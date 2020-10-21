# WinDbg
#### Set Symbol server
https://docs.microsoft.com/zh-cn/windows-hardware/drivers/debugger/microsoft-public-symbols
https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/symbol-path
```
.sympath cache*c:\msft-symbols;srv*https://msdl.microsoft.com/download/symbols
```
```cmd
set _NT_SYMBOL_PATH=srv*DownstreamStore*https://msdl.microsoft.com/download/symbols
```
