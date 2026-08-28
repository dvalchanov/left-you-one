# Core Flow Implementation

## Implemented slice

The prototype now carries one stable `Gift` from discovery through the first recipient claim:

```text
/start
  → discover and open an exact Gift
  → name a sender and optional intended recipient
  → add an optional private note
  → simulate “Leave this for [name] · $2”
  → share a private claim link
  → recipient claims and opens the Gift
  → first JourneyStop and current-holder access
  → optional public identity and public journey
```

This is the first sender-to-recipient flow only. Onward passing, real payment, accounts, delivery, and the landing page are not implemented.

## Routes and access

| Route | Purpose | Access |
| --- | --- | --- |
| `GET /start` | Choose a broad theme or Surprise me | Public |
| `POST /gifts` | Discover exactly one Gift | Session idempotency key |
| `GET /manage/:token` | Establish creator access, then redirect | Creator capability |
| `GET /gifts/:public_slug/manage` | Discovery, recipient, commitment, and sender status scenes | Encrypted creator cookie |
| `POST /gifts/:public_slug/reveal` | Record the creator reveal | Encrypted creator cookie |
| `POST /gifts/:public_slug/recipient` | Store a short-lived sender draft | Encrypted creator cookie |
| `POST /gifts/:public_slug/activate` | Simulate the `$2` commitment and create a pending Transfer | Encrypted creator cookie |
| `POST /gifts/:public_slug/cancel` | Cancel the pending handoff | Encrypted creator cookie |
| `GET /gifts/:public_slug/recipient-preview` | Preview without claiming or mutating | Encrypted creator cookie |
| `GET /open/:token` | Show the private sealed recipient arrival | Recipient claim capability |
| `POST /open/:token/claim` | Atomically claim the pending Transfer | Recipient claim capability |
| `GET /hold/:token` | Establish reusable current-holder access, then redirect | Holder capability |
| `GET /o/:public_slug` | Show safe public provenance and, when authorized, holder aftercare | Public slug; optional holder/creator cookie |
| `PATCH /o/:public_slug/holder_identity` | Update the current JourneyStop’s optional public mark | Encrypted holder cookie |

Development/test also provides `/dev/recipient-lab`, `/dev/recipient-preview`, `POST /dev/prototype-visual-default`, and safe deletion of only an unactivated current test Gift.

## Controllers and services

`StartsController` and `GiftsController` handle discovery. `CreatorCapabilitiesController` converts the raw management link into a clean creator session. `ManagedGiftsController` owns sender scenes. `RecipientClaimsController` owns the one-time claim boundary. `HolderCapabilitiesController` establishes reusable current-holder access. `PublicGiftsController` separates ordinary public rendering from creator- and holder-aware rendering.

State-changing domain work stays in small services:

- `GiftTemplates::Select` selects by theme or across active templates for Surprise me.
- `Gifts::Discover` creates one idempotent discovered Gift and snapshots its visual configuration.
- `Gifts::ActivateForRecipient` authorizes the creator, creates or replaces one pending Transfer, and moves the Gift to `waiting_for_claim`.
- `Gifts::CancelPendingTransfer` cancels the current pending handoff and returns the Gift to `discovered`.
- `Transfers::Claim` locks the Transfer and Gift, makes the first claimant holder generation 1, and creates exactly one JourneyStop.
- `JourneyStops::UpdateIdentity` authorizes the current holder generation and applies an explicit public or anonymous choice.

## State transitions

```text
Discovery
  Gift: new → discovered
  holder_generation: 0
  Transfer: none
  JourneyStop: none

Simulated activation
  Gift: discovered → waiting_for_claim
  Transfer: new → pending, source_holder_generation 0

First claim
  Gift: waiting_for_claim → held
  holder_generation: 0 → 1
  Transfer: pending → claimed
  JourneyStop: none → sequence 1
```

Creator reveal changes only `opened_by_creator_at`. It does not activate the Gift or create journey records. A duplicate discovery submission returns the same Gift. Repeating activation with the same retained claim capability returns the same pending Transfer. Replacing a pending recipient cancels the earlier Transfer first. Concurrent claims are serialized; exactly one becomes `claimed` and produces sequence 1.

## Capabilities and cookies

Creator, claim, and holder capabilities are independent random values. Only SHA-256 digests are stored. The public slug is never sufficient for a private action.

- The creator link is consumed into an encrypted, HTTP-only, SameSite Lax cookie and redirected to a clean URL.
- The claim capability remains in the private `/open/:token` URL until claim. The exact Gift and private note are withheld before claim.
- A successful claim creates a new holder capability, stores its digest on the Gift, and puts the raw value in an encrypted holder cookie. A quiet holder disclosure can recreate `/hold/:token` for another browser.
- Cookies are `Secure` when served over HTTPS. Holder access also records `holder_generation`; a future move invalidates the previous generation even before token rotation is expanded.
- Token pages and cookie-specific private responses use `no-referrer`, `noindex`, and `private, no-store` headers. Sensitive parameter names and private notes are filtered from logs.

Encrypted cookies protect capabilities from ordinary client-side script but are not a production device-management or revocation system. Anyone who receives a raw capability can exercise that role while it remains valid. Token expiry, rotation UI, recovery, abuse handling, and private-note encryption at rest need a security review before use beyond controlled testing.

## Public and private boundaries

Before claim, `/o/:public_slug` shows only a sealed waiting state. It omits the authored Gift text, context, ritual, intended recipient name, and private note. After claim, it may show the authored Gift, serial, public origin, date, aggregate journey state, and only holder identity fields the holder explicitly published.

The intended recipient name remains a private dedication. It never becomes public identity automatically. The sender’s private note is visible to the creator and authorized current holder, but not an ordinary public visitor. Creator access does not grant holder controls; holder access does not grant creator controls.

## Simulated activation

The `$2` action performs no billing and creates no purchase record. The server transaction uses the same boundary a future confirmed payment could call, but today it immediately creates the pending Transfer and reseals the Gift for the recipient. The screen explicitly says that no payment will be taken.

## Selected visual configuration

`config/prototype_visual_default.yml` currently records the product owner’s selected treatment:

- Paper World / A way through
- Warm grain
- Bottom left
- Soft cover
- Slow push
- Soft grain
- Paper edge
- Dark type

`GiftVisuals::PrototypeDefault` validates lab selections against `config/gift_visuals.yml`. When a Gift is discovered, `Gifts::Discover` resolves this configuration and stores the small result in `gifts.visual_configuration`. Sender discovery, recipient arrival, holder view, and public journey all render from that snapshot. Changing the global default therefore affects only future Gifts; an existing Gift does not change after it has been viewed or sent.

## Known prototype shortcuts

- Activation is local and immediate; there is no payment provider.
- The sender shares the recipient URL manually; there is no email or SMS delivery.
- Private notes are plaintext in the local PostgreSQL database, although filtered from logs and ordinary serialization.
- Creator and holder cookies currently retain one Gift capability at a time per browser role.
- Holder identity is self-described and unverified.
- The public journey is intentionally simple and usually contains one stop.
- Passing onward is a non-mutating placeholder. It will later need a new pending Transfer from the current generation, closing the prior JourneyStop only when the next claim succeeds, and holder-token rotation.
- Prototype artwork is local generated placeholder material, not final licensed photography.
