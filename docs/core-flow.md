# Core Flow

## Flow invariant

The exact gift must be discovered before the recipient is chosen:

> broad direction → exact gift → association → person → optional note → commitment → handoff

Any flow that collects the recipient first tests ordinary gift selection rather than Left You One.

## Actors and working objects

- **Visitor** — somebody encountering the concept, often through the landing experience.
- **Originator** — the person who makes a discovered gift real and initiates its journey.
- **Holder** — the one person the gift is logically with after an accepted handoff.
- **Recipient** — the intended next holder while a transfer is pending.
- **Gift template** — editable authored content and visual direction available for discovery.
- **Gift** — the same logical object that can move over time.
- **Transfer** — an intended handoff from an originator or holder to a recipient.
- **Journey stop** — an accepted period with one holder; not merely a link being created or clicked.

These are working concepts, not a requirement to add all models in the first implementation step.

## Current technical representation

The foundation now persists `GiftTemplate`, `Gift`, `Transfer`, and `JourneyStop` without a `User` model. Private creator, claim, and current-holder access is represented by token digests; a gift's public slug is deliberately separate and grants no control. Only discovered-gift creation and creator-capability issuance are implemented so far.

The schema prepares—but does not yet implement—the following atomic claim behavior: claim the pending transfer, move the gift to `held`, advance `holder_generation`, create exactly one journey stop, and issue a new current-holder capability. A later successful pass will also close the prior stop and invalidate earlier holder access by advancing the generation. Browser authorization and these transition services remain reversible future work.

## End-to-end outline

```text
Experience premise
  → choose broad feeling / Surprise me
  → discover exact gift
  → notice who came to mind
  → identify that person
  → optionally add a note
  → simulate “Leave this for [name] · $2”
  → hand off a sealed gift
  → recipient recognizes the sender's intention
  → recipient opens it
  → gift is with the recipient
  → recipient keeps it indefinitely or later passes the same gift
```

## Landing demonstration

### L0 — Unassigned object

- **Show:** “This one isn’t for anyone yet” and a sealed or partially hidden object.
- **Primary action:** “Open it.”
- **Purpose:** Create curiosity without first teaching the business model.

### L1 — Example reveal

- **Show:** One complete, art-directed example gift.
- **Primary action:** initially none; let the visitor look.
- **Purpose:** Let discovery precede explanation.

### L2 — Association check

- **Ask:** “Who did this make you think of?”
- **Primary action:** “Someone came to mind.”
- **Secondary action:** “Nobody yet.”
- **Purpose:** Make the central mechanism explicit without manufacturing success.

If nobody came to mind, acknowledge it plainly and let the visitor continue to the short explanation, view another deliberately chosen example, or leave. Do not interpret the click as a conversion failure inside the UI.

### L3 — Explanation

- **Show:** “That’s the idea. Usually you think of someone and look for a gift. We do it backwards.”
- **Purpose:** Name what the visitor just experienced.

### L4 — Start

- **Show:** A restrained invitation to start one, with the working $2 framing if the test calls for it.
- **Primary action:** “Start one.”
- **Purpose:** Move from understanding to genuine discovery.

Open question: the example gift could become the visitor's real gift, or the creation flow could begin with a new discovery. The former reduces friction; the latter preserves the promised choice of theme. Test rather than burying this decision in architecture.

## Sender creation flow

### S0 — Broad direction

- **Show:** A small number of feeling/theme choices and “Surprise me.”
- **Do not show:** Exact gifts, a catalog, prices per item, or recipient fields.
- **Primary action:** Select one direction.
- **Product question:** Does a light choice create useful anticipation without feeling like shopping?

The exact themes and count remain content hypotheses.

### S1 — Discovery setup

- **Show:** A sealed visual or similarly deliberate pre-reveal state.
- **Primary action:** “Open it” or equivalent.
- **System behavior:** Select one exact gift from the chosen broad direction before reveal.
- **Product question:** Does opening feel intriguing rather than random or game-like?

### S2 — Exact gift revealed

- **Show:** The complete gift composition, including its main content, context, and closing where present.
- **Primary action:** none at first; allow a brief, user-controlled looking moment.
- **System behavior:** Keep this discovered gift stable. Do not cycle results automatically.
- **Product question:** Is the gift enjoyable and specific enough to evoke a person?

### S3 — Association

- **Ask:** “Who came to mind?”
- **Primary action:** “Someone came to mind.”
- **Secondary actions:** “Nobody yet” and, if testing repeated discovery, a quiet “Not this one.”
- **System behavior:** Record or observe the honest branch without presenting it as an error.

Do not ask for contact details in this state. First establish that there is a person.

Repeated discovery needs restraint. Return to broad direction or a deliberate next choice rather than providing an addictive instant reroll.

### S4 — Name the person

- **Ask:** A minimal prompt for the recipient's name or display name.
- **Primary action:** Continue for that named person.
- **System behavior:** Personalize later copy with the name.
- **Product question:** Does naming the person strengthen intention or break the spell?

Exact delivery details are not required until the chosen handoff method needs them. Do not turn this into address-book onboarding.

### S5 — Optional personal note

- **Ask:** “Leave a note, if you like.”
- **Primary action:** Continue with or without a note.
- **System behavior:** Preserve the distinction between the authored gift and the sender's private note.
- **Product question:** Does a note deepen the gesture, or does requiring composition recreate an e-card form?

The note is always optional. Avoid suggested messages that make the sender feel they are editing a greeting-card template.

### S6 — Commitment

- **Show:** The gift, recipient name, optional note, and one primary action such as “Leave this for Maria · $2.”
- **Primary action:** Simulate commitment.
- **System behavior:** In prototype mode, perform no real billing and transition to success.
- **Product question:** After association, does $2 feel natural and trivial relative to the intended moment?

