# Copy Guide

## What the words need to do

Copy should make a small gesture feel human, specific, and lightly ceremonial. It should create curiosity, leave room for the sender's own association, and acknowledge intention without over-explaining the product.

The voice is:

- **Warm, not sentimental** — affectionate without forcing emotion.
- **Specific, not inspirational** — observant details instead of universal advice.
- **Quiet, not flat** — restrained language with personality.
- **Playful, not cute by default** — wit is welcome; whimsy is not mandatory.
- **Intimate, not invasive** — personal without claiming to know the reader.
- **Confident, not promotional** — short statements instead of sales persuasion.

The interface should sound as though a thoughtful person is guiding one small ritual, not as though a brand is explaining a platform.

## Core terminology

### Public language

Use “one” only where it is an ordinary English pronoun:

- “Maya left you one.”
- “Someone left one for you.”
- “Start one.”
- “Open this one.”
- “Pass this one on.”

Do not name the objects “Ones,” capitalize the word as a category, or write constructions such as “Create an One,” “browse Ones,” or “your One collection.”

Prefer **leave** when describing the sender's gesture, **open** for the reveal, **with you** for possession, and **pass on** for a later transfer. Use **gift** sparingly in explanatory copy when clarity is more important than mystery.

### Internal language

The expected domain terms are:

- `GiftTemplate` — authored content and its visual treatment or references.
- `Gift` — the one persistent logical object created from a template.
- `Transfer` — the act of sending or passing that gift.
- `JourneyStop` — a holder or place in its history.

These internal terms do not dictate public labels.

## Core working lines

These lines express the product especially well and should be treated as anchors, not filler:

> A small gift for moments that don’t need a big one.

> You’ll know who it’s for when you see it.

> Who came to mind?

> Dimitar left you one.

> Dimitar found something and thought of you.

> It’s with you now.

> Keep it for as long as it means something.

> When somebody else comes to mind, pass it on.

> It might stay with one person. It might cross the world.

> Give people something to carry, not something to scroll past.

Names should make the experience feel personal, but sentence patterns must also work when only a sender-provided display name is known. Avoid inferring gendered pronouns. “Dimitar found something and thought of you” is safer and more direct than adding “he” or “she.”

## Gift-content anatomy

A gift is more than a floating aphorism. A useful working structure is:

1. **Main thing** — something offered, noticed, granted, or imagined.
2. **Context** — a detail that makes it land in a particular kind of day or moment.
3. **Closing or ritual** — a light suggestion for what to do with it or how long to keep it.

Not every gift needs all three parts, and this structure remains a hypothesis. It is a quality check, not a rigid schema.

Example:

> A little courage before your doubts wake up.
>
> For the thing you’ve been putting off.
>
> Keep it until you begin.

Other working examples:

> Ten quiet minutes with nothing to prove.
>
> For the day that will not stop asking things of you.
>
> Use them slowly.

> A meeting that ends fourteen minutes early.
>
> For tomorrow afternoon.
>
> Use immediately.

> Permission to stop solving it tonight.
>
> Tomorrow can have the problem back.

## Gift-writing patterns

Good gifts usually have at least two of these qualities:

- an offered thing that cannot literally be wrapped;
- a concrete time, number, behavior, place, or sensory detail;
- gentle recognition of a familiar private experience;
- a small turn or surprise in the final line;
- enough ambiguity for the sender to supply the personal meaning;
- a cadence that reads naturally aloud.

Useful openings include:

- “A little …”
- “Ten minutes of …”
- “Permission to …”
- “One afternoon where …”
- “A reason to …”
- “The exact amount of …”

Vary the grammar. A library in which every gift starts with “Permission to” will quickly feel generated.

## Interface-copy patterns

### Landing experience

- Setup: “This one isn’t for anyone yet.”
- Primary action: “Open it”
- Association: “Who did this make you think of?”
- Confirmation: “Someone came to mind”
- Explanation: “Usually you think of someone and look for a gift. We do it backwards.”
- Start: “Start one”

### Discovery and sender flow

- Promise: “You’ll know who it’s for when you see it.”
- Broad choice: a short theme label or “Surprise me”
- Post-reveal prompt: “Who came to mind?”
- Honest escape: “Nobody yet” or “Not this one”
- Note invitation: “Leave a note, if you like.”
- Commitment: “Leave this for Maria · $2”
- After simulated success: “It’s ready for Maria.”

The honest escape is important. Do not use copy that assumes the mechanism worked when it did not.

### Recipient flow

- Arrival: “Dimitar left you one.”
- Context: “Dimitar found something and thought of you.”
- Primary action: “Open it”
- After reveal: “It’s with you now.”
- Permission to keep: “Keep it for as long as it means something.”
- Optional future: “When somebody else comes to mind, pass it on.”

### Journey

- Origin: “Started by Dimitar”
- Holder line: “Anna — Sofia”
- Honest possibility: “It might stay with one person. It might cross the world.”

Do not imply that a location is known unless somebody deliberately provided it. The exact location request and privacy treatment remain undecided.

## Price and transaction language

The payment moment should name the person and the gesture:

> Leave this for Maria · $2

Avoid leading with the object and its price, such as “Buy gift — $1.99,” “Purchase quote,” or “Add to cart.” The price supports an act that already has emotional intention; it does not create that intention.

In prototype mode, do not falsely imply that a card was charged. Use a local simulated success state and, where testers could mistake it for a real purchase, plainly mark the environment as a prototype without interrupting the emotional scene.

## Journey language

Journey copy grants permission; it does not set a mission.

Use:

- “Keep it for as long as it means something.”
- “When somebody else comes to mind, pass it on.”
- “See where it has been.”
- “It might stay with one person. It might cross the world.”

Avoid:

- “Keep the chain alive!”
- “Don’t let it stop with you.”
- “Send it to unlock the next stop.”
- “Help it travel the world.”
- “Only 24 hours left to pass it on.”

## Forbidden tones and claims

Do not use generic self-help:

- “Believe in yourself.”
- “Follow your dreams.”
- “Good things are coming.”
- “You can achieve anything.”

Do not frame discovery as gambling or collection:

- “Try your luck.”
- “Reveal your rarity.”
- “You got a legendary one.”
- “Collect them all.”

Do not use SaaS, e-commerce, or growth language in the experience:

- “Get started in seconds.”
- “Choose a plan.”
- “Add to cart.”
- “Complete checkout.”
- “Invite contacts.”
- “Boost engagement.”

Do not make unverifiable emotional or journey promises:

- “They’ll love it.”
- “Make someone’s day.”
- “This will travel around the world.”
- “The gift that keeps on giving.”

Avoid calling the object a message, quote, card, asset, collectible, token, drop, or content. Each of those imports the wrong mental model.

## Editorial checks

Before accepting new copy, ask:

- Does it leave room for the person rather than narrating their feelings for them?
- Is it specific enough that somebody real might come to mind?
- Does it sound authored rather than generated?
- Does it keep the sequence discovery-first?
- Does it avoid commerce until intention exists?
- Does it avoid pressure, urgency, and journey-as-game language?
- Can it be changed in one editable content source?
- Does it still work with long names, no known pronouns, and small screens?

All copy in this guide is working copy. Preserve the intent, test the actual words, and record material changes rather than treating any line as final.
