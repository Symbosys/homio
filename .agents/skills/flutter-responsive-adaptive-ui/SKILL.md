---

name: flutter-responsive-adaptive-ui
description: >
Build production-grade responsive and adaptive Flutter interfaces that
remain usable, visually balanced, accessible, and polished across phones,
foldables, tablets, laptops, desktops, large monitors, ultrawide displays,
resizable windows, split-screen modes, landscape and portrait. Use whenever
implementing, reviewing, debugging, refactoring, or designing responsive
Flutter UI.
-----------

# Flutter Responsive & Adaptive UI Engineering

## ROLE

Act as a senior Flutter responsive-design engineer, product designer, and UI architect.

Your responsibility is to build interfaces that remain:

* visually polished
* usable
* accessible
* stable
* proportional
* performant
* adaptive
* maintainable

across the full range of real-world Flutter window sizes.

Do not optimize for one screenshot or one device.

Optimize for the entire space between minimum and maximum supported dimensions.

---

# 1. CORE PRINCIPLE

Responsive UI is NOT:

> "Make the mobile UI fit on desktop."

Responsive UI is:

> "Create a layout system that continuously adapts to the available space."

Adaptive UI is:

> "Choose the most appropriate composition and interaction model for the available space."

The implementation must support both.

---

# 2. NON-NEGOTIABLE REQUIREMENT

Never assume that:

* phone = small width
* tablet = medium width
* desktop = large width
* portrait = mobile
* landscape = tablet/desktop
* Android = phone
* iOS = phone
* Windows = desktop

The application may run inside:

* resizable windows
* split-screen
* freeform windows
* foldables
* desktop windows
* browser-sized windows
* embedded surfaces

Therefore:

## Base layout decisions primarily on AVAILABLE SPACE and CAPABILITIES.

---

# 3. RESPONSIVE QUALITY BAR

Every screen must remain usable at arbitrary widths within the supported range.

Do not only test:

```text
390
768
1440
```

Also consider intermediate values:

```text
320
360
375
390
414
430
480
540
600
640
720
768
800
834
900
960
1024
1100
1200
1280
1366
1440
1600
1920
2560+
```

The UI must gracefully transition between states.

---

# 4. NEVER DESIGN A SINGLE FIXED LAYOUT

Do not assume one widget tree can simply be scaled indefinitely.

A professional responsive implementation may use different compositions.

Example:

```text
COMPACT
Bottom navigation
Single column
Full-width controls

MEDIUM
Navigation rail
Two-column content where appropriate

EXPANDED
Persistent sidebar
Multi-column layout
Secondary panels

LARGE
Constrained content canvas
Multi-region composition
Additional contextual information
```

The exact states must be determined by the product's needs.

---

# 5. BREAKPOINTS ARE BEHAVIOR CHANGES

Never choose breakpoints merely because:

```text
600 = tablet
1024 = desktop
```

Instead ask:

> "At what width does the current composition stop being usable or visually balanced?"

A breakpoint should represent a meaningful layout transformation.

Examples:

```text
Navigation no longer fits
        ↓
Switch navigation model

Cards become too narrow
        ↓
Change column count

Text becomes too long
        ↓
Increase content width or change composition

Two panels become cramped
        ↓
Stack them

Primary controls no longer fit
        ↓
Collapse secondary actions
```

---

# 6. USE CONTINUOUS RESPONSIVENESS

Do not overuse discrete breakpoints.

Use continuous constraints where possible.

Prefer:

```dart
ConstrainedBox
SizedBox
FractionallySizedBox
Expanded
Flexible
Wrap
LayoutBuilder
GridView
SliverGrid
```

over arbitrary width calculations.

Use breakpoints only when the composition genuinely needs to change.

---

# 7. LAYOUTBUILDER

Use `LayoutBuilder` when a component's layout depends on the constraints supplied by its parent.

