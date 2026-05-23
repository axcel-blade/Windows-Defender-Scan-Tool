@echo off
title Windows Defender Scan Tool
color 0A

:: Self-elevate to administrator on double-click
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%~s0' -Verb RunAs"
    exit /b
)

:menu
cls
echo ===============================================
echo          Windows Defender Scan Tool
echo ===============================================
echo.
echo Please select the type of scan you want to run:
echo.
echo [1] Quick Scan
echo [2] Full Scan
echo [3] Custom Scan (specify folder)
echo [4] Microsoft Defender Offline Scan
echo [5] Boot Sector Scan
echo [6] Exit
echo.
set /p choice="Enter your choice (1-6): "

if "%choice%"=="1" goto quickscan
if "%choice%"=="2" goto fullscan
if "%choice%"=="3" goto customscan
if "%choice%"=="4" goto offlinescan
if "%choice%"=="5" goto bootscan
if "%choice%"=="6" goto exit
echo Invalid choice. Please try again.
pause
goto menu

:quickscan
cls
echo ===============================================
echo          Quick Scan
echo ===============================================
echo.
powershell -NoProfile -Command ^
    "$exe = \"$env:ProgramFiles\Windows Defender\MpCmdRun.exe\"; " ^
    "$psi = New-Object System.Diagnostics.ProcessStartInfo $exe, '-Scan -ScanType 1'; " ^
    "$psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; " ^
    "$p = [System.Diagnostics.Process]::Start($psi); " ^
    "while (-not $p.StandardOutput.EndOfStream) { " ^
    "    $line = $p.StandardOutput.ReadLine(); " ^
    "    if ($line -match 'Scanning\s+(.+)') { " ^
    "        Write-Host ('  [>] Scanning: ' + $Matches[1]) -ForegroundColor Cyan " ^
    "    } elseif ($line -match 'Scan\s+(starting|finished|complete)' -or $line -match 'threat|found|clean') { " ^
    "        Write-Host ('  ' + $line) -ForegroundColor Yellow " ^
    "    } elseif ($line.Trim()) { " ^
    "        Write-Host ('  ' + $line) " ^
    "    } " ^
    "}; $p.WaitForExit()"
set "scantype=Quick Scan"
goto showreport

:fullscan
cls
echo ===============================================
echo          Full Scan
echo ===============================================
echo Warning: Full scan may take several hours to complete.
echo.
set /p confirm="Do you want to continue? (Y/N): "
if /i "%confirm%"=="Y" (
    echo.
    powershell -NoProfile -Command ^
        "$exe = \"$env:ProgramFiles\Windows Defender\MpCmdRun.exe\"; " ^
        "$psi = New-Object System.Diagnostics.ProcessStartInfo $exe, '-Scan -ScanType 2'; " ^
        "$psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; " ^
        "$p = [System.Diagnostics.Process]::Start($psi); " ^
        "while (-not $p.StandardOutput.EndOfStream) { " ^
        "    $line = $p.StandardOutput.ReadLine(); " ^
        "    if ($line -match 'Scanning\s+(.+)') { " ^
        "        Write-Host ('  [>] Scanning: ' + $Matches[1]) -ForegroundColor Cyan " ^
        "    } elseif ($line -match 'Scan\s+(starting|finished|complete)' -or $line -match 'threat|found|clean') { " ^
        "        Write-Host ('  ' + $line) -ForegroundColor Yellow " ^
        "    } elseif ($line.Trim()) { " ^
        "        Write-Host ('  ' + $line) " ^
        "    } " ^
        "}; $p.WaitForExit()"
    set "scantype=Full Scan"
    goto showreport
) else (
    echo Full scan cancelled.
    pause
    goto menu
)

:customscan
cls
echo ===============================================
echo          Custom Scan
echo ===============================================
echo.
set /p scanpath="Enter the path to scan (e.g., C:\Users): "
if not exist "%scanpath%" (
    echo Error: The specified path does not exist.
    pause
    goto menu
)
echo.
echo  Target: %scanpath%
echo.
powershell -NoProfile -Command ^
    "$exe = \"$env:ProgramFiles\Windows Defender\MpCmdRun.exe\"; " ^
    "$args = \"-Scan -ScanType 3 -File '%scanpath%'\"; " ^
    "$psi = New-Object System.Diagnostics.ProcessStartInfo $exe, $args; " ^
    "$psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; " ^
    "$p = [System.Diagnostics.Process]::Start($psi); " ^
    "while (-not $p.StandardOutput.EndOfStream) { " ^
    "    $line = $p.StandardOutput.ReadLine(); " ^
    "    if ($line -match 'Scanning\s+(.+)') { " ^
    "        Write-Host ('  [>] Scanning: ' + $Matches[1]) -ForegroundColor Cyan " ^
    "    } elseif ($line -match 'Scan\s+(starting|finished|complete)' -or $line -match 'threat|found|clean') { " ^
    "        Write-Host ('  ' + $line) -ForegroundColor Yellow " ^
    "    } elseif ($line.Trim()) { " ^
    "        Write-Host ('  ' + $line) " ^
    "    } " ^
    "}; $p.WaitForExit()"
