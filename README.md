# Music Player

Termux music player — yt-dlp + mpv.

## Instalasi

Setup awal :
pkg update && pkg upgrade -y
pkg update && pkg install -y yt-dlp mpv ffmpeg jq
termux-setup-storage

Download Script & jalankan:
cp ~/storage/downloads/ellmusic.sh
bash ~/ellmusic.sh

## Perintah

[nama lagu] - cari lagu
[nama band] - cari discography
random - lagu random
riwayat - history
bantuan - help
bahasa - ganti bahasa
exit - keluar

Player: p pause, r repeat, n next, q stop

## Troubleshooting

Error "command not found" -> pkg install -y yt-dlp mpv ffmpeg jq
Lagu putus-putus -> pkg install -y termux-api
yt-dlp error -> pip install --upgrade yt-dlp

diperlukan:

TERMUX
https://f-droid.org/id/packages/com.termux/
TERMUX:api
https://f-droid.org/id/packages/com.termux.api/

jangan download dari playstore atau AppStore
karena sudah di versi lama

## Lisensi

CC BY-NC-SA 4.0 - dilarang jual, wajib credit.

👤Author: 
@smallchild_raff03 (IG)
@ELL-STORE (GitHub)
@darkprime46 (TikTok)

(English)
# Music Player

Termux music player — yt-dlp + mpv.

## Installation

Initial setup:
pkg update && pkg upgrade -y
pkg install -y yt-dlp mpv ffmpeg jq termux-api
termux-setup-storage

Download Script & run:
cp ~/storage/downloads/ellmusic.sh
bash ~/ellmusic.sh

## Commands
`[song name]` - search for a song
`[band name]` - search discography
`random` - random song
`riwayat` - history
`bantuan` - help
`bahasa` - change language
`exit` - exit

Player: `p` pause, `r` repeat, `n` next, `q` stop

*Requirements:*

*TERMUX*
https://f-droid.org/packages/com.termux/
*TERMUX:API*
https://f-droid.org/packages/com.termux.api/

Do not download from Play Store or App Store
as they are outdated versions

## Troubleshooting

Error "command not found" -> `pkg install -y yt-dlp mpv ffmpeg jq`
Laggy / choppy audio -> `pkg install -y termux-api`
yt-dlp error -> `pip install --upgrade yt-dlp`

## License

CC BY-NC-SA 4.0 - commercial use prohibited, credit required.

👤 Author:
@smallchild_raff03 (IG)
@ELL-STORE (GitHub)
@darkprime46 (TikTok)
