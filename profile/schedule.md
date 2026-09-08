# Weekly Schedule Template

Edit days/order freely — this is the fixed skeleton Claude builds each week's
plan around. The example below shows one possible setup (coached swims,
two Claude-designed running days, two Claude-designed gym days) — replace
it with whatever your actual week looks like.

| Day | Session | Alterable? |
|---|---|---|
| TODO | TODO (e.g. "Guided swim (coach-led), ~1km") | No — fixed, Claude doesn't touch |
| TODO | TODO (e.g. "Strength & conditioning") | Yes — Claude-designed |
| TODO | TODO (e.g. "Running — intervals/tempo") | Yes — Claude-designed, driven by recent Garmin run data |
| TODO | TODO | TODO |
| TODO | TODO | TODO |
| TODO | TODO (e.g. "Running — long run") | Yes — Claude-designed within a distance/pace band you set below |
| TODO | Rest / easy recovery | TODO |

## Strength & conditioning (if applicable)

Delete or rewrite this section if you don't have gym days.

- **Equipment:** TODO (e.g. "full gym access", "bodyweight only")
- **Timing:** TODO (e.g. "evenings, 60 minutes")
- **Experience level:** TODO — affects load/complexity Claude programs
- **Focus:** TODO (e.g. "running form and power — glute/hip strength,
  plyometrics, single-leg stability, calf/ankle stiffness")
- **Structure:** TODO — this is where you can be as specific or as loose
  as you want per day. Two worked examples:

  ```
  ### <Day 1> — fixed structure
  - Warm-up/mobility: exactly 5 exercises
  - Strength: exactly 6 exercises
  - Cool-down: 5 minutes

  ### <Day 2> — flexible, themed
  - Focus: agility (footwork, change-of-direction, reactive drills)
  - Volume: not capped — use the full time window, more exercises/sets
    than <Day 1> if the session calls for it
  ```

  The automation prompt (`scripts/weekly_plan_prompt.md`) reads whatever
  you put here — it does not hardcode exercise counts, so editing this
  section is enough to change what gets generated and emailed.

## Running days (if applicable)

- **Intervals/tempo day:** structure driven by current training phase
  (base/build/peak/taper), recent training-readiness signal, **and the
  actual pace/HR/cadence/GCT data from recent runs** — the run schedule is
  not a fixed template, it's regenerated from how the prior week's runs
  actually went.
- **Long run day:** progressive build toward the goal in
  [`athlete.md`](./athlete.md), staying within a distance/pace band you're
  comfortable with (TODO — set one, e.g. "15-20km zone 2"), respecting a
  safe weekly mileage ramp given current baseline and last week's
  execution.

## Notes

- Any fixed external session (coached swim, boxing class, etc.) should be
  treated as fixed training load — Claude reads its volume/intensity from
  Garmin to inform the days it does design, but doesn't design or alter
  the fixed session itself. Say so explicitly here if that's not what you
  want.
