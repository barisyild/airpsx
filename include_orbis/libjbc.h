extern "C" {
    typedef uint32_t uid_t;
    typedef uint32_t gid_t;

    struct jbc_cred
    {
        uid_t uid;
        uid_t ruid;
        uid_t svuid;
        gid_t rgid;
        gid_t svgid;
        uintptr_t prison;
        uintptr_t cdir;
        uintptr_t rdir;
        uintptr_t jdir;
        uint64_t sceProcType;
        uint64_t sonyCred;
        uint64_t sceProcCap;
    };

    int jbc_get_cred(struct jbc_cred*);
    int jbc_jailbreak_cred(struct jbc_cred*);
    int jbc_set_cred(const struct jbc_cred*);
    bool is_jailbroken();
}