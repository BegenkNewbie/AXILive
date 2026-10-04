# AXILive

AXILive Streaming Service installer & updater.

## Installation

Untuk menginstall AXILive di VPS / server Linux (Ubuntu/Debian):

```bash
curl -fsSL https://raw.githubusercontent.com/BegenkNewbie/AXILive/main/bin/install.sh | sudo bash
```

Perintah di atas akan otomatis:
- Memasang dependensi yang dibutuhkan (`curl`, `ffmpeg`)
- Mengunduh binary rilis terbaru dari [GitHub Releases](https://github.com/BegenkNewbie/AXILive/releases)
- Mengonfigurasi dan menyalakan systemd service `AXILive.service`

## Update

Untuk memperbarui ke versi terbaru di masa depan, cukup jalankan:

```bash
sudo axilive-update
```
