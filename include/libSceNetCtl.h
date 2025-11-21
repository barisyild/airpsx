extern "C" {
    typedef struct SceNetEtherAddr {
        uint8_t data[6];
    } SceNetEtherAddr;

    typedef union SceNetCtlInfo
    {
    	uint32_t device;
    	SceNetEtherAddr ether_addr;
    	uint32_t mtu;
    	uint32_t link;
    	SceNetEtherAddr bssid;
    	char ssid[33];
    	uint32_t wifi_security;
    	int32_t rssi_dbm;
    	uint8_t rssi_percentage;
    	uint8_t channel;
    	uint32_t ip_config;
    	char dhcp_hostname[256];
    	char pppoe_auth_name[128];
    	char ip_address[16];
    	char netmask[16];
    	char default_route[16];
    	char primary_dns[16];
    	char secondary_dns[16];
    	uint32_t http_proxy_config;
    	char http_proxy_server[256];
    	uint16_t http_proxy_port;
    } SceNetCtlInfo;

    int sceNetCtlInit(void);
    int sceNetCtlTerm(void);
    int sceNetCtlGetInfo(int s, SceNetCtlInfo *b);
}