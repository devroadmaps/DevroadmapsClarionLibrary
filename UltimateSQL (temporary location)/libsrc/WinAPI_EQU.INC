! Commonly used Windows constants

api_LPINITCOMMONCONTROLSEX GROUP,TYPE
dwSize  LONG
dwICC   LONG
  END

api_ICC_LISTVIEW_CLASSES EQUATE(00000001h) ! listview, header
api_ICC_TREEVIEW_CLASSES EQUATE(00000002h) ! treeview, tooltips
api_ICC_BAR_CLASSES      EQUATE(00000004h) ! toolbar, statusbar, trackb
api_ICC_TAB_CLASSES      EQUATE(00000008h) ! tab, tooltips
api_ICC_UPDOWN_CLASS     EQUATE(00000010h) ! updown
api_ICC_PROGRESS_CLASS   EQUATE(00000020h) ! progress
api_ICC_HOTKEY_CLASS     EQUATE(00000040h) ! hotkey
api_ICC_ANIMATE_CLASS    EQUATE(00000080h) ! animate
api_ICC_WIN95_CLASSES    EQUATE(000000FFh)
api_ICC_DATE_CLASSES     EQUATE(00000100h) ! month picker, date picker,
api_ICC_USEREX_CLASSES   EQUATE(00000200h) ! comboex
api_ICC_COOL_CLASSES     EQUATE(00000400h) ! rebar (coolbar) control

api_SWP_NOSIZE          EQUATE(0001h)
api_SWP_NOMOVE          EQUATE(0002h)
api_SWP_NOZORDER        EQUATE(0004h)
api_SWP_NOREDRAW        EQUATE(0008h)
api_SWP_NOACTIVATE      EQUATE(0010h)
api_SWP_FRAMECHANGED    EQUATE(0020h)  !/* The frame changed: send WM_NCCALCSIZE */
api_SWP_SHOWWINDOW      EQUATE(0040h)
api_SWP_HIDEWINDOW      EQUATE(0080h)
api_SWP_NOCOPYBITS      EQUATE(0100h)
api_SWP_NOOWNERZORDER   EQUATE(0200h)  !/* Don't do owner Z ordering */
api_SWP_NOSENDCHANGING  EQUATE(0400h)  !/* Don't send WM_WINDOWPOSCHANGING */

api_HWND_TOP        EQUATE(0)
api_HWND_BOTTOM     EQUATE(1)
api_HWND_TOPMOST    EQUATE(-1)
api_HWND_NOTOPMOST  EQUATE(-2)



! WinHelp constants
api_HELP_COMMAND        EQUATE(0102h)
api_HELP_CONTEXT        EQUATE(0001H)  ! Display topic in ulTopic
api_HELP_KEY            EQUATE(0101h)
api_HELP_PARTIALKEY     EQUATE(0105h)
api_HELP_QUIT           EQUATE(0002H)  ! Terminate help
api_HELP_FINDER         EQUATE(000bH)
api_HELP_HELPONHELP     EQUATE(0004h)
api_HELP_INDEX          EQUATE(0003h)

api_ERROR_SUCCESS EQUATE(0)
api_ERROR_INVALID_FUNCTION EQUATE(1)
api_ERROR_FILE_NOT_FOUND EQUATE(2)
api_ERROR_PATH_NOT_FOUND EQUATE(3)
api_ERROR_TOO_MANY_OPEN_FILES  EQUATE(4)
api_ERROR_ACCESS_DENIED  EQUATE(5)
api_ERROR_INVALID_HANDLE EQUATE(6)
api_ERROR_ARENA_TRASHED  EQUATE(7)
api_ERROR_NOT_ENOUGH_MEMORY  EQUATE(8)
api_ERROR_INVALID_BLOCK  EQUATE(9)
api_ERROR_BAD_ENVIRONMENT  EQUATE(10)
api_ERROR_BAD_FORMAT  EQUATE(11)
api_ERROR_INVALID_ACCESS EQUATE(12)
api_ERROR_INVALID_DATA EQUATE(13)
api_ERROR_OUTOFMEMORY  EQUATE(14)
api_ERROR_INVALID_DRIVE  EQUATE(15)
api_ERROR_CURRENT_DIRECTORY  EQUATE(16)
api_ERROR_NOT_SAME_DEVICE  EQUATE(17)
api_ERROR_NO_MORE_FILES  EQUATE(18)
api_ERROR_WRITE_PROTECT  EQUATE(19)
api_ERROR_BAD_UNIT EQUATE(20)
api_ERROR_NOT_READY  EQUATE(21)
api_ERROR_BAD_COMMAND  EQUATE(22)
api_ERROR_CRC  EQUATE(23)
api_ERROR_BAD_LENGTH EQUATE(24)
api_ERROR_SEEK EQUATE(25)
api_ERROR_NOT_DOS_DISK EQUATE(26)
api_ERROR_SECTOR_NOT_FOUND EQUATE(27)
api_ERROR_OUT_OF_PAPER EQUATE(28)
api_ERROR_WRITE_FAULT  EQUATE(29)
api_ERROR_READ_FAULT EQUATE(30)
api_ERROR_GEN_FAILURE  EQUATE(31)
api_ERROR_SHARING_VIOLATION  EQUATE(32)
api_ERROR_LOCK_VIOLATION EQUATE(33)
api_ERROR_WRONG_DISK EQUATE(34)
api_ERROR_SHARING_BUFFER_EXCEEDED  EQUATE(36)
api_ERROR_HANDLE_EOF EQUATE(38)
api_ERROR_HANDLE_DISK_FULL EQUATE(39)
api_ERROR_NOT_SUPPORTED  EQUATE(50)
api_ERROR_REM_NOT_LIST EQUATE(51)
api_ERROR_DUP_NAME EQUATE(52)
api_ERROR_BAD_NETPATH  EQUATE(53)
api_ERROR_NETWORK_BUSY EQUATE(54)
api_ERROR_DEV_NOT_EXIST  EQUATE(55)
api_ERROR_TOO_MANY_CMDS  EQUATE(56)
api_ERROR_ADAP_HDW_ERR EQUATE(57)
api_ERROR_BAD_NET_RESP EQUATE(58)
api_ERROR_UNEXP_NET_ERR  EQUATE(59)
api_ERROR_BAD_REM_ADAP EQUATE(60)
api_ERROR_PRINTQ_FULL  EQUATE(61)
api_ERROR_NO_SPOOL_SPACE EQUATE(62)
api_ERROR_PRINT_CANCELLED  EQUATE(63)
api_ERROR_NETNAME_DELETED  EQUATE(64)
api_ERROR_NETWORK_ACCESS_DENIED  EQUATE(65)
api_ERROR_BAD_DEV_TYPE EQUATE(66)
api_ERROR_BAD_NET_NAME EQUATE(67)
api_ERROR_TOO_MANY_NAMES EQUATE(68)
api_ERROR_TOO_MANY_SESS  EQUATE(69)
api_ERROR_SHARING_PAUSED EQUATE(70)
api_ERROR_REQ_NOT_ACCEP  EQUATE(71)
api_ERROR_REDIR_PAUSED EQUATE(72)
api_ERROR_FILE_EXISTS  EQUATE(80)
api_ERROR_CANNOT_MAKE  EQUATE(82)
api_ERROR_FAIL_I24 EQUATE(83)
api_ERROR_OUT_OF_STRUCTURES  EQUATE(84)
api_ERROR_ALREADY_ASSIGNED EQUATE(85)
api_ERROR_INVALID_PASSWORD EQUATE(86)
api_ERROR_INVALID_PARAMETER  EQUATE(87)
api_ERROR_NET_WRITE_FAULT  EQUATE(88)
api_ERROR_NO_PROC_SLOTS  EQUATE(89)
api_ERROR_TOO_MANY_SEMAPHORES  EQUATE(100)
api_ERROR_EXCL_SEM_ALREADY_OWNED EQUATE(101)
api_ERROR_SEM_IS_SET EQUATE(102)
api_ERROR_TOO_MANY_SEM_REQUESTS  EQUATE(103)
api_ERROR_INVALID_AT_INTERRUPT_TIME  EQUATE(104)
api_ERROR_SEM_OWNER_DIED EQUATE(105)
api_ERROR_SEM_USER_LIMIT EQUATE(106)
api_ERROR_DISK_CHANGE  EQUATE(107)
api_ERROR_DRIVE_LOCKED EQUATE(108)
api_ERROR_BROKEN_PIPE  EQUATE(109)
api_ERROR_OPEN_FAILED  EQUATE(110)
api_ERROR_BUFFER_OVERFLOW  EQUATE(111)
api_ERROR_DISK_FULL  EQUATE(112)
api_ERROR_NO_MORE_SEARCH_HANDLES EQUATE(113)
api_ERROR_INVALID_TARGET_HANDLE  EQUATE(114)
api_ERROR_INVALID_CATEGORY EQUATE(117)
api_ERROR_INVALID_VERIFY_SWITCH  EQUATE(118)
api_ERROR_BAD_DRIVER_LEVEL EQUATE(119)
api_ERROR_CALL_NOT_IMPLEMENTED EQUATE(120)
api_ERROR_SEM_TIMEOUT  EQUATE(121)
api_ERROR_INSUFFICIENT_BUFFER  EQUATE(122)
api_ERROR_INVALID_NAME EQUATE(123)
api_ERROR_INVALID_LEVEL  EQUATE(124)
api_ERROR_NO_VOLUME_LABEL  EQUATE(125)
api_ERROR_MOD_NOT_FOUND  EQUATE(126)
api_ERROR_PROC_NOT_FOUND EQUATE(127)
api_ERROR_WAIT_NO_CHILDREN EQUATE(128)
api_ERROR_CHILD_NOT_COMPLETE EQUATE(129)
api_ERROR_DIRECT_ACCESS_HANDLE EQUATE(130)
api_ERROR_NEGATIVE_SEEK  EQUATE(131)
api_ERROR_SEEK_ON_DEVICE EQUATE(132)
api_ERROR_IS_JOIN_TARGET EQUATE(133)
api_ERROR_IS_JOINED  EQUATE(134)
api_ERROR_IS_SUBSTED EQUATE(135)
api_ERROR_NOT_JOINED EQUATE(136)
api_ERROR_NOT_SUBSTED  EQUATE(137)
api_ERROR_JOIN_TO_JOIN EQUATE(138)
api_ERROR_SUBST_TO_SUBST EQUATE(139)
api_ERROR_JOIN_TO_SUBST  EQUATE(140)
api_ERROR_SUBST_TO_JOIN  EQUATE(141)
api_ERROR_BUSY_DRIVE EQUATE(142)
api_ERROR_SAME_DRIVE EQUATE(143)
api_ERROR_DIR_NOT_ROOT EQUATE(144)
api_ERROR_DIR_NOT_EMPTY  EQUATE(145)
api_ERROR_IS_SUBST_PATH  EQUATE(146)
api_ERROR_IS_JOIN_PATH EQUATE(147)
api_ERROR_PATH_BUSY  EQUATE(148)
api_ERROR_IS_SUBST_TARGET  EQUATE(149)
api_ERROR_SYSTEM_TRACE EQUATE(150)
api_ERROR_INVALID_EVENT_COUNT  EQUATE(151)
api_ERROR_TOO_MANY_MUXWAITERS  EQUATE(152)
api_ERROR_ALREADY_EXISTS       EQUATE(183)
api_ERROR_NO_MORE_ITEMS        equate( 259 )

