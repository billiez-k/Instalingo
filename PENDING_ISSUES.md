# InstaLingo v3 — PENDING_ISSUES.md

## Chrome Viewport Auto-Resize for `flutter run -d chrome`

### Problem
When running `flutter run -d chrome`, Chrome opens in a full desktop window (~800x600+). There is no built-in Flutter CLI flag to force Chrome to open with a specific mobile viewport size (e.g., 390x844).

### Root Cause
`flutter run -d chrome` launches a bare Chrome instance with default window dimensions. Unlike Chrome DevTools "Device Toolbar" which requires manual activation, there is no way to programmatically set the viewport via Flutter CLI flags alone.

### What We Tried
- `flutter run -d chrome` — opens full desktop Chrome, no viewport control.
- Flutter 3.29.3 does not support `--web-browser-flag` for viewport control (flags are for security/feature flags only).

### Recommended Solutions (choose one)

1. **Chrome DevTools Device Mode (manual)**:
   After Chrome opens, press `Ctrl+Shift+I` → click "Toggle Device Toolbar" (`Ctrl+Shift+M`) → select iPhone 14 Pro (390x844). This must be done manually each session.

2. **Custom Chrome launch script** (automated):
   Create a launch script that opens Chrome with `--window-size` and `--auto-open-devtools-for-tabs`:
   ```bash
   # scripts/launch_chrome_mobile.sh
   google-chrome --new-window --window-size=390,844 \
     --user-data-dir=/tmp/flutter-mobile-profile \
     http://localhost:$(cat /tmp/flutter_web_port)
   ```
   Then run Flutter web without launching a browser:
   ```bash
   flutter run -d web-server --web-port=8080
   ```
   And use the script to open Chrome with the correct viewport.

3. **Responsive emulator** (recommended for testing):
   Use `flutter run -d chrome` normally and add `const ResponsiveWrapper` (from `responsive_framework` package) to the app root. The app will look correct on any viewport width by design. This is already partially done via `flutter_screenutil` in the v3 codebase.

### Status
- **Not fixable via Flutter CLI alone** — requires either manual DevTools activation, a custom launch script, or using a platform emulator.
- **Workaround**: The app already uses `flutter_screenutil` with `designSize: 390x844`, so it renders correctly at any browser width. The issue is purely cosmetic (Chrome window looks like desktop).
- **For production demos**: Use `flutter build web --no-tree-shake-icons` and deploy to a server, then view on a real mobile device.
