# Sources

Per-source gathering detail for `work-summary`, steps 2-11. Every `{{key}}` comes from the
profile resolved in step 0. Sources are independent - a failure in one does not block others;
record it and carry on.

## Step 2 — GitHub activity

**Short periods (roughly a week or less) — the events feed.** It is the richer source:
pushes, branch creations, and review comments only exist here.

```bash
gh api "users/{{github_login}}/events?per_page=100"
```

Filter to `created_at` within `START..END` AND `repo.name` starting `{{github_org}}/`. This
feed includes private-repo events because the call is authenticated as that user. It is
capped at roughly **300 events / 90 days** across three pages (`&page=2`, `&page=3`) — at his
current rate one page reached back 14 days and all three reached 30. Check the oldest
`created_at` you got back: **if it lands after `START`, the feed did not cover the period and
you must say so.**

**Longer periods — the PR search**, which is indexed rather than a rolling feed and does not
age out:

```bash
gh search prs --author {{github_login}} --owner {{github_org}} --created "$START..$END" \
  --json number,title,state,createdAt,repository --limit 100
gh search prs --author {{github_login}} --owner {{github_org}} --merged-at "$START..$END" \
  --json number,title,state,closedAt,repository --limit 100
```

Both were verified working. Two quirks: `mergedAt` is **not** an available `--json` field, so
use `closedAt` from the `--merged-at` query — for a merged PR they are the same timestamp
(checked against the PR API on #135/#136). And a PR opened before `START` and merged inside it
only appears in the second query, which is exactly why both run.

Pushes and review comments have no equivalent search, so for a long period they are
events-feed-only and simply unavailable past the cap. State that rather than implying the
period had no commits.

Report per repo: PRs opened / merged / closed (with numbers and titles), pushes (branch
+ commit count), branches created, review comments. Prefer PR titles over commit
messages — they read better and are already written for an audience.

One limit worth respecting rather than working around: `gh search commits` is **not** a
substitute for either query — its index lags and misses same-day work.

Merge attribution needs the PR API, not the events feed: a merge of *his* PR shows up in his
event stream with `actor: {{github_login}}` even when someone else clicked the button. If who merged
matters, read `merged_by` from `gh api repos/OWNER/REPO/pulls/N`.

## Step 3 — Granola meetings

Call `mcp__claude_ai_Granola__list_meetings` with `time_range: "custom"`,
`custom_start` = `START`, `custom_end` = **the day after `END`**, and
`involvement: {captured_by_me: true, listed_as_participant: true}`.

**Dedupe.** The same meeting often appears twice — once captured by him, once by another
attendee. Collapse entries sharing a title and start time.

List title and time only. Do **not** pull transcripts unless explicitly asked; meeting
content is sensitive and a summary line doesn't need it.

**This is context, not output.** Meetings are gathered so the summary can explain a day —
why something moved, stalled, or landed on him. Most runs print none at all. See step 13.

## Step 4 — Outline docs

Call `mcp__claude_ai_Outline__list_documents` with `limit: 25` and no query (returns
recent documents). Do **not** use 100 — that returned 177k chars in testing and blew the
tool-result token cap. Keep documents where **either**:
- `updatedAt` is within `START..END` and `updatedBy.id` is his Outline id, **or**
- `createdAt` is within `START..END` and `createdBy.id` is his Outline id.

**Paginate for anything longer than a day.** The list is workspace-recent across everyone, so
25 rows can cover less than a day in a busy week. Walk `offset` in steps of 25 until the
oldest `updatedAt` on a page is **older than `START`** — that page is the first one that
proves you've gone far enough back. Stop there.

Report title, the `breadcrumb` for context, and the `url`.

Limitation to state honestly if it matters: this is a recency list, not a per-user audit log,
and it only reports the *latest* edit — see step 5's unattributable-edits rule, which covers
Outline too. A doc he edited on Tuesday and a teammate edited on
Friday attributes to the teammate, so his Tuesday work vanishes from a Mon–Fri period. Nothing
in the API fixes that — for a long period, treat Outline as a floor on his doc work, not a
count.

## Step 5 — Google Docs

Call `mcp__claude_ai_Google_Drive__list_recent_files` with `orderBy: "lastModifiedByMe"`,
`pageSize: 25`, `excludeContentSnippets: true`. Keep files whose `modifiedTime` falls within
`START..END`. For a longer period, follow `next_page_token` until a page's `modifiedTime`
values drop below `START`.

Most files in this Drive are `sharedWithMe` and owned by teammates, so "he edited it" is
approximate — the API gives no per-user edit timestamp, and `get_file_metadata` adds nothing
(no `lastModifyingUser`; checked). Prefer files he owns, or that the `lastModifiedByMe`
ordering surfaces near the top. Never claim authorship of an edit you cannot attribute.

**Unattributable edits get surfaced, not dropped.** When a file he plausibly worked on was
modified inside the period but the editor can't be established, give it one line saying
exactly that — *"modified Thu 12:42, can't tell from the API whether that was me"* — instead
of omitting it. Two signals make a file plausible: `viewedByMeTime` inside the period, or the
file being the subject of something assigned to him in step 8. Silence reads as "I didn't
touch it", which is a stronger claim than the evidence supports.

The same rule applies to Outline (step 4), which reports only the *latest* editor: if he is in
`collaboratorIds` on a doc whose last edit inside the period belongs to someone else, his own
edit may be hidden underneath it. Surface it the same way, and check `collaboratorIds` before
concluding a doc wasn't his.

## Step 6 — Claude artifacts

Call the `Artifact` tool with `action: "list"`, `limit: 25`, and `scope: "mine"` — only
artifacts he owns. Keep the ones whose last-updated date falls within `START..END`.

Report title and URL. Link the title; never paste the bare artifact URL into prose.

Three honest limits:
- The listing gives **last-updated, not created**, so a page he published weeks ago and
  edited inside the period looks identical to one created in it. Write it as "published or
  updated" unless he says which he wants — don't assert he created it on this evidence.
- There is no date filter in the call, so filter locally. Newest first, so a day inside the
  most recent 25 is safe; raise the limit toward the **50 cap** for longer periods. 50 is a
  hard ceiling with no pagination — if the 50th artifact is still newer than `START`, the
  period is only partly covered and the summary must say so.
- `scope: "mine"` deliberately excludes artifacts teammates shared with him. Those aren't his
  work and don't belong in his summary.

Unlike the four sources above, this one is a built-in tool rather than MCP, so it and step 10
are the only steps that would still work in a headless run.

## Step 7 — email

Call `mcp__claude_ai_Gmail__search_threads` twice with `view: "THREAD_VIEW_MINIMAL"` and
`pageSize: 25`. **Both of Gmail's bounds are exclusive**, so widen by a day on each side:
`after:` takes the day *before* `START`, `before:` takes the day *after* `END` (step 1 has
both commands). Dates use slashes here, not dashes:

- What he sent — `in:sent after:2026/08/19 before:2026/08/22`
- What landed for him directly — `to:me after:2026/08/19 before:2026/08/22 -category:promotions -category:social -category:updates -category:forums`

Follow `pageToken` if a long period fills the page; 25 threads is roughly a quiet week.

Report at **subject level only**. A sent mail that decided something, asked a question now
outstanding, or unblocked someone earns a line; a one-line reply does not. Received mail earns a
line when it's provisioning, access, or a decision — most received mail is not his work and does
not belong in a summary of it.

**Do not call `get_thread`.** Subjects plus the snippet the search already returns are enough, and
full bodies are a privacy step-change for a note to himself. Same principle as the Granola
transcript rule.

**Email is where credentials actually arrive** — invitation links, one-time codes, API keys,
password resets. The no-secrets rule gets tested here rather than in theory. Never reproduce any
of it, and if a subject line itself contains something token-shaped, describe the mail instead of
quoting it: "a WorkOS invitation email", not the subject.

Scope rule still applies: skip threads belonging to `{{exclude_orgs}}`.

## Step 8 — Slack

Two passes: what he said, then what was said to him. Both call
`mcp__claude_ai_Slack__slack_search_public_and_private` with `sort: "timestamp"`,
`include_context: false`, and `only_my_channels: true`.

**Pass A — what he communicated:**

```
from:<@{{chat_destination}}> after:<day before START> before:<day after END> -in:<@{{chat_destination}}>
```

**That trailing exclusion is not optional.** `{{chat_destination}}` is the configured destination — the channel this skill
posts to. Without excluding it, yesterday's summary gets read back as today's activity and the
summary starts summarizing itself.

Angle brackets around IDs are literal in Slack search syntax. Date modifiers are `YYYY-MM-DD`,
and both bounds are exclusive like Gmail's — use the same widened days from step 1. `on:` matches
a single day if you prefer it for a one-day period.

**Search returns at most 20 messages per call.** A single busy day already hit 13, so any period
beyond a couple of days needs the `cursor` from the response followed until it stops. Twenty
results is not "that's all there was".

**Pass B — what was aimed at him:**

```
<@{{chat_destination}}> after:<day before START> before:<day after END> -from:<@{{chat_destination}}> -in:<@{{chat_destination}}>
```

His bare user ID as a search term matches messages that mention him. `to:` only works for DMs, so
the bare ID is the thing that catches a channel mention. This is where the day's *asks* live: a
question waiting on him, a post-standup to-do list that assigns him work, an access grant landing.
Pass A only shows what he pushed out — without pass B, a question a teammate asked him in a
working channel is invisible, and that is usually the most actionable line in the summary.

**Check pass A before calling anything outstanding.** Most asks get answered within the hour, and
an answered question is not an open item. Match them by thread: the permalinks carry `thread_ts`,
so a reply of his in the same thread is normally the answer.

Anything still unanswered, or assigned to him and not done, becomes an *On me* line in step 13 —
unless what he needs is from someone else, in which case it is a blocker (step 12).

**Pass C, optional — read the channels this workspace's work happens in**, for a day that
looks thinner than it was. The channel ids come from `{{work_channels}}`; skip pass C entirely
when that key is blank. Read each one with `mcp__claude_ai_Slack__slack_read_channel` and
`response_format: "concise"`.

`oldest`/`latest` are epoch seconds, and they must bound the *local* period — `START` 00:00 to
the day after `END` 00:00:

```bash
date -j -f "%Y-%m-%d %H:%M:%S" "$START 00:00:00" +%s          # oldest
date -j -v+1d -f "%Y-%m-%d %H:%M:%S" "$END 00:00:00" +%s      # latest
```

`limit` maxes at 100 messages per call, with a `cursor` for more.

This catches what never mentioned him at all — a teammate shipping something he then picked up.
It returns **top-level messages only**; thread replies are collapsed, and that is where most of
the back-and-forth happens, so it complements the two searches rather than replacing them. Volume
on a working channel is usually single digits for a whole day, so it is cheap when you want it.

Report what he actually communicated — a decision, a heads-up, a question he's waiting on — not
chatter. Channel names carry the context, so keep them. Questions he asked that nobody answered
are blocker candidates for step 12.

## Step 9 — calendar

Call `mcp__claude_ai_Google_Calendar__list_events` on his primary calendar with `startTime` =
`START` 00:00 local and `endTime` = the day after `END` at 00:00 local, `orderBy: "startTime"`.
Raise `pageSize` for a long period (max 250) and page through `nextPageToken`.

This closes a real gap rather than duplicating step 3: **Granola only sees meetings that were
recorded.** A meeting he attended without capturing notes is invisible to Granola entirely.

Cross-reference the two. A calendar event with a matching Granola note needs no separate line —
Granola's is better, because it has the content. Report the events that Granola *missed*, and use
calendar to correct the meeting times, since Granola's timestamps are when the note was captured
rather than when the meeting was scheduled.

Two things not to assume: an event on the calendar is not proof he attended, and an accepted invite
is not either. Prefer events he organized or that have a Granola note; if attendance is genuinely
ambiguous, leave it out rather than assert it — the same standard step 5 uses for Drive files.
Declined and cancelled events are not activity.

If the connector is unauthenticated (only `authenticate` / `complete_authentication` exposed), say
so in one line per the honest-gap rule rather than omitting it silently.

## Step 10 — Linear

Skip the step entirely when `{{linear_teams}}` is blank. If the connector is unauthenticated
(only `authenticate` / `complete_authentication` exposed), say so in one line per the
honest-gap rule, the same as step 9.

**Confirm the workspace before reading anything.**
`mcp__claude_ai_Linear__get_workspace` names the Linear workspace the connector is bound to,
and OAuth binds exactly one at a time. A connector pointed at an org in `{{exclude_orgs}}`
will happily return tickets that must not appear in this summary. If it isn't this
workspace's, report that in one line and skip — do not filter your way to a partial answer.

Then resolve identity and scope once:

```
mcp__claude_ai_Linear__list_users   → his id, matched on {{linear_user}}
mcp__claude_ai_Linear__list_teams   → keep only the teams named in {{linear_teams}}
```

**Two passes per team, recency-ordered and date-filtered locally.** `list_issues` takes
`team`, `project`, `query`, `limit`, `fields` and `orderBy` — there is no date argument, so the
period filter happens on your side, exactly as in steps 4-6:

```
mcp__claude_ai_Linear__list_issues
  team: <team>, limit: 50, orderBy: "updatedAt",
  fields: ["identifier","title","status","assignee","updatedAt","createdAt","url"]
```

- **Pass A — what he owns that moved.** Keep issues whose `updatedAt` falls inside
  `START..END` and whose `assignee` is him.
- **Pass B — what he opened.** Same call with `orderBy: "createdAt"`; keep issues he created
  inside the period. An issue he filed and someone else now owns is still his work.

Paginate like step 4: keep going until a page's oldest date is older than `START`. Raise
`limit`, never the field list — `fields` is what controls response size, so ask for the seven
above and nothing else. Requesting `description` across 50 issues is how this step blows the
tool-result token cap.

**`updatedAt` is not an attribution.** Anyone's comment or status change bumps it, so pass A
means "issues he owns that moved", not "issues he moved". Where the difference matters, check
`mcp__claude_ai_Linear__list_comments` on that one issue for his authorship inside the period
— never across a whole team. This is step 4's latest-editor problem again, and it earns the
same honest line rather than a confident claim.

**The GitHub overlap is the thing to get right.** Linear links PRs and flips issues to Done on
merge, so a ticket that closed because his PR merged is already reported in step 2 and must not
become a second bullet. A ticket earns a line only for what the PR doesn't say: a status
decision (blocked, descoped, punted to the next cycle), a scope or estimate change, or a
comment thread that settled something. A ticket with no PR behind it is the case where this
step carries the whole item.

Two more calls, worth it for a week or longer and skippable for a day:
- `mcp__claude_ai_Linear__get_status_updates` — a project update he wrote is the closest thing
  to a summary he already authored. If one covers the period, prefer his wording to yours.
- `mcp__claude_ai_Linear__list_documents` — Linear docs, filtered the way step 4 filters
  Outline.

**Feed the leftovers forward instead of printing them.** Issues assigned to him and still open
at `END` are *On me* candidates (step 13). An issue sitting in a blocked state, or one whose
latest comment is a question aimed at him, is a blocker candidate (step 12).

One caveat about this step specifically: only `list_issues`' argument list was exercised
against a live connector. If a call rejects an argument, read the tool schema, adjust, and fix
this file — do not drop the step.

## Step 11 — Claude Code sessions

Every source above records an artifact. This one records intent — what he was trying to do,
what he decided, and the work that produced nothing to point at.

Transcripts are local JSONL, one file per session, in project dirs named after the session
cwd with `/` replaced by `-`. A helper does the extraction:

```bash
~/.claude/skills/work-summary/scripts/claude-code-sessions.sh "$START" "$END"   # END optional
```

Per session it prints the auto-generated title, cwd, git branch, short session id, prompt count,
and every human prompt with its local time — sessions ordered by when they started, and a totals
footer. For a multi-day period the time column gains the date automatically, so the output stays
groupable by day. It globs `{{transcript_glob}}` only, so `{{exclude_orgs}}` sessions
never appear — the scope rule holds without extra filtering.

If the script is gone, this is the whole of it. `.origin.kind == "human"` is what separates a
typed prompt from a tool result — both carry `type: "user"`, and tool results outnumber prompts
five to one:

```bash
jq -r --arg s "2026-08-19" --arg e "2026-08-21" '
  select(.type == "user" and .origin.kind == "human" and (.isSidechain != true))
  | (.timestamp | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601) as $t
  | ($t | strflocaltime("%Y-%m-%d")) as $day
  | select($day >= $s and $day <= $e)
  | ($t | strflocaltime("%Y-%m-%d %H:%M")) + "  " + (.message.content
      | if type == "string" then . else (map(select(.type == "text") | .text) | join(" ")) end
      | gsub("\\s+"; " ") | .[0:220])
' ~/.claude/projects/{{transcript_glob}}/*.jsonl
```

**Timestamps are UTC, the day is local.** Do not match the date as a string prefix.
`2026-08-21T01:30Z` is 20:30 on the 20th in CT, so prefix matching files an evening's work
under tomorrow and empties out the evenings. `strflocaltime` is there to do that conversion.

Optional second pass, for a session whose work never reached a commit — the files it edited:

```bash
jq -r 'select(.type == "assistant") | .message.content[]? | select(.type == "tool_use")
  | select(.name == "Edit" or .name == "Write") | .input.file_path // empty' SESSION.jsonl |
  grep -v scratchpad | sort -u
```

**Report the arc, not the prompts.** A busy day is 60+ prompts over four sessions — 6 KB of
text; three days ran to 71 prompts over five sessions. Scale by reading the session headers
first and only descending into the prompts of sessions that matter: for a week or more, the
titles plus prompt counts carry most of the signal, and a 40-prompt session obviously deserves
more attention than a 2-prompt one. One line per session: what he was after and where it
landed. A session already covered
by its PR in step 2 gets nothing here; the PR says it better. Session titles make decent
handles, but a long session wanders far from its title, so trust the prompts over it.

Work on this skill is the exception: sessions that edited `~/.claude/skills/work-summary/`
never make the summary, even though they fit everything below. See the hard rules in step 13.

What this source is *for*, and where it beats the others: work that produced no commit, doc, or
artifact; a decision made and then reversed; something tried that didn't work. If a session's
whole story is already in GitHub, this step has nothing to add.

Four limits, all load-bearing:
- **Claude Code only.** Chat and Cowork conversations live server-side with no connector, so
  they are invisible here. Artifacts published from them still surface in step 6 — the
  conversations do not. Never imply the summary covers them.
- **cwd decides inclusion.** A workspace session run from outside `{{workspace_root}}`, or from a worktree
  outside `{{workspace_root}}`, is missed entirely. Set `CLAUDE_SESSION_GLOB` to widen the glob
  if a day looks thinner than it was.
- **Edited-file lists miss Bash writes.** Files written with a heredoc, `sed`, or a script
  leave no tracked edit, so that second pass can come back empty for a session that changed
  plenty.
- **Sessions get resumed and forked**, so an early prompt can appear under two session files.
  Collapse duplicates, the way step 3 collapses Granola meetings.

**Never quote a prompt verbatim.** Prompts are raw typed text, and this step reads more raw
human text than any other. They contain pasted keys, invite links, one-time codes, and the odd
`.env` line. Describe what he was asking for instead. The 220-char cut bounds how much reaches
context; it is a bound, not a scrubber. Same rule as step 7, with more exposure to it.

