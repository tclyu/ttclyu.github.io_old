# WinDbg
#### Set Symbol server
https://docs.microsoft.com/zh-cn/windows-hardware/drivers/debugger/microsoft-public-symbols
https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/symbol-path
```
.sympath cache*c:\msft_symbols;srv*https://msdl.microsoft.com/download/symbols
```
Execute in command prompt
```
set _NT_SYMBOL_PATH=srv*c:\msft_symbols*https://msdl.microsoft.com/download/symbols
```