api_FORMAT_MESSAGE_IGNORE_INSERTS  equate(000200h)
api_FORMAT_MESSAGE_FROM_SYSTEM     equate(001000h)
api_FORMAT_MESSAGE_MAX_WIDTH_MASK  EQUATE(000000FFH)
api_LANG_USER_DEFAULT              EQUATE(400H)

api_S_OK    EQUATE(0)
api_S_FALSE EQUATE(1)

api_FILE_NOTIFY_CHANGE_FILE_NAME    equate(00000001h)
api_FILE_NOTIFY_CHANGE_DIR_NAME     equate(00000002h)
api_FILE_NOTIFY_CHANGE_ATTRIBUTES   equate(00000004h)
api_FILE_NOTIFY_CHANGE_SIZE         equate(00000008h)
api_FILE_NOTIFY_CHANGE_LAST_WRITE   equate(00000010h)
api_FILE_NOTIFY_CHANGE_LAST_ACCESS  equate(00000020h)
api_FILE_NOTIFY_CHANGE_CREATION     equate(00000040h)
api_FILE_NOTIFY_CHANGE_SECURITY     equate(00000100h)
api_Watch_subdirectories            equate(1)
api_Watch_NoSubDirectories          equate(0)
api_Watch_autoreset                 equate(1)
api_Watch_noAutoReset               equate(0)

!
!Wait object equates
api_MAXIMUM_WAIT_OBJECTS EQUATE(64)
api_Waitinfinite     EQUATE(-1)
api_Wait_object_0    EQUATE(0)
api_Wait_Abandoned_0 EQUATE(80)
api_WAIT_TIMEOUT     EQUATE(102)
api_WAIT_FAILED      EQUATE(-1)
!
api_INFINITE ULONG(0FFFFFFFFH)
! ShGetFolderLocation equates
api_CSIDL_DESKTOP                 EQUATE(0H)  ! {Desktop}
api_CSIDL_INTERNET                EQUATE(1H)  ! Internet Explorer Icon on Desktop
api_CSIDL_PROGRAMS                EQUATE(2H)  ! Start Menu\Programs
api_CSIDL_CONTROLS                EQUATE(3H)  ! My Computer\Control Panel
api_CSIDL_PRINTERS                EQUATE(4H)  ! My Computer\Printers
api_CSIDL_PERSONAL                EQUATE(5H)  ! My Documents
api_CSIDL_FAVORITES               EQUATE(6H)  ! {User Name}\Favorites
api_CSIDL_STARTUP                 EQUATE(7H)  ! Start Menu\Programs\Startup
api_CSIDL_RECENT                  EQUATE(8H)  ! {User Name}\Recent
api_CSIDL_SENDTO                  EQUATE(9H)  ! {User Name}\SendTo
api_CSIDL_BITBUCKET               EQUATE(0AH) ! {Desktop}\Recycle Bin
api_CSIDL_STARTMENU               EQUATE(0BH) ! {User Name}\Start Menu
api_CSIDL_DESKTOPDIRECTORY        EQUATE(10H) ! {User Name}\Desktop
api_CSIDL_DRIVES                  EQUATE(11H) ! My Computer
api_CSIDL_NETWORK                 EQUATE(12H) ! Network Neighborhood
api_CSIDL_NETHOOD                 EQUATE(13H) ! {User Name}\nethood
api_CSIDL_FONTS                   EQUATE(14H) ! Windows\fonts
api_CSIDL_TEMPLATES               EQUATE(15H)
api_CSIDL_COMMON_STARTMENU        EQUATE(16H) ! All Users\Start Menu
api_CSIDL_COMMON_PROGRAMS         EQUATE(17H) ! All Users\Programs
api_CSIDL_COMMON_STARTUP          EQUATE(18H) ! All Users\Startup
api_CSIDL_COMMON_DESKTOPDIRECTORY EQUATE(19H) ! All Users\Desktop
api_CSIDL_APPDATA                 EQUATE(1AH) ! {User Name}\Application Data
api_CSIDL_PRINTHOOD               EQUATE(1BH) ! {User Name}\PrintHood
api_CSIDL_LOCAL_APPDATA           EQUATE(1CH) ! {User Name}\Local Settings\Application Data (non roaming)
api_CSIDL_ALTSTARTUP              EQUATE(1DH) ! Non-Localized Startup
api_CSIDL_COMMON_ALTSTARTUP       EQUATE(1EH) ! Non-Localized Common Startup
api_CSIDL_COMMON_FAVORITES        EQUATE(1FH)
api_CSIDL_INTERNET_CACHE          EQUATE(20H)
api_CSIDL_COOKIES                 EQUATE(21H)
api_CSIDL_HISTORY                 EQUATE(22H)
api_CSIDL_COMMON_APPDATA          EQUATE(23H) ! All Users\Application Data
api_CSIDL_WINDOWS                 EQUATE(24H) ! GetWindowsDirectory()
api_CSIDL_SYSTEM                  EQUATE(25H) ! GetSystemDirectory()
api_CSIDL_PROGRAM_FILES           EQUATE(26H) ! C:\Program Files
api_CSIDL_MYPICTURES              EQUATE(27H) ! {User Name}\My Documents\My Pictures
api_CSIDL_PROFILE                 EQUATE(28H) ! UserProfile
api_CSIDL_SYSTEMX86               EQUATE(29H) ! x86 System Directory on RISC
api_CSIDL_PROGRAM_FILESX86        EQUATE(2AH) ! x86 C:\Program Files on RISC
api_CSIDL_PROGRAM_FILES_COMMON    EQUATE(2BH) ! C:\Program Files\Common
api_CSIDL_PROGRAM_FILES_COMMONX86 EQUATE(2CH) ! x86 Program Files\Common on RISC
api_CSIDL_COMMON_TEMPLATES        EQUATE(2DH) ! All Users\Templates
api_CSIDL_COMMON_DOCUMENTS        EQUATE(2EH) ! All Users\Documents
api_CSIDL_COMMON_ADMINTOOLS       EQUATE(2FH) ! All Users\Start Menu\Programs\Administrative Tools
api_CSIDL_ADMINTOOLS              EQUATE(30H) ! {User Name}\Start Menu\Programs\Administrative Tools

api_CSIDL_FLAG_CREATE      EQUATE(8000H)  ! Combine with api_CSIDL_ value to force create on ShGetFolderLocation()
api_CSIDL_FLAG_DONT_VERIFY EQUATE(4000H)  ! Combine with api_CSIDL_ value to force create on ShGetFolderLocation()
api_CSIDL_FLAG_MASK        EQUATE(0FF00H) ! Mask for all possible flag values

api_SHGFP_TYPE_CURRENT EQUATE(0) ! Current value for user; verify it exists
api_SHGFP_TYPE_DEFAULT EQUATE(1)

api_SW_NORMAL           EQUATE(1)
api_SW_MINIMIZE         EQUATE(6)
api_SW_MAXIMIZE         EQUATE(3)
api_SW_HIDE             EQUATE(0)
api_SW_INVALIDATE       EQUATE(0002h)

api_STARTF_USESHOWWINDOW    EQUATE(00000001H)
api_STARTF_USESTDHANDLES    EQUATE(00000100h)

api_NORMAL_PRIORITY_CLASS   EQUATE(00000020h)
api_CREATE_NEW_CONSOLE        EQUATE(00000010h)
api_CREATE_DEFAULT_ERROR_MODE EQUATE(04000000h)

api_HANDLE_FLAG_INHERIT      EQUATE(00000001H)
api_STD_INPUT_HANDLE         EQUATE(-10) ! api_Handle to the standard input device.
api_STD_OUTPUT_HANDLE        EQUATE(-11) ! api_Handle to the standard output device.
api_STD_ERROR_HANDLE         EQUATE(-12) !api_handle to standard error device

api_INVALID_LONG_VALUE        EQUATE(4294967295)

api_GENERIC_ALL                EQUATE(10000000h)
api_GENERIC_EXECUTE            EQUATE(20000000h)
api_GENERIC_WRITE              EQUATE(40000000h)
api_GENERIC_READ               EQUATE(80000000h)
api_CREATE_NEW                      equate(1)
api_CREATE_ALWAYS                   equate(2)
api_OPEN_EXISTING                   equate(3)
api_OPEN_ALWAYS                     equate(4)
api_TRUNCATE_EXISTING               equate(5)

