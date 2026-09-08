# Athlete Profile

Edit any value here directly — this file drives the training plan. Blank
fields marked `TODO` need to be filled in before the plan can be finalized.

## Goal

- **Event:** TODO (e.g. `10K`, `21K half marathon`, `marathon`, or just
  "general fitness" with no race)
- **Target date(s):** TODO — exact date(s), e.g. `2026-11-15`. List more
  than one if you have multiple races on the calendar; note which is the
  near-term priority.
- **Priority:** TODO — which race (if any) is the A-race right now.

## Current baseline (fill in — needed to build a safe ramp)

- **Longest recent run:** TODO (e.g. `6km`, or "already running 15-20km
  long runs weekly")
- **Current running frequency:** TODO (e.g. `2x/week`)
- **Running experience:** TODO (e.g. "beginner", "a little better than
  beginner", "experienced")
- **Swimming experience:** TODO — only relevant if swimming is part of
  your schedule
- **Gym/strength experience:** TODO (e.g. "beginner", "advanced")
- **Gym session time cap:** TODO (e.g. `60 minutes`) — see
  [`schedule.md`](./schedule.md) for day/time

## Body stats

- **Age:** TODO
- **Sex:** TODO
- **Weight:** TODO
- **Height:** TODO
- **Muscle mass:** TODO
- _(Source: Garmin Connect — `get_body_composition` / `get_weigh_ins`. Fill
  this in manually only if Garmin data is unavailable or wrong.)_

## Injury history / constraints

TODO — any current niggles, past injuries, or movements to avoid in
strength sessions. Leave as "none" if not applicable.

## Menstrual cycle

Only relevant if you want cycle-informed deload logic. Not tracked in
Garmin Connect — tell Claude directly, ideally as:

- **Last period start date:** TODO
- **Typical cycle length:** TODO (days)

This drives the cycle-informed deload logic in
[`training-rules.md`](./training-rules.md). Update the start date each
cycle so the deload phase estimate stays current. Delete this section
entirely if it doesn't apply to you.
