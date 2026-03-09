# ============================================================
# ATLAS-ARM64 macOS APP + DMG BUILD STEPS
# Target: Apple Silicon Mac (M1/M2/M3/M4)
# Folder name: ATLAS-ARM64
# ============================================================

# 1) Go to your project folder
cd ~/ec2-user/ATLAS-ARM64

# If needed, verify location:
pwd
ls

# You should see files like:
# app
# launcher_desktop.py
# main.py
# requirements.txt
# schema.sql
# ATLAS-ARM64.spec

# 2) Check Homebrew
brew --version

# If brew is not installed, install it:
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3) Install Python 3.11
brew install python@3.11

# 4) Make sure Python 3.11 works
python3.11 --version

# If python3.11 is not found, run:
# echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zprofile
# source ~/.zprofile
# python3.11 --version

# 5) Create virtual environment
python3.11 -m venv venv

# 6) Activate it
source venv/bin/activate

# 7) Upgrade packaging tools
python -m pip install --upgrade pip setuptools wheel

# 8) Install project requirements
pip install -r requirements.txt

# 9) Install PyInstaller
pip install pyinstaller==6.3.0

# 10) Install create-dmg for DMG packaging
brew install create-dmg

# 11) Clean old builds
rm -rf build dist

# 12) Build the macOS app
pyinstaller --clean --noconfirm ATLAS-ARM64.spec

# 13) Confirm app exists
ls dist

# Expected:
# ATLAS-ARM64.app

# 14) Test launch
open dist/ATLAS-ARM64.app

# If macOS blocks it first time:
# System Settings -> Privacy & Security -> Open Anyway

# 15) Move into dist folder
cd dist

# 16) Create ZIP package for sharing
ditto -c -k --sequesterRsrc --keepParent "ATLAS-ARM64.app" "ATLAS-ARM64.zip"

# 17) Create DMG package
create-dmg \
  --volname "ATLAS-ARM64" \
  --window-pos 200 120 \
  --window-size 800 420 \
  --icon-size 120 \
  --icon "ATLAS-ARM64.app" 200 190 \
  --hide-extension "ATLAS-ARM64.app" \
  --app-drop-link 600 185 \
  "ATLAS-ARM64.dmg" \
  "ATLAS-ARM64.app"

# 18) Confirm final outputs
ls -lh

# Expected files:
# ATLAS-ARM64.app
# ATLAS-ARM64.zip
# ATLAS-ARM64.dmg
