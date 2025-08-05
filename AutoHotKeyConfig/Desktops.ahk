#Requires AutoHotkey v2+

#Include VD.ahk

; Dual display detection and primary display app retention
class DualDisplayManager {
    static hasMultipleDisplays := false
    static primaryDisplayBounds := {}
    static pinnedWindows := Map()
    static currentMonitorCount := 0
    
    static Initialize() {
        this.DetectDisplays()
        this.currentMonitorCount := Max(this.ahkMonitorCount, this.apiMonitorCount)
        
        ; Debug: Show detection results
        ToolTip("AHK: " . this.ahkMonitorCount . " | API: " . this.apiMonitorCount . " | Multiple displays: " . (this.hasMultipleDisplays ? "Yes" : "No"))
        SetTimer(() => ToolTip(), -3000)  ; Hide tooltip after 3 seconds
        
        ; Register for display change notifications
        OnMessage(0x007E, OnDisplayChangeCallback)  ; WM_DISPLAYCHANGE
        
        if (this.hasMultipleDisplays) {
            this.GetPrimaryDisplayBounds()
            this.PinPrimaryDisplayApps()
        }
    }
    
    static DetectDisplays() {
        ; Try AutoHotkey's built-in method first
        monitorCount := MonitorGet()
        
        ; Also try Windows API method as backup
        apiMonitorCount := DllCall("User32.dll\GetSystemMetrics", "Int", 80) ; SM_CMONITORS
        
        ; Use the higher count
        actualCount := Max(monitorCount, apiMonitorCount)
        this.hasMultipleDisplays := (actualCount >= 2)
        
        ; Store both counts for debugging
        this.ahkMonitorCount := monitorCount
        this.apiMonitorCount := apiMonitorCount
        
        return this.hasMultipleDisplays
    }
    
    static GetPrimaryDisplayBounds() {
        primaryNum := MonitorGetPrimary()
        MonitorGet(primaryNum, &left, &top, &right, &bottom)
        this.primaryDisplayBounds := {
            left: left,
            top: top,
            right: right,
            bottom: bottom
        }
    }
    
    static IsWindowOnPrimaryDisplay(hwnd) {
        WinGetPos(&x, &y, &width, &height, "ahk_id " hwnd)
        centerX := x + width // 2
        centerY := y + height // 2
        
        return (centerX >= this.primaryDisplayBounds.left && 
                centerX <= this.primaryDisplayBounds.right && 
                centerY >= this.primaryDisplayBounds.top && 
                centerY <= this.primaryDisplayBounds.bottom)
    }
    
    static PinPrimaryDisplayApps() {
        if (!this.hasMultipleDisplays)
            return
            
        ; Get all windows
        windowList := WinGetList()
        pinnedCount := 0
        
        for hwnd in windowList {
            try {
                ; Get window title for debugging
                winTitle := WinGetTitle("ahk_id " hwnd)
                if (winTitle == "")
                    continue
                    
                ; Skip if window is already pinned or invalid
                if (VD.IsWindowPinned("ahk_id " hwnd) == 1)
                    continue
                    
                ; Check if window is on primary display
                if (this.IsWindowOnPrimaryDisplay(hwnd)) {
                    ; Pin the window to all desktops
                    VD.PinWindow("ahk_id " hwnd)
                    this.pinnedWindows[hwnd] := true
                    pinnedCount++
                }
            } catch {
                ; Skip windows that can't be processed
                continue
            }
        }
        
        ; Debug: Show how many windows were pinned
        if (pinnedCount > 0) {
            ToolTip("Pinned " . pinnedCount . " windows on primary display")
            SetTimer(() => ToolTip(), -2000)
        }
    }
    
    static OnDisplayChange(wParam, lParam, msg, hwnd) {
        ; Small delay to ensure display info is updated
        SetTimer(() => DualDisplayManager.HandleDisplayChange(), -500)
    }
    
    static HandleDisplayChange() {
        ; Re-detect displays
        wasMultiple := this.hasMultipleDisplays
        oldCount := this.currentMonitorCount
        
        this.DetectDisplays()
        newCount := Max(this.ahkMonitorCount, this.apiMonitorCount)
        this.currentMonitorCount := newCount
        
        ; Debug notification
        ToolTip("Display change: " . oldCount . " → " . newCount . " monitors")
        SetTimer(() => ToolTip(), -2000)
        
        if (wasMultiple && !this.hasMultipleDisplays) {
            ; Going from multiple to single monitor - unpin all our pinned windows
            this.UnpinAllWindows()
        } else if (!wasMultiple && this.hasMultipleDisplays) {
            ; Going from single to multiple monitors - pin primary display apps
            this.GetPrimaryDisplayBounds()
            this.PinPrimaryDisplayApps()
        } else if (this.hasMultipleDisplays && (newCount != oldCount)) {
            ; Monitor count changed but still multiple - refresh pinning
            this.GetPrimaryDisplayBounds()
            this.PinPrimaryDisplayApps()
        }
    }
    
