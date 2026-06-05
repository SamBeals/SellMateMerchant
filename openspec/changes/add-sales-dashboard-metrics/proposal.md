## Why

Merchants need a quick way to understand revenue performance beyond the current day. Showing daily, weekly, and monthly revenue on the dashboard makes the app more useful for monitoring business health without drilling into raw sales rows.

## What Changes

- Add dashboard revenue metrics for today, current week, and current month.
- Calculate metrics from sales data using the merchant machine's sale timestamps and total amounts.
- Update sales loading so the dashboard has enough recent sales history to compute weekly and monthly totals.
- Keep existing dashboard daily order count, items sold, and recent sales behavior available.
- Add verification for date-boundary calculations and dashboard rendering of the new metric set.

## Capabilities

### New Capabilities

- `sales-dashboard-metrics`: Defines revenue rollups for daily, weekly, and monthly periods on the merchant dashboard.

### Modified Capabilities

- None.

## Impact

- Affected app code includes `SellMateMerchant/Views/DashboardView.swift`, `SellMateMerchant/ViewModels/DashboardViewModel.swift`, `SellMateMerchant/ViewModels/SalesViewModel.swift`, and the sales fetching path in `SellMateMerchant/Services/InventoryService.swift`.
- The existing `fetchSales(machineId:since:)` service can likely be reused by requesting sales since the start of the current month.
- Tests should cover period boundary behavior, empty sales, and mixed sales across today, current week, current month, and older periods.
- No Firebase schema changes are expected if existing sale documents already include `timestamp` and `totalCents`.
