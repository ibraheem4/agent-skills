---
name: ui-component-lookup
description: Quick lookup for a specific UI component pattern including anatomy, props, and accessibility. Use when building a Table, Modal, Button, or any common component and need the reference card.
---

# UI Component Lookup

## Overview

Fast reference lookup for a specific component pattern. Returns the component's anatomy, key props, accessibility requirements, and anti-patterns from the frontend-ui-engineering reference library.

Use this for quick answers ("how should a Modal work?") instead of reading the full frontend-ui-engineering skill.

## When to Use

- Building a specific component and need the pattern reference
- Checking accessibility requirements for a component type
- Verifying you're not using an anti-pattern

## Core Process

### 1. Search the Component Reference

Look up the requested component in the reference files:

- **Component patterns**: `frontend-ui-engineering/references/components.md`
- **Accessibility**: `frontend-ui-engineering/references/accessibility.md`
- **Responsive behavior**: `frontend-ui-engineering/references/responsive.md`
- **Data visualization**: `frontend-ui-engineering/references/data-viz.md`

Also check if the project has its own design system documentation (e.g., `design-system.md`, `.claude/skills/*/references/*-surfaces.md`).

### 2. Return the Reference Card

Provide a concise, actionable card:

```
## [Component Name]

**Use when**: When to choose this component over alternatives
**Anatomy**: Required parts / composition structure
**Key props**: Essential configuration
**Accessibility**: ARIA roles, keyboard nav, screen reader requirements
**Anti-patterns**: Common mistakes to avoid
**Project note**: Project-specific conventions (if found)
```

### 3. Add Context

If the project has existing instances of this component, note the patterns they follow so the new instance is consistent.

## Available Components

The reference library covers: Alert, Avatar, Badge, Breadcrumb, Button, Card, Checkbox, Chip/Tag, Combobox, Data Table, Date Picker, Dialog/Modal, Dropdown Menu, Empty State, Form Field, Icon Button, List, Navigation, Pagination, Popover, Progress, Radio Group, Select, Sidebar, Skeleton, Slider, Snackbar/Toast, Stepper, Switch/Toggle, Tabs, Text Input, Textarea, Toolbar, Tooltip, Tree View.

## Verification

- [ ] Component pattern matches the reference anatomy
- [ ] All accessibility requirements from the reference are implemented
- [ ] No anti-patterns from the reference are present
- [ ] Component is consistent with existing instances in the project
