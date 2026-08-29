# Prototype Progress

This is the shared status log for future product-design and implementation steps. Update it after every requested step; keep newest entries first and do not rewrite past observations to match later conclusions.

## Current status

- **Phase:** Public overview and first accountless sender-to-recipient flow complete; real-person evaluation pending
- **Current objective:** Use the landing page and real handoff to evaluate premise comprehension, association, the simulated `$2` commitment, recipient trust/reveal, and gentle possession
- **Prototype entry point:** `/`; sender discovery at `/start`; visual laboratory at `/dev/recipient-lab` in development/test
- **Last updated:** 2026-08-28
- **Updated by:** Codex

## Active step

- [x] Explain the product publicly and carry one stable Gift from sender discovery to a first holder in another browser

**Hypothesis being tested:** H1–H10 can now be evaluated through a public orientation and believable handoff: premise comprehension, authored discovery, genuine association, object-like value, the `$2` commitment, sender intention, recipient trust and opening, gentle possession, and basic provenance. Building the flow does not itself support those hypotheses.

**Scope:** Public product overview with curated read-only paths; Theme or Surprise me selection; idempotent direct Gift discovery; creator capability and clean management URL; named recipient and optional private note; simulated `$2` activation; replace/cancel while pending; isolated recipient claim and reveal; automatic private JourneyStop identity; first-holder capability; private read-only journey for creator and holder; development testing links; the selected Paper World default; per-Gift visual snapshots; responsive and reduced-motion coverage. Onward passing remains outside this step.

**Reversible assumptions:** Landing paths are curated fictional examples and never expose or become real Gifts; the checked-in default is Paper World / A way through with Warm grain, Bottom left, Soft cover, Slow push, Soft grain, Paper edge, and Dark type; that resolved treatment is snapshotted per Gift; first claim happens when the opening gesture completes; intended recipient name becomes a private journey label automatically; location is not collected; activation simulates `$2` without billing; and the sender manually shares the private link.

**Validation performed:** Full `bin/ci` passes in 40.13s: setup, 87-file RuboCop, dependency audits, Brakeman with zero warnings, 103 RSpec examples, and seed replant. Coverage includes public landing comprehension, read-only path exploration, isolation from real private records, bounded tall-desktop hero geometry and title hierarchy, immediate sender discovery without an opening control, the complete isolated recipient opening, automatic private journey identity, private journey authorization, public-name redaction, concurrent first-claim behavior, the clean duplicate-claim UI, saved-default integration, per-Gift visual stability, and true `390 × 844` viewport coverage. The application boots under Rails 8.1.3.1 and the idempotent import reports 21 templates.

## Completed steps

### 2026-08-28 — Rebalanced the landing Gift hierarchy

- **Request:** Correct the landing hero after clarifying that the problem was the large example card and its title competing with the main product claim, not only the surrounding whitespace.
- **Changed:** Made the desktop example Gift a deliberately smaller supporting object with a maximum `36rem` width and a stable `4:5` proportion. Reduced its internal headline scale on desktop and phone while leaving the actual recipient Gift experience untouched. The page claim now remains visibly dominant and the example reads as proof of the idea rather than a second hero.
- **Hypothesis:** A clear claim-first, object-second hierarchy will help a new visitor understand the product before inspecting the example Gift.
- **Assumptions:** The public example should be legible but quieter than both the landing claim and the private recipient reveal; the latter should retain its immersive scale.
- **Validation and result:** Focused landing request and browser coverage passes with five examples. Fresh `1500 × 1578` desktop and `390 × 844` phone renders were inspected. The desktop regression caps the example at `580 × 730px`, requires the main headline to be at least `1.45×` the Gift headline, and checks for horizontal overflow. Full `bin/ci` passes in 40.13s with 103 examples, no RuboCop offenses, clean dependency audits, zero Brakeman warnings, and a successful seed replant.
- **Evidence learned (if tested with people):** None. This corrects an observed product-owner hierarchy defect.
- **Open questions:** Whether the quieter example is now at exactly the right physical scale in the original browser window.
- **Most useful next test:** Reopen `/` at the reported window size and judge whether the eye now lands on the product claim first and the Gift second.