api_FILE_SHARE_READ                 equate(00000001h)
api_FILE_SHARE_WRITE                equate(00000002h)
api_FILE_SHARE_DELETE               equate(00000004h)
api_FILE_ATTRIBUTE_READONLY         equate(00000001h)
api_FILE_ATTRIBUTE_HIDDEN           equate(00000002h)
api_FILE_ATTRIBUTE_SYSTEM           equate(00000004h)
api_FILE_ATTRIBUTE_DIRECTORY        equate(00000010h)
api_FILE_ATTRIBUTE_ARCHIVE          equate(00000020h)
api_FILE_ATTRIBUTE_NORMAL           equate(00000080h)
api_FILE_ATTRIBUTE_TEMPORARY        equate(00000100h)
api_FILE_ATTRIBUTE_COMPRESSED       equate(00000800h)
api_FILE_ATTRIBUTE_OFFLINE          equate(00001000h)
api_FILE_ACTION_ADDED               equate(00000001h)
api_FILE_ACTION_REMOVED             equate(00000002h)
api_FILE_ACTION_MODIFIED            equate(00000003h)
api_FILE_ACTION_RENAMED_OLD_NAME    equate(00000004h)
api_FILE_ACTION_RENAMED_NEW_NAME    equate(00000005h)
api_FILE_CASE_SENSITIVE_SEARCH      equate(00000001h)
api_FILE_CASE_PRESERVED_NAMES       equate(00000002h)
api_FILE_UNICODE_ON_DISK            equate(00000004h)
api_FILE_PERSISTENT_ACLS            equate(00000008h)
api_FILE_FILE_COMPRESSION           equate(00000010h)
api_FILE_VOLUME_IS_COMPRESSED       equate(00008000h)
!api_FILE_SHARE_READ                 equate(1)
!api_FILE_SHARE_WRITE                equate(2)
api_FILE_FLAG_RANDOM_ACCESS         equate(10000000H)
api_FILE_FLAG_SEQUENTIAL_SCAN       equate(08000000H)
api_FILE_FLAG_DELETE_ON_CLOSE       equate(04000000H)

api_DUPLICATE_CLOSE_SOURCE EQUATE(00000001h)! Closes the source api_handle. This occurs regardless of any error status returned.
api_DUPLICATE_SAME_ACCESS  EQUATE(00000002h) !Ignores the dwDesiredAccess parameter. The duplicate api_handle has the same access as the source api_handle.

!
!Standard Windows Messages

api_WM_NULL                         equate(00H)
api_WM_CREATE                       equate(01H)
api_WM_DESTROY                      equate(02H)
api_WM_MOVE                         equate(03H)
api_WM_SIZE                         equate(05H)
api_WM_ACTIVATE                     equate(06H)
api_WM_SETFOCUS                     equate(07H)
api_WM_KILLFOCUS                    equate(08H)
api_WM_ENABLE                       equate(0AH)
api_WM_SETREDRAW                    equate(0BH)
api_WM_SETTEXT                      equate(0CH)
api_WM_GETTEXT                      equate(0DH)
api_WM_GETTEXTLENGTH                equate(0EH)
api_WM_PAINT                        equate(0FH)
api_WM_CLOSE                        equate(010H)
api_WM_QUERYENDSESSION              equate(011H)
api_WM_QUIT                         equate(012H)
api_WM_QUERYOPEN                    equate(013H)
api_WM_ERASEBKGND                   equate(014H)
api_WM_SYSCOLORCHANGE               equate(015H)
api_WM_ENDSESSION                   equate(016H)
api_WM_SHOWWINDOW                   equate(018H)
api_WM_CTLCOLOR                     equate(019H)
api_WM_WININICHANGE                 equate(01AH)
api_WM_DEVMODECHANGE                equate(01BH)
api_WM_ACTIVATEAPP                  equate(01CH)
api_WM_FONTCHANGE                   equate(01DH)
api_WM_TIMECHANGE                   equate(01EH)
api_WM_CANCELMODE                   equate(01FH)
api_WM_SETCURSOR                    equate(020H)
api_WM_MOUSEACTIVATE                equate(021H)
!api_WM_DESTROY                     equate(022H)
api_WM_QUEUESYNC                    equate(023H)
api_WM_GETMINMAXINFO                equate(024H)
api_WM_PAINTICON                    equate(026H)
api_WM_ICONERASEBKGND               equate(027H)
api_WM_NEXTDLGCTL                   equate(028H)
api_WM_SPOOLERSTATUS                equate(02AH)
api_WM_DRAWITEM                     equate(02BH)
api_WM_MEASUREITEM                  equate(02CH)
api_WM_DELETEITEM                   equate(02DH)
api_WM_VKEYTOITEM                   equate(02EH)
api_WM_CHARTOITEM                   equate(02FH)
api_WM_SETFONT                      equate(030H)
api_WM_GETFONT                      equate(031H)
api_WM_QUERYDRAGICON                equate(037H)
api_WM_COMPAREITEM                  equate(039H)
api_WM_COMPACTING                   equate(041H)
api_WM_WINDOWPOSCHANGING            equate(0046H)
api_WM_WINDOWPOSCHANGED             equate(0047H)
api_WM_CONTEXTMENU                  equate(07Bh)
api_WM_STYLECHANGING                equate(07Ch)
api_WM_STYLECHANGED                 equate(07Dh)
api_WM_DISPLAYCHANGE                equate(07Eh)
api_WM_GETICON                      equate(07Fh)
api_WM_SETICON                      equate(080h)
api_WM_NCCREATE                     equate(081H)
api_WM_NCDESTROY                    equate(082H)
api_WM_NCCALCSIZE                   equate(083H)
api_WM_NCHITTEST                    equate(084H)
api_WM_NCPAINT                      equate(085H)
api_WM_NCACTIVATE                   equate(086H)
api_WM_GETDLGCODE                   equate(087H)
api_WM_NCMOUSEMOVE                  equate(0A0H)
api_WM_NCLBUTTONDOWN                equate(0A1H)
api_WM_NCLBUTTONUP                  equate(0A2H)
api_WM_NCLBUTTONDBLCLK              equate(0A3H)
api_WM_NCRBUTTONDOWN                equate(0A4H)
api_WM_NCRBUTTONUP                  equate(0A5H)
api_WM_NCRBUTTONDBLCLK              equate(0A6H)
api_WM_NCMBUTTONDOWN                equate(0A7H)
api_WM_NCMBUTTONUP                  equate(0A8H)
api_WM_NCMBUTTONDBLCLK              equate(0A9H)
api_WM_KEYFIRST                     equate(0100H)
api_WM_KEYDOWN                      equate(0100H)
api_WM_KEYUP                        equate(0101H)
api_WM_CHAR                         equate(0102H)
api_WM_DEADCHAR                     equate(0103H)
api_WM_SYSKEYDOWN                   equate(0104H)
api_WM_SYSKEYUP                     equate(0105H)
api_WM_SYSCHAR                      equate(0106H)
api_WM_SYSDEADCHAR                  equate(0107H)
api_WM_KEYLAST                      equate(0108H)
api_WM_INITDIALOG                   equate(0110H)
api_WM_COMMAND                      equate(0111H)
api_WM_SYSCOMMAND                   equate(0112H)
api_WM_TIMER                        equate(0113H)
api_WM_HSCROLL                      equate(0114H)
api_WM_VSCROLL                      equate(0115H)
api_WM_INITMENU                     equate(0116H)
api_WM_INITMENUPOPUP                equate(0117H)
api_WM_MENUSELECT                   equate(011FH)
api_WM_MENUCHAR                     equate(0120H)
api_WM_ENTERIDLE                    equate(0121H)
api_WM_MOUSEFIRST                   equate(0200H)
api_WM_MOUSEMOVE                    equate(0200H)
api_WM_LBUTTONDOWN                  equate(0201H)
api_WM_LBUTTONUP                    equate(0202H)
api_WM_LBUTTONDBLCLK                equate(0203H)
api_WM_RBUTTONDOWN                  equate(0204H)
api_WM_RBUTTONUP                    equate(0205H)
api_WM_RBUTTONDBLCLK                equate(0206H)
api_WM_MBUTTONDOWN                  equate(0207H)
api_WM_MBUTTONUP                    equate(0208H)
api_WM_MBUTTONDBLCLK                equate(0209H)

api_WM_MOUSEHOVER                   equate(02A1H)
api_WM_MOUSELEAVE                   equate(02A3H)
api_WM_XBUTTONDOWN                  equate(020BH)
api_WM_XBUTTONUP                    equate(020CH)
api_WM_XBUTTONDBLCLK                equate(020DH)
api_WM_MOUSELAST                    equate(020AH)

api_WM_PARENTNOTIFY                 equate(0210H)
api_WM_MDICREATE                    equate(0220H)
api_WM_MDIDESTROY                   equate(0221H)
api_WM_MDIACTIVATE                  equate(0222H)
api_WM_MDIRESTORE                   equate(0223H)
api_WM_MDINEXT                      equate(0224H)
api_WM_MDIMAXIMIZE                  equate(0225H)
api_WM_MDITILE                      equate(0226H)
api_WM_MDICASCADE                   equate(0227H)
api_WM_MDIICONARRANGE               equate(0228H)
api_WM_MDIGETACTIVE                 equate(0229H)
api_WM_MDISETMENU                   equate(0230H)
api_WM_CUT                          equate(0300H)
api_WM_COPY                         equate(0301H)
api_WM_PASTE                        equate(0302H)
api_WM_CLEAR                        equate(0303H)
api_WM_UNDO                         equate(0304H)
api_WM_RENDERFORMAT                 equate(0305H)
api_WM_RENDERALLFORMATS             equate(0306H)
api_WM_DESTROYCLIPBOARD             equate(0307H)
api_WM_DRAWCLIPBOARD                equate(0308H)
api_WM_PAINTCLIPBOARD               equate(0309H)
api_WM_VSCROLLCLIPBOARD             equate(030AH)
api_WM_SIZECLIPBOARD                equate(030BH)
api_WM_ASKCBFORMATNAME              equate(030CH)
api_WM_CHANGECBCHAIN                equate(030DH)
api_WM_HSCROLLCLIPBOARD             equate(030EH)
api_WM_QUERYNEWPALETTE              equate(030FH)
api_WM_PALETTEISCHANGING            equate(0310H)
api_WM_PALETTECHANGED               equate(0311H)
api_WM_USER                         equate(0400H)

