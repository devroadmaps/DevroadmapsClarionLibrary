										PROGRAM

    include('DCL_clariontest_testrunner.inc'),once
    include('DCL_clariontest_testresult.inc'),once
    Include('DCL_System_Runtime_DirectoryWatcher.inc'),once
    include('DCL_System_Diagnostics_Logger.inc'),once
    include('DCL_System_String.inc'),once
    include('DCL_System_IO_Directory.inc'),once
    Include('DCL_System_IO_StdOut.inc'),Once
    INCLUDE('ABUTIL.INC'),ONCE


                                            MAP
                                                module('ClarionTest_Main.clw')
                                                    main()
                                                end
                                                module('ClarionTest_About.clw')
                                                    About()
                                                end
                                                Module('ClarionTest_Settings.clw')
                                                    Settings()
                                                end
                                                MODULE('')
                                                    SLEEP(LONG),PASCAL
                                                END
                                            end

Settings                                    INIClass                              ! Global non-volatile storage manager

    CODE
    Settings.Init(LongPath() & '\ClarionTest.INI', NVD_INI)                ! Configure INIManager to use INI file
    Main()
    Settings.Kill                                              ! Destroy INI manager




!!
!!!MJH 2012/04/17 - Potentially redundant EQUATEs
!!!These equates are defined in SVAPI.INC, but there are issues with dups that 
!!!cause some people to remove these from that file.  However, they are still 
!!!needed by WINAPI.INC, so I've added them here.  Ignore the compiler warnings.!
!!!(Due to the way they are included, there is no easy way to prevent the warnings.)
!!
!!STATUS_WAIT_0                               equate(000000000h)
!!STATUS_USER_APC                             equate(0000000C0h)
!!STATUS_TIMEOUT                              equate(000000102h)
!!
!!WAIT_OBJECT_0                               equate((STATUS_WAIT_0) + 0)
!!WAIT_IO_COMPLETION                          equate(STATUS_USER_APC)
!!WAIT_TIMEOUT                                equate(STATUS_TIMEOUT)
!!INFINITE                                    equate(0FFFFFFFFh) ! Infinite timeout
!!WINEVENT:Version                            equate ('3.74')   !Deprecated
!!WinEvent:TemplateVersion                    equate('3.74')
!!event:WinEventTaskbarLoadIcon               equate(0500h+5510)
!!
!!    INCLUDE('ABERROR.INC'),ONCE
!!    INCLUDE('ABUTIL.INC'),ONCE
!!    INCLUDE('ERRORS.CLW'),ONCE
!!    INCLUDE('KEYCODES.CLW'),ONCE
!!    INCLUDE('ABDST.INC'),ONCE
!!!    INCLUDE('ABFUZZY.INC'),ONCE
!!    INCLUDE('ABMIME.INC'),ONCE
!!!   INCLUDE('JPWBFISH.INC'),ONCE
!!!!   include('csGPF.Inc'),ONCE
!!!     include('hyper.inc'),once
!!!	include('DCL_system_diagnostics_debugger.inc'),once
!!!
!!!
!!
!!!gdbg                                    DCL_System_Diagnostics_Debugger,external,dll
!!    !Include('EventEqu.Clw'),Once
!!!    INCLUDE('iQXML.INC','Equates')
!
!                                            MAP
!                                                MODULE('CLARIONTEST_BC.CLW')
!DctInit                                             PROCEDURE                                      ! Initializes the dictionary definition module
!DctKill                                             PROCEDURE                                      ! Kills the dictionary definition module
!                                                END
!                                                MODULE('CLARIONTEST001.CLW')
!RunTests                                            PROCEDURE   !
!SettingsForm                                        PROCEDURE   !Form Settings
!About                                               PROCEDURE   !
!                                                END
!                                                !include('eventmap.clw')
!                                                !INCLUDE('iQXML.INC','Modules')
!                                                !URLHandler(unsigned, STRING)
!                                                !MODULE('winstuff')
!                                                !    ShellExecute(UNSIGNED,LONG,*CSTRING,LONG,*CSTRING,SIGNED),UNSIGNED,PASCAL,RAW,NAME('SHELLEXECUTEA')
!                                                !END
!                                                !MyOKToEndSessionHandler(long pLogoff),long,pascal
!                                                !MyEndSessionHandler(long pLogoff),pascal
!                                            END
!
!SETUP                                       GROUP,PRE(SET)
!FolderToMonitor                                 STRING(220)
!MonitorMode                                     BYTE
!AutoRunTest                                     BYTE
!Domain                                          STRING(120)
!SMTPServer                                      STRING(120)
!SMTPPort                                        STRING(120)
!SMTPUser                                        STRING(120)
!SMTPPassword                                    STRING(120)
!SenderAddress                                   STRING(120)
!FromHeaderAddress                               STRING(120)
!FromHeaderName                                  STRING(120)
!                                            END
!SilentRunning                               BYTE(0)                               ! Set true when application is running in 'silent mode'
!
!!region File Declaration
!!endregion
!
!!ThisGPF                                     Class(GPFReporterClass)
!!Initialize                                      PROCEDURE () ,VIRTUAL
!!ExtraReportText                                 PROCEDURE () ,VIRTUAL
!!                                            End
!!GlobalAddresses                             AdrMgr
!!AddressBook                                 AddressVisual
!!AddressBookUpd                              CLASS(AdrVisualUpdate)
!!Init                                            PROCEDURE(),BYTE,PROC,DERIVED
!!                                            END
!!
!!eMail                                       SMTPTransport
!!News                                        NNTPTransport
!!Base64                                      Base64FileMgr,THREAD
!!PlainEncoder                                NoneFM,THREAD
!!QuotedPrintable                             QuotedPrintFM,THREAD
!!DbMessage                                   DocumentHandler
!!DbAddresses                                 AdrMgr
!!SilentErrorsStatus                          ErrorStatusClass,THREAD
!!SilentErrors                                CLASS(ErrorClass)
!!Init                                            PROCEDURE()
!!ViewHistory                                     PROCEDURE(),DERIVED
!!                                            END
!
!
!!FuzzyMatcher                                FuzzyClass                            ! Global fuzzy matcher
!GlobalErrorStatus                           ErrorStatusClass,THREAD
!GlobalErrors                                ErrorClass                            ! Global error manager
!GlobalRequest                               BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
!GlobalResponse                              BYTE(0),THREAD                        ! Set to the response from the form
!VCRRequest                                  LONG(0),THREAD                        ! Set to the request from the VCR buttons
!
!Dictionary                                  CLASS,THREAD
!Construct                                       PROCEDURE
!Destruct                                        PROCEDURE
!                                            END
!
!
!    CODE
!    GlobalErrors.Init(GlobalErrorStatus)
!    !FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
!    !FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
!    !FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
!    DctInit
!!    SilentErrors.Init(SilentErrorsStatus)
!!    GlobalAddresses.Init(INIMgr, 'Global')
!!    AddressBook.Init(AddressBookUpd, INIMgr, GlobalErrors)
!!    Base64.Init(GlobalErrors)
!!    QuotedPrintable.Init(GlobalErrors)
!!    PlainEncoder.Init(GlobalErrors)
!!    eMail.Init(GlobalAddresses.GetIABook(), SilentErrors)
!!    eMail.DefaultServer = SET:SMTPServer
!!    eMail.DefaultPort = SET:SMTPPort
!!    eMail.AuthUser = SET:SMTPUser
!!    eMail.AuthPass = SET:SMTPPassword
!!    eMail.Sender = SET:SenderAddress
!!    eMail.From = SET:FromHeaderName & ' <<' & SET:FromHeaderAddress & '>'
!!    eMail.SenderDomain = SET:Domain
!!    News.Init(GlobalAddresses.GetIABook(), SilentErrors)
!!    News.DefaultServer = ''
!!    News.DefaultPort = '119'
!!    News.User = ''
!!    News.Password = ''
!!    DbMessage.Init(SilentErrors)
!!    DbMessage.AddDST(eMail.IDST,SMTP)
!!    DbMessage.AddDST(News.IDST,NNTP)
!!    DbAddresses.Init(INIMgr, 'DbAddresses')
!    !ds_SetOKToEndSessionHandler(address(MyOKToEndSessionHandler))
!    !ds_SetEndSessionHandler(address(MyEndSessionHandler))
!    RunTests
!    INIMgr.Update
!    !ThisGPF.RestartProgram = 0
!!    eMail.Kill()
!!    News.Kill()
!!    Base64.Kill()
!!    QuotedPrintable.Kill()
!!    PlainEncoder.Kill()
!!    GlobalAddresses.Kill()
!!    DbMessage.Kill()
!!    DbAddresses.Kill()
!!    SilentErrors.Kill()
!    !FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher
!    
!
!!AddressBookUpd.Init                         PROCEDURE
!!
!!ReturnValue                                     BYTE,AUTO
!!
!!    CODE
!!    ReturnValue = PARENT.Init()
!!    AddressBookUpd.AddItem(eMail.IDST, 'SMTP')
!!    AddressBookUpd.AddItem(News.IDST, 'NNTP')
!!    RETURN ReturnValue
!!
!!
!!SilentErrors.Init                           PROCEDURE
!!
!!    CODE
!!    PARENT.Init
!!    SELF.SetHistoryThreshold(1000)
!!    SELF.SetHistoryViewLevel(Level:Notify)
!!    SELF.SetHistoryResetOnView(True)
!!    SELF.SetSilent(True)
!!
!!
!!SilentErrors.ViewHistory                    PROCEDURE
!!
!!    CODE
!!    PARENT.ViewHistory
!!    IF SELF.GetHistoryResetOnView()
!!        SELF.ResetHistory()
!!    END
!
!!!----------------------------------------------------
!!ThisGPF.Initialize                          PROCEDURE ()
!!    CODE
!!    ThisGPF.EmailAddress = 'The developer <support@example.com>'
!!    ThisGPF.WindowTitle = ''
!!    ThisGPF.DumpFileName = 'GPFReport.log'
!!    ThisGPF.DumpFileAppend = 1
!!    ThisGPF.RestartProgram = 1
!!    ThisGPF.ShowDetails = 0
!!    ThisGPF.DebugEmail = 0
!!    ThisGPF.DebugLogEnabled = 0
!!    ThisGPF.WaitWinEnabled = 0
!!    ThisGPF.Workstation = ds_GetWorkstationName()     ! requires winevent ver 3.61 or later
!!    ThisGPF.UserName = ds_GetUserName()               ! requires winevent ver 3.61 or later
!!    PARENT.Initialize ()
!!!----------------------------------------------------
!!ThisGPF.ExtraReportText                     PROCEDURE ()
!!    CODE
!!    ! ThisGPF.ReportText = 'Add your own report text here.'<13,10>This is on the next line.'
!!    PARENT.ExtraReportText ()
!!MyOKToEndSessionHandler                     procedure(long pLogoff)
!!OKToEndSession                                  long(TRUE)
!!! Setting the return value OKToEndSession = FALSE
!!! will tell windows not to shutdown / logoff now.
!!! If parameter pLogoff = TRUE if the user is logging off.
!!
!!    code
!!    return(OKToEndSession)
!!
!!
!!MyEndSessionHandler                         procedure(long pLogoff)
!!! If parameter pLogoff = TRUE if the user is logging off.
!!
!!    code
!!URLHandler                                  PROCEDURE (wHandle, URL)                   ! Declare Procedure
!!
!!URLBuffer                                       CSTRING(256)
!!EmptyString                                     CSTRING(254)
!!
!!    CODE                                                          ! Begin processed code
!!    URLBuffer = CLIP(URL)
!!    EmptyString=''
!!    x#=ShellExecute(whandle, 0, URLBuffer, 0, EmptyString, 1)
!!
!
!
!Dictionary.Construct                        PROCEDURE
!
!    CODE
!    IF THREAD()<>1
!        DctInit()
!    END
!
!
!Dictionary.Destruct                         PROCEDURE
!
!    CODE
!    DctKill()
!
