# -*- mode: python ; coding: utf-8 -*-

from PyInstaller.utils.hooks import collect_submodules

hiddenimports = collect_submodules('boto3') + collect_submodules('botocore')

a = Analysis(
    ['launcher_desktop.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('app/templates', 'app/templates'),
        ('app/static', 'app/static'),
        ('schema.sql', '.'),
        ('ATLAS.icns', '.'),
    ],
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='ATLAS',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=False,
    target_arch='universal2',
)

app = BUNDLE(
    exe,
    name='ATLAS.app',
    icon='ATLAS.icns',
    bundle_identifier='com.company.atlas',
    info_plist={
        'CFBundleName': 'ATLAS',
        'CFBundleDisplayName': 'ATLAS - AWS Trusted Login & Access Service',
        'CFBundleShortVersionString': '1.0.0',
        'CFBundleVersion': '1.0.0',
        'NSHighResolutionCapable': True,
    },
)