api_WM_NOTIFY                       equate(0004Eh)
api_WM_INPUTLANGCHANGEREQUEST       equate(00050h)
api_WM_INPUTLANGCHANGE              equate(00051h)
api_WM_TCARD                        equate(00052h)
api_WM_HELP                         equate(00053h)
api_WM_USERCHANGED                  equate(00054h)
api_WM_NOTIFYFORMAT                 equate(00055h)

!Virtual Key definitions
api_VK_LBUTTON          EQUATE(01h)
api_VK_RBUTTON          EQUATE(02h)
api_VK_CANCEL           EQUATE(03h)
api_VK_MBUTTON          EQUATE(04h)
api_VK_BACK             EQUATE(08h)
api_VK_TAB              EQUATE(09h)
api_VK_CLEAR            EQUATE(0Ch)
api_VK_RETURN           EQUATE(0Dh)
api_VK_SHIFT            EQUATE(10h)
api_VK_CONTROL          EQUATE(11h)
api_VK_MENU             EQUATE(12h)
api_VK_PAUSE            EQUATE(13h)
api_VK_CAPITAL          EQUATE(14h)
api_VK_ESCAPE           EQUATE(1Bh)
api_VK_SPACE            EQUATE(20h)
api_VK_PRIOR            EQUATE(21h)
api_VK_NEXT             EQUATE(22h)
api_VK_END              EQUATE(23h)
api_VK_HOME             EQUATE(24h)
api_VK_LEFT             EQUATE(25h)
api_VK_UP               EQUATE(26h)
api_VK_RIGHT            EQUATE(27h)
api_VK_DOWN             EQUATE(28h)
api_VK_SELECT           EQUATE(29h)
api_VK_PRINT            EQUATE(2Ah)
api_VK_EXECUTE          EQUATE(2Bh)
api_VK_SNAPSHOT         EQUATE(2Ch)
api_VK_INSERT           EQUATE(2Dh)
api_VK_DELETE           EQUATE(2Eh)
api_VK_HELP             EQUATE(2Fh)
api_VK_NUMPAD0          EQUATE(60h)
api_VK_NUMPAD1          EQUATE(61h)
api_VK_NUMPAD2          EQUATE(62h)
api_VK_NUMPAD3          EQUATE(63h)
api_VK_NUMPAD4          EQUATE(64h)
api_VK_NUMPAD5          EQUATE(65h)
api_VK_NUMPAD6          EQUATE(66h)
api_VK_NUMPAD7          EQUATE(67h)
api_VK_NUMPAD8          EQUATE(68h)
api_VK_NUMPAD9          EQUATE(69h)
api_VK_MULTIPLY         EQUATE(6Ah)
api_VK_ADD              EQUATE(6Bh)
api_VK_SEPARATOR        EQUATE(6Ch)
api_VK_SUBTRACT         EQUATE(6Dh)
api_VK_DECIMAL          EQUATE(6Eh)
api_VK_DIVIDE           EQUATE(6Fh)
api_VK_F1               EQUATE(70h)
api_VK_F2               EQUATE(71h)
api_VK_F3               EQUATE(72h)
api_VK_F4               EQUATE(73h)
api_VK_F5               EQUATE(74h)
api_VK_F6               EQUATE(75h)
api_VK_F7               EQUATE(76h)
api_VK_F8               EQUATE(77h)
api_VK_F9               EQUATE(78h)
api_VK_F10              EQUATE(79h)
api_VK_F11              EQUATE(7Ah)
api_VK_F12              EQUATE(7Bh)
api_VK_F13              EQUATE(7Ch)
api_VK_F14              EQUATE(7Dh)
api_VK_F15              EQUATE(7Eh)
api_VK_F16              EQUATE(7Fh)
api_VK_F17              EQUATE(80h)
api_VK_F18              EQUATE(81h)
api_VK_F19              EQUATE(82h)
api_VK_F20              EQUATE(83h)
api_VK_F21              EQUATE(84h)
api_VK_F22              EQUATE(85h)
api_VK_F23              EQUATE(86h)
api_VK_F24              EQUATE(87h)
api_VK_NUMLOCK          EQUATE(90h)
api_VK_SCROLL           EQUATE(91h)
!Window Styles

api_WS_OVERLAPPED                   equate(00000000h)
api_WS_POPUP                        equate(80000000h)
api_WS_CHILD                        equate(40000000h)
api_WS_MINIMIZE                     equate(20000000h)
api_WS_VISIBLE                      equate(10000000h)
api_WS_DISABLED                     equate(08000000h)
api_WS_CLIPSIBLINGS                 equate(04000000h)
api_WS_CLIPCHILDREN                 equate(02000000h)
api_WS_MAXIMIZE                     equate(01000000h)
api_WS_CAPTION                      equate(00C00000h)  !WS_BORDER | WS_DLGFRAME
api_WS_BORDER                       equate(00800000h)
api_WS_DLGFRAME                     equate(00400000h)
api_WS_VSCROLL                      equate(00200000h)
api_WS_HSCROLL                      equate(00100000h)
api_WS_SYSMENU                      equate(00080000h)
api_WS_THICKFRAME                   equate(00040000h)
api_WS_GROUP                        equate(00020000h)
api_WS_TABSTOP                      equate(00010000h)

api_WS_MINIMIZEBOX                  equate(00020000h)
api_WS_MAXIMIZEBOX                  equate(00010000h)

!Common Window Styles

api_WS_OVERLAPPEDWINDOW             equate(api_WS_OVERLAPPED     + |
                                       api_WS_CAPTION        + |
                                       api_WS_SYSMENU        + |
                                       api_WS_THICKFRAME     + |
                                       api_WS_MINIMIZEBOX    + |
                                       api_WS_MAXIMIZEBOX)

api_WS_POPUPWINDOW                  equate(api_WS_POPUP          + |
                                       api_WS_BORDER         + |
                                       api_WS_SYSMENU)

api_WS_CHILDWINDOW                  equate(api_WS_CHILD)

api_WS_TILED                        equate(api_WS_OVERLAPPED)
api_WS_ICONIC                       equate(api_WS_MINIMIZE)
api_WS_SIZEBOX                      equate(api_WS_THICKFRAME)
api_WS_TILEDWINDOW                  equate(api_WS_OVERLAPPEDWINDOW)

!Extended Window Styles

api_WS_EX_DLGMODALFRAME             equate(00000001h)
api_WS_EX_NOPARENTNOTIFY            equate(00000004h)
api_WS_EX_TOPMOST                   equate(00000008h)
api_WS_EX_ACCEPTFILES               equate(00000010h)
api_WS_EX_TRANSPARENT               equate(00000020h)
api_WS_EX_MDICHILD                  equate(00000040h)
api_WS_EX_TOOLWINDOW                equate(00000080h)
api_WS_EX_WINDOWEDGE                equate(00000100h)
api_WS_EX_CLIENTEDGE                equate(00000200h)
api_WS_EX_CONTEXTHELP               equate(00000400h)
api_WS_EX_RIGHT                     equate(00001000h)
api_WS_EX_LEFT                      equate(00000000h)
api_WS_EX_RTLREADING                equate(00002000h)
api_WS_EX_LTRREADING                equate(00000000h)
api_WS_EX_LEFTSCROLLBAR             equate(00004000h)
api_WS_EX_RIGHTSCROLLBAR            equate(00000000h)
api_WS_EX_CONTROLPARENT             equate(00010000h)
api_WS_EX_STATICEDGE                equate(00020000h)
api_WS_EX_APPWINDOW                 equate(00040000h)
api_WS_EX_OVERLAPPEDWINDOW          equate(api_WS_EX_WINDOWEDGE + api_WS_EX_CLIENTEDGE)
api_WS_EX_PALETTEWINDOW             equate(api_WS_EX_WINDOWEDGE + api_WS_EX_TOOLWINDOW + api_WS_EX_TOPMOST)

!Window field offsets for GetWindowLong() / SetWindowLong()

api_GWL_WNDPROC                     equate(-4)
api_GWL_HINSTANCE                   equate(-6)
api_GWL_HWNDPARENT                  equate(-8)
api_GWL_STYLE                       equate(-16)
api_GWL_EXSTYLE                     equate(-20)
api_GWL_USERDATA                    equate(-21)
api_GWL_ID                          equate(-12)

!
! Windows naming conventions used in Clarion prototypes
!
api_SOCKET                  EQUATE(UNSIGNED)
api_LPBYTE                  EQUATE(ulong)
api_LPDWORD                 EQUATE(ULONG)

api_HFILE_ERROR             EQUATE(-1)
api_UINT                    EQUATE(UNSIGNED)
api_FOURCC                  EQUATE(LONG)
api_WCHAR                   EQUATE(BYTE)
api_UCHAR                   EQUATE(BYTE)
api_CHAR                    EQUATE(BYTE)
api_BOOL                    EQUATE(SIGNED)
api_BYTE                    EQUATE(BYTE)
api_WORD                    EQUATE(SIGNED)
api_DWORD                   EQUATE(ULONG)
api_HANDLE                  EQUATE(UNSIGNED)
api_LPVOID                  EQUATE(ULONG)
api_PVOID                   EQUATE(ULONG)
api_FLOAT                   EQUATE(SREAL)
api_LPSTR                   EQUATE(CSTRING)    !Usage:Pass the Label of the LPSTR
api_LPCSTR                  EQUATE(CSTRING)    !Usage:Pass the Label of the LPCSTR
api_MAX_PATH                EQUATE(260)
api_HWND                    EQUATE(api_HANDLE)
api_HINSTANCE               EQUATE(api_HANDLE)
api_HMODULE                 EQUATE(api_HINSTANCE)
api_HTASK                   EQUATE(api_HANDLE)
api_HDC                     EQUATE(api_HANDLE)
api_WPARAM                  EQUATE(api_UINT)
api_LPARAM                  EQUATE(LONG)
api_LRESULT                 EQUATE(LONG)
api_LPBOOL                  EQUATE(ULONG)
api_LPCVOID                 EQUATE(ULONG)

