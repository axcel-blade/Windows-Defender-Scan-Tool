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
echo Running Quick Scan...
echo ===============================================
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
echo.
echo Quick scan completed!
pause
goto menu

:fullscan
cls
echo Running Full Scan...
echo ===============================================
echo Warning: Full scan may take several hours to complete.
set /p confirm="Do you want to continue? (Y/N): "
if /i "%confirm%"=="Y" (
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 2
    echo.
    echo Full scan completed!
) else (
    echo Full scan cancelled.
)
pause
goto menu

:customscan
cls
echo Custom Scan
echo ===============================================
set /p scanpath="Enter the path to scan (e.g., C:\Users): "
if not exist "%scanpath%" (
    echo Error: The specified path does not exist.
    pause
    goto menu
)
echo Scanning: %scanpath%
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3 -File "%scanpath%"
echo.
echo Custom scan completed!
pause
goto menu

:offlinescan
cls
echo Microsoft Defender Offline Scan
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
echo Boot Sector Scan
echo ===============================================
echo Running boot sector scan...
"%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 3 -BootSectorScan
echo.
echo Boot sector scan completed!
pause
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