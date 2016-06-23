@echo off

SET PBOCONSOLE="C:\Program Files\PBO Manager v.1.4 beta\PBOConsole"
SET ADDONSDIR=%~dp0

for %%f in (.\*.pbo) do (
    echo "delete: "%%f
    del /q %ADDONSDIR%\%%f
)

for /D %%s in (.\*) do (
    echo "pack: "%%s
    %PBOCONSOLE% -pack %ADDONSDIR%\%%s %ADDONSDIR%\%%s.pbo
)