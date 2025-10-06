extern "C" {
    int sceRegMgrGetInt(long, int*);
    int sceRegMgrGetStr(long, char*, int);
    int sceRegMgrGetBin(long, void*, int);

    int sceRegMgrSetInt(long, int);
    int sceRegMgrSetBin(long, const void*, int);
    int sceRegMgrSetStr(long, const char*, int);
}