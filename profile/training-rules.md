# Training Rules & Automation Preferences

Edit any value here to change how the plan is built and delivered.

## Data sources

| Data | Source | Tool |
|---|---|---|
| Activities (runs, swims): HR, cadence, power, splits | Garmin Connect | `garmin_mcp` |
| Sleep, HRV, stress, body battery, training readiness/load | Garmin Connect | `garmin_mcp` |
| Body composition (weight, muscle mass) | Garmin Connect | `garmin_mcp` |
| Calorie intake / food log | Garmin Connect | `garmin_mcp` |
| Menstrual cycle | **Not in Garmin** — told directly by you, see `athlete.md` (delete this row if not applicable) | manual |
| Running dynamics detail (GCT, vertical osc/ratio, stride length, power) | TODO — depends on your device; most recent Garmin running watches support this wrist-based, no accessory needed | `garmin_mcp` |

## Deload week trigger

Pick whichever model fits you, or write your own:

- **Cycle-informed** (if `athlete.md` has cycle data): reduce running/S&C
  intensity and volume during the phase you report as hardest (common
  default assumption: menstrual + late luteal — confirm/correct once
  you've logged a cycle or two). Fixed/coached sessions stay as-is
  regardless.
- **Fixed-cadence:** e.g. every 4th week is a deload, regardless of
  signals.
- **Fatigue-metric-based:** trigger off Garmin training-readiness/HRV/body
  battery thresholds you set here.

Garmin training-readiness/HRV/body battery should be checked as a
secondary signal either way — if it's poor even outside a deload phase,
Claude should flag it and suggest adjusting rather than silently pushing
through.

## Weekly cycle trigger

**Automatic, weekly on Sunday morning** — a local scheduled job (macOS
`launchd`, see [`scripts/`](../scripts)) runs headless Claude Code with
Garmin MCP access on this machine (the OAuth token in `~/.garminconnect`
is local-only, so this can't run on Anthropic's cloud scheduler — it has
to run here). You can still ask for an ad-hoc review anytime; that doesn't
replace the Sunday run.

## Delivery email

**Recipient:** TODO — your email address, e.g. `you@example.com`. The
automation reads this field at runtime, so filling it in here is the only
place you need to set it.

**Delivery mode:** TODO — pick one:
- `draft` — Claude creates a Gmail draft each week; you review and hit
  send yourself. Safer default for an unattended cron job.
- `auto-send` — Claude sends the email straight to your inbox with no
  review step.

## Weekly output delivery

Every Sunday morning, the scheduled job:

1. Analyzes the past week from real Garmin data (pace/HR/cadence/GCT from
   the running days, plus training readiness/HRV/sleep/load trend) — what
   improved, what needs work.
2. Builds next week's Claude-designed running and gym sessions, driven by
   that analysis (respecting fixed/coached days and the current
   deload/build phase).
3. Schedules those sessions onto the Garmin calendar via `garmin_mcp`.
4. Delivers the writeup via Gmail per the **Delivery mode** above.

## Progression safety

- Long-run/weekly-mileage ramp capped at a conservative, injury-aware rate
  given your baseline in `athlete.md` — Claude will flag if your target
  date is too aggressive for a safe ramp from current volume, rather than
  silently overloading you to hit the date.
