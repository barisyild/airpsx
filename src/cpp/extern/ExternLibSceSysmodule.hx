package cpp.extern;

#if orbis
@:keep
@:include('libSceSysmodule.h')
extern class ExternLibSceSysmodule {
    @:native('sceSysmoduleLoadModule')
    public static function sceSysmoduleLoadModule(moduleId:OrbisSysModule):Int32;

    @:native('sceSysmoduleLoadModuleInternal')
    public static function sceSysmoduleLoadModuleInternal(moduleId:OrbisSysModuleInternal):Int32;
}

enum abstract OrbisSysModuleInternal(UInt32) from UInt32 to UInt32 {
    var ORBIS_SYSMODULE_INTERNAL_AUDIOOUT = 0x80000001; // libSceAudioOut
    var ORBIS_SYSMODULE_INTERNAL_AUDIOIN = 0x80000002; // libSceAudioIn
    var ORBIS_SYSMODULE_INTERNAL_AV_CAPTURE = 0x80000003; // libSceAvcap
    var ORBIS_SYSMODULE_INTERNAL_SYSCORE = 0x80000004; // libSceSysCore
    var ORBIS_SYSMODULE_INTERNAL_CDLG_UTILITY_SERVER = 0x80000007; // libSceCdlgUtilServer
    var ORBIS_SYSMODULE_INTERNAL_KEYBOARD = 0x80000008; // libSceKeyboard
    var ORBIS_SYSMODULE_INTERNAL_NETCTL = 0x80000009; // libSceNetCtl
    var ORBIS_SYSMODULE_INTERNAL_HTTP = 0x8000000A; // libSceHttp
    var ORBIS_SYSMODULE_INTERNAL_SSL = 0x8000000B; // libSceSsl
    var ORBIS_SYSMODULE_INTERNAL_NP_COMMON = 0x8000000C; // libSceNpCommon
    var ORBIS_SYSMODULE_INTERNAL_NP_MANAGER = 0x8000000D; // libSceNpManager
    var ORBIS_SYSMODULE_INTERNAL_NP_WEB_API = 0x8000000E; // libSceNpWebApi
    var ORBIS_SYSMODULE_INTERNAL_SAVE_DATA = 0x8000000F; // libSceSaveData
    var ORBIS_SYSMODULE_INTERNAL_SYSTEM_SERVICE = 0x80000010; // libSceSystemService
    var ORBIS_SYSMODULE_INTERNAL_USER_SERVICE = 0x80000011; // libSceUserService
    var ORBIS_SYSMODULE_INTERNAL_VISION_MANAGER = 0x80000012; // libSceVisionManager
    var ORBIS_SYSMODULE_INTERNAL_AC3_ENC = 0x80000013; // libSceAc3Enc
    var ORBIS_SYSMODULE_INTERNAL_APP_INST_UTIL = 0x80000014; // libSceAppInstUtil
    var ORBIS_SYSMODULE_INTERNAL_VDECCORE = 0x80000015; // libSceVdecCore
    var ORBIS_SYSMODULE_INTERNAL_VENCCORE = 0x80000016; // libSceVencCore (file not found)
    var ORBIS_SYSMODULE_INTERNAL_HID_CONTROL = 0x80000017; // libSceHidControl
    var ORBIS_SYSMODULE_INTERNAL_COMMON_DIALOG = 0x80000018; // libSceCommonDialog
    var ORBIS_SYSMODULE_INTERNAL_PERF = 0x80000019; // libScePerf
    var ORBIS_SYSMODULE_INTERNAL_CAMERA = 0x8000001A; // libSceCamera
    var ORBIS_SYSMODULE_INTERNAL_NET = 0x8000001C; // libSceNet
    var ORBIS_SYSMODULE_INTERNAL_IPMI = 0x8000001D; // libSceIpmi
    var ORBIS_SYSMODULE_INTERNAL_VIDEO_OUT = 0x80000022; // libSceVideoOut
    var ORBIS_SYSMODULE_INTERNAL_BGFT = 0x8000002A; // libSceBgft
    var ORBIS_SYSMODULE_INTERNAL_PRECOMPILED_SHADERS = 0x80000064; // libScePrecompiledShaders
    var ORBIS_SYSMODULE_INTERNAL_PAD = 0x80000024; // libScePad
    var ORBIS_SYSMODULE_INTERNAL_SYS_UTIL= 0x80000026; // libSceSysUtil
}