api_HFILE                   EQUATE(api_HANDLE)
api_HDIOBJ                  EQUATE(api_HANDLE)
api_HCOLORSPACE             EQUATE(api_HANDLE)
api_HRDVR                   EQUATE(api_HANDLE)
api_HWAVEOUT                EQUATE(api_HANDLE)
api_HWAVEIN                 EQUATE(api_HANDLE)
api_HACCEL                  EQUATE(api_HANDLE)
api_HBITMAP                 EQUATE(api_HANDLE)
api_HPEN                    EQUATE(api_HANDLE)
api_HWINSTA                 EQUATE(api_HANDLE)
api_HBRUSH                  EQUATE(api_HANDLE)
api_HRGN                    EQUATE(api_HANDLE)
api_HKL                     EQUATE(api_HANDLE)
api_HPALETTE                EQUATE(api_HANDLE)
api_HFONT                   EQUATE(api_HANDLE)
api_HHOOK                   EQUATE(api_HANDLE)
api_HDRVR                   EQUATE(api_HANDLE)
api_HDWP                    EQUATE(api_HANDLE)
api_HRSRC                   EQUATE(api_HANDLE)
api_HSTR                    EQUATE(api_HANDLE)
api_HCURSOR                 EQUATE(api_HANDLE)
api_HICON                   EQUATE(api_HCURSOR)
api_HGRN                    EQUATE(api_HANDLE)
api_HMENU                   EQUATE(api_HANDLE)
api_SC_HANDLE               EQUATE(api_HANDLE)
api_HDESK                   EQUATE(api_HANDLE)
api_HENHMETAFILE            EQUATE(api_HANDLE)
api_HSZ                     EQUATE(api_WORD)
api_HMETAFILE               EQUATE(api_HANDLE)
api_HMIDIIN                 EQUATE(api_HANDLE)
api_HMIDIOUT                EQUATE(api_HANDLE)
api_HMMIO                   EQUATE(api_HANDLE)
api_HFILE                   EQUATE(SIGNED)
api_LUID                    EQUATE(LONG)
api_PLUID                   EQUATE(LONG)
api_HKEY                    EQUATE(api_DWORD)

api_ANYSIZE_ARRAY           EQUATE(1)
api_PHANDLE                 EQUATE(api_HANDLE)
api_SPHANDLE                EQUATE(api_HANDLE)
api_LPHANDLE                EQUATE(api_HANDLE)
api_HGLOBAL                 EQUATE(api_HANDLE)
api_HLOCAL                  EQUATE(api_HANDLE)
api_GLOBALHANDLE            EQUATE(api_HANDLE)
api_LOCALHANDLE             EQUATE(api_HANDLE)
api_ATOM                    EQUATE(api_UINT)

api_COLORREF                EQUATE(api_DWORD)
api_HDDEDATA                EQUATE(api_DWORD)
api_HCONV                   EQUATE(api_DWORD)
api_HCONVLIST               EQUATE(api_DWORD)
api_LONGREAL                EQUATE(REAL)
api_DWORDLONG               EQUATE(REAL)
api_WORDLONG                EQUATE(REAL)
api_LARGE_INTEGER           EQUATE(LONG)
api_ULARGE_INTEGER          EQUATE(ULONG)
api_BOOLEAN                 EQUATE(BYTE)
api_VERSION                 EQUATE(UNSIGNED)

api_LASTINPUTINFO GROUP,TYPE
cbSize  ULONG
dwTime  ULONG
  End

api_SECURITY_ATTRIBUTES     GROUP, TYPE
nLength                  ulong
lpSecurityDescriptor     ulong
bInheritHandle           api_bool
                        END
api_ProcessInformation   GROUP,TYPE
hProcess              api_HANDLE
hThread               api_HANDLE
dwProcessId           api_DWORD
dwThreadId            api_DWORD
                            END

api_StartupInfo          GROUP,TYPE
cb                    api_DWORD
lpReserved            ULONG
lpDesktop             ULONG
lpTitle               ULONG
dwX                   api_DWORD
dwY                   api_DWORD
dwXSize               api_DWORD
dwYSize               api_DWORD
dwXCountChars         api_DWORD
dwYCountChars         api_DWORD
dwFillAttribute       api_DWORD
dwFlags               api_DWORD
wShowWindow           USHORT
cbReserved2           USHORT
lpReserved2           ULONG
hStdInput             api_HANDLE
hStdOutput            api_HANDLE
hStdError             api_HANDLE
                            END

api_SHELLEXECUTEINFOgroup GROUP, TYPE
cbSize        UNSIGNED
fMask         UNSIGNED
hwnd          UNSIGNED
lpVerb        LONG
lpFile        LONG
lpParameters  LONG
lpDirectory   LONG
nShow         LONG
hInstApp      UNSIGNED
! Optional members
lpIDList      LONG
lpClass       LONG
hkeyClass     LONG
dwHotKey      UNSIGNED
hIcon         UNSIGNED
hProcess      UNSIGNED
  END                            

api_SEE_MASK_CLASSNAME         EQUATE(00000001h)
api_SEE_MASK_CLASSKEY          EQUATE(00000003h)
!// Note INVOKEIDLIST overrides IDLIST
api_SEE_MASK_IDLIST            EQUATE(00000004h)
api_SEE_MASK_INVOKEIDLIST      EQUATE(0000000ch)
api_SEE_MASK_ICON              EQUATE(00000010h)
api_SEE_MASK_HOTKEY            EQUATE(00000020h)
api_SEE_MASK_NOCLOSEPROCESS    EQUATE(00000040h)
api_SEE_MASK_CONNECTNETDRV     EQUATE(00000080h)
api_SEE_MASK_NOASYNC           EQUATE(00000100h)
api_SEE_MASK_FLAG_DDEWAIT      EQUATE(00000100h)
api_SEE_MASK_DOENVSUBST        EQUATE(00000200h)
api_SEE_MASK_FLAG_NO_UI        EQUATE(00000400h)
api_SEE_MASK_UNICODE           EQUATE(00004000h)
api_SEE_MASK_NO_CONSOLE        EQUATE(00008000h)
api_SEE_MASK_ASYNCOK           EQUATE(00100000h)
api_SEE_MASK_HMONITOR          EQUATE(00200000h)

api_FILETIMEType     GROUP,TYPE
dwLowDateTime    api_DWORD
dwHighDateTime   api_DWORD 
 END
 
api_SHFILEINFO          Group, Type
hIcon                 UNSIGNED
iIcon                 Long
dwAttributes          UNSIGNED
DisplayName           CString(260)
TypeName              CString(80)
                     End

api_SYSTEMTIME               GROUP,TYPE
wYear                             USHORT
wMonth                            USHORT
wDayOfWeek                        USHORT
wDay                              USHORT
wHour                             USHORT
wMinute                           USHORT
wSecond                           USHORT
wMilliseconds                     USHORT
                                END
api_WIN32_FIND_DATA          GROUP,TYPE
dwFileAttributes                  ULONG
ftCreationTime                    GROUP(api_FILETIMEType).
ftLastAccessTime                  GROUP(api_FILETIMEType).
ftLastWriteTime                   GROUP(api_FILETIMEType).
nFileSizeHigh                     ULONG
nFileSizeLow                      ULONG
dwReserved0                       ULONG
dwReserved1                       ULONG
cFileName                         CSTRING( FILE:MaxFilePath )
cAlternateFileName                CSTRING( 14 )
                                END

api_SHGFI_ICON              EQUATE(000000100h)     ! get icon
api_SHGFI_DISPLAYNAME       EQUATE(000000200h)     ! get display name
api_SHGFI_TYPENAME          EQUATE(000000400h)     ! get type name
api_SHGFI_ATTRIBUTES        EQUATE(000000800h)     ! get attributes
api_SHGFI_ICONLOCATION      EQUATE(000001000h)     ! get icon location
api_SHGFI_EXETYPE           EQUATE(000002000h)     ! return exe type
api_SHGFI_SYSICONINDEX      EQUATE(000004000h)     ! get system icon index
api_SHGFI_LINKOVERLAY       EQUATE(000008000h)     ! put a link overlay on icon
api_SHGFI_SELECTED          EQUATE(000010000h)     ! show icon in selected state
api_SHGFI_ATTR_SPECIFIED    EQUATE(000020000h)     ! get only specified attributes
api_SHGFI_LARGEICON         EQUATE(000000000h)     ! get large icon
api_SHGFI_SMALLICON         EQUATE(000000001h)     ! get small icon
api_SHGFI_OPENICON          EQUATE(000000002h)     ! get open icon
api_SHGFI_SHELLICONSIZE     EQUATE(000000004h)     ! get shell size icon
api_SHGFI_PIDL              EQUATE(000000008h)     ! pszPath is a pidl
api_SHGFI_USEFILEATTRIBUTES EQUATE(000000010h)     ! use passed dwFileAttribute
api_SHGFI_ADDOVERLAYS       EQUATE(000000020h)     ! apply the appropriate overlays
api_SHGFI_OVERLAYINDEX      EQUATE(000000040h)     ! Get the index of the overlay
                                          ! in the upper 8 bits of the iIcon
 

!ListBox messages
api_LB_GETCURSEL            Equate(0188H)
api_LB_GETTEXT              Equate(0189H)
api_LB_GETTEXTLEN           Equate(018AH)
api_LB_GETCOUNT             Equate(018BH)

