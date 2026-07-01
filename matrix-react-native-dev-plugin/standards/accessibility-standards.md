# Accessibility Standards

## Purpose & Scope

These standards apply to all React Native screens and components reviewed by `rn-code-reviewer`, and are used by `rn-feature-developer` during implementation. They loosely follow WCAG 2.1 and the platform accessibility guidelines from Apple and Google; see [References](#references). Each bullet carries a stable ID so review findings can cite the exact rule they violate. This list is a baseline, not exhaustive — reviewers should use judgment for app-specific risk.

## Accessibility Props & Roles

- `A11Y-ROLES-1` Every interactive element (`Pressable`, `TouchableOpacity`, custom buttons) has an `accessibilityRole` matching its function (`button`, `link`, `switch`, `header`, etc.).
- `A11Y-ROLES-2` Every interactive element without adjacent visible text has an explicit `accessibilityLabel` describing its action, not its appearance (e.g. "Delete item", not "Trash icon").
- `A11Y-ROLES-3` Stateful controls (toggles, checkboxes, tabs, expandable sections) expose their state via `accessibilityState` (`checked`, `selected`, `expanded`, `disabled`) rather than relying on visual styling alone.
- `A11Y-ROLES-4` Purely decorative images/icons are marked `accessible={false}` or `accessibilityElementsHidden`/`importantForAccessibility="no"` so screen readers don't announce them.
- `A11Y-ROLES-5` Grouped content that should be read as one unit (e.g. a list row with title + subtitle) uses `accessible={true}` on the container with a combined `accessibilityLabel`, not separate announcements per child.

## Touch Target Sizes

- `A11Y-TOUCH-1` Interactive elements have a minimum tappable area of 44x44pt on iOS and 48x48dp on Android, using `hitSlop` or padding when the visual element is smaller.
- `A11Y-TOUCH-2` Adjacent tappable elements have enough spacing to avoid accidental mis-taps, even when `hitSlop` is used to hit the minimum target size.

## Dynamic Font Scaling

- `A11Y-FONT-1` Text respects the OS font-scale setting by default — `allowFontScaling={false}` is only used with a specific, documented reason (e.g. a fixed-size icon label), never as a default choice.
- `A11Y-FONT-2` Layouts that contain text are tested at large accessibility font sizes and don't clip, truncate critical information, or overlap other elements.
- `A11Y-FONT-3` Fixed-height containers around text use `flexWrap`/`minHeight` rather than a hard pixel height that breaks when the font scales up.

## Screen Reader Testing

- `A11Y-SR-1` New or changed interactive flows are manually walked through with VoiceOver (iOS) and TalkBack (Android) before merging — automated checks alone are not sufficient.
- `A11Y-SR-2` Focus order for screen readers follows the visual reading order; custom focus order (`accessibilityViewIsModal`, explicit focus management) is used when a modal/overlay would otherwise break that order.
- `A11Y-SR-3` Dynamic content changes (errors, loading states, toasts) are announced to screen readers via `AccessibilityInfo.announceForAccessibility` or an equivalent live-region mechanism, not silently rendered.

## References

- W3C Web Content Accessibility Guidelines (WCAG) 2.1.
- Apple Human Interface Guidelines — Accessibility.
- Android Accessibility developer guidelines (TalkBack, minimum touch target size).
- This document is a living baseline; reviewers should flag standards gaps found during review rather than working around them silently.
