# Recipient Experience

## Intended sequence

The recipient experience is designed around:

> curiosity → personal recognition → anticipation → reveal → feeling → possession → optional future connection

The reusable stage now serves both the development laboratory and the real first-recipient flow. Laboratory actions remain non-mutating. In the real `/open/:token` flow, completing the explicit opening action atomically claims the pending Transfer, creates JourneyStop sequence 1, establishes holder access, and resumes the reveal on `/o/:public_slug`. The later passing action remains a non-mutating placeholder.

## Arrival

Arrival contains only a recipient line, who left something, the intention behind the handoff, and one action: **Open it**. The recipient holds the pointer action for roughly one second; a quiet “Hold for a moment” hint describes that gesture without replacing the primary label. The gift remains visually sealed. Brand chrome, price, navigation, marketing, journey mechanics, and creation calls to action do not appear.

Named and anonymous patterns both come from I18n. The named default—“Dimitar left you something. They wanted you to have it.”—uses singular “they” so no gender is inferred. It states the sender’s intention without claiming whether the gift prompted the thought, met a need, or was simply something worth sharing. The anonymous fallback makes the same limited claim.

## Opening

The recipient explicitly starts the opening. In the default sequence:

1. Holding the action gradually fills it while the veiled world becomes warmer and clearer.
2. Arrival copy recedes when the hold completes.
3. The sealed treatment lifts from the same image.
4. The main authored text resolves.
5. Context and ritual follow.
6. The private sender note follows as a distinct voice.
7. The interface settles into possession after the first reading moment.

The hold takes about `1.05s`; the authored gift resolves about `0.72s` after it completes, and possession follows about `2.6s` after completion. **Show it now** still settles the sequence immediately. The interaction does not navigate, spin, count down, or celebrate like a reward reveal.

## Revealed gift

The revealed hierarchy is:

1. quiet origin;
2. main authored gift text;
3. contextual line;
4. ritual or closing line;
5. private sender note.

The exact authored Gift and note are not rendered on the private arrival before claim, so they cannot leak through source inspection or assistive technology. After successful claim they are rendered as distinct voices. The image remains decorative; all meaning-bearing text is selectable semantic HTML.

## Possession

After the reading moment, the stage introduces:

> It’s with you now.

> Keep it for as long as it means something.

> When somebody else comes to mind, pass it on.

Keeping is presented before passing. The prototype action **This made me think of someone** reveals a calm placeholder and performs no transfer. Current-holder access and the optional public-identity form sit below the emotional stage so they do not interrupt the reveal.

The possession block reserves its final layout space while it is visually and accessibly hidden. When it settles in, the already revealed gift remains fixed instead of being pushed upward by the new content.

## Sender anticipation comparison

The development laboratory and creator-authorized real flow render the same stage as a sender preview. Arrival is explicitly framed as “This is what Anna opens.” After the gift resolves, the possession area is replaced with:

> You saw this and thought of Anna.

> That’s what makes it a gift. The rest is the moment Anna gets to open.

The primary action remains the established simulated commitment—**Leave this for Anna · $2**—and is followed by the explicit prototype notice that no payment will be taken. In the real flow it creates a pending Transfer and reseals the Gift; it creates no payment record. The separate recipient-preview route is creator-authorized, clearly labelled outside the ceremonial frame, and never claims or mutates the Gift.

## Existing journey

The existing-journey variation adds an origin age, holder position, a short place trail, and a compact aggregate, for example:

> This one began with Maya 19 days ago.

> You’re its 7th holder.

> Sofia → Vienna → Berlin

> 7 people · 3 countries · 19 days

This is synthetic presentation data. The place list is treated as three country stops for the current comparison tool; real location consent and vocabulary remain undecided. Journey context comes after the gift and possession rather than becoming a map or dashboard.

## Development routes

The visual-comparison routes exist only in development and test:

- `/dev/recipient-lab` — controls plus an embedded clean preview;
- `/dev/recipient-preview` — the recipient experience without controls or debug information.

Both routes accept only allowlisted presentation parameters. They do not accept or expose creator, claim, or holder capabilities.

The real recipient route is `/open/:token`; successful claim redirects to the clean public route `/o/:public_slug` with encrypted holder access. The raw holder capability is available only in a quiet private-access disclosure for testing another browser. Ordinary public visitors receive neither private content nor holder controls.

The laboratory updates its embedded preview as controls change; typing fields use a short debounce and duplicate input/change events do not reload an unchanged preview. It can vary the point of view, prototype price, template, people, note, journey age and places, family, finish, background, composition, seal, motion, grain, overlay, text tone, state, reduced motion, mobile width, long copy, and anonymous sender. It can reset, open, jump, change template, randomize, open a clean tab, and copy the clean URL. The laboratory’s **Open gift** control begins after the hold phase so the reveal remains replayable even when a browser throttles an embedded iframe.

## Accessibility and control

- Pointer activation uses the deliberate hold; releasing early rewinds to the sealed state.
- Keyboard activation automatically completes the same warm-up and opening path without requiring a sustained keypress.
- Focus moves to the gift heading after reveal.
- A polite live region announces opening and revealed states.
- Reduced motion may be requested by the operating system or simulated in the lab; it removes the hold hint and opens immediately.
- The real claim form submits only after the opening interaction completes; duplicate or concurrent claim loss resolves to a calm already-claimed state.
- Decorative photography does not duplicate the text.
- The stage can scroll after reveal without moving the photographic world to a separate page.

## What must be tested with people

- Whether arrival communicates trust and a specific human choice before opening.
- Whether the reveal creates a felt moment rather than presenting a quote.
- Whether the timing feels calm or precious.
- Whether holding adds meaningful anticipation or only interaction friction.
- Whether the sender note deepens recognition or carries too much of the value.
- Whether the sender preview strengthens anticipation and care without flattering the sender or weakening the gift itself.
- Whether “It’s with you now” communicates gentle possession without collectible language.
- Whether people notice passing as a future possibility without feeling pushed.
- Whether journey context adds meaning or distracts.
- Whether warm, funny, dark, and strange gifts still feel like one product.
- Whether claiming on the opening gesture feels natural or makes the reveal feel consequential in the wrong way.

No product hypothesis is marked supported until these states are observed with real sender-recipient pairs.
