# notime
A tiny macOS desktop widget that shows how much time is left in the day, week, month, and year.

<p align="center">
  <img src="time-is-running-out.png" width="600" />
</p>

- Sits below your windows like a desktop widget
- Drag to reposition anywhere, resize horizontally from the corner
- Right-click to toggle always-on-top, reset position, or quit
- Only one instance runs at a time
- No dock icon, ~200KB binary, zero dependencies
- Progress bars shift cyan → red as time drains

## Install

```bash
curl -sL https://raw.githubusercontent.com/hpanwar09/notime/main/get.sh | bash
```

This downloads the app to `/Applications` and opens it.

## Reopen

If you quit it, reopen anytime:

```bash
open -a notime
```

Or find **notime** in Spotlight (⌘ Space → "notime").

## Auto-start on login

Open **System Settings → General → Login Items** and add `/Applications/notime.app`.

Or from terminal:

```bash
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/notime.app", hidden:true}'
```

## Right-click menu

- **Always on Top** — toggle floating above all windows
- **Reset Position** — snap back to bottom-right corner
- **Quit notime**

## Uninstall

```bash
rm -rf /Applications/notime.app
```

## Build from source

Requires macOS 13+ and Xcode Command Line Tools.

```bash
git clone https://github.com/hpanwar09/notime.git
cd notime
./build.sh
open notime.app
```

## License

MIT