!ListView messages
api_LVM_FIRST               Equate(1000h)      
api_LVM_GETITEMCOUNT        Equate(api_LVM_FIRST + 4)
api_LVM_GETITEMTEXTA        Equate(api_LVM_FIRST + 45)
api_LVM_GETITEMTEXTW        Equate(api_LVM_FIRST + 115)
api_LVIF_TEXT               Equate(0001h)

api_LVITEM Group,Type
mask        UNSIGNED
iItem       Long
iSubItem    Long
state       UNSIGNED
stateMask   UNSIGNED
pszText     UNSIGNED
cchTextMax  Long
iImage      Long
lParam      Long
iIndent     Long
iGroupId    Long
cColumns    UNSIGNED ! tile view columns
puColumns   UNSIGNED
          End

!Security types
api_LUID Group,Type
LowPart     Ulong
HighPart    Long
        End

api_LUID_AND_ATTRIBUTES  Group,Type
Luid                      Like(api_LUID)
Attributes                Ulong
                        End

api_TOKEN_PRIVILEGES Group,Type
PrivilegeCount          UNSIGNED
Privileges              Like(api_LUID_AND_ATTRIBUTES),Dim(10) !you may need a larger
                    End

api_SE_PRIVILEGE_ENABLED      Equate(00000002h)

!Process rights
api_PROCESS_TERMINATE         Equate(0001h)
api_PROCESS_CREATE_THREAD     Equate(0002h)
api_PROCESS_SET_SESSIONID     Equate(0004h)
api_PROCESS_VM_OPERATION      Equate(0008h)
api_PROCESS_VM_READ           Equate(0010h)
api_PROCESS_VM_WRITE          Equate(0020h)
api_PROCESS_DUP_HANDLE        Equate(0040h)
api_PROCESS_CREATE_PROCESS    Equate(0080h)
api_PROCESS_SET_QUOTA         Equate(0100h)
api_PROCESS_SET_INFORMATION   Equate(0200h)
api_PROCESS_QUERY_INFORMATION Equate(0400h)
api_PROCESS_SUSPEND_RESUME    Equate(0800h)
api_TOKEN_ADJUST_PRIVILEGES   Equate(0020h)

api_PAGE_NOACCESS                   equate(01h)
api_PAGE_READONLY                   equate(02h)
api_PAGE_READWRITE                  equate(04h)
api_PAGE_WRITECOPY                  equate(08h)
api_PAGE_EXECUTE                    equate(10h)
api_PAGE_EXECUTE_READ               equate(20h)
api_PAGE_EXECUTE_READWRITE          equate(40h)
api_PAGE_EXECUTE_WRITECOPY          equate(80h)
api_PAGE_GUARD                      equate(100h)
api_PAGE_NOCACHE                    equate(200h)
api_MEM_COMMIT                      equate(1000h)
api_MEM_RESERVE                     equate(2000h)
api_MEM_DECOMMIT                    equate(4000h)
api_MEM_RELEASE                     equate(8000h)
api_MEM_FREE                        equate(10000h)
api_MEM_PRIVATE                     equate(20000h)
api_MEM_MAPPED                      equate(40000h)
api_MEM_RESET                       equate(80000h)
api_MEM_TOP_DOWN                    equate(100000h)
api_SEC_FILE                        equate(800000h)
api_SEC_IMAGE                       equate(1000000h)
api_SEC_RESERVE                     equate(4000000h)
api_SEC_COMMIT                      equate(8000000h)
api_SEC_NOCACHE                     equate(10000000h)

!//////////////////////////////////////////////////////////////////////
!                                                                     //
!                Registry API Constants                                //
!                                                                     //
! //////////////////////////////////////////////////////////////////////

api_HKEY_CLASSES_ROOT EQUATE(80000000h)
api_HKEY_CURRENT_USER EQUATE(80000001h)
api_HKEY_LOCAL_MACHINE EQUATE(80000002h)
api_HKEY_USERS EQUATE(80000003h)
api_HKEY_PERFORMANCE_DATA EQUATE(80000004h)
api_HKEY_CURRENT_CONFIG EQUATE(80000005h)
api_HKEY_DYN_DATA EQUATE(80000006h)

! Reg Create Type Values...
api_REG_OPTION_RESERVED EQUATE(0)           ! Parameter is reserved
api_REG_OPTION_NON_VOLATILE EQUATE(0)       ! Key is preserved when system is rebooted
api_REG_OPTION_VOLATILE EQUATE(1)           ! Key is not preserved when system is rebooted
api_REG_OPTION_CREATE_LINK EQUATE(2)        ! Created key is a symbolic link
api_REG_OPTION_BACKUP_RESTORE EQUATE(4)     ! open for backup or restore

! Reg Data Types...
api_REG_NONE EQUATE(0)                       ! No value type
api_REG_SZ EQUATE(1)                         ! Unicode nul terminated string
api_REG_EXPAND_SZ EQUATE(2)                  ! Unicode nul terminated string
api_REG_BINARY EQUATE(3)                     ! Free form binary
api_REG_DWORD EQUATE(4)                      ! 32-bit number
api_REG_DWORD_LITTLE_ENDIAN EQUATE(4)        ! 32-bit number (same as REG_DWORD)
api_REG_DWORD_BIG_ENDIAN EQUATE(5)           ! 32-bit number
api_REG_LINK EQUATE(6)                       ! Symbolic Link (unicode)
api_REG_MULTI_SZ EQUATE(7)                   ! Multiple Unicode strings
api_REG_RESOURCE_LIST EQUATE(8)              ! Resource list in the resource map
api_REG_FULL_RESOURCE_DESCRIPTOR EQUATE(9)   ! Resource list in the hardware description
api_REG_RESOURCE_REQUIREMENTS_LIST EQUATE(10)
api_REG_CREATED_NEW_KEY EQUATE(1h)                      ! New Registry Key created
api_REG_OPENED_EXISTING_KEY EQUATE(2h)                      ! Existing Key opened
api_REG_WHOLE_HIVE_VOLATILE EQUATE(1h)                      ! Restore whole hive volatile
api_REG_REFRESH_HIVE EQUATE(2h)                      ! Unwind changes to last flush
api_REG_NOTIFY_CHANGE_NAME EQUATE(1h)                      ! Create or delete (child)
api_REG_NOTIFY_CHANGE_ATTRIBUTES EQUATE(2h)
api_REG_NOTIFY_CHANGE_LAST_SET EQUATE(4h)                      ! Time stamp
api_REG_NOTIFY_CHANGE_SECURITY EQUATE(8h)
api_REG_LEGAL_CHANGE_FILTER EQUATE(0Fh)
api_REG_LEGAL_OPTION EQUATE(7h)

! Reg Key Security Options
api_READ_CONTROL EQUATE(20000h)
api_KEY_QUERY_VALUE EQUATE(1h)
api_KEY_SET_VALUE EQUATE(2h)
api_KEY_CREATE_SUB_KEY EQUATE(4h)
api_KEY_ENUMERATE_SUB_KEYS EQUATE(8h)
api_KEY_NOTIFY EQUATE(10h)
api_KEY_CREATE_LINK EQUATE(20h)
api_KEY_READ EQUATE(20009h)
api_KEY_WRITE EQUATE(20009h)
api_KEY_EXECUTE EQUATE(api_KEY_READ)
api_KEY_ALL_ACCESS EQUATE(api_KEY_WRITE)
api_STANDARD_RIGHTS_READ EQUATE(api_READ_CONTROL)
api_STANDARD_RIGHTS_WRITE   EQUATE(api_READ_CONTROL)

