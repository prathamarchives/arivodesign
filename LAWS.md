# LAWS — arivodesign

Hard constraints. An agent that violates a law produces invalid work regardless of output quality. Laws are append-only: never rewritten to change meaning — a superseded law gets a `STATUS: superseded by L-xx` line and its successor carries the next number. Every law cites its grounding (owner intent → INT entry → raw turn). Justification and operating procedure live in PRINCIPLES.md and GOVERNANCE.md, not here: laws state the constraint, nothing else (constraint ladder — prose last).

## The ladder

When constraints conflict, the higher rung wins. C0 is the product itself; C1–C4 protect the system that makes C0 possible; C5–C6 are hygiene.

- **C0 — The experience is the product.**
- **C1 — Owner sovereignty.**
- **C2 — Memory and continuity.**
- **C3 — Drift control.**
- **C4 — Quarantine and safety.**
- **C5 — Epistemics (what may be claimed).**
- **C6 — Sizing (how the system grows).**

---

### C0 — The experience is the product

**L-01 · Reading is the heart.** The reading experience is the product's core; all interface chrome recedes while reading. No design decision may add friction to the act of reading itself — administrative surfaces (settings, sync, governance views) live on secondary screens, never inside the reading flow.
*Grounds: INT-001; the owner's vision narrative in the Arivoo raw corpus ("just like a book").*

### C1 — Owner sovereignty

**L-02 · Owner words are sovereign and verbatim.** Owner intent enters the repo ONLY through verbatim capture in `context/raw/` and an INTENT-LEDGER entry, before any work that depends on it. Paraphrase is interpretation — labeled as such, never a substitute for the verbatim record.
*Grounds: INT-001 ("you don't lose the owners intent aka my words").*

**L-03 · The ledger is the only intent authority.** No document, artifact, or claim in this repo may assert owner intent without citing an INT id. Uncited intent claims are void and must be corrected on sight.
*Grounds: INT-001; Arivoo governance pattern.*

**L-04 · Walls before paint.** No UI design artifact (HTML, CSS, component, layout, color, interaction spec) may exist in this repo until the kernel (LAWS, RULES, CONTRACT, PRINCIPLES, DECISIONS) and the harness (GOVERNANCE, verify.sh) are standing and mutually consistent. The paint phase begins only after the system exists.
*Grounds: INT-002 ("we;ll not hop on the designing... but first the walls and harness and kernel"); INT-003.*

**L-05 · Desktop-first.** Every design decision optimizes the desktop experience first; smaller screens adapt downstream, never at the cost of the desktop experience.
*Grounds: INT-002 ("dekstop-first i guesss" — leaning, held as working decision D-001 until the owner revisits).*

**L-06 · Self-extraction is mandatory.** When owner text contains an intent, constraint, preference, correction, or goal — stated or implied — the agent captures it verbatim and ledgers it WITHOUT being asked, before doing anything else with that turn.
*Grounds: INT-003 ("it writes its own intents when sees one in text").*

### C2 — Memory and continuity

**L-07 · Raw is sacred.** `context/raw/` is append-only: never edited, never deleted, never reformatted, never summarized in place. Corrections apply as new entries that reference the old.
*Grounds: INT-001 (repo as long-term memory); Arivoo doctrine.*

**L-08 · Append-only governance.** LAWS, RULES, DECISIONS, PRINCIPLES, CONTRACT, and the INTENT-LEDGER are never rewritten to change meaning. Supersede by reference: add the successor, mark the predecessor. WORKLOG and STATE are append/update per their own protocols.
*Grounds: INT-001; Arivoo governance pattern.*

**L-09 · Corrections codify same-session.** When the owner corrects agent work, the correction becomes (a) a verbatim capture, (b) a ledger entry, and (c) a promoted law/rule/contract-invariant — in the same session — and the broken artifact is repaired before push. An uncoded correction is a lost correction.
*Grounds: INT-003 ("agent did work, made mistake, i correct it. now it should be a law/rule or something automatically by agent").*

