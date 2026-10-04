#!/bin/bash
set -e

# ==========================================================
# AXILive - Unified Installer & Auto-Updater Script
# ==========================================================

# Konfigurasi Repository GitHub
GITHUB_REPO="${GITHUB_REPO:-BegenkNewbie/AXILive}"
BINARY_NAME="AXILive"
INSTALL_DIR="/usr/local/bin"
SERVICE_NAME="AXILive.service"
SERVICE_PATH="/etc/systemd/system/${SERVICE_NAME}"

# Warna untuk output terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}       AXILive Setup / Update Tool      ${NC}"
echo -e "${BLUE}========================================${NC}"

# 1. Pastikan dijalankan sebagai root / sudo
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[ERROR] Script ini harus dijalankan sebagai root (gunakan sudo).${NC}"
    exit 1
fi

# 2. Tentukan URL binary: argumen manual (jika ada) atau GitHub Releases latest
if [ -n "$1" ]; then
    DOWNLOAD_URL="$1"
    echo -e "${YELLOW}[INFO] Menggunakan URL custom: ${DOWNLOAD_URL}${NC}"
else
    DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/latest/download/${BINARY_NAME}"
    echo -e "${BLUE}[INFO] Mengunduh versi terbaru dari GitHub: ${GITHUB_REPO}${NC}"
fi

# 3. Pastikan dependencies terpasang
MISSING_DEPS=()
if ! command -v curl &> /dev/null; then
    MISSING_DEPS+=("curl")
fi
if ! command -v ffmpeg &> /dev/null; then
    MISSING_DEPS+=("ffmpeg")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo -e "${YELLOW}[INFO] Menginstall dependencies: ${MISSING_DEPS[*]}...${NC}"
    apt update -y && apt install -y "${MISSING_DEPS[@]}"
fi

# 4. Hentikan service jika sedang berjalan (agar binary tidak berstatus 'Text file busy')
IS_UPDATING=false
if systemctl is-active --quiet "${SERVICE_NAME}" 2>/dev/null; then
    IS_UPDATING=true
    echo -e "${YELLOW}[INFO] Mendeteksi AXILive sedang berjalan. Menghentikan service untuk update...${NC}"
    systemctl stop "${SERVICE_NAME}"
elif [ -f "${INSTALL_DIR}/${BINARY_NAME}" ]; then
    IS_UPDATING=true
    echo -e "${YELLOW}[INFO] Binary lama ditemukan. Mempersiapkan update...${NC}"
fi

# 5. Unduh binary baru ke file sementara terlebih dahulu
echo -e "${BLUE}[INFO] Mengunduh binary ${BINARY_NAME}...${NC}"
mkdir -p "${INSTALL_DIR}"
TMP_FILE="${INSTALL_DIR}/${BINARY_NAME}.tmp"

HTTP_CODE=$(curl -sSL -w "%{http_code}" -o "${TMP_FILE}" "${DOWNLOAD_URL}")

if [ "${HTTP_CODE}" -ne 200 ] && [ "${HTTP_CODE}" -ne 302 ]; then
    echo -e "${RED}[ERROR] Gagal mengunduh binary (HTTP Status: ${HTTP_CODE}).${NC}"
    echo -e "${RED}Pastikan release binary '${BINARY_NAME}' sudah diunggah di GitHub Releases: https://github.com/${GITHUB_REPO}/releases${NC}"
    rm -f "${TMP_FILE}"
    if [ "$IS_UPDATING" = true ]; then
        echo -e "${YELLOW}[INFO] Memulai kembali service sebelumnya...${NC}"
        systemctl start "${SERVICE_NAME}" || true
    fi
    exit 1
fi

chmod +x "${TMP_FILE}"
mv -f "${TMP_FILE}" "${INSTALL_DIR}/${BINARY_NAME}"

# 6. Buat / perbarui file service systemd
echo -e "${BLUE}[INFO] Menyiapkan systemd service...${NC}"
cat <<EOF > "${SERVICE_PATH}"
[Unit]
Description=AXILive Streaming Service
After=network.target

[Service]
ExecStart=${INSTALL_DIR}/${BINARY_NAME}
WorkingDirectory=${INSTALL_DIR}
Restart=always
RestartSec=5
User=root
Environment=ENV=production
LimitCPU=infinity

[Install]
WantedBy=multi-user.target
EOF

# 7. Buat shortcut 'axilive-update' agar user di server mudah melakukan update di masa depan
cat <<EOF > /usr/local/bin/axilive-update
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/${GITHUB_REPO}/main/bin/install.sh | bash -s -- "\$@"
EOF
chmod +x /usr/local/bin/axilive-update

# 8. Reload systemd dan aktifkan/jalankan service
systemctl daemon-reload
systemctl enable "${SERVICE_NAME}"
systemctl restart "${SERVICE_NAME}"

echo -e "${GREEN}========================================${NC}"
if [ "$IS_UPDATING" = true ]; then
    echo -e "${GREEN}✓ Update AXILive berhasil diselesaikan!${NC}"
else
    echo -e "${GREEN}✓ Instalasi AXILive berhasil diselesaikan!${NC}"
fi
echo -e "${GREEN}✓ Service AXILive sekarang aktif dan berjalan.${NC}"
echo -e "${BLUE}Tips: Di masa depan, untuk update cukup ketik: ${YELLOW}axilive-update${NC}"
echo -e "${GREEN}========================================${NC}"