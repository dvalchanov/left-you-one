# Prototype Progress

This is the shared status log for future product-design and implementation steps. Update it after every requested step; keep newest entries first and do not rewrite past observations to match later conclusions.

## Current status

- **Phase:** First accountless sender-to-recipient flow complete; real-person evaluation pending
- **Current objective:** Use the real handoff to evaluate association, the simulated `$2` commitment, recipient trust/reveal, and gentle possession
- **Prototype entry point:** `/start`; visual laboratory at `/dev/recipient-lab` in development/test
- **Last updated:** 2026-08-28
- **Updated by:** Codex

## Active step

- [x] Carry one stable Gift from sender discovery to a first holder in another browser

**Hypothesis being tested:** H2–H10 can now be evaluated through a believable handoff: authored discovery, genuine association, object-like value, the `$2` commitment, sender intention, recipient trust and opening, gentle possession, and basic provenance. Building the flow does not itself support those hypotheses.

**Scope:** Theme or Surprise me selection; idempotent Gift discovery; creator capability and clean management URL; sender reveal; recipient dedication and optional private note; simulated `$2` activation; replace/cancel while pending; isolated recipient claim; first-holder capability; optional public identity; privacy-safe public journey; development testing links; the selected Paper World default; per-Gift visual snapshots; responsive and reduced-motion coverage. The landing page and onward passing remain outside this step.

**Reversible assumptions:** The checked-in default is Paper World / A way through with Warm grain, Bottom left, Soft cover, Slow push, Soft grain, Paper edge, and Dark type; that resolved treatment is snapshotted per Gift; first claim happens when the opening gesture completes; intended recipient name is private dedication rather than identity; holder identity is optional and self-described; activation simulates `$2` without billing; and the sender manually shares the private link.

**Validation performed:** Full `bin/ci` passes in 44.11s: setup, 86-file RuboCop, dependency audits, Brakeman with zero warnings, 98 RSpec examples, and seed replant. Coverage includes the complete isolated flow, concurrent first-claim behavior, duplicate claim UI, public/private separation, saved-default integration, per-Gift visual stability, and a true `390 × 844` reduced-motion viewport. The application boots under Rails 8.1.3.1 and the idempotent import reports 21 templates.

## Completed steps

### 2026-08-28 — First sender-to-recipient core flow

- **Request:** After selecting the preferred visual combination, make it the prototype default and build the complete first sender-to-recipient flow so the product owner can experience the real sequence before deciding what comes next.
- **Changed:** Saved the selected Paper World treatment; snapshotted resolved visuals on each Gift; added `/start`, sender discovery and commitment scenes, simulated activation, clean creator management, private recipient claim, atomic first-holder creation, reusable holder access, optional identity, privacy-safe public provenance, sender status, link cancel/replace, development testing conveniences, focused services, and manual/technical documentation.
- **Hypothesis:** A stable object carried through two browsers can produce more trustworthy evidence about H2–H10 than a synthetic laboratory preview, especially at the association, `$2`, arrival, reveal, and possession moments.
- **Assumptions:** The first claim occurs on completed open; no payment record is useful in prototype mode; recipient dedication remains private; claim links are manually shared; creator/holder capabilities may remain reusable for controlled tests; one browser retains one creator or holder Gift role at a time; and changing the prototype visual default affects only future Gifts.
- **Validation and result:** Full `bin/ci` passes with 98 RSpec examples, zero RuboCop offenses, no dependency/importmap vulnerabilities, no Brakeman warnings, successful setup, and seed replant. Coverage includes two isolated roles, concurrent first claimant, already-claimed handling, optional identity, public privacy, selected/default integration, stable existing Gifts, keyboard opening, reduced motion, and phone-width overflow. The application boots and 21 development templates import idempotently. No people have tested the flow.
- **Evidence learned (if tested with people):** None. The implementation makes H2–H10 testable but does not validate them.
- **Open questions:** Whether claim-on-open feels natural; whether `$2` feels like commitment rather than buying words; whether the sender preview helps or lengthens the journey; whether “They wanted you to have it” is warm or redundant; whether the collage feels premium in the real handoff; and whether public provenance adds value after one stop.
- **Most useful next test:** Use the manual protocol with a real sender and their actual recipient in separate browsers, without explaining reverse gifting first; observe where association, commitment, trust, or emotional response weakens.

