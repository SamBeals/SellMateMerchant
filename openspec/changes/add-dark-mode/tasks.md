## 1. Audit Current Appearance Usage

- [x] 1.1 Identify all app-target SwiftUI view files and confirm the Sales tab source is included in the app target.
- [x] 1.2 Search views and assets for hard-coded colors, foreground/background modifiers, tint usage, and appearance overrides.
- [x] 1.3 List each screen state that must be checked in dark appearance: dashboard, inventory loading/error/empty/populated, products list/edit/add, and sales loading/error/empty/populated.

## 2. Implement Adaptive Styling

- [x] 2.1 Replace light-biased custom colors with semantic SwiftUI colors, adaptive asset colors, or role-aware styles.
- [x] 2.2 Add light and dark variants for accent or status colors in the asset catalog where app-specific colors are required.
- [x] 2.3 Update error, loading, empty, list, form, toolbar, tab, and control treatments so they remain legible in dark appearance.
- [x] 2.4 Preserve system-driven appearance by avoiding a forced root `.preferredColorScheme` or a new in-app theme setting.

## 3. Add Verification Coverage

- [x] 3.1 Add or update SwiftUI previews/test fixtures for representative light and dark states across the core merchant tabs.
- [x] 3.2 Add UI or unit-level checks that launch or render representative screens in dark appearance.
- [x] 3.3 Run the relevant Xcode test suite and document any checks that must remain manual.

## 4. Final Validation

- [ ] 4.1 Verify dashboard, inventory, products, and sales screens in both light and dark appearances.
- [ ] 4.2 Confirm no contrast or legibility regressions remain in editable fields, toolbar buttons, toggles, empty states, loading states, or error messages.
- [ ] 4.3 Re-run OpenSpec validation/status for `add-dark-mode` and confirm the change is ready to apply or archive after implementation.
