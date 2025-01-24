extern "C" {
    int sceNetInit();
    int sceNetTerm();
    int sceNetShowIfconfig();
    int sceNetShowNetstat();
    int sceNetShowPolicy();
    int sceNetShowRoute();
    int sceNetShowRoute6();
    int sceNetConfigRoutingShowRoutingConfig();
    int sceNetConfigRoutingShowtCtlVar();
    int sceNetShowNetstatForBuffer(void *buffer, unsigned int size);
}