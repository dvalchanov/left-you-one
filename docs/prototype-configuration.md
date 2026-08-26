# Prototype Configuration

## Environment settings

The centralized interface is `LeftYouOne.config`:

```ruby
LeftYouOne.config.prototype_mode
LeftYouOne.config.display_price_cents
LeftYouOne.config.display_currency
```

Supported environment variables:

| Variable | Default | Meaning |
| --- | --- | --- |
| `PROTOTYPE_MODE` | `true` in development; `false` elsewhere | Enables explicitly simulated prototype behavior. It does not enable billing. |
| `DISPLAY_PRICE_CENTS` | `200` | Working display price in minor currency units. Must be a non-negative integer. |
| `DISPLAY_CURRENCY` | `USD` | Three-letter display currency code. |

`.env.example` lists the working local values. Rails does not load `.env` files by itself in this repository; export the values in the shell or configure them through the process runner. No dotenv dependency was added.

The price is a display hypothesis only. No payment provider, checkout, or charge exists.

## Editable interface copy

Product-defining English copy lives in `config/locales/en.yml` under `brand`, `landing`, `start`, `sender`, `recipient`, `holder`, `journey`, `prototype`, and `faq`. Future views should interpolate a formatted price rather than hardcode `$2`.

## Gift-template library

The small authored development library lives in `db/gift_templates.yml`. It contains three active examples for each working theme. Re-importing updates records by `source_key` and does not create duplicates.

Import it directly:

```sh
bin/rails gifts:templates:import
```

Or prepare and seed the database:

```sh
bin/rails db:prepare
bin/rails db:seed
```

`db/seeds.rb` calls the same idempotent importer.

## Creating a discovered gift

In `bin/rails console`:

```ruby
template = GiftTemplate.active.first
result = Gifts::Discover.call(gift_template: template)

result.gift.display_serial_number
result.gift.public_slug
result.creator_manage_token # returned raw only from this call
```

For a stable visual seed during a test:

```ruby
result = Gifts::Discover.call(gift_template: template, render_seed: 12_345)
```

Only the creator token digest is stored. Treat the returned raw value as a private capability and do not log it.

## Verification commands

```sh
bin/rspec
bin/rubocop
bin/ci
```

`bin/ci` runs setup, style, dependency and security audits, RSpec, and a seed replant. The project still contains the Rails-generated Minitest directories, but the product-domain suite is RSpec with FactoryBot.