api_RECT            GROUP,TYPE 
left                  SIGNED
top                   SIGNED
right                 SIGNED
bottom                SIGNED
                    END

                          !Prototypes
  MAP
    MODULE('WINAPI')
     api_GetWindowThreadProcessId(api_HWND hWnd, *UNSIGNED lpdwProcessId),UNSIGNED, Pascal, Raw, Proc, Name('GetWindowThreadProcessId')
     api_OpenProcess(UNSIGNED dwDesiredAccess, BOOL bInheritHandle, UNSIGNED dwProcessId)api_HANDLE, Pascal, Name('OpenProcess')
     api_VirtualAllocEx(api_HANDLE hProcess, UNSIGNED lpAddress, ULong dwSize, ULONG flAllocationType, UNSIGNED flProtect),UNSIGNED, Pascal, Name('VirtualAllocEx')
     api_VirtualFreeEx(api_HANDLE hProcess, UNSIGNED lpAddress, ULong dwSize, ULong dwFreeType),BOOL, Pascal, Proc, Name('VirtualFreeEx')
     api_WriteProcessMemory(api_HANDLE hProcess, UNSIGNED lpBaseAddress, UNSIGNED lpBuffer, UNSIGNED nSize, <*UNSIGNED lpNumberOfBytesWritten>),BOOL, Pascal, Raw, Proc, Name('WriteProcessMemory')
     api_ReadProcessMemory(api_HANDLE hProcess, UNSIGNED lpBaseAddress, UNSIGNED lpBuffer, UNSIGNED nSize, <*UNSIGNED lpNumberOfBytesRead>),BOOL, Pascal, Raw, Proc, Name('ReadProcessMemory')
     api_OpenProcessToken(UNSIGNED processHandle, Ulong desiredAccess, *UNSIGNED tokenHandle),BOOL, Pascal, Proc, Raw, Name('OpenProcessToken')
     api_LookupPrivilegeValue(UNSIGNED lpSystemName, *Cstring szName, Long lpLuid),BOOL, Pascal, Proc, Raw, Name('LookupPrivilegeValueA')
     api_AdjustTokenPrivileges(UNSIGNED tokenHandle, Long disableAll, UNSIGNED lpTokenPrivileges, UNSIGNED buflen, UNSIGNED lpPrev, UNSIGNED lpRetLen),BOOL, Pascal, Proc, Raw, Name('AdjustTokenPrivileges')

      api_Access(*cstring,short),short,raw,name('_access')
      api_AllocConsole(),api_BOOL,RAW,PASCAL,NAME('AllocConsole')
      api_BringWindowToTop(UNSIGNED),UNSIGNED,PASCAL,NAME('BringWindowToTop')
      api_CallNextHookEx(Long,Long,Long,Long),Long,Raw,Pascal,NAME('CallNextHookEx')
      api_CoInitialize(LONG pvReserved=0  | Reserved; must be NULL
                  ),LONG, PASCAL, NAME('CoInitialize')
      api_CoUninitialize(),PASCAL,NAME('CoUninitialize')
      api_CopyFile(*cstring szFileName, *cstring szNewFileName, api_bool bFailIfExists),api_bool,raw,pascal,name('CopyFileA')
      api_CreateDirectory(*cSTRING lpPathName, LONG ),api_BOOL,PASCAL,RAW,NAME( 'CreateDirectoryA' )
      api_CreateProcess (ULONG lpApplicationName, ULONG lpCommandLine, ULONG lpProcessAttributes, ULONG lpThreadAttributes, api_BOOL bInheritHandles, api_DWORD dwCreationFlags, api_LPVOID lpEnvironment, ULONG lpCurrentDirectory, ULONG lpStartupInfo, ULONG lpProcessInformation),api_BOOL,RAW,PASCAL,NAME('CreateProcessA')
      api_DeleteFile(*cstring szFileName),api_bool,name('DeleteFileA'),raw,pascal
      api_DestroyIcon(UNSIGNED hIcon),BOOL,PASCAL,PROC,NAME('DestroyIcon')
      api_DuplicateHandle(api_HANDLE, api_HANDLE, api_HANDLE, api_HANDLE, api_DWORD, api_BOOL, api_DWORD),api_BOOL,PASCAL,RAW,Name('DuplicateHandle')
      api_EnumChildWindows(api_HWND hWndParent, UNSIGNED lpEnumFunc, Long lParam ),Bool, Pascal, Name('EnumChildWindows')
      api_EnumWindows(Long,Long),proc,pascal,byte,NAME('EnumWindows')
      api_ExitWindows(ulong, signed),signed,PASCAL,NAME('ExitWindowsEx')
      api_FileTimeToLocalFileTime(*api_FILETIMEType,*api_FILETIMEType),api_BOOL,PASCAL,RAW,Name('FileTimeToLocalFileTime')
      api_FileTimeToSystemTime(*api_FILETIMEType,*api_SYSTEMTIME lpSystemTime),api_BOOL,PASCAL,RAW,Name('FileTimeToSystemTime')
      api_FindClose( LONG hFindFile ),api_BOOL,RAW,PASCAL,PROC,NAME('FINDClose')
      api_FindFirstFile( *CSTRING lpFileName, *api_WIN32_FIND_DATA ),LONG,RAW,PASCAL,NAME('FindFirstFileA')
      api_FindResource(LONG,LONG,LONG),LONG,PASCAL,RAW,NAME('FindResourceA')
      api_FindWindow(<*cstring lpszClassName>, <*cstring lpszWindowName>),api_HWND,raw,pascal,name('FindWindowA')
      api_FNSplit(*CSTRING Path, *CSTRING Drv, *CSTRING Dir, *CSTRING Nme, *CSTRING Ext),SIGNED,PROC,RAW,NAME('_fnsplit')
      api_FormatMessage(api_DWORD,LONG,api_DWORD,api_DWORD,*CSTRING,api_DWORD,LONG),api_DWORD,PASCAL,RAW,NAME('FormatMessageA')
      api_FreeConsole(),api_BOOL,RAW,PASCAL,NAME('FreeConsole')
      api_FreeLibrary(LONG),api_BOOL,RAW,PASCAL,NAME('FreeLibrary')
      api_FreeResource(LONG),LONG,PASCAL,NAME('FreeResource')
      api_GetClassName(api_HWND hWnd, *Cstring lpClassName, Long nMaxCount),Long, Pascal, Raw, Proc, Name('GetClassNameA')
      api_GetClientRect(LONG,*api_RECT),PASCAL,RAW,NAME('GetClientRect')
      api_GetComputerName(*CSTRING,*ULONG),api_BOOL,PASCAL,RAW,NAME('GetComputerNameA'),PROC
      api_GetCurrentProcess(),api_HWND,PASCAL,RAW,NAME('GetCurrentProcess')
      api_GetDC(api_HWND hwnd),api_HDC,pascal,NAME('GetDC')
      api_GetDesktopWindow(),api_HWND,PASCAL,RAW,NAME('GetDesktopWindow()')
      api_GetDOSEnv(string),string,NAME('GetDOSEnv')
      api_GetDriveType(*api_LPCSTR),UNSIGNED,PASCAL,RAW,NAME('GetDriveTypeA')
      api_GetEnvironment(*CSTRING),CSTRING,RAW,NAME('_GETENV')
      api_GetExitCodeProcess (api_HANDLE hProcess,ULONG lpExitCode),api_BOOL,PASCAL,NAME('GetExitCodeProcess')
      api_GetFileTime(unsigned,*api_FILETIMEType,*api_FILETIMEType,*api_FILETIMEType),api_BOOL,PASCAL,RAW,NAME('GetFileTime')
      api_GetLastError(),LONG,PASCAL,NAME('GetLastError')
      api_GetLastInputInfo(*api_LASTINPUTINFO),LONG,PASCAL,PROC,RAW,NAME('GetLastInputInfo')
      api_GetModuleFileName(UNSIGNED,*CSTRING,LONG),LONG,PASCAL,RAW,NAME('GetModuleFileNameA')
      api_GetModuleHandle(LONG),LONG,PASCAL,RAW,NAME('GetModuleHandleA')
      api_GetModuleUsage(api_HINSTANCE),SIGNED,PASCAL,NAME('GetModuleUsage')
      api_GetNextWindow(api_HWND, api_WORD),api_HWND,PASCAL,NAME('GetNextWindow')
      api_GetNumTasks(),SIGNED,PASCAL,NAME('GetNumTasks()')
      api_GetParent(LONG),LONG,PASCAL,RAW,NAME('GetParent')
      api_GetProcAddress(LONG, *CSTRING),ULONG,RAW,PASCAL,NAME('GetProcAddress')
      api_GetStdHandle(LONG),ULONG,PROC,PASCAL,RAW,NAME('GetStdHandle')
      api_GetVersion(),api_DWORD,PASCAL,NAME('GetVersion()')
      api_GetVersionEx(ULONG),api_BOOL,PASCAL,RAW,NAME('GetVersionExA')
      api_GetWindow(api_HWND,UNSIGNED),api_HWND,PASCAL,NAME('GetWindow')
      api_GetWindowRect(api_HWND, *RECT),api_BOOL,PASCAL,RAW,NAME('GetWindowRect')
      api_GetWindowTask(api_HWND),api_HTASK,PASCAL,NAME('GetWindowTask')
      api_GetWindowText(UNSIGNED, LONG,SIGNED),SIGNED,PASCAL,RAW,NAME('GetWindowTextA')
      api_GetWindowThreadProcessId(unsigned,*ulong),ulong,PASCAL,NAME('GetWindowThreadProcessId')
      api_GlobalAlloc(UNSIGNED,ulong),unsigned,PASCAL,name('GlobalAlloc')
      api_GlobalFree(unsigned),unsigned,PASCAL,proc,Name('GlobalFree')
      api_GlobalLock(unsigned),LONG,PASCAL,name('GlobalLock')
      api_GlobalMemoryStatus(*MEMORYSTATUS),PASCAL,RAW,NAME('GlobalMemoryStatus(')
      api_globalsize(unsigned),ulong,pascal,Name('GlobalSize')
      api_globalunlock(unsigned),long,pascal,proc,Name('GlobalUnlock')
      api_ImageList_Draw(LONG, LONG, api_HDC, long, long,ULONG),short,PASCAL,RAW,NAME('ImageList_Draw')
      api_InitCommonControls(),RAW,PASCAL,NAME('InitCommonControls')
      api_InitCommonControlsEx(api_LPINITCOMMONCONTROLSEX),LONG,RAW,PASCAL,NAME('InitCommonControlsEx')
      api_Incr(*LONG),LONG,PASCAL,PROC,NAME('InterlockedIncrement')
      api_InvalidateRect(UNSIGNED hWnd1, LONG lpRect, SIGNED bErase),PASCAL,NAME('InvalidateRect')
      api_LoadLibrary(*CSTRING),ULONG,RAW,PASCAL,NAME('LoadLibraryA')
      api_LoadLibrary(Long),Long,Raw,Pascal,Name('LoadLibraryA')
      api_LoadResource(LONG, LONG),LONG,PASCAL,NAME('LoadResource')
      api_LocalFileTimeToFileTime(*api_FILETIMEType,*api_FILETIMEType),api_BOOL,PASCAL,RAW,Name('LocalFileTimeToFileTime')
      api_LockResource(LONG),ULONG,PASCAL,NAME('LockResource')
      api_LStrCpy(*CString,LONG),LONG,PASCAL,RAW,PROC,NAME('LStrCpy(')
      api_LtoA(LONG,*CSTRING,SIGNED),ULONG,RAW,NAME('_ltoa'),PROC
      api_memcpy(LONG,LONG,UNSIGNED),NAME('_memcpy')
      api_memset(LONG,LONG,UNSIGNED),NAME('_memset')
      api_MkDir(*cstring),short,raw,name('_mkdir')
