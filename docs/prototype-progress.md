# Prototype Progress

This is the shared status log for future product-design and implementation steps. Update it after every requested step; keep newest entries first and do not rewrite past observations to match later conclusions.

## Current status

- **Phase:** Recipient visual laboratory complete; real-person evaluation pending
- **Current objective:** Compare whether arrival, opening, and possession feel like a small memorable event rather than a generated quote
- **Prototype entry point:** `/dev/recipient-lab`; clean view at `/dev/recipient-preview` in development/test
- **Last updated:** 2026-08-26
- **Updated by:** Codex

## Active step

- [x] Design the gift’s visual form and recipient experience

**Hypothesis being tested:** H7–H10 can now be evaluated: personal recognition and trust at arrival, a felt opening moment, gentle possession, and journey interest without obligation. Building the laboratory does not itself support those hypotheses.

**Scope:** Six local photographic placeholder families, three sealed treatments, one reusable recipient stage, five preview states, clean and controlled development routes, responsive and reduced-motion behavior, and recipient visual/experience documentation.

**Reversible assumptions:** Veiled image is the default seal; a serif-led type voice; sender note after authored copy; origin and prototype serial at reveal; possession after roughly 1.85 seconds; synthetic journey places counted as country stops; six configuration-driven families using generated placeholder artwork.

**Validation performed:** The full `bin/ci` workflow passed: setup, RuboCop, dependency audits, Brakeman, 65 RSpec examples, and seed replant. Rails eager loading passed. A production-environment request returned 404 for the clean preview. Desktop and mobile screenshots were inspected, including long content, and no remote image hotlinks or domain mutations were introduced.

## Completed steps

### 2026-08-26 — Live recipient-lab updates

- **Request:** Remove the manual “Update preview” action and refresh the recipient preview whenever a laboratory control changes.
- **Changed:** Selects and toggles now refresh immediately; text and number fields refresh after a short debounce. Reset remains available with the other laboratory actions.
- **Hypothesis:** Immediate comparison will make visual iteration faster and reduce interface friction in the development tool.
- **Assumptions:** A `280ms` typing debounce feels live while avoiding an iframe reload for every keystroke.
- **Validation and result:** Browser coverage now changes the sender name and observes the embedded clean preview update without submitting the form.
- **Evidence learned (if tested with people):** None. This is development-tool ergonomics.
- **Open questions:** Whether rapid image-treatment changes should preserve the current opened state or continue using the selected state.
- **Most useful next test:** Use the live controls during a visual comparison session and adjust the debounce only if it feels laggy or disruptive.

### 2026-08-26 — Brighter sealed-arrival treatment

- **Request:** Make the first recipient screen less black and underwhelming while keeping the image unclear.
- **Changed:** Rebalanced the default veil to preserve substantially more brightness and color, reduced blur and desaturation, added a restrained cool/warm glass sheen, and weakened the extra-dark Night Window arrival overlay.
- **Hypothesis:** A visible but unresolved photographic world will create more curiosity and emotional presence than a nearly black sealed stage.
- **Assumptions:** The image should be recognizable as atmosphere but not clear enough to feel already opened; the copy still needs reliable contrast over every family.
- **Validation and result:** Rendered Night Window at `1440 × 900` and Quiet Light at `390 × 844`. Both now retain visible photographic color and structure beneath the seal while keeping the image unresolved and the arrival copy readable. The focused visual check passed; the recipient system suite was rerun before handoff.
- **Evidence learned (if tested with people):** None. This responds to product-owner visual review, not recipient observation.
- **Open questions:** Whether the image is now intriguingly obscured or simply blurred, and whether different families need individual veil strengths.
- **Most useful next test:** Compare the revised Night Window, After Rain, and Quiet Light arrival states side by side before changing the reveal timing.

### 2026-08-26 — Recipient visual system and opening laboratory

