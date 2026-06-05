## Appearance Audit

- App-target SwiftUI screens are under `SellMateMerchant/ContentView.swift`, `SellMateMerchant/SellMateMerchantApp.swift`, and `SellMateMerchant/Views/`.
- Sales UI source has been moved from `SellMateMerchantUITests/` into the app target under `SellMateMerchant/Views/SalesView.swift` and `SellMateMerchant/ViewModels/SalesViewModel.swift`.
- Sales domain models now live with the app domain models in `SellMateMerchant/Models/DomainModels.swift`.
- Custom appearance usage after implementation is limited to adaptive/system-safe styling: `StatusBanner`, semantic foreground styles, `.thinMaterial`, `.background`, `.secondary`, and the adaptive `AccentColor` asset.
- The app root does not force `.preferredColorScheme` and does not add an in-app theme override.

## Dark-Appearance States To Check

- Dashboard: machine details, today totals, empty sales state, recent sales rows.
- Inventory: loading, error banner, empty inventory, populated slot rows, quantity controls, toggles, save/discard toolbar actions.
- Products: error banner, populated editable list, text fields, toggles, add-product sheet, save/discard/add toolbar actions.
- Sales: loading, error, empty sales state, today totals, recent sales rows, secondary item metadata.

## Automated Verification

- `AppearanceRenderingTests` renders representative dashboard, inventory, products, and sales views in dark appearance.
- `AppearanceRenderingTests` renders the main tab container in light appearance to guard the baseline system appearance.
- `PreviewFixtures` provides light and dark preview fixtures backed by deterministic sample merchant data.

## Verification Results

- `xcodebuild build -project SellMateMerchant.xcodeproj -scheme SellMateMerchant -destination generic/platform=iOS -derivedDataPath .build/DerivedData CODE_SIGNING_ALLOWED=NO` succeeds.
- `xcodebuild test ...` cannot complete in this environment because the available provisioning profile does not include the selected Mac destination.
- `xcodebuild test ... CODE_SIGNING_ALLOWED=NO` builds the test bundle but cannot install the unsigned app on the selected destination.

## Manual Verification

- Run the app in Simulator or on device with both light and dark system appearances.
- Inspect editable text fields and toolbar buttons in Products, quantity controls and toggles in Inventory, and empty/loading/error states when service data is unavailable.
