# Weekly Training Plan Generation

You are running **unattended** (no human in the loop) as a Sunday-morning
scheduled job. Do not ask clarifying questions — if something is missing,
note the gap in the email and continue. Follow this procedure.

## 1. Read config

Read `profile/athlete.md`, `profile/schedule.md`, and
`profile/training-rules.md` for the athlete profile, the fixed weekly
skeleton, and the automation/deload rules.

## 2. Pull the last 7 days of Garmin data

Using the `garmin` MCP tools:

- Every Claude-designed running day from `schedule.md`: `get_activities`,
  `get_activity`, `get_activity_splits`, `get_activity_hr_in_timezones` —
  pace, HR zones, cadence, ground contact time, vertical
  oscillation/ratio, power.
- Every fixed/coached day from `schedule.md` (swim, boxing, etc.), if
  logged, for overall load context (these are fixed and not redesigned,
  but count toward total training load).
- `get_training_readiness`, `get_training_status`, `get_training_load_trend`,
  `get_hrv_data`, `get_sleep_data`, `get_body_composition` for the
  recovery/readiness signal.
- `get_menstrual_calendar_data` / `get_menstrual_data_for_date` if
  available, to evaluate the cycle-informed deload trigger in
  `training-rules.md`. If this data isn't in Garmin and hasn't been
  supplied in `athlete.md` either, treat the deload trigger as unknown for
  this week and say so in the email rather than guessing.

## 3. Analyze

- Compare this week's actual run execution (pace, HR drift, cadence,
  GCT/VO/VR trends) against the prior week(s) and against the goal/date in
  `athlete.md`.
- Determine training phase (base/build/peak/taper) from weeks remaining to
  the goal date. If the goal date is still a `TODO`, flag that explicitly
  — you cannot compute a ramp against an unknown deadline.
- Check the deload trigger from `training-rules.md`. If conditions are
  met, reduce next week's Claude-designed intensity and volume; fixed/
  coached load stays as-is.
- If the ramp implied by the goal date looks unsafe given actual recent
  volume, do not silently push through — flag it clearly in the email.

## 4. Design next week's Claude-owned sessions

For each day `schedule.md` marks "Claude-designed":

- **Running days:** structure and intensity driven by the analysis above;
  long-run distance stays within whatever band `schedule.md`/`athlete.md`
  specify, progressing safely toward the goal.
- **Gym/S&C days:** targeted at whatever the run data shows as the
  current limiter (e.g. cadence drop, GCT increase, fatigue in late
  splits), on top of the general focus in `schedule.md`. Follow whatever
  per-day structure `schedule.md` specifies exactly — if it says "exactly
  5 exercises," use exactly 5; if it says a day is uncapped/flexible, size
  it to fill the stated time window instead. Do not invent a structure
  `schedule.md` doesn't specify.
- Leave every day marked "fixed" / "no — Claude doesn't touch" in
  `schedule.md` untouched — analyze that data for context, don't redesign
  it.

## 5. Schedule it

Build each Claude-designed running day with `create_run_workout` and each
Claude-designed gym/S&C day with `create_strength_workout` (garmin MCP),
then place them on the calendar with `schedule_workout` (or
`schedule_week` for all of them at once) for the coming week.

## 6. Derive pace/HR targets from actual data

Before writing the email, pull splits (`get_activity_splits`) and HR data
(`get_activity_hr_in_timezones`) for the last several weeks of runs and
compute the athlete's real pace-at-HR-zone relationship (e.g. "recent
easy-zone pace has been ~X:XX/km at 130–140bpm"). Use that —not a generic
zone chart— to set this week's target paces. If there isn't enough recent
run data to do this reliably, say so in the email and fall back to
HR-zone targets only (bpm ranges), not invented pace numbers.

## 7. Email it — clean HTML, tables for anything structured

Send via `mcp__claude_ai_Gmail__send_message` to the address in the
**Delivery email** field of `training-rules.md` (as a draft or auto-sent
per that file's **Delivery mode** — use `create_draft` for `draft` mode,
`send_message` for `auto-send`), subject `Weekly training plan — week of
<upcoming Monday's date>`, using `htmlBody` (with `body` as a plain-text
fallback of the same content). Structure:

1. **Recap** — last week in real numbers (pace, HR, cadence, GCT trend vs
   prior weeks; sleep/HRV/readiness), 3-5 sentences, no table needed.
2. **Flags** — anything from step 3 (missing target date, deload
   uncertainty, ramp risk, etc.), as a short bulleted list. Omit this
   section entirely if there's nothing to flag.
3. **This week's running days** — an HTML table, one row per
   Claude-designed running day: columns Day | Session type |
   Distance/Duration | Target pace (min/km) | Target HR (bpm). Pace/HR
   values come from step 6.
4. **Each Claude-designed gym/S&C day** — one set of HTML tables per day
   (warm-up/mobility, strength, cool-down), row counts and volume exactly
   matching what `schedule.md` specifies for that day — fixed counts where
   it says so, filled-to-the-time-window where it says flexible.

Keep prose sections tight; let the tables carry the structured detail.
