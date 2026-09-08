# Weekly Schedule Template

Edit this to match your actual week — this is the skeleton Claude builds
each week's plan around. There's no "right" amount of detail here: some
people just want "a couple of easy runs a week," others want every set
and rep spelled out. Start simple. You can always add more detail later.

## Your week

Replace the example below with your own days/sessions. This is already a
complete, valid schedule as-is — you don't need gym days, coached
sessions, or anything extra unless you actually have them.

| Day | Session | Alterable? |
|---|---|---|
| Monday | Rest | — |
| Tuesday | Easy run | Yes — Claude-designed |
| Wednesday | Rest | — |
| Thursday | Intervals/tempo run | Yes — Claude-designed |
| Friday | Rest | — |
| Saturday | Long run | Yes — Claude-designed, within a distance/pace band you set below |
| Sunday | Rest | — |

**Any day can be:**
- **Fixed** — something Claude shouldn't touch (a class, a coached
  session, work commitments). Claude will still glance at that day's
  Garmin data for context, but won't redesign it.
- **Claude-designed** — Claude plans it fresh each week, based on how
  your training's actually going.

## Running days

- **Speed/tempo day (if you have one):** structure driven by your current
  training phase and how your recent runs actually went — not a fixed
  template.
- **Long run day (if you have one):** stays within a distance/pace band
  you're comfortable with — TODO, set one here (e.g. "5-8km, easy pace"),
  progressing safely toward your goal in [`athlete.md`](./athlete.md).

If you're not training toward anything structured and just want steady,
sensible runs, you can delete this section entirely — Claude will fall
back to general safe-progression judgment.

## Gym/strength day (optional — delete if not relevant)

If you want a gym day, describe it here — equipment, how much time you
have, your experience level, and what you want it focused on. Be as loose
or as specific as you like:

- **Loose example:** "40 minutes, bodyweight only, general strength,
  whatever seems useful."
- **Specific example:** "60 minutes, full gym access. Exactly 5 warm-up
  exercises, 6 strength exercises, then a 5-minute cool-down."

The automation (`scripts/weekly_plan_prompt.md`) follows whatever you
write here exactly — a loose instruction gets a looser session, a
specific one gets followed to the letter.

## Notes

- Any day marked "fixed" above (a class, a coached session, etc.) is
  treated as fixed training load — Claude reads it for context but
  doesn't redesign it.
