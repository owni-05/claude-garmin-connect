#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

LOG_DIR="$HOME/Library/Logs/claude-garmin-connect"
mkdir -p "$LOG_DIR"
STAMP="$(date +%Y-%m-%dT%H-%M-%S)"

# Verified against src/garmin_mcp/*.py in Taxuspt/garmin_mcp (2026-09-08) —
# re-check this list if the server is updated and a run reports a new
# permission gate.
ALLOWED_TOOLS="Read,\
mcp__garmin__get_activities,mcp__garmin__get_activities_by_date,\
mcp__garmin__get_activities_fordate,mcp__garmin__get_activity,\
mcp__garmin__get_activity_splits,mcp__garmin__get_activity_typed_splits,\
mcp__garmin__get_activity_split_summaries,\
mcp__garmin__get_activity_hr_in_timezones,\
mcp__garmin__get_activity_power_in_timezones,\
mcp__garmin__get_sleep_data,mcp__garmin__get_sleep_summary,\
mcp__garmin__get_training_readiness,\
mcp__garmin__get_morning_training_readiness,\
mcp__garmin__get_training_status,mcp__garmin__get_training_load_trend,\
mcp__garmin__get_training_effect,mcp__garmin__get_endurance_score,\
mcp__garmin__get_running_tolerance,mcp__garmin__get_running_tolerance_trend,\
mcp__garmin__get_hrv_data,mcp__garmin__get_hrv_trend,\
mcp__garmin__get_body_battery,mcp__garmin__get_body_composition,\
mcp__garmin__get_weigh_ins,mcp__garmin__get_rhr_day,\
mcp__garmin__get_menstrual_calendar_data,\
mcp__garmin__get_menstrual_data_for_date,\
mcp__garmin__get_workouts,mcp__garmin__get_scheduled_workouts,\
mcp__garmin__create_run_workout,mcp__garmin__create_walk_run_workout,\
mcp__garmin__create_strength_workout,mcp__garmin__schedule_workout,\
mcp__garmin__schedule_week,\
mcp__claude_ai_Gmail__send_message,mcp__claude_ai_Gmail__create_draft"

claude -p "$(cat "$REPO_DIR/scripts/weekly_plan_prompt.md")" \
  --allowedTools "$ALLOWED_TOOLS" \
  >>"$LOG_DIR/weekly_plan_$STAMP.log" 2>&1
