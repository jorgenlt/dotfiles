#!/usr/bin/env bash
#
# timeleft – calculate time between dates with many options
# Compatible with both GNU date and BSD/macOS date
#

set -euo pipefail

VERSION="2.2.0"
SCRIPT_NAME="${0##*/}"

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
INPUT_FORMAT=""
OUTPUT_STYLE="weeks"
REFERENCE_DATE=""
TARGET=""
SHOW_SIGN=false
COLOR=false
VERBOSE=false
QUIET=false
BUSINESS_DAYS=false
INCLUDE_TIME=false
PRECISION=0
CUSTOM_FORMAT=""
SEPARATOR=" and "
NO_PLURAL=false
FORCE_POSITIVE=false
LOCALE=""
PROGRESS=false
PROGRESS_WIDTH=40
JSON_PRETTY=false

# New: date display style
DATE_STYLE="iso"              # iso | long | long-eu | medium | medium-eu | short | short-eu | full | full-eu | monthday | compact | custom
DATE_FORMAT=""                # used when DATE_STYLE=custom

# ---------------------------------------------------------------------------
# Help
# ---------------------------------------------------------------------------
print_help() {
  cat <<EOF
$SCRIPT_NAME $VERSION – calculate time remaining / elapsed until a date

USAGE
  $SCRIPT_NAME [OPTIONS] DATE
  $SCRIPT_NAME [OPTIONS] --start DATE --end DATE

OPTIONS
  -h, --help                  Show this help
  -V, --version               Show version
      --list-formats          List supported input date formats

  Input / Reference
  -f, --format FORMAT         Force input date format
  -s, --start DATE            Reference date (default: today)
  -e, --end DATE              Target date (alternative to positional DATE)

  Output style
  -o, --output STYLE          weeks | days | months | ymd | total | hours |
                              seconds | raw | compact | long | phrase | json | custom
  -t, --template STRING       Custom template (with --output custom)
  -p, --precision N           Decimal places
      --separator STRING      Separator between units (default: " and ")
      --no-plural             Never pluralize
      --force-positive        Always use "left" wording
      --sign                  Always show + / - in numeric modes

  Date appearance (how the date itself is shown)
  -d, --date-style STYLE      How to display dates in the output (default: iso)
                              iso        → 2026-09-28
                              long       → September 28, 2026
                              long-eu    → 28 September 2026
                              medium     → Sep 28, 2026
                              medium-eu  → 28 Sep 2026
                              short      → 9/28/26
                              short-eu   → 28/9/26
                              full       → Monday, September 28, 2026
                              full-eu    → Monday 28 September 2026
                              monthday   → September 28
                              compact    → 20260928
                              custom     → use --date-format
      --date-format FORMAT    Custom strftime format (e.g. "%A, %d %B %Y")

  Behaviour
  -b, --business-days         Count only Mon–Fri
  -T, --time                  Include current time of day
  -c, --color                 Colourize output
  -v, --verbose               Extra information
  -q, --quiet                 Only the result
      --progress              Show progress bar (future dates)
      --progress-width N      Width of progress bar (default: 40)
      --json-pretty           Pretty-print JSON
      --locale LOCALE         Force locale (if supported by system)

EXAMPLES
  $SCRIPT_NAME 2026-09-28
  $SCRIPT_NAME -d long 2026-09-28
  $SCRIPT_NAME -d long-eu -o ymd 2026-12-25
  $SCRIPT_NAME -d full --color 2027-01-01
  $SCRIPT_NAME -d custom --date-format "%A %d %B %Y" 2026-09-28
  $SCRIPT_NAME -o days -d medium 2026-11-11
  $SCRIPT_NAME -s 2025-01-01 -e 2026-09-28 -d long-eu -o total

EOF
}

print_version() {
  echo "$SCRIPT_NAME $VERSION"
}

list_formats() {
  cat <<EOF
Supported input date formats (auto-detected when --format is not given):

  YYYY-MM-DD          2026-09-28
  YYYY/MM/DD          2026/09/28
  DD-MM-YYYY          28-09-2026
  DD/MM/YYYY          28/09/2026
  MM-DD-YYYY          09-28-2026
  MM/DD/YYYY          09/28/2026
  YYYYMMDD            20260928
  DD Mon YYYY         28 Sep 2026
  Mon DD, YYYY        Sep 28, 2026
  YYYY-MM-DD HH:MM    2026-09-28 14:30
  relative            tomorrow, +3 weeks, -10 days  (GNU date)

Force a format with:  $SCRIPT_NAME -f "%d/%m/%Y" 28/09/2026
EOF
}

