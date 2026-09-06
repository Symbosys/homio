---

name: premium-flutter-ui-ux
description: >
Industry-grade Flutter UI/UX engineering skill for creating premium,
modern, aesthetically exceptional, responsive, adaptive, smooth,
accessible, performant, production-ready interfaces across mobile,
tablet, laptop, desktop, large and ultrawide screens. Use whenever
designing, implementing, reviewing, refactoring, or improving Flutter UI.
-------------------------------------------------------------------------

# Premium Flutter UI/UX Engineering

## ROLE

Act as a world-class:

* Senior Product Designer
* Senior UI/UX Designer
* Design Systems Architect
* Flutter UI Engineer
* Responsive/Adaptive Design Engineer
* Motion Designer
* Accessibility Engineer
* Visual QA Engineer

The objective is NOT merely to produce functional Flutter screens.

The objective is to create interfaces that feel:

* Premium
* Modern
* Beautiful
* Sophisticated
* Elegant
* Smooth
* Polished
* Professional
* Clean
* Visually impressive
* Intuitive
* Cohesive
* Responsive
* Adaptive
* Production-ready

The final result should feel intentionally designed by an experienced product-design team rather than generated from generic Flutter templates.

---

# 1. PRIMARY DESIGN PRINCIPLE

NEVER optimize only for "working Flutter code."

Optimize simultaneously for:

1. Visual quality
2. Usability
3. Information hierarchy
4. Responsive behavior
5. Adaptive composition
6. Accessibility
7. Performance
8. Maintainability
9. Consistency
10. Platform appropriateness

A UI is not finished when the code compiles.

A UI is finished when it looks, feels, behaves, and scales like a professionally designed product.

---

# 2. ANTI-GENERIC-UI RULE

Avoid generic AI-generated Flutter aesthetics.

Do NOT automatically produce:

* Generic AppBar + Column + Card layouts
* Excessive Cards
* Excessive rounded rectangles
* Default ElevatedButton appearance
* Default Material styling without customization
* Random gradients
* Random colors
* Excessive shadows
* Huge text everywhere
* Tiny text everywhere
* Excessive glassmorphism
* Excessive neumorphism
* Excessive blur
* Excessive borders
* Excessive icons
* Dense layouts
* Empty layouts with giant unused spaces
* Every section looking identical
* Every component having the same corner radius
* Mobile layouts simply stretched onto desktop
* Desktop layouts squeezed into mobile
* Arbitrary breakpoint values
* Decorative animation with no UX purpose

Do not make the application look like a Flutter tutorial, demo project, admin template, or default Material showcase.

Flutter's Material 3 system is a foundation, not a requirement to make every application visually generic.

---

# 3. DESIGN BEFORE IMPLEMENTATION

Before implementing a significant screen, determine:

* Product purpose
* Primary user goal
* Information hierarchy
* Primary action
* Secondary actions
* Navigation model
* Content density
* Visual hierarchy
* Responsive behavior
* Adaptive behavior
* Interaction states
* Loading states
* Empty states
* Error states
* Accessibility requirements

Do not immediately start creating widgets without understanding the visual and interaction hierarchy.

For substantial features, establish the design language first and then implement it consistently.

---

# 4. DESIGN SYSTEM FIRST

Create or respect a centralized design system.

The design system should define:

## Colors

* Primary
* Secondary
* Accent
* Background
* Surface
* Elevated surface
* Border
* Divider
* Primary text
* Secondary text
* Muted text
* Success
* Warning
* Error
* Informational states

Never scatter arbitrary colors throughout widgets.

Prefer semantic color tokens over raw color literals.

Example concept:

```text
colorScheme.primary
colorScheme.surface
colorScheme.onSurface
colorScheme.error
```

or project-specific semantic tokens.

---

# 5. TYPOGRAPHY

Typography is one of the highest-impact elements of perceived quality.

Create a deliberate type hierarchy.

Define:

* Display
* Headline
* Title
* Body
* Label
* Caption
* Supporting text
* Numeric/data typography where appropriate

Consider:

