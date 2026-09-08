# claude-garmin-connect

This lets Claude read your Garmin data — your runs, sleep, heart rate,
and more — and use it to build you a personal training plan. It can put
new workouts straight onto your Garmin calendar, and — if you want —
email you a new plan every week without you asking.

You don't need to know how to code to set this up. You'll just be
copying and pasting a few commands into a window called the **Terminal**
(it comes built into your Mac — search for "Terminal" with Spotlight,
the magnifying glass in your menu bar), and editing a couple of plain
text files with your own details.

## What you'll need

- A Mac
- A Garmin Connect account (the app/account your Garmin watch syncs to)
- [Claude Desktop](https://claude.ai/download) or Claude Code installed
- About 15–20 minutes for the basic setup (Steps 1–6 below). If you go on
  to set up the optional cloud-server automation, budget extra time and
  some comfort with renting/managing a server — it's a bigger step up in
  difficulty than everything else here.

## What you get

Once it's set up, you can ask Claude things like *"how was my training
this week?"* or *"plan my workouts for next week"*, and it will actually
look at your real Garmin data to answer — your runs, sleep, heart rate,
recovery, weight, and (if you want) your menstrual cycle. It can also
create and schedule real workouts on your Garmin calendar for you.

There are three ways to actually use it — pick whichever fits you
(details for each are further down):

1. **Run one command whenever you want** — a script does the whole
   "check my data → plan next week → schedule it → email me" sequence in
   one go, on demand.
2. **Fully automatic, on a schedule** — the same script runs by itself
   every week, either on your own computer or on a small cloud server you
   set up, so you never have to ask.
3. **Just ask Claude** — the simplest option, no setup beyond connecting
   your account. Open Claude whenever you want a plan and ask for one.

---

## Setup

Every step below involves opening **Terminal** and pasting in a command,
then pressing Enter. That's all "running a command" means.

### Step 1 — Get this project onto your computer

Everything below refers to files inside this project (like
`profile/athlete.md`), so you need a copy of it on your computer first.

Easiest way, no coding involved:

1. On the GitHub page for this project, click the green **Code** button,
   then **Download ZIP**.
2. Find the downloaded ZIP file (usually in your Downloads folder) and
   double-click it to unzip it.
3. Move the unzipped folder somewhere you'll remember — your Desktop or
   Documents folder is fine.

That folder is "this project" for every instruction below. If you're
comfortable with `git`, cloning the repo works just as well.

### Step 2 — Install a small helper tool

Open Terminal, copy this, paste it in, press Enter:

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
```

This installs a tool called `uv`, which is just what lets your computer
download and run the program that talks to Garmin. You won't interact
with it directly again.

> If a later step says something like `command not found: uv`, it
> usually just means you opened a *new* Terminal window after installing
> it. Run `source $HOME/.local/bin/env` again in that window and it'll
> work.

### Step 3 — Connect your Garmin account (one time)

```sh
uvx --python 3.12 --from git+https://github.com/Taxuspt/garmin_mcp garmin-mcp-auth
```

This will ask for your Garmin email, password, and the code from your
phone if you have two-factor login turned on — just like logging into
the Garmin app. You'll know it worked when it prints something like
`Login successful` / `Token saved` near the end. Your password is **not**
saved anywhere; instead this creates a secure pass (it lasts about 6
months) that lives only on your own computer. When it eventually
expires, just run this command again.

### Step 4 — Tell Claude how to reach Garmin

**If you use Claude Desktop:** open this file on your computer —
`~/Library/Application Support/Claude/claude_desktop_config.json` — with
any text editor (TextEdit is fine).

- **If the file is empty or doesn't exist yet:** put this inside it:

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

- **If the file already has content in it** (for example you've
  connected other tools to Claude before), don't replace it — you'd lose
  those. Instead, add a `"garmin": { ... }` entry alongside whatever's
  already inside `"mcpServers": { ... }`. For example, if it currently
  looks like this:

  ```json
  {
    "mcpServers": {
      "some-other-tool": { "command": "..." }
    }
  }
  ```

  add a comma after that entry and put the `"garmin"` block right after
  it, so it becomes:

  ```json
  {
    "mcpServers": {
      "some-other-tool": { "command": "..." },
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

  If you're not sure your edit is valid, paste the whole file into
  Claude and ask it to check the JSON is well-formed before you save.

Save the file, then completely quit and reopen Claude Desktop (not just
close the window — actually quit it).

**If you use Claude Code** (needed for Options A and B below), run this
instead, from inside this project's folder in Terminal:

```sh
claude mcp add garmin --scope local -- uvx --python 3.12 --from git+https://github.com/Taxuspt/garmin_mcp garmin-mcp
```

To check it worked:

```sh
claude mcp list
```

You should see a line that says `garmin: ... ✔ Connected`.

**One more connection, for email:** the weekly-email feature (optional,
see below) sends through Gmail. Check `claude mcp list` for a Gmail
connection too — if you don't see one, connect Gmail however your version
of Claude offers to connect apps/tools.

### Step 5 — Tell Claude about yourself

This is the part that makes the plan actually *yours*. Inside the
`profile` folder are three plain text files — open them with any text
editor, no coding involved:

- **`profile/athlete.md`** — your goal (e.g. a race and date), your
  current fitness, body stats, any injuries, and (optional) your cycle
  info
- **`profile/schedule.md`** — your weekly routine: which days are fixed
  (like a class you already go to) and which days you want Claude to plan
  for you
- **`profile/training-rules.md`** — your email address for the weekly
  plan, and a few preferences about how cautious the plan should be

Each file has spots marked `TODO` — replace those with your real
information. Everything else is just an example to show you the format;
feel free to change it however you like, it's your file.

### Step 6 — Choose how you want to run it

All three options below need Steps 1–5 done first. Pick one.

---

#### Option A — Run one command whenever you want a plan

This needs **Claude Code** (not Desktop) with the `garmin` connection
from Step 4. It runs the exact same "check my data → plan next week →
schedule it → email me" sequence as the automatic option below, just on
demand instead of on a timer:

```sh
bash scripts/weekly_plan.sh
```

Give it a minute or two, then check your email and Garmin calendar for
what it created.

> ⚠️ **Heads up:** this creates real workouts on your calendar and
> sends/drafts a real email every time you run it. Don't run it several
> times in a row just to test — you'll end up with duplicate workouts
> you'd need to clean up.

---

#### Option B — Fully automatic, on a schedule

The same script as Option A, but run by a scheduler so it happens
without you doing anything. Pick where it runs:

**On your own Mac** — simplest, but it only runs while your Mac is on
and you're logged in at the scheduled time (e.g. it won't fire if your
laptop is asleep on Sunday morning).

1. Copy the template file and fill in a few blanks:

   ```sh
   cp scripts/com.example.garmin-weekly-plan.plist.template \
      ~/Library/LaunchAgents/com.me.garmin-weekly-plan.plist
   ```

   Open the copy you just made
   (`~/Library/LaunchAgents/com.me.garmin-weekly-plan.plist`) in a text
   editor and replace:
   - `/path/to/claude-garmin-connect` → the real folder path of this
     project on your computer. Not sure what that is? In Terminal, `cd`
     into the project folder (type `cd ` with a trailing space, then drag
     the folder from Finder into the Terminal window, then press Enter),
     then run `pwd` — it'll print the exact path to use.
   - `/path/to/log/dir` → wherever you'd like a record of each run saved
     (e.g. `/Users/yourname/Library/Logs`)

   It's already set to run every Sunday at 8am — to change that, edit the
   `Hour`/`Minute` numbers, or the `Weekday` number (0 = Sunday, 1 =
   Monday, ... 6 = Saturday).

2. Turn it on:

   ```sh
   launchctl load ~/Library/LaunchAgents/com.me.garmin-weekly-plan.plist
   ```

   No error message means it worked — it'll quietly wait until the
   scheduled time. To turn it back off later:

   ```sh
   launchctl unload ~/Library/LaunchAgents/com.me.garmin-weekly-plan.plist
   ```

**On a cloud server you control** — runs even when your laptop is off.

> This path is genuinely more advanced than everything else in this
> README — it means renting and managing your own small server. If
> phrases like "SSH into a server" aren't familiar, skip this and use
> "On your own Mac" above, or Option C below — both work great without
> any of this.

There's no special "cloud scheduling" product involved here — you're just
setting this whole project up a second time on a small always-on Linux
server you rent (a $5-6/month VPS from any provider is plenty), the same
way you set it up on your Mac:

1. On that server, repeat Steps 2–5 above: install `uv`, run the Garmin
   auth command (Step 3 — you'll need to do the email/password/MFA login
   again, this time from the server), install Claude Code and connect the
   `garmin` MCP server (Step 4), and get your filled-in `profile/` files
   onto the server (e.g. `git clone` this repo there, then edit
   `profile/*.md` directly on the server — don't push your filled-in
   versions back to GitHub).
2. Instead of `launchd` (that's Mac-only), use `cron`, which is Linux's
   built-in scheduler. Run `crontab -e` and add a line like:

   ```
   0 8 * * 0 /bin/bash /path/to/claude-garmin-connect/scripts/weekly_plan.sh
   ```

   That means "run this every Sunday at 8:00am server time." The five
   numbers/stars are minute, hour, day-of-month, month, and day-of-week
   (0 = Sunday) — change them to whatever schedule you want.
3. Save and exit; `cron` picks it up automatically, no separate "turn it
   on" step needed.

Either way, this is the only option where your Garmin connection lives
on a machine other than your own laptop — see **Keeping your information
private** below for what that means.

---

#### Option C — Just ask Claude (simplest, nothing else to set up)

No script, no scheduling — just talk to Claude (Desktop or Code)
whenever you want a plan:

> "Look at my Garmin data and tell me how my training went this week"

or

> "Build me a plan for next week based on profile/athlete.md,
> profile/schedule.md, and profile/training-rules.md"

If it can read your real data and the plan makes sense, you're already
done. This is the lowest-effort option — no script to run, nothing to
schedule — but it does mean remembering to ask.

---

## Keeping your information private

- The files in `profile/` are meant to hold your real personal details
  once you fill them in — your body stats, injuries, race goals, etc.
  **Don't upload your filled-in versions anywhere public** (like posting
  them to a public GitHub repository). If you're using this project from
  a public copy on GitHub, keep your own edits local and never `commit`/
  `push` them.
- Your Garmin sign-in pass from Step 3 lives in a hidden file
  (`~/.garminconnect`) on whichever machine you ran that step on, and is
  never uploaded anywhere by this project.
- If you use the cloud-server version of Option B, that pass now lives on
  a machine you're renting instead of your own laptop — make sure that
  server itself is reasonably secured (a strong password/SSH key, kept
  up to date) since it's holding a live connection to your Garmin
  account.

## If something isn't working

- **Terminal says `command not found`:** almost always means you opened
  a new Terminal window after installing something (like `uv`) in an
  older one. Close the window, open a fresh Terminal, and try the step
  again — or run `source $HOME/.local/bin/env` first.
- **Claude says it can't find a Garmin tool it needs:** the Garmin
  connector occasionally adds or renames its tools. If you're using
  Option A or B and it mentions a missing/blocked tool, open
  `scripts/weekly_plan.sh` and add the tool name it mentions to the long
  list near the top of the file.
- **A workout doesn't show up on your calendar as expected:** just ask
  Claude directly — e.g. "check what's on my Garmin calendar this week"
  — and it can look, and fix it, for you.
- **You ended up with duplicate workouts from testing:** ask Claude to
  check your Garmin calendar for the affected days and remove the
  duplicates.

## License

MIT — see [LICENSE](./LICENSE). In plain terms: anyone is free to use,
copy, and change this.
