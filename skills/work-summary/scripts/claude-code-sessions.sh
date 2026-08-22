#!/usr/bin/env bash
# Lists one workspace's Claude Code sessions and their human prompts over a local-date range.
# Usage: claude-code-sessions.sh [START [END]]   (YYYY-MM-DD, inclusive; both default to today)
set -uo pipefail

START="${1:-$(date +%Y-%m-%d)}"
END="${2:-$START}"
ROOT="${CLAUDE_PROJECTS_DIR:-$HOME/.claude/projects}"
# Project dirs are the session cwd with "/" replaced by "-", so a workspace-root prefix acts
# as the org filter: other orgs' sessions never match. Required - there is no sane default.
GLOB="${CLAUDE_SESSION_GLOB:?set CLAUDE_SESSION_GLOB to the transcript_glob from the profile}"
MAXLEN="${PROMPT_MAXLEN:-220}"

if [[ ! "$START" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ || ! "$END" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
  echo "usage: $(basename "$0") [START [END]]   dates as YYYY-MM-DD" >&2
  exit 2
fi
if [[ "$END" < "$START" ]]; then
  echo "error: END ($END) is before START ($START)" >&2
  exit 2
fi

# Time column: clock only for a single day, date + clock for a range.
if [ "$START" = "$END" ]; then TSFMT="%H:%M"; else TSFMT="%Y-%m-%d %H:%M"; fi

RS=$'\036'   # stands in for newline while a session block is one sortable line
shopt -s nullglob
out=""
sessions=0
prompts=0

for f in "$ROOT"/$GLOB/*.jsonl; do
  body=$(jq -r --arg s "$START" --arg e "$END" --arg fmt "$TSFMT" --argjson max "$MAXLEN" '
    select(.type == "user" and .origin.kind == "human" and (.isSidechain != true))
    | (.timestamp | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601) as $epoch
    | ($epoch | strflocaltime("%Y-%m-%d")) as $day
    | select($day >= $s and $day <= $e)
    | ($epoch | tostring) + "\t" + ($epoch | strflocaltime($fmt)) + "  " +
      (.message.content
       | if type == "string" then . else (map(select(.type == "text") | .text) | join(" ")) end
       | gsub("\\s+"; " ")
       | if (length > $max) then (.[0:$max] + " …[truncated]") else . end)
  ' "$f" 2>/dev/null)
  [ -n "$body" ] || continue

  first=$(head -1 <<<"$body" | cut -f1)
  title=$(jq -r 'select(.type == "ai-title") | .aiTitle' "$f" 2>/dev/null | tail -1)
  meta=$(jq -r 'select(.cwd) | [.cwd, (.gitBranch // "-")] | @tsv' "$f" 2>/dev/null | tail -1)
  n=$(grep -c '' <<<"$body")
  sessions=$((sessions + 1))
  prompts=$((prompts + n))

  header=$(printf '== %s%s   %s | branch %s | session %s | %s prompt(s)' \
    "${title:-(untitled)}" "$RS" "$(cut -f1 <<<"$meta")" "$(cut -f2 <<<"$meta")" \
    "$(basename "$f" .jsonl | cut -c1-8)" "$n")
  lines=$(cut -f2- <<<"$body" | sed 's/^/   /' | tr '\n' "$RS")
  out+="$first	$header$RS$lines"$'\n'
done

if [ "$sessions" -eq 0 ]; then
  echo "(no Claude Code sessions with prompts in $START..$END for glob $GLOB)"
  exit 0
fi

# Sessions in the order they started, not glob order.
printf '%s' "$out" | sort -n -k1,1 | cut -f2- | tr "$RS" '\n'
printf -- '-- %s session(s), %s prompt(s), %s..%s\n' "$sessions" "$prompts" "$START" "$END"
