# Weekly Schedule Template

Edit this to match your actual week — this is the skeleton Claude builds
each week's plan around. Replace the example below with your own
days/sessions; delete rows or whole sections you don't need.

## Your week

| Day | Session | Alterable? |
|---|---|---|
| Monday | Rest | — |
| Tuesday | Easy run | Yes — Claude-designed |
| Wednesday | Strength & conditioning | Yes — Claude-designed |
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

- **Equipment:** TODO — e.g. "full gym access (barbells, machines, free
  weights)", "bodyweight only, no equipment", "a few dumbbells at home"
- **Timing:** TODO — e.g. "mornings, 45 minutes"
- **Experience level:** TODO — beginner/intermediate/advanced; affects
  load and complexity Claude programs
- **Focus:** TODO — e.g. "general strength", or something more specific
  like "running form and power — glute/hip strength, plyometrics,
  single-leg stability"
- **Structure:** as loose or as specific as you like, for example: "5
  warm-up exercises, 6 strength exercises, then a 5-minute cool-down" —
  or just "whatever fits in the time, your judgment."

The automation (`scripts/weekly_plan_prompt.md`) follows whatever you
write here exactly — a loose instruction gets a looser session, a
specific one gets followed to the letter.

## Notes

- Any day marked "fixed" above (a class, a coached session, etc.) is
  treated as fixed training load — Claude reads it for context but
  doesn't redesign it.
