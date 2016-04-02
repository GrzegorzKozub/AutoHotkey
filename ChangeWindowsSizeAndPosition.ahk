﻿; Settings

_settings := [ Join

    , { HiRes: { Width: 2200, Height: 1300, Center: True }
      , LoRes: { Width: 1650, Height: 1000, Center: True, Max: True }
      , Windows: [ "Microsoft SQL Server Management Studio"
                 , "Microsoft Visual Studio"
                 , "Release Management" ] }

    , { HiRes: { Width: 1636, Height: 984, Center: True }
      , LoRes: { Width: 1636, Height: 984, Center: True }
      , Windows: [ "GVIM"
                 , "Visual Studio Code" ] }

    , { HiRes: { Width: 1900, Height: 1200, Center: True }
      , LoRes: { Width: 1500, Height: 1000, Center: True }
      , Windows: [ "BareTail"
                 , "Developer Tools" ; Chrome
                 , "Edge"
                 , "Excel"
                 , "F12 Developer Tools" ; Edge
                 , "Git Gui"
                 , "Google Chrome"
                 , "JetBrains dotPeek"
                 , "Mozilla Firefox",
                 , "paint.net"
                 , "PowerPoint"
                 , "Remote Desktop Connection"
                 , "SourceTree"
                 , "SQL Server Profiler"
                 , "SumatraPDF"
                 , "Visio"
                 , "Internet Explorer"
                 , "Word" ] }

    , { HiRes: { Width: 1500, Height: 1000, Center: True }
      , LoRes: { Width: 1300, Height: 900, Center: True }
      , Windows: [ "Spotify"
                 , "Steam" ] }

    , { HiRes: { Width: 1200, Height: 850, Center: True }
      , LoRes: { Width: 1200, Height: 850, Center: True }
      , Windows: [ "Event Viewer"
                 , "Fiddler Web Debugger"
                 , "Hyper-V Manager"
                 , "Internet Information Services (IIS) Manager"
                 , "LOOT"
                 , "Mod Organizer"
                 , "NVIDIA Control Panel"
                 , "Pogoda"
                 , "Task Scheduler"
                 , "Total Commander"
                 , "Settings"
                 , "WinSCP" ] } ]