### 2026-08-28 — Corrected landing hero scale on tall desktops

- **Request:** Fix the landing hero because its scale looked wrong on a tall desktop screenshot.
- **Changed:** Capped the hero’s responsive minimum height at `62rem` instead of allowing it to grow with the full viewport indefinitely. The Gift retains its existing maximum size, but the composition now begins near the top with balanced padding and lets the following purpose section enter naturally rather than floating the hero inside a large empty field.
- **Hypothesis:** A bounded editorial hero will preserve the intended title-to-Gift relationship across ordinary and unusually tall desktop viewports without changing the phone composition.
- **Assumptions:** The root page does not need to monopolize a tall viewport; showing the beginning of the next scene is preferable to enlarging the Gift beyond its useful reading scale.
- **Validation and result:** Focused landing request and browser coverage passes with five examples. A new geometry regression at `1500 × 1578` asserts that the hero remains at or below `1000px`, the Gift begins within `40–110px` of the hero top, and the document does not overflow horizontally. A fresh tall-desktop render was inspected against the reported `3000 × 3156` Retina screenshot. Full `bin/ci` passes in 46.15s with 103 examples, no RuboCop offenses, clean dependency audits, zero Brakeman warnings, and a successful seed replant.
- **Evidence learned (if tested with people):** None. This fixes an observed product-owner layout defect.
- **Open questions:** Whether the capped height still feels balanced on ultra-wide displays with a short browser window.
- **Most useful next test:** Reopen `/` at the original window size and confirm the hero now reads as one composed spread rather than a small composition suspended in empty space.

### 2026-08-28 — Public landing overview and read-only example paths

- **Request:** Implement the `/` landing page so a new visitor can understand what the product is for, how to begin, and what a Gift path can look like; let people explore paths without joining one, because receiving requires a private invitation, while still allowing them to start a new Gift.
- **Changed:** Added an editorial root page with a clear reverse-gifting premise, one complete authored example, a four-part lifecycle, three expandable illustrative paths, and a final invitation boundary. Every example is explicitly read-only and offers no claim or join action. The page loads no real Gift, Transfer, or JourneyStop records, so private names, notes, slugs, and journey data cannot become a public feed. All start actions enter the existing `/start` discovery flow.
- **Hypothesis:** A calm public overview can make H1 understandable before a visitor begins while the large example and path stories preserve enough product feeling to avoid reading like generic marketing.
- **Assumptions:** Curated fictional paths are sufficient for this first orientation pass; real journeys remain private; landing examples do not become sendable Gifts; the eventual possibility of multiple holders can be explained even though onward passing is not implemented yet.
- **Validation and result:** Focused request coverage confirms the page story, three examples, start link, absence of controls within paths, and isolation from real private records. Browser coverage confirms path expansion, transition into `/start`, and no horizontal overflow at `390 × 844`. Fresh desktop and phone renders were inspected across the hero, purpose, lifecycle, paths, invitation boundary, and footer. Full `bin/ci` passes in 41.05s with 102 examples, no RuboCop offenses, clean dependency audits, zero Brakeman warnings, and a successful seed replant.
- **Evidence learned (if tested with people):** None. This implements the product owner's requested first pass; H1 and the usefulness of public path examples remain unresolved.
- **Open questions:** Whether the overview explains too much before discovery; whether example paths deepen the concept or make it look like a feed; whether real journeys should ever support an intentionally public, privacy-safe version; and whether the earlier interactive landing demonstration would create stronger association.
- **Most useful next test:** Give `/` to a new visitor without explanation, ask what the product is and how somebody receives one, then observe whether they explore paths or start a Gift first.

### 2026-08-28 — Direct sender discovery with a clear handoff story