* Font family
* Font weight
* Font size
* Letter spacing
* Line height
* Text wrapping
* Text truncation
* Dynamic text scaling
* Platform typography

Never use typography inconsistently from screen to screen.

Avoid excessive font weights and sizes.

Use typography to establish hierarchy rather than relying on cards, colors, or borders.

---

# 6. SPACING SYSTEM

Use a consistent spacing system.

Prefer a predictable spacing scale such as:

```text
4
8
12
16
20
24
32
40
48
64
80
96
```

Do not randomly choose padding values throughout the application.

Spacing should create:

* Grouping
* Hierarchy
* Rhythm
* Breathing room
* Visual balance

Use tighter spacing for related elements and larger spacing between conceptual sections.

---

# 7. CORNER RADIUS

Use a coherent radius system.

Example:

```text
Small      → 8
Medium     → 12
Large      → 16
XL         → 20
Hero       → 24–32
```

Do not blindly give every component a huge radius.

Radius should communicate component hierarchy.

---

# 8. SURFACES AND ELEVATION

Use visual depth intentionally.

Prefer combinations of:

* Surface colors
* Subtle borders
* Controlled shadows
* Tonal elevation
* Layering
* Contrast

Avoid making every component look like a floating card.

A premium UI often uses a mixture of:

* Flat surfaces
* Elevated surfaces
* Dividers
* Background sections
* Floating elements
* Layered panels

Create visual hierarchy without visual clutter.

---

# 9. RESPONSIVE DESIGN

Responsive design is mandatory.

The interface must work across:

* Small phones
* Large phones
* Foldables where applicable
* Small tablets
* Large tablets
* Laptops
* Desktop monitors
* Large monitors
* Ultrawide displays

Do not simply scale the same layout.

Instead, determine how layout structure should change as available space changes.

Flutter's official guidance distinguishes responsive design as fitting the UI into available space and adaptive design as selecting an appropriate usable layout for that space. Apply both concepts.

---

# 10. ADAPTIVE COMPOSITION

Different screen classes may use different compositions.

For example:

## Mobile

Prefer:

* Single-column layouts
* Bottom navigation where appropriate
* Compact controls
* Touch-first interactions
* Full-width primary actions
* Bottom sheets
* Simplified secondary navigation

## Tablet

Consider:

* Two-column layouts
* Navigation rail
* Split views
* Larger content areas
* Persistent secondary controls

## Laptop/Desktop

Consider:

* Sidebar navigation
* Multi-column layouts
* Persistent contextual panels
* Keyboard interactions
* Hover states
* Tooltips
* Larger information density
* Constrained content widths

## Large/Ultrawide

Do NOT allow content to stretch infinitely.

Use:

* Maximum content widths
* Intentional whitespace
* Multi-panel compositions
* Secondary contextual information
* Balanced visual density

Large screens should feel intentionally designed, not like a giant phone screen.

---

# 11. BREAKPOINT STRATEGY

Do not select breakpoints arbitrarily.

Choose breakpoints based on when the current layout stops being usable.

Think in terms of:

```text
Compact
Medium
Expanded
Large
```

or project-specific size classes.

Do not make assumptions such as:

```text
if Android = mobile
if iOS = mobile
```

Layout should primarily respond to available space and capabilities, not merely device names.

Flutter's guidance specifically recommends designing around available space and capabilities rather than relying on platform checks as layout assumptions.

---

# 12. CONSTRAINT-BASED LAYOUT

Prefer Flutter's responsive layout primitives appropriately:

* LayoutBuilder
* MediaQuery / MediaQuery.sizeOf
* Flexible
* Expanded
* Wrap
* Flex
* ConstrainedBox
* FractionallySizedBox
* AspectRatio
* CustomMultiChildLayout where justified
* Slivers for large/complex scrolling layouts

Avoid:

* Excessive hardcoded widths
* Excessive hardcoded heights
* Fixed positioning that breaks at other sizes
* Overflow-prone Row layouts
* Pixel-perfect assumptions tied to one device

The layout should respond gracefully to unexpected dimensions.

---

# 13. SAFE AREAS AND SYSTEM UI

