# Windows Defender Scan Tool

A user-friendly batch script that provides a menu-driven interface for Windows Defender's built-in scanning capabilities. This tool simplifies access to various scan types without needing to remember complex command-line parameters.

## Features

- **Interactive Menu Interface** - Easy-to-use command-line menu system
- **Multiple Scan Types** - Quick, Full, Custom, Offline, and Boot Sector scans
- **Real-Time Scan Progress** - Shows the current file/folder being scanned as it happens
- **Post-Scan Report** - Displays a full summary after every scan with threat details and AV status
- **Safety Confirmations** - Prompts for potentially disruptive operations
- **Error Handling** - Validates paths and provides helpful error messages
- **Auto-Elevate** - Automatically requests administrator privileges on double-click

## Scan Types

### 1. Quick Scan
- Scans the most common locations where malware is typically found
- Fast execution (usually completes in minutes)
- Ideal for routine security checks

### 2. Full Scan
- Comprehensive scan of the entire system
- Scans all files and running programs
- Can take several hours to complete
- Includes confirmation prompt due to time requirement

### 3. Custom Scan
- Allows you to specify a particular folder or drive path
- Perfect for scanning suspicious directories or external drives
- Validates path existence before scanning

### 4. Microsoft Defender Offline Scan
- Restarts the computer and runs a pre-boot scan
- Effective against rootkits and persistent malware
- **Warning:** Will restart your computer automatically
- Includes multiple confirmation prompts

### 5. Boot Sector Scan
- Scans boot sectors for rootkits and boot-level malware
- Targets areas that are difficult to scan while Windows is running
- Quick execution compared to full system scans

## Real-Time Scan Progress

During any scan, the tool displays each file and folder being scanned as it happens:

```
===============================================
         Quick Scan
===============================================

  [>] Scanning: C:\Windows\System32\ntdll.dll
  [>] Scanning: C:\Users\YourName\AppData\Roaming\...
  Scan finished.
```

- **`[>] Scanning:`** lines (cyan) — current file or folder being checked
- **Status lines** (yellow) — scan start, finish, and threat events
- Progress scrolls live so you always know what Defender is working on

## Post-Scan Report

After every scan completes, a full report is shown in the CLI before returning to the menu:

```
===============================================
                 SCAN REPORT
===============================================
 Scan Type : Quick Scan
-----------------------------------------------
  Last Quick Scan : 05/24/2026 14:32:01
  Last Full Scan  : 05/20/2026 09:15:44
  AV Signatures   : 1.409.100.0
  Realtime Prot.  : Enabled
-----------------------------------------------
  Threats Found   : None
===============================================

  Press ENTER to return to the menu...
```

If threats are detected, they are listed by name in red. Recent detection history (up to 10 entries) is shown with timestamps and resolution status. The window stays open until you press **Enter**.

## Requirements

- Windows 10/11 with Windows Defender enabled
- Administrator privileges (the script auto-elevates on double-click)
- Windows Defender command-line tool (`MpCmdRun.exe`) must be available
- PowerShell (built into Windows — no installation needed)

## Installation

1. Download the `DefenderScan.bat` file
2. Save it to a convenient location on your computer
3. Double-click to run — it will automatically request administrator privileges

## Usage

1. **Launch the Script**
   ```
   Double-click DefenderScan.bat
   ```
   The script self-elevates to administrator automatically.

2. **Select Scan Type**
   - Choose from options 1-6 using the number keys
   - Follow on-screen prompts for confirmation when required

3. **Monitor Progress**
   - Watch real-time scan output showing each file being checked
   - A full report is displayed when the scan finishes

4. **Review the Report**
   - Check threat status, AV signature version, and scan timestamps
   - Press **Enter** to return to the main menu

## Example Session

```
===============================================
         Windows Defender Scan Tool
===============================================

Please select the type of scan you want to run:

[1] Quick Scan
[2] Full Scan
[3] Custom Scan (specify folder)
[4] Microsoft Defender Offline Scan
[5] Boot Sector Scan
[6] Exit

Enter your choice (1-6): 1

===============================================
         Quick Scan
===============================================

  [>] Scanning: C:\Windows\System32\kernel32.dll
  [>] Scanning: C:\Users\YourName\Downloads\setup.exe
  Scan finished.

===============================================
                 SCAN REPORT
===============================================
 Scan Type : Quick Scan
-----------------------------------------------
  Last Quick Scan : 05/24/2026 14:32:01
  Last Full Scan  : N/A
  AV Signatures   : 1.409.100.0
  Realtime Prot.  : Enabled
-----------------------------------------------
  Threats Found   : None
===============================================

  Press ENTER to return to the menu...
```

## Important Notes

> **Administrator Rights** — The script auto-elevates on double-click. If UAC is disabled, run it manually as administrator.

> **Offline Scan Warning** — The offline scan option will restart your computer. Save all work before proceeding.

> **Full Scan Duration** — Full scans can take several hours depending on system size and file count.

## Troubleshooting

### Common Issues

**"Windows Defender command line tool not found"**
- Ensure Windows Defender is enabled in Windows Security settings
- Verify that Windows Defender is not disabled by group policy
- Check if a third-party antivirus has replaced Windows Defender

**"Access Denied" Errors**
- Run the script as administrator
- Ensure Windows Defender Real-time Protection is enabled

**Custom Scan Path Not Found**
- Verify the path exists and is accessible
- Use full paths (e.g., `C:\Users\YourName\Documents`)
- Avoid using mapped network drives for reliability

**Scan progress not showing**
- Ensure PowerShell is available (it is built into Windows 10/11)
- Try running the script directly as administrator rather than via double-click

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Suggested Improvements
- Add scan scheduling options
- Add support for exclusion lists
- Export report to a text or HTML file

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This tool is provided as-is for educational and administrative purposes. Always ensure you have proper backups before running system scans. The authors are not responsible for any system issues that may arise from the use of this tool.

## Support

If you encounter issues or have questions:
1. Check the troubleshooting section above
2. Review Windows Defender documentation
3. Submit an issue on this repository

---

**Version:** 1.2  
**Last Updated:** May 2026  
**Compatibility:** Windows 10, Windows 11
