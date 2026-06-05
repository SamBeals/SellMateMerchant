## Why

SellMateMerchant currently relies mostly on default SwiftUI styling, but it has not defined or verified a complete dark-mode experience across the merchant workflows. Adding explicit dark-mode support improves comfort in low-light environments and ensures inventory, product, dashboard, and sales screens remain readable when the device uses a dark appearance.

## What Changes

- Support the system dark appearance throughout the app without requiring users to change an in-app setting.
- Audit all merchant screens for readable text, backgrounds, form fields, alerts, loading states, empty states, lists, tab/navigation bars, and controls in both light and dark appearances.
- Replace hard-coded or light-biased colors with semantic SwiftUI colors, adaptive asset colors, or color styles that preserve contrast in both appearances.
- Add verification coverage for representative light and dark rendering states, including loading, error, empty, and populated views where practical.

## Capabilities

### New Capabilities

- `dark-mode`: Defines the requirement that the app adapts to the device color scheme and keeps core merchant workflows legible and visually coherent in dark appearance.

### Modified Capabilities

- None.

## Impact

- Affected UI files include `SellMateMerchant/ContentView.swift`, the views under `SellMateMerchant/Views/`, `SellMateMerchant/SellMateMerchantApp.swift`, and any app-target sales view source used by the tab bar.
- Asset catalog color definitions, especially `AccentColor`, may need light and dark variants.
- Tests may include SwiftUI previews, unit-level view state checks where available, and UI tests or screenshot-oriented checks for light and dark appearances.
- No backend API or Firebase data model changes are expected.
