@echo off
title YTDL-Helper Updater
cd %~dp0
:: ==================================================Obtain==================================================
curl --output releases.tmp -L https://api.github.com/repos/yuri010/youtube-dl-helper/releases
call :gver
call :gvercleanup
call :lver
goto :main
:: ==================================================Checks==================================================

:gver
for /F "tokens=2 delims= " %%a IN ('findstr /I "tag_name" releases.tmp') DO (
set gver=%%a
exit /b
)
:gvercleanup
for /F "tokens=1 delims=," %%b IN ("%gver%") DO (
set gver=%%b
exit /b
)

:lver
for /F "tokens=3 delims= " %%c IN ('findstr /I "version" ytdl-helper.bat') DO (
set lver=%%c
exit /b
)


:main
del releases.tmp
if /I "%lver%" GTR %gver% (
cls
echo Hey! Github isn't Up-to-Date!
echo.
echo Press any key to exit...
pause > nul
exit
)
if /I "%lver%" == %gver% (
cls
echo YTDL-Helper is Up-to-Date.
echo.
echo Press any key to exit...
pause > nul
exit
)
if "%lver%" LSS %gver% (
cls
echo An update is available, would you like to install it? [Y/N]
choice /c YN /N
if /I "%errorlevel%" EQU "2" exit
if /I "%errorlevel%" EQU "1" goto :update
)

:: ==================================================Update==================================================

:update
cls
echo Attempting to obtain the latest YTDL-Helper...
curl -0 -L https://raw.githubusercontent.com/Yuri010/Youtube-DL-Helper/main/ytdl-helper.bat -o ytdl-helper-new.bat
cls
echo Updating to version %gver% over %lver%...
move ytdl-helper.bat ytdl-helper-old.bak
move ytdl-helper-new.bat ytdl-helper.bat
cls
echo Updating to version %gver% over %lver%... Done!
echo.
echo Update success!
timeout /t 3 /nobreak > nul
exit