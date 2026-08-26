# Accountless Domain Model

## Why there is no `User`

Left You One models a person's relationship to one gift, not a persistent profile. A sender discovers a gift, a recipient claims a transfer, and a holder may later pass the same gift onward. None of those actions requires registration or verified identity.

Names and coarse locations are descriptive metadata for one handoff or journey stop. They do not prove identity and do not grant access. Keeping this distinction prevents the prototype from becoming an account product before evidence shows that accounts would improve the human gesture.

## The four models

```text
GiftTemplate 1 ─── * Gift 1 ─── * Transfer
                       │                 │
                       └── 1 ─── * JourneyStop
                                         │
                              optional, unique Transfer
```

### `GiftTemplate`

An editable authored definition: the main thought, context, optional ritual, broad theme, and replaceable visual-treatment keys. `source_key` is stable and unique so YAML imports update rather than duplicate records. Templates can be inactive without being deleted.

The stored themes are `courage`, `calm`, `momentum`, `connection`, `luck`, `wonder`, and `strange`. “Surprise me” is a future selection mode across themes, not a stored theme.

### `Gift`

One persistent object discovered from a template. It has a database-generated serial number, opaque public slug, stable render seed, state, timestamps, and capability digests. `holder_generation` starts at zero and is intended to increase whenever a later claimant becomes the logical holder.

The serial number is displayable as `#000421`, but it is never authorization. The public slug is hard to guess but is also never authorization.

### `Transfer`

One intended handoff of a gift. It stores a private claim-token digest, state, sender display name, recipient dedication, holder generation at creation, timestamps, and an optional private note. The database permits at most one pending transfer per gift while retaining claimed or cancelled history.

`intended_recipient_name` is a dedication, not proof of who used the claim capability. The private note belongs to that transfer and must never become journey or public metadata.

For this local foundation, `private_note` is plaintext at rest. It is filtered from parameter logs and omitted from ordinary model serialization. Active Record Encryption is deliberately postponed until stable environment keys can be configured without making the prototype brittle. No public endpoint exists in this step.

### `JourneyStop`

One accepted period with a holder. It carries a per-gift sequence, arrival and departure times, and optional self-described public metadata. Anonymous is the default. A claimed transfer can produce at most one stop, and merely opening a future link must not create one.

The optional transfer foreign key preserves the small reversible schema described by the product documents, but application services should normally create stops only from successfully claimed transfers.

## States

`Gift` states:

- `discovered`: the exact gift exists and has been viewed, but is not sendable.
- `waiting_for_claim`: a future simulated commitment has created a pending transfer.
- `held`: a recipient has claimed the gift and is its logical current holder.

`Transfer` states:

- `pending`: the private recipient capability can still be claimed.
- `claimed`: the handoff succeeded and has one journey stop.
- `cancelled`: the handoff will not be claimed.

The transition workflow is not implemented yet. Future claim and pass services must update the gift, transfer, holder generation, and journey stops in one database transaction.

## Capability ownership

Private capabilities use 32 bytes of cryptographically secure randomness. Only deterministic SHA-256 digests are persisted and comparisons use a constant-time secure comparison.

- The originator receives a raw creator-management capability once when a gift is discovered. Its digest belongs to `Gift`.
- A future recipient receives a raw one-time claim capability when a `Transfer` is created. Its digest belongs to that transfer.
- A future current holder receives a reusable holder capability after claim. Its digest belongs to `Gift` and must rotate when the gift moves.
- The public `/o/:public_slug` shape may later show deliberately public provenance only. The slug never grants control.

The current code issues and validates tokens and issues the first creator capability. It does not yet put tokens in routes, cookies, logs, or browser sessions.

## Accountless interaction prepared by the schema

1. `Gifts::Discover` creates a `discovered` gift at generation zero and returns its raw creator capability once. It creates neither a transfer nor a journey stop.
2. A future commitment service creates a pending transfer and changes the gift to `waiting_for_claim`.
3. A future claim service atomically claims the transfer, changes the gift to `held`, advances its generation, creates the first journey stop, and issues a holder capability.
4. Optional public name and location edit that journey stop, not a profile.
5. A future pass keeps the existing holder in place until the next person claims. Claim closes the prior stop, advances the generation, rotates the holder capability, and creates the next stop.

## Adding persistent identity later

If testing eventually demonstrates a need for accounts, identity can be added as an optional layer over role-specific records: for example, a separate identity could link to selected journey stops or retained management capabilities. Gift ownership, transfer history, and journey sequencing would remain in these four models. Anonymous and capability-only participation could continue alongside signed-in participation.

That decision should follow evidence. It is not represented in the current schema.

## Deliberately postponed

- Controllers, public routes, recipient claim and authorization flows.
- Holder cookies, device sessions, token rotation, expiry, and replacement links.
- Complete transfer/claim/pass transition services.
- Recipient, sender, journey, and landing interfaces.
- Simulated checkout and all real payment behavior.
- Active Storage, runtime generation, analytics, administration, and deployment work.