    static UnpinAllWindows() {
        count := 0
        for hwnd in this.pinnedWindows {
            try {
                if (WinExist("ahk_id " hwnd)) {
                    VD.UnPinWindow("ahk_id " hwnd)
                    count++
                }
            } catch {
                continue
            }
        }
        this.pinnedWindows.Clear()
        
        if (count > 0) {
            ToolTip("Unpinned " . count . " windows (switched to single monitor)")
            SetTimer(() => ToolTip(), -2000)
        }
    }
    
    static OnDesktopSwitch() {
        if (this.hasMultipleDisplays) {
            ; Re-pin any new windows on primary display
            this.PinPrimaryDisplayApps()
        }
    }
}

; Callback function for display change notifications
OnDisplayChangeCallback(wParam, lParam, msg, hwnd) {
    DualDisplayManager.OnDisplayChange(wParam, lParam, msg, hwnd)
}

; Custom desktop switching function that handles dual displays
SwitchToDesktop(desktopNum) {
    DualDisplayManager.OnDesktopSwitch()
    VD.goToDesktopNum(desktopNum)
}

; Initialize dual display management on startup
DualDisplayManager.Initialize()

; Hotkeys to switch to a specific virtual desktop
!1::SwitchToDesktop(1)
!2::SwitchToDesktop(2)
!3::SwitchToDesktop(3)
!4::SwitchToDesktop(4)
!5::SwitchToDesktop(5)

; Hotkey to create a new virtual desktop and switch to it
!+d::VD.createDesktop(true)

; Debug hotkey to manually trigger pinning (Alt+Shift+P)
!+p::DualDisplayManager.PinPrimaryDisplayApps()

; Manual override to force dual display mode (Alt+Shift+F)
!+f::{
    DualDisplayManager.hasMultipleDisplays := true
    DualDisplayManager.GetPrimaryDisplayBounds()
    DualDisplayManager.PinPrimaryDisplayApps()
    ToolTip("Forced dual display mode ON")
    SetTimer(() => ToolTip(), -2000)
}

; Manual unpinning for testing (Alt+Shift+U)
!+u::{
    DualDisplayManager.UnpinAllWindows()
    DualDisplayManager.hasMultipleDisplays := false
    ToolTip("Manually unpinned all windows")
    SetTimer(() => ToolTip(), -2000)
}

; Debug hotkey to show detailed display info (Alt+Shift+S)
!+s::{
    monCount := MonitorGet()
    hasMultiple := DualDisplayManager.hasMultipleDisplays
    pinnedCount := DualDisplayManager.pinnedWindows.Count
    
    msg := "=== DISPLAY DETECTION DEBUG ===`n"
    msg .= "AutoHotkey MonitorGet(): " . monCount . "`n"
    msg .= "Windows API GetSystemMetrics(): " . DualDisplayManager.apiMonitorCount . "`n"
    msg .= "Multiple displays detected: " . (hasMultiple ? "Yes" : "No") . "`n"
    msg .= "Pinned windows: " . pinnedCount . "`n`n"
    
    ; Get detailed info for each monitor
    msg .= "=== MONITOR DETAILS ===`n"
    Loop monCount {
        MonitorGet(A_Index, &left, &top, &right, &bottom)
        MonitorGetWorkArea(A_Index, &wLeft, &wTop, &wRight, &wBottom)
        
        width := right - left
        height := bottom - top
        isPrimary := (A_Index == MonitorGetPrimary()) ? " (PRIMARY)" : ""
        
        msg .= "Monitor " . A_Index . isPrimary . ":`n"
        msg .= "  Position: " . left . "," . top . " to " . right . "," . bottom . "`n"
        msg .= "  Size: " . width . "x" . height . "`n"
        msg .= "  Work Area: " . wLeft . "," . wTop . " to " . wRight . "," . wBottom . "`n`n"
    }
    
    ; Check Windows display settings suggestion
    msg .= "=== TROUBLESHOOTING ===`n"
    msg .= "If you have 2 displays but only 1 is detected:`n"
    msg .= "1. Check Windows Display Settings (Win+P)`n"
    msg .= "2. Ensure displays are set to 'Extend' not 'Duplicate'`n"
    msg .= "3. Try disconnecting/reconnecting external monitor`n"
    msg .= "4. Update display drivers if needed"
    
    MsgBox(msg, "Detailed Display Information", "0x40000")
}
