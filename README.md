# This distribution is made exclusively for entertainment purposes.
## HOS - Hentai Operating System

Custom Linux distribution based on Alpine Linux.

## Quick Start

```bash
# 1. Clone repository
git clone https://github.com/Sskame1/HOS.git
cd HOS

# 2. Install tools (as root)
sudo ./scripts/installer.sh

# 3. Make system changes and save
hos-snapshot

# 4. Commit and push
git add .
git commit -m "description"
git push

# 5. Build ISO (on any Alpine system)
./scripts/build-iso.sh