Example:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final width = constraints.maxWidth;

    if (width < compactBreakpoint) {
      return const CompactLayout();
    }

    if (width < expandedBreakpoint) {
      return const MediumLayout();
    }

    return const ExpandedLayout();
  },
)
```

Do not place all responsive logic into one giant `LayoutBuilder`.

Responsive behavior should be localized to the components that actually need it.

---

# 8. MEDIA QUERY

Use:

```dart
MediaQuery.sizeOf(context)
```

when the component needs information about the application window.

Use `MediaQuery` for environmental information such as:

* window size
* text scaling
* accessibility settings
* padding
* view insets

Do not use MediaQuery as a replacement for proper component constraints.

---

# 9. CONSTRAINTS FIRST

Always understand Flutter's layout model:

> Constraints go down.
> Sizes go up.
> Parents set positions.

Before changing dimensions, inspect:

* incoming constraints
* child constraints
* available width
* available height
* minimum width
* maximum width
* minimum height
* maximum height

Do not solve overflow by randomly adding:

```dart
SizedBox
Expanded
SingleChildScrollView
```

without understanding why the overflow occurred.

---

# 10. NEVER HARD-CODE SCREEN WIDTHS

Avoid:

```dart
width: 390
width: 400
width: 768
width: 1024
```

for major responsive containers.

Hardcoded dimensions are acceptable only for genuinely fixed-size elements such as:

* icons
* touch targets
* avatar sizes
* control heights
* small visual details

Major layout dimensions should derive from constraints.

---

# 11. MAXIMUM CONTENT WIDTH

Large displays must not cause content to stretch indefinitely.

Use maximum widths for:

* forms
* reading content
* settings
* profile pages
* authentication
* detail pages
* dashboards
* text-heavy interfaces

Example:

```dart
Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(
      maxWidth: 1200,
    ),
    child: content,
  ),
)
```

The exact maximum width must be chosen according to the content.

Do not blindly use `800` or `1200` everywhere.

---

# 12. FLUID WIDTHS

Prefer fluid sizing for containers where appropriate.

For example:

```text
Available width
        ↓
Outer padding
        ↓
Maximum content width
        ↓
Grid/list constraints
        ↓
Component constraints
```

Do not build layouts from a chain of arbitrary pixel widths.

---

# 13. RESPONSIVE GRID

Grid layouts must adapt their column count.

Prefer:

```dart
SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent: ...,
)
```

when appropriate.

This allows the grid to naturally determine the number of columns.

Alternatively calculate columns from:

* minimum card width
* available width
* spacing
* maximum columns

Do not blindly specify:

```text
2 columns mobile
3 columns tablet
4 columns desktop
```

without considering actual available space.

---

# 14. MINIMUM COMPONENT WIDTH

Every responsive component should have a usable minimum width.

Example:

```text
Card minimum useful width = 260px
```

If the available width falls below that threshold:

```text
Do not shrink the card endlessly.
Change the composition.
```

Possible solutions:

* stack content
* reduce secondary information
* switch to list
* collapse controls
* change grid columns
* move actions
* create horizontal scrolling only when genuinely appropriate

---

# 15. FLEXIBLE ROWS

Rows are a common source of responsive failures.

Avoid:

```dart
Row(
  children: [
    hugeFixedWidget,
    hugeFixedWidget,
    hugeFixedWidget,
  ],
)
```

Prefer:

```dart
Row(
  children: [
    Expanded(...),
    Flexible(...),
  ],
)
```

or switch to:

```dart
Wrap
```

or a different layout entirely.

Always consider what happens when text becomes longer.

---

# 16. TEXT IS A RESPONSIVE ELEMENT

Never design assuming text has a fixed length.

Test:

* short labels
* long labels
* localization
* large accessibility text
* dynamic content
* user-generated content

Avoid:

```dart
Text(
  "...",
  maxLines: 1,
  overflow: TextOverflow.clip,
)
```

unless clipping is genuinely intended.

Prefer graceful wrapping or alternative layouts.

---

# 17. TEXT SCALING

The UI must remain functional when users increase text size.

Do not design around:

```text
fontSize = 14
```

as though it will always render at exactly that size.

Test large text settings.

Do not allow:

* clipped labels
* overlapping controls
* inaccessible buttons
* broken navigation
* overflowing cards

---

# 18. RESPONSIVE TYPOGRAPHY

Typography may adapt between size classes.

For example:

```text
Compact:
28px heading

Medium:
32px heading

Expanded:
40px heading
```

But don't arbitrarily scale everything.

Typography must preserve:

* hierarchy
* readability
* rhythm
* brand personality

---

# 19. RESPONSIVE SPACING

Spacing should adapt when appropriate.

Example:

```text
Compact:
16px page padding

