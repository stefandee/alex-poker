if not exist ./obj mkdir obj

fpc -Mtp -WG -FU./obj POKER.PAS
@if %ERRORLEVEL% GEQ 1 EXIT /B %ERRORLEVEL%

poker.exe