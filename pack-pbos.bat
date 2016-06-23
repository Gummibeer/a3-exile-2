@echo off

SET PBOCONSOLE="C:\Program Files\PBO Manager v.1.4 beta\PBOConsole"
SET BASEDIR=%~dp0

echo base: %BASEDIR%

for %%x in (@ExileServer\addons mpmissions) do (
    echo search in: %BASEDIR%%%x

    for %%f in (%BASEDIR%%%x\*.pbo) do (
        echo delete: %%f
        del /q %%f
    )

    for /D %%s in (%BASEDIR%%%x\*) do (
        echo pack: %%s
        %PBOCONSOLE% -pack %%s %%s.pbo
    )
)