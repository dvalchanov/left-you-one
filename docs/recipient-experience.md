# Recipient Experience

## Intended sequence

The recipient experience is designed around:

> curiosity → personal recognition → anticipation → reveal → feeling → possession → optional future connection

It is a visual simulation. Opening, possession, and passing never update `Gift`, `Transfer`, or `JourneyStop` records in this step.

## Arrival

Arrival contains only quiet brand presence, a recipient line, who left the gift, why they chose the recipient, and one action: **Open it**. The gift remains visually sealed. Price, navigation, marketing, journey mechanics, and creation calls to action do not appear.

Named and anonymous patterns both come from I18n. The named default is direct—“Dimitar found something and thought of you”—so no pronoun is inferred. The anonymous fallback says only what is known.

## Opening

The recipient explicitly starts the opening. In the default sequence:

1. Arrival copy recedes.
2. The sealed treatment lifts from the same image.
3. The main authored text resolves.
4. Context and ritual follow.
5. The private sender note follows as a distinct voice.
6. The interface settles into possession.

The sequence is under two seconds before possession becomes available. It can be completed immediately with **Show it now**. It does not navigate, spin, count down, or celebrate like a reward reveal.

## Revealed gift

The revealed hierarchy is:

1. quiet origin and prototype serial;
2. main authored gift text;
3. contextual line;
4. ritual or closing line;
5. private sender note.

The note is unavailable to assistive technology before opening and is visually distinct from the authored gift. The image remains decorative; all meaning-bearing text is selectable semantic HTML.

## Possession

After the reading moment, the stage introduces:

> It’s with you now.

> Keep it for as long as it means something.

> When somebody else comes to mind, pass it on.

Keeping is presented before passing. The prototype action **This made me think of someone** reveals a calm placeholder and performs no transfer.

## Existing journey

The existing-journey variation adds an origin age, holder position, a short place trail, and a compact aggregate, for example:

> This one began with Maya 19 days ago.

> You’re its 7th holder.

> Sofia → Vienna → Berlin

> 7 people · 3 countries · 19 days

This is synthetic presentation data. The place list is treated as three country stops for the current comparison tool; real location consent and vocabulary remain undecided. Journey context comes after the gift and possession rather than becoming a map or dashboard.

## Development routes

The routes exist only in development and test:

- `/dev/recipient-lab` — controls plus an embedded clean preview;
- `/dev/recipient-preview` — the recipient experience without controls or debug information.

Both routes accept only allowlisted presentation parameters. They do not accept or expose creator, claim, or holder capabilities.

The laboratory updates its embedded preview as controls change; typing fields use a short debounce. It can vary the template, people, note, journey age and places, family, finish, background, composition, seal, motion, grain, overlay, text tone, state, reduced motion, mobile width, long copy, and anonymous sender. It can reset, open, jump, change template, randomize, open a clean tab, and copy the clean URL.

## Accessibility and control

- Keyboard activation uses the same opening path as pointer activation.
- Focus moves to the gift heading after reveal.
- A polite live region announces opening and revealed states.
- Reduced motion may be requested by the operating system or simulated in the lab.
- Decorative photography does not duplicate the text.
- The stage can scroll after reveal without moving the photographic world to a separate page.

## What must be tested with people

- Whether arrival communicates trust and a specific human choice before opening.
- Whether the reveal creates a felt moment rather than presenting a quote.
- Whether the timing feels calm or precious.
- Whether the sender note deepens recognition or carries too much of the value.
- Whether “It’s with you now” communicates gentle possession without collectible language.
- Whether people notice passing as a future possibility without feeling pushed.
- Whether journey context adds meaning or distracts.
- Whether warm, funny, dark, and strange gifts still feel like one product.

No product hypothesis is marked supported until these states are observed with real sender-recipient pairs.
