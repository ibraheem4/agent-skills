# Profile example

Both `work-queue` and `work-summary` refuse to run without a profile, and neither ships one.
This is the template their Step 0 sends you to. Copy it, fill it in, and keep it in the
workspace it describes — never in this repo.

## Where it goes

```
~/<workspace>/.claude/workspace.config.md        # the general profile
~/<workspace>/.claude/work-summary.config.md     # work-summary's own, if you keep them split
```

A workspace may carry several profile files with separate contracts; a key defined by any of
them resolves. Splitting them is optional — one file that defines every key works. What is not
optional is the drift rule: **if two profiles define the same key with different values, the
skill stops and reports it** rather than picking one. Duplicate a key on purpose or not at all.

**Keep these files out of this repo.** They belong to the workspace, in whatever repo already
versions that workspace's `.claude/` directory, or in none. The skills are public and generic;
the values are neither.

## The keys

| Key | Example | What it is |
|---|---|---|
| `workspace_root` | `~/acme` | The cwd test for "which workspace is this", ahead of the glob |
| `github_login` | `your-gh-handle` | Your own login, for "PRs I opened" and "reviews of me" |
| `github_org` | `Acme-Inc` | The org whose repos count as work |
| `exclude_orgs` | `sideproject`, `OldCo` | Orgs to drop from every sweep |
| `linear_teams` | `ENG`, `OPS` | **Every** team holding your issues, not just the first |
| `linear_user` | `you@acme.com` | Work email — `list_users` takes it as a query and returns both the id and the display name |
| `work_channels` | `C0123ABCDEF` (`#dev`) | Channel ids. Read differently by each skill — see below |
| `chat_destination` | `U0123ABCDEF` | Where `work-summary` drafts. A DM id is fine |
| `outline_base` | `https://docs.acme.com` | Wiki base URL |
| `outline_user_id` | `00000000-0000-0000-0000-000000000000` | Your wiki user id |
| `transcript_glob` | `-Users-you-acme*` | Session transcripts, filtered by cwd |
| `work_log_dir` | `~/acme/.claude/work-log` | Where both skills record a run |

## Three things the table cannot say

**`work_channels` means opposite things to the two skills, on purpose.** `work-summary` reads
it as a channel list — the channels its chat pass searches. `work-queue` searches every channel
and DM regardless, and reads this key only to *rank* what it finds. Do not "fix" the
inconsistency by making `work-queue` honour it as a scope; that was the old behaviour, and an
allowlist hid exactly the direct asks most likely to be blocking someone.

**`linear_teams` is the key that goes stale.** A team gets created, work starts landing in it,
and the profile still names one. The sweep then misses half the queue while looking healthy.
When the queue reads thinner than it should, re-check this before anything else.

**These are identifiers, not secrets.** Never put tokens, keys, cookies or connection strings
in a profile. If a skill needs a credential, it should read it from the secret store at the
point of use.

## Minimal version

Everything above is optional except what the sources you actually run require. A profile this
short is legitimate if you only sweep the tracker and GitHub:

```markdown
# Workspace profile — Acme

| Key | Value |
|---|---|
| `workspace_root` | `~/acme` |
| `github_login` | `your-gh-handle` |
| `github_org` | `Acme-Inc` |
| `linear_teams` | `ENG` |
| `linear_user` | `you@acme.com` |
| `work_log_dir` | `~/acme/.claude/work-log` |
```

A skill that needs a key you have not defined says which key and stops. That is the intended
way to discover the rest — add them as the sweep grows, rather than filling in all twelve up
front.