_settings := Concatenate(_settings, [ Join

    , { HiRes: { Width: 1253, Height: 959, Right: 25, Bottom: 25 }
      , LoRes: { Width: 1013, Height: 779, Right: 25, Bottom: 25 }
      , Windows: [ "~" ] } ; ConEmu

    , { HiRes: { Width: 975, Height: 650, Center: True }
      , LoRes: { Width: 975, Height: 650, Center: True }
      , Windows: [ "WinSnap" ] }

    , { HiRes: { Width: 900, Height: 900, Center: True }
      , LoRes: { Width: 900, Height: 900, Center: True }
      , Windows: [ "Skype"
                 , "Slack" ] }

    , { HiRes: { Width: 900, Height: 600, Center: True }
      , LoRes: { Width: 900, Height: 600, Center: True }
      , Windows: [ { Title: "C:\Users\", Except: "Notepad" } ; 7-Zip
                 , "Deluge"
                 , "KeePass"
                 , "Lister" ; Total Commander
                 , "Notepad"
                 , "Oracle VM VirtualBox Manager"
                 , "Rapid Environment Editor"
                 , "Registry Editor"
                 , "Resource Hacker"
                 , "VLC media player"
                 , "WinRAR" ] } ] )

_settings := Concatenate(_settings, [ Join

    , { HiRes: { Width: 700, Height: 800, Center: True }
      , LoRes: { Width: 700, Height: 800, Center: True }
      , Windows: [ "Todoist" ] }

    , { HiRes: { Width: 800, Height: 500, Center: True }
      , LoRes: { Width: 800, Height: 500, Center: True }
      , Windows: [ "SyncBackPro" ] }

    , { HiRes: { Width: 750, Height: 500, Center: True }
      , LoRes: { Width: 750, Height: 500, Center: True }
      , Windows: [ "Manage Stickies" ] }

    , { HiRes: { Width: 660, Height: 600, Right: 25, Bottom: 25 }
      , LoRes: { Width: 660, Height: 600, Right: 25, Bottom: 25 }
      , Windows: [ "Task Manager" ] }

    , { HiRes: { Width: 650, Height: 600, Center: True }
      , LoRes: { Width: 650, Height: 600, Center: True }
      , Windows: [ "Open Broadcaster Software" ] }

    , { HiRes: { Width: 233, Height: 450, Right: 25, Bottom: 25 }
      , LoRes: { Width: 233, Height: 450, Right: 25, Bottom: 25 }
      , Windows: [ "Friends" ] } ; Steam

    , { HiRes: { Center: True }
      , LoRes: { Center: True }
      , Windows: [ "Calculator"
                 , "Command Prompt"
                 , "IrfanView"
                 , "Microsoft Security Essentials"
                 , "Stickies"
                 , "Web Platform Installer" ] } ] )

; Main

SplitPath A_ScriptName,,,, fileName
Menu Tray, Icon, %fileName%.ico
SetTitleMatchMode 2
HotKey ^#w, FixWindows
HotKey ^#a, FixActiveWindow
HotKey ^#c, CenterActiveWindow
_screen := GetScreen()
return

; Labels

FixWindows:
    _screen := GetScreen()
    Act(_settings)
    return

FixActiveWindow:
    _screen := GetScreen()
    WinGetActiveTitle activeWindowTitle
    Act(_settings, activeWindowTitle)
    return

CenterActiveWindow:
    _screen := GetScreen()
    WinGetActiveTitle title
    UpdateWindow(title, "", { Center: True })
    return

; Functions

Act(settings, filter = "") {
    global _screen
    for key, group in settings {
        options := _screen.LoRes ? group.LoRes : group.HiRes
        for key, window in group.Windows {
            title := window.Title ? window.Title : window
            except := window.Except ? window.Except : ""
            if (!filter || (InStr(filter, title) > 0 && (!except || InStr(filter, except) == 0))) {
                UpdateWindow(title, except, options)
                if (filter) {
                    match := True
                    break
                }
            }
        }
        if (match) {
            match := False
            break
        }
    }
}

UpdateWindow(title, except, options) {
    global _screen
    window := GetWindowPositionAndSize(title, except)
    if (!window) {
        return
    }
    left := options.Left ? options.Left : -options.Right
    top := options.Top ? options.Top : -options.Bottom
    SetWindowPositionAndSize(title, except, left, top, options.Width, options.Height, options.Center, options.Max)
    if (window.Minimized) {
        WinMinimize % title
    }
}

SetWindowPositionAndSize(title, except = "", left = "", top = "", width = "", height = "", center = False, max = False) {
    global _screen
    WinRestore %title%,, %except%
    window := GetWindowPositionAndSize(title, except)
    if (!width) {
        width := window.Width
    }
    if (!height) {
        height := window.Height
    }
    if (!left) {
        left := window.Left
    } else if (left < 0) {
        left := _screen.Width - (width + Abs(left))
    }
    if (!top) {
        top := window.Top
    } else if (top < 0) {
        top := _screen.Height - (height + Abs(top))
    }
    WinMove %title%,, %left%, %top%, %width%, %height%, %except%
    if (center) {
        WinMove %title%,, (_screen.Width / 2) - (width / 2), (_screen.Height / 2) - (height / 2),,, %except%
    }
    if (max) {
        WinMaximize %title%,, %except%
    }
}

GetWindowPositionAndSize(title = "", except = "") {
    if (!title) {
        WinGetActiveTitle title
    }
    WinGetPos x, y, width, height, %title%,, %except%
    if (!x) {
        return
    }
    WinGet minMax, MinMax, %title%,, %except%
    return { Left: x, Top: y, Width: width, Height: height, Maximized: minMax == 1, Minimized: minMax == -1 }
}

GetScreen(monitorNumber = "") {
    if (!monitorNumber) {
        SysGet monitorNumber, MonitorPrimary
    }
    SysGet monitor, Monitor, %monitorNumber%
    SysGet monitorWorkArea, MonitorWorkArea, %monitorNumber%
    return { LoRes: monitorBottom < 1440
           , Width: monitorWorkAreaRight - monitorWorkAreaLeft
           , Height: monitorWorkAreaBottom - monitorWorkAreaTop }
}

Concatenate(arrays*) {
    result := Object()
    for key, array in arrays {
        for key, element in array {
            result.Insert(element)
        }
    }
    return result
}

