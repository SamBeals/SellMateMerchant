## Context

SellMateMerchant is a SwiftUI iOS app with tab-based merchant workflows for dashboard metrics, machine inventory, product management, and sales history. Most screens are built with system controls such as `List`, `Form`, `NavigationStack`, `TabView`, `Toggle`, `TextField`, `ProgressView`, and `ContentUnavailableView`, which can adapt to light and dark appearance when semantic colors are used.

The current codebase contains a few explicit color choices, including translucent red error backgrounds and an accent color asset without separate light/dark values. The implementation should preserve the system-driven appearance model and avoid introducing a custom theme setting unless future requirements call for one.

## Goals / Non-Goals

**Goals:**

- Make the app adapt automatically to the device light or dark color scheme.
- Keep all core merchant workflows readable and visually coherent in dark appearance.
- Use semantic SwiftUI colors and adaptive asset catalog colors for durable contrast.
- Verify representative screens and states in both color schemes.

**Non-Goals:**

- Add an in-app light/dark/manual theme picker.
- Redesign navigation, layout, typography, or information architecture.
- Change Firebase data models, service APIs, or merchant business logic.
- Introduce a third-party design system or theming dependency.

## Decisions

1. Use the system color scheme as the source of truth.

   SwiftUI already propagates `colorScheme` from iOS to app views. The implementation should not force `.preferredColorScheme` at the app root. This preserves user accessibility and device preferences while minimizing state management.

   Alternative considered: add a persisted in-app theme override. That creates settings, storage, conflict rules, and test matrix expansion without being required for the requested dark-mode support.

2. Prefer semantic SwiftUI styling over hard-coded colors.

   UI elements should use system materials and semantic colors such as primary, secondary, background, grouped backgrounds, tint, and role-aware button styles. Hard-coded light-biased colors should be replaced or wrapped in adaptive color assets.

   Alternative considered: define a full custom color token layer. The app is small and mostly native SwiftUI, so a full token system would add abstraction before there is enough complexity to justify it.

3. Make accent and status colors adaptive where they appear outside default controls.

   `AccentColor` should define usable light and dark variants if the app depends on brand tint. Error or warning treatments should keep sufficient contrast in dark mode by pairing semantic foreground styles with adaptive background opacity or asset colors.

   Alternative considered: rely entirely on current default accent behavior. That leaves branded controls and custom status surfaces under-specified and harder to verify.

4. Verify by rendering representative states in both appearances.

   Implementation should add or update previews/tests for populated, empty, loading, error, and editing states where practical. UI tests can launch with light and dark appearance arguments or use screenshot-oriented checks if the project already supports them.

   Alternative considered: manual simulator-only QA. Manual checks are useful, but repeatable coverage reduces the risk of regressions when screens change.

## Risks / Trade-offs

- Hard-coded colors remain in less obvious modifiers -> Audit views with searches for `Color`, `foreground`, `background`, `tint`, and asset references before finishing implementation.
- Sales screen source appears outside the main app folder -> Confirm target membership or move/duplicate the app-owned sales view before relying on dark-mode coverage for that tab.
- Screenshot/UI testing can be brittle across iOS versions -> Prefer semantic assertions and targeted preview/test fixtures, using screenshots only for high-value visual checks.
- Adaptive colors may shift perceived brand tone between appearances -> Choose dark variants that preserve contrast first and brand exactness second.
