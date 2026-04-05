---
name: frontend-ui-engineering
description: Use when building UI components, pages, or interactive features. Composition over configuration, accessibility by default, no generic AI aesthetic.
---

# Frontend UI Engineering

## Overview

Agents produce UI that "works" but looks generic — default spacing, no hierarchy, poor accessibility, inconsistent patterns. This skill enforces component architecture, accessibility as a non-negotiable, and design system adherence. The goal is UI that a designer wouldn't need to redo.

## When to Use

- Building any user-facing component or page
- Modifying existing UI components
- Adding interactivity (forms, modals, navigation)
- Reviewing frontend code

**Do not use** for CLI tools, APIs, or backend-only code.

## Reference Library

This skill includes detailed reference files for deep-dive patterns:
- **[references/components.md](references/components.md)** — Anatomy, props, and anti-patterns for 20+ components (Table, Modal, Button, Tabs, Toast, etc.)
- **[references/accessibility.md](references/accessibility.md)** — ARIA patterns, keyboard navigation, screen reader requirements by component
- **[references/responsive.md](references/responsive.md)** — Breakpoint strategies, container queries, mobile-first patterns
- **[references/data-viz.md](references/data-viz.md)** — Chart selection, dashboard layout, data table patterns

Use the **[ui-component-lookup](../ui-component-lookup/)** skill for quick access to a specific component's reference card.

## Core Process

### 1. Read the Design System First

Before writing any component, check if the project has:
- A component library (shadcn/ui, MUI, Radix, etc.)
- Design tokens (colors, spacing, typography)
- Existing components that do something similar

```
Bad:  Write a custom <Button> from scratch
Good: Import the existing Button from the design system
```

If no design system exists, follow the conventions of existing components in the codebase.

### 2. Component Architecture

**Composition over configuration.** Build small, focused components that compose together — not god-components with 20 props.

```tsx
// Bad: monolithic component with flags
<DataDisplay
  showHeader={true}
  showFooter={false}
  variant="card"
  withBorder={true}
  headerActions={[...]}
  footerText="..."
/>

// Good: composable components
<Card>
  <Card.Header actions={[...]}>Title</Card.Header>
  <Card.Body>{content}</Card.Body>
</Card>
```

Rules:
- **Single responsibility** — each component does one thing
- **Props over internal state** — push state up, keep components pure where possible
- **Separate data from presentation** — container components fetch data, presentational components render it
- **Follow existing patterns** — if the codebase uses hooks, use hooks. If it uses render props, use render props

### 3. Accessibility (Non-Negotiable)

Every interactive element must be accessible. This is not optional.

| Element | Requirements |
|---------|-------------|
| **Buttons** | Descriptive text (not just an icon). `aria-label` if icon-only |
| **Forms** | Every input has a `<label>`. Error messages linked with `aria-describedby` |
| **Images** | `alt` text on every `<img>`. Decorative images get `alt=""` |
| **Modals** | Focus trap. Escape to close. `role="dialog"` + `aria-labelledby` |
| **Lists** | Semantic `<ul>/<ol>/<li>`. Not `<div>` with visual bullets |
| **Navigation** | `<nav>` landmark. `aria-current="page"` on active link |
| **Loading** | `aria-live="polite"` for status updates. Don't remove content abruptly |
| **Color** | 4.5:1 contrast ratio for text. Don't rely on color alone for meaning |

Keyboard navigation:
- All interactive elements reachable with Tab
- Logical tab order (follows visual order)
- Enter/Space activates buttons
- Arrow keys navigate within groups (tabs, menus, radio groups)
- Escape closes overlays

### 4. Visual Hierarchy and Spacing

Don't use arbitrary pixel values. Use a spacing scale:

```css
/* Spacing scale (example: 4px base) */
--space-1: 4px;   /* tight — between related items */
--space-2: 8px;   /* default — between elements */
--space-3: 12px;  /* comfortable — between groups */
--space-4: 16px;  /* section — between sections */
--space-6: 24px;  /* generous — page-level spacing */
--space-8: 32px;  /* spacious — major sections */
```

Hierarchy rules:
- **One primary action per view** — one prominent button, not three
- **Group related items** — tighter spacing within groups, larger spacing between
- **Consistent alignment** — left-align by default, don't center everything
- **Whitespace is a feature** — don't fill every pixel

### 5. Responsive Design

Design for mobile first, enhance for desktop:

```css
/* Mobile first */
.container { padding: var(--space-4); }

/* Tablet */
@media (min-width: 768px) {
  .container { padding: var(--space-6); max-width: 720px; }
}

/* Desktop */
@media (min-width: 1024px) {
  .container { padding: var(--space-8); max-width: 960px; }
}
```

- Touch targets: minimum 44×44px
- Readable text: 16px minimum on mobile
- Don't hide critical content behind "desktop only" layouts

### 6. No AI Aesthetic

Agents tend to produce UI with these tells — avoid all of them:
- Excessive gradients and rounded corners
- Card-based layouts for everything
- Generic placeholder illustrations
- "Dashboard" layout when a simple list would do
- Purple/blue gradient hero sections
- Overly animated transitions

Match the existing visual language of the project. If there's no established style, default to clean and minimal — less decoration, more clarity.

## Common Rationalizations

| Excuse | Why It's Wrong |
|--------|---------------|
| "Accessibility is a nice-to-have" | It's a legal requirement in many jurisdictions and an ethical baseline everywhere else |
| "We'll add keyboard nav later" | You won't. And screen reader users can't use your app until you do |
| "The design system doesn't have this component" | Compose from existing primitives before creating new ones. Most "new" components are combinations of existing ones |
| "It looks fine on my screen" | Test at 320px wide and 200% zoom. "Looks fine" isn't responsive |
| "The user will figure out the UI" | If they have to figure it out, it's not good UI. Labels, hierarchy, and affordances should make it obvious |

## Red Flags

- Interactive elements with no keyboard support
- Images without alt text
- Forms without labels
- Custom components that duplicate existing design system components
- Hardcoded pixel values instead of spacing tokens
- No responsive breakpoints
- All text the same size and weight (no hierarchy)
- `div` used for everything (no semantic HTML)

## Verification

- [ ] All interactive elements are keyboard-accessible
- [ ] All form inputs have associated labels
- [ ] All images have appropriate alt text
- [ ] Component follows existing design system patterns (or project conventions)
- [ ] Layout is responsive (tested at 320px, 768px, 1024px)
- [ ] Color contrast meets WCAG AA (4.5:1 for text)
- [ ] No new components duplicate existing design system functionality
