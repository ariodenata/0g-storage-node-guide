# 0G Storage Node Guide

Panduan lengkap untuk menjalankan 0G Storage Node di Ubuntu (WSL di Windows).

## 📌 Cara Menggunakan

1. Clone repository ini:
   ```bash
   git clone https://github.com/ariodenata/0g-storage-node-guide.git
   cd 0g-storage-node-guide
ATAU pakai cara di bawah ini: 

---

# **Panduan Menjalankan 0G Storage Node**

Panduan ini akan membantu kamu dalam menjalankan **0G Storage Node** di sistem **Ubuntu LTS** (di WSL atau server Linux).  

## **1. Persiapan Lingkungan**

### **Update Sistem & Install Dependensi**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget git build-essential pkg-config libssl-dev
```

### **Install Rust**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

Pastikan Rust sudah terinstall:
```bash
rustc --version
cargo --version
```

---

## **2. Clone Repository & Build Node**
Clone repository node:
```bash
git clone https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
```

Build node:
```bash
cargo build --release
```

---

## **3. Menjalankan Node Secara Manual**
```bash
./target/release/zgs_node --config run/config-testnet-turbo.toml
```

Jika berjalan dengan baik, node akan mulai memproses transaksi dan mencetak log.

---

## **4. Otomatisasi dengan systemd**
Agar node berjalan otomatis saat booting, buat file service:
```bash
sudo nano /etc/systemd/system/zgs_node.service
```

Isi dengan:
```ini
[Unit]
Description=0G Storage Node
After=network.target

[Service]
User=kimura
ExecStart=/home/kimura/0g-storage-node/target/release/zgs_node --config /home/kimura/0g-storage-node/run/config-testnet-turbo.toml
Restart=always
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
```

Simpan dengan **CTRL + X**, lalu **Y** dan **ENTER**.

Aktifkan service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable zgs_node
sudo systemctl start zgs_node
```

Cek status node:
```bash
systemctl status zgs_node
```

---

## **5. Memeriksa Status Node**
Cek apakah node berjalan:
```bash
ps aux | grep zgs_node
```

Cek log node:
```bash
tail -f /home/kimura/0g-storage-node/run/log/zgs.log
```

---

## **6. Troubleshooting**
Jika ada masalah, coba restart node:
```bash
sudo systemctl restart zgs_node
```

Jika gagal, cek log error:
```bash
journalctl -u zgs_node -n 50 --no-pager
```

Jika ingin menghapus node:
```bash
sudo systemctl stop zgs_node
sudo systemctl disable zgs_node
sudo rm /etc/systemd/system/zgs_node.service
```

---

## **7. Pembaruan Node**
Untuk memperbarui node ke versi terbaru:
```bash
cd ~/0g-storage-node
git pull origin main
cargo build --release
sudo systemctl restart zgs_node
```

---

### **Selesai! 🎉**  
Sekarang **0G Storage Node** kamu berjalan secara otomatis dan siap digunakan.

---