!RSMMORE - get rid of these moai after making sure they aren't currently in use.
      moai_CloseHandle(UNSIGNED),SIGNED,PROC,PASCAL,NAME('CloseHandle')
      moai_CreateMutex(ULONG,SIGNED,<*CSTRING>),UNSIGNED,RAW,PASCAL,NAME('CreateMutexA')                 
      moai_GetLastError(),SIGNED,PASCAL,NAME('GetLastError')
      api_CreateMutex (<*LONG>,SIGNED,<*CSTRING>),UNSIGNED,RAW,PASCAL,NAME('CreateMutexA')
      api_MoveWindow(UNSIGNED hWnd1, SIGNED X, SIGNED y, SIGNED nWidht, SIGNED nHeight, SIGNED bRepaint),PASCAL,NAME('MoveWindow')
      api_OutputDebugString(*CString),RAW,PASCAL,NAME('OutputDebugStringA')
      api_PostMessage(UNSIGNED,UNSIGNED,UNSIGNED,LONG),proc,pascal,BYTE,NAME('PostMessageA')
      api_ReleaseDC(api_HWND hwnd, api_HDC hdc),bool,pascal,proc,NAME('ReleaseDC')
      api_Removey(*cstring),short,raw,name('_remove')
      api_Rename(*cstring, *cstring), short, raw, name('_rename')
      api_ReplaceFile(*cstring szFileName, *cstring szReplacementFileName, long lpBackupFileName, long dwReplaceFlags, |
                long lpExclude = 0, long lpReserved = 0),api_bool,raw,pascal,name('ReplaceFileA')
      api_RmDir(*CSTRING),SHORT, RAW, NAME('_rmdir')
      api_SearchPathA(*CSTRING, *CSTRING, *CSTRING, ULONG, *CSTRING, ULONG), ULONG, PASCAL, RAW,NAME('SearchPathA')
      api_SendMessage(UNSIGNED hwnd1, UNSIGNED uMsg, SIGNED wParam, LONG lParam),LONG,PASCAL,PROC,NAME('SendMessage')
      api_SendMessageTimeout(api_HWND hWnd, Long uMsg, UNSIGNED wParam, Long lParam, UNSIGNED fuFlags, UNSIGNED uTimeout, *Long lpdwResult),Long,Pascal,Raw Name('SendMessageTimeoutA')
      api_SetEnvironmentVariableA(*CSTRING,*CSTRING),api_BOOL,PASCAL,RAW,NAME('SetEnvironmentVariableA')
      api_SetFileTime(unsigned,*api_FILETIMEType,*api_FILETIMEType,*api_FILETIMEType),api_BOOL,PASCAL,RAW,NAME('SetFileTime')
      api_SetFocus(UNSIGNED),UNSIGNED,PASCAL      ! Returns last window with focus,NAME('SetFocus')
      api_SetStdHandle(LONG, api_HANDLE),ULONG,PROC,PASCAL,RAW,NAME('SetStdHandle')
      api_SetWindowPos(UNSIGNED,UNSIGNED,SHORT,SHORT,SHORT,SHORT,USHORT),SHORT,PASCAL,NAME('SetWindowPos')
      api_SetWindowsHookEx(Long,Long,Long,Long),Long,Raw,Pascal,Name('SetWindowsHookExA')
!     api_SHCreateDirectoryEx(LONG pHwnd, *cSTRING lpPathName, LONG pSECURITY_ATTRIBUTES),LONG,PASCAL,RAW,NAME( 'SHCreateDirectoryExA' )
      api_ShellExecute(UNSIGNED,*CSTRING,*CSTRING,*CSTRING,*CSTRING,SIGNED),UNSIGNED,PASCAL,RAW,NAME('ShellExecuteA')
      api_ShellExecuteEx(*api_SHELLEXECUTEINFOgroup),SIGNED,PASCAL,RAW, DLL, NAME('ShellExecuteExA')
      api_shGetFileInfo(*CSTRING pszPath,            |
                    UNSIGNED dwFileAttributes,   |
                    *api_SHFILEINFO psfi,            |
                    UNSIGNED cbFileInfo,         |
                    ULONG uFlags                 |
                   ),LONG, PASCAL, RAW, NAME('shGetFileInfoA')
      api_ShowWindow(UNSIGNED,SIGNED),SIGNED,PASCAL,PROC,NAME('ShowWindow')    
      api_SizeofResource(LONG, LONG),ULONG,PASCAL,NAME('SizeofResource')
      api_Sleep(ULONG),PASCAL,NAME('Sleep')
      api_sndPlaySound(*api_LPCSTR,UNSIGNED),api_BOOL,PROC,pascal,raw,NAME('sndPlaySoundA')
      api_SystemTimeToFileTime(*api_SYSTEMTIME lpSystemTime, *api_FILETIMEType),api_BOOL,PASCAL,RAW,NAME('SystemTimeToFileTime')
      api_UnhookWindowsHookEx(Long),api_Bool,Raw,Pascal,NAME('UnhookWindowsHookEx')
      vsCallWinProc           (LONG,UNSIGNED,UNSIGNED,UNSIGNED,LONG),LONG,PASCAL,NAME('CallWindowProcA')
      api_WinExec(*api_LPCSTR,UNSIGNED),UNSIGNED,PASCAL,RAW,NAME('WinExec')
      COMPILE('***',_WIDTH32_)
        api_Chmod(*Cstring,ulong),api_bool,Pascal,Raw,Name('SetFileAttributesA')
        api_CallWindowProc(LONG,UNSIGNED,UNSIGNED,UNSIGNED,LONG),LONG,PASCAL,NAME('CallWindowProcA')
        api_CloseHandle(unsigned),api_BOOL,PASCAL,proc,Name('CloseHandle')
        api_CreateFile(*cstring,ulong,ulong,long,ulong,ulong,unsigned),unsigned,PASCAL,RAW,Name('CreateFileA')
        api_CreatePipe(long,long,long,long),ulong,PASCAL,RAW,NAME('CreatePipe')
        api_GetFileSize(unsigned,<*ulong>),ulong,PASCAL,Name('GetFileSize')
        api_GetForegroundWindow(),UNSIGNED,PASCAL,NAME('GetForegroundWindow')
        api_GetModuleHandle(*api_LPCSTR),api_HMODULE,PASCAL,RAW,NAME('GetModuleHandleA')
        api_GetPrivateProfileString(*api_LPCSTR,*api_LPCSTR,*api_LPCSTR,*api_LPSTR,api_DWORD,*api_LPCSTR),api_DWORD,PASCAL,RAW,NAME('GetPrivateProfileStringA')
        api_GetSystemDirectory(*CSTRING, UNSIGNED),UNSIGNED,PASCAL,RAW,NAME('GetSystemDirectoryA')
        api_GetTempFileName(*cstring,*cstring,UNSIGNED,*cstring),UNSIGNED,PASCAL,RAW,NAME('GetTempFileNameA'),proc
        api_GetTempPathA(long,*cstring),Long,PASCAL,RAW,proc,name('GetTempPathA')
        api_GetWindowsDirectory(*api_LPSTR,UNSIGNED),UNSIGNED,PASCAL,RAW,NAME('GetWindowsDirectoryA')
        api_GetWindowText(api_HWND,*api_LPSTR,SIGNED),SIGNED,PASCAL,RAW,NAME('GetWindowTextA')
        api_GetWindowTextLength(api_HWND),SIGNED,PASCAL,NAME('GetWindowTextLengthA')
        api_LoadIcon(UNSIGNED,LONG),UNSIGNED,PASCAL,NAME('LoadIconA')
        api_ReadFile(ulong,long,ulong,long,long),long,pascal,raw,Name('ReadFile')
        api_RegCloseKey(api_HKEY),LONG,PASCAL,NAME('RegCloseKey')
        api_RegCreateKeyEx(LONG,LONG,LONG,LONG,LONG,LONG,LONG,LONG,LONG),LONG,PASCAL,RAW,NAME('RegCreateKeyExA')
        api_RegSetValueEx(LONG,LONG,LONG,LONG,LONG,LONG),LONG,RAW,PASCAL,NAME('RegSetValueExA')
        api_RegCreateKey(api_HKEY,*api_LPCSTR,api_DWORD,*api_LPSTR,api_DWORD,api_DWORD,*api_DWORD,*api_HKEY,*api_DWORD),LONG,PASCAL,RAW,NAME('RegCreateKeyExA')
        api_RegDeleteKey(api_HKEY,*api_LPCSTR),LONG,PASCAL,NAME('RegDeleteKeyA')
        api_RegEnumKey(api_HKEY,api_DWORD,*api_LPSTR,api_DWORD),LONG,PASCAL,RAW,NAME('RegEnumKeyA')
        api_RegOpenKey(api_HKEY,*api_LPCSTR,api_DWORD,api_DWORD,*api_HKEY),LONG,PASCAL,RAW,NAME('RegOpenKeyExA')
        api_RegQueryValue(api_HKEY,*api_LPCSTR,*api_DWORD,*api_DWORD,*CSTRING,*api_DWORD),LONG,PASCAL,RAW,NAME('RegQueryValueExA')
        api_RegSetValue(api_HKEY,*api_LPCSTR,api_DWORD,api_DWORD,LONG,api_DWORD),LONG,PASCAL,RAW,NAME('RegSetValueExA')
        api_SetFilePointer(UNSIGNED, LONG, LONG, ULONG),ULONG,PROC,PASCAL,RAW,Name('SetFilePointer')
        api_SetHandleInformation( api_HANDLE, api_DWORD, api_DWORD),ULONG,PROC,PASCAL,RAW,NAME('SetHandleInformation')
        api_SetForegroundWindow(UNSIGNED),api_BOOL,PASCAL,NAME('SetForegroundWindow')
        api_SetWindowLong(UNSIGNED,SIGNED,LONG),LONG,RAW,PASCAL,NAME('SetWindowLongA')
        api_Shell_NotifyIcon(ULONG,LONG),api_BOOL,PASCAL,NAME('Shell_NotifyIconA')
        api_WriteFile(unsigned,long,ulong,*ulong,long),api_BOOL,PASCAL,RAW,proc,Name('WriteFile')
        api_WaitForMultipleObjects(LONG,LONG,LONG,LONG),RAW,LONG,PASCAL,PROC, NAME('WaitForMultipleObjects')
        api_WaitForSingleObject(UNSIGNED, ULONG), UNSIGNED, PASCAL, NAME('WaitForSingleObject')
      ***
    END      
  END
