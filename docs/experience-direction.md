# Experience Direction

## North star

Left You One should feel more like an interactive short story than a website flow. The interface recedes so that one thought, one image, and one action can carry each moment.

The experiential sequence is:

> curiosity → discovery → association → intention → anticipation

For recipients it becomes:

> curiosity → personal recognition → reveal → feeling → possession

Visual beauty matters, but only in service of those transitions. The product is not successful if it looks editorial while behaving like a form or if the art overwhelms the human gesture.

## Experience principles

- Show one primary thought and one primary action at a time.
- Use space, pacing, and transitions to make small actions feel deliberate.
- Let the visitor experience the premise before explaining it.
- Treat the recipient opening as a first-class product, not a share-page afterthought.
- Make the object feel authored through the union of words, image, typography, and motion.
- Keep conventional application chrome nearly invisible.
- Preserve moments of quiet; do not fill every screen with explanation.
- Let people leave without pretending they felt an association.

## Landing page as demonstration

The landing page should enact reverse gifting rather than follow a standard marketing-page stack. Do not build a hero, feature grid, testimonials, pricing table, FAQ, and repeated calls to action.

A working sequence is:

### Scene 1: curiosity

> This one isn’t for anyone yet.

Primary action: **Open it**

The visitor should know just enough to act. Brand presence is quiet. There is no product taxonomy or feature explanation.

### Scene 2: discovery

An example gift reveals within a strong visual composition. Give the visitor enough time and control to look at it. Do not immediately cover the result with the next prompt.

### Scene 3: association

> Who did this make you think of?

Primary action: **Someone came to mind**

There must also be an honest, low-emphasis route for “Nobody yet.” The prototype should learn from a missing association rather than coerce a positive answer.

### Scene 4: understanding

> That’s the idea.

> Usually you think of someone and look for a gift. We do it backwards.

This explanation earns its place after the visitor has felt the mechanism. Keep it brief.

### Scene 5: desire

> Start a tiny thing for $2 and see where it goes.

The exact pricing line remains a hypothesis. The action should lead into discovery, not a catalog. Whether the demonstration gift itself can become sendable or the visitor starts a fresh discovery is deliberately open and should be tested.

## Sender experience

The sender flow is not a wizard even if it has sequential states. It should feel like a series of scenes:

- A small set of broad feelings or “Surprise me” creates direction without shopping for an exact item.
- The exact gift remains unknown until discovery.
- Reveal is followed by an unhurried looking state.
- “Who came to mind?” appears only after the sender has seen the gift.
- Recipient details and an optional note appear only after association.
- The approximate $2 commitment is phrased as making the gesture real for a named person.
- Success creates anticipation and presents the simplest believable handoff.

Avoid progress bars, numbered checkout steps, dense panels, persistent sidebars, and multiple competing exits. Back navigation can exist, but should not dominate the scene.

Repeated discovery must not resemble pulling a slot machine. Avoid rapid-fire rerolling, rarity language, celebratory reward effects, and counters. If a gift does not evoke anybody, let the sender pause, choose another broad direction, or leave.

## Recipient experience

Receiving is the most ceremonial part of the product. A working arrival composition is:

> Dimitar left you something.

> They wanted you to have it.

Then show one large, sealed visual and one action: **Open it**.

Keep the stage free of persistent brand text or site chrome. The personal handoff should establish context; product identity can appear later only if trust or onward action proves to require it.

The gift should occupy most of the available view while retaining calm padding on every side. Its reveal occurs inside the same visual world rather than navigating into a conventional content page. The transition should preserve continuity: the recipient opens *this thing*, not a second screen unrelated to it.

After the recipient has had time to read and feel the result:

> It’s with you now.

Journey and passing language come later and with lower emphasis. Do not attach an upsell, account prompt, share demand, app navigation, or company promotion to the emotional peak.

### Current prototype direction

The development recipient laboratory now implements this sequence inside one stable photographic stage. Its working default is a veiled form of the final image: a short hold warms and clarifies the same visual world, opening removes the veil, resolves the authored text in layers, gives the sender note a separate voice, and only then introduces “It’s with you now.” The laboratory can also replay the same composition from the sender’s point of view before simulated commitment, so anticipation and receiving can be compared without building the sender flow. Two alternative seals remain available for comparison. See `docs/visual-system.md` and `docs/recipient-experience.md`.

This is a reversible design direction, not a validated result. The generated local backgrounds, exact type voice, timing, note placement, origin metadata, and default seal must be judged with real recipients before they become product decisions.

## Photography and art direction

The visual target is a beautiful photograph that has been deliberately art-directed and stylized for a specific gift. Suitable source worlds include:

- landscapes and weather;
- quiet interiors and natural light;
- close crops and abstract material details;
- atmospheric spaces;
- subtle traces of people without requiring faces.

The subject, crop, tonal treatment, texture, and type placement should reinforce the gift's feeling. The result should not look like a stock image with a caption centered over it.

Useful techniques include:

- choosing images with intentional negative space for text;
- using close or unusual crops that make familiar scenes feel discovered;
- applying restrained grain, noise, color wash, shadow, or gradient as part of one treatment;
- matching typographic scale and position to the image composition;
- using a small family of flexible treatments rather than a unique UI system for every gift.

Avoid decorative imagery that merely illustrates a word literally, obvious lifestyle stock photography, motivational-poster scenery, prominent unidentified faces, and arbitrary filters.

Photography licensing, sourcing, and the final treatment system remain implementation decisions. Prototype assets must still be legal to use in the intended test setting.

## Typography and content composition

Gift words should remain real document text even when visually integrated with an image. This keeps copy editable, selectable, responsive, and accessible. Treat type as part of the composition through placement, measure, weight, color, and spacing rather than baking it permanently into an image.

Use a restrained typographic hierarchy:

- subtle product identity;
- a clear human-context line;
- expressive but highly readable gift text;
- quiet contextual and closing lines;
- one unmistakable primary action.

Do not force every gift into the same centered quote-card layout. Some compositions may be left-aligned, low in the frame, or arranged around the image's visual center, as long as the responsive system remains legible.

## Layout and responsive behavior

- Favor the viewport as the scene instead of a long application page.
- Keep deliberate outer margins so the gift reads as an object within space.
- Use rounded corners only where they support the object-like quality; do not apply cards everywhere.
- Respect mobile safe areas, browser chrome, dynamic viewport height, and large text settings.
- Let the image crop adapt without hiding the visual subject or creating unreadable type.
- Keep touch targets generous while letting secondary actions remain visually quiet.
- On desktop, do not turn the extra width into side navigation or settings panels.

Exact dimensions, radii, typefaces, colors, and breakpoints should emerge from visual prototypes. They are not brand decisions yet.

## Motion and pacing

Motion should clarify an emotional transition:

- sealed to open;
- obscured to visible;
- general object to person-specific gesture;
- newly received to now possessed.

Useful motion may include a slow crop shift, subtle depth, a gentle mask or cover opening, and restrained text staging. The user initiates the important reveal. Do not auto-play past the moment they came to see.

Avoid confetti, bouncing rewards, slot-machine spins, aggressive parallax, novelty cursors, long unskippable sequences, and motion on every element. The intended pace is calm, not slow for its own sake. Repeated use should remain tolerable.

Respect `prefers-reduced-motion` and provide an immediate, coherent state without animation. The experience should be understandable with motion disabled. Default to silence; sound is not required for the initial prototype and must never surprise the recipient if explored later.

## Interaction and accessibility

Ceremony cannot depend on exclusion. At minimum, future implementations should preserve:

- keyboard access and a visible focus state;
- semantic headings and buttons;
- adequate text contrast across every image treatment;
- real text rather than text embedded in raster assets;
- useful alternative descriptions where imagery carries meaning;
- reduced-motion behavior;
- readable layouts at increased zoom and text size;
- no information conveyed only through color or animation.

The sealed state should not hide the basic context from assistive technology, while the gift content itself should not be announced before the recipient chooses to open it. That reveal behavior will need deliberate accessibility testing.

## What the experience must not become

- A conventional SaaS marketing site.
- A card builder or template customizer.
- An online shop or checkout funnel.
- A random-reward machine.
- A motivational quote placed over interchangeable stock imagery.
- A dashboard with the emotional experience inside a panel.
- A forced-sharing chain.
- A cinematic sequence that sacrifices control or accessibility.

## Practical iteration principle

Separate content, treatment choices, and state transitions enough that each can change during testing. Provide a simple way for the team to replay or reset prototype scenes outside the public experience. The goal is to compare emotional effects quickly, not to perfect a design system before the premise is proven.