### 2026-08-27 — Arrival copy without invented causality

- **Request:** Replace the unnatural “Dimitar left you one” and avoid implying that the gift itself necessarily caused the sender to think of the recipient.
- **Changed:** The named arrival now reads “Dimitar left you something. They wanted you to have it.” The anonymous version follows the same pattern, and the product copy references were updated to use “one” only when its antecedent is clear.
- **Hypothesis:** Natural, motive-neutral language will preserve mystery and personal intention while allowing the sender’s real reason to range from spontaneous affection to usefulness or simple resonance.
- **Assumptions:** Wanting the recipient to have the object is the smallest reliable claim the handoff can make; singular “they” is preferable to inferring pronouns from a display name; and the surrounding “This is for you, Anna” line remains useful personal recognition even with some deliberate semantic overlap.
- **Validation and result:** Copy and documentation were checked for the superseded arrival lines. Focused model, request, view, and browser-system coverage passed with 30 examples, including named and anonymous arrival variants.
- **Evidence learned (if tested with people):** None. This is a product-owner copy refinement; H7 remains unresolved.
- **Open questions:** Whether “They wanted you to have it” adds warmth or merely repeats the handoff, and whether the simpler arrival should ultimately omit a context line altogether.
- **Most useful next test:** Show the revised sealed arrival without explanation and ask recipients who sent it, why they think it was meant for them, and what they expect to open.

### 2026-08-27 — Stable reveal-to-possession layout

- **Request:** Remove the strange jump where “You’re the first person it has been left with” appears and pushes the already revealed gift upward.
- **Changed:** The sender/recipient possession block now reserves its exact final layout footprint while remaining visually hidden, non-interactive, and `aria-hidden`. When possession settles in, only that block fades into its reserved space; the authored gift and note no longer move.
- **Hypothesis:** Keeping the revealed gift spatially stable will protect the reading moment and make possession feel like a quiet addition rather than a second layout event.
- **Assumptions:** The final with-you composition should determine the gift’s position from the start of reveal; reserving the actual responsive block is safer than estimating a fixed height or absolutely positioning content over the artwork.
- **Validation and result:** Focused view/system coverage passed with 18 examples. A geometry regression asserts that the gift heading’s top coordinate changes by no more than `0.5px` when possession appears at both `1280 × 800` and `390 × 844`. Setup, RuboCop, dependency audits, and Brakeman passed; the full 74-example RSpec suite and seed replant also passed.
- **Evidence learned (if tested with people):** None. This fixes an observed product-owner layout defect; H8 and H9 remain unresolved.
- **Open questions:** Whether the resulting initial revealed position feels equally composed across all artwork families and long-copy variants, and whether the reserved spacing is too generous before possession becomes visible on short screens.
- **Most useful next test:** Replay revealed-to-with-you on the strongest desktop and phone treatments and confirm that the copy now feels anchored while possession arrives without drawing attention to layout mechanics.

### 2026-08-26 — Deliberate opening and sender anticipation comparison