- **Request:** Make the real sender flow understandable and emotionally stronger: remove the recipient-like hold-and-open step from discovery, explain what the discovered object is, remove the unclear “You found this,” and clarify why leaving it for someone matters.
- **Changed:** The sender now sees the complete authored Gift immediately after choosing a feeling; only the recipient receives the sealed hold-and-open ritual. The start copy states the reverse-gifting sequence directly. Discovery now says the Gift is not for anyone yet, keeps “Who came to mind?”, and explains that the named person will open this exact Gift from the sender with any private note. Removed the duplicate “You found this” eyebrow and the obsolete creator-reveal route.
- **Hypothesis:** Separating sender discovery from recipient opening, while naming the handoff in one short sentence, will make the product mechanism understandable and let the Gift itself create the emotional association.
- **Assumptions:** The sender’s discovery does not need a ceremony separate from seeing the Gift; visual scale and authored content provide the looking moment; “this exact gift from you” communicates intention without claiming why the sender chose the recipient.
- **Validation and result:** Focused service, request, and two-browser system coverage passes. Fresh desktop and phone renders confirm that discovery opens directly on the complete Gift, the obsolete sender opening control is absent, the unclear duplicate eyebrow is gone, and the association explanation remains legible with both honest actions. Full `bin/ci` passes in 38.43s with 98 examples, no RuboCop offenses, clean dependency audits, zero Brakeman warnings, and a successful seed replant.
- **Evidence learned (if tested with people):** None. This implements the product owner's flow correction and does not validate association or recipient response.
- **Open questions:** Whether the revised discovery creates an immediate specific-person reaction, and whether the short explanation is sufficient without feeling instructional.
- **Most useful next test:** Give a new sender `/start` with no verbal explanation and ask what they think will happen, who comes to mind, and what they expect the named recipient to receive.

### 2026-08-28 — Automatic possession and private journey

- **Request:** Rework the flow as a coherent product experience: remove the unexplained post-open identity form, stop asking recipients to add themselves or supply city/country, explain why the Gift and journey were appearing together, and make journey recording automatic from information already known at the handoff.
- **Changed:** Made the recipient's first name or nickname required when the sender prepares the handoff. Claiming now records that name automatically on the JourneyStop while keeping it private. The recipient remains in the revealed Gift through possession with no appended form, anonymous-choice button, location fields, holder-access controls, sender navigation, or dead passing placeholder. Added a separate read-only journey screen reachable deliberately by the current holder or creator; the public slug cannot open it. Used-claim links now return to a calm already-opened state rather than redirecting into the public Gift. Location is neither requested nor inferred.
- **Hypothesis:** A continuous arrival-to-possession experience, with provenance recorded as a consequence of opening rather than a task afterward, will make the recipient understand where they are and preserve the emotional ending.
- **Assumptions:** A sender knows the recipient name needed for this personal handoff; that name is useful inside the private journey but should not be published automatically; geography adds insufficient value to justify collection or inference; journey is optional context, not a required completion step.
- **Validation and result:** Service and request coverage confirms automatic private identity, no location, private journey authorization for holder and creator, public-name redaction, and the clean used-link state. The complete desktop and phone browser flow passes without identity fields or horizontal overflow. Fresh `1280 × 800` and `390 × 844` renders confirm that possession remains inside the Gift and the separate journey reads clearly without repeating the Gift or the current holder. Full `bin/ci` passes in 43.62s with 98 RSpec examples, zero RuboCop offenses, clean dependency audits, zero Brakeman warnings, and a successful seed replant.
- **Evidence learned (if tested with people):** None. This implements the product owner's direct flow correction; it does not yet validate journey value with recipients.
- **Open questions:** Whether journey deserves a visible link after only one stop, and how creator access should behave after later onward passes.
- **Most useful next test:** Send one Gift without explaining journey mechanics, observe whether the recipient understands that opening completes receipt, and only then ask whether “See how it got here” adds meaning or distraction.

### 2026-08-28 — Composed post-open sender update

