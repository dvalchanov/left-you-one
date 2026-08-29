# Manual Core Flow Testing

## Prepare the local prototype

```sh
bin/setup --skip-server
bin/rails gifts:templates:import
bin/dev
```

Open `http://localhost:3000/`. Use a normal browser for the sender, a private/incognito window for the recipient, and another browser or private profile for an ordinary public visitor. Do not paste private capability URLs into shared notes, screenshots, or public channels.

## Landing overview

1. Confirm the first viewport explains that the Gift is discovered before its person and offers **Start a new gift**.
2. Read **It works backwards** and confirm the sequence is discover, notice, leave, then open and keep.
3. Expand all three illustrative paths. Confirm they can be read but offer no join, claim, or recipient action.
4. Confirm the invitation section says that receiving begins through a private invitation and that its only action starts a new Gift.
5. Create a real private Gift in another session and refresh `/`. Confirm its names, note, slug, and journey never appear on the landing page.
6. Select **Start a new gift** and confirm it enters `/start` without choosing one of the illustrative examples.

## Main sender and recipient session

1. In the sender browser, choose a theme and select **Find one**.
2. Confirm the exact Gift appears immediately, no sender **Open it** action is present, and the person was not requested first.
3. Read it before continuing. Confirm **This isn’t for anyone yet**, **Who came to mind?**, and the short handoff explanation make the sequence understandable without a verbal pitch.
4. Select **Someone came to mind**. Enter the sender display name, the recipient's first name or nickname, and optionally a private note.
5. Continue to the sender preview. Confirm the Gift looks identical to discovery and the preview is clearly labelled.
6. Select **Leave this for [name] · $2**. Confirm there are no billing fields and the prototype notice says no payment will be taken.
7. Copy the private recipient link. Keep the sender status tab open.
8. In the recipient private window, paste the link. Before opening, confirm the exact authored Gift and private note are not visible.
9. Open it. Confirm the authored Gift and private note appear, followed by **It’s with you now.**
10. Confirm no identity, city, country, or holder-access form appears. Select **See how it got here** and confirm the private journey already says it began with the sender and is now with the named recipient.
11. Return to the Gift and confirm possession still reads as the end of opening, not as an incomplete setup step.
12. Return to the sender tab. Confirm it now says the recipient opened the Gift. Select **See its journey** and confirm the same private handoff is visible without exposing holder controls or tokens.

## Public visitor and privacy

Before the recipient claims, open `/o/:public_slug` in the ordinary public browser. It should say only that the Gift is waiting for someone. It must not show the Gift text, recipient nickname, private note, or any private token.

After claim, refresh it. It may show the revealed Gift and public origin. It must not show the private note or intended recipient nickname. Attempting the journey URL without a creator or holder cookie must return not found.

## Edge scenarios

| Scenario | Steps | Expected result |
| --- | --- | --- |
| Already claimed | Reopen the original recipient link in a second private window after claim | Calm “already found someone” state; no journey link, private note, or holder controls |
| Missing recipient | Submit the sender form without a recipient nickname | The form remains on the handoff step and asks who it is for |
| Named recipient | Enter a nickname such as Anna | Arrival says “This is for you, Anna”; claim records Anna on the private journey automatically but the public slug does not expose it |
| Cancelled link | Activate, retain the claim URL, cancel from sender status, then open the old URL | Gentle unavailable/already-moved state; no claim succeeds |
| Replaced recipient | Activate for one person, choose **Change recipient**, activate again, then try both links | Old link cannot claim; replacement link can claim once |
| Long input | Use long names and a multi-paragraph note | Fields remain usable, content is normalized/limited, and the stage scrolls without horizontal overflow |
| Invalid token | Alter characters in creator, recipient, and holder URLs | Gentle not-found/404 behavior with no state or token digest exposed |
| Duplicate claim | Open one claim URL in two isolated windows and attempt both | Exactly one becomes holder generation 1; exactly one JourneyStop exists |

## Mobile and reduced motion

Use responsive mode at both `390 × 844` and `430 × 932`. Complete theme selection, direct sender discovery, recipient entry, activation, recipient arrival/reveal, possession, and the optional private journey. Check that buttons remain reachable above browser chrome, text does not clip, and the document has no horizontal scroll.

Enable **Reduce motion** in the operating system or browser emulation and repeat the opening. The hold hint should disappear, opening should complete immediately, and every state and focus change should remain understandable without animation.

## Visual-default stability

1. From a sender management page, expand **Prototype testing** and open the gift moment laboratory.
2. Select a treatment and choose **Set as prototype default**.
3. Return to the current Gift. Confirm it has not changed.
4. Start another Gift. Confirm the new sender scene uses the newly selected treatment.
5. Activate it and open it as the recipient. Confirm sender and recipient see the same artwork, crop, typography, overlay, grain, seal, and motion choice.
6. Change the default again in the lab.
7. Reopen both already-created Gifts. Confirm each retained the appearance it had at discovery.

The checked-in starting default is Paper World / A way through, Warm grain, Bottom left, Soft cover, Slow push, Soft grain, Paper edge, and Dark type.

## Product-owner observation record

Record behavior before discussing the concept with the participant.

| Question | Observation / quote | Confidence or follow-up |
| --- | --- | --- |
| Did a real person come to mind? |  |  |
| Did the `$2` moment feel natural? |  |  |
| Did the sender experience feel too long? |  |  |
| Did the recipient arrival create curiosity? |  |  |
| Did the reveal feel special? |  |  |
| Did the private note add value? |  |  |
| Did “It’s with you now” make sense? |  |  |
| Would the recipient pass it later? |  |  |
| Did the selected visual treatment still feel right in the real flow? |  |  |
| Did the photographic/artwork stage feel premium rather than decorative? |  |  |
| What felt cheesy? |  |  |
| What felt like a quote generator? |  |  |
| What should change before building the landing page? |  |  |

Do not mark a hypothesis validated from the builder’s own walkthrough. The next useful evidence is an observed sender-recipient pair using separate browsers without prior explanation.
