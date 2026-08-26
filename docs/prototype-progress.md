# Prototype Progress

This is the shared status log for future product-design and implementation steps. Update it after every requested step; keep newest entries first and do not rewrite past observations to match later conclusions.

## Current status

- **Phase:** Technical foundation complete; experiential prototype not started
- **Current objective:** Preserve an editable, accountless base for testing reverse gifting
- **Prototype entry point:** None yet; console and YAML content only
- **Last updated:** 2026-08-26
- **Updated by:** Codex

## Active step

- [x] Build the technical foundation and minimal accountless domain model

**Hypothesis being tested:** This implementation does not validate a product hypothesis by itself. It prepares reversible persistence and content needed for later tests of association, sender intention, recipient recognition, possession, and journey.

**Scope:** Central prototype configuration, editable I18n copy, four PostgreSQL models, capability-token utility, discovered-gift service, 21-template YAML library/importer, RSpec/FactoryBot suite, and developer documentation.

**Reversible assumptions:** Seven string themes; three gift and three transfer states; a database-generated serial plus separate opaque public slug; one pending transfer per gift; holder generation on the gift; optional per-stop identity; plaintext private notes for this local-only stage.

**Validation planned:** Run migrations, import twice, run RSpec and lint, boot Rails, inspect database constraints and the final diff, and confirm no user/authentication/payment dependency exists.

## Completed steps

### 2026-08-26 — Accountless technical foundation

- **Request:** Build only the Rails foundation and smallest reversible accountless domain needed for the prototype.
- **Changed:** Added `GiftTemplate`, `Gift`, `Transfer`, and `JourneyStop`; PostgreSQL integrity constraints; capability-token issuance/validation; transactional discovered-gift creation; centralized display configuration and copy; an idempotent curated template import; RSpec/FactoryBot; and domain/configuration documentation.
- **Hypothesis:** Creates the technical base for later testing without pre-deciding accounts, final transfer rules, payment, or the visual experience.
- **Assumptions:** Recipient names are dedications; public slugs grant no control; raw capabilities are returned only at issuance; a holder remains in place while a later transfer is pending; journey stops represent claimed handoffs only.
- **Validation and result:** Database migration and 21-template development import succeeded. Import idempotency, model behavior, services, token handling, and database constraints are covered by 41 passing RSpec examples. The full `bin/ci` workflow passed, including RuboCop, dependency audits, Brakeman, RSpec, and seed replant; Rails also eager-loaded successfully. No people have tested the experience.
- **Evidence learned (if tested with people):** None. Product hypotheses remain unresolved.
- **Open questions:** Exact claim semantics, old-link behavior, note timing, location consent, passing price and withdrawal, and whether persistent identity ever adds enough value.
- **Most useful next test:** Build the smallest art-directed discovery/reveal sequence that can test H1–H4 before adding the full transfer flow.

## Hypothesis status

- H1–H12 remain unresolved; no participant evidence was collected in this step.

## Open decisions

- Pricing, categories, final theme set, and exact gift anatomy remain hypotheses.
- Whether a landing example can become a real gift should be tested in the experience.
- Claim versus open versus explicit accept semantics remain undecided; the schema supports a later transactional choice.
- Originator journey visibility, current-holder link rotation, pending-transfer replacement/expiry, and onward-passing price remain undecided.
- Public journey identity and location remain opt-in, coarse, and unverified if introduced.
- Persistent identity should be added only if accountless testing reveals a concrete need.
- “Someone probably needs this more than you do” is centralized as requested but may pressure a holder to pass; do not surface it without testing against the keep-is-valid guardrail.

## Known issues

- `Transfer#private_note` is plaintext at rest for the local prototype. It is filtered from parameter logs and ordinary serialization, but encryption must be revisited before storing real sensitive notes outside controlled local testing.
- Capability authorization routes, cookies, rotation, and claim/pass transactions are not implemented.
- There is intentionally no root product route or user-facing experience yet.
- The Rails-generated Minitest scaffold remains, while product-domain coverage uses RSpec.
