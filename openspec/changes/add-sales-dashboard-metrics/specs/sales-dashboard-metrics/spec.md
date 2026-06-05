## ADDED Requirements

### Requirement: Dashboard displays revenue periods
The dashboard SHALL display revenue totals for today, the current calendar week, and the current calendar month.

#### Scenario: Sales exist in all periods
- **WHEN** the merchant opens the Dashboard tab and sales exist today, earlier in the current week, and earlier in the current month
- **THEN** the dashboard shows separate daily, weekly, and monthly revenue totals

#### Scenario: No sales exist
- **WHEN** the merchant opens the Dashboard tab and no sales are available for the current month
- **THEN** daily, weekly, and monthly revenue totals display as zero-value currency amounts

### Requirement: Revenue period boundaries
Revenue totals SHALL include only sales whose timestamps fall within each displayed period using the user's current calendar and timezone.

#### Scenario: Daily total excludes prior-day sales
- **WHEN** a sale occurred before the start of the current day
- **THEN** that sale is excluded from daily revenue

#### Scenario: Weekly total excludes prior-week sales
- **WHEN** a sale occurred before the start of the current calendar week
- **THEN** that sale is excluded from weekly revenue

#### Scenario: Monthly total excludes prior-month sales
- **WHEN** a sale occurred before the start of the current calendar month
- **THEN** that sale is excluded from monthly revenue

### Requirement: Revenue calculations use sale totals
Dashboard revenue metrics SHALL sum each included sale's `totalCents` value and format the result as currency for display.

#### Scenario: Multiple sales are included
- **WHEN** multiple sales fall within a displayed period
- **THEN** the displayed revenue equals the sum of those sales' `totalCents` values formatted as currency

#### Scenario: Sale contains multiple items
- **WHEN** a sale contains multiple line items and a `totalCents` value
- **THEN** dashboard revenue uses the sale's `totalCents` value rather than recalculating from line items

### Requirement: Existing dashboard sales context remains available
The dashboard SHALL preserve the existing sales context while adding period revenue metrics.

#### Scenario: Today sales summary remains visible
- **WHEN** the dashboard displays revenue metrics
- **THEN** today's order count and items sold remain visible

#### Scenario: Recent sales remain visible
- **WHEN** loaded sales are available
- **THEN** the dashboard continues to display recent sales rows