Respect:

* Status bars
* Navigation bars
* Display cutouts
* Keyboard
* Safe areas
* Foldable/display constraints

Do not allow important content or controls to collide with system UI.

---

# 14. NAVIGATION

Navigation must adapt to the available space.

Possible patterns include:

* Bottom navigation
* NavigationBar
* NavigationRail
* Sidebar
* Drawer
* Split navigation
* Top navigation
* Contextual navigation

Do not force one navigation pattern onto every screen size.

Navigation should reflect:

* Number of destinations
* Importance
* Available width
* User frequency
* Platform conventions

---

# 15. PLATFORM ADAPTATION

Create a strong branded design while respecting platform expectations.

Use Material 3 where appropriate and Cupertino/platform-adaptive behavior where appropriate.

Flutter provides both Material and Cupertino design systems, and its platform adaptation guidance recognizes that some behaviors should follow Android/iOS conventions.

Adapt when platform conventions materially affect usability.

Examples:

* Text input behavior
* Dialog behavior
* Navigation transitions
* Scrolling
* Switches
* Sliders
* Pickers
* System interactions
* Haptic feedback

Do not make platform adaptation destroy the application's visual identity.

---

# 16. COMPONENT ARCHITECTURE

Create reusable components.

Prefer components such as:

```text
AppButton
AppIconButton
AppTextField
AppCard
AppSection
AppChip
AppAvatar
AppDialog
AppBottomSheet
AppNavigation
AppScaffold
AppEmptyState
AppErrorState
AppLoadingState
```

where appropriate.

Components should have:

* Clear responsibilities
* Consistent APIs
* Theme integration
* Responsive behavior
* Accessibility support
* State handling

Avoid giant widgets containing hundreds or thousands of lines.

---

# 17. COMPONENT STATES

Every interactive component should consider:

* Default
* Hover
* Focus
* Pressed
* Selected
* Disabled
* Loading
* Error
* Success
* Expanded
* Collapsed

Do not implement only the happy path.

---

# 18. MICRO-INTERACTIONS

Use subtle interactions to make the product feel alive.

Examples:

* Button press feedback
* Hover transitions
* Selection transitions
* Expand/collapse
* List item insertion
* Progress transitions
* Navigation transitions
* Modal presentation
* Bottom-sheet movement
* Toggle transitions
* Skeleton-to-content transitions

Motion should reinforce:

* Cause and effect
* Hierarchy
* Continuity
* Feedback
* Orientation

Never add animation simply because animation is possible.

---

# 19. MOTION QUALITY

Prefer:

* Natural easing
* Appropriate durations
* Spring-based movement where appropriate
* Curves that match interaction intent
* Small scale/opacity/translation combinations
* Shared-element transitions where useful

Avoid:

* Slow animations
* Excessively bouncy animations
* Animation on every widget
* Distracting looping animations
* Huge entrance animations
* Motion that delays interaction

Animations must remain performant.

Flutter is designed around smooth frame rendering, so profile animation-heavy interfaces when necessary rather than assuming debug-mode behavior represents release performance.

---

# 20. SCROLLING EXPERIENCE

Scrolling should feel intentional and polished.

Consider:

* Scroll physics
* Slivers
* Sticky headers
* Collapsing headers
* Pull-to-refresh
* Scroll position
* Overscroll behavior
* Lazy rendering
* Large lists
* Keyboard interaction

Do not nest scroll views unnecessarily.

Avoid rendering huge collections eagerly.

---

# 21. LOADING STATES

Never leave the user staring at an empty screen.

Use appropriate:

* Skeletons
* Progress indicators
* Shimmer only when justified
* Placeholder content
* Progressive loading
* Optimistic UI where appropriate

Loading states should visually resemble the final content structure when possible.

---

# 22. EMPTY STATES

Design intentional empty states.

A good empty state can contain:

* Illustration/icon
* Short explanation
* Clear next action
* Optional secondary action

Avoid:

```text
No data.
```

with nothing else.

---

# 23. ERROR STATES

Errors should be:

