! Commonly used Windows constants

! WinHelp constants
DCL_API_HELP_COMMAND                        EQUATE(0102h)
DCL_API_HELP_CONTEXT                        EQUATE(0001H)  ! Display topic in ulTopic
DCL_API_HELP_KEY                            EQUATE(0101h)
DCL_API_HELP_PARTIALKEY                     EQUATE(0105h)
DCL_API_HELP_QUIT                           EQUATE(0002H)  ! Terminate help
DCL_API_HELP_FINDER                         EQUATE(000bH)
DCL_API_HELP_HELPONHELP                     EQUATE(0004h)
DCL_API_HELP_INDEX                          EQUATE(0003h)
DCL_API_WM_HELP                             EQUATE(0053h)

DCL_API_ERROR_SUCCESS                       EQUATE(0)
DCL_API_ERROR_INVALID_FUNCTION              EQUATE(1)
DCL_API_ERROR_FILE_NOT_FOUND                EQUATE(2)
DCL_API_ERROR_PATH_NOT_FOUND                EQUATE(3)
DCL_API_ERROR_TOO_MANY_OPEN_FILES           EQUATE(4)
DCL_API_ERROR_ACCESS_DENIED                 EQUATE(5)
DCL_API_ERROR_INVALID_HANDLE                EQUATE(6)
DCL_API_ERROR_ARENA_TRASHED                 EQUATE(7)
DCL_API_ERROR_NOT_ENOUGH_MEMORY             EQUATE(8)
DCL_API_ERROR_INVALID_BLOCK                 EQUATE(9)
DCL_API_ERROR_BAD_ENVIRONMENT               EQUATE(10)
DCL_API_ERROR_BAD_FORMAT                    EQUATE(11)
DCL_API_ERROR_INVALID_ACCESS                EQUATE(12)
DCL_API_ERROR_INVALID_DATA                  EQUATE(13)
DCL_API_ERROR_OUTOFMEMORY                   EQUATE(14)
DCL_API_ERROR_INVALID_DRIVE                 EQUATE(15)
DCL_API_ERROR_CURRENT_DIRECTORY             EQUATE(16)
DCL_API_ERROR_NOT_SAME_DEVICE               EQUATE(17)
DCL_API_ERROR_NO_MORE_FILES                 EQUATE(18)
DCL_API_ERROR_WRITE_PROTECT                 EQUATE(19)
DCL_API_ERROR_BAD_UNIT                      EQUATE(20)
DCL_API_ERROR_NOT_READY                     EQUATE(21)
DCL_API_ERROR_BAD_COMMAND                   EQUATE(22)
DCL_API_ERROR_CRC                           EQUATE(23)
DCL_API_ERROR_BAD_LENGTH                    EQUATE(24)
DCL_API_ERROR_SEEK                          EQUATE(25)
DCL_API_ERROR_NOT_DOS_DISK                  EQUATE(26)
DCL_API_ERROR_SECTOR_NOT_FOUND              EQUATE(27)
DCL_API_ERROR_OUT_OF_PAPER                  EQUATE(28)
DCL_API_ERROR_WRITE_FAULT                   EQUATE(29)
DCL_API_ERROR_READ_FAULT                    EQUATE(30)
DCL_API_ERROR_GEN_FAILURE                   EQUATE(31)
DCL_API_ERROR_SHARING_VIOLATION             EQUATE(32)
DCL_API_ERROR_LOCK_VIOLATION                EQUATE(33)
DCL_API_ERROR_WRONG_DISK                    EQUATE(34)
DCL_API_ERROR_SHARING_BUFFER_EXCEEDED       EQUATE(36)
DCL_API_ERROR_HANDLE_EOF                    EQUATE(38)
DCL_API_ERROR_HANDLE_DISK_FULL              EQUATE(39)
DCL_API_ERROR_NOT_SUPPORTED                 EQUATE(50)
DCL_API_ERROR_REM_NOT_LIST                  EQUATE(51)
DCL_API_ERROR_DUP_NAME                      EQUATE(52)
DCL_API_ERROR_BAD_NETPATH                   EQUATE(53)
DCL_API_ERROR_NETWORK_BUSY                  EQUATE(54)
DCL_API_ERROR_DEV_NOT_EXIST                 EQUATE(55)
DCL_API_ERROR_TOO_MANY_CMDS                 EQUATE(56)
DCL_API_ERROR_ADAP_HDW_ERR                  EQUATE(57)
DCL_API_ERROR_BAD_NET_RESP                  EQUATE(58)
DCL_API_ERROR_UNEXP_NET_ERR                 EQUATE(59)
DCL_API_ERROR_BAD_REM_ADAP                  EQUATE(60)
DCL_API_ERROR_PRINTQ_FULL                   EQUATE(61)
DCL_API_ERROR_NO_SPOOL_SPACE                EQUATE(62)
DCL_API_ERROR_PRINT_CANCELLED               EQUATE(63)
DCL_API_ERROR_NETNAME_DELETED               EQUATE(64)
DCL_API_ERROR_NETWORK_ACCESS_DENIED         EQUATE(65)
DCL_API_ERROR_BAD_DEV_TYPE                  EQUATE(66)
DCL_API_ERROR_BAD_NET_NAME                  EQUATE(67)
DCL_API_ERROR_TOO_MANY_NAMES                EQUATE(68)
DCL_API_ERROR_TOO_MANY_SESS                 EQUATE(69)
DCL_API_ERROR_SHARING_PAUSED                EQUATE(70)
DCL_API_ERROR_REQ_NOT_ACCEP                 EQUATE(71)
DCL_API_ERROR_REDIR_PAUSED                  EQUATE(72)
DCL_API_ERROR_FILE_EXISTS                   EQUATE(80)
DCL_API_ERROR_CANNOT_MAKE                   EQUATE(82)
DCL_API_ERROR_FAIL_I24                      EQUATE(83)
DCL_API_ERROR_OUT_OF_STRUCTURES             EQUATE(84)
DCL_API_ERROR_ALREADY_ASSIGNED              EQUATE(85)
DCL_API_ERROR_INVALID_PASSWORD              EQUATE(86)
DCL_API_ERROR_INVALID_PARAMETER             EQUATE(87)
DCL_API_ERROR_NET_WRITE_FAULT               EQUATE(88)
DCL_API_ERROR_NO_PROC_SLOTS                 EQUATE(89)
DCL_API_ERROR_TOO_MANY_SEMAPHORES           EQUATE(100)
DCL_API_ERROR_EXCL_SEM_ALREADY_OWNED        EQUATE(101)
DCL_API_ERROR_SEM_IS_SET                    EQUATE(102)
DCL_API_ERROR_TOO_MANY_SEM_REQUESTS         EQUATE(103)
DCL_API_ERROR_INVALID_AT_INTERRUPT_TIME     EQUATE(104)
DCL_API_ERROR_SEM_OWNER_DIED                EQUATE(105)
DCL_API_ERROR_SEM_USER_LIMIT                EQUATE(106)
DCL_API_ERROR_DISK_CHANGE                   EQUATE(107)
DCL_API_ERROR_DRIVE_LOCKED                  EQUATE(108)
DCL_API_ERROR_BROKEN_PIPE                   EQUATE(109)
DCL_API_ERROR_OPEN_FAILED                   EQUATE(110)
DCL_API_ERROR_BUFFER_OVERFLOW               EQUATE(111)
DCL_API_ERROR_DISK_FULL                     EQUATE(112)
DCL_API_ERROR_NO_MORE_SEARCH_HANDLES        EQUATE(113)
DCL_API_ERROR_INVALID_TARGET_HANDLE         EQUATE(114)
DCL_API_ERROR_INVALID_CATEGORY              EQUATE(117)
DCL_API_ERROR_INVALID_VERIFY_SWITCH         EQUATE(118)
DCL_API_ERROR_BAD_DRIVER_LEVEL              EQUATE(119)
DCL_API_ERROR_CALL_NOT_IMPLEMENTED          EQUATE(120)
DCL_API_ERROR_SEM_TIMEOUT                   EQUATE(121)
DCL_API_ERROR_INSUFFICIENT_BUFFER           EQUATE(122)
DCL_API_ERROR_INVALID_NAME                  EQUATE(123)
DCL_API_ERROR_INVALID_LEVEL                 EQUATE(124)
DCL_API_ERROR_NO_VOLUME_LABEL               EQUATE(125)
DCL_API_ERROR_MOD_NOT_FOUND                 EQUATE(126)
DCL_API_ERROR_PROC_NOT_FOUND                EQUATE(127)
DCL_API_ERROR_WAIT_NO_CHILDREN              EQUATE(128)
DCL_API_ERROR_CHILD_NOT_COMPLETE            EQUATE(129)
DCL_API_ERROR_DIRECT_ACCESS_HANDLE          EQUATE(130)
DCL_API_ERROR_NEGATIVE_SEEK                 EQUATE(131)
DCL_API_ERROR_SEEK_ON_DEVICE                EQUATE(132)
DCL_API_ERROR_IS_JOIN_TARGET                EQUATE(133)
DCL_API_ERROR_IS_JOINED                     EQUATE(134)
DCL_API_ERROR_IS_SUBSTED                    EQUATE(135)
DCL_API_ERROR_NOT_JOINED                    EQUATE(136)
DCL_API_ERROR_NOT_SUBSTED                   EQUATE(137)
DCL_API_ERROR_JOIN_TO_JOIN                  EQUATE(138)
DCL_API_ERROR_SUBST_TO_SUBST                EQUATE(139)
DCL_API_ERROR_JOIN_TO_SUBST                 EQUATE(140)
DCL_API_ERROR_SUBST_TO_JOIN                 EQUATE(141)
DCL_API_ERROR_BUSY_DRIVE                    EQUATE(142)
DCL_API_ERROR_SAME_DRIVE                    EQUATE(143)
DCL_API_ERROR_DIR_NOT_ROOT                  EQUATE(144)
DCL_API_ERROR_DIR_NOT_EMPTY                 EQUATE(145)
DCL_API_ERROR_IS_SUBST_PATH                 EQUATE(146)
DCL_API_ERROR_IS_JOIN_PATH                  EQUATE(147)
DCL_API_ERROR_PATH_BUSY                     EQUATE(148)
DCL_API_ERROR_IS_SUBST_TARGET               EQUATE(149)
DCL_API_ERROR_SYSTEM_TRACE                  EQUATE(150)
DCL_API_ERROR_INVALID_EVENT_COUNT           EQUATE(151)
DCL_API_ERROR_TOO_MANY_MUXWAITERS           EQUATE(152)
DCL_API_ERROR_ALREADY_EXISTS                EQUATE(183)
DCL_API_ERROR_NO_MORE_ITEMS                 equate( 259 )