- **Request:** Build only the gift’s reusable visual form and recipient experience, plus development-only tools for repeated comparison.
- **Changed:** Added six editorial prototype backgrounds and visual-family configuration; three sealed treatments; arrival, opening, revealed, with-you, and existing-journey states; a reusable stage with I18n copy; clean and laboratory routes; Stimulus reveal and lab controls; responsive, keyboard, focus, tab-pause, and reduced-motion behavior; and visual/recipient documentation.
- **Hypothesis:** Enables direct evaluation of H7–H10 and the question of whether receiving feels like a small memorable event rather than opening a generated quote.
- **Assumptions:** Veiled image is the working default because it preserves object continuity without gift-box or reward imagery. Artwork is generated placeholder material. Preview names, note, serial, holder count, and journey are synthetic and do not imply real transfer state.
- **Validation and result:** The full `bin/ci` workflow passed, including 65 RSpec examples, RuboCop, dependency audits, Brakeman, setup, and seed replant. Rails eager loading passed. Configuration, request, partial, and browser-system coverage includes named/anonymous and short/long content, keyboard opening, focus, reduced motion, mobile layout, journey, safe fallbacks, production isolation, and zero domain mutation. Desktop and phone screenshots were inspected and the long-copy scale and clean-route metadata were refined. No people have tested the experience.
- **Evidence learned (if tested with people):** None. H7–H10 remain unresolved.
- **Open questions:** Whether the opening feels emotional or precious, whether the private note adds or overwhelms value, which family best fits the product, whether “with you” reads naturally, and whether origin/journey context should arrive later.
- **Most useful next test:** Give clean preview links to real sender-recipient pairs without explaining the product, observe arrival interpretation and opening reactions, then compare the six families and three seals in the lab.

### 2026-08-26 — Accountless technical foundation

- **Request:** Build only the Rails foundation and smallest reversible accountless domain needed for the prototype.
- **Changed:** Added `GiftTemplate`, `Gift`, `Transfer`, and `JourneyStop`; PostgreSQL integrity constraints; capability-token issuance/validation; transactional discovered-gift creation; centralized display configuration and copy; an idempotent curated template import; RSpec/FactoryBot; and domain/configuration documentation.
- **Hypothesis:** Creates the technical base for later testing without pre-deciding accounts, final transfer rules, payment, or the visual experience.
- **Assumptions:** Recipient names are dedications; public slugs grant no control; raw capabilities are returned only at issuance; a holder remains in place while a later transfer is pending; journey stops represent claimed handoffs only.
- **Validation and result:** Database migration and 21-template development import succeeded. Import idempotency, model behavior, services, token handling, and database constraints are covered by 41 passing RSpec examples. The full `bin/ci` workflow passed, including RuboCop, dependency audits, Brakeman, RSpec, and seed replant; Rails also eager-loaded successfully. No people have tested the experience.
- **Evidence learned (if tested with people):** None. Product hypotheses remain unresolved.
- **Open questions:** Exact claim semantics, old-link behavior, note timing, location consent, passing price and withdrawal, and whether persistent identity ever adds enough value.
- **Most useful next test:** Build the smallest art-directed discovery/reveal sequence that can test H1–H4 before adding the full transfer flow.

## Hypothesis status

- H1–H12 remain unresolved; no participant evidence was collected in this step.

## Open decisions

- Pricing, categories, final theme set, and exact gift anatomy remain hypotheses.
- Whether a landing example can become a real gift should be tested in the experience.
- Claim versus open versus explicit accept semantics remain undecided; the schema supports a later transactional choice.
- Originator journey visibility, current-holder link rotation, pending-transfer replacement/expiry, and onward-passing price remain undecided.
- Public journey identity and location remain opt-in, coarse, and unverified if introduced.
- Persistent identity should be added only if accountless testing reveals a concrete need.
- “Someone probably needs this more than you do” is centralized as requested but may pressure a holder to pass; do not surface it without testing against the keep-is-valid guardrail.

## Known issues

- `Transfer#private_note` is plaintext at rest for the local prototype. It is filtered from parameter logs and ordinary serialization, but encryption must be revisited before storing real sensitive notes outside controlled local testing.
- Capability authorization routes, cookies, rotation, and claim/pass transactions are not implemented.
- There is intentionally no root product route or user-facing experience yet.
- The Rails-generated Minitest scaffold remains, while product-domain coverage uses RSpec.