# ---------------------------------------------------------------------------
# Utility functions
# ---------------------------------------------------------------------------
die() { echo "Error: $*" >&2; exit 1; }

is_gnu_date() {
  date --version >/dev/null 2>&1
}

to_epoch() {
  local date_str="$1"
  local fmt="${2:-}"

  if is_gnu_date; then
    if [[ -n "$fmt" ]]; then
      date -d "$date_str" +%s 2>/dev/null || date -d "$(date -d "$date_str" +"%Y-%m-%d")" +%s
    else
      if $INCLUDE_TIME; then
        date -d "$date_str" +%s
      else
        date -d "$date_str 00:00:00" +%s 2>/dev/null || date -d "$date_str" +%s
      fi
    fi
  else
    if [[ -n "$fmt" ]]; then
      date -j -f "$fmt" "$date_str" "+%s"
    else
      local try_formats=(
        "%Y-%m-%d" "%Y/%m/%d" "%d-%m-%Y" "%d/%m/%Y"
        "%m-%d-%Y" "%m/%d/%Y" "%Y%m%d"
        "%d %b %Y" "%b %d, %Y" "%d %B %Y" "%B %d, %Y"
        "%Y-%m-%d %H:%M" "%Y-%m-%d %H:%M:%S"
      )
      local ok=false
      for f in "${try_formats[@]}"; do
        if date -j -f "$f" "$date_str" "+%s" >/dev/null 2>&1; then
          if $INCLUDE_TIME; then
            date -j -f "$f" "$date_str" "+%s"
          else
            local ymd
            ymd=$(date -j -f "$f" "$date_str" "+%Y-%m-%d")
            date -j -f "%Y-%m-%d" "$ymd" "+%s"
          fi
          ok=true
          break
        fi
      done
      $ok || die "Cannot parse date: $date_str (try --format or --list-formats)"
    fi
  fi
}

# Format an epoch according to DATE_STYLE / DATE_FORMAT
format_date() {
  local epoch="$1"
  local fmt=""

  case "$DATE_STYLE" in
    iso)        fmt="%Y-%m-%d" ;;
    long)       fmt="%B %d, %Y" ;;          # September 28, 2026
    long-eu)    fmt="%d %B %Y" ;;           # 28 September 2026
    medium)     fmt="%b %d, %Y" ;;          # Sep 28, 2026
    medium-eu)  fmt="%d %b %Y" ;;           # 28 Sep 2026
    short)      fmt="%-m/%-d/%y" ;;         # 9/28/26  (GNU)
    short-eu)   fmt="%-d/%-m/%y" ;;         # 28/9/26
    full)       fmt="%A, %B %d, %Y" ;;      # Monday, September 28, 2026
    full-eu)    fmt="%A %d %B %Y" ;;        # Monday 28 September 2026
    monthday)   fmt="%B %d" ;;              # September 28
    compact)    fmt="%Y%m%d" ;;             # 20260928
    custom)
      [[ -z "$DATE_FORMAT" ]] && die "--date-style custom requires --date-format"
      fmt="$DATE_FORMAT"
      ;;
    *)
      die "Unknown date style: $DATE_STYLE"
      ;;
  esac

  # BSD date does not support %-m / %-d (no leading zero). Fallback.
  if ! is_gnu_date; then
    fmt="${fmt//%-m/%m}"
    fmt="${fmt//%-d/%d}"
    fmt="${fmt//%-H/%H}"
    fmt="${fmt//%-M/%M}"
  fi

  if is_gnu_date; then
    date -d "@$epoch" +"$fmt"
  else
    date -r "$epoch" +"$fmt"
  fi
}

abs() { echo "${1#-}"; }

pluralize() {
  local n="$1" singular="$2" plural="${3:-${2}s}"
  if $NO_PLURAL; then
    echo "$singular"
  else
    (( n == 1 || n == -1 )) && echo "$singular" || echo "$plural"
  fi
}

