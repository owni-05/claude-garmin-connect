# Training Rules & Automation Preferences

Edit any value here to change how the plan is built and delivered. Most
sections below are optional — delete what doesn't apply to you. The one
thing everyone needs to set is **Delivery email** near the bottom.

## Data sources

Garmin covers most of this automatically:

| Data | Source | Tool |
|---|---|---|
| Activities (runs, etc.): HR, cadence, power, splits | Garmin Connect | `garmin_mcp` |
| Sleep, HRV, stress, body battery, training readiness/load | Garmin Connect | `garmin_mcp` |
| Body composition (weight, muscle mass) | Garmin Connect | `garmin_mcp` |
| Calorie intake / food log | Garmin Connect | `garmin_mcp` |
| Menstrual cycle (if relevant to you) | **Not in Garmin** — told directly by you, see `athlete.md`. Delete this row if not applicable. | manual |
| Running dynamics (GCT, vertical osc/ratio, stride length, power) | TODO — depends on your device; most recent Garmin running watches support this wrist-based, no accessory needed | `garmin_mcp` |

## Deload week trigger (optional)

If you don't want a formal "easier week" pattern, delete this section —
Claude will still ease off if your Garmin readiness/HRV data looks bad,
just without a fixed rule.

Otherwise, pick whichever model fits you, or write your own:

- **Cycle-informed** (if `athlete.md` has cycle data): reduce intensity
  and volume during the phase you report as hardest.
- **Fixed-cadence:** e.g. every 4th week is a deload, regardless of
  other signals.
- **Fatigue-metric-based:** trigger off Garmin training-readiness/HRV/
  body battery thresholds you set here.

Either way, Garmin training-readiness/HRV/body battery should be checked
as a secondary signal — if it's poor even outside a deload phase, Claude
should flag it and suggest adjusting rather than silently pushing
through.

## Weekly cycle trigger (optional automation)

By default, you just ask Claude for a plan whenever you want one — no
automation needed.

If you've set up the optional weekly automation (see the README), this
section describes it: **automatic, once a week** — a local scheduled job
(macOS `launchd`, see [`scripts/`](../scripts)) runs headless Claude Code
with Garmin access on your own machine (the Garmin connection is
local-only, so this can't run on a cloud scheduler — it has to run on
your computer). You can still ask for an ad-hoc plan anytime; that
doesn't replace the scheduled run.

## Delivery email

**Recipient:** TODO — your email address, e.g. `you@example.com`. The
automation reads this field at runtime, so filling it in here is the only
place you need to set it.

**Delivery mode:** TODO — pick one:
- `draft` — Claude creates a Gmail draft each week; you review and hit
  send yourself. Safer default for an unattended job.
- `auto-send` — Claude sends the email straight to your inbox with no
  review step.

## What the weekly job does (if you're using the automation)

1. Looks at the past week's real Garmin data — what improved, what needs
   work.
2. Builds next week's Claude-designed sessions from `schedule.md`,
   respecting any fixed/coached days and your deload rule above (if any).
3. Schedules those sessions onto your Garmin calendar.
4. Delivers the writeup via Gmail per **Delivery mode** above.

## Progression safety

- Any distance/volume ramp stays capped at a conservative, injury-aware
  rate given your baseline in `athlete.md` — Claude should flag it rather
  than silently overload you if a goal date looks too aggressive for a
  safe ramp from your current volume.
