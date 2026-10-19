# PHASE 1 — INTERACTION STABILITY AND USABILITY

**Status:** execution contract; not an implementation report  
**Owner source:** INT-028, `context/raw/turn-028.txt`, attached recording `2026-10-19 15-23-52.mp4`  
**Scope:** the existing HTML/CSS/vanilla-JS prototype in `design/`  
**Target pages:** `index.html`, `home-light.html`, `library.html`, `archive.html`, `journal.html`, `reader.html`

## 0. Result required

Make page navigation and theme changes feel like one continuous application. Keep existing page content and component geometry. Remove the blank/covered transition state. Add one global theme state. Add idle hide/reveal for navigation chrome. Audit every visible interactive control.

This phase does **not** redesign the visual system or add product features. The implementation agent must not invent copy, components, labels, font choices, page structure, colors, or interaction outcomes.

**Current status: not checked after changes.** No UI repair is claimed in this specification-only commit. The recording is evidence of the current failure; it is not evidence of a repair.

## 1. Fixed constraints

1. Keep this prototype static HTML/CSS with vanilla JavaScript. Do not add a framework, build tool, dependency, API, or backend requirement. [D-010, INT-028]
2. Keep `design/styles/prototype.css` frozen. It is the owner-supplied Figma export. Do not reformat or rewrite it. Add overrides to the named custom style files. [D-008, D-009, INT-028]
3. Preserve Home, Library, Archive, Journal, Reader, their content, grayscale visual language, cover artwork, and avatar asset. Do not remove, rename, reorder, or add content. The only component addition allowed is the owner-requested top-left rail pin toggle in D-014. [X-01–X-16, INT-004, INT-028]
4. Preserve the restored sidebar: Home / Library / Archive at the top; 64px collapsed width; 168px expanded width; labels fade and blur in; divider above the account identity; 26px avatar; handle `prathamarchives` with no `@`; identity stays on its fixed axis. Do not center, resize, retype, or move the identity. [INT-019, INT-023, INT-024, INT-026]
5. Preserve the homepage's 30px section rhythm, 16px intra-section rhythm, 60.256% / remaining-width reading cards, right-aligned Import action, and edge-aligned sections. Preserve the removal of the marked promotional copy, the `@` before the handle, the `⌘K` hint, and the personal-space label. [INT-025, INT-026]
6. Do not add success toasts or filler copy. Do not claim that a control works unless its behavior was tested. [L-13, L-16, INT-028]
7. Do not use page-wide `filter: blur()`, `backdrop-filter` on the viewport, or a full-screen opaque overlay. Blur belongs on the outgoing/incoming page transition and on existing sidebar labels only. Keep the glass sidebar sharp and readable. [X-11, X-14, INT-028]
8. Do not change typeface, weight, icon stroke, radii, card dimensions, or page content while fixing navigation and theme state. The historic Helvetica vs current Figma Inter/Lora conflict remains outside this phase and must not be silently decided here. [D-008, D-010, INT-013, INT-028]
9. No implementation change is complete until the rendered page and interactions are tested. A passing string/grep check alone cannot prove a visual result. [L-13, L-16]

## 2. Defect model

Observed in the supplied recording:
- Switching theme replaces the page instead of changing its state in place.
- Switching section looks and feels like a new site/page load.
- A transition covers nearly the whole screen; a near-blank state appears.
- The navigation shell does not stay visually stable during the transitions.

Confirmed from source:
- Each section is a separate HTML file.
- Theme switches are anchors between `index.html` and `home-light.html`.
- Pages hard-code `theme-light` or `theme-dark`.
- `motion.js` handles initial entrance, current-section selection, and rail hover/focus only. It has no shared route state and no persistent theme state.

**Root cause:** the prototype has page-per-file markup but no shared application navigation state. The page-level theme is hard-coded. A CSS effect cannot correct that architecture on its own.

## 3. Exact implementation order

Do not reorder phases. Do not combine them into one unreviewed patch.

### Pass A — Shared route state and theme

Files allowed: new `design/navigation.js`, new `design/styles/theme.css`, six target HTML files, `design/styles/tokens.css` only if a theme role token is missing, and `verify.sh`.

1. Add `theme.css` after `prototype.css` and before `shell.css`. Keep the Figma export frozen. Define these exact role values from the current prototype palette. Do not add hues or new surface colors.

   | Token | Dark | Light |
   |---|---|---|
   | `--app-canvas` | `#171717` | `#F7F7F5` |
   | `--app-shell` | `#222222` | `#F7F7F5` |
   | `--app-surface-primary` | `#2C2C2C` | `#FFFFFF` |
   | `--app-surface-secondary` | `#292929` | `#F2F2EE` |
   | `--app-fg` | `#EEEEEA` | `#252525` |
   | `--app-muted` | `#A1A19C` | `#777775` |
   | `--app-divider` | `#3B3B39` | `#DEDEDB` |
   | `--app-glass` | `rgba(23,23,23,.72)` | `rgba(255,255,255,.72)` |
   | `--app-glass-edge` | `rgba(238,238,234,.10)` | `rgba(255,255,255,.65)` |
   | `--app-focus` | `rgba(238,238,234,.5)` | `rgba(37,37,37,.5)` |

   Map every visible text and surface role across all six pages to these tokens. Derive the selector list from the existing HTML; do not use universal selectors to recolor elements. Preserve the colors of cover artwork, avatar artwork, and embedded illustrations. Preserve the rail's existing body theme variables in `tokens.css` unless a change is required for a shared theme state.
