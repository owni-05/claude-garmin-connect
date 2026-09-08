# claude-garmin-connect

This lets Claude read your Garmin data — your runs, sleep, heart rate,
and more — and use it to build you a personal training plan. It can even
put new workouts straight onto your Garmin calendar and email you a plan
every week, automatically.

You don't need to know how to code to set this up. You'll just be
copying and pasting a few commands into a window called the **Terminal**
(it comes built into your Mac — search for "Terminal" with Spotlight,
the magnifying glass in your menu bar), and editing a couple of plain
text files with your own details.

## What you'll need

- A Mac
- A Garmin Connect account (the app/account your Garmin watch syncs to)
- [Claude Desktop](https://claude.ai/download) or Claude Code installed
- About 15–20 minutes

## What you get

Once it's set up, you can ask Claude things like *"how was my training
this week?"* or *"plan my workouts for next week"*, and it will actually
look at your real Garmin data to answer — your runs, sleep, heart rate,
recovery, weight, and (if you want) your menstrual cycle. It can also
create and schedule real workouts on your Garmin calendar for you.

There's also an optional feature (further down) that does this
automatically every week and emails you the plan, with no need to ask.

---

## Setup

Every step below involves opening **Terminal** and pasting in a command,
then pressing Enter. That's all "running a command" means.

### Step 1 — Install a small helper tool

Copy this, paste it into Terminal, press Enter:

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
```

This installs a tool called `uv`, which is just what lets your computer
download and run the program that talks to Garmin. You won't interact
with it directly again.

### Step 2 — Connect your Garmin account (one time)

```sh
uvx --python 3.12 --from git+https://github.com/Taxuspt/garmin_mcp garmin-mcp-auth
```

This will ask for your Garmin email, password, and the code from your
phone if you have two-factor login turned on — just like logging into
the Garmin app. Your password is **not** saved anywhere; instead this
creates a secure pass (it lasts about 6 months) that lives only on your
own computer. When it eventually expires, just run this command again.

### Step 3 — Tell Claude how to reach Garmin

**If you use Claude Desktop:** open this file on your computer —
`~/Library/Application Support/Claude/claude_desktop_config.json` — with
any text editor (TextEdit is fine), and put this inside it:

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

Save the file, then completely quit and reopen Claude Desktop (not just
close the window — actually quit it).

**If you use Claude Code** (needed for the automatic weekly email
further down), run this instead, from inside this folder:

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

### Step 4 — Tell Claude about yourself

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

### Step 5 — Try it out

Before setting up anything automatic, just open Claude and ask it
something like:

> "Look at my Garmin data and tell me how my training went this week"

or

> "Build me a plan for next week based on profile/athlete.md,
> profile/schedule.md, and profile/training-rules.md"

If it can read your real data and the plan makes sense, you're good to
go. If you skip the automatic part below, this is all you need — you can
just ask Claude for a plan whenever you want one.

---

## Optional: get a plan emailed to you automatically every week

This part is more technical and is only needed if you want it to happen
**without you asking** — every Sunday, Claude checks your Garmin data,
schedules next week's workouts, and emails you the plan on its own. If
that's not important to you, skip this whole section — everything above
already works fine on its own, just by asking.

This runs on your own computer (not "in the cloud"), because the secure
pass from Step 2 only exists on your machine. That also means it only
works while your Mac is turned on and you're logged in at the scheduled
time.

1. First, try it manually once to make sure it works:

   ```sh
   bash scripts/weekly_plan.sh
   ```

   This does exactly what the automatic weekly version will do. Give it a
   minute or two, then check your email and your Garmin calendar to see
   what it created.

   > ⚠️ **Heads up:** this creates real workouts on your calendar and
   > sends/drafts a real email each time you run it. Don't run it several
   > times in a row just to test — you'll end up with duplicate workouts
   > on your calendar that you'd need to clean up.

2. If that looked right, set it to run automatically every Sunday. Copy
   the template file and fill in a few blanks:

   ```sh
   cp scripts/com.example.garmin-weekly-plan.plist.template \
      ~/Library/LaunchAgents/com.me.garmin-weekly-plan.plist
   ```

   Open the copy you just made (`~/Library/LaunchAgents/com.me.garmin-weekly-plan.plist`)
   in a text editor and replace:
   - `/path/to/claude-garmin-connect` → the real folder path of this
     project on your computer
   - `/path/to/log/dir` → wherever you'd like a record of each run saved
     (e.g. `/Users/yourname/Library/Logs`)

   It's already set to run every Sunday at 8am — to change that, edit the
   `Hour`/`Minute` numbers, or the `Weekday` number (0 = Sunday, 1 =
   Monday, ... 6 = Saturday).

3. Turn it on:

   ```sh
   launchctl load ~/Library/LaunchAgents/com.me.garmin-weekly-plan.plist
   ```

   No error message means it worked. It'll quietly wait until the
   scheduled time — it won't run right away.

   To turn it back off later:

   ```sh
   launchctl unload ~/Library/LaunchAgents/com.me.garmin-weekly-plan.plist
   ```

---

## Keeping your information private

- The files in `profile/` are meant to hold your real personal details
  once you fill them in — your body stats, injuries, race goals, etc.
  **Don't upload your filled-in versions anywhere public** (like posting
  them to a public GitHub repository). If you're using this project from
  a public copy on GitHub, keep your own edits local and never `commit`/
  `push` them.
- Your Garmin sign-in pass from Step 2 lives in a hidden file on your own
  computer only (`~/.garminconnect`) — it's never uploaded anywhere.

## If something isn't working

- **Claude says it can't find a Garmin tool it needs:** the Garmin
  connector occasionally adds or renames its tools. If you're using the
  automatic weekly email and it mentions a missing/blocked tool, open
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
