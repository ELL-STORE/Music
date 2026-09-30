#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
#  MUSIC PLAYER  —  Termux Edition (v2.6.1)
#  by @smallchild_raff03  •  License: CC BY-NC-SA 4.0
#  Dilarang menjual script ini, wajib credit.
# ============================================================

set -uo pipefail

RESET='\033[0m'; BOLD='\033[1m'; DIM='\033[2m'
CYAN='\033[38;5;51m'; MAG='\033[38;5;213m'; YEL='\033[38;5;220m'
GRN='\033[38;5;84m'; RED='\033[38;5;203m'; BLU='\033[38;5;75m'
WHT='\033[97m'

TERM_COLS=$(tput cols 2>/dev/null)
[[ "$TERM_COLS" =~ ^[0-9]+$ ]] || TERM_COLS=54
if [ "$TERM_COLS" -ge 56 ]; then
  WIDTH=54
else
  WIDTH=$((TERM_COLS - 2))
fi
[ "$WIDTH" -lt 34 ] && WIDTH=34
TMPDIR="/data/data/com.termux/files/usr/tmp/ellmusic.$$"
mkdir -p "$TMPDIR" 2>/dev/null || { TMPDIR="/tmp/ellmusic.$$"; mkdir -p "$TMPDIR"; }
HISTORY_FILE="$HOME/.ellmusic_history.log"
CONFIG_FILE="$HOME/.ellmusic_config"
MPV_PID=""
REPEAT=0
VU_LEVELS=(0 0 0 0 0 0 0 0 0 0)
ELL_LANG=""

BANNER_ANIMATED=0
BANNER_PHASE=0
RAINBOW_COLORS=("38;5;213" "38;5;207" "38;5;201" "38;5;171" "38;5;45" "38;5;51" "38;5;84" "38;5;220")

_MP_IG="smallchild_raff03"
_MP_GH="ELL-STORE"
_MP_TT="darkprime46"

set_translations() {
  if [ "$ELL_LANG" == "en" ]; then
    L_BOOT_1="Starting Music Player..."
    L_BOOT_2="Connecting to yt-dlp + mpv..."
    L_BOOT_3="Ready! ✓"
    L_BOOT_STEP1="Checking dependencies"
    L_BOOT_STEP2="Loading audio engine"
    L_BOOT_STEP3="Initializing player"
    L_MENU_TITLE="Type SONG name or BAND name"
    L_MENU_SUB="(random / history / help / exit / language)"
    L_MENU_PROMPT="❯ "
    L_MODE_PROMPT="Mode? [1] Single song (select)   [2] Full band/artist songs"
    L_MODE_INPUT="❯ "
    L_RAND_COUNT="How many songs? (Enter = 8): "
    L_RAND_PREP="🎲 Preparing %d random songs (Western + Indo pop)..."
    L_RAND_READY="✓ %d songs ready to play!"
    L_RAND_FAIL="Failed to prepare random playlist. Try again."
    L_SEARCHING="🔍 Searching: "
    L_NOT_FOUND="✗ No results found for that."
    L_EMPTY_QUERY="Empty, try another keyword."
    L_SHUFFLE_PROMPT="Shuffle track order? [y/N]: "
    L_FOUND_BAND="✓ Found %d songs from \"%s\". Auto-playing..."
    L_SELECT_NUM="Choose number (Enter = 1): "
    L_PLAYER_CONTROLS="[p]pause [r]repeat [n]next [q]stop"
    L_NEXT_TRACK="Next: "
    L_FINISHED="✓ Finished."
    L_SKIPPED="⏭  Skip..."
    L_STOPPED="⏹  Stop."
    L_HISTORY_TITLE="🕘 PLAY HISTORY"
    L_HISTORY_EMPTY="No history yet. Play some songs~"
    L_PRESS_ENTER="Press Enter to return to menu..."
    L_HELP_TITLE="❓ HELP"
    L_HELP_DESC="Type song / band name, then choose mode:"
    L_HELP_MODE1="  [1] Single song (select from results)"
    L_HELP_MODE2="  [2] Full songs / discography (auto-play all)"
    L_HELP_CTRL="Controls while playing:"
    L_HELP_CTRL_KEYS="  p = pause/resume   r = toggle repeat"
    L_HELP_CTRL_KEYS2="  n = next / skip    q = stop"
    L_HELP_CMD="Other commands: random | history | help | lang | exit"
    L_HELP_TIP="If songs buffer: pkg install termux-api"
    L_HELP_TIP2="+ install Termux:API app, to prevent CPU sleep"
    L_EXIT_MSG="Thanks for listening~"
    L_WARN_FULL="⚠️"
    L_TRACK_INFO="track %d/%d"
    L_PLAYING=" 🎵 NOW PLAYING "
    L_LANG_TITLE="Select Language / Pilih Bahasa:"
    L_LANG_CHOICE="1. Indonesia\n2. English"
    L_LANG_PROMPT="❯ "
  else
    L_BOOT_1="Menyalakan Music Player..."
    L_BOOT_2="Menghubungkan ke yt-dlp + mpv..."
    L_BOOT_3="Siap! ✓"
    L_BOOT_STEP1="Cek dependensi"
    L_BOOT_STEP2="Load audio engine"
    L_BOOT_STEP3="Inisialisasi player"
    L_MENU_TITLE="Ketik nama LAGU atau nama BAND"
    L_MENU_SUB="(random / riwayat / bantuan / exit / bahasa)"
    L_MENU_PROMPT="❯ "
    L_MODE_PROMPT="Mode? [1] Satu lagu (pilih)   [2] Full lagu band/artist"
    L_MODE_INPUT="❯ "
    L_RAND_COUNT="Mau berapa lagu? (Enter = 8): "
    L_RAND_PREP="🎲 Nyiapin %d lagu random (Barat + Indo populer)..."
    L_RAND_READY="✓ %d lagu siap diputer!"
    L_RAND_FAIL="Yah, gagal nyiapin playlist random. Coba lagi."
    L_SEARCHING="🔍 Nyari: "
    L_NOT_FOUND="✗ Ga ketemu hasil buat itu."
    L_EMPTY_QUERY="Kosong, coba kata kunci lain."
    L_SHUFFLE_PROMPT="Acak urutan lagu? [y/N]: "
    L_FOUND_BAND="✓ Ketemu %d lagu dari \"%s\". Mulai muter otomatis..."
    L_SELECT_NUM="Pilih nomor (Enter = 1): "
    L_PLAYER_CONTROLS="[p]pause [r]repeat [n]next [q]stop"
    L_NEXT_TRACK="Berikutnya: "
    L_FINISHED="✓ Selesai."
    L_SKIPPED="⏭  Skip..."
    L_STOPPED="⏹  Stop."
    L_HISTORY_TITLE="🕘 RIWAYAT PEMUTARAN"
    L_HISTORY_EMPTY="Belum ada riwayat. Muter lagu dulu ya~"
    L_PRESS_ENTER="Tekan Enter buat balik ke menu..."
    L_HELP_TITLE="❓ BANTUAN"
    L_HELP_DESC="Ketik nama lagu / band, lalu pilih mode:"
    L_HELP_MODE1="  [1] Satu lagu (pilih dari hasil pencarian)"
    L_HELP_MODE2="  [2] Full lagu / discography (auto-play semua)"
    L_HELP_CTRL="Kontrol pas lagu muter:"
    L_HELP_CTRL_KEYS="  p = pause/resume   r = toggle repeat"
    L_HELP_CTRL_KEYS2="  n = next / skip    q = stop"
    L_HELP_CMD="Perintah lain: random | riwayat | bantuan | bahasa | exit"
    L_HELP_TIP="Kalo lagu putus-putus: pkg install termux-api"
    L_HELP_TIP2="+ install app Termux:API, biar CPU ga di-tidurin"
    L_EXIT_MSG="Makasih udah dengerin~"
    L_WARN_FULL="⚠️"
    L_TRACK_INFO="track %d/%d"
    L_PLAYING=" 🎵 NOW PLAYING "
    L_LANG_TITLE="Select Language / Pilih Bahasa:"
    L_LANG_CHOICE="1. Indonesia\n2. English"
    L_LANG_PROMPT="❯ "
  fi
}

set_translations

# masukkan band favorit mu
# enter your favorite band
RANDOM_SONGS=(
  "Ed Sheeran Shape of You"
  "The Weeknd Blinding Lights"
  "Dua Lipa Levitating"
  "Bruno Mars Uptown Funk"
  "Adele Someone Like You"
  "Coldplay Yellow"
  "Imagine Dragons Believer"
  "Taylor Swift Love Story"
  "Maroon 5 Sugar"
  "Ed Sheeran Perfect"
  "Billie Eilish Bad Guy"
  "OneRepublic Counting Stars"
  "Charlie Puth Attention"
  "Sam Smith Stay With Me"
  "John Legend All of Me"
  "Tulus Hati Hati di Jalan"
  "Raisa Serba Salah"
  "Rizky Febian Cukup Tau"
  "Sheila On 7 Dan"
  "Noah Separuh Aku"
  "Nidji Laskar Pelangi"
  "Ada Band Manusia Bodoh"
  "Isyana Sarasvati Kau Adalah"
  "Hindia Secukupnya"
  "Mahalini Sial"
  "Lyodra Mana Kutahu"
  "Fiersa Besari Waktu Yang Salah"
  "Padi Sobat"
  "Peterpan Kisah Cintaku"
  "Glenn Fredly Sekali Ini Saja"
  "Dewa 19 Kangen"
  "Armada Asal Kau Bahagia"
  "Yura Yunita Tutur Batin"
  "Danilla Sunyi"
  "GAC Kepompong"
  ".feast"
  "hindia"
  "iwan fals"
  "topi sihir"
)

cleanup() {
  [ -n "$MPV_PID" ] && kill -CONT "$MPV_PID" 2>/dev/null && kill "$MPV_PID" 2>/dev/null
  rm -rf "$TMPDIR" 2>/dev/null
  command -v termux-wake-unlock >/dev/null 2>&1 && termux-wake-unlock 2>/dev/null
  printf "${RESET}\n${MAG}${BOLD}  $L_EXIT_MSG${RESET}\n\n"
  exit 0
}
trap cleanup SIGINT SIGTERM EXIT

center() {
  local text="$1"; local color="${2:-$WHT}"
  local len=${#text}
  local pad=$(( (WIDTH - len) / 2 ))
  [ $pad -lt 0 ] && pad=0
  printf "${color}%*s%s%*s${RESET}\n" $pad "" "$text" $pad ""
}

box_top()    { printf "${CYAN}╔%s╗${RESET}\n" "$(printf '═%.0s' $(seq 1 $((WIDTH-2))))"; }
box_bottom() { printf "${CYAN}╚%s╝${RESET}\n" "$(printf '═%.0s' $(seq 1 $((WIDTH-2))))"; }
box_line() {
  local text="$1"; local color="${2:-$WHT}"
  local len=${#text}
  local inner=$((WIDTH-2))
  local pad=$(( (inner - len) / 2 ))
  [ $pad -lt 0 ] && pad=0
  local rpad=$((inner - len - pad))
  printf "${CYAN}║${RESET}%*s${color}%s${RESET}%*s${CYAN}║${RESET}\n" $pad "" "$text" $rpad ""
}
box_line_left() {
  local text="$1"; local color="${2:-$WHT}"
  local inner=$((WIDTH-2))
  local len=${#text}
  [ $len -gt $((inner-2)) ] && text="${text:0:$((inner-5))}..." && len=${#text}
  local rpad=$((inner - len - 1))
  printf "${CYAN}║${RESET} ${color}%s${RESET}%*s${CYAN}║${RESET}\n" "$text" $rpad ""
}

box_line_rainbow() {
  local visible_text="$1"
  local phase="${2:-0}"
  local inner=$((WIDTH-2))
  local len=${#visible_text}
  local pad=$(( (inner - len) / 2 ))
  [ $pad -lt 0 ] && pad=0
  local rpad=$((inner - len - pad))

  local rainbow=""
  local i c color
  for ((i=0; i<${#visible_text}; i++)); do
    c="${visible_text:$i:1}"
    if [ "$c" == " " ]; then
      rainbow+=" "
    else
      color="${RAINBOW_COLORS[$(( (phase + i) % ${#RAINBOW_COLORS[@]} ))]}"
      rainbow+=$'\033'"[${color};1m${c}"
    fi
  done
  printf "${CYAN}║${RESET}%*s%b\033[0m%*s${CYAN}║${RESET}\n" $pad "" "$rainbow" $rpad ""
}

type_out() {
  local text="$1" delay="${2:-0.015}"
  local i
  for ((i=0; i<${#text}; i++)); do
    printf "%s" "${text:$i:1}"
    sleep "$delay"
  done
  printf "\n"
}

boot_progress() {
  local label="$1"
  local duration="${2:-1.0}"
  local width=22
  local steps=22
  local sleep_time
  sleep_time=$(awk "BEGIN {printf \"%.3f\", $duration/$steps}")
  local i filled empty bar pct
  for ((i=0; i<=steps; i++)); do
    filled=$(( i * width / steps ))
    empty=$(( width - filled ))
    pct=$(( i * 100 / steps ))
    bar=$(printf '█%.0s' $(seq 1 $filled) 2>/dev/null)
    bar+=$(printf '░%.0s' $(seq 1 $empty) 2>/dev/null)
    printf "\r\033[K  ${CYAN}▸${RESET} ${WHT}%s${RESET}  ${YEL}[${RESET}${GRN}%s${RESET}${YEL}]${RESET} ${WHT}%3d%%${RESET}" "$label" "$bar" "$pct"
    sleep "$sleep_time"
  done
  printf "\r\033[K  ${GRN}✓${RESET} ${WHT}%s${RESET}\n" "$label"
}

check_deps() {
  local miss=0
  command -v yt-dlp >/dev/null 2>&1 || { echo -e "${RED}✗ yt-dlp not installed${RESET}"; miss=1; }
  command -v mpv    >/dev/null 2>&1 || { echo -e "${RED}✗ mpv not installed${RESET}"; miss=1; }
  command -v jq     >/dev/null 2>&1 || { echo -e "${RED}✗ jq not installed${RESET}"; miss=1; }
  if [ $miss -eq 1 ]; then
    echo -e "${YEL}Install:${RESET} pkg update && pkg install -y yt-dlp mpv ffmpeg jq"
    exit 1
  fi
}

acquire_wakelock() {
  if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock 2>/dev/null
  fi
}

banner() {
  clear
  echo
  box_top
  box_line ""
  local E=("██████" "██    " "██    " "██████" "██    " "██    " "██████")
  local L=("██    " "██    " "██    " "██    " "██    " "██    " "██████")
  local colors=("\033[38;5;213m" "\033[38;5;207m" "\033[38;5;201m" "\033[38;5;207m" "\033[38;5;45m" "\033[38;5;51m" "${YEL}${BOLD}")
  local i
  for i in "${!E[@]}"; do
    box_line "${E[$i]}  ${L[$i]}  ${L[$i]}" "${colors[$i]}"
    if [ "$BANNER_ANIMATED" -eq 0 ]; then
      sleep 0.035
    fi
  done
  box_line ""
  box_line_rainbow "M U S I C   P L A Y E R" "$BANNER_PHASE"
  box_line "— powered by yt-dlp + mpv —" "$DIM$WHT"
  box_line ""
  box_line_left "◉  Instagram  : @${_MP_IG}"  "$MAG"
  box_line_left "◆  GitHub     : @${_MP_GH}"  "$WHT"
  box_line_left "♪  TikTok     : @${_MP_TT}"  "$CYAN"
  box_line ""
  box_line "Show some love to the dev so I keep cookin'!" "$DIM$WHT"
  box_line ""
  box_bottom
  echo

  BANNER_ANIMATED=1
  BANNER_PHASE=$(( (BANNER_PHASE + 1) % 8 ))
}

boot_intro() {
  clear
  echo
  printf "${MAG}${BOLD}"
  center "╭────────────────────────────────────╮" "$MAG"
  center "│       MUSIC PLAYER  •  v2.6.1      │" "$MAG"
  center "╰────────────────────────────────────╯" "$MAG"
  printf "${RESET}\n"

  boot_progress "$L_BOOT_STEP1" 0.9
  boot_progress "$L_BOOT_STEP2" 0.9
  boot_progress "$L_BOOT_STEP3" 0.7
  echo

  printf "${CYAN}  "; type_out "$L_BOOT_1" 0.018
  printf "${MAG}  "; type_out "$L_BOOT_2" 0.018
  printf "${GRN}  "; type_out "$L_BOOT_3" 0.025
  sleep 0.4
}

spinner() {
  local msg="$1"
  local pid=$2
  local frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0
  while kill -0 "$pid" 2>/dev/null; do
    i=$(( (i+1) % ${#frames} ))
    printf "\r\033[K${CYAN}${frames:$i:1}${RESET} ${WHT}%s${RESET}" "$msg" >&2
    sleep 0.08
  done
  printf "\r\033[K" >&2
}

fmt_time() {
  local s=$1
  printf "%02d:%02d" $((s/60)) $((s%60))
}

log_history() {
  local title="$1" artist="$2"
  mkdir -p "$(dirname "$HISTORY_FILE")" 2>/dev/null
  printf "%s | %s - %s\n" "$(date '+%d/%m %H:%M')" "$artist" "$title" >> "$HISTORY_FILE" 2>/dev/null
}

show_history() {
  clear; banner
  box_top
  box_line "$L_HISTORY_TITLE" "$YEL$BOLD"
  box_bottom
  echo
  if [ ! -s "$HISTORY_FILE" ]; then
    center "$L_HISTORY_EMPTY" "$DIM$WHT"
  else
    tail -n 15 "$HISTORY_FILE" | tac | while IFS= read -r line; do
      printf "  ${MAG}♪${RESET} ${WHT}%s${RESET}\n" "$line"
    done
  fi
  echo
  read -n1 -r -p "$(printf "${DIM}$L_PRESS_ENTER${RESET}")"
}

show_help() {
  clear; banner
  box_top
  box_line "$L_HELP_TITLE" "$YEL$BOLD"
  box_bottom
  box_line_left "$L_HELP_DESC" "$WHT"
  box_line_left "$L_HELP_MODE1" "$GRN"
  box_line_left "$L_HELP_MODE2" "$MAG"
  box_line_left "" "$WHT"
  box_line_left "$L_HELP_CTRL" "$WHT"
  box_line_left "$L_HELP_CTRL_KEYS" "$CYAN"
  box_line_left "$L_HELP_CTRL_KEYS2" "$CYAN"
  box_line_left "" "$WHT"
  box_line_left "$L_HELP_CMD" "$DIM$WHT"
  box_line_left "" "$WHT"
  box_line_left "$L_HELP_TIP" "$DIM$WHT"
  box_line_left "$L_HELP_TIP2" "$DIM$WHT"
  box_bottom
  echo
  read -n1 -r -p "$(printf "${DIM}$L_PRESS_ENTER${RESET}")"
}

choose_language() {
  clear
  echo -e "${CYAN}${BOLD}$L_LANG_TITLE${RESET}\n"
  echo -e "${WHT}$L_LANG_CHOICE${RESET}\n"
  printf "${CYAN}$L_LANG_PROMPT${RESET}"
  read -r lang_choice
  case "$lang_choice" in
    2) ELL_LANG="en" ;;
    *) ELL_LANG="id" ;;
  esac
  echo "ELL_LANG=\"$ELL_LANG\"" > "$CONFIG_FILE"
  set_translations
}

search_yt() {
  local query="$1" count="${2:-10}"
  echo -e "${CYAN}$L_SEARCHING${WHT}${query}${RESET}" >&2
  yt-dlp --no-warnings -j --flat-playlist "ytsearch${count}:${query}" > "$TMPDIR/list.json" 2>"$TMPDIR/err.log" &
  local pid=$!
  spinner "Searching..." $pid
  wait $pid
  if [ ! -s "$TMPDIR/list.json" ]; then
    echo -e "${RED}$L_NOT_FOUND${RESET}" >&2
    return 1
  fi
  echo "$TMPDIR/list.json"
}

parse_list() {
  local list="$1"
  local -n _ids=$2
  local -n _titles=$3
  local -n _durs=$4
  _ids=(); _titles=(); _durs=()
  local id title dur
  while IFS=$'\t' read -r id title dur; do
    [ -z "$id" ] && continue
    _ids+=("$id")
    _titles+=("$title")
    _durs+=("$dur")
  done < <(jq -r 'select(.id != null and .title != null) | [.id, .title, (.duration // -1)] | @tsv' "$list" 2>/dev/null)
}

shuffle_arrays() {
  local -n a1=$1
  local -n a2=$2
  local -n a3=$3
  local n=${#a1[@]}
  local i j t1 t2 t3
  for ((i=n-1; i>0; i--)); do
    j=$((RANDOM % (i+1)))
    t1="${a1[i]}"; a1[i]="${a1[j]}"; a1[j]="$t1"
    t2="${a2[i]}"; a2[i]="${a2[j]}"; a2[j]="$t2"
    t3="${a3[i]}"; a3[i]="${a3[j]}"; a3[j]="$t3"
  done
}

is_full_album() {
  local dur="$1" title_lc="$2"
  [[ "$dur" =~ ^[0-9]+$ ]] && [ "$dur" -gt 900 ] && return 0
  [[ "$title_lc" == *"full album"* || "$title_lc" == *"compilation"* || \
     "$title_lc" == *"mixtape"* || "$title_lc" == *"megamix"* || \
     "$title_lc" == *"full playlist"* || "$title_lc" == *"greatest hits"* ]] && return 0
  return 1
}

filter_full_album() {
  local -n in_ids=$1 in_titles=$2 in_durs=$3
  local -n out_ids=$4 out_titles=$5 out_durs=$6
  out_ids=(); out_titles=(); out_durs=()
  local i ttl_lc
  for ((i=0; i<${#in_ids[@]}; i++)); do
    ttl_lc=$(tr '[:upper:]' '[:lower:]' <<< "${in_titles[$i]}")
    is_full_album "${in_durs[$i]}" "$ttl_lc" && continue
    out_ids+=("${in_ids[$i]}")
    out_titles+=("${in_titles[$i]}")
    out_durs+=("${in_durs[$i]}")
  done
  if [ "${#out_ids[@]}" -eq 0 ] && [ "${#in_ids[@]}" -gt 0 ]; then
    out_ids=("${in_ids[@]}")
    out_titles=("${in_titles[@]}")
    out_durs=("${in_durs[@]}")
  fi
}

draw_bar() {
  local elapsed=$1 total=$2 title="$3" artist="$4" extra="$5" paused="$6" nexttitle="$7"
  [ "$total" -le 0 ] && total=1
  [ "$elapsed" -gt "$total" ] && elapsed=$total

  local barw=28
  local percent=$(( elapsed * 100 / total ))
  local filled=$(( barw * elapsed / total ))
  local empty=$(( barw - filled ))
  local bar
  bar=$(printf '█%.0s' $(seq 1 $filled) 2>/dev/null)
  bar+=$(printf '░%.0s' $(seq 1 $empty) 2>/dev/null)

  local chars=(▂ ▄ ▆ █) vu="" k lv delta vucolor
  for ((k=0; k<10; k++)); do
    if [ "$paused" -eq 1 ]; then
      lv=0
    else
      delta=$(( (RANDOM % 3) - 1 ))
      lv=$(( ${VU_LEVELS[$k]:-0} + delta ))
      [ "$lv" -lt 0 ] && lv=0
      [ "$lv" -gt 3 ] && lv=3
    fi
    VU_LEVELS[$k]=$lv
    if [ "$lv" -le 1 ]; then
      vucolor="${GRN}"
    elif [ "$lv" -eq 2 ]; then
      vucolor="${YEL}"
    else
      vucolor="${RED}"
    fi
    vu+="${vucolor}${chars[$lv]}"
  done
  vu+="${RESET}"

  local ttl="$title"
  [ -n "$artist" ] && [ "$artist" != "-" ] && ttl="$title — $artist"
  [ ${#ttl} -gt $((WIDTH-4)) ] && ttl="${ttl:0:$((WIDTH-7))}..."

  local icon="▶"
  [ "$paused" -eq 1 ] && icon="⏸"
  local rep=""
  [ "$REPEAT" -eq 1 ] && rep=" 🔁"

  local label="$L_PLAYING"
  local llen=${#label}
  local side=$(( (WIDTH-llen)/2 ))
  local rside=$((WIDTH-llen-side))
  local dash_l=$(printf '─%.0s' $(seq 1 $side))
  local dash_r=$(printf '─%.0s' $(seq 1 $rside))
  local rule=$(printf '─%.0s' $(seq 1 $WIDTH))

  local nt=""
  if [ -n "$nexttitle" ]; then
    nt="$nexttitle"
    [ ${#nt} -gt $((WIDTH-14)) ] && nt="${nt:0:$((WIDTH-17))}..."
  fi

  printf "\033[K${BLU}%s${RESET}${YEL}${BOLD}%s${RESET}${BLU}%s${RESET}\n" "$dash_l" "$label" "$dash_r"
  printf "\033[K${MAG}%s${RESET} ${BOLD}${WHT}%s${RESET}${YEL}%s${RESET}\n" "$icon" "$ttl" "$rep"
  printf "\033[K%b  ${DIM}%s${RESET}\n" "$vu" "$extra"
  printf "\033[K${GRN}%s${RESET} ${CYAN}[%s]${RESET} ${GRN}%s${RESET}  ${YEL}%3d%%${RESET}\n" \
    "$(fmt_time $elapsed)" "$bar" "$(fmt_time $total)" "$percent"
  printf "\033[K${DIM}%s${RESET}\n" "$L_PLAYER_CONTROLS"
  if [ -n "$nt" ]; then
    printf "\033[K${DIM}%s${RESET}${WHT}%s${RESET}\n" "$L_NEXT_TRACK" "$nt"
  else
    printf "\033[K\n"
  fi
  printf "\033[K${BLU}%s${RESET}\n" "$rule"
}

play_track_once() {
  local vid="$1" title="$2" artist="$3" idx="$4" total_tracks="$5" nexttitle="$6"

  local dur
  dur=$(yt-dlp --no-warnings --print "%(duration)s" "https://www.youtube.com/watch?v=${vid}" 2>/dev/null)
  [[ "$dur" =~ ^[0-9]+$ ]] || dur=0

  mpv --no-video --really-quiet --no-terminal \
      --cache=yes --cache-secs=60 --demuxer-max-bytes=64MiB --demuxer-readahead-secs=30 \
      "https://www.youtube.com/watch?v=${vid}" >"$TMPDIR/mpv.log" 2>&1 &
  MPV_PID=$!
  log_history "$title" "$artist"

  local extra=""
  [ -n "$total_tracks" ] && [ "$total_tracks" -gt 1 ] && extra=$(printf "$L_TRACK_INFO" "$idx" "$total_tracks")

  echo
  VU_LEVELS=(0 0 0 0 0 0 0 0 0 0)

  local first_draw=1
  local start_epoch=$(date +%s)
  local total_paused=0
  local pause_start=0
  local paused=0
  local key=""

  while kill -0 "$MPV_PID" 2>/dev/null; do
    if [ "$first_draw" -eq 1 ]; then
      first_draw=0
    else
      printf "\033[7A"
    fi

    local now_epoch=$(date +%s)
    local elapsed
    if [ "$paused" -eq 1 ]; then
      local paused_now=$((now_epoch - pause_start))
      elapsed=$((now_epoch - start_epoch - total_paused - paused_now))
    else
      elapsed=$((now_epoch - start_epoch - total_paused))
    fi
    [ "$elapsed" -gt "$dur" ] && elapsed=$dur
    [ "$elapsed" -lt 0 ] && elapsed=0

    draw_bar "$elapsed" "$dur" "$title" "$artist" "$extra" "$paused" "$nexttitle"

    if read -t 0.5 -n 1 key; then
      case "$key" in
        n|N) kill -CONT "$MPV_PID" 2>/dev/null; kill "$MPV_PID" 2>/dev/null; MPV_PID=""
             printf "\n${YEL}$L_SKIPPED${RESET}\n"; sleep 0.4; return 2 ;;
        q|Q) kill -CONT "$MPV_PID" 2>/dev/null; kill "$MPV_PID" 2>/dev/null; MPV_PID=""
             printf "\n${RED}$L_STOPPED${RESET}\n"; sleep 0.4; return 1 ;;
        p|P)
             if [ "$paused" -eq 0 ]; then
                 kill -STOP "$MPV_PID" 2>/dev/null
                 paused=1
                 pause_start=$(date +%s)
             else
                 kill -CONT "$MPV_PID" 2>/dev/null
                 paused=0
                 total_paused=$((total_paused + $(date +%s) - pause_start))
             fi ;;
        r|R) [ "$REPEAT" -eq 0 ] && REPEAT=1 || REPEAT=0 ;;
      esac
    fi
  done

  MPV_PID=""
  if [ "$first_draw" -eq 0 ]; then
      printf "\033[7A"
      draw_bar "$dur" "$dur" "$title" "$artist" "$extra" 0 "$nexttitle"
  fi
  printf "\n${GRN}$L_FINISHED${RESET}\n"
  sleep 0.3
  return 0
}

play_track() {
  while true; do
    play_track_once "$@"
    local rc=$?
    if [ "$rc" -eq 0 ] && [ "$REPEAT" -eq 1 ]; then
      continue
    fi
    return $rc
  done
}

mode_random() {
  local total="${1:-8}"
  local n=${#RANDOM_SONGS[@]}
  [ "$total" -gt "$n" ] && total=$n

  local indices=() i j tmp
  for ((i=0; i<n; i++)); do indices+=("$i"); done
  for ((i=n-1; i>0; i--)); do
    j=$((RANDOM % (i+1)))
    tmp="${indices[i]}"; indices[i]="${indices[j]}"; indices[j]="$tmp"
  done

  clear; banner
  printf "${MAG}$L_RAND_PREP${RESET}\n" "$total"

  local ids=() titles=()
  local k query list lids ltitles ldurs pick d ttl_lc
  for ((k=0; k<total; k++)); do
    query="${RANDOM_SONGS[${indices[$k]}]}"
    list=$(search_yt "$query" 5) || continue
    parse_list "$list" lids ltitles ldurs
    [ "${#lids[@]}" -eq 0 ] && continue

    local f_ids f_titles f_durs
    filter_full_album lids ltitles ldurs f_ids f_titles f_durs

    if [ "${#f_ids[@]}" -gt 0 ]; then
        ids+=("${f_ids[0]}")
        titles+=("${f_titles[0]}")
    fi
  done

  local found=${#ids[@]}
  if [ "$found" -eq 0 ]; then
    echo -e "${RED}$L_RAND_FAIL${RESET}"; sleep 1; return
  fi

  printf "${GRN}$L_RAND_READY${RESET}\n" "$found"
  sleep 1

  local nt
  for ((k=0; k<found; k++)); do
    nt=""
    [ $((k+1)) -lt "$found" ] && nt="${titles[$((k+1))]}"
    clear; banner
    play_track "${ids[$k]}" "${titles[$k]}" "Mix" "$((k+1))" "$found" "$nt"
    [ $? -eq 1 ] && break
  done
}

mode_single() {
  local query="$1"
  local list
  list=$(search_yt "$query" 5) || { read -n1 -r -p "$(printf "${DIM}$L_PRESS_ENTER${RESET}")"; return; }

  local ids titles durs
  parse_list "$list" ids titles durs
  local n=${#ids[@]}
  if [ "$n" -eq 0 ]; then
    echo -e "${RED}$L_EMPTY_QUERY${RESET}"; sleep 1; return
  fi

  clear; banner
  box_top
  box_line "🔎 $L_SEARCHING" "$YEL$BOLD"
  box_bottom
  local i label d ttl_lc
  for ((i=0; i<n; i++)); do
    label="[$((i+1))] ${titles[$i]}"
    d="${durs[$i]}"
    ttl_lc=$(tr '[:upper:]' '[:lower:]' <<< "${titles[$i]}")
    if [[ "$d" =~ ^[0-9]+$ ]]; then
      label="$label ($(fmt_time "$d"))"
    fi
    if [[ "$d" =~ ^[0-9]+$ ]] && [ "$d" -gt 900 ]; then
      label="$label $L_WARN_FULL"
    elif [[ "$ttl_lc" == *"full album"* || "$ttl_lc" == *"compilation"* || "$ttl_lc" == *"mixtape"* || "$ttl_lc" == *"megamix"* ]]; then
      label="$label $L_WARN_FULL"
    fi
    box_line_left "$label" "$WHT"
  done
  box_bottom
  echo
  printf "${CYAN}$L_SELECT_NUM${RESET}"
  read -r choice
  [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "$n" ] || choice=1
  local idx=$((choice-1))

  clear; banner
  play_track "${ids[$idx]}" "${titles[$idx]}" "-" "1" "1" ""
}

mode_band() {
  local query="$1"
  local list
  list=$(search_yt "$query" 15) || { read -n1 -r -p "$(printf "${DIM}$L_PRESS_ENTER${RESET}")"; return; }

  local ids titles durs
  parse_list "$list" ids titles durs
  local n=${#ids[@]}
  if [ "$n" -eq 0 ]; then
    echo -e "${RED}$L_EMPTY_QUERY${RESET}"; sleep 1; return
  fi

  local f_ids f_titles f_durs
  filter_full_album ids titles durs f_ids f_titles f_durs
  ids=("${f_ids[@]}")
  titles=("${f_titles[@]}")
  durs=("${f_durs[@]}")
  n=${#ids[@]}

  printf "${YEL}$L_SHUFFLE_PROMPT${RESET}"
  read -r shuf_ans
  if [[ "$shuf_ans" =~ ^[Yy]$ ]]; then
    shuffle_arrays ids titles durs
  fi

  printf "${GRN}$L_FOUND_BAND${RESET}\n" "$n" "$query"
  sleep 1

  local k next_title
  for ((k=0; k<n; k++)); do
    next_title=""
    [ $((k+1)) -lt "$n" ] && next_title="${titles[$((k+1))]}"
    clear; banner
    play_track "${ids[$k]}" "${titles[$k]}" "$query" "$((k+1))" "$n" "$next_title"
    [ $? -eq 1 ] && break
  done
}

main_menu() {
  while true; do
    banner
    center "$L_MENU_TITLE" "$WHT"
    center "$L_MENU_SUB" "$DIM$WHT"
    echo
    printf "${CYAN}$L_MENU_PROMPT${RESET}"
    read -r query
    [ -z "$query" ] && continue

    case "$query" in
      exit|keluar) exit 0 ;;
      riwayat|history) show_history; continue ;;
      bantuan|help) show_help; continue ;;
      lang|bahasa|language) choose_language; continue ;;
      random|rnd|acak)
        printf "${YEL}$L_RAND_COUNT${RESET}"
        read -r cnt
        [[ "$cnt" =~ ^[0-9]+$ ]] && [ "$cnt" -ge 1 ] || cnt=8
        mode_random "$cnt"
        continue ;;
    esac

    echo
    printf "${YEL}$L_MODE_PROMPT${RESET}\n"
    printf "${CYAN}$L_MODE_INPUT${RESET}"
    read -r mode

    case "$mode" in
      2) mode_band "$query" ;;
      *) mode_single "$query" ;;
    esac
  done
}

check_deps
acquire_wakelock

if [ -f "$CONFIG_FILE" ]; then
  source "$CONFIG_FILE"
fi
if [ -z "$ELL_LANG" ]; then
  choose_language
fi
set_translations

boot_intro
main_menu
