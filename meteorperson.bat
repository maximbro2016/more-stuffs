@echo off
setlocal enabledelayedexpansion
:: Set UTF-8 for House Symbol (⌂)
chcp 65001 >nul

:: Fix: Generates ESC character safely for ALL terminals
for /F "delims=#" %%a in ('"prompt #$E# & for %%a in (1) do rem"') do set "E=%%a"

:: Define Visuals (Binary Sky System)
set "SKY=%E%[94m█%E%[0m"
set "HOUSE=%E%[97m⌂%E%[0m"
set "MET_TOP=%E%[91m▀%E%[0m"
:: Code 93 is Bright Yellow/Orange - It cannot be black in any theme
set "MET_BOT=%E%[93m▄%E%[0m"

:: Game Start State
set "pX=10"
set "score=0"
:: Setup 6 Meteors (Binary 1s)
for /L %%i in (1,1,6) do (
    set /a "m%%i_x=!random! %% 20"
    set /a "m%%i_y=!random! %% 10 - 15"
)

:GAME_LOOP
cls
echo SCORE: !score! ^| A-Left D-Right
echo --------------------

:: Render 10x20 Binary Sky Grid
for /L %%y in (0,1,10) do (
    set "line="
    for /L %%x in (0,1,20) do (
        set "tile=!SKY!"
        :: Loop through 6 potential meteors
        for /L %%m in (1,1,6) do (
            if %%x==!m%%m_x! if %%y==!m%%m_y! set "tile=!MET_TOP!"
            if %%x==!m%%m_x! if %%y==!m%%m_y!-1 set "tile=!MET_BOT!"
        )
        if %%x==!pX! if %%y==10 set "tile=!HOUSE!"
        set "line=!line!!tile!"
    )
    echo !line!
)

:: Physics & Collision Logic
for /L %%m in (1,1,6) do (
    set /a "m%%m_y+=1"
    if !m%%m_y! GTR 11 (
        set /a "m%%m_x=!random! %% 20"
        set /a "m%%m_y=0"
        set /a "score+=1"
    )
    :: Collision Detection
    if !m%%m_x!==!pX! if !m%%m_y!==10 goto GAME_OVER
)

:: Movement (1-second tick)
choice /c AD /n /t 1 /d A >nul
if %errorlevel%==1 if !pX! GTR 0 set /a "pX-=1"
if %errorlevel%==2 if !pX! LSS 20 set /a "pX+=1"

goto GAME_LOOP

:GAME_OVER
echo.
echo %E%[91mYour house was hit!%E%[0m
echo %E%[93mFinal Score: !score!%E%[0m
echo.
echo Press any key to exit...
pause >nul
exit
