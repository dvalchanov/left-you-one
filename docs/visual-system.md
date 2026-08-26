# Recipient Visual System

## Status and purpose

This is a replaceable prototype system for comparing whether a received gift can feel like a small visual world rather than a quote placed over a generic background. It is deliberately configuration-driven and development-only. The treatments are not a final brand system, and the included artwork is prototype artwork rather than approved production photography.

The reusable stage is rendered by `app/views/recipient_experiences/_stage.html.erb`. The clean preview and the laboratory both use the same partial, so changes are evaluated against the same recipient composition.

## Stage layout

The experience uses one photographic stage rather than a stack of cards:

- the page keeps `10–28px` of responsive outer space, including safe-area insets;
- the stage fills the remaining stable viewport height with `svh`;
- radius scales from roughly `25px` on mobile to `40px` on desktop;
- imagery, overlays, content, opening controls, possession, and journey context remain inside that one stage;
- the stage scrolls internally only when revealed copy needs more room;
- arrival aims to remain a composed single-screen scene.

The type and image are composed together through six constrained placements: bottom left, bottom center, center, upper left, center left, and quiet corner. There is no arbitrary positioning interface.

## Configuration model

Visual experimentation lives in `config/gift_visuals.yml`. A `GiftTemplate` still supplies `visual_family`, `finish`, `background_key`, and `design_seed`; the catalog maps the Prompt 2 vocabulary onto the current prototype families without changing the database schema. Unknown database or query values fall back to a known local treatment.

Each background can set:

- a local asset path;
- focal position;
- light or dark text;
- composition;
- overlay;
- motion;
- grain;
- accent and finish.

Preview query parameters can override the editable choices, but only with keys present in the catalog. They cannot inject an asset URL, CSS position, or class name.

## Visual families

| Family | Working role | Default background |
| --- | --- | --- |
| Quiet Light | Warm natural light; intimate and human | Linen at four |
| Distant Horizon | Open space and reflective distance | Spare horizon |
| After Rain | Cooler glass, water, and softened light | Glass after rain |
| Night Window | Rich shadow with one restrained light source | Last light awake |
| Close Detail | Tactile crops of fabric, paper, and glass | Paper, linen, glass |
| Strange Stillness | Slightly surreal but still photographic | Weather indoors |

They share the same stage, type hierarchy, grain logic, motion restraint, and interaction. A family is an art direction, not a different website template.

## Prototype image assets

The six local WebP files live in `app/assets/images/prototype/receiver/` and are each 23–121 KB at `1536 × 1024`. They were generated for this prototype as clearly replaceable editorial placeholders. No remote image URL is used.

To replace one:

1. Prepare a licensed landscape image with useful negative space and a portrait-safe focal area.
2. Export an optimized WebP near the existing dimensions.
3. Put it under `app/assets/images/prototype/receiver/`.
4. Update only the matching `asset` and `focal_position` values in `config/gift_visuals.yml`.
5. Check every composition at `390 × 844`, `430 × 932`, `768 × 1024`, and desktop widths before accepting the crop.

Do not bake gift text into a replacement image. Do not silently treat the current generated files as licensed final photography.

## Image treatment

The image layer supports focal position, cover scaling, finish filters, a static overlay wash, a sealed-state treatment, and optional slow motion. A small static SVG-noise texture is embedded in CSS and mixed softly over the stage. It is not animated and can be disabled with `grain: none`.

Overlay presets are restrained gradients selected for the type-safe part of each image. Text tone is explicit rather than inferred at runtime. Every new asset still needs a manual contrast check in its actual composition.

## Sealed treatments

Three treatments remain available for comparison:

- **Veiled image** — the final photograph stays present behind translucent colored glass: softened enough to remain unknown, while its palette and atmosphere are still visible.
- **Soft cover** — a borderless translucent layer obscures the photographic object without placing the arrival inside an inset panel.
- **Light hidden** — the image waits in near-darkness and resolves as light returns.

The default is **Veiled image**. It best preserves continuity between arrival and reveal: the recipient opens the thing already in front of them, without literal gift-box imagery or an animation that suggests a prize.

## Motion rules

Available modes are none, slow push, slow drift, slight parallax, and gentle light shift. Image loops take roughly `22–30s`; parallax is capped at six pixels. Motion pauses when the document is hidden.

The user-initiated opening takes about `1.85s`: arrival recedes, the veil lifts, the authored gift resolves, the note follows, and possession appears after the first reading moment. “Show it now” completes the sequence immediately.

Both the operating-system preference and the laboratory’s reduced-motion simulation disable image movement and transformation. Opening then changes state immediately with no loss of text or focus behavior.

## Responsive rules

- The stage keeps visible outer space and rounded corners on phone and desktop.
- Typography uses bounded fluid scales; the long-copy test has a smaller dedicated scale.
- Touch targets remain at least about `49px` high.
- Important content stays inside safe-area-aware padding.
- Revealed and long-content states may scroll inside the stage; arrival should not require scrolling under the target phone sizes.
- Extra desktop width expands the composition rather than introducing site navigation or side panels.

## Accessibility behavior

- “Open it” and “Show it now” are real buttons with visible keyboard focus.
- Gift text remains semantic HTML over a decorative image with empty alternative text.
- Before opening, the reveal region is both hidden and marked `aria-hidden`.
- When opening settles, focus moves to the revealed gift heading and a polite live region announces the state.
- Light/dark modes and overlay choices provide explicit contrast control.
- No meaning relies only on color or motion.
- Forced-colors mode adds structural borders and reduces the decorative image.

## Unresolved visual decisions

- Which family creates the strongest sender-recipient association rather than merely looking attractive?
- Does the private note feel integrated, or does it make the authored gift feel secondary?
- Is the serif voice intimate and contemporary enough across humorous and strange gifts?
- Does Veiled image remain satisfying after repeated use?
- Should the origin and prototype serial be visible at first reveal or delayed further?
- Which final image sources and licenses are appropriate if real-person testing expands beyond controlled prototype sessions?

These require observation with real recipients. The implementation only makes them easy to compare.
