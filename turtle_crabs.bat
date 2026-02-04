@echo off
setlocal enabledelayedexpansion
chcp 1252 >nul

:: DCG: Generate Turtle symbol ¤ (ID 164)
for /f "delims=" %%A in ('powershell -NoProfile -Command "[char]164"') do set "turtle=%%A"

:: Game Settings
set "crab=M"
set "sand=."
set /a tx=15, ty=7, score=0, width=30, height=10
set "currentDir=w"
set "crabCount=1"
if not defined bestScore set "bestScore=0"

:: Initialize First Crab Position
set /a "cx[1]=10, cy[1]=5"

:menu
cls
echo ========================================
echo        TURTLE SAND WALK (2026)
echo ========================================
echo  Turtle: %turtle%   Crabs: %crab%
echo  Difficulty: New Crab every 125 score!
echo  Best Score: %bestScore%
echo.
pause

:gameLoop
set /a score+=1
if %score% gtr %bestScore% set "bestScore=%score%"

:: 1. DIFFICULTY LOGIC (Add 1 crab every 125 points)
set /a "check=score %% 125"
if %check% equ 0 (
    set /a crabCount+=1
    set /a "cx[!crabCount!]=!random! %% width + 1"
    set /a "cy[!crabCount!]=!random! %% height + 1"
)

:: 2. MOVEMENT ENGINE (1s delay, auto-walk)
choice /c wasd /t 1 /d %currentDir% /n >nul
if %errorlevel% equ 1 set "currentDir=w"
if %errorlevel% equ 2 set "currentDir=a"
if %errorlevel% equ 3 set "currentDir=s"
if %errorlevel% equ 4 set "currentDir=d"

if "%currentDir%"=="w" set /a ty-=1
if "%currentDir%"=="a" set /a tx-=1
if "%currentDir%"=="s" set /a ty+=1
if "%currentDir%"=="d" set /a tx+=1

:: 3. CRAB AI AND COLLISION
for /L %%i in (1,1,%crabCount%) do (
    set /a "r=!random! %% 4"
    if !r! equ 0 set /a cy[%%i]-=1
    if !r! equ 1 set /a cy[%%i]+=1
    if !r! equ 2 set /a cx[%%i]-=1
    if !r! equ 3 set /a cx[%%i]+=1
    
    :: Crab Boundaries
    if !cx[%%i]! lss 1 set /a cx[%%i]=1
    if !cx[%%i]! gtr %width% set /a cx[%%i]=%width%
    if !cy[%%i]! lss 1 set /a cy[%%i]=1
    if !cy[%%i]! gtr %height% set /a cy[%%i]=%height%
    
    :: Check Collision
    if !tx! equ !cx[%%i]! if !ty! equ !cy[%%i]! goto :gameOver
)

:: 4. TURTLE BOUNDARIES
if %tx% lss 1 set tx=1
if %tx% gtr %width% set tx=%width%
if %ty% lss 1 set ty=1
if %ty% gtr %height% set ty=%height%

:: 5. DRAWING (Fixed Visible Crab Logic)
cls
echo Score: %score%  Best: %bestScore%  Crabs: %crabCount%
echo ------------------------------
for /L %%y in (1,1,%height%) do (
    set "line="
    for /L %%x in (1,1,%width%) do (
        set "pixel=%sand%"
        :: Check for Crabs first
        for /L %%i in (1,1,%crabCount%) do (
            if %%x equ !cx[%%i]! if %%y equ !cy[%%i]! set "pixel=%crab%"
        )
        :: Turtle overrides sand (but not necessarily crab if you hit it)
        if %%x equ %tx% if %%y equ %ty% set "pixel=%turtle%"
        set "line=!line!!pixel!"
    )
    echo(!line!
)
echo ------------------------------
goto :gameLoop

:gameOver
cls
:: Fast Corrupted Effect (IDs 32 to 255)
powershell -NoProfile -Command "$o=''; for($i=0;$i -lt 400;$i++){$o+=[char](Get-Random -Min 32 -Max 255)}; Write-Host $o -FC Cyan"
echo.
echo           [ G A M E   O V E R ]
echo           Final Score: %score%
echo           Crabs Faced: %crabCount%
echo           Best Score:  %bestScore%
echo.
powershell -NoProfile -Command "$o=''; for($i=0;$i -lt 200;$i++){$o+=[char](Get-Random -Min 32 -Max 255)}; Write-Host $o -FC Cyan"
echo.
pause
:: Reset variables for a fresh start
set score=0
set crabCount=1
set /a "cx[1]=10, cy[1]=5"
set "currentDir=w"
goto :menu
