# AXILive Server Installation & Specifications

Petunjuk instalasi, pembaruan, dan rekomendasi spesifikasi VPS Linux untuk menjalankan **AXILive Streaming Service**.

---

## 🖥️ Rekomendasi Spesifikasi VPS Linux

Penggunaan FFmpeg dan streaming video membutuhkan performa CPU, RAM, dan I/O disk yang stabil. Berikut adalah panduan spesifikasi server:

| Komponen | Rekomendasi Spesifikasi (Optimal) | Minimum Spesifikasi |
|---|---|---|
| **CPU** | **6 Core vCPU** (AMD EPYC / Intel Xeon terbaru) | 4 Core vCPU |
| **RAM** | **12 GB** (DDR4 / DDR5) | 8 GB |
| **Storage** | **100 GB NVMe SSD** (High IOPS untuk video buffer & aset) | 50 GB SSD |
| **Network** | **1 Gbps Port** (Bandwidth min. 5 TB / Unmetered) | 1 Gbps (min. 2 TB/bln) |
| **Lokasi** | **US Central / US West** (Los Angeles, Dallas, Oregon, Silicon Valley) | US / Dekat target ingest stream |
| **OS** | Ubuntu 22.04 / 24.04 LTS atau Debian 12 (64-bit) | Ubuntu 20.04 LTS+ |

### Kenapa Spesifikasi Ini Direkomendasikan?
1. **CPU 6 Core**: Mampu menangani multi-stream concurrent, encoding/transcoding video resolusi 1080p, dan pemrosesan intro chromakey secara lancar tanpa frame drop.
2. **RAM 12 GB**: Memberikan ruang buffer memori yang sangat aman untuk proses FFmpeg, sistem antrean, dan mencegah resiko OOM (*Out Of Memory*).
3. **Storage 100 GB NVMe**: NVMe memiliki kecepatan baca-tulis ribuan MB/s yang memastikan proses download aset, segmentasi video (HLS/DASH/RTMP), dan caching tidak mengalami bottleneck I/O disk.
4. **Lokasi US (Central/West)**: Server ingest streaming platform besar (YouTube Live, TikTok Live, Twitch, Kick, Facebook) memiliki peering jaringan dan backbone tercepat di region Amerika Serikat (US Central & US West).

### Rekomendasi Provider VPS:
- **Hetzner Cloud** (CPX41 / CCX23 - Region Hillsboro / Ashburn US)
- **Vultr** (High Performance AMD / Intel - Region Los Angeles / Dallas / Silicon Valley)
- **Contabo** (Cloud VPS - Region US Central / West)
- **DigitalOcean** (Premium Droplets - Region SFO / NYC)

---

## 🚀 Quick Install (One-Liner)

Jalankan perintah ini di terminal server VPS Linux (Ubuntu / Debian):

```bash
curl -fsSL https://raw.githubusercontent.com/BegenkNewbie/AXILive/main/bin/install.sh | sudo bash
```

Perintah di atas akan otomatis:
1. Memeriksa dan menginstall dependensi (`curl`, `ffmpeg`).
2. Mengunduh binary rilis terbaru `AXILive` dari [GitHub Releases](https://github.com/BegenkNewbie/AXILive/releases).
3. Membuat dan mengaktifkan service systemd (`AXILive.service`).
4. Mendaftarkan shortcut perintah update `axilive-update`.

---

## 🔄 Pembaruan (Update)

Setelah terinstall, untuk memperbarui ke versi terbaru di kemudian hari, cukup jalankan:

```bash
sudo axilive-update
```

---

## ⚙️ Manajemen Service

Untuk mengecek status atau mengelola service AXILive:

```bash
# Cek status service
sudo systemctl status AXILive

# Restart service
sudo systemctl restart AXILive

# Hentikan service
sudo systemctl stop AXILive

# Jalankan service
sudo systemctl start AXILive

# Melihat live log service
sudo journalctl -u AXILive -f
```
