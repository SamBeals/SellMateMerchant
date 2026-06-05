## ADDED Requirements

### Requirement: System appearance adaptation
The app SHALL render using the device's current light or dark color scheme without requiring an in-app theme setting.

#### Scenario: Device uses dark appearance
- **WHEN** the device appearance is dark
- **THEN** the app renders all tab, navigation, list, form, loading, empty, and modal surfaces with dark-compatible system or adaptive colors

#### Scenario: Device uses light appearance
- **WHEN** the device appearance is light
- **THEN** the app preserves the existing light appearance behavior with readable system or adaptive colors

### Requirement: Core merchant screen readability
The app SHALL keep primary text, secondary text, controls, editable fields, dividers, selected states, and action buttons readable across dashboard, inventory, products, and sales workflows in both light and dark appearances.

#### Scenario: Dashboard is viewed in dark appearance
- **WHEN** a merchant opens the Dashboard tab while the device appearance is dark
- **THEN** machine details, daily sales metrics, order counts, item counts, empty states, and recent sales rows remain legible against their backgrounds

#### Scenario: Inventory is viewed in dark appearance
- **WHEN** a merchant opens the Inventory tab while the device appearance is dark
- **THEN** slot labels, product assignment text, quantity controls, enable toggles, save/discard actions, loading state, error state, and empty state remain legible and visually distinct

#### Scenario: Products are edited in dark appearance
- **WHEN** a merchant opens the Products tab while the device appearance is dark
- **THEN** product names, price fields, image URL fields, active toggles, add-product form fields, and toolbar actions remain legible and usable

#### Scenario: Sales are viewed in dark appearance
- **WHEN** a merchant opens the Sales tab while the device appearance is dark
- **THEN** totals, order identifiers, timestamps, payment rows, item rows, loading state, error state, and empty state remain legible and visually distinct

### Requirement: Status and brand color contrast
The app SHALL use semantic or adaptive colors for brand tint and status treatments so interactive controls and error/warning messages maintain sufficient contrast in both light and dark appearances.

#### Scenario: Error message is displayed in dark appearance
- **WHEN** an error message is visible while the device appearance is dark
- **THEN** the error icon, message text, and background treatment remain readable without appearing as a light-mode artifact

#### Scenario: Branded action is displayed in dark appearance
- **WHEN** a tinted or accent-colored control is visible while the device appearance is dark
- **THEN** the control remains visually discoverable and its label or icon remains readable

### Requirement: Appearance verification coverage
The app SHALL include repeatable verification for representative light and dark rendering states before the change is considered complete.

#### Scenario: Dark-mode verification is run
- **WHEN** the dark-mode verification suite or documented checks are run
- **THEN** at least one representative state for each core merchant tab is checked in dark appearance

#### Scenario: Light-mode verification is run
- **WHEN** the light-mode verification suite or documented checks are run
- **THEN** representative states continue to pass in light appearance
