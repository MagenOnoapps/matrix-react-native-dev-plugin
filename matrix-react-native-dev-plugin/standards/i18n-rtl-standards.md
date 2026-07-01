# i18n & RTL Standards

## Purpose & Scope

These standards apply to all React Native app code reviewed by `rn-code-reviewer` via `/review-code` — any screen, component, or copy that reaches an end user, plus the `react-i18next` configuration and translation resources backing it. Each bullet below carries a stable ID so review findings can cite the exact rule they violate. This list is a baseline, not exhaustive — reviewers should use judgment for app-specific risk.

## react-i18next Conventions

- `I18N-COPY-1` No hardcoded user-facing strings in components — every user-visible string goes through `t()`/`useTranslation()`.
- `I18N-COPY-2` Translation keys are namespaced per feature (e.g. `checkout.summary.title`), not a single flat global namespace, so keys don't collide across features.
- `I18N-COPY-3` Dynamic values are passed via `t()` interpolation (`t('greeting', { name })`), never built with string concatenation or template literals around a translated string.
- `I18N-COPY-4` Pluralization uses `react-i18next`'s plural key suffixes (`_one`/`_other`, etc.) instead of manual `count === 1 ? ... : ...` branching.
- `I18N-COPY-5` New keys are added to every supported locale's resource file in the same change, even if only the base locale has a real translation initially (placeholder, not missing).

## RTL Layout Rules

- `I18N-RTL-1` Layout styles use logical properties (`start`/`end`, `marginStart`/`marginEnd`, `paddingStart`/`paddingEnd`) instead of physical `left`/`right`, so layout mirrors automatically under RTL.
- `I18N-RTL-2` Directional flex layouts rely on `I18nManager.isRTL` (or the platform's automatic mirroring of `flexDirection: 'row'`) rather than hardcoding a visual order that assumes LTR.
- `I18N-RTL-3` Icons and imagery that imply direction (back/forward arrows, chevrons, progress indicators) are explicitly flipped for RTL — automatic layout mirroring does not flip raster/vector icon content on its own.
- `I18N-RTL-4` Text alignment uses `start`/`end` (or `writingDirection`-aware defaults), not hardcoded `left`/`right` alignment.

## Bidirectional Testing

- `I18N-TEST-1` Every new screen or flow is manually checked in both an LTR locale and an RTL locale (e.g. Hebrew or Arabic) before merge — this is a required check in `/review-code`, not optional polish.
- `I18N-TEST-2` Bidirectional checks include interactive elements (swipe gestures, sliders, carousels), not just static layout — gesture direction should also mirror under RTL where the platform expects it.

## Locale-Aware Formatting

- `I18N-FMT-1` Dates, times, numbers, and currency are formatted via locale-aware utilities (`Intl.DateTimeFormat`, `Intl.NumberFormat`, or the project's i18n library equivalent) — never built by manually slicing/concatenating date or number parts.
- `I18N-FMT-2` Currency formatting includes the correct currency symbol and decimal/grouping conventions for the active locale, not a hardcoded `$`/`.`/`,`.

## References

- `react-i18next` documentation for translation and pluralization conventions.
- This document is a living baseline; reviewers should flag standards gaps found during review rather than working around them silently.
