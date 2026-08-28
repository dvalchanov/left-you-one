# Product Prototype

## Purpose

This prototype is an evidence-generating experience, not a small production system. It should let the team:

- experience the central idea without explaining it first;
- put it in front of other people;
- change content, copy, pacing, and visual treatments quickly;
- observe whether a real person comes to mind;
- judge whether the recipient's opening feels special;
- test the approximate $2 commitment moment without billing anybody;
- decide whether the journey makes the gift more interesting.

Technical completeness is valuable only when it helps answer those questions.

## The first meaningful prototype

When implementation is requested, the smallest useful vertical experience should cover these connected moments:

1. An experiential landing sequence that demonstrates reverse gifting.
2. A broad feeling/theme choice or “Surprise me.”
3. Discovery and deliberate reveal of one exact gift.
4. A pause in which the sender can notice who came to mind.
5. Recipient selection by lightweight, accountless details.
6. An optional personal note.
7. A simulated “Leave this for Maria · $2” commitment moment.
8. A sendable or demonstrable handoff.
9. A recipient arrival, sealed presentation, reveal, and possession moment.
10. A lightweight view of the gift's origin or journey.
11. An optional path for the current holder to pass the same gift onward.

These are product states, not a requirement to build every backend concern at once. A staged prototype may use curated fixtures or local state before adding persistence, as long as it can still test the intended feeling honestly.

## In scope

- A small, curated set of authored gift content with meaningfully different tones.
- Art-directed visual treatments sufficient to test whether a gift feels deliberately made.
- Server-rendered Rails screens with Hotwire/Stimulus where transitions add experiential value.
- Editable YAML/I18n or similarly simple content sources for product and interface copy.
- Accountless sender and recipient flows.
- Capability-style URLs or tokens if persistent shareable flows are needed.
- Simple domain concepts near `GiftTemplate`, `Gift`, `Transfer`, and `JourneyStop` if persistence is needed.
- Local, fake, or simulated payment success with unmistakably non-production behavior.
- Basic journey provenance sufficient to understand “this same thing has been with other people.”
- Manual usability sessions and lightweight observations.

## Out of scope

- Real billing, Stripe, refunds, taxation, or payment operations.
- User accounts, a `User` model, passwords, OAuth, Google login, or social profiles.
- A store, catalog, cart, product comparison, or conventional checkout.
- AI generation presented as the product's value.
- Digital ownership, trading, scarcity, blockchain, or collectible mechanics.
- Company dashboards, bulk campaigns, creator tooling, campaign analytics, or company pricing.
- Production messaging infrastructure, deliverability work, or notification orchestration.
- Sophisticated maps, geolocation, social sharing systems, or public feeds.
- Rare-item systems, fixed inventory economics, streaks, leaderboards, referral loops, or pressure to pass.
- Production scaling, elaborate queues, service extraction, or a general event architecture.
- Physical goods.

## Prototype constraints

### Preserve the actual sequence

Do not ask for a recipient before the sender has seen the exact gift. That would turn reverse gifting back into ordinary gift shopping and invalidate the test.

### Preserve a real choice

The interface may invite “Who came to mind?” but must not pretend an association happened. A sender needs a graceful way to admit that nobody did. That outcome is product evidence, not an error.

### Keep content authored and editable

The prototype needs enough variety to test warm, funny, odd, comforting, specific, and playful responses. Content should be easy to revise without changing business logic. A large inventory is less useful than a small collection of carefully differentiated examples.

### Simulate commitment, not commerce

The approximate $2 moment should occur only after a recipient is in mind. The prototype can immediately simulate success, but its copy and interaction should help answer whether payment feels natural at that exact point.

### Make the handoff believable

A recipient experience tested only from the sender's browser risks missing the core value. The prototype should eventually allow a recipient to arrive through a distinct link or equivalent handoff. It does not need production-grade security or delivery infrastructure to test that moment.

### Keep technical choices reversible

Start with Rails conventions, server rendering, Hotwire/Stimulus, minimal models, and minimal dependencies. Add persistence or a model only when a tested flow needs it. Avoid creating abstractions for undecided business models.

## Current repository state

The repository now has a deliberately small first vertical flow on Rails 8.1 and PostgreSQL. It retains Hotwire/Stimulus, import maps, server-rendered Rails conventions, and RSpec with FactoryBot.

`/start` carries a sender through broad theme selection, exact Gift discovery, reveal, association, minimal recipient details, optional private note, and a simulated `$2` commitment. The result is a private recipient claim link. A separate browser can open, claim, reveal, become holder generation 1, optionally publish a coarse identity, and view the public journey. The sender’s clean management page updates after claim.

Four accountless persistence concepts remain sufficient: `GiftTemplate`, `Gift`, `Transfer`, and `JourneyStop`. Creator, claim, and holder roles use separate capabilities whose raw values are never stored. Public slugs grant no control. The product owner’s Paper World treatment is saved as the prototype default and resolved into each Gift at discovery so sender and recipient see a stable shared object.

This implementation stops at the first holder. The landing demonstration, onward passing, real payment, automated delivery, accounts, and production infrastructure remain outside the current slice.

## Definition of prototype success

The prototype succeeds by producing trustworthy answers, not by accumulating features. The strongest signal would be a repeatable sequence in which:

- the sender understands the interaction without a verbal pitch;
- the reveal is enjoyable but does not feel random or game-like;
- a specific person genuinely comes to mind;
- the sender wants to make the gift real for that person;
- the approximate price feels trivial relative to the gesture;
- the recipient understands that they were specifically thought of;
- opening creates a small emotional response;
- possession and possible onward travel add interest rather than obligation.

A polished flow that does not produce association or personal recognition is evidence against the current concept, not a successful prototype.

## Decisions intentionally deferred

Do not let prototype scaffolding settle final pricing, free-versus-paid design, first-gift promotions, company-funded gifts, visual rarity, categories, inventory size, identity, exact transfer rules, map design, or final content structure. Record assumptions as reversible and revisit them after observation.
