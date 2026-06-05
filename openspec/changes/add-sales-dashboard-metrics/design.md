## Context

SellMateMerchant is a SwiftUI iOS app with a tab-based dashboard and sales workflow. The dashboard currently shows today's revenue, order count, items sold, and recent sales by reading values from `SalesViewModel`. `SalesViewModel.load()` currently fetches sales since the start of the current day, which is sufficient for daily totals but not enough for weekly or monthly revenue.

Sales data already includes `timestamp` and `totalCents`, and the existing service query can fetch sales since a supplied date. The implementation can therefore compute dashboard revenue rollups locally if the loaded sales range covers the start of the current month.

## Goals / Non-Goals

**Goals:**

- Show daily, weekly, and monthly revenue metrics on the Dashboard tab.
- Compute revenue using sale timestamps and `totalCents` from loaded sales.
- Use the user's current calendar/timezone for period boundaries.
- Keep current order count, items sold, empty state, and recent-sales behavior intact.
- Add focused tests for period calculations and dashboard metric display.

**Non-Goals:**

- Add charts, trend lines, forecasting, exports, or custom date range pickers.
- Add multi-machine aggregation beyond the app's currently selected/first machine behavior.
- Change the Firebase sales document schema.
- Add server-side aggregation or cloud functions.

## Decisions

1. Fetch sales from the start of the current month for dashboard metrics.

   Monthly revenue is the widest requested range, so loading sales since month start gives enough data for monthly, weekly, and daily totals. This keeps the service API simple and reuses the existing `fetchSales(machineId:since:)` shape.

   Alternative considered: issue separate daily, weekly, and monthly queries. That reduces client-side filtering work but adds repeated network requests, duplicate query handling, and potential inconsistency if queries complete at different times.

2. Centralize period calculations in the sales/dashboard view-model layer.

   Revenue totals should be derived from `Sale.timestamp` and `Sale.totalCents` using `Calendar.current`. The view should format and display already-computed values rather than duplicating filtering logic.

   Alternative considered: compute totals directly in `DashboardView`. That is quick, but it makes date boundary behavior harder to test and easier to regress during UI changes.

3. Treat "week" as the current calendar week.

   Weekly revenue should include sales whose timestamps fall within `Calendar.current.dateInterval(of: .weekOfYear, for: now)`. This respects the device/user calendar settings for week starts.

   Alternative considered: a rolling seven-day window. That can be useful analytically, but "daily, weekly, monthly" dashboard metrics usually read as calendar periods and align better with month-to-date semantics.

4. Store and display revenue in cents until formatting.

   Totals should remain integer cents during computation and convert to currency strings only at the UI boundary. This avoids floating-point rounding issues in revenue calculations.

   Alternative considered: convert each sale to `Double` dollars before summing. That is simpler to read but less precise.

## Risks / Trade-offs

- Fetching month-to-date sales may grow larger over time -> Limit scope to the currently selected machine and revisit server aggregation if monthly sales volume becomes high.
- Calendar week boundaries can differ by locale -> Use `Calendar.current` and add tests that inject or fix calendar behavior where possible.
- Existing dashboard depends directly on `app.salesViewModel` -> Keep changes scoped, but prefer moving metric derivation behind view-model properties before adding more UI.
- Dark-mode change is active in the same worktree -> Avoid reworking appearance decisions and keep the metrics UI compatible with the semantic SwiftUI styles introduced there.
