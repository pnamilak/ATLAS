# ATLAS-ARM64

Display name: **ATLAS - AWS Trusted Login & Access Service**

Internal brand: **ATLAS**

Target architecture: **Apple Silicon (ARM64)**

## Notes

- macOS app data path uses ~/Library/Application Support/ATLAS
- Internal data folder name uses ATLAS
- Spec file: $AppName.spec
- PyInstaller app output: dist/ATLAS-ARM64.app
- Existing icon filename can remain unchanged if present

## ARM64 build steps

Run these on an Apple Silicon Mac:

`ash
cd ATLAS-ARM64
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
pip install pyinstaller==6.3.0
pyinstaller --noconfirm --clean ATLAS-ARM64.spec
`

Expected output:

`ash
dist/ATLAS-ARM64.app
`

Zip for sharing:

`ash
cd dist
ditto -c -k --sequesterRsrc --keepParent "ATLAS-ARM64.app" "ATLAS-ARM64.zip"
`
"@
} else {
@"
## X64 build steps

Share these only after ARM64 testing is complete.
