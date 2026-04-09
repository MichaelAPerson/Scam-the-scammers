@echo off
:: ============================================
::   ALL-IN-ONE SHUTDOWN/RESTART PREVENTION
:: ============================================

:: Disable sleep (plugged in + on battery)
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0

:: Disable screen timeout (plugged in + on battery)
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0

:: Disable hibernate
powercfg /hibernate off

:: Disable Windows Update auto-restart
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f

:: Disable Windows Update service
sc config wuauserv start= disabled
sc stop wuauserv >nul 2>&1

:: Disable automatic maintenance (can trigger restarts)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /t REG_DWORD /d 1 /f

:: Launch the protection loop in a hidden background window
start /min "" cmd /c "title ShutdownGuard & :loop & shutdown /a >nul 2>&1 & timeout /t 1 /nobreak >nul & goto loop"