If testers could reasonably believe real money will move, label the prototype context clearly outside the emotional copy or brief them before the session.

### S7 — Ready to hand off

- **Show:** “It’s ready for Maria” and the simplest available send/share mechanism.
- **Primary action:** Copy or open the recipient link, or use a deliberately limited prototype handoff.
- **Secondary information:** A private return link if journey-return testing needs one.
- **Product question:** Does sending feel like leaving something for a person rather than forwarding content?

The initial prototype does not need automated email, SMS, contacts, or production delivery. Native sharing may be explored later, but should not obscure whether the object itself has value.

## Recipient flow

### R0 — Arrival through a capability link

- **System behavior:** Resolve a specific gift and pending or accepted transfer without requiring an account.
- **Failure behavior:** If the link cannot be used, explain this calmly without exposing private journey data.
- **Purpose:** Keep access lightweight while making the handoff distinct from the sender's session.

### R1 — Personal context and sealed object

- **Show:** Quiet `leftyou.one` identity, “Dimitar left you one,” “Dimitar found something and thought of you,” one large sealed visual, and “Open it.”
- **Do not show:** Gift content, account prompts, navigation, journey mechanics, promotions, or price.
- **Product question:** Before opening, does the recipient understand that somebody specifically thought of them, and do they feel safe and curious enough to continue?

The sender's optional note may appear before or after the reveal. That timing is unresolved and should be tested because it can either strengthen personal recognition or spoil the authored reveal.

### R2 — Opening transition

- **Trigger:** Recipient explicitly chooses “Open it.”
- **Show:** A controlled transition from sealed to revealed within the same composition.
- **System behavior:** Mark an opening only when necessary for the tested journey behavior; do not build an elaborate event system.
- **Product question:** Does the act of opening create a tiny event without feeling theatrical or slow?

### R3 — Gift revealed

- **Show:** The full authored gift, with the optional personal note placed so it remains clearly the sender's voice.
- **Primary action:** none during the first reading moment.
- **Product question:** Does the content create a small smile, feeling, surprise, or recognition?

### R4 — Possession

- **Show after the reveal has settled:** “It’s with you now” and “Keep it for as long as it means something.”
- **Secondary action:** An optional, quiet route to its journey.
- **Later action:** “When somebody else comes to mind, pass it on.”
- **Product question:** Does “with you” create meaningful possession without collectible or ownership language?

Do not make passing the immediate visual climax. Keeping is the normal valid state.

### R5 — Journey

- **Show:** Simple human provenance such as “Started by Dimitar” and confirmed stops in order.
- **Show only when known and intentionally shared:** coarse location labels such as city.
- **Do not show:** Competitive counts, a progress target, predicted destination, engagement prompts, or a promise of global travel.
- **Product question:** Does history deepen the gift without making it public, performative, or game-like?

### R6 — Later return

- **Show:** The gift as something still with the current holder, with journey changes if any.
- **Possible action:** Pass it when somebody genuinely comes to mind.
- **Product question:** Is the object worth revisiting after the opening moment?

## Passing flow

Passing begins from an existing holder's later association, not from pressure immediately after opening.

1. **P0 — Intention:** The holder chooses “Pass it on” because somebody came to mind.
2. **P1 — Next person:** Ask only for the minimum recipient identification needed by the prototype.
3. **P2 — Optional note:** Let the holder add their own note without changing the original gift.
4. **P3 — Confirm handoff:** Make clear that this is the same gift and that it will be with the next person after handoff.
5. **P4 — Pending:** Create the recipient capability link or equivalent handoff.
6. **P5 — Accepted/opened:** Add the next journey stop and make the new person the logical holder.

A reversible working assumption is that the existing holder remains the holder while a pass is pending, and possession changes when the next recipient accepts or opens it. This avoids leaving an unclaimed gift with nobody and preserves one logical holder. It is not yet a final domain rule.

Whether passing has a price, whether an originator can cancel a pending first handoff, how long pending transfers last, and whether a pass can be withdrawn are unresolved. Do not answer them implicitly through an inflexible schema.

## Journey visibility and link roles

Accountless flows may require distinct capabilities:

- a recipient link that opens or holds a specific transfer;
- a holder link that lets the current holder return and potentially pass;
- an originator return link that lets the starter see appropriate journey updates.

The exact token model, privacy boundaries, link rotation, and old-link behavior should be designed only when implementation reaches persistent handoffs. At minimum, an old holder's link must not misleadingly claim the gift is still with them after a completed pass.

## State and privacy constraints

- One logical gift moves; passing must not silently clone it.
- One person is the logical holder at a time once possession has been accepted.
- The originator and current holder are distinct roles.
- A journey stop represents an actual accepted handoff, not every send attempt.
- Sender notes need an explicit rule: either they remain attached to their transfer only or become part of visible history. The safer working default is transfer-only and private to its recipient.
- Locations are optional and should never be inferred or exposed without clear consent.
- Journey visibility must be understandable before real personal data is collected.

## Unresolved flow questions to test

- Can the landing-page example become the gift, or should creation always start fresh?
- How many broad themes help without creating a store-like taxonomy?
- When should the optional sender note appear to the recipient?
- Does “It’s with you now” feel meaningful or artificially possessive?
- Does passing require opening, explicit acceptance, or a separate action before ownership changes?
- Should the first originator retain a private journey link, and what can they see?
- Is any price attached to onward passing?
- What location, if any, do people want in a journey?
- How should an unclaimed, expired, or withdrawn transfer feel?

These questions are product research inputs. Keep their implementation reversible until observation provides a reason to decide.