- **Request:** Improve the existing recipient UI into a more beautiful emotional moment for both the person opening it and the sender seeing what they are about to leave.
- **Changed:** Made the recipient’s name more personal in the arrival hierarchy; added a short hold that gradually warms and clarifies the veiled artwork; retained “Open it” as the primary label with a quiet hold hint; delayed possession until after a reading moment; added a sender point of view that previews the recipient’s opening and reframes the reveal around “You saw this and thought of Anna”; added the established simulated commitment and an explicit no-payment notice; exposed point of view and prototype price in the development laboratory; and prevented duplicate live-form events from resetting an in-progress preview.
- **Hypothesis:** A small embodied opening ritual may strengthen H8, while showing the sender the future recipient experience and naming the sender’s act of attention may strengthen H6 without making the sender self-congratulatory.
- **Assumptions:** The hold is roughly `1.05s`; releasing early returns to the sealed state; keyboard activation self-completes the warm-up; reduced motion opens immediately; the sender comparison reuses the recipient composition instead of implementing the sender flow; `$2` remains editable prototype copy; and the warm bloom remains a replaceable treatment.
- **Validation and result:** Focused model, view, request, and system coverage passed with 29 examples. The full `bin/ci` workflow passed with 73 RSpec examples, zero RuboCop offenses, no dependency or Brakeman warnings, and a successful seed replant. No product records are mutated, and the clean routes remain unavailable in production.
- **Evidence learned (if tested with people):** None. The interaction is implemented for comparison; H6 and H8 remain unresolved.
- **Open questions:** Whether holding feels intimate or merely slow; whether the warmer opening remains specific across all artwork families; whether the sender reflection feels affirming without praising the sender; whether `2.6s` before possession is enough reading room; and whether the sender should see a simulated recipient opening at all before commitment.
- **Most useful next test:** Give the same gift to real sender-recipient pairs, compare the hold with the earlier single-click opening, observe the recipient without explanation, and ask the sender what changed when they saw the future opening before the `$2` moment.

### 2026-08-26 — Serial removed from the reveal

- **Request:** Remove the unexplained `#008201`-style number from its current position in the revealed gift.
- **Changed:** Removed the prototype serial from the recipient-stage metadata while retaining the underlying gift and preview serial values for possible later use.
- **Hypothesis:** Removing unexplained system metadata from the emotional reveal will keep attention on the authored gift and sender connection.
- **Assumptions:** A serial may still be useful later for provenance or support, but no replacement location should be invented before that need is tested.
- **Validation and result:** Focused request, partial, and browser-system coverage passed with 19 examples, including an explicit assertion that no serial-shaped value appears in the revealed stage.
- **Evidence learned (if tested with people):** None. This records a product-owner visual decision.
- **Open questions:** Whether a serial is ever meaningful to recipients, and whether provenance belongs after possession or only in support tooling.
- **Most useful next test:** Observe the reveal without a serial and ask recipients what, if anything, they still need explained.

### 2026-08-26 — Brand-free recipient stage

- **Request:** Remove the `leftyou.one` text from the top-left corner of the recipient experience.
- **Changed:** Removed the persistent brand label and its unused positioning styles from the shared recipient stage. The development laboratory retains its own developer-only identity.
- **Hypothesis:** Letting the sender and gift establish context will make arrival feel more personal and less like a conventional branded webpage.
- **Assumptions:** Product identity is not required before opening in this controlled prototype; it can return later only if trust testing demonstrates a need.
- **Validation and result:** Focused request, partial, and browser-system coverage passed with 18 examples, including an explicit check that the shared recipient stage contains no persistent brand label.
- **Evidence learned (if tested with people):** None. This records a product-owner visual decision.
- **Open questions:** Whether recipients understand and trust an accountless capability link without visible product identity.
- **Most useful next test:** Show the clean link without explanation and ask recipients what they think it is before they open it.

### 2026-08-26 — Enticing artwork directions and ambient gutter

