#!/bin/bash

echo "🚀 Memulai Setup 0G Storage Node..."

# Update sistem
sudo apt update && sudo apt upgrade -y

# Install dependensi
sudo apt install -y curl wget git build-essential pkg-config libssl-dev

# Install Rust (jika belum ada)
if ! command -v rustc &> /dev/null
then
    echo "⚙️ Menginstal Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "✅ Rust sudah terinstal"
fi

# Clone source code node
if [ ! -d "$HOME/0g-storage-node" ]; then
    echo "📥 Mengunduh source code 0G Storage Node..."
    git clone https://github.com/0glabs/0g-storage-node.git $HOME/0g-storage-node
else
    echo "✅ Source code sudah ada"
fi

# Build node
cd $HOME/0g-storage-node
cargo build --release

# Buat file systemd service
echo "📝 Membuat service systemd..."

sudo bash -c 'cat > /etc/systemd/system/zgs_node.service <<EOF
[Unit]
Description=0G Storage Node
After=network.target

[Service]
User='$USER'
ExecStart='$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config-testnet-turbo.toml'
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd dan enable service
sudo systemctl daemon-reload
sudo systemctl enable zgs_node
sudo systemctl start zgs_node

echo "🎉 Setup selesai! Gunakan 'systemctl status zgs_node' untuk melihat status node."
