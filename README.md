# claude-garmin-connect

Connect Garmin Connect to Claude, so Claude can read your training/health
data (activities, sleep, HRV, body composition, nutrition, menstrual
cycle, training readiness) and design + schedule your own workouts on
your Garmin calendar — then, optionally, generate and email you a new
training plan automatically every week, driven entirely by your actual
recorded runs and the coaching rules you write in plain markdown.

This doesn't vendor any code — it wires up
[garmin_mcp](https://github.com/Taxuspt/garmin_mcp) (Taxuspt), an existing
MCP server covering most of the `python-garminconnect` library (100+
tools), via [`uv`](https://github.com/astral-sh/uv)/`uvx`. The actual
coaching logic lives entirely in the markdown files under `profile/` and
in `scripts/weekly_plan_prompt.md` — you edit plain English to change how
Claude plans your training, not code.

## What this gives Claude

- **Activities** — list/inspect runs, swims, etc.: splits, HR zones, weather,
  gear, power, running dynamics.
- **Health & wellness** — sleep, HRV, stress, respiration, body battery,
  training readiness/status/load trend.
- **Body composition** — weight, muscle mass, body fat (read + log).
- **Nutrition** — food/calorie logging (read + log).
- **Women's health** — menstrual cycle calendar data (optional).
- **Workouts** — create runs/intervals/strength sessions, schedule a full
  week at once, edit/delete/unschedule.

## How it fits together

```
profile/athlete.md          <- who you are, your goal, your constraints
profile/schedule.md         <- your fixed weekly skeleton (what's fixed,
                                what Claude designs, and how)
profile/training-rules.md   <- data sources, deload logic, delivery prefs
scripts/weekly_plan_prompt.md <- the instructions the automation follows,
                                  reading all three files above at runtime
scripts/weekly_plan.sh      <- runs the prompt headlessly via Claude Code
scripts/*.plist.template    <- macOS launchd job to run it every Sunday
```

Nothing here hardcodes your race date, your body stats, your schedule, or
your email — all of that lives in `profile/` as plain markdown you edit
directly. Change your mind about your deload logic, your gym structure,
or how many exercises you want on a given day? Edit the file, no code
changes needed.

---

## Setup

### 1. Install `uv`

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
```

### 2. Authenticate with Garmin (one-time)

Run this yourself in a terminal — it prompts for your Garmin email,
password, and MFA code interactively:

```sh
uvx --python 3.12 --from git+https://github.com/Taxuspt/garmin_mcp garmin-mcp-auth
```

This saves a long-lived OAuth token to `~/.garminconnect` (valid ~6
months, on your machine only). No password is stored, and the MCP server
never needs your credentials again after this step. Re-run this command
whenever the token expires.

### 3. Add the MCP server

**For Claude Desktop** — add this to
`~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "garmin": {
      "command": "uvx",
      "args": [
        "--python", "3.12",
        "--from", "git+https://github.com/Taxuspt/garmin_mcp",
        "garmin-mcp"
      ]
    }
  }
}
```

Then fully restart Claude Desktop (quit and reopen, not just close the
window).

**For Claude Code** (needed if you want the weekly automation below) —
from this repo's directory:

```sh
claude mcp add garmin --scope local -- uvx --python 3.12 --from git+https://github.com/Taxuspt/garmin_mcp garmin-mcp
```

Verify it connected:

```sh
claude mcp list
```

You should see `garmin: ... ✔ Connected`.

**Gmail** (needed for the weekly email) — this repo assumes you already
have a Gmail MCP connector available to Claude (e.g. the built-in
`claude.ai Gmail` connector). Check `claude mcp list` for it; if it's
missing, connect it through however your Claude client exposes first-party
connectors.

### 4. Fill in your profile

Edit these three files directly — every `TODO` should get replaced with
your actual information:

- [`profile/athlete.md`](./profile/athlete.md) — goal, race date(s),
  baseline, body stats, injuries, cycle info (delete the cycle section if
  not applicable to you)
- [`profile/schedule.md`](./profile/schedule.md) — your actual weekly
  skeleton: which days are fixed (coached swim, a class, etc.) vs.
  Claude-designed (running, gym), and exactly how specific you want to be
  about structure (see the worked examples in the file)
- [`profile/training-rules.md`](./profile/training-rules.md) — data
  sources, your deload-week logic, your delivery email and whether you
  want a draft or auto-sent email

### 5. Test it manually first

Before setting up automation, just talk to Claude (Desktop or Code, with
the `garmin` MCP connected) and ask it to review your week or build a
plan, referencing the files in `profile/`. Confirm it can actually read
your Garmin data and that the plan it proposes makes sense.

You can also dry-run the exact automation prompt without waiting for
Sunday:

```sh
bash scripts/weekly_plan.sh
```

Check the log it writes to `~/Library/Logs/claude-garmin-connect/` and
your inbox (or Gmail drafts, depending on your `training-rules.md`
delivery mode).

> **Careful:** each run of this script can create real workouts on your
> Garmin calendar and send/draft a real email. Don't run it repeatedly
> without checking what it scheduled first — duplicate test runs will
> leave duplicate calendar entries. If you do end up with duplicates, ask
> Claude to check `get_scheduled_workouts` for the affected date range and
> clean up with `unschedule_workouts` + `delete_workouts`.

### 6. Set up the weekly automation (optional)

The automation runs **locally**, not in the cloud — the Garmin OAuth
token in `~/.garminconnect` is local-only, so a cloud-scheduled agent
can't reach it. This uses macOS `launchd` to run headless Claude Code on
your own machine.

1. Copy the plist template and fill in your real paths:

   ```sh
   cp scripts/com.example.garmin-weekly-plan.plist.template \
      ~/Library/LaunchAgents/com.<you>.garmin-weekly-plan.plist
   ```

   Edit the copy:
   - `Label` — match the filename, e.g. `com.<you>.garmin-weekly-plan`
   - `ProgramArguments` — replace `/path/to/claude-garmin-connect` with
     this repo's actual absolute path on your machine
   - `StandardOutPath` / `StandardErrorPath` — replace `/path/to/log/dir`
     with wherever you want logs (e.g. `~/Library/Logs`)
   - `StartCalendarInterval` — defaults to Sunday 8am (`Weekday: 0`,
     `Hour: 8`); change `Weekday` (0=Sunday .. 6=Saturday) or `Hour`/
     `Minute` to taste

2. Load it:

   ```sh
   launchctl load ~/Library/LaunchAgents/com.<you>.garmin-weekly-plan.plist
   launchctl list | grep garmin-weekly-plan
   ```

   A `0` exit status with no error means it's registered — it will next
   fire at the scheduled time, not immediately (unless you set
   `RunAtLoad` to `true`).

3. **This only runs while your Mac is on and you're logged in** at the
   scheduled time — `launchd` user agents don't run on a powered-off or
   logged-out machine.

To stop it: `launchctl unload ~/Library/LaunchAgents/com.<you>.garmin-weekly-plan.plist`.

---

## Privacy

- **Never commit your filled-in `profile/` files, your token, or any
  personal training data if you fork or push changes to a public repo.**
  This repo ships `profile/*.md` as generic templates full of `TODO`s —
  keep it that way in git; fill in your real details locally and leave
  those edits uncommitted (or keep your fork private).
- The Garmin OAuth token lives at `~/.garminconnect`, outside this repo,
  and is never read by anything except the `garmin_mcp` server on your
  own machine.
- The weekly automation logs to `~/Library/Logs/claude-garmin-connect/`
  by default (outside the repo) — those logs will contain your real
  training data, so don't commit that directory either.

## Troubleshooting

- **A tool call gets blocked/gated that isn't in `scripts/weekly_plan.sh`'s
  `ALLOWED_TOOLS` list:** `garmin_mcp` occasionally adds/renames tools.
  Add the missing `mcp__garmin__<tool_name>` to the list and re-run.
- **`create_run_workout` or similar seems to silently no-op:** double
  check the exact tool names your connected server exposes (`claude mcp
  list`, or inspect the server's source) — names can drift from what any
  docs say.
- **Duplicate calendar entries:** see the warning in step 5 above.

## License

MIT — see [LICENSE](./LICENSE).