- **Request:** Explore another gutter treatment and make the recipient imagery more emotionally enticing, using vivid image or modern wave-like gradient directions as references.
- **Changed:** Kept the gutter near-black but added a very slow, artwork-keyed ambient color spill behind the stage. Added three replaceable local visual families: cinematic post-storm photography, saturated stippled illustration, and tactile paper collage. Existing `luminous`, `illustrated`, and `paper` template aliases now surface the new directions by default.
- **Hypothesis:** Stronger emotional color and atmosphere will make arrival feel worth opening, while a restrained gutter echo will connect the stage to the page without recreating a border or inset card.
- **Assumptions:** The supplied images are mood references rather than compositions to copy; the gutter should remain fundamentally black; the artwork, rather than an abstract full-stage gradient, is the more useful first comparison; all motion must remain ambient and optional.
- **Validation and result:** Rendered and inspected Radiant World and Paper World at `1440 × 900`, plus Color Current at `390 × 844`; the black gutter remains legible as page space while picking up a restrained artwork-colored edge, and arrival copy remains readable across light and dark treatments. Focused service/request/system coverage passed with 14 examples. The repository checks passed: setup, RuboCop, dependency audits, Brakeman, all 66 RSpec examples, and seed replant.
- **Evidence learned (if tested with people):** None. This responds to product-owner art-direction review.
- **Open questions:** Which of the three directions feels emotionally specific rather than generically beautiful, and whether the gutter spill is visible enough without calling attention to itself.
- **Most useful next test:** Compare the three new families on the same gift and arrival copy, then test the strongest image against a full-stage animated-gradient alternative only if the image still feels too literal.

### 2026-08-26 — Borderless arrival and restored dark gutter

- **Request:** Remove the unattractive border and inset section around the arrival content, and return the page-edge gutter to black.
- **Changed:** Restored the near-black outer page background and replaced the inset Closed frame treatment with a full-stage, borderless Soft cover treatment.
- **Hypothesis:** Letting arrival copy sit directly in the photographic world will feel calmer and less like a card nested inside another card.
- **Assumptions:** A dark gutter works when the sealed photograph retains enough color; the alternative seal does not need a literal frame to feel closed.
- **Validation and result:** The recipient browser suite was rerun before handoff.
- **Evidence learned (if tested with people):** None. This responds to product-owner visual review.
- **Open questions:** Whether Soft cover is distinct enough from Veiled image to remain a useful comparison treatment.
- **Most useful next test:** Compare Veiled image and Soft cover on the same three visual families and remove Soft cover if recipients cannot describe a meaningful difference.

### 2026-08-26 — Warm paper gutter

- **Request:** Change the page-edge gutter around the recipient stage from black to a light color.
- **Changed:** Set the clean recipient page background to warm paper (`#f1efe9`) while retaining the stage radius and restrained shadow.
- **Hypothesis:** A light gutter will separate dark photography from the browser edge and make the stage feel like a deliberately presented object.
- **Assumptions:** Warm off-white will feel calmer and less clinical than pure white across both dark and light visual families.
- **Validation and result:** The recipient browser suite was rerun before handoff.
- **Evidence learned (if tested with people):** None. This responds to product-owner visual review.
- **Open questions:** Whether the light gutter should remain constant or adapt subtly by family.
- **Most useful next test:** Compare Night Window and Quiet Light at desktop and mobile widths with the same gutter.

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
- The first flow currently claims on completed open; whether onward passing should use the same boundary remains undecided.
- Originator journey visibility, current-holder link rotation, pending-transfer replacement/expiry, and onward-passing price remain undecided.
- Public journey identity and location remain opt-in, coarse, and unverified if introduced.
- Persistent identity should be added only if accountless testing reveals a concrete need.
- “Someone probably needs this more than you do” is centralized as requested but may pressure a holder to pass; do not surface it without testing against the keep-is-valid guardrail.

## Known issues

- `Transfer#private_note` is plaintext at rest for the local prototype. It is filtered from parameter logs and ordinary serialization, but encryption must be revisited before storing real sensitive notes outside controlled local testing.
- Capability expiry, recovery, production rotation/revocation, and onward-pass token rotation are not implemented.
- The core flow begins at `/start`; the landing demonstration and root product route are intentionally not implemented.
- The Rails-generated Minitest scaffold remains, while product-domain coverage uses RSpec.
