#ifndef __PROSPERO__
#include <sys/resource.h>
#include <sys/priority.h>
#include <sys/types.h>
#include <stdint.h>
#include <sys/types.h>
#include <sys/param.h>

extern "C" {
    /* FreeBSD-compatible typedefs */
    typedef uint32_t vm_size_t;   /* size of virtual memory */
    typedef int64_t segsz_t;     /* segment size (pages) */
    typedef uint32_t fixpt_t;     /* fixed point type */
    typedef int32_t lwpid_t;     /* light-weight process id */

    #define	KI_NSPARE_INT	4
    #define	KI_NSPARE_LONG	12
    #define	KI_NSPARE_PTR	6

    #define	WMESGLEN	8		/* size of returned wchan message */
    #define	LOCKNAMELEN	8		/* size of returned lock name */
    #define	TDNAMLEN	16		/* size of returned thread name */
    #define	COMMLEN		19		/* size of returned ki_comm name */
    #define	KI_EMULNAMELEN	16		/* size of returned ki_emul */
    #define	KI_NGROUPS	16		/* number of groups in ki_groups */
    #define	LOGNAMELEN	17		/* size of returned ki_login */
    #define	LOGINCLASSLEN	17		/* size of returned ki_loginclass */

    struct kinfo_proc {
    	int	ki_structsize;		/* size of this structure */
    	int	ki_layout;		/* reserved: layout identifier */
    	struct	pargs *ki_args;		/* address of command arguments */
    	struct	proc *ki_paddr;		/* address of proc */
    	struct	user *ki_addr;		/* kernel virtual addr of u-area */
    	struct	vnode *ki_tracep;	/* pointer to trace file */
    	struct	vnode *ki_textvp;	/* pointer to executable file */
    	struct	filedesc *ki_fd;	/* pointer to open file info */
    	struct	vmspace *ki_vmspace;	/* pointer to kernel vmspace struct */
    	void	*ki_wchan;		/* sleep address */
    	pid_t	ki_pid;			/* Process identifier */
    	pid_t	ki_ppid;		/* parent process id */
    	pid_t	ki_pgid;		/* process group id */
    	pid_t	ki_tpgid;		/* tty process group id */
    	pid_t	ki_sid;			/* Process session ID */
    	pid_t	ki_tsid;		/* Terminal session ID */
    	short	ki_jobc;		/* job control counter */
    	short	ki_spare_short1;	/* unused (just here for alignment) */
    	dev_t	ki_tdev;		/* controlling tty dev */
    	sigset_t ki_siglist;		/* Signals arrived but not delivered */
    	sigset_t ki_sigmask;		/* Current signal mask */
    	sigset_t ki_sigignore;		/* Signals being ignored */
    	sigset_t ki_sigcatch;		/* Signals being caught by user */
    	uid_t	ki_uid;			/* effective user id */
    	uid_t	ki_ruid;		/* Real user id */
    	uid_t	ki_svuid;		/* Saved effective user id */
    	gid_t	ki_rgid;		/* Real group id */
    	gid_t	ki_svgid;		/* Saved effective group id */
    	short	ki_ngroups;		/* number of groups */
    	short	ki_spare_short2;	/* unused (just here for alignment) */
    	gid_t	ki_groups[KI_NGROUPS];	/* groups */
    	vm_size_t ki_size;		/* virtual size */
    	segsz_t ki_rssize;		/* current resident set size in pages */
    	segsz_t ki_swrss;		/* resident set size before last swap */
    	segsz_t ki_tsize;		/* text size (pages) XXX */
    	segsz_t ki_dsize;		/* data size (pages) XXX */
    	segsz_t ki_ssize;		/* stack size (pages) */
    	u_short	ki_xstat;		/* Exit status for wait & stop signal */
    	u_short	ki_acflag;		/* Accounting flags */
    	fixpt_t	ki_pctcpu;	 	/* %cpu for process during ki_swtime */
    	u_int	ki_estcpu;	 	/* Time averaged value of ki_cpticks */
    	u_int	ki_slptime;	 	/* Time since last blocked */
    	u_int	ki_swtime;	 	/* Time swapped in or out */
    	u_int	ki_cow;			/* number of copy-on-write faults */
    	u_int64_t ki_runtime;		/* Real time in microsec */
    	struct	timeval ki_start;	/* starting time */
    	struct	timeval ki_childtime;	/* time used by process children */
    	long	ki_flag;		/* P_* flags */
    	long	ki_kiflag;		/* KI_* flags (below) */
    	int	ki_traceflag;		/* Kernel trace points */
    	char	ki_stat;		/* S* process status */
    	signed char ki_nice;		/* Process "nice" value */
    	char	ki_lock;		/* Process lock (prevent swap) count */
    	char	ki_rqindex;		/* Run queue index */
    	u_char	ki_oncpu_old;		/* Which cpu we are on (legacy) */
    	u_char	ki_lastcpu_old;		/* Last cpu we were on (legacy) */
    	char	ki_tdname[TDNAMLEN+1];	/* thread name */
    	char	ki_wmesg[WMESGLEN+1];	/* wchan message */
    	char	ki_login[LOGNAMELEN+1];	/* setlogin name */
    	char	ki_lockname[LOCKNAMELEN+1]; /* lock name */
    	char	ki_comm[COMMLEN+1];	/* command name */
    	char	ki_emul[KI_EMULNAMELEN+1];  /* emulation name */
    	char	ki_loginclass[LOGINCLASSLEN+1]; /* login class */
    	/*
    	 * When adding new variables, take space for char-strings from the
    	 * front of ki_sparestrings, and ints from the end of ki_spareints.
    	 * That way the spare room from both arrays will remain contiguous.
    	 */
    	char	ki_sparestrings[50];	/* spare string space */
    	int	ki_spareints[KI_NSPARE_INT];	/* spare room for growth */
    	int	ki_oncpu;		/* Which cpu we are on */
    	int	ki_lastcpu;		/* Last cpu we were on */
    	int	ki_tracer;		/* Pid of tracing process */
    	int	ki_flag2;		/* P2_* flags */
    	int	ki_fibnum;		/* Default FIB number */
    	u_int	ki_cr_flags;		/* Credential flags */
    	int	ki_jid;			/* Process jail ID */
    	int	ki_numthreads;		/* XXXKSE number of threads in total */
    	lwpid_t	ki_tid;			/* XXXKSE thread id */
    	struct	priority ki_pri;	/* process priority */
    	struct	rusage ki_rusage;	/* process rusage statistics */
    	/* XXX - most fields in ki_rusage_ch are not (yet) filled in */
    	struct	rusage ki_rusage_ch;	/* rusage of children processes */
    	struct	pcb *ki_pcb;		/* kernel virtual addr of pcb */
    	void	*ki_kstack;		/* kernel virtual addr of stack */
    	void	*ki_udata;		/* User convenience pointer */
    	struct	thread *ki_tdaddr;	/* address of thread */
    	/*
    	 * When adding new variables, take space for pointers from the
    	 * front of ki_spareptrs, and longs from the end of ki_sparelongs.
    	 * That way the spare room from both arrays will remain contiguous.
    	 */
    	void	*ki_spareptrs[KI_NSPARE_PTR];	/* spare room for growth */
    	long	ki_sparelongs[KI_NSPARE_LONG];	/* spare room for growth */
    	long	ki_sflag;		/* PS_* flags */
    	long	ki_tdflags;		/* XXXKSE kthread flag */
    };
}
#endif