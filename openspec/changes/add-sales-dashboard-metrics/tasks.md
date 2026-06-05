## 1. Sales Data Range

- [x] 1.1 Update sales loading to fetch sales from the start of the current month instead of only the start of today.
- [x] 1.2 Keep existing loading, error, refresh, and recent-sales behavior working after the wider fetch window.

## 2. Metrics Calculation

- [x] 2.1 Add testable revenue metric properties for today, current calendar week, and current calendar month.
- [x] 2.2 Calculate metrics from `Sale.timestamp` and `Sale.totalCents` using `Calendar.current`.
- [x] 2.3 Preserve today's order count and items sold calculations using only today's sales.

## 3. Dashboard UI

- [x] 3.1 Update the Dashboard tab to show daily, weekly, and monthly revenue as distinct dashboard metrics.
- [x] 3.2 Keep existing machine, today summary, empty state, and recent-sales sections available.
- [x] 3.3 Format all revenue metrics as currency without floating-point rounding drift.

## 4. Verification

- [x] 4.1 Add unit tests for sales on today, earlier this week, earlier this month, and before the current month.
- [x] 4.2 Add or update dashboard preview/test fixtures for the expanded metric display.
- [x] 4.3 Run the relevant Xcode build/test command and document any environment-limited checks.
- [x] 4.4 Re-run OpenSpec status for `add-sales-dashboard-metrics` and confirm the change is ready for implementation completion/archive.