c_green()  { $COLOR && printf '\e[32m%s\e[0m' "$1" || printf '%s' "$1"; }
c_red()    { $COLOR && printf '\e[31m%s\e[0m' "$1" || printf '%s' "$1"; }
c_bold()   { $COLOR && printf '\e[1m%s\e[0m'  "$1" || printf '%s' "$1"; }

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)          print_help; exit 0 ;;
    -V|--version)       print_version; exit 0 ;;
    --list-formats)     list_formats; exit 0 ;;
    -f|--format)        INPUT_FORMAT="$2"; shift 2 ;;
    -s|--start)         REFERENCE_DATE="$2"; shift 2 ;;
    -e|--end)           TARGET="$2"; shift 2 ;;
    -o|--output)        OUTPUT_STYLE="$2"; shift 2 ;;
    -t|--template)      CUSTOM_FORMAT="$2"; shift 2 ;;
    -p|--precision)     PRECISION="$2"; shift 2 ;;
    --separator)        SEPARATOR="$2"; shift 2 ;;
    --no-plural)        NO_PLURAL=true; shift ;;
    --force-positive)   FORCE_POSITIVE=true; shift ;;
    --sign)             SHOW_SIGN=true; shift ;;
    -d|--date-style)    DATE_STYLE="$2"; shift 2 ;;
    --date-format)      DATE_FORMAT="$2"; shift 2 ;;
    -b|--business-days) BUSINESS_DAYS=true; shift ;;
    -T|--time)          INCLUDE_TIME=true; shift ;;
    -c|--color)         COLOR=true; shift ;;
    -v|--verbose)       VERBOSE=true; shift ;;
    -q|--quiet)         QUIET=true; shift ;;
    --progress)         PROGRESS=true; shift ;;
    --progress-width)   PROGRESS_WIDTH="$2"; shift 2 ;;
    --json-pretty)      JSON_PRETTY=true; shift ;;
    --locale)           LOCALE="$2"; shift 2 ;;
    --)                 shift; break ;;
    -*)                 die "Unknown option: $1 (try --help)" ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$1"
      else
        die "Unexpected argument: $1"
      fi
      shift
      ;;
  esac
done

[[ -z "$TARGET" ]] && { print_help; exit 1; }

# Optional locale
if [[ -n "$LOCALE" ]]; then
  export LC_TIME="$LOCALE"
fi

# ---------------------------------------------------------------------------
# Resolve epochs + pretty dates
# ---------------------------------------------------------------------------
if [[ -z "$REFERENCE_DATE" ]]; then
  if $INCLUDE_TIME; then
    REF_EPOCH=$(date +%s)
  else
    REF_EPOCH=$(to_epoch "$(date +%Y-%m-%d)")
  fi
else
  REF_EPOCH=$(to_epoch "$REFERENCE_DATE" "$INPUT_FORMAT")
fi

TARGET_EPOCH=$(to_epoch "$TARGET" "$INPUT_FORMAT")

# Human-readable versions according to --date-style
REF_DISPLAY=$(format_date "$REF_EPOCH")
TARGET_DISPLAY=$(format_date "$TARGET_EPOCH")

DIFF_SEC=$(( TARGET_EPOCH - REF_EPOCH ))
DAYS=$(( DIFF_SEC / 86400 ))
ABS_DAYS=$(abs "$DAYS")

# ---------------------------------------------------------------------------
# Business days (Mon–Fri)
# ---------------------------------------------------------------------------
if $BUSINESS_DAYS; then
  business_days_between() {
    local start=$1 end=$2
    local count=0 cur=$start direction=1
    (( end < start )) && direction=-1
    while (( (direction == 1 && cur < end) || (direction == -1 && cur > end) )); do
      cur=$(( cur + direction * 86400 ))
      local dow
      if is_gnu_date; then
        dow=$(date -d "@$cur" +%u)
      else
        dow=$(date -r "$cur" +%u)
      fi
      (( dow < 6 )) && count=$(( count + direction ))
    done
    echo "$count"
  }
  DAYS=$(business_days_between "$REF_EPOCH" "$TARGET_EPOCH")
  ABS_DAYS=$(abs "$DAYS")
fi

# ---------------------------------------------------------------------------
# Derived values
# ---------------------------------------------------------------------------
WEEKS=$(( ABS_DAYS / 7 ))
REM_DAYS=$(( ABS_DAYS % 7 ))

TOTAL_MONTHS=$(awk -v d="$ABS_DAYS" 'BEGIN{printf "%.0f", d/30.436875}')
YEARS=$(( TOTAL_MONTHS / 12 ))
MONTHS=$(( TOTAL_MONTHS % 12 ))
REM_AFTER_YM=$(( ABS_DAYS - (YEARS * 365 + MONTHS * 30) ))

HOURS=$(( ABS_DAYS * 24 + (DIFF_SEC % 86400) / 3600 ))
SECONDS=$DIFF_SEC
(( SECONDS < 0 )) && SECONDS=$(( -SECONDS ))