Medium:
24px

Expanded:
32px

Large:
40px+
```

But avoid proportional scaling of every spacing token.

Maintain a coherent design system.

---

# 20. RESPONSIVE NAVIGATION

Navigation should adapt.

Possible patterns:

```text
Compact
Bottom Navigation / NavigationBar

Medium
NavigationRail

Expanded
NavigationRail or persistent sidebar

Large
Persistent sidebar + contextual navigation
```

Do not force bottom navigation onto desktop.

Do not force a large sidebar onto narrow mobile screens.

---

# 21. RESPONSIVE APP BARS

App bars should adapt based on:

* available width
* number of actions
* title length
* navigation structure

When actions don't fit:

* move secondary actions into an overflow menu
* change composition
* reduce visible actions
* move actions into contextual areas

Never allow AppBar actions to overflow.

---

# 22. RESPONSIVE FORMS

Forms should adapt structurally.

Compact:

```text
Single column
```

Medium:

```text
Two columns where fields logically belong together
```

Expanded:

```text
Structured multi-column form
```

Do not create multi-column forms simply because there is empty space.

Related fields should remain visually grouped.

---

# 23. RESPONSIVE DASHBOARDS

Dashboards should change composition.

Compact:

```text
1-column
```

Medium:

```text
2-column
```

Expanded:

```text
3–4 regions where appropriate
```

Large:

```text
Primary content
+
secondary contextual information
```

Do not allow tiny cards to proliferate simply to fill available width.

---

# 24. RESPONSIVE DETAIL PAGES

A detail page may transition from:

```text
Compact:
Image
↓
Details
↓
Actions
```

to:

```text
Expanded:
Image | Details | Contextual actions
```

Use available width meaningfully.

---

# 25. RESPONSIVE DIALOGS

Dialogs must have maximum width constraints.

Do not create:

```dart
Dialog(
  child: Container(
    width: MediaQuery.sizeOf(context).width,
  ),
)
```

on large screens.

Prefer a constrained dialog width.

On mobile, consider whether:

* dialog
* bottom sheet
* full-screen route

is the most appropriate interaction.

---

# 26. BOTTOM SHEETS

Bottom sheets should adapt.

Compact:

```text
Bottom sheet
```

Expanded:

```text
Dialog
Side panel
Popover
```

when appropriate.

Do not blindly use mobile interaction patterns on desktop.

---

# 27. MASTER-DETAIL LAYOUTS

For large screens, consider:

```text
Navigation
|
Master list
|
Detail content
```

rather than navigating to entirely separate screens.

On compact screens:

```text
List
↓
Detail
```

This is a genuine adaptive composition.

---

# 28. SIDE PANELS

On large screens, use side panels when they improve productivity.

Examples:

* Filters
* Properties
* Context
* Details
* Secondary navigation
* Inspector
* Activity

On compact screens, convert them into:

* bottom sheets
* dialogs
* dedicated routes

---

# 29. FOLDABLES AND UNUSUAL ASPECT RATIOS

Do not assume a normal phone aspect ratio.

Consider:

* very wide windows
* very tall windows
* foldable displays
* dual-pane situations
* split-screen

Design based on usable window regions and constraints.

---

# 30. ORIENTATION

Do not use orientation as the primary source of layout decisions.

Instead:

```text
Available width
+
Available height
+
Interaction capabilities
```

should determine the composition.

Portrait can have a wide window.

Landscape can have a narrow window.

Orientation alone is insufficient.

---

# 31. KEYBOARD

Desktop and tablet experiences may involve hardware keyboards.

Support:

* Tab navigation
* Focus movement
* Enter/activation
* Escape where appropriate
* Common shortcuts where useful

Do not make the application touch-only.

---

# 32. MOUSE AND TRACKPAD

For pointer-capable environments consider:

* Hover states
* Cursor changes
* Tooltips
* Context menus
* Hover previews
* Pointer affordances

Do not make hover the only way to understand functionality.

Touch users must remain fully supported.

---

# 33. TOUCH TARGETS

Interactive controls should remain comfortably tappable.

Target approximately:

```text
48 × 48 logical pixels
```

where appropriate.

Visual size and interactive hit area may differ.

A visually small icon can have a larger semantic hit target.

---

# 34. SAFE AREAS AND INSETS

Respect:

* status bars
* navigation bars
* display cutouts
* keyboard
* system UI
* viewInsets
* safe areas

Test when the keyboard is visible.

---

# 35. KEYBOARD-AWARE FORMS

Forms must remain usable when the keyboard appears.

Consider:

* scrolling focused fields into view
* avoiding keyboard overlap
* preserving actions
* correct resize behavior
* dismissing keyboard appropriately

Do not let the keyboard cover the active field or primary action.

---

# 36. SCROLLING ARCHITECTURE

Choose scrolling deliberately.

Use:

```text
ListView.builder
GridView.builder
CustomScrollView
SliverList
SliverGrid
```

for large/unknown collections.

Avoid eagerly building thousands of children.

---

# 37. AVOID NESTED SCROLL CHAOS

Do not create unnecessary nested:

```text
ListView
inside
SingleChildScrollView
inside
ListView
```

Nested scrolling should have a deliberate reason.

When scrolling becomes complex, redesign the scroll architecture.

---

# 38. OVERFLOW IS A BUG

Treat:

```text
RenderFlex overflowed
```

as a real defect.

Do not hide it using arbitrary:

```dart
ClipRect
OverflowBox
SizedBox
```

unless the visual behavior is intentionally clipped.

Find and fix the underlying constraint problem.

---

# 39. NO OVERFLOW FALLBACK

Do not rely on:

```dart
FittedBox
```

to solve every responsive problem.

FittedBox can make text and UI physically smaller without making the interaction better.

Prefer restructuring the layout.

---

# 40. NO "SHRINK EVERYTHING" STRATEGY

When space decreases:

Do not simply:

```text
make everything smaller
```

Instead prioritize:

```text
Remove low-priority information
↓
Collapse secondary actions
↓
Stack content
↓
Change navigation
↓
Change component composition
↓
Only then reduce dimensions where appropriate
```

---

# 41. INFORMATION PRIORITY

Responsive design is partly information architecture.

When space is limited:

### Keep visible:

* screen identity
* primary content
* primary action
* critical status

### Deprioritize:

* secondary metadata
* optional actions
* decorative elements
* low-priority panels

Move secondary information into:

* overflow
* expandable sections
* sheets
* dialogs
* detail screens

---

# 42. CONTAINER QUERIES MINDSET

Think in terms of component space rather than only screen size.

A card may appear:

```text
inside a narrow column
```

even on a large desktop.

Therefore its layout should respond to its own available constraints.

Do not assume:

```text
large screen = every child is large
```

---

# 43. COMPONENT-LEVEL RESPONSIVENESS

Responsive behavior belongs at multiple levels:

```text
Application
↓
Page
↓
Section
↓
Component
↓
Control
```

Do not implement all responsive behavior at the application root.

A reusable component should be able to respond to its own available width.

---

# 44. PAGE-LEVEL RESPONSIVENESS

Page-level decisions may control:

* navigation
* columns
* panels
* major sections
* information density

Component-level decisions may control:

* card orientation
* button arrangement
* text wrapping
* metadata visibility

Keep these responsibilities separate.

---

# 45. DESIGN TOKENS FOR RESPONSIVENESS

Centralize responsive values where appropriate.

Example:

```text
AppBreakpoints
AppContentWidths
AppPagePadding
AppGridSpacing
AppControlSizes
AppTypography
```

Avoid scattering breakpoint values across dozens of files.

---

# 46. USE SEMANTIC BREAKPOINTS

Prefer names such as:

```dart
compactBreakpoint
mediumBreakpoint
expandedBreakpoint
largeBreakpoint
```

instead of:

```dart
width600
width1024
width1440
```

The name should communicate the behavior, not merely the number.

---

# 47. DO NOT CREATE TOO MANY BREAKPOINTS

Too many breakpoints create fragile UI.

Start with the minimum number of meaningful layout states.

Add another state only when there is a real composition change.

---

# 48. RESPONSIVE IMAGES

Images should adapt using:

* AspectRatio
* constraints
* BoxFit
* bounded dimensions

Do not allow images to distort.

Use appropriate cropping.

---

# 49. RESPONSIVE ICONS

Icon sizes should remain visually balanced.

Do not continuously scale icons with screen width.

Icons usually use stable sizes while their surrounding layout changes.

---

# 50. RESPONSIVE BUTTONS

Buttons should adapt.

Compact:

```text
Full-width primary action
```

Expanded:

```text
Intrinsic / constrained width
```

When multiple actions don't fit:

```text
Primary action
+
Overflow
```

Do not squeeze five buttons into one narrow row.

---

# 51. RESPONSIVE TABLES

Tables are difficult on compact screens.

Do not simply shrink a desktop table until text becomes unreadable.

Consider:

```text
Desktop:
Full table