- **Request:** Improve the sender page after the recipient opens the Gift; the large message, journey action, and private note did not look cohesive beneath the revealed artwork.
- **Changed:** Kept the revealed Gift as the emotional proof of opening, then rebuilt the lower area as a compact responsive journey update containing only the opening status and optional public-journey action. Removed the duplicated private-note block because the sender's note is already visible inside the revealed Gift, removed the unused copy-status space from this state, and tightened its overall vertical rhythm.
- **Hypothesis:** A composed status area will let the sender register that the handoff succeeded without making the administrative update compete with the Gift itself.
- **Assumptions:** The sender should still see the Gift fully revealed after opening; showing the private note once within that Gift is sufficient context; public journey remains a small optional action rather than the next required step.
- **Validation and result:** Fresh claimed-state renders were inspected at `1280 × 800` and `390 × 844`; the update now follows the revealed Gift without repeating its note. Browser coverage checks the claimed composition in the complete two-browser flow and confirms that its phone layout does not overflow.
- **Evidence learned (if tested with people):** None. This is a product-owner design refinement; the emotional value of sender status remains untested.
- **Open questions:** Whether the public-journey action is useful after only one stop, and whether the sender wants any notification-like status beyond this page.
- **Most useful next test:** Reopen the sender link after a real recipient claims the Gift and ask what the sender notices first and whether they want to follow the journey.

### 2026-08-28 — A visibly sealed sender-success state

- **Request:** Rework the sender success page because the open Gift above “It’s sealed and waiting” did not feel convincing; explore an envelope or frame.
- **Changed:** Replaced the open Gift in the pending sender-status hero with a tactile closed paper envelope addressed to the recipient, marked from the sender, and held over a softened version of the Gift’s stable artwork. The copy/link/status panel remains unchanged, and the claimed sender state still reveals the Gift.
- **Hypothesis:** Making the activation transformation visually literal will help the sender feel that discovery has become an intentional handoff rather than a generic confirmation page.
- **Assumptions:** A restrained paper envelope belongs in the selected Paper World language without implying postal delivery; the wax-like mark can communicate closure without branding, confetti, or checkout-success imagery.
- **Validation and result:** Request and browser-system coverage confirm that the pending sender page renders the sealed object, addresses the intended recipient, and no longer renders the authored Gift text in the waiting hero.
- **Evidence learned (if tested with people):** None. This is a product-owner design refinement; H6 remains unresolved.
- **Open questions:** Whether the envelope feels intimate or too literal, and whether the same object language remains suitable if the prototype default later moves away from Paper World.
- **Most useful next test:** Move through activation once on desktop and phone, then judge whether the envelope makes the handoff feel complete before reading the status copy.

### 2026-08-28 — Warm, non-glowing field focus

- **Request:** Remove the strange blue glow from focused sender input fields.
- **Changed:** Sender-form fields now use a stronger warm-neutral border on focus and explicitly remove the browser’s blue outline and shadow.
- **Hypothesis:** A quiet neutral focus state will preserve the paper-like visual world while remaining clear enough for keyboard and form use.
- **Assumptions:** The darker border provides the necessary focus distinction without an additional glow or colored ring.
- **Validation and result:** Browser-system coverage checks the focused note field’s computed outline and shadow during the complete sender flow.
- **Evidence learned (if tested with people):** None. This is a product-owner polish decision.
- **Open questions:** None introduced.
- **Most useful next test:** Tab through the sender form once and confirm that focus remains easy to follow without drawing attention away from the content.

### 2026-08-28 — Primary action without link underline

- **Request:** Remove the underline from the black “Someone came to mind” button.
- **Changed:** Button-styled recipient actions now explicitly remove link decoration, while quiet text links keep their underlined treatment.
- **Hypothesis:** A single filled primary action will read more clearly as a button when it does not also carry the visual language of a text link.
- **Assumptions:** Every element using the shared `recipient-button` treatment should look like a button whether its HTML element is a link or a button.
- **Validation and result:** Browser-system coverage checks the computed primary-action decoration while exercising the sender discovery flow.
- **Evidence learned (if tested with people):** None. This is a product-owner polish decision.
- **Open questions:** None introduced.
- **Most useful next test:** Continue the sender flow and note only whether the primary and secondary actions now have an immediately clear hierarchy.

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
- Onward passing is not implemented; the multi-holder landing path is illustrative of the intended future behavior.
- The Rails-generated Minitest scaffold remains, while product-domain coverage uses RSpec.