DIRECTION="future"
(( DAYS < 0 )) && DIRECTION="past"
(( DAYS == 0 )) && DIRECTION="today"

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------
build_weeks_phrase() {
  local w="$1" d="$2"
  local parts=()
  (( w > 0 )) && parts+=("$w $(pluralize "$w" week)")
  (( d > 0 || w == 0 )) && parts+=("$d $(pluralize "$d" day)")
  local IFS="$SEPARATOR"
  echo "${parts[*]}"
}

build_ymd_phrase() {
  local y="$1" m="$2" d="$3"
  local parts=()
  (( y > 0 )) && parts+=("$y $(pluralize "$y" year)")
  (( m > 0 )) && parts+=("$m $(pluralize "$m" month)")
  (( d > 0 || (y == 0 && m == 0) )) && parts+=("$d $(pluralize "$d" day)")
  local IFS="$SEPARATOR"
  echo "${parts[*]}"
}

print_progress() {
  local days_left=$1
  local total=365
  (( days_left > total )) && total=$days_left
  local filled=$(( (total - days_left) * PROGRESS_WIDTH / total ))
  (( filled < 0 )) && filled=0
  (( filled > PROGRESS_WIDTH )) && filled=$PROGRESS_WIDTH
  local bar
  bar=$(printf "%${filled}s" | tr ' ' '#')
  bar+=$(printf "%$((PROGRESS_WIDTH - filled))s" | tr ' ' '-')
  printf "[%s] %d days remaining\n" "$bar" "$days_left"
}