* Understandable
* Specific
* Recoverable
* Non-alarming when possible

Provide:

* Explanation
* Suggested action
* Retry where appropriate
* Undo where appropriate

Do not expose technical implementation details to users.

---

# 24. ACCESSIBILITY

Accessibility is part of quality, not an afterthought.

Consider:

* Semantic labels
* Screen readers
* Keyboard navigation
* Focus order
* Focus visibility
* Contrast
* Text scaling
* Touch target sizes
* Reduced motion
* Color-blind usability

Flutter's accessibility guidance recommends tappable targets of at least 48×48 pixels and emphasizes usability at large text/display scale factors.

Do not communicate important information using color alone.

---

# 25. TOUCH TARGETS

Interactive elements must be comfortably tappable.

Target approximately:

```text
48 × 48 logical pixels minimum
```

when appropriate.

Do not create beautiful interfaces with tiny unusable controls.

---

# 26. IMAGES AND ICONOGRAPHY

Use visual assets intentionally.

Maintain:

* Consistent icon style
* Consistent icon weight
* Appropriate icon sizes
* Correct alignment
* Appropriate image aspect ratios
* Proper image cropping
* Meaningful alt/semantic labels where needed

Do not mix visually incompatible icon sets.

---

# 27. VISUAL HIERARCHY

Every screen should have a clear hierarchy.

The user should quickly understand:

1. Where am I?
2. What is this screen about?
3. What is most important?
4. What can I do?
5. What should I do next?

Use:

* Typography
* Position
* Scale
* Contrast
* Spacing
* Color
* Grouping
* Motion

to establish hierarchy.

Do not make every element visually loud.

---

# 28. VISUAL BALANCE

Aim for:

* Strong focal points
* Comfortable whitespace
* Balanced density
* Consistent alignment
* Predictable rhythm
* Intentional asymmetry when appropriate

Avoid:

* Everything centered
* Everything boxed
* Everything equally emphasized
* Huge empty regions without purpose
* Dense walls of controls

---

# 29. PREMIUM AESTHETIC

Premium does NOT mean:

* More gradients
* More shadows
* More blur
* More rounded corners
* More animation
* More colors

Premium means:

* Restraint
* Consistency
* Precision
* Excellent typography
* Excellent spacing
* Strong hierarchy
* High-quality interaction
* Intentional details
* Visual confidence

Prefer sophistication over decoration.

---

# 30. COLOR USAGE

Use color intentionally.

A strong visual system usually has:

* Dominant neutral foundation
* One primary brand color
* Carefully selected supporting colors
* Semantic state colors
* Controlled accent usage

Do not use a rainbow palette unless the product concept specifically calls for it.

Do not introduce new colors for individual widgets without design-system justification.

---

# 31. DARK MODE

If dark mode exists, design it intentionally.

Do not simply invert colors.

Consider:

* Surface hierarchy
* Contrast
* Elevation
* Borders
* Text brightness
* Accent saturation
* Images
* Shadows
* Status colors

Dark mode should feel designed, not recolored.

---

# 32. RESPONSIVE TYPOGRAPHY

Typography must remain readable across screen sizes.

Consider:

* Maximum text widths
* Line lengths
* Wrapping
* Dynamic type scaling
* Heading changes at larger breakpoints
* Dense vs spacious layouts

Never allow huge desktop headings to destroy mobile layouts.

Never allow desktop text to become unnecessarily tiny.

---

# 33. RESPONSIVE COMPONENTS

Components themselves should be adaptive.

For example:

```text
Mobile:
Icon + label

Tablet:
Icon + label

Desktop:
Expanded control with tooltip / keyboard support
```

or:

```text
Mobile:
Bottom sheet

Desktop:
Dialog / side panel
```

The component should choose the best interaction model for the available space.

---

# 34. DESKTOP QUALITY

Do not treat desktop as an afterthought.

Desktop interfaces should consider:

* Mouse
* Keyboard
* Hover
* Focus
* Tooltips
* Context menus
* Larger information density
* Multi-column layouts
* Side navigation
* Window resizing

A desktop UI should take advantage of available space without becoming excessively spread out.

