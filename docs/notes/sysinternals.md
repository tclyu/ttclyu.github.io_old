# SysInternals - Process Monitor
#### Enable Boot Logging
```
Menu > Options > Enable Boot Logging
```
#### Execute ProcMon Remotely
```cmd
psexec \\10.15.232.21 /s /d procmon.exe /accepteula /quiet /backingfile c:\MyTemp\proc.pml
```
## Keywords
session
window station
window message
# SysInternals - WinDbg
#### Set Symbol server
https://docs.microsoft.com/zh-cn/windows-hardware/drivers/debugger/microsoft-public-symbols
```cmd
set _NT_SYMBOL_PATH=srv*DownstreamStore*https://msdl.microsoft.com/download/symbols
```