enum abstract OrbisSysModule(UInt32) from UInt32 to UInt32 {
    var ORBIS_SYSMODULE_INVALID = 0x0000;
    var ORBIS_SYSMODULE_FIBER = 0x0006; // libSceFiber.sprx
    var ORBIS_SYSMODULE_ULT = 0x0007; // libSceUlt.sprx
    var ORBIS_SYSMODULE_NGS2 = 0x000B; // libSceNgs2.sprx
    var ORBIS_SYSMODULE_XML = 0x0017; // libSceXml.sprx
    var ORBIS_SYSMODULE_NP_UTILITY = 0x0019; // libSceNpUtility.sprx
    var ORBIS_SYSMODULE_VOICE = 0x001A; // libSceVoice.sprx
    var ORBIS_SYSMODULE_VOICEQOS = 0x001B; // libSceVoiceQos.sprx
    var ORBIS_SYSMODULE_NP_MATCHING2 = 0x001C; // libSceNpMatching2.sprx
    var ORBIS_SYSMODULE_NP_SCORE_RANKING = 0x001E; // libSceNpScoreRanking.sprx
    var ORBIS_SYSMODULE_RUDP = 0x0021; // libSceRudp.sprx
    var ORBIS_SYSMODULE_NP_TUS = 0x002C; // libSceNpTus.sprx
    var ORBIS_SYSMODULE_FACE = 0x0038;
    var ORBIS_SYSMODULE_SMART = 0x0039;
    var ORBIS_SYSMODULE_JSON = 0x0080;
    var ORBIS_SYSMODULE_GAME_LIVE_STREAMING = 0x0081; // libSceGameLiveStreaming.sprx
    var ORBIS_SYSMODULE_COMPANION_UTIL = 0x0082; // libSceCompanionUtil.sprx
    var ORBIS_SYSMODULE_PLAYGO = 0x0083; // libScePlayGo.sprx
    var ORBIS_SYSMODULE_FONT = 0x0084; // libSceFont.sprx
    var ORBIS_SYSMODULE_VIDEO_RECORDING = 0x0085; // libSceVideoRecording.sprx
    var ORBIS_SYSMODULE_S3DCONVERSION = 0x0086;
    var ORBIS_SYSMODULE_AUDIODEC = 0x0088; // libSceAudiodec.sprx
    var ORBIS_SYSMODULE_JPEG_DEC = 0x008A; // libSceJpegDec.sprx
    var ORBIS_SYSMODULE_JPEG_ENC = 0x008B; // libSceJpegEnc.sprx
    var ORBIS_SYSMODULE_PNG_DEC = 0x008C; // libScePngDec.sprx
    var ORBIS_SYSMODULE_PNG_ENC = 0x008D; // libScePngEnc.sprx
    var ORBIS_SYSMODULE_VIDEODEC = 0x008E; // libSceVideodec.sprx
    var ORBIS_SYSMODULE_MOVE = 0x008F; // libSceMove.sprx
    var ORBIS_SYSMODULE_PAD_TRACKER = 0x0091; // libScePadTracker.sprx
    var ORBIS_SYSMODULE_DEPTH = 0x0092; // libSceDepth.sprx
    var ORBIS_SYSMODULE_HAND = 0x0093;
    var ORBIS_SYSMODULE_LIBIME = 0x0095; // libSceIme.sprx
    var ORBIS_SYSMODULE_IME_DIALOG = 0x0096; // libSceImeDialog.sprx
    var ORBIS_SYSMODULE_NP_PARTY = 0x0097; // libSceNpParty.sprx
    var ORBIS_SYSMODULE_FONT_FT = 0x0098; // libSceFontFt.sprx
    var ORBIS_SYSMODULE_FREETYPE_OT = 0x0099; // libSceFreeTypeOt.sprx
    var ORBIS_SYSMODULE_FREETYPE_OL = 0x009A; // libSceFreeTypeOl.sprx
    var ORBIS_SYSMODULE_FREETYPE_OPT_OL = 0x009B; // libSceFreeTypeOptOl.sprx
    var ORBIS_SYSMODULE_SCREEN_SHOT = 0x009C; // libSceScreenShot.sprx
    var ORBIS_SYSMODULE_NP_AUTH = 0x009D; // libSceNpAuth.sprx
    var ORBIS_SYSMODULE_SULPHA = 0x009F;
    var ORBIS_SYSMODULE_SAVE_DATA_DIALOG = 0x00A0; // libSceSaveDataDialog.sprx
    var ORBIS_SYSMODULE_INVITATION_DIALOG = 0x00A2; // libSceInvitationDialog.sprx
    var ORBIS_SYSMODULE_DEBUG_KEYBOARD = 0x00A3;
    var ORBIS_SYSMODULE_MESSAGE_DIALOG = 0x00A4; // libSceMsgDialog.sprx
    var ORBIS_SYSMODULE_AV_PLAYER = 0x00A5; // libSceAvPlayer.sprx
    var ORBIS_SYSMODULE_CONTENT_EXPORT = 0x00A6; // libSceContentExport.sprx
    var ORBIS_SYSMODULE_AUDIO_3D = 0x00A7; // libSceAudio3d.sprx
    var ORBIS_SYSMODULE_NP_COMMERCE = 0x00A8; // libSceNpCommerce.sprx
    var ORBIS_SYSMODULE_MOUSE = 0x00A9; // libSceMouse.sprx
    var ORBIS_SYSMODULE_COMPANION_HTTPD = 0x00AA; // libSceCompanionHttpd.sprx
    var ORBIS_SYSMODULE_WEB_BROWSER_DIALOG = 0x00AB; // libSceWebBrowserDialog.sprx
    var ORBIS_SYSMODULE_ERROR_DIALOG = 0x00AC; // libSceErrorDialog.sprx
    var ORBIS_SYSMODULE_NP_TROPHY = 0x00AD; // libSceNpTrophy.sprx
    var ORBIS_SYSMODULE_VIDEO_CORE_IF = 0x00AE; // libSceVideoCoreInterface.sprx
    var ORBIS_SYSMODULE_VIDEO_CORE_SERVER_IF = 0x00AF; // libSceVideoCoreServerInterface.sprx
    var ORBIS_SYSMODULE_NP_SNS_FACEBOOK = 0x00B0; // libSceNpSnsFacebookDialog.sprx
    var ORBIS_SYSMODULE_MOVE_TRACKER = 0x00B1; // libSceMoveTracker.sprx
    var ORBIS_SYSMODULE_NP_PROFILE_DIALOG = 0x00B2; // libSceNpProfileDialog.sprx
    var ORBIS_SYSMODULE_NP_FRIEND_LIST_DIALOG = 0x00B3; // libSceNpFriendListDialog.sprx
    var ORBIS_SYSMODULE_APP_CONTENT = 0x00B4; // libSceAppContent.sprx
    var ORBIS_SYSMODULE_NP_SIGNALING = 0x00B5; // libSceNpSignaling.sprx
    var ORBIS_SYSMODULE_REMOTE_PLAY = 0x00B6; // libSceRemoteplay.sprx
    var ORBIS_SYSMODULE_USBD = 0x00B7; // libSceUsbd.sprx
    var ORBIS_SYSMODULE_GAME_CUSTOM_DATA_DIALOG = 0x00B8; // libSceGameCustomDataDialog.sprx
    var ORBIS_SYSMODULE_NP_EULA_DIALOG = 0x00B9; // libSceNpEulaDialog.sprx
    var ORBIS_SYSMODULE_RANDOM = 0x00BA; // libSceRandom.sprx
    var ORBIS_SYSMODULE_RESERVED2 = 0x00BB;
    var ORBIS_SYSMODULE_M4AAC_ENC = 0x00BC; // libSceM4aacEnc.sprx
    var ORBIS_SYSMODULE_AUDIODEC_CPU = 0x00BD; // libSceAudiodecCpu.sprx
    var ORBIS_SYSMODULE_AUDIODEC_CPU_DDP = 0x00BE; // libSceAudiodecCpuDdp.sprx
    var ORBIS_SYSMODULE_AUDIODEC_CPU_M4AAC = 0x00C0; // libSceAudiodecCpuM4aac.sprx
    var ORBIS_SYSMODULE_BEMP2_SYS = 0x00C1; // libSceBemp2sys.sprx
    var ORBIS_SYSMODULE_BEISOBMF = 0x00C2; // libSceBeisobmf.sprx
    var ORBIS_SYSMODULE_PLAY_READY = 0x00C3; // libScePlayReady.sprx
    var ORBIS_SYSMODULE_VIDEO_NATIVE_EXT_ESSENTIAL = 0x00C4; // libSceVideoNativeExtEssential.sprx
    var ORBIS_SYSMODULE_ZLIB = 0x00C5; // libSceZlib.sprx
    var ORBIS_SYSMODULE_DTCP_IP = 0x00C6; // libSceDtcpIp.sprx
    var ORBIS_SYSMODULE_CONTENT_SEARCH = 0x00C7; // libSceContentSearch.sprx
    var ORBIS_SYSMODULE_SHARE_UTILITY = 0x00C8; // libSceShareUtility.sprx
    var ORBIS_SYSMODULE_AUDIODEC_CPU_DTS_HD_LBR = 0x00C9; // libSceAudiodecCpuDtsHdLbr.sprx
    var ORBIS_SYSMODULE_DECI4H = 0x00CA;
    var ORBIS_SYSMODULE_HEAD_TRACKER = 0x00CB;
    var ORBIS_SYSMODULE_GAME_UPDATE = 0x00CC; // libSceGameUpdate.sprx
    var ORBIS_SYSMODULE_AUTO_MOUNTER_CLIENT = 0x00CD; // libSceAutoMounterClient.sprx
    var ORBIS_SYSMODULE_SYSTEM_GESTURE = 0x00CE; // libSceSystemGesture.sprx
    var ORBIS_SYSMODULE_VIDEODEC2 = 0x00CF;
    var ORBIS_SYSMODULE_VDECWRAP = 0x00D0; // libSceVdecwrap.sprx
    var ORBIS_SYSMODULE_AT9_ENC = 0x00D1; // libSceAt9Enc.sprx
    var ORBIS_SYSMODULE_CONVERT_KEYCODE = 0x00D2; // libSceConvertKeycode.sprx
    var ORBIS_SYSMODULE_SHARE_PLAY = 0x00D3; // libSceSharePlay.sprx
    var ORBIS_SYSMODULE_HMD = 0x00D4; // libSceHmd.sprx
    var ORBIS_SYSMODULE_USB_STORAGE = 0x00D5; // libSceUsbStorage.sprx
    var ORBIS_SYSMODULE_USB_STORAGE_DIALOG = 0x00D6; // libSceUsbStorageDialog.sprx
    var ORBIS_SYSMODULE_DISC_MAP = 0x00D7; // libSceDiscMap.sprx
    var ORBIS_SYSMODULE_FACE_TRACKER = 0x00D8;
    var ORBIS_SYSMODULE_HAND_TRACKER = 0x00D9;
    var ORBIS_SYSMODULE_NP_SNS_YOUTUBE_DIALOG = 0x00DA; // libSceNpSnsYouTubeDialog.sprx
    var ORBIS_SYSMODULE_PROFILE_CACHE_EXTERNAL = 0x00DC; // libSceProfileCacheExternal.sprx
    var ORBIS_SYSMODULE_MUSIC_PLAYER_SERVICE = 0x00DD; // libSceMusicPlayerService.sprx
    var ORBIS_SYSMODULE_SP_SYS_CALL_WRAPPER = 0x00DE; // libSceSpSysCallWrapper.sprx
    var ORBIS_SYSMODULE_PS2_EMU_MENU_DIALOG = 0x00DF; // libScePs2EmuMenuDialog.sprx
    var ORBIS_SYSMODULE_NP_SNS_DIALYMOTION_DIALOG = 0x00E0; // libSceNpSnsDailyMotionDialog.sprx
    var ORBIS_SYSMODULE_AUDIODEC_CPU_HEVAG = 0x00E1; // libSceAudiodecCpuHevag.sprx
    var ORBIS_SYSMODULE_LOGIN_DIALOG = 0x00E2; // libSceLoginDialog.sprx
    var ORBIS_SYSMODULE_LOGIN_SERVICE = 0x00E3; // libSceLoginService.sprx
    var ORBIS_SYSMODULE_SIGNIN_DIALOG = 0x00E4; // libSceSigninDialog.sprx
    var ORBIS_SYSMODULE_VDECSW = 0x00E5; // libSceVdecsw.sprx
    var ORBIS_SYSMODULE_CUSTOM_MUSIC_CORE = 0x00E6; // libSceCustomMusicCore.sprx
    var ORBIS_SYSMODULE_JSON2 = 0x00E7; // libSceJson2.sprx
    var ORBIS_SYSMODULE_AUDIO_LATENCY_ESTIMATION = 0x00E8;
    var ORBIS_SYSMODULE_WK_FONT_CONFIG = 0x00E9; // libSceWkFontConfig.sprx
    var ORBIS_SYSMODULE_RESERVED27 = 0x00EA;
    var ORBIS_SYSMODULE_HMD_SETUP_DIALOG = 0x00EB; // libSceHmdSetupDialog.sprx
    var ORBIS_SYSMODULE_RESERVED28 = 0x00EC;
    var ORBIS_SYSMODULE_VR_TRACKER = 0x00ED; // libSceVrTracker.sprx
    var ORBIS_SYSMODULE_CONTENT_DELETE = 0x00EE; // libSceContentDelete.sprx
    var ORBIS_SYSMODULE_IME_BACKEND = 0x00EF; // libSceImeBackend.sprx
    var ORBIS_SYSMODULE_NET_CTL_AP_DIALOG = 0x00F0; // libSceNetCtlApDialog.sprx
    var ORBIS_SYSMODULE_PLAYGO_DIALOG = 0x00F1; // libScePlayGoDialog.sprx
    var ORBIS_SYSMODULE_SOCIAL_SCREEN = 0x00F2; // libSceSocialScreen.sprx
    var ORBIS_SYSMODULE_EDIT_MP4 = 0x00F3; // libSceEditMp4.sprx
    var ORBIS_SYSMODULE_PSM_KIT_SYSTEM = 0x00F5; // libScePsmKitSystem.sprx
    var ORBIS_SYSMODULE_TEXT_TO_SPEECH = 0x00F6; // libSceTextToSpeech.sprx
    var ORBIS_SYSMODULE_NP_TOOLKIT = 0x00F7;
    var ORBIS_SYSMODULE_CUSTOM_MUSIC_SERVICE = 0x00F8; // libSceCustomMusicService.sprx
    var ORBIS_SYSMODULE_CL_SYS_CALL_WRAPPER = 0x00F9; // libSceClSysCallWrapper.sprx
    var ORBIS_SYSMODULE_SYSTEM_LOGGER = 0x00FA; // libSceSystemLogger.sprx
    var ORBIS_SYSMODULE_BLUETOOTH_HID = 0x00FB; // libSceBluetoothHid.sprx
    var ORBIS_SYSMODULE_VIDEO_DECODER_ARBITRATION = 0x00FC; // libSceVideoDecoderArbitration.sprx
    var ORBIS_SYSMODULE_VR_SERVICE_DIALOG = 0x00FD; // libSceVrServiceDialog.sprx
    var ORBIS_SYSMODULE_JOB_MANAGER = 0x00FE;
    var ORBIS_SYSMODULE_KEYBOARD = 0x0106;
}
#end