2. Use one preference key: `arivo.theme`, with values `dark` and `light`. If no saved preference exists, use dark. This follows the current dark-first design-system rule. Apply the preference before the first visible paint where possible. Wrap storage access in `try/catch`; storage failure must not break navigation.
3. Theme switch must update the current document in place. It must not change the URL to another theme-specific page, fetch a new page, or reload the document.
4. The chosen theme must remain the same when the user opens Home, Library, Archive, Journal, or Reader. The theme must survive a direct URL load and browser reload.
5. Build a component-scoped color-role map for all six pages. Do not use `filter: invert()`, broad image filters, or a wildcard that recolors cover artwork, the avatar, or illustrations. Audit text, card surfaces, segmented controls, dividers, progress bars, floating panels, and focus states in both themes. Keep grayscale only.
6. Intercept only safe, same-origin links to the six app documents. Respect Ctrl/Cmd-click, Shift-click, middle-click, downloads, external URLs, non-self targets, and hash-only links. Those links must keep browser behavior.
7. For an internal section change, fetch and parse the target document before changing the visible page. Preserve the shared runtime and stylesheet set. Replace the page root without replacing `window`, the document, or the theme preference. Update `history.pushState`, the document title, `body[data-page]`, and selected navigation state. Support Back and Forward through `popstate`.
8. Do not claim SPA behavior merely because an animation runs. Internal section change must not create another top-level navigation timing entry. Directly opening a section URL must still work without JavaScript navigation.
9. Make route handling and motion initialization idempotent. Re-entering a page must not add duplicate event handlers, duplicate timers, or duplicate document listeners.

### Pass B — Route motion and idle navigation

Files allowed: `design/navigation.js`, `design/motion.js`, `design/styles/motion.css`, `design/styles/shell.css`, `design/styles/tokens.css`, and markup/cache-query updates in the six target HTML files. The only allowed markup addition is the specified pin toggle.

#### Route transition

Use the View Transitions API where available. Provide a no-blank fallback. Fetch and validate the destination before starting the transition.

- Duration: **300ms**.
- Shared easing: `cubic-bezier(0.32, 0.72, 0, 1)`.
- Outgoing page: move right by **18px**, fade from 1 to 0, and blur from **0px to 4px**.
- Incoming page: start **18px left**, fade from 0 to 1, and blur from **4px to 0px**.
- No bounce, overshoot, rotation, scale-up, per-card cascades, or sequential blank frame.
- Do not blur the viewport, the sidebar glass, text outside the page transition, or the next page after the transition completes.
- Use `prefers-reduced-motion: reduce` to remove movement and blur. Use an opacity-only transition no longer than **120ms**.
- Theme switching is not a route change. It uses a short color fade, no page slide, no loading screen, and no route transition.

If the browser lacks View Transitions, use a temporary outgoing-page overlay while the new page is already present underneath. Animate old and new layers together. Remove the overlay after the animation. Do not fade to an empty body and then insert the destination.

#### Sidebar pin and navigation chrome idle state

Add one button to the top-left corner of the sidebar in all six page shells. Use a 24×24px hit area, 12px grayscale line icon, 1.5px stroke, round caps, and no label. Fix the button's x/y position relative to the panel; its location must not move when the panel expands. Set `aria-label` to `Pin sidebar` or `Unpin sidebar` and `aria-pressed` to the current pinned state. The control must support pointer and keyboard activation.

- Click to pin: keep the rail expanded and visible. Cancel/ignore the idle-hide timer while pinned.
- Click again to unpin: return to hover/focus expansion and normal idle-hide behavior.
- The pin icon must use existing grayscale tokens; do not add a dependency or a new icon font.
- Idle threshold: **1800ms** after pointer/keyboard/scroll activity.
- On idle, fade navigation chrome to opacity 0 and translate it **8px upward** over **220ms**. Do not blur the sidebar.
- On any pointer movement, key press, scroll, or focus entry, reveal chrome immediately and clear the idle timer.
- Do not hide chrome while the pointer is over it or keyboard focus is inside it.
- On pointer leave or focus leave, start the single shared idle timer.
- Reveal at least one visible, keyboard-accessible way to keep navigation available when the pointer is not moving. Do not add a new branded control. Use the existing sidebar/pin interaction if it exists; otherwise, the hidden state must reveal on keyboard focus and pointer movement.
- While idle chrome is hidden, the page content must reclaim the sidebar's reserved grid column smoothly. When chrome returns, restore the normal inset and keep the page content readable. No overlap, jump, horizontal scrollbar, or clipped card.
- Hide only navigation chrome. Keep page content, Import, section headings, reading controls, and the content's own actions visible.
- Retain the current sidebar hover expansion and account alignment. The icon and avatar X-axis must differ by no more than **1px** between collapsed and expanded states. The pin button position must also remain fixed.
- Focus indicators and accessible labels remain present. Hover-only interaction is not sufficient.