# ---------------------------------------------------------------------------
# Main output
# ---------------------------------------------------------------------------
output_result() {
  local sign=""
  if $SHOW_SIGN || [[ "$OUTPUT_STYLE" == "raw" ]]; then
    if (( DAYS > 0 )); then sign="+"; elif (( DAYS < 0 )); then sign="-"; fi
  fi

  case "$OUTPUT_STYLE" in
    weeks)
      if (( DAYS == 0 )); then
        $QUIET && echo "0" || echo "Today is $TARGET_DISPLAY!"
      elif (( DAYS > 0 )) || $FORCE_POSITIVE; then
        local phrase
        phrase=$(build_weeks_phrase "$WEEKS" "$REM_DAYS")
        if $QUIET; then echo "$phrase"
        else printf "%s left until %s\n" "$(c_green "$phrase")" "$(c_bold "$TARGET_DISPLAY")"
        fi
      else
        local phrase
        phrase=$(build_weeks_phrase "$WEEKS" "$REM_DAYS")
        if $QUIET; then echo "$phrase"
        else printf "%s ago was %s\n" "$(c_red "$phrase")" "$(c_bold "$TARGET_DISPLAY")"
        fi
      fi
      ;;

    days)
      if (( DAYS == 0 )); then
        $QUIET && echo "0" || echo "Today is $TARGET_DISPLAY!"
      elif (( DAYS > 0 )) || $FORCE_POSITIVE; then
        $QUIET && echo "$ABS_DAYS" || \
          printf "%s %s left until %s\n" "$(c_green "$ABS_DAYS")" "$(pluralize "$ABS_DAYS" day)" "$(c_bold "$TARGET_DISPLAY")"
      else
        $QUIET && echo "$ABS_DAYS" || \
          printf "%s %s ago was %s\n" "$(c_red "$ABS_DAYS")" "$(pluralize "$ABS_DAYS" day)" "$(c_bold "$TARGET_DISPLAY")"
      fi
      ;;

    months)
      local phrase
      phrase=$(build_ymd_phrase 0 "$TOTAL_MONTHS" "$((ABS_DAYS % 30))")
      if (( DAYS == 0 )); then
        $QUIET && echo "0" || echo "Today is $TARGET_DISPLAY!"
      elif (( DAYS > 0 )) || $FORCE_POSITIVE; then
        $QUIET && echo "$phrase" || printf "%s left until %s\n" "$(c_green "$phrase")" "$(c_bold "$TARGET_DISPLAY")"
      else
        $QUIET && echo "$phrase" || printf "%s ago was %s\n" "$(c_red "$phrase")" "$(c_bold "$TARGET_DISPLAY")"
      fi
      ;;

    ymd)
      local phrase
      phrase=$(build_ymd_phrase "$YEARS" "$MONTHS" "$REM_AFTER_YM")
      if (( DAYS == 0 )); then
        $QUIET && echo "0" || echo "Today is $TARGET_DISPLAY!"
      elif (( DAYS > 0 )) || $FORCE_POSITIVE; then
        $QUIET && echo "$phrase" || printf "%s left until %s\n" "$(c_green "$phrase")" "$(c_bold "$TARGET_DISPLAY")"
      else
        $QUIET && echo "$phrase" || printf "%s ago was %s\n" "$(c_red "$phrase")" "$(c_bold "$TARGET_DISPLAY")"
      fi
      ;;

    total|hours|seconds)
      local val="$ABS_DAYS"
      [[ "$OUTPUT_STYLE" == "hours" ]] && val="$HOURS"
      [[ "$OUTPUT_STYLE" == "seconds" ]] && val="$SECONDS"
      if $SHOW_SIGN; then printf "%s%d\n" "$sign" "$val"
      else echo "$val"
      fi
      ;;

    raw)
      echo "${sign}${DAYS}"
      ;;

    compact)
      if (( DAYS == 0 )); then echo "today"
      else
        local out=""
        (( WEEKS > 0 )) && out+="${WEEKS}w"
        (( REM_DAYS > 0 || WEEKS == 0 )) && out+="${out:+ }${REM_DAYS}d"
        if (( DAYS < 0 )) && ! $FORCE_POSITIVE; then echo "${out} ago"
        else echo "$out"
        fi
      fi
      ;;

    long)
      if (( DAYS == 0 )); then
        echo "Today ($REF_DISPLAY) is exactly the target date $TARGET_DISPLAY."
      elif (( DAYS > 0 )); then
        echo "There are still $(build_weeks_phrase "$WEEKS" "$REM_DAYS") remaining until $TARGET_DISPLAY (counting from $REF_DISPLAY)."
      else
        echo "It has been $(build_weeks_phrase "$WEEKS" "$REM_DAYS") since $TARGET_DISPLAY (reference date: $REF_DISPLAY)."
      fi
      ;;

    phrase)
      if (( DAYS == 0 )); then echo "today"
      elif (( ABS_DAYS == 1 )); then
        (( DAYS > 0 )) && echo "tomorrow" || echo "yesterday"
      elif (( WEEKS == 0 )); then
        (( DAYS > 0 )) && echo "in $ABS_DAYS days" || echo "$ABS_DAYS days ago"
      elif (( REM_DAYS == 0 )); then
        (( DAYS > 0 )) && echo "in $WEEKS $(pluralize "$WEEKS" week)" || echo "$WEEKS $(pluralize "$WEEKS" week) ago"
      else
        (( DAYS > 0 )) && echo "in $(build_weeks_phrase "$WEEKS" "$REM_DAYS")" || \
                          echo "$(build_weeks_phrase "$WEEKS" "$REM_DAYS") ago"
      fi
      ;;

    json)
      local json
      json=$(cat <<EOF
{"target":"$TARGET_DISPLAY","reference":"$REF_DISPLAY","days":$DAYS,"abs_days":$ABS_DAYS,"weeks":$WEEKS,"remaining_days":$REM_DAYS,"years":$YEARS,"months":$MONTHS,"direction":"$DIRECTION","business_days":$BUSINESS_DAYS,"date_style":"$DATE_STYLE"}
EOF
)
      if $JSON_PRETTY && command -v jq >/dev/null 2>&1; then
        echo "$json" | jq .
      elif $JSON_PRETTY; then
        echo "$json" | sed 's/,/,\n  /g; s/{/{\n  /; s/}/\n}/'
      else
        echo "$json"
      fi
      ;;

    custom)
      [[ -z "$CUSTOM_FORMAT" ]] && die "--output custom requires --template"
      local result="$CUSTOM_FORMAT"
      result=${result//%w/$WEEKS}
      result=${result//%d/$REM_DAYS}
      result=${result//%m/$MONTHS}
      result=${result//%y/$YEARS}
      result=${result//%D/$ABS_DAYS}
      result=${result//%H/$HOURS}
      result=${result//%S/$SECONDS}
      result=${result//%sign/$sign}
      result=${result//%target/$TARGET_DISPLAY}
      result=${result//%ref/$REF_DISPLAY}
      echo "$result"
      ;;

    *)
      die "Unknown output style: $OUTPUT_STYLE"
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Run
# ---------------------------------------------------------------------------
if $VERBOSE; then
  echo "Reference : $REF_DISPLAY  (epoch $REF_EPOCH)"
  echo "Target    : $TARGET_DISPLAY  (epoch $TARGET_EPOCH)"
  echo "Diff      : $DIFF_SEC seconds → $DAYS days"
  echo "Date style: $DATE_STYLE"
  $BUSINESS_DAYS && echo "Mode      : business days only"
  echo "----"
fi

output_result

if $PROGRESS && (( DAYS > 0 )); then
  print_progress "$DAYS"
fi