set "scantype=Custom Scan (%scanpath%)"
goto showreport

:offlinescan
cls
echo ===============================================
echo     Microsoft Defender Offline Scan
echo ===============================================
echo WARNING: This will restart your computer and perform an offline scan.
echo Make sure to save all your work before proceeding.
echo The computer will automatically restart and scan before Windows loads.
echo.
set /p confirm="Are you sure you want to continue? (Y/N): "
if /i "%confirm%"=="Y" (
    echo Scheduling offline scan...
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3 -BootSectorScan
    echo.
    echo Offline scan has been scheduled. Your computer will restart shortly.
    echo After restart, the scan will run automatically.
    timeout /t 10
    shutdown /r /t 30 /c "Restarting for Microsoft Defender Offline Scan"
) else (
    echo Offline scan cancelled.
    pause
    goto menu
)
exit

:bootscan
cls
echo ===============================================
echo          Boot Sector Scan
echo ===============================================
echo.
powershell -NoProfile -Command ^
    "$exe = \"$env:ProgramFiles\Windows Defender\MpCmdRun.exe\"; " ^
    "$psi = New-Object System.Diagnostics.ProcessStartInfo $exe, '-Scan -ScanType 3 -BootSectorScan'; " ^
    "$psi.UseShellExecute = $false; $psi.RedirectStandardOutput = $true; $psi.RedirectStandardError = $true; " ^
    "$p = [System.Diagnostics.Process]::Start($psi); " ^
    "while (-not $p.StandardOutput.EndOfStream) { " ^
    "    $line = $p.StandardOutput.ReadLine(); " ^
    "    if ($line -match 'Scanning\s+(.+)') { " ^
    "        Write-Host ('  [>] Scanning: ' + $Matches[1]) -ForegroundColor Cyan " ^
    "    } elseif ($line -match 'Scan\s+(starting|finished|complete)' -or $line -match 'threat|found|clean') { " ^
    "        Write-Host ('  ' + $line) -ForegroundColor Yellow " ^
    "    } elseif ($line.Trim()) { " ^
    "        Write-Host ('  ' + $line) " ^
    "    } " ^
    "}; $p.WaitForExit()"
set "scantype=Boot Sector Scan"
goto showreport

:showreport
echo.
echo ===============================================
echo                  SCAN REPORT
echo ===============================================
echo  Scan Type : %scantype%
echo -----------------------------------------------
powershell -NoProfile -Command ^
    "$status = Get-MpComputerStatus; " ^
    "$detections = Get-MpThreatDetection -ErrorAction SilentlyContinue | " ^
    "    Sort-Object InitialDetectionTime -Descending | Select-Object -First 10; " ^
    "$threats = Get-MpThreat -ErrorAction SilentlyContinue; " ^
    "Write-Host ('  Last Quick Scan : ' + $(if($status.QuickScanStartTime){$status.QuickScanStartTime}else{'N/A'})); " ^
    "Write-Host ('  Last Full Scan  : ' + $(if($status.FullScanStartTime){$status.FullScanStartTime}else{'N/A'})); " ^
    "Write-Host ('  AV Signatures   : ' + $status.AntivirusSignatureVersion); " ^
    "Write-Host ('  Realtime Prot.  : ' + $(if($status.RealTimeProtectionEnabled){'Enabled'}else{'Disabled'})); " ^
    "Write-Host '-----------------------------------------------'; " ^
    "if ($threats) { " ^
    "    Write-Host ('  Threats Found   : ' + $threats.Count) -ForegroundColor Red; " ^
    "    foreach ($t in $threats) { Write-Host ('    [!] ' + $t.ThreatName) -ForegroundColor Red } " ^
    "} else { Write-Host '  Threats Found   : None' -ForegroundColor Green }; " ^
    "if ($detections) { " ^
    "    Write-Host '-----------------------------------------------'; " ^
    "    Write-Host '  Recent Detections:'; " ^
    "    foreach ($d in $detections) { " ^
    "        $time = $d.InitialDetectionTime.ToString('yyyy-MM-dd HH:mm:ss'); " ^
    "        $action = if($d.ActionSuccess){'Resolved'}else{'Pending'}; " ^
    "        Write-Host ('    [' + $time + '] ' + $d.ThreatName + ' - ' + $action) -ForegroundColor Yellow " ^
    "    } " ^
    "}"
echo ===============================================
echo.
set /p dummy="  Press ENTER to return to the menu..."
goto menu

:exit
cls
echo Thank you for using Windows Defender Scan Tool!
echo Exiting...
timeout /t 3
exit

:error
echo.
echo Error: Windows Defender command line tool not found.
echo Please make sure Windows Defender is installed and enabled.
echo.
pause
goto menu
