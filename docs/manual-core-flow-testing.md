# Manual Core Flow Testing

## Prepare the local prototype

```sh
bin/setup --skip-server
bin/rails gifts:templates:import
bin/dev
```

Open `http://localhost:3000/start`. Use a normal browser for the sender, a private/incognito window for the recipient, and another browser or private profile for an ordinary public visitor. Do not paste private capability URLs into shared notes, screenshots, or public channels.

## Main sender and recipient session

1. In the sender browser, choose a theme and select **Find one**.
2. Confirm the exact Gift is still sealed and the person was not requested first.
3. Open it. Read it before continuing and note whether a real person comes to mind.
4. Select **Someone came to mind**. Enter the sender display name, optionally a recipient nickname, and optionally a private note.
5. Continue to the sender preview. Confirm the Gift looks identical to discovery and the preview is clearly labelled.
6. Select **Leave this for [name] · $2**. Confirm there are no billing fields and the prototype notice says no payment will be taken.
7. Copy the private recipient link. Keep the sender status tab open.
8. In the recipient private window, paste the link. Before opening, confirm the exact authored Gift and private note are not visible.
9. Open it. Confirm the authored Gift and private note appear, followed by **It’s with you now.**
10. Optionally add a display name, city, and two-letter country code, or continue anonymously.
11. Copy **Private holder access**, open it in another clean browser, and confirm it redirects to the clean public URL with holder controls still available.
12. Return to the sender tab. Confirm it now says the recipient opened the Gift and shows no holder controls or holder token.

## Public visitor and privacy

Before the recipient claims, open `/o/:public_slug` in the ordinary public browser. It should say only that the Gift is waiting for someone. It must not show the Gift text, recipient nickname, private note, or any private token.

After claim, refresh it. It may show the revealed Gift, public origin, serial/date, and an explicitly published holder mark. It must not show the private note or intended recipient nickname merely because the sender entered it.

## Edge scenarios

| Scenario | Steps | Expected result |
| --- | --- | --- |
| Already claimed | Reopen the original recipient link in a second private window after claim | Calm “already found someone” state; public journey remains available; no private note or holder controls |
| Anonymous recipient | Leave recipient nickname blank | Arrival says it was left for the recipient without inventing a name; public identity stays anonymous |
| Named recipient | Enter a nickname such as Anna | Arrival says “This is for you, Anna”; the nickname is not published automatically |
| Cancelled link | Activate, retain the claim URL, cancel from sender status, then open the old URL | Gentle unavailable/already-moved state; no claim succeeds |
| Replaced recipient | Activate for one person, choose **Change recipient**, activate again, then try both links | Old link cannot claim; replacement link can claim once |
| Long input | Use long names and a multi-paragraph note | Fields remain usable, content is normalized/limited, and the stage scrolls without horizontal overflow |
| Invalid token | Alter characters in creator, recipient, and holder URLs | Gentle not-found/404 behavior with no state or token digest exposed |
| Duplicate claim | Open one claim URL in two isolated windows and attempt both | Exactly one becomes holder generation 1; exactly one JourneyStop exists |

## Mobile and reduced motion

Use responsive mode at both `390 × 844` and `430 × 932`. Complete theme selection, sender reveal, recipient entry, activation, recipient arrival/reveal, optional identity, and public journey. Check that buttons remain reachable above browser chrome, text does not clip, and the document has no horizontal scroll.

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
