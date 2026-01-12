extern "C" {

    int sceKernelGetHwSerialNumber(char *);
    int sceKernelGetHwModelName(char *);
    #ifndef __PROSPERO__
    typeof(sceKernelGetHwSerialNumber)* f_sceKernelGetHwSerialNumber;
    int (*f_sceKernelGetHwModelName)(char *) = 0;
    #endif

}