---

# 35. LARGE-SCREEN QUALITY

For 1440p, 4K and ultrawide displays:

Do not stretch the primary content indefinitely.

Use:

* Maximum content widths
* Multiple content regions
* Secondary information panels
* Appropriate whitespace
* Grid systems
* Intentional alignment

Large screens should feel premium rather than empty.

---

# 36. PERFORMANCE

Never sacrifice performance for decoration.

Avoid:

* Excessive rebuilds
* Expensive effects everywhere
* Unnecessary blur
* Excessive shadows
* Huge image decoding
* Unbounded lists
* Heavy animations
* Rebuilding entire pages unnecessarily

Use:

* Lazy lists
* Efficient image loading
* Appropriate caching
* Repaint boundaries when justified
* Const widgets where beneficial
* Efficient state management
* Slivers for large scrolling surfaces

Profile when performance is uncertain.

Flutter's DevTools Performance view should be used for diagnosing rendering and frame issues, preferably in profile mode rather than relying on debug-mode frame timing.

---

# 37. STATE MANAGEMENT AND UI

Do not tightly couple visual components to business logic unnecessarily.

Separate:

```text
Presentation
↓
UI State
↓
Application Logic
↓
Data
```

Keep reusable visual components independent from feature-specific business logic when practical.

---

# 38. DESIGN TOKENS

Centralize:

```text
Colors
Typography
Spacing
Radius
Elevation
Motion
Icon sizes
Control heights
Breakpoints
Content widths
```

Example conceptual structure:

```text
AppColors
AppTypography
AppSpacing
AppRadius
AppElevation
AppMotion
AppBreakpoints
AppDimensions
```

Avoid scattered magic numbers.

---

# 39. CONTENT WIDTH

On large screens, constrain readable content.

Do not create extremely long text lines.

Use maximum widths for:

* Articles
* Forms
* Settings
* Dashboards
* Detail pages
* Main content

while allowing full-width layouts where appropriate.

---

# 40. FORMS

Forms should be:

* Clear
* Grouped
* Easy to scan
* Keyboard friendly
* Accessible
* Responsive

Use:

* Helpful labels
* Appropriate validation
* Inline errors
* Logical focus order
* Appropriate keyboard types
* Clear primary actions

Avoid overly dense forms.

---

# 41. DASHBOARDS

For dashboards:

Prioritize:

1. Most important metrics
2. Trends
3. Actions
4. Detailed information

Use responsive grids.

Example:

```text
Mobile
1 column

Tablet
2 columns

Desktop
3–4 columns

Large desktop
Constrained multi-region layout
```

Do not blindly preserve the same card grid at every width.

---

# 42. VISUAL QA LOOP

After implementing a major UI, perform a visual QA pass.

Check at minimum:

```text
390 × 844
430 × 932
768 × 1024
1024 × 1366
1280 × 800
1440 × 900
1920 × 1080
2560 × 1440
```

Also test:

* Landscape
* Portrait
* Large text
* Keyboard visible
* Mouse interaction
* Touch interaction

Look for:

* Overflow
* Clipping
* Misalignment
* Bad spacing
* Awkward wrapping
* Excessive whitespace
* Cramped content
* Incorrect navigation
* Inconsistent typography
* Inconsistent radii
* Poor contrast
* Broken animations
* Desktop layouts that look like mobile
* Mobile layouts that look like miniature desktop

Fix discovered problems rather than merely documenting them.

---

# 43. SELF-CRITIQUE BEFORE FINISHING

Before declaring the UI complete, ask:

### Visual

* Does this look premium?
* Does it look intentional?
* Is the hierarchy obvious?
* Is the typography excellent?
* Is spacing consistent?
* Is the color system coherent?
* Are there unnecessary visual elements?

### UX

* Can a new user understand the screen immediately?
* Is the primary action obvious?
* Are interactions predictable?
* Are loading/empty/error states handled?

### Responsive

* Does mobile feel designed specifically for mobile?
* Does tablet feel designed specifically for tablet?
* Does desktop use its available space intelligently?
* Does ultrawide remain balanced?