**L-10 · Continuous commit.** Work is committed and pushed as it lands, in small verified increments. Unpushed work is unfinished work; chat-only knowledge does not exist.
*Grounds: INT-001 ("repo as an long term memory"); Arivoo P-15 pattern.*

### C3 — Drift control

**L-11 · Read-order discipline.** Every agent session starts with the AGENTS.md read order (the full kernel, ledger, state, worklog tail, latest raw turns) and ends with the exit gate (STATE update, WORKLOG entry, push). Skipping either is a violation, not a style choice.
*Grounds: INT-003 ("tighethen it. so agent doesnt drift").*

**L-12 · Provenance or void.** Every design artifact, decision, rule, and law cites what grounds it (INT id, and the Arivoo decision or raw-corpus source where inherited). Unanchored artifacts are invalid.
*Grounds: INT-003 ("own rules and own lawsn and own constriants"); INT-001.*

**L-13 · Verify before claim.** `bash verify.sh` must pass before any push, and every claim of completion or quality carries an evidence label. Working past a failed verify is forbidden.
*Grounds: INT-003 (verification loop); Arivoo ENGINEERING ("protect the verifier", one verify command).*

### C4 — Quarantine and safety

**L-14 · Old Arivo is quarantined.** No code, design, pattern, palette, layout, iconography, or interaction idea may be inherited from the archived `prathamarchives/Arivo` repo or any of its artifacts — in whole or in part, directly or by paraphrase. Its existence is a warning, not a reference.
*Grounds: INT-002 ("archived for a reason all code and design is slop... please don't go on that path").*

**L-15 · No secrets in the repo.** Credentials, tokens, and personal filesystem paths never enter tracked files; redact at ingestion; secrets live in the environment only.
*Grounds: INT-001 credential handling; Arivoo D-025 / INT-092.*

### C5 — Epistemics

**L-16 · Evidence honesty.** Every claim of completion, quality, or behavior carries exactly one evidence label: "verified by run" or "not checked". Experience claims are never "verified" without a rendered artifact a human or agent has actually viewed.
*Grounds: INT-003 (verification loop); Arivoo evidence doctrine.*

**L-17 · STATE is navigation, not authority.** STATE.md points and orients; on any conflict, canonical documents (ledger, laws, contract) win.
*Grounds: Arivoo D-027 pattern, inherited.*

### C6 — Sizing

**L-18 · Grow on failure or directive, never on speculation.** New governance files, rules, or checks are added only when a real failure, a real owner correction, or an explicit owner directive demands them. No speculative ceremony — this repo builds a product, and governance serves the product.
*Grounds: INT-001 ("the right way this time" — the owner's verdict that Arivoo is "a lil bit over engineered"); Arivoo ENGINEERING growth stages.*


---

### C0 — Continuity of the experience

**L-19 · Route and theme state are shared.** An in-prototype section change must not replace the document. A theme change must not navigate to a second theme-specific document. The selected theme persists across every prototype section, and browser history must remain usable.
*Grounds: INT-028; current source inspection of `design/index.html`, `design/home-light.html`, `design/library.html`, `design/archive.html`, `design/journal.html`, `design/reader.html`.*

**L-20 · Structural motion must not obscure the product.** Route motion must keep the outgoing or incoming page visible. A blank transition, full-viewport blur, or overlay that makes the page unreadable is a defect. Reduced-motion mode must remove movement and blur.
*Grounds: INT-028 and the owner-supplied recording; CONTRACT X-11/X-14.*

**L-21 · Idle chrome must remain recoverable.** Hiding navigation chrome is allowed only after the fixed idle interval. Pointer, keyboard, scroll, and focus activity must reveal it. Focused or hovered navigation must not disappear. The content must not be clipped when the chrome hides or returns.
*Grounds: INT-028; CONTRACT X-07/X-11/X-15.*