DCL_API_FORMAT_MESSAGE_IGNORE_INSERTS       equate(000200h)
DCL_API_FORMAT_MESSAGE_FROM_SYSTEM          equate(001000h)
DCL_API_FORMAT_MESSAGE_MAX_WIDTH_MASK       EQUATE(000000FFH)
DCL_API_LANG_USER_DEFAULT                   EQUATE(400H)

DCL_API_S_OK                                EQUATE(0)
DCL_API_S_FALSE                             EQUATE(1)

DCL_API_FILE_NOTIFY_CHANGE_FILE_NAME        equate(00000001h)
DCL_API_FILE_NOTIFY_CHANGE_DIR_NAME         equate(00000002h)
DCL_API_FILE_NOTIFY_CHANGE_ATTRIBUTES       equate(00000004h)
DCL_API_FILE_NOTIFY_CHANGE_SIZE             equate(00000008h)
DCL_API_FILE_NOTIFY_CHANGE_LAST_WRITE       equate(00000010h)
DCL_API_FILE_NOTIFY_CHANGE_LAST_ACCESS      equate(00000020h)
DCL_API_FILE_NOTIFY_CHANGE_CREATION         equate(00000040h)
DCL_API_FILE_NOTIFY_CHANGE_SECURITY         equate(00000100h)
DCL_API_Watch_subdirectories                equate(1)
DCL_API_Watch_NoSubDirectories              equate(0)
DCL_API_Watch_autoreset                     equate(1)
DCL_API_Watch_noAutoReset                   equate(0)