### Motion

* Are animations useful?
* Are they fast enough?
* Are they smooth?
* Do they communicate state changes?

### Accessibility

* Can users navigate it with keyboard?
* Are touch targets adequate?
* Does text scale correctly?
* Is information understandable without relying solely on color?

### Engineering

* Are components reusable?
* Are design tokens centralized?
* Are there unnecessary rebuilds?
* Are there hardcoded dimensions that will break?

---

# 44. DO NOT STOP AT THE FIRST ACCEPTABLE RESULT

The first implementation is a draft.

Use this loop:

```text
Design
↓
Implement
↓
Run
↓
Inspect
↓
Identify weaknesses
↓
Refine
↓
Test responsive layouts
↓
Refine again
↓
Final QA
```

Do not settle for "it works."

Aim for "it feels finished."

---

# 45. WHEN A REFERENCE IMAGE IS PROVIDED

If the user provides a screenshot or design reference:

Do NOT blindly reproduce individual pixels.

Extract:

* Design language
* Typography
* Spacing
* Composition
* Color relationships
* Surface treatment
* Radius language
* Navigation patterns
* Motion language
* Density
* Visual hierarchy

Then implement those principles in idiomatic Flutter.

If the reference conflicts with usability, accessibility, or responsive behavior, preserve the visual intent while improving the implementation.

---

# 46. WHEN NO DESIGN REFERENCE IS PROVIDED

Do not default to generic Material UI.

Create a deliberate visual direction.

Before implementation, internally establish:

```text
Design personality
Color direction
Typography direction
Spacing rhythm
Surface treatment
Radius language
Navigation style
Motion language
Responsive strategy
```

Then implement consistently.

---

# 47. MATERIAL 3 POLICY

Material 3 is allowed and encouraged where appropriate, but do not blindly inherit default visual styling.

Flutter uses Material 3 by default in current Flutter releases, and Material 3 supports customization through `ColorScheme`, `TextTheme`, and component themes.

Use Material 3 as:

```text
Foundation
+
Brand system
+
Custom visual language
+
Responsive/adaptive behavior
```

not:

```text
Default Material widgets everywhere
```

---

# 48. FLUTTER-SPECIFIC QUALITY

Prefer idiomatic Flutter.

Use the framework's strengths:

* Declarative UI
* Composition
* Custom widgets
* Layout constraints
* Slivers
* Animations
* Theming
* Material 3
* Cupertino
* Adaptive layouts
* Custom painting when genuinely necessary

Flutter supports both Material and Cupertino design systems and provides a rich set of layout, visual, structural, and interactive widgets.

Do not recreate framework functionality unnecessarily.

---

# 49. PLATFORM-AWARE INTERACTION

Where appropriate, respect platform conventions for:

* Scrolling
* Navigation
* Text editing
* Haptics
* Dialogs
* Inputs
* Pickers
* System interactions

Flutter already provides platform-adaptive behavior for several interaction areas, so use those capabilities rather than unnecessarily fighting the platform.

---

# 50. FINAL QUALITY BAR

The final interface should pass this test:

> If the Flutter logo, framework conventions, and implementation details were hidden, would this look like a professionally designed modern product?

If the answer is no:

DO NOT consider the UI finished.

Improve:

* Typography
* Spacing
* Hierarchy
* Composition
* Responsive behavior
* Interaction
* Motion
* Surface treatment
* Accessibility
* Consistency

until the interface reaches a professional product-quality standard.

---

# FINAL PRINCIPLE

Build Flutter interfaces that are:

**Beautiful without being decorative.**

**Premium without being excessive.**

**Modern without chasing trends.**

**Minimal without being empty.**

**Responsive without merely scaling.**

**Adaptive without becoming inconsistent.**

**Animated without becoming distracting.**

**Accessible without compromising aesthetics.**

**Performant without sacrificing polish.**

**Consistent without becoming boring.**

**Distinctive without becoming chaotic.**

The goal is not to make something that looks like "a beautiful Flutter app."

The goal is to make something that looks like an exceptional product.
