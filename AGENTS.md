# Left You One: Agent Guide

Left You One is currently a product-discovery prototype. The goal is to learn whether a tiny digital gift can create a real moment of human connection. Product feeling and evidence matter more than feature count or technical completeness.

## Required reading

Before planning or changing anything, read every product document:

1. `docs/product-vision.md`
2. `docs/product-prototype.md`
3. `docs/copy-guide.md`
4. `docs/experience-direction.md`
5. `docs/core-flow.md`
6. `docs/testing-hypotheses.md`
7. `docs/prototype-progress.md`

Do not rely on a summary or read only the document that appears closest to the task. The documents describe one connected experience.

## Product guardrails

- Protect the reverse-gifting sequence: discover the exact gift before choosing its recipient.
- Optimize for the moment when the sender thinks, “This is absolutely for them.”
- Make receiving feel intimate, calm, personal, and deliberately made.
- Treat the gift as a reason to think of somebody, not as a quote, advice product, collectible, or game.
- Use “one” only where it reads naturally in English. Do not turn “Ones” into the public name of the objects. The internal model may be `Gift`.
- Keep the journey optional. Keeping a gift is never failure, and copy must not pressure a holder to pass it on.
- Product feeling is more important than adding features.
- Implement only the step the user requested.

## Prototype guardrails

- Prefer the smallest reversible implementation that can answer the current product question.
- Do not overengineer or build production infrastructure for an unproven concept.
- Keep copy in editable content or I18n files rather than burying it in application logic.
- Keep visual systems and gift treatments easy to replace and iterate.
- Prefer server-rendered Rails with Hotwire/Stimulus and minimal dependencies.
- Preserve accountless flows and capability-style links unless a later explicit decision changes them.
- Do not add a `User` model unless explicitly requested.
- Do not implement real payments unless explicitly requested. A prototype payment moment should be simulated locally.
- Do not add authentication, OAuth, Stripe, company dashboards, elaborate analytics/event systems, or scaling architecture unless explicitly requested.
- Do not implement company or creator features during the initial consumer prototype.

## Decisions and ambiguity

Do not silently invent major product decisions. Pricing, free-versus-paid behavior, categories, inventory, rarity, accounts, exact gift structure, final copy, and journey presentation remain hypotheses.

When behavior is ambiguous:

1. Check all product documentation for an existing constraint.
2. Choose the simplest reversible behavior that preserves the intended feeling.
3. Record the assumption and what would cause it to change in `docs/prototype-progress.md`.
4. Ask for direction before making a choice that would materially narrow the product.

## Repository baseline

This is a minimal Rails 8.1 application using PostgreSQL, Hotwire/Stimulus, import maps, Tailwind CSS, and Minitest. At the time this guide was created, no product routes, models, controllers, or views had been implemented.

Use the repository's established commands when implementation is requested:

- Setup: `bin/setup --skip-server`
- Development: `bin/dev`
- Tests: `bin/rails test`
- Full local checks: `bin/ci`

Match verification effort to the change. Documentation-only work does not require application tests, but it does require checking links, terminology, internal consistency, and the final diff.

## Progress record

Update `docs/prototype-progress.md` after every requested implementation or product-design step. Record:

- what was asked for and what changed;
- the hypothesis the step is meant to test;
- important reversible assumptions;
- validation performed and its result;
- open questions and the most useful next test.

Keep the record factual. Do not mark an experience validated until it has been observed with real people.
