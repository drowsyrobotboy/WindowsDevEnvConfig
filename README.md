# Virtual Desktop Manager with Dual Display Support

An AutoHotkey v2 script that enhances Windows Virtual Desktops with intelligent dual display management. When using multiple monitors, apps on your primary display automatically stay visible across all virtual desktops.

## Features

- 🖥️ **Automatic dual display detection** - Detects when you have 2+ monitors
- 📌 **Smart app pinning** - Apps on primary display remain visible on all desktops  
- 🔄 **Dynamic monitor change handling** - Automatically adapts when connecting/disconnecting displays
- ⌨️ **Convenient hotkeys** - Quick virtual desktop switching and management
- 🐛 **Debug tools** - Built-in diagnostics and manual controls

## Requirements

- AutoHotkey v2+
- Windows 10/11 with Virtual Desktop support
- VD.ahk library (in same folder)

## Installation

1. Download both `Desktops.ahk` and `VD.ahk` files
2. Place them in the same folder
3. Run `Desktops.ahk` with AutoHotkey v2

## Keyboard Shortcuts

### Virtual Desktop Navigation
| Shortcut | Action |
|----------|--------|
| `Alt + 1` | Switch to Virtual Desktop 1 |
| `Alt + 2` | Switch to Virtual Desktop 2 |
| `Alt + 3` | Switch to Virtual Desktop 3 |
| `Alt + 4` | Switch to Virtual Desktop 4 |
| `Alt + 5` | Switch to Virtual Desktop 5 |
| `Alt + Shift + D` | Create new virtual desktop and switch to it |

### Debug & Manual Controls
| Shortcut | Action |
|----------|--------|
| `Alt + Shift + S` | Show detailed display status and troubleshooting info |
| `Alt + Shift + P` | Manually trigger app pinning on primary display |
| `Alt + Shift + F` | Force enable dual display mode (override detection) |
| `Alt + Shift + U` | Manually unpin all windows |

## How It Works

### Dual Monitor Mode (2+ displays detected)
- **Automatic Detection**: Script detects multiple monitors using Windows API
- **Primary Display Apps**: Windows on your primary display are automatically pinned to all virtual desktops
- **Smart Switching**: When switching desktops, apps on primary display remain visible while secondary display apps switch normally

### Single Monitor Mode (1 display detected)
- **Normal Behavior**: Standard virtual desktop switching without any pinning
- **Automatic Cleanup**: When switching from dual to single monitor, all pinned windows are automatically unpinned

### Dynamic Adaptation
- **Monitor Connect/Disconnect**: Script automatically detects when monitors are connected or disconnected
- **Seamless Transition**: Switches between single and dual monitor modes without manual intervention
- **Visual Feedback**: Tooltips show when display changes are detected and actions are taken

## Troubleshooting

### "Only 1 monitor detected" but you have 2 displays

1. **Check Windows Display Settings**:
   - Right-click desktop → Display settings
   - Ensure both displays are shown and recognized

2. **Verify Display Mode**:
   - Press `Win + P` → Select "Extend these displays"
   - Avoid "Duplicate" mode which appears as one display

3. **Force Detection**:
   - In Display settings, click "Detect" button
   - Try disconnecting and reconnecting external monitor

4. **Manual Override**:
   - Press `Alt + Shift + F` to force dual display mode
   - Press `Alt + Shift + S` to see detailed detection info

### Debug Information

Press `Alt + Shift + S` to see:
- Monitor count from different detection methods
- Detailed position and size info for each display
- Current pinning status
- Troubleshooting suggestions

## Display Detection Methods

The script uses multiple detection methods for reliability:
- **AutoHotkey MonitorGet()**: Built-in AHK function
- **Windows API GetSystemMetrics()**: Direct Windows system call
- **Automatic Selection**: Uses whichever method reports higher monitor count

## Customization

### Adding More Virtual Desktops
To add shortcuts for more virtual desktops, add lines like:
```autohotkey
!6::SwitchToDesktop(6)  ; Alt+6 for Desktop 6
```

### Changing Hotkeys
Modify the hotkey definitions at the bottom of the script:
- `!` = Alt key
- `+` = Shift key  
- `^` = Ctrl key
- `#` = Windows key

Example: `^1::SwitchToDesktop(1)` would make Ctrl+1 switch to Desktop 1

## Files

- **Desktops.ahk** - Main script with dual display management
- **VD.ahk** - Virtual Desktop library (handles Windows Virtual Desktop API)
- **README.md** - This documentation

## Credits

- Uses the excellent [VD.ahk library](https://github.com/FuPeiJiang/VD.ahk) for Virtual Desktop management
- Built with AutoHotkey v2

## License

Free to use and modify. No warranty provided.