### Pass C — Interaction audit and correction loop

1. Inventory every interactive-looking element on all six pages. For each one, record its selector/label, expected action grounded in current owner intent, actual result, keyboard behavior, and evidence.
2. Test navigation, theme, browser history, rail expansion, selected-section indicator, tooltips, links, segmented controls, import/add actions, reader controls, journal links, reference picker, and note/highlight affordances.
3. Implement only behaviors already defined by the prototype and this contract. Do not invent backend behavior. If an existing affordance has no defined outcome, do not fake a success message; record it as unresolved and keep the interface honest.
4. Every defect becomes one entry in `design/REVIEW.md` with: defect ID, reproduction, screenshot/log evidence, root cause, bounded fix, test, result, and remaining risk.
5. If the owner corrects a result, follow GOVERNANCE Loop 2 in the same session. Preserve history; promote the correction to the right law/rule/contract and add a regression check only when the failure is mechanically testable.

## 4. Test matrix — mandatory

Run each of the six pages in both themes:

| Page | Dark | Light |
|---|---|---|
| Home (`index.html`) | Required | Required |
| Home (`home-light.html`) | Required | Required |
| Library | Required | Required |
| Archive | Required | Required |
| Journal | Required | Required |
| Reader | Required | Required |

Run at these viewport sizes: **1092×614**, **1440×900**, **1280×720**, and **1024×768**.

For every combination, record:
- Page renders with readable foreground/background contrast and no content obscured by navigation.
- No horizontal overflow or clipped main sections.
- No console errors or uncaught promise rejections.
- Sidebar state (hover, hidden, pinned, unpinned), section selection, icon/avatar axis, pin position, label visibility, and account handle are correct.
- Theme is consistent after section changes and after reload.
- Direct URL load works.
- Section route works without a new document load.
- Back and Forward restore the correct section and keep the selected theme.
- Reduced-motion mode disables route movement and blur.
- Hidden chrome returns with pointer movement, keyboard input, focus, or scroll; it does not hide while in use.
- Every visible interactive control gives its documented result or is recorded as unresolved.

At least one test pass must inspect **1092×614** because it matches the supplied recording. A test report must include actual browser name/version, date, viewport, commands or steps, pass/fail, and screenshot/log path. Commit any new test runner under `scripts/` before citing it. Do not cite ephemeral `/tmp` files as the only evidence. Never invent a screenshot or infer a visual pass from DOM values.

## 5. Regression requirements

Before reporting any pass:

1. Run `bash verify.sh` from the repository root. Fix every failure before continuing.
2. Check all changed HTML files parse. Check all local script and stylesheet URLs return success.
3. Confirm internal route clicks preserve the current document. Confirm theme clicks preserve URL and document.
4. Confirm a fresh page load uses saved theme. Confirm Back/Forward work after at least three section changes.
5. Capture before/after screenshots for Home dark/light, Library dark/light, and Archive dark/light, plus Journal and Reader in both themes. Store them under `design/preview/phase1/`; store the full 48-state result matrix at `design/preview/phase1/MATRIX.md`. The 1092×614 viewport must have before/after evidence because it matches the supplied recording.
6. Read the screenshots at native size. A rendered artifact must be viewed before any visual claim.
7. Request a fresh-context audit that reads this file, CONTRACT.md, DESIGN-SYSTEM.md, and the resulting evidence. The audit must challenge owner-intent interpretation, not just retest assumptions encoded by the builder.
8. Update `design/REVIEW.md`, `context/WORKLOG.md`, and `STATE.md`. Label every behavior claim **verified by run** or **not checked**.
9. Do not merge. Open a reviewable PR or leave the branch ready for owner inspection. Owner approval is required before shipping interpretive/destructive changes.

## 6. Definition of done

Phase 1 is complete only when all mandatory test combinations pass, the route and theme changes are in-place, no blank transition appears, idle and pinned navigation behave as specified, accessibility states work, all known visible controls have an audit result, `bash verify.sh` passes, a fresh-context audit has no blocking finding, and the rendered evidence has been viewed.

**No partial pass may be described as “fixed.” Report the exact passed matrix and the remaining failures.**
