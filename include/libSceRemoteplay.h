extern "C" {
    int sceRemoteplayInitialize(int, size_t);
    int sceRemoteplayTerminate();
    int sceRemoteplayGeneratePinCode(uint32_t*);
    int sceRemoteplayConfirmDeviceRegist(int*, int*);
    int sceRemoteplayNotifyPinCodeError(int);
}