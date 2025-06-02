# Cloudflare DNS Switcher

A simplified fork of [onedns](https://github.com/BDadmehr0/onedns) — uses only [Cloudflare DNS](https://1.1.1.1) for speed, privacy, and simplicity.

## Features
- One-click switch to Cloudflare DNS (1.1.1.1 & 1.0.0.1)
- Backup and restore original DNS configuration
- Safe, lightweight, and easy-to-use terminal UI
- Works system-wide (requires root)

## Installation

```bash
git clone https://github.com/karanveers969/cloudflare-dns-switcher.git
cd cloudflare-dns-switcher
chmod +x onedns.sh
```

## Usage

Run the script with root permissions:

```bash
sudo ./onedns.sh
```

You’ll see a menu:

- `1` → Apply Cloudflare DNS (1.1.1.1 / 1.0.0.1)
- `6` → Show current DNS configuration
- `7` → Restore original DNS (from backup)
- `9` → Uninstall OneDNS from your system
- `00` → Exit the script

📌 Make sure you're connected to the internet before applying DNS.

## Uninstallation

Run the script again and select option `9` from the menu to remove OneDNS and its backup file.

## Credits

Forked from [onedns](https://github.com/BDadmehr0/onedns) by [BDadmehr0](https://github.com/BDadmehr0)

## License

MIT License