Tablet:
Reduced columns

Mobile:
Card/list representation
```

This is adaptive design.

---

# 52. RESPONSIVE DATA VISUALIZATION

Charts must adapt their:

* labels
* legends
* axis density
* dimensions
* interaction model

Do not allow chart labels to overlap.

On compact screens, simplify visual information rather than shrinking everything.

---

# 53. RESPONSIVE MODALS AND MENUS

Menus should remain inside available bounds.

Consider:

* available width
* available height
* keyboard
* safe areas
* anchor location

Never allow menus to render partially off-screen.

---

# 54. LARGE SCREEN WHITESPACE

Large screens require intentional whitespace.

Do not stretch content to fill every pixel.

Use:

```text
maximum content width
+
balanced gutters
+
secondary regions
```

Whitespace should communicate hierarchy.

---

# 55. ULTRAWIDE SUPPORT

For ultrawide screens:

Do not produce:

```text
huge empty margins
```

without purpose.

Possible strategies:

```text
Primary content
+
secondary panel
+
contextual information
```

or:

```text
Constrained central canvas
+
supporting navigation/context
```

The layout should remain visually balanced.

---

# 56. RESIZABLE WINDOW TESTING

Desktop applications must survive continuous resizing.

Test:

```text
wide → narrow
narrow → wide
```

without restarting the application.

Look for:

* overflow
* layout jumps
* broken navigation
* lost state
* disappearing controls
* incorrect animation
* incorrect scroll positions

---

# 57. VISUAL TRANSITIONS BETWEEN BREAKPOINTS

Responsive transitions should feel intentional.

Avoid sudden:

```text
everything jumps
```

unless a structural change requires it.

Where appropriate, use:

* AnimatedSwitcher
* AnimatedContainer
* implicit animations
* controlled transitions

Do not animate every breakpoint change.

---

# 58. ACCESSIBILITY

Responsive UI must work with accessibility settings.

Test:

* large text
* high contrast where applicable
* screen readers
* keyboard navigation
* focus traversal
* reduced motion
* touch targets

Accessibility can change the effective layout.

Treat accessibility as a responsive input.

---

# 59. LOCALIZATION

Assume text can become longer.

Design for:

* longer translations
* RTL languages
* different date formats
* different number formats

Avoid fixed-width labels.

Use logical directional properties where appropriate.

---

# 60. RTL

Do not hardcode left/right assumptions when directional layout is appropriate.

Prefer:

```text
EdgeInsetsDirectional
AlignmentDirectional
BorderRadiusDirectional
```

where appropriate.

Test RTL layouts if the product supports localization.

---

# 61. STATE PRESERVATION

Responsive layout changes should not unnecessarily destroy:

* scroll position
* form input
* selection
* navigation state
* expanded sections

When changing composition, preserve meaningful user state.

---

# 62. RESPONSIVE PERFORMANCE

Do not rebuild the entire application whenever the window size changes.

Keep responsive logic appropriately scoped.

Avoid expensive layout calculations during every frame.

When resizing or animating:

* minimize unnecessary rebuilds
* avoid expensive effects
* avoid huge image transformations
* use efficient lists
* profile when necessary

---

# 63. RESPONSIVE TEST MATRIX

For every major screen, test at minimum:

```text
320 × 568
360 × 800
390 × 844
430 × 932

600 × 800
768 × 1024
834 × 1194
1024 × 1366

1280 × 800
1366 × 768
1440 × 900
1600 × 900
1920 × 1080
2560 × 1440
```

Also test:

```text
Portrait
Landscape
Keyboard visible
Large text
Mouse
Touch
Window resizing
```

The exact test matrix may be adjusted to the product's supported platforms.

---

# 64. VISUAL QA PROCESS

After implementation:

## Step 1

Run the application.

## Step 2

Resize to compact width.

## Step 3

Check:

* overflow
* text wrapping
* buttons
* navigation
* spacing
* content visibility

## Step 4

Resize continuously toward tablet.

## Step 5

Inspect the transition.

## Step 6

Resize toward desktop.

## Step 7

Inspect:

* content width
* navigation
* grids
* whitespace
* panel composition

## Step 8

Test ultrawide.

## Step 9

Test large text.

## Step 10

Fix every discovered visual or functional defect.

---

# 65. SCREENSHOT-DRIVEN QA

When screenshot or rendering tools are available:

Capture representative sizes.

Compare:

```text
Compact
Medium
Expanded
Large
Ultrawide
```

Look for:

* alignment
* hierarchy
* whitespace
* component proportions
* typography
* visual density
* overflow
* clipping
* inconsistent spacing

Do not judge responsiveness only from source code.

Judge the rendered interface.

---

# 66. RESPONSIVE CODE REVIEW

Before finishing, inspect the implementation for:

* hardcoded screen dimensions
* arbitrary breakpoints
* overflow risks
* fixed-width rows
* fixed-height text containers
* unnecessary nested scrolling
* duplicated responsive logic
* device-type checks
* orientation-only decisions
* inaccessible controls
* desktop-only assumptions
* mobile-only assumptions

Refactor fragile code.

---

# 67. RESPONSIVE FAILURE RECOVERY

If a layout breaks at a specific width:

DO NOT immediately add another breakpoint.

First determine:

1. What constraint failed?
2. Which child is too large?
3. Is the content hierarchy correct?
4. Should the component wrap?
5. Should content stack?
6. Should secondary content disappear?
7. Should navigation change?
8. Should the component use a different composition?

Only add a breakpoint when the product genuinely needs a different layout state.

---

# 68. NEVER PATCH RESPONSIVENESS WITH RANDOM VALUES

Avoid chains of patches such as:

```text
if width < 700
if width < 680
if width < 665
if width < 640
if width < 625
```

This indicates architectural failure.

Step back and redesign the constraint model.

---

# 69. RESPONSIVE DESIGN REVIEW CHECKLIST

Before completion:

### Compact

* [ ] No horizontal overflow
* [ ] No clipped text
* [ ] Touch targets usable
* [ ] Primary action obvious
* [ ] Navigation usable
* [ ] Keyboard does not cover important content
* [ ] Content hierarchy preserved

### Medium

* [ ] Layout uses additional space
* [ ] Components do not become unnecessarily huge
* [ ] Columns remain readable
* [ ] Navigation is appropriate
* [ ] Spacing remains balanced

### Expanded

* [ ] Desktop composition is intentional
* [ ] Content is constrained appropriately
* [ ] Navigation uses available space
* [ ] Multi-column layouts are meaningful
* [ ] Hover/focus states work

### Large

* [ ] Content does not stretch indefinitely
* [ ] Whitespace is intentional
* [ ] Secondary regions are useful
* [ ] Grid density is appropriate

### Accessibility

* [ ] Large text works
* [ ] Keyboard navigation works
* [ ] Focus is visible
* [ ] Touch targets are adequate
* [ ] Screen reader semantics are meaningful

---

# 70. FINAL RULE

The application must not be considered responsive merely because:

```dart
LayoutBuilder
```

exists.

It is responsive only when the rendered interface remains:

* usable
* visually balanced
* accessible
* stable
* performant
* aesthetically coherent

throughout the supported range of window sizes.

---

# GOLDEN RULE

## NEVER ASK:

> "How do I make this widget fit?"

Ask:

> "What is the best composition for the space available?"

That distinction is the foundation of professional responsive Flutter UI engineering.

Build for the space.

Adapt the composition.

Preserve hierarchy.

Protect usability.

Respect accessibility.

Test intermediate widths.

Test extreme widths.

Never accept overflow.

Never accept accidental stretching.

Never accept a layout that only works at the developer's screen size.

The goal is not to make one screen responsive.

The goal is to build a **responsive design system capable of surviving real-world devices, windows, users, content, and accessibility settings.**
