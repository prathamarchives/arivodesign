# CONTRACT — the Arivo experience contract

The design-side product contract: what the Arivo experience IS, expressed as obligations every rendered artifact must satisfy. This is one of the repo's first-class assets (the ENGINEERING doctrine: product contract + golden path + one verify command). It renders the backend's fixed contracts (Arivoo D-023, D-030, D-031) and the owner's vision words from the Arivoo raw corpus — it NEVER renames, reinterprets, or drops an object.

Every artifact produced in the paint phase cites the invariants it implements (R-D05). A rendered screen that breaks an invariant is invalid, no matter how good it looks.

## Part 1 — Objects (rendered from the backend contracts)

| Object | Contract (from Arivoo) | Design obligation |
|---|---|---|
| **Work** | the unit of reading (a book, paper, text) — D-023 | a library and an open-reading surface that feel like handling real books; currently-reading is visible at all times |
| **Source** | any readable format is admissible — D-031 | import paths must never make the owner feel format friction |
| **Highlight** | capture anchored to passage — D-023 | capture happens IN the reading flow, never via a modal pilgrimage; nothing durable can be silently lost (losing a highlight = intolerable failure, owner raw corpus) |
| **Anchor** | the precise passage linkage — D-023 | anchors are visual and precise; the passage is always re-findable |
| **Bookmark** | position memory — D-023 | returning to a Work resumes exactly where reading stopped |
| **Note** | raw thinking WITH diagrams — D-023 | notes feel like pen/pencil rough work, not sticky notes, not sterile forms; freeform + diagram-capable |
| **Journal block** | end-of-day page, writing lab — D-023 | the journal is a daily page and a laboratory ("where i write posts, experiment, raw writing") — rough, alive, personal |
| **@-reference** | passage ↔ work linkage everywhere — D-023 | @ is a first-class interaction across reading, notes, journal; references render as living links back to the anchored passage |
| **Concept** | growing personal-wikipedia entities | concepts visibly grow as highlights/notes accrue — compounding made visible |
| **Classification word** | free text, never an imposed tag system — D-030 | free-text words in, no taxonomy UI, no required fields, no mandatory dropdowns |

## Part 2 — Experience invariants (the walls for the paint phase)

- **X-01 · The book is the interface.** While reading, chrome recedes to near-invisibility; the text is the screen. [L-01; owner vision: "just like a book", "clean minimalistic UI, rounded corners, not sloppy"]
- **X-02 · Capture without leaving.** Highlight, note, and classification happen in place, at the passage, in one gesture's reach. [X-01 + D-023; two-speed capture: instant then provisional]
- **X-03 · Nothing durable is lost.** No highlight, note, journal line, or position can vanish through a design path — optimistic capture, visible save state. [owner raw corpus: losing-a-highlight is an intolerable failure]
- **X-04 · Raw aesthetic for thinking surfaces.** Notes and journals render with the honesty of pen on paper — rough-edged, diagram-friendly, personal — while the reading surface stays clean and typographic. [owner vision: "raw pen/pencil... rough work", "notes are raw thinking"]
- **X-05 · Two speeds everywhere.** Instant capture first; structure and refinement are provisional and optional, never blocking. [Arivoo P-10]
- **X-06 · Compounding is visible.** The library, currently-reading, growing concepts, and the compounding digest are present as living surfaces — the system should feel like "a whole new brain forming up". [owner vision]
- **X-07 · Desktop-first chrome.** Keyboard-friendly, generous layout for large screens; smaller screens adapt later without renegotiating X-01–X-06. [L-05, D-001]
- **X-08 · No imposed taxonomy.** No tag trees, no required categories; classification is free-text words at capture speed. [D-030]
- **X-09 · @ is everywhere.** Passage ↔ work reference is reachable from reading, notes, and journal with the same gesture and renders consistently everywhere. [D-023]
- **X-10 · Lookup in place.** Dictionary/reference lookups happen at the passage, without ejecting the reader from the book. [owner vision: dictionary feature]

## Part 2b — Visual-language invariants (locked by the owner's vision turn)

- **X-11 · One motion system everywhere.** Sidebar, overlay, pages, cards — all structural movement shares one easing family, and movement carries the blur treatment. Consistency is the law: "same animation/motion rules and everything same as the sidebar... keep like this consistency allover". [INT-004]
- **X-12 · Grayscale discipline.** Grey and white only, in both themes — "the colour accents would be grey and white thats it". No hue anywhere unless the owner later unlocks it. [INT-004]
- **X-13 · No sharp corners.** Radii on every surface, pills where pill-like, round caps even in icons. [INT-004]
- **X-14 · Glass on elevation.** Floating/elevated surfaces are translucent with backdrop blur at the locked levels (clear/frosted/blur) and hairline borders. [INT-004 + refs]
- **X-15 · Hover is a first-class state.** Detailing on hover everywhere — lifts, border brightens, reveals — micro, never bouncy. [INT-004 "detialing on hover nad everything"]
- **X-16 · Typography is Helvetica.** One family, the locked scale; the wordmark is the only exception (Rounded Bold). [INT-004]

## Part 3 — The golden path (the experience arc the design must serve end-to-end)

Import/read a Work → read with zero chrome → capture a highlight at the passage → classify it with free-text words (or leave it raw) → jot a raw note or diagram → end the day in the journal page → @-link a passage into a note/journal → watch concepts grow → receive the compounding digest.

Every phase of design work must keep this arc walkable. A design that breaks the arc is invalid even if each screen is pretty.

## Part 4 — Verification

- Invariants X-01..X-10 are the checklist for every painted artifact (Loop 3 self-review, Loop 4 verification).
- The mechanical half (`verify.sh`) guards the repo; the experiential half is judged against this contract, labeled per L-16.
- Contract changes follow L-08 (append-only, supersede by reference) and require an INT grounding — the contract renders owner intent, it does not invent it.
