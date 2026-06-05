## Verification Results

- `xcodebuild build -quiet -project SellMateMerchant.xcodeproj -scheme SellMateMerchant -destination generic/platform=iOS -derivedDataPath .build/DerivedData CODE_SIGNING_ALLOWED=NO` succeeds.
- `xcodebuild build-for-testing -quiet -project SellMateMerchant.xcodeproj -scheme SellMateMerchant -destination generic/platform=iOS -derivedDataPath .build/DerivedData CODE_SIGNING_ALLOWED=NO` succeeds.
- Full `xcodebuild test` execution still requires a signed/runnable simulator or device destination in this environment.

## Coverage Added

- `SalesDashboardMetricsTests` covers daily, weekly, and monthly revenue boundaries.
- `SalesDashboardMetricsTests` verifies revenue uses each sale's `totalCents` rather than summing line items.
- `SalesDashboardMetricsTests` verifies month-start calculation for the sales fetch window.
- Dashboard previews and rendering fixtures now include sales from today, the current week, and the current month.
