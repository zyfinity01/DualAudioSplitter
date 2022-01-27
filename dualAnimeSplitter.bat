@echo off

title DualAnimeSplitter

::This is your mkvmerge install path
set mkvmerge="%~dp0tools\mkvtoolnix\mkvmerge.exe" 
set JQ="%~dp0tools\jq-win64.exe" 

cls


:ID
echo.
echo This batch script will allow you to identify english audio/ subtitle tracks alongside japanese audio / english subtitle tracks and split the two. The changes will be made to copies of the files and the originals will remain untouched. For this reason, please make sure you have enough disk space for the output files (3x original files size).
for %%i in (%~dp0dropHere\*.MKV) do (%mkvmerge% -J "%%i" | JQ -r ".file_name" 
%mkvmerge% -J "%%i" | jq -r ".tracks | map(\"ID: \" + (.id | tostring) + \" \" + \" Language: \" + .properties.language + \"  Track Name: \" + .properties.track_name + \"  Codec: \" + .codec)" 
GOTO SELECTSUBBEDAUDIO)
echo.
pause

:SELECTSUBBEDAUDIO
echo.
echo For the Subbed copy of the show:
echo The first track you enter will be set as default
set /p SUBBEDAT=Type the track ID(s) of the audio track(s) you would like to KEEP, seperated by commas. For multiple tracks, enclose the entire statement in quotes:

:SELECTSUBBEDSUBS
echo.
echo The first track you enter will be set as default
set /p SUBBEDST=Type the track ID(s) of the subtitle track(s) you would like to KEEP, seperated by commas. For multiple tracks, enclose the entire statement in quotes:

:SELECTDUBBEDAUDIO
echo.
echo -----------------------------
echo For the Dubbed copy of the show:
echo The first track you enter will be set as default
set /p DUBBEDAT=Type the track ID(s) of the audio track(s) you would like to KEEP, seperated by commas. For multiple tracks, enclose the entire statement in quotes:

:SELECTDUBBEDSUBS
echo.
echo The first track you enter will be set as forced
set /p DUBBEDST=Type the track ID(s) of the subtitle track(s) you would like to KEEP, seperated by commas. For multiple tracks, enclose the entire statement in quotes:

::calculate default audio and subbed tracks
setlocal
set /A SUBBEDATDEFAULT=%SUBBEDAT%
set /A SUBBEDSTDEFAULT=%SUBBEDST%
set /A DUBBEDATDEFAULT=%DUBBEDAT%
set /A DUBBEDSTFORCED=%DUBBEDST%
pause





FOR /F "delims=*" %%A IN ('dir %~dp0dropHere\ /b *.MKV') DO %mkvmerge% -o "%cd%/subbed/%%A" --atracks "%SUBBEDAT%" --stracks "%SUBBEDST%" --default-track "%SUBBEDATDEFAULT%" --default-track "%SUBBEDSTDEFAULT%" --compression -1:none "%~dp0dropHere\%%A"
FOR /F "delims=*" %%A IN ('dir %~dp0dropHere\ /b *.MKV') DO %mkvmerge% -o "%cd%/dubbed/%%A" --atracks "%DUBBEDAT%" --stracks "%DUBBEDST%" --default-track "%DUBBEDATDEFAULT%" --forced-track "%DUBBEDSTFORCED%" --compression -1:none "%~dp0dropHere\%%A"


::FOR /F "delims=*" %%A IN ('dir %~dp0dropHere\ /b /a-d-h-s *.MKV') DO %mkvmerge% -o "%cd%/subbed/%%A" --atracks "%SUBBEDAT%" --stracks "%SUBBEDST%" --default-track "%SUBBEDATDEFAULT%" --default-track "%SUBBEDSTDEFAULT%" --compression -1:none "%~dp0dropHere\%%A"
::FOR /F "delims=*" %%A IN ('dir %~dp0dropHere\ /b /a-d-h-s *.MKV') DO (%mkvmerge% -o "%cd%/dubbed/%%A" --atracks "%DUBBEDAT%" --stracks "%DUBBEDST%" --default-track "%DUBBEDATDEFAULT%" --forced-track "%DUBBEDSTFORCED%" --compression -1:none "%~dp0dropHere\%%A"
::del "%~dp0\dropHere\%%A")
PAUSE