!
!Wait object equates
DCL_API_MAXIMUM_WAIT_OBJECTS                EQUATE(64)
DCL_API_Waitinfinite                        EQUATE(-1)
DCL_API_Wait_object_0                       EQUATE(0)
DCL_API_Wait_Abandoned_0                    EQUATE(80)
DCL_API_WAIT_TIMEOUT                        EQUATE(102)
DCL_API_WAIT_FAILED                         EQUATE(-1)

! ShGetFolderLocation equates
DCL_API_CSIDL_DESKTOP                       EQUATE(0H)  ! {Desktop}
DCL_API_CSIDL_INTERNET                      EQUATE(1H)  ! Internet Explorer Icon on Desktop
DCL_API_CSIDL_PROGRAMS                      EQUATE(2H)  ! Start Menu\Programs
DCL_API_CSIDL_CONTROLS                      EQUATE(3H)  ! My Computer\Control Panel
DCL_API_CSIDL_PRINTERS                      EQUATE(4H)  ! My Computer\Printers
DCL_API_CSIDL_PERSONAL                      EQUATE(5H)  ! My Documents
DCL_API_CSIDL_FAVORITES                     EQUATE(6H)  ! {User Name}\Favorites
DCL_API_CSIDL_STARTUP                       EQUATE(7H)  ! Start Menu\Programs\Startup
DCL_API_CSIDL_RECENT                        EQUATE(8H)  ! {User Name}\Recent
DCL_API_CSIDL_SENDTO                        EQUATE(9H)  ! {User Name}\SendTo
DCL_API_CSIDL_BITBUCKET                     EQUATE(0AH) ! {Desktop}\Recycle Bin
DCL_API_CSIDL_STARTMENU                     EQUATE(0BH) ! {User Name}\Start Menu
DCL_API_CSIDL_DESKTOPDIRECTORY              EQUATE(10H) ! {User Name}\Desktop
DCL_API_CSIDL_DRIVES                        EQUATE(11H) ! My Computer
DCL_API_CSIDL_NETWORK                       EQUATE(12H) ! Network Neighborhood
DCL_API_CSIDL_NETHOOD                       EQUATE(13H) ! {User Name}\nethood
DCL_API_CSIDL_FONTS                         EQUATE(14H) ! Windows\fonts
DCL_API_CSIDL_TEMPLATES                     EQUATE(15H)
DCL_API_CSIDL_COMMON_STARTMENU              EQUATE(16H) ! All Users\Start Menu
DCL_API_CSIDL_COMMON_PROGRAMS               EQUATE(17H) ! All Users\Programs
DCL_API_CSIDL_COMMON_STARTUP                EQUATE(18H) ! All Users\Startup
DCL_API_CSIDL_COMMON_DESKTOPDIRECTORY       EQUATE(19H) ! All Users\Desktop
DCL_API_CSIDL_APPDATA                       EQUATE(1AH) ! {User Name}\Application Data
DCL_API_CSIDL_PRINTHOOD                     EQUATE(1BH) ! {User Name}\PrintHood
DCL_API_CSIDL_LOCAL_APPDATA                 EQUATE(1CH) ! {User Name}\Local Settings\Application Data (non roaming)
DCL_API_CSIDL_ALTSTARTUP                    EQUATE(1DH) ! Non-Localized Startup
DCL_API_CSIDL_COMMON_ALTSTARTUP             EQUATE(1EH) ! Non-Localized Common Startup
DCL_API_CSIDL_COMMON_FAVORITES              EQUATE(1FH)
DCL_API_CSIDL_INTERNET_CACHE                EQUATE(20H)
DCL_API_CSIDL_COOKIES                       EQUATE(21H)
DCL_API_CSIDL_HISTORY                       EQUATE(22H)
DCL_API_CSIDL_COMMON_APPDATA                EQUATE(23H) ! All Users\Application Data
DCL_API_CSIDL_WINDOWS                       EQUATE(24H) ! GetWindowsDirectory()
DCL_API_CSIDL_SYSTEM                        EQUATE(25H) ! GetSystemDirectory()
DCL_API_CSIDL_PROGRAM_FILES                 EQUATE(26H) ! C:\Program Files
DCL_API_CSIDL_MYPICTURES                    EQUATE(27H) ! {User Name}\My Documents\My Pictures
DCL_API_CSIDL_PROFILE                       EQUATE(28H) ! UserProfile
DCL_API_CSIDL_SYSTEMX86                     EQUATE(29H) ! x86 System Directory on RISC
DCL_API_CSIDL_PROGRAM_FILESX86              EQUATE(2AH) ! x86 C:\Program Files on RISC
DCL_API_CSIDL_PROGRAM_FILES_COMMON          EQUATE(2BH) ! C:\Program Files\Common
DCL_API_CSIDL_PROGRAM_FILES_COMMONX86       EQUATE(2CH) ! x86 Program Files\Common on RISC
DCL_API_CSIDL_COMMON_TEMPLATES              EQUATE(2DH) ! All Users\Templates
DCL_API_CSIDL_COMMON_DOCUMENTS              EQUATE(2EH) ! All Users\Documents
DCL_API_CSIDL_COMMON_ADMINTOOLS             EQUATE(2FH) ! All Users\Start Menu\Programs\Administrative Tools
DCL_API_CSIDL_ADMINTOOLS                    EQUATE(30H) ! {User Name}\Start Menu\Programs\Administrative Tools

DCL_API_CSIDL_FLAG_CREATE                   EQUATE(8000H)  ! Combine with DCL_API_CSIDL_ value to force create on ShGetFolderLocation()
DCL_API_CSIDL_FLAG_DONT_VERIFY              EQUATE(4000H)  ! Combine with DCL_API_CSIDL_ value to force create on ShGetFolderLocation()
DCL_API_CSIDL_FLAG_MASK                     EQUATE(0FF00H) ! Mask for all possible flag values

DCL_API_SHGFP_TYPE_CURRENT                  EQUATE(0) ! Current value for user; verify it exists
DCL_API_SHGFP_TYPE_DEFAULT                  EQUATE(1)

DCL_API_SW_NORMAL                           EQUATE(1)
DCL_API_SW_MINIMIZE                         EQUATE(6)
DCL_API_SW_MAXIMIZE                         EQUATE(3)
DCL_API_SW_HIDE                             EQUATE(0)
DCL_API_SW_INVALIDATE                       EQUATE(0002h)

DCL_API_STARTF_USESHOWWINDOW                EQUATE(00000001H)
DCL_API_STARTF_USESTDHANDLES                EQUATE(00000100h)

DCL_API_NORMAL_PRIORITY_CLASS               EQUATE(00000020h)
DCL_API_CREATE_NEW_CONSOLE                  EQUATE(00000010h)
DCL_API_CREATE_DEFAULT_ERROR_MODE           EQUATE(04000000h)

DCL_API_HANDLE_FLAG_INHERIT                 EQUATE(00000001H)
DCL_API_STD_INPUT_HANDLE                    EQUATE(-10) ! DCL_API_Handle to the standard input device.
DCL_API_STD_OUTPUT_HANDLE                   EQUATE(-11) ! DCL_API_Handle to the standard output device.
DCL_API_STD_ERROR_HANDLE                    EQUATE(-12) !DCL_API_handle to standard error device

DCL_API_INVALID_LONG_VALUE                  EQUATE(4294967295)

DCL_API_GENERIC_WRITE                       EQUATE(40000000h)
DCL_API_FILE_ATTRIBUTE_NORMAL               EQUATE(00000080h)
DCL_API_CREATE_ALWAYS                       EQUATE(2)
DCL_API_OPEN_EXISTING                       EQUATE(3)

DCL_API_FILE_SHARE_READ                     equate(1)
DCL_API_FILE_SHARE_WRITE                    equate(2)
DCL_API_FILE_FLAG_RANDOM_ACCESS             equate(10000000H)
DCL_API_FILE_FLAG_SEQUENTIAL_SCAN           equate(08000000H)
DCL_API_FILE_FLAG_DELETE_ON_CLOSE           equate(04000000H)

DCL_API_DUPLICATE_CLOSE_SOURCE              EQUATE(00000001h)! Closes the source DCL_API_handle. This occurs regardless of any error status returned.
DCL_API_DUPLICATE_SAME_ACCESS               EQUATE(00000002h) !Ignores the dwDesiredAccess parameter. The duplicate DCL_API_handle has the same access as the source DCL_API_handle.

!
! Windows naming conventions used in Clarion prototypes
!
DCL_API_SOCKET                              EQUATE(UNSIGNED)
DCL_API_LPBYTE                              EQUATE(ulong)
DCL_API_WM_TIMER                            EQUATE(0113h)
DCL_API_WM_COMMAND                          EQUATE(0111h)
DCL_API_LPDWORD                             EQUATE(ULONG)
DCL_API_WM_USER                             EQUATE(400h)

DCL_API_HFILE_ERROR                         EQUATE(-1)
DCL_API_UINT                                EQUATE(UNSIGNED)
DCL_API_FOURCC                              EQUATE(LONG)
DCL_API_WCHAR                               EQUATE(BYTE)
DCL_API_UCHAR                               EQUATE(BYTE)
DCL_API_CHAR                                EQUATE(BYTE)
DCL_API_BOOL                                EQUATE(SIGNED)
DCL_API_BYTE                                EQUATE(BYTE)
DCL_API_WORD                                EQUATE(SIGNED)
DCL_API_DWORD                               EQUATE(ULONG)
DCL_API_HANDLE                              EQUATE(UNSIGNED)
DCL_API_LPVOID                              EQUATE(ULONG)
DCL_API_PVOID                               EQUATE(ULONG)
DCL_API_FLOAT                               EQUATE(SREAL)
DCL_API_LPSTR                               EQUATE(CSTRING)    !Usage:Pass the Label of the LPSTR
DCL_API_LPCSTR                              EQUATE(CSTRING)    !Usage:Pass the Label of the LPCSTR
DCL_API_MAX_PATH                            EQUATE(260)
DCL_API_HWND                                EQUATE(DCL_API_HANDLE)
DCL_API_HINSTANCE                           EQUATE(DCL_API_HANDLE)
DCL_API_HMODULE                             EQUATE(DCL_API_HINSTANCE)
DCL_API_HTASK                               EQUATE(DCL_API_HANDLE)
DCL_API_HDC                                 EQUATE(DCL_API_HANDLE)
DCL_API_WPARAM                              EQUATE(DCL_API_UINT)
DCL_API_LPARAM                              EQUATE(LONG)
DCL_API_LRESULT                             EQUATE(LONG)
DCL_API_LPBOOL                              EQUATE(ULONG)
DCL_API_LPCVOID                             EQUATE(ULONG)

DCL_API_HFILE                               EQUATE(DCL_API_HANDLE)
DCL_API_HDIOBJ                              EQUATE(DCL_API_HANDLE)
DCL_API_HCOLORSPACE                         EQUATE(DCL_API_HANDLE)
DCL_API_HRDVR                               EQUATE(DCL_API_HANDLE)
DCL_API_HWAVEOUT                            EQUATE(DCL_API_HANDLE)
DCL_API_HWAVEIN                             EQUATE(DCL_API_HANDLE)
DCL_API_HACCEL                              EQUATE(DCL_API_HANDLE)
DCL_API_HBITMAP                             EQUATE(DCL_API_HANDLE)
DCL_API_HPEN                                EQUATE(DCL_API_HANDLE)
DCL_API_HWINSTA                             EQUATE(DCL_API_HANDLE)
DCL_API_HBRUSH                              EQUATE(DCL_API_HANDLE)
DCL_API_HRGN                                EQUATE(DCL_API_HANDLE)
DCL_API_HKL                                 EQUATE(DCL_API_HANDLE)
DCL_API_HPALETTE                            EQUATE(DCL_API_HANDLE)
DCL_API_HFONT                               EQUATE(DCL_API_HANDLE)
DCL_API_HHOOK                               EQUATE(DCL_API_HANDLE)
DCL_API_HDRVR                               EQUATE(DCL_API_HANDLE)
DCL_API_HDWP                                EQUATE(DCL_API_HANDLE)
DCL_API_HRSRC                               EQUATE(DCL_API_HANDLE)
DCL_API_HSTR                                EQUATE(DCL_API_HANDLE)
DCL_API_HCURSOR                             EQUATE(DCL_API_HANDLE)
DCL_API_HICON                               EQUATE(DCL_API_HCURSOR)
DCL_API_HGRN                                EQUATE(DCL_API_HANDLE)
DCL_API_HMENU                               EQUATE(DCL_API_HANDLE)
DCL_API_SC_HANDLE                           EQUATE(DCL_API_HANDLE)
DCL_API_HDESK                               EQUATE(DCL_API_HANDLE)
DCL_API_HENHMETAFILE                        EQUATE(DCL_API_HANDLE)
DCL_API_HSZ                                 EQUATE(DCL_API_WORD)
DCL_API_HMETAFILE                           EQUATE(DCL_API_HANDLE)
DCL_API_HMIDIIN                             EQUATE(DCL_API_HANDLE)
DCL_API_HMIDIOUT                            EQUATE(DCL_API_HANDLE)
DCL_API_HMMIO                               EQUATE(DCL_API_HANDLE)
DCL_API_HFILE                               EQUATE(SIGNED)
DCL_API_LUID                                EQUATE(LONG)
DCL_API_PLUID                               EQUATE(LONG)
DCL_API_HKEY                                EQUATE(DCL_API_DWORD)

DCL_API_ANYSIZE_ARRAY                       EQUATE(1)
DCL_API_PHANDLE                             EQUATE(DCL_API_HANDLE)
DCL_API_SPHANDLE                            EQUATE(DCL_API_HANDLE)
DCL_API_LPHANDLE                            EQUATE(DCL_API_HANDLE)
DCL_API_HGLOBAL                             EQUATE(DCL_API_HANDLE)
DCL_API_HLOCAL                              EQUATE(DCL_API_HANDLE)
DCL_API_GLOBALHANDLE                        EQUATE(DCL_API_HANDLE)
DCL_API_LOCALHANDLE                         EQUATE(DCL_API_HANDLE)
DCL_API_ATOM                                EQUATE(DCL_API_UINT)

DCL_API_COLORREF                            EQUATE(DCL_API_DWORD)
DCL_API_HDDEDATA                            EQUATE(DCL_API_DWORD)
DCL_API_HCONV                               EQUATE(DCL_API_DWORD)
DCL_API_HCONVLIST                           EQUATE(DCL_API_DWORD)
DCL_API_LONGREAL                            EQUATE(REAL)
DCL_API_DWORDLONG                           EQUATE(REAL)
DCL_API_WORDLONG                            EQUATE(REAL)
DCL_API_LARGE_INTEGER                       EQUATE(LONG)
DCL_API_ULARGE_INTEGER                      EQUATE(ULONG)
DCL_API_BOOLEAN                             EQUATE(BYTE)
DCL_API_VERSION                             EQUATE(UNSIGNED)

DCL_API_SECURITY_ATTRIBUTES                 GROUP, TYPE
nLength                                     ulong
lpSecurityDescriptor                        ulong
bInheritHandle                              DCL_API_bool
										END
DCL_API_ProcessInformation                  GROUP,TYPE
hProcess                                    DCL_API_HANDLE
hThread                                     DCL_API_HANDLE
dwProcessId                                 DCL_API_DWORD
dwThreadId                                  DCL_API_DWORD
										END

DCL_API_StartupInfo                         GROUP,TYPE
cb                                          DCL_API_DWORD
lpReserved                                  ULONG
lpDesktop                                   ULONG
lpTitle                                     ULONG
dwX                                         DCL_API_DWORD
dwY                                         DCL_API_DWORD
dwXSize                                     DCL_API_DWORD
dwYSize                                     DCL_API_DWORD
dwXCountChars                               DCL_API_DWORD
dwYCountChars                               DCL_API_DWORD
dwFillAttribute                             DCL_API_DWORD
dwFlags                                     DCL_API_DWORD
wShowWindow                                 USHORT
cbReserved2                                 USHORT
lpReserved2                                 ULONG
hStdInput                                   DCL_API_HANDLE
hStdOutput                                  DCL_API_HANDLE
hStdError                                   DCL_API_HANDLE
										END

DCL_API_FILETIMEType                        GROUP,TYPE
dwLowDateTime                               DCL_API_DWORD
dwHighDateTime                              DCL_API_DWORD 
										END

DCL_API_SYSTEMTIME                          GROUP,TYPE
wYear                                       USHORT
wMonth                                      USHORT
wDayOfWeek                                  USHORT
wDay                                        USHORT
wHour                                       USHORT
wMinute                                     USHORT
wSecond                                     USHORT
wMilliseconds                               USHORT
										END
DCL_API_WIN32_FIND_DATA                     GROUP,TYPE
dwFileAttributes                            ULONG
ftCreationTime                              GROUP(DCL_API_FILETIMEType).
ftLastAccessTime                            GROUP(DCL_API_FILETIMEType).
ftLastWriteTime                             GROUP(DCL_API_FILETIMEType).
nFileSizeHigh                               ULONG
nFileSizeLow                                ULONG
dwReserved0                                 ULONG
dwReserved1                                 ULONG
cFileName                                   CSTRING( FILE:MaxFilePath )
cAlternateFileName                          CSTRING( 14 )
										END
 
!//////////////////////////////////////////////////////////////////////
!                                                                     //
!                Registry API Constants                                //
!                                                                     //
! //////////////////////////////////////////////////////////////////////

DCL_API_HKEY_CLASSES_ROOT                   EQUATE(80000000h)
DCL_API_HKEY_CURRENT_USER                   EQUATE(80000001h)
DCL_API_HKEY_LOCAL_MACHINE                  EQUATE(80000002h)
DCL_API_HKEY_USERS                          EQUATE(80000003h)
DCL_API_HKEY_PERFORMANCE_DATA               EQUATE(80000004h)
DCL_API_HKEY_CURRENT_CONFIG                 EQUATE(80000005h)
DCL_API_HKEY_DYN_DATA                       EQUATE(80000006h)

! Reg Create Type Values...
DCL_API_REG_OPTION_RESERVED                 EQUATE(0)           ! Parameter is reserved
DCL_API_REG_OPTION_NON_VOLATILE             EQUATE(0)       ! Key is preserved when system is rebooted
DCL_API_REG_OPTION_VOLATILE                 EQUATE(1)           ! Key is not preserved when system is rebooted
DCL_API_REG_OPTION_CREATE_LINK              EQUATE(2)        ! Created key is a symbolic link
DCL_API_REG_OPTION_BACKUP_RESTORE           EQUATE(4)     ! open for backup or restore

! Reg Data Types...
DCL_API_REG_NONE                            EQUATE(0)                       ! No value type
DCL_API_REG_SZ                              EQUATE(1)                         ! Unicode nul terminated string
DCL_API_REG_EXPAND_SZ                       EQUATE(2)                  ! Unicode nul terminated string
DCL_API_REG_BINARY                          EQUATE(3)                     ! Free form binary
DCL_API_REG_DWORD                           EQUATE(4)                      ! 32-bit number
DCL_API_REG_DWORD_LITTLE_ENDIAN             EQUATE(4)        ! 32-bit number (same as REG_DWORD)
DCL_API_REG_DWORD_BIG_ENDIAN                EQUATE(5)           ! 32-bit number
DCL_API_REG_LINK                            EQUATE(6)                       ! Symbolic Link (unicode)
DCL_API_REG_MULTI_SZ                        EQUATE(7)                   ! Multiple Unicode strings
DCL_API_REG_RESOURCE_LIST                   EQUATE(8)              ! Resource list in the resource map
DCL_API_REG_FULL_RESOURCE_DESCRIPTOR        EQUATE(9)   ! Resource list in the hardware description
DCL_API_REG_RESOURCE_REQUIREMENTS_LIST      EQUATE(10)
DCL_API_REG_CREATED_NEW_KEY                 EQUATE(1h)                      ! New Registry Key created
DCL_API_REG_OPENED_EXISTING_KEY             EQUATE(2h)                      ! Existing Key opened
DCL_API_REG_WHOLE_HIVE_VOLATILE             EQUATE(1h)                      ! Restore whole hive volatile
DCL_API_REG_REFRESH_HIVE                    EQUATE(2h)                      ! Unwind changes to last flush
DCL_API_REG_NOTIFY_CHANGE_NAME              EQUATE(1h)                      ! Create or delete (child)
DCL_API_REG_NOTIFY_CHANGE_ATTRIBUTES        EQUATE(2h)
DCL_API_REG_NOTIFY_CHANGE_LAST_SET          EQUATE(4h)                      ! Time stamp
DCL_API_REG_NOTIFY_CHANGE_SECURITY          EQUATE(8h)
DCL_API_REG_LEGAL_CHANGE_FILTER             EQUATE(0Fh)
DCL_API_REG_LEGAL_OPTION                    EQUATE(7h)

! Reg Key Security Options
DCL_API_READ_CONTROL                        EQUATE(20000h)
DCL_API_KEY_QUERY_VALUE                     EQUATE(1h)
DCL_API_KEY_SET_VALUE                       EQUATE(2h)
DCL_API_KEY_CREATE_SUB_KEY                  EQUATE(4h)
DCL_API_KEY_ENUMERATE_SUB_KEYS              EQUATE(8h)
DCL_API_KEY_NOTIFY                          EQUATE(10h)
DCL_API_KEY_CREATE_LINK                     EQUATE(20h)
DCL_API_KEY_READ                            EQUATE(20009h)
DCL_API_KEY_WRITE                           EQUATE(20009h)
DCL_API_KEY_EXECUTE                         EQUATE(DCL_API_KEY_READ)
DCL_API_KEY_ALL_ACCESS                      EQUATE(DCL_API_KEY_WRITE)
DCL_API_STANDARD_RIGHTS_READ                EQUATE(DCL_API_READ_CONTROL)
DCL_API_STANDARD_RIGHTS_WRITE               EQUATE(DCL_API_READ_CONTROL)

