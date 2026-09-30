# 🎵 Music Player

A lightweight Termux-based music player powered by **yt-dlp** and **mpv**.

This project allows you to search and play music directly from the terminal on Android using Termux.

---

## 🇮🇩 Bahasa Indonesia

### Deskripsi

Termux music player — **yt-dlp + mpv**.

### Persyaratan

Pastikan aplikasi berikut sudah terinstall dari **F-Droid**:

- **[Termux](https://f-droid.org/id/packages/com.termux/)**
- **[Termux:API](https://f-droid.org/id/packages/com.termux.api/)**

> Jangan download dari Play Store atau App Store karena versi yang tersedia sudah usang.

### Instalasi

#### Setup Awal

```bash
pkg update && pkg upgrade -y
pkg update && pkg install -y yt-dlp mpv ffmpeg jq
termux-setup-storage
```

#### Download Script dan Jalankan

```bash
cp ~/storage/downloads/ellmusic.sh
bash ~/ellmusic.sh
```

### Perintah

| Perintah | Fungsi |
|----------|--------|
| `[nama lagu]` | Cari lagu |
| `[nama band]` | Cari discography |
| `random` | Putar lagu acak |
| `riwayat` | Lihat riwayat |
| `bantuan` | Tampilkan bantuan |
| `bahasa` | Ganti bahasa |
| `exit` | Keluar dari aplikasi |

### Kontrol Pemutar

| Tombol | Aksi |
|--------|------|
| `p` | Pause / lanjut |
| `r` | Repeat |
| `n` | Lagu berikutnya |
| `q` | Stop |

### Troubleshooting

| Masalah | Solusi |
|---------|--------|
| Error `command not found` | `pkg install -y yt-dlp mpv ffmpeg jq` |
| Lagu putus-putus | `pkg install -y termux-api` |
| Error pada `yt-dlp` | `pip install --upgrade yt-dlp` |

---

## 🇬🇧 English

### Overview

Termux music player — **yt-dlp + mpv**.

### Requirements

Make sure the following apps are installed through **F-Droid**:

- **[Termux](https://f-droid.org/packages/com.termux/)**
- **[Termux:API](https://f-droid.org/packages/com.termux.api/)**

> Do not install from the Play Store or App Store, as those versions are outdated.

### Installation

#### Initial Setup

```bash
pkg update && pkg upgrade -y
pkg update && pkg install -y yt-dlp mpv ffmpeg jq
termux-setup-storage
```

#### Download Script and Run

```bash
cp ~/storage/downloads/ellmusic.sh
bash ~/ellmusic.sh
```

### Commands

| Command | Description |
|---------|-------------|
| `[song name]` | Search for a song |
| `[band name]` | Search discography |
| `random` | Play a random song |
| `riwayat` | View history |
| `bantuan` | Show help |
| `bahasa` | Change language |
| `exit` | Exit the app |

### Player Controls

| Key | Action |
|-----|--------|
| `p` | Pause / resume |
| `r` | Repeat |
| `n` | Next track |
| `q` | Stop |

### Troubleshooting

| Issue | Fix |
|-------|-----|
| `command not found` error | `pkg install -y yt-dlp mpv ffmpeg jq` |
| Laggy / choppy audio | `pkg install -y termux-api` |
| `yt-dlp` error | `pip install --upgrade yt-dlp` |

---

## 📜 License

This project is licensed under **CC BY-NC-SA 4.0**.

- Commercial use is prohibited.
- Credit is required.

---

## 👤 Author

- **Instagram:** [@smallchild_raff03](https://instagram.com/smallchild_raff03)
- **GitHub:** [@ELL-STORE](https://github.com/ELL-STORE)
- **TikTok:** [@darkprime46](https://tiktok.com/@darkprime46)

---
