常用命令：
Process： !process [0 0]；dt nt!_eprocess；dt nt!_kprocess；
Thread： !thread；dt nt!_ethread；dt nt!_kthread；
I/O Request： dt nt!_irp；!irpfind；

lkd> dt nt!_kevent
lkd> dt nt!_kmutant
lkd> dt nt!_ksemaphore
lkd> !job
lkd> !session
lkd> !vm
