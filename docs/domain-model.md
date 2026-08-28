# Accountless Domain Model

## Why there is no `User`

Left You One models a person’s relationship to one Gift, not a persistent profile. A sender discovers a Gift, a recipient claims a Transfer, and a holder may later pass the same Gift onward. Names and coarse locations are metadata for one handoff or JourneyStop; they do not verify identity or grant access.

## The four models

```text
GiftTemplate 1 ─── * Gift 1 ─── * Transfer
                       │                 │
                       └── 1 ─── * JourneyStop
                                         │
                              optional, unique Transfer
```

### `GiftTemplate`

An editable authored definition containing main text, optional context and ritual, broad theme, and replaceable visual hints. `source_key` is stable and unique, so YAML imports update rather than duplicate records. Templates may be inactive without being deleted.

The stored themes are `courage`, `calm`, `momentum`, `connection`, `luck`, `wonder`, and `strange`. “Surprise me” selects across active templates; it is not a stored theme.

### `Gift`

One persistent object discovered from a template. It has a serial number, opaque public slug, deterministic render seed, state and timestamps, capability digests, and `holder_generation`. It also stores a small resolved `visual_configuration` snapshot so its appearance does not change when the global lab default changes.

`creation_key_digest` makes discovery idempotent for the short-lived sender session. `opened_by_creator_at` records only that the sender revealed the exact Gift; it does not activate it.

The serial and public slug are identifiers, never authorization.

### `Transfer`

One intended handoff. It stores a claim-capability digest, state, sender display name, private intended-recipient dedication, optional private note, source holder generation, and transition timestamps. A partial unique index permits at most one pending Transfer per Gift while retaining cancelled and claimed history.

`intended_recipient_name` is not verified identity and never automatically becomes public journey metadata. `private_note` belongs to its Transfer and is excluded from ordinary serialization and parameter logs. It is currently plaintext at rest in the local prototype; encryption is required before broader real-data use.

### `JourneyStop`

One accepted period with a holder. Anonymous is the default. A claimed Transfer can create at most one stop, enforced by a unique index, and each Gift has only one stop for each sequence number. The first successful claim creates sequence 1. Merely opening or previewing a link creates nothing.

Optional `display_name`, `city`, and two-letter `country_code` are published only after the current holder explicitly submits them. They remain self-described and unverified.

## Implemented states and transitions

`Gift` states:

- `discovered`: the exact Gift exists at generation 0; no handoff is active.
- `waiting_for_claim`: simulated activation created one pending Transfer.
- `held`: the first recipient claimed; the Gift is at generation 1.

`Transfer` states:

- `pending`: its private claim capability can still win the handoff.
- `claimed`: it won and has exactly one JourneyStop.
- `cancelled`: it was cancelled or replaced and can no longer claim.

Transitions live in services rather than callbacks:

1. `Gifts::Discover` creates a `discovered` Gift, returns its creator capability, snapshots visuals, and creates no Transfer or JourneyStop.
2. `Gifts::ActivateForRecipient` authorizes the creator, creates or idempotently returns one pending Transfer, and changes the Gift to `waiting_for_claim`. A replacement cancels the previous pending Transfer first.
3. `Gifts::CancelPendingTransfer` cancels a pending first handoff and restores `discovered`.
4. `Transfers::Claim` locks the Transfer and Gift, lets only the first claimant succeed, advances generation 0 to 1, rotates in a holder capability, and creates JourneyStop sequence 1.
5. `JourneyStops::UpdateIdentity` authorizes the current token and generation, then changes only that stop’s optional public mark.

## Capability ownership

Private capabilities use cryptographically secure randomness. Only deterministic SHA-256 digests are persisted and comparisons use a constant-time check.

- The creator capability digest belongs to `Gift`. Its raw URL establishes an encrypted creator cookie and redirects to a clean management URL.
- The one-time recipient claim digest belongs to `Transfer`. Its raw capability remains in `/open/:token` until claim.
- The reusable current-holder digest belongs to `Gift`. Successful claim issues it and the holder cookie records the matching generation.
- `/o/:public_slug` grants no control. It renders public data plus role-aware additions only when a valid cookie is present.

Creator, recipient, and holder roles are deliberately separate. A creator does not receive holder controls, a holder does not receive creator controls, and the intended recipient dedication never authorizes anybody.

## Adding onward passing later

The existing structure supports a later pass without cloning the Gift. A current holder would create a Transfer at the current generation while remaining holder. A successful next claim would close the prior JourneyStop, advance `holder_generation`, rotate the current-holder capability, and create the next sequenced stop. Expiry, cancellation, price, and old-holder presentation remain product decisions and are not implemented.

## Adding persistent identity later

If testing demonstrates a need for accounts, identity can remain an optional layer linked to selected role records. Gift ownership, Transfer history, and JourneyStop sequencing do not need to move into a `User` model. Anonymous and capability-only participation can remain available.

## Deliberately postponed

- Onward passing and multi-stop journeys beyond fixtures.
- Real payment, purchase records, checkout, refunds, or billing identity.
- Token recovery, production expiry/rotation management, and device revocation.
- Verified identity, accounts, profiles, social graphs, or exact location.
- Production messaging, analytics, administration, and deployment architecture.
