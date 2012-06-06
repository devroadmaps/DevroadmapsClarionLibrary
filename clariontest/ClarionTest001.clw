

                                            MEMBER('ClarionTest.clw')                               ! This is a MEMBER module


    INCLUDE('ABRESIZE.INC'),ONCE
    INCLUDE('ABTOOLBA.INC'),ONCE
    INCLUDE('ABUTIL.INC'),ONCE
    INCLUDE('ABWINDOW.INC'),ONCE

myConfigQueue                               QUEUE,PRE()
FolderToMonitor                                 STRING(220)
MonitorMode                                     STRING(20)
AutoRunTest                                     STRING(20)
Domain                                          STRING(120)
SMTPServer                                      STRING(120)
SMTPPort                                        STRING(120)
SMTPUser                                        STRING(120)
SMTPPassword                                    STRING(120)
SenderAddress                                   STRING(120)
FromHeaderAddress                               STRING(120)
FromHeaderName                                  STRING(120)
                                            END
recs                                        LONG
X                                           LONG
MyKey                                       STRING('ClarionTestFTW456 {15}')
MyText                                      STRING(10000)
!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
RunTests                                    PROCEDURE 

firstdisplay                                    byte(true)
TestRunner                                      DCL_ClarionTest_TestRunner
ProceduresQ                                     queue(DCL_ClarionTest_ProceduresQueue)
                                                end
TestResult                                      &DCL_ClarionTest_TestResult
                                                itemize(1),pre(Style)
Default                                             equate
Passed                                              equate
Failed                                              equate
Bold                                                equate
                                                end

eGroup                                          equate(1)
eChild                                          equate(2)

runall                                          byte(true)
DllNameAndPath                                  cstring(255)
!dbg             DCL_system_diagnostics_debugger


TestDll                                         STRING(255)                           !
LS_SMTPPassword                                 CSTRING(120)                          !
LL_NotifyType                                   LONG                                  !
LogQ                                            QUEUE,PRE()                           !
lQDate                                              LONG                                  !
lQStartTime                                         LONG                                  !
lQEndTime                                           LONG                                  !
lQTest                                              STRING(200)                           !
lQResult                                            STRING(200)                           !
                                                END                                   !
l:DoNotMonitor                                  BYTE                                  !
ChangedDllsQ                                    QUEUE,PRE()                           !
DllName                                             STRING(100)                           !
                                                END                                   !
AllFiles                                        QUEUE(File:queue),PRE(FIL)            !
                                                END                                   !
LB_Description                                  STRING(200)                           !
TestDllsQ                                       QUEUE,PRE()                           !
fQName                                              STRING(100)                           !
fQDate                                              LONG                                  !
fQTime                                              LONG                                  !
fQMarked                                            BYTE                                  !
                                                END                                   !
LB_Passed                                       BYTE                                  !
LB_UnitTest                                     STRING(100)                           !
LB_Result                                       STRING(200)                           !
LB_TestGroup                                    STRING(30)                            !
LB_Priority                                     DECIMAL(7,2)                          !
LB_Selected                                     LONG                                  !
LB_Marked                                       BYTE                                  !
LB_qTestGroup                                   STRING(200)                           !
DCL_DisplayQueue                                QUEUE,PRE()                           !
qTestGroup                                          STRING(200)                           !
qLevel                                              LONG                                  !
qTestGroupStyle                                     LONG                                  !
qPriority                                           DECIMAL(6,2)                          !
qPriorityStyle                                      LONG                                  !
qTestResult                                         STRING(400)                           !
qTestResultStyle                                    LONG                                  !
qTestDescription                                    STRING(100)                           !
qTestLongDescription                                STRING(5000)                          !
qPassed                                             BYTE                                  !
qPassedStyle                                        LONG                                  !
qMark                                               BYTE                                  !
qPointer                                            LONG                                  !
qType                                               BYTE                                  !
                                                END                                   !
                                                ! LIST,AT(13,31,349,219),USE(?LIST),HVSCROLL,FORMAT('162L(2)MY~Test Name~@s100@800L(2)Y~Result~@s200@'),FROM(ProceduresQ),MARK(ProceduresQ.mark)
                
cTarget                                         cstring(220)
eMyNotifyCode                                   equate(222)
eMyNotifyParam                                  equate(0)
myChg                                           DCL_System_Runtime_DirectoryWatcher
notifyCode                                      unsigned
notifyParam                                     long
Window                                          WINDOW('ClarionTest'),AT(,,754,380),FONT('Segoe UI',8,,FONT:regular),RESIZE,CENTER, |
                                                    ICON('ClarionTest.ico'),GRAY,SYSTEM,IMM
                                                    SHEET,AT(0,0,752,378),USE(?SHEET1),BELOW
                                                        TAB('Tab1'),USE(?TAB1)
                                                            BOX,AT(0,0,751,26),USE(?BOX1),COLOR(COLOR:Silver),FILL(COLOR:Silver),LINEWIDTH(1)
                                                            BOX,AT(196,-1,209,27),USE(?BOX2),COLOR(00F5F5F5h),FILL(00F5F5F5h),LINEWIDTH(1)
                                                            PROMPT('Test DLL:'),AT(295,260,45),USE(?TestDll:Prompt),FONT(,10,,FONT:regular),RIGHT,HIDE, |
                                                                TRN
                                                            ENTRY(@s255),AT(345,259,378,15),USE(TestDll),HIDE
                                                            BUTTON('...'),AT(727,258,18,16),USE(?LookupFile),HIDE
                                                            LIST,AT(582,335,87,12),USE(?LIST2),HVSCROLL,FORMAT('85L(2)MY~Test Group~@s30@41L(2)MY~P' & |
                                                                'riority~@n_5.2@261L(2)MY~Test Name~@s100@800L(2)Y~Result~@s200@'),FROM(ProceduresQ),HIDE, |
                                                                MARK(proceduresq.mark)
                                                            LIST,AT(197,31,555,270),USE(?LIST),FONT(,10),HVSCROLL,FORMAT('259L(2)|MYT(1)~Test Group' & |
                                                                '~@s200@#1#1020L(2)Y~Test Result~@s255@#6#'),FROM(DCL_DisplayQueue),MARK(DCL_DisplayQueue.qMark)
                                                            STRING('Reload'),AT(264,2),USE(?ReloadMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
                                                            STRING('Reload & Run All'),AT(264,15,70),USE(?ReloadAndRunMenu),FONT(,10,,FONT:regular+FONT:underline), |
                                                                TRN
                                                            STRING('Run All'),AT(203,2),USE(?RunAllMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
                                                            STRING('Run Selected'),AT(203,15),USE(?RunSelectedMenu),FONT(,10,,FONT:regular+FONT:underline), |
                                                                TRN
                                                            STRING('Clear Results'),AT(341,2),USE(?ClearResultsMenu),FONT(,10,,FONT:regular+FONT:underline), |
                                                                TRN
                                                            STRING('Clear Marks'),AT(341,15),USE(?ClearMarksMenu),FONT(,10,,FONT:regular+FONT:underline), |
                                                                TRN
                                                            LIST,AT(5,49,187,322),USE(?LIST1),HVSCROLL,FORMAT('57L(2)|M~Test DLLs~@s100@54R(2)|M~Da' & |
                                                                'te~C(0)@D17@60R(2)|M~Time~C(0)@T7@'),FROM(TestDllsQ),MARK(TestDllsQ.fQMarked)
                                                            STRING('Setup'),AT(665,12),USE(?SetupMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
                                                            LIST,AT(197,303,481,68),USE(?LIST3),VSCROLL,FORMAT('53R(2)|M~Date~C(2)@D17@39R(2)|M~Sta' & |
                                                                'rt~C(1)@T4@40R(2)|M~End~C(1)@T4@187L(2)|M~Test~@s200@800L(2)~Result~@s200@'),FROM(LogQ)
                                                            PROMPT('Folder To Monitor:'),AT(4,4,59),USE(?SET:FolderToMonitor:Prompt),TRN
                                                            ENTRY(@s220),AT(4,14,188,10),USE(SET:FolderToMonitor),FLAT,SKIP,TRN
                                                            STRING('Mark All'),AT(6,33),USE(?MarkAllMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
                                                            STRING('Clear All'),AT(47,33),USE(?ClearAllMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
                                                            STRING('Process Marked'),AT(87,33),USE(?ProcessMarkedMenu),FONT(,10,,FONT:regular+FONT:underline), |
                                                                TRN
                                                            STRING('About'),AT(694,12),USE(?AboutMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
                                                            STRING('Close'),AT(723,12),USE(?CloseMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
                                                            STRING('Export To XML'),AT(683,305,61,12),USE(?ExportToXMLMenu),FONT(,10,,FONT:regular+FONT:underline), |
                                                                TRN
                                                            STRING('Export To Text'),AT(683,321,61,12),USE(?ExportToTextMenu),FONT(,10,,FONT:regular+FONT:underline), |
                                                                TRN
                                                            STRING('Export To Clipbrd'),AT(683,337,68,12),USE(?ExportToClipboardMenu),FONT(,10,,FONT:regular+FONT:underline), |
                                                                TRN
                                                            STRING('Email Log'),AT(683,353,68,12),USE(?EmailLog),FONT(,10,,FONT:regular+FONT:underline), |
                                                                TRN
                                                        END
                                                        TAB('Tab2'),USE(?TAB2)
                                                            BUTTON('Setup'),AT(423,234,83),USE(?SetupButton),HIDE
                                                            BUTTON('Clear Results'),AT(422,141,84),USE(?BUTTON1),HIDE
                                                            BUTTON('Run &Selected'),AT(422,159,84),USE(?RunSelected),HIDE
                                                            BUTTON('Re&load'),AT(422,175,84),USE(?Reload),HIDE
                                                            BUTTON('&Reload and Run All'),AT(422,194,84,14),USE(?ReloadAndRun),HIDE
                                                            BUTTON('Run &All'),AT(422,212,84),USE(?RunAll),HIDE
                                                            BUTTON('Clear Marks'),AT(421,122,85),USE(?BUTTON2),HIDE
                                                            BUTTON('Process Marked'),AT(511,122),USE(?ProcessMarked),SKIP
                                                            BUTTON('Mark All'),AT(511,168,43),USE(?MarkAll),SKIP
                                                            BUTTON('Clear All'),AT(511,150),USE(?ClearAll),SKIP
                                                            BUTTON('About'),AT(521,209),USE(?About)
                                                            BUTTON('&Close'),AT(521,228,67,20),USE(?Close)
                                                            BUTTON('Export To XML'),AT(520,265),USE(?ExportToXML)
                                                            BUTTON('Export To Clipboard'),AT(520,282),USE(?ExportToClipboard)
                                                            BUTTON('Export To Text'),AT(521,300,67,20),USE(?ExportToText)
                                                            BUTTON('EMail Results'),AT(525,330),USE(?EmailResults)
                                                        END
                                                    END
                                                END

ThisWindow                                      CLASS(WindowManager)
Init                                                PROCEDURE(),BYTE,PROC,DERIVED
Kill                                                PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted                                        PROCEDURE(),BYTE,PROC,DERIVED
TakeFieldEvent                                      PROCEDURE(),BYTE,PROC,DERIVED
TakeNewSelection                                    PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent                                     PROCEDURE(),BYTE,PROC,DERIVED
                                                END

Toolbar                                         ToolbarClass
MyBlowfish                                      CLASS(JPWBlowfish)
                                                END

FileLookup1                                     SelectFileClass
Resizer                                         CLASS(WindowResizeClass)
Init                                                PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                                                END


    CODE
    GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

LoadDirectory                               Routine
!	myChg.kill()
    Free(AllFiles)
    DIRECTORY(AllFiles,CLIP(Set:FolderToMonitor) & '\*.DLL',ff_:DIRECTORY)
    FREE(ChangedDllsQ)
    IF Set:AutoRunTest
        LOOP N# = 1 To Records(AllFiles)
            GET(AllFiles,N#)
            TestDllsQ.fQName = FIL:Name
            GET(TestDllsQ,TestDllsQ.fQName)
            IF TestDllsQ.fQDate = FIL:Date AND TestDllsQ.fQTime = FIL:Time
            ELSE
                ChangedDllsQ.DllName = FIL:Name
                ADD(ChangedDllsQ,ChangedDllsQ.DllName)
            END
        END
    END
	
	
    FREE(TestDllsQ)
    LOOP N# = 1 To Records(AllFiles)
        GET(AllFiles,N#)
        TestDllsQ.fQName = FIL:Name
        TestDllsQ.fQDate = FIL:Date
        TestDllsQ.fQTime = FIL:Time
        ADD(TestDllsQ,TestDllsQ.fQName)
    END
    cTarget = Set:FolderToMonitor
	
	
LoadDisplayQueue                            Routine
    FREE(DCL_DisplayQueue)
    CLEAR(DCL_DisplayQueue)
    LB_qTestGroup = ''
    loop x = 1 to records(ProceduresQ)
        get(ProceduresQ,x)
        IF ProceduresQ.TestGroup <> LB_qTestGroup
            LB_qTestGroup = ProceduresQ.TestGroup
            CLEAR(DCL_DisplayQueue)
            DCL_DisplayQueue.qTestGroup = ProceduresQ.TestGroup
            DCL_DisplayQueue.qLevel = 1
            DCL_DisplayQueue.qPointer = 0
            DCL_DisplayQueue.qTestGroupStyle = Style:Bold
            DCL_DisplayQueue.qType = eGroup
            ADD(DCL_DisplayQueue)
        END
		
        CLEAR(DCL_DisplayQueue)
        DO FillDisplayQueue
        DCL_DisplayQueue.qType = eChild
        ADD(DCL_DisplayQueue)
    END
	
	
FillDisplayQueue                            ROUTINE
	
    DCL_DisplayQueue.qTestGroup = ProceduresQ.TestName
    DCL_DisplayQueue.qLevel = 2
    DCL_DisplayQueue.qPriority = ProceduresQ.Priority
    DCL_DisplayQueue.qTestResult = ProceduresQ.TestResult
    DCL_DisplayQueue.qTestGroupStyle = ProceduresQ.TestGroupStyle
    DCL_DisplayQueue.qPriorityStyle = ProceduresQ.PriorityStyle
    DCL_DisplayQueue.qTestResultStyle = ProceduresQ.TestResultStyle
    DCL_DisplayQueue.qPointer = x

	
		
	
Refresh                                     routine
    setcursor(cursor:wait)
    firstDisplay = false
    TestRunner.Init(testdll)
    TestRunner.GetTestProcedures(ProceduresQ)
	
    loop x = 1 to records(ProceduresQ)
        get(ProceduresQ,x)
        ProceduresQ.TestNameStyle = Style:Default
        ProceduresQ.TestGroupStyle = Style:Default
        ProceduresQ.PassedStyle = Style:Default
        ProceduresQ.TestResultStyle = Style:Default
        ProceduresQ.Mark = false		 
        put(ProceduresQ)
    END
    IF ~records(ProceduresQ)
        ProceduresQ.TestName = 'No tests loaded'
        add(ProceduresQ)
    END
    DO LoadDisplayQueue
    TestRunner.Kill()
    setcursor()
    display()
    
RunTests                                    ROUTINE
    setcursor(cursor:wait)
    !dbg.write('RunTests routine is initializing the dll') 
    IF RECORDS(ChangedDllsQ)
        GET(ChangedDllsQ,1)
        IF ~error()
            TestDLL = CLIP(Set:FolderToMonitor) & '\' & ChangedDllsQ.DllName
            runall = true
            DO Refresh
        END
        Delete(ChangedDllsQ)
		 
    END
    LogQ.lQDate = Today()
    LogQ.lQStartTime = Clock()
    LogQ.lQEndTime = 0
    LogQ.lQTest = 'Processing ' & CLIP(Set:FolderToMonitor) & '\' & TestDllsQ.fQName
    ADD(LogQ)
    ?LIST3{PROP:Selected} = Records(LogQ)
    TestRunner.Init(testdll)
	 
    loop x = 1 to records(DCL_DisplayQueue)
        get(DCL_DisplayQueue,x)
        if ~runall and DCL_DisplayQueue.qmark = FALSE
            !!dbg.Message('Skipping this item')
            DCL_DisplayQueue.qTestResult = ''
            DCL_DisplayQueue.qMark = False
            PUT(DCL_DisplayQueue)
            CYCLE
        END
        IF DCL_DisplayQueue.qPointer = 0
            DCL_DisplayQueue.qMark = False
            PUT(DCL_DisplayQueue)
            CYCLE
        END
		
        get(ProceduresQ,DCL_DisplayQueue.qPointer)
!		!dbg.write('Got record ' & DCL_DisplayQueue.qPointer & ', test ' & ProceduresQ.TestName)
        LogQ.lQDate = Today()
        LogQ.lQStartTime = CLock()
        LogQ.lQEndTime = 0
        LogQ.lQTest = '  Running Test: ' & ProceduresQ.TestName
        ADD(LogQ)
        ?LIST3{PROP:Selected} = Records(LogQ)
!		!dbg.write('Running test ' & ProceduresQ.TestName)
        TestResult &= TestRunner.RunTest(DCL_DisplayQueue.qPointer)
        ProceduresQ.TestResultStyle = Style:Failed
        if TestResult &= null
            ProceduresQ.passed = false
            ProceduresQ.TestResult = 'Failed: TestResult object was null'
        ELSE
            ProceduresQ.TestName = TestResult.ProcedureName
            if TestResult.Passed
                ProceduresQ.TestResult = 'Passed ' & TestResult.Description
                ProceduresQ.TestResultStyle = Style:Passed
            ELSE
                ProceduresQ.TestResult = 'Failed: ' & TestResult.Message
            END
        END
        put(ProceduresQ)
        LogQ.lQEndTime = Clock()
        LogQ.lQResult = '     Test Result: ' & ProceduresQ.TestResult
        PUT(LogQ)
        ?LIST3{PROP:Selected} = Records(LogQ)	
        DCL_DisplayQueue.qTestResult = ProceduresQ.TestResult
        DCL_DisplayQueue.qTestResultStyle = ProceduresQ.TestResultStyle
        DCL_DisplayQueue.qPassed = ProceduresQ.Passed
        DCL_DisplayQueue.qMark = False
        PUT(DCL_DisplayQueue)
    END
    LogQ.lQTest = ' Tests Processed ==================================='
    ADD(LogQ)
    ?LIST3{PROP:Selected} = Records(LogQ)	
	
    TestRunner.Kill()
    display()
    setcursor()
    
LoadSetup                                   Routine
	
    CLEAR(Setup)
    FREE(MyConfigQueue)
    if not xml:LoadFromFIle('myconfig.xml')
        recs = xml:loadQueue(MyConfigQueue,true,true)
        if recs <> 1
            message('WE REALLY MESSED UP')
        ELSE
            get(MyConfigQueue,1)
        END
        !xml:DebugMyQueue(myconfigqueue,'this is my queue')
      	
        clear(Setup)	
        Setup :=: myConfigQueue
        if SET:SMTPPassword <> ''
            MyBlowfish.Key32 = MyKey
            MyBlowfish.Size = len(clip(Set:SMTPPassword)) + (8-(len(clip(Set:SMTPPassword))%8))
            loop X = (len(clip(Set:SMTPPassword))+1) to MyBlowfish.Size
                Set:SMTPPassword[X] = '<0>'
            end
            MyBlowfish.BinData = address(Set:SMTPPassword)
            MyBlowfish.DecodeHex()
            MyBlowfish.Clip(Set:SMTPPassword)
        END
		
        xml:free()
    END 
    IF Set:FolderToMonitor = ''
        Set:FolderToMonitor = LongPath()
    End
  	
    IF Set:FolderToMonitor = LongPath()
        l:DoNotMonitor = True
    END
	
    IF l:DoNotMonitor
    ELSE
        DO LoadDirectory
        IF TestDLL = ''
            GET(TestDllsQ,1)
            IF ~error()
                TestDLL = CLIP(Set:FolderToMonitor) & '\' & TestDllsQ.fQName
            END
        END
  	
        do refresh
    END
	
!---------------------------------------------------------------------------
DefineListboxStyle                          ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
    !------------------------------------
    !Style for ?LIST2
    !------------------------------------
    !------------------------------------
    !Style for ?LIST
    !------------------------------------
!---------------------------------------------------------------------------
CreateILControls                            ROUTINE                !Create HyperLink Regions
    CREATE(100, CREATE:Region , )
    100{PROP:Imm   } = TRUE
    100{PROP:Use   } = 100
    100{PROP:Height} = ?ReloadMenu{PROP:Height}
    100{PROP:Width } = ?ReloadMenu{PROP:Width }
    100{PROP:XPos  } = ?ReloadMenu{Prop:XPos  }
    100{PROP:YPos  } = ?ReloadMenu{Prop:YPos  }
    100{PROP:Hide  } = FALSE
!   100{PROP:Cursor} = '~hand.cur'
    ?ReloadMenu{PROP:FontColor   } = 0
    CREATE(101, CREATE:Region , )
    101{PROP:Imm   } = TRUE
    101{PROP:Use   } = 101
    101{PROP:Height} = ?ReloadAndRunMenu{PROP:Height}
    101{PROP:Width } = ?ReloadAndRunMenu{PROP:Width }
    101{PROP:XPos  } = ?ReloadAndRunMenu{Prop:XPos  }
    101{PROP:YPos  } = ?ReloadAndRunMenu{Prop:YPos  }
    101{PROP:Hide  } = FALSE
!   101{PROP:Cursor} = '~hand.cur'
    ?ReloadAndRunMenu{PROP:FontColor   } = 0
    CREATE(102, CREATE:Region , )
    102{PROP:Imm   } = TRUE
    102{PROP:Use   } = 102
    102{PROP:Height} = ?RunAllMenu{PROP:Height}
    102{PROP:Width } = ?RunAllMenu{PROP:Width }
    102{PROP:XPos  } = ?RunAllMenu{Prop:XPos  }
    102{PROP:YPos  } = ?RunAllMenu{Prop:YPos  }
    102{PROP:Hide  } = FALSE
!   102{PROP:Cursor} = '~hand.cur'
    ?RunAllMenu{PROP:FontColor   } = 0
    CREATE(103, CREATE:Region , )
    103{PROP:Imm   } = TRUE
    103{PROP:Use   } = 103
    103{PROP:Height} = ?RunSelectedMenu{PROP:Height}
    103{PROP:Width } = ?RunSelectedMenu{PROP:Width }
    103{PROP:XPos  } = ?RunSelectedMenu{Prop:XPos  }
    103{PROP:YPos  } = ?RunSelectedMenu{Prop:YPos  }
    103{PROP:Hide  } = FALSE
!   103{PROP:Cursor} = '~hand.cur'
    ?RunSelectedMenu{PROP:FontColor   } = 0
    CREATE(104, CREATE:Region , )
    104{PROP:Imm   } = TRUE
    104{PROP:Use   } = 104
    104{PROP:Height} = ?ClearResultsMenu{PROP:Height}
    104{PROP:Width } = ?ClearResultsMenu{PROP:Width }
    104{PROP:XPos  } = ?ClearResultsMenu{Prop:XPos  }
    104{PROP:YPos  } = ?ClearResultsMenu{Prop:YPos  }
    104{PROP:Hide  } = FALSE
!   104{PROP:Cursor} = '~hand.cur'
    ?ClearResultsMenu{PROP:FontColor   } = 0
    CREATE(105, CREATE:Region , )
    105{PROP:Imm   } = TRUE
    105{PROP:Use   } = 105
    105{PROP:Height} = ?ClearMarksMenu{PROP:Height}
    105{PROP:Width } = ?ClearMarksMenu{PROP:Width }
    105{PROP:XPos  } = ?ClearMarksMenu{Prop:XPos  }
    105{PROP:YPos  } = ?ClearMarksMenu{Prop:YPos  }
    105{PROP:Hide  } = FALSE
!   105{PROP:Cursor} = '~hand.cur'
    ?ClearMarksMenu{PROP:FontColor   } = 0
    CREATE(106, CREATE:Region , )
    106{PROP:Imm   } = TRUE
    106{PROP:Use   } = 106
    106{PROP:Height} = ?SetupMenu{PROP:Height}
    106{PROP:Width } = ?SetupMenu{PROP:Width }
    106{PROP:XPos  } = ?SetupMenu{Prop:XPos  }
    106{PROP:YPos  } = ?SetupMenu{Prop:YPos  }
    106{PROP:Hide  } = FALSE
!   106{PROP:Cursor} = '~hand.cur'
    ?SetupMenu{PROP:FontColor   } = 0
    CREATE(107, CREATE:Region , )
    107{PROP:Imm   } = TRUE
    107{PROP:Use   } = 107
    107{PROP:Height} = ?ProcessMarkedMenu{PROP:Height}
    107{PROP:Width } = ?ProcessMarkedMenu{PROP:Width }
    107{PROP:XPos  } = ?ProcessMarkedMenu{Prop:XPos  }
    107{PROP:YPos  } = ?ProcessMarkedMenu{Prop:YPos  }
    107{PROP:Hide  } = FALSE
!   107{PROP:Cursor} = '~hand.cur'
    ?ProcessMarkedMenu{PROP:FontColor   } = 0
    CREATE(108, CREATE:Region , )
    108{PROP:Imm   } = TRUE
    108{PROP:Use   } = 108
    108{PROP:Height} = ?MarkAllMenu{PROP:Height}
    108{PROP:Width } = ?MarkAllMenu{PROP:Width }
    108{PROP:XPos  } = ?MarkAllMenu{Prop:XPos  }
    108{PROP:YPos  } = ?MarkAllMenu{Prop:YPos  }
    108{PROP:Hide  } = FALSE
!   108{PROP:Cursor} = '~hand.cur'
    ?MarkAllMenu{PROP:FontColor   } = 0
    CREATE(109, CREATE:Region , )
    109{PROP:Imm   } = TRUE
    109{PROP:Use   } = 109
    109{PROP:Height} = ?ClearAllMenu{PROP:Height}
    109{PROP:Width } = ?ClearAllMenu{PROP:Width }
    109{PROP:XPos  } = ?ClearAllMenu{Prop:XPos  }
    109{PROP:YPos  } = ?ClearAllMenu{Prop:YPos  }
    109{PROP:Hide  } = FALSE
!   109{PROP:Cursor} = '~hand.cur'
    ?ClearAllMenu{PROP:FontColor   } = 0
    CREATE(110, CREATE:Region , )
    110{PROP:Imm   } = TRUE
    110{PROP:Use   } = 110
    110{PROP:Height} = ?AboutMenu{PROP:Height}
    110{PROP:Width } = ?AboutMenu{PROP:Width }
    110{PROP:XPos  } = ?AboutMenu{Prop:XPos  }
    110{PROP:YPos  } = ?AboutMenu{Prop:YPos  }
    110{PROP:Hide  } = FALSE
!   110{PROP:Cursor} = '~hand.cur'
    ?AboutMenu{PROP:FontColor   } = 0
    CREATE(111, CREATE:Region , )
    111{PROP:Imm   } = TRUE
    111{PROP:Use   } = 111
    111{PROP:Height} = ?CloseMenu{PROP:Height}
    111{PROP:Width } = ?CloseMenu{PROP:Width }
    111{PROP:XPos  } = ?CloseMenu{Prop:XPos  }
    111{PROP:YPos  } = ?CloseMenu{Prop:YPos  }
    111{PROP:Hide  } = FALSE
!   111{PROP:Cursor} = '~hand.cur'
    ?CloseMenu{PROP:FontColor   } = 0
    CREATE(112, CREATE:Region , )
    112{PROP:Imm   } = TRUE
    112{PROP:Use   } = 112
    112{PROP:Height} = ?ExportToXMLMenu{PROP:Height}
    112{PROP:Width } = ?ExportToXMLMenu{PROP:Width }
    112{PROP:XPos  } = ?ExportToXMLMenu{Prop:XPos  }
    112{PROP:YPos  } = ?ExportToXMLMenu{Prop:YPos  }
    112{PROP:Hide  } = FALSE
!   112{PROP:Cursor} = '~hand.cur'
    ?ExportToXMLMenu{PROP:FontColor   } = 0
    CREATE(113, CREATE:Region , )
    113{PROP:Imm   } = TRUE
    113{PROP:Use   } = 113
    113{PROP:Height} = ?ExportToTextMenu{PROP:Height}
    113{PROP:Width } = ?ExportToTextMenu{PROP:Width }
    113{PROP:XPos  } = ?ExportToTextMenu{Prop:XPos  }
    113{PROP:YPos  } = ?ExportToTextMenu{Prop:YPos  }
    113{PROP:Hide  } = FALSE
!   113{PROP:Cursor} = '~hand.cur'
    ?ExportToTextMenu{PROP:FontColor   } = 0
    CREATE(114, CREATE:Region , )
    114{PROP:Imm   } = TRUE
    114{PROP:Use   } = 114
    114{PROP:Height} = ?ExportToClipboardMenu{PROP:Height}
    114{PROP:Width } = ?ExportToClipboardMenu{PROP:Width }
    114{PROP:XPos  } = ?ExportToClipboardMenu{Prop:XPos  }
    114{PROP:YPos  } = ?ExportToClipboardMenu{Prop:YPos  }
    114{PROP:Hide  } = FALSE
!   114{PROP:Cursor} = '~hand.cur'
    ?ExportToClipboardMenu{PROP:FontColor   } = 0
    CREATE(115, CREATE:Region , )
    115{PROP:Imm   } = TRUE
    115{PROP:Use   } = 115
    115{PROP:Height} = ?EmailLog{PROP:Height}
    115{PROP:Width } = ?EmailLog{PROP:Width }
    115{PROP:XPos  } = ?EmailLog{Prop:XPos  }
    115{PROP:YPos  } = ?EmailLog{Prop:YPos  }
    115{PROP:Hide  } = FALSE
!   115{PROP:Cursor} = '~hand.cur'
    ?EmailLog{PROP:FontColor   } = 0

InternetLinkEvents                          Routine                !Handle HyperLink Events
    IF FIELD()=100 AND Event()=Event:MouseUp
        POST(Event:Accepted,?Reload)
        EXIT
    END
    IF FIELD()=100 AND Event()=Event:MouseIn
        ?ReloadMenu{PROP:FontColor}=255
    END
    IF FIELD()=100 AND Event()=Event:MouseOut
        ?ReloadMenu{PROP:FontColor}=0
    END
    IF FIELD()=101 AND Event()=Event:MouseUp
        POST(Event:Accepted,?ReloadAndRun)
        EXIT
    END
    IF FIELD()=101 AND Event()=Event:MouseIn
        ?ReloadAndRunMenu{PROP:FontColor}=255
    END
    IF FIELD()=101 AND Event()=Event:MouseOut
        ?ReloadAndRunMenu{PROP:FontColor}=0
    END
    IF FIELD()=102 AND Event()=Event:MouseUp
        POST(Event:Accepted,?RunAll)
        EXIT
    END
    IF FIELD()=102 AND Event()=Event:MouseIn
        ?RunAllMenu{PROP:FontColor}=255
    END
    IF FIELD()=102 AND Event()=Event:MouseOut
        ?RunAllMenu{PROP:FontColor}=0
    END
    IF FIELD()=103 AND Event()=Event:MouseUp
        POST(Event:Accepted,?RunSelected)
        EXIT
    END
    IF FIELD()=103 AND Event()=Event:MouseIn
        ?RunSelectedMenu{PROP:FontColor}=255
    END
    IF FIELD()=103 AND Event()=Event:MouseOut
        ?RunSelectedMenu{PROP:FontColor}=0
    END
    IF FIELD()=104 AND Event()=Event:MouseUp
        POST(Event:Accepted,?BUTTON1)
        EXIT
    END
    IF FIELD()=104 AND Event()=Event:MouseIn
        ?ClearResultsMenu{PROP:FontColor}=255
    END
    IF FIELD()=104 AND Event()=Event:MouseOut
        ?ClearResultsMenu{PROP:FontColor}=0
    END
    IF FIELD()=105 AND Event()=Event:MouseUp
        POST(Event:Accepted,?BUTTON2)
        EXIT
    END
    IF FIELD()=105 AND Event()=Event:MouseIn
        ?ClearMarksMenu{PROP:FontColor}=255
    END
    IF FIELD()=105 AND Event()=Event:MouseOut
        ?ClearMarksMenu{PROP:FontColor}=0
    END
    IF FIELD()=106 AND Event()=Event:MouseUp
        POST(Event:Accepted,?SetupButton)
        EXIT
    END
    IF FIELD()=106 AND Event()=Event:MouseIn
        ?SetupMenu{PROP:FontColor}=255
    END
    IF FIELD()=106 AND Event()=Event:MouseOut
        ?SetupMenu{PROP:FontColor}=0
    END
    IF FIELD()=107 AND Event()=Event:MouseUp
        POST(Event:Accepted,?ProcessMarked)
        EXIT
    END
    IF FIELD()=107 AND Event()=Event:MouseIn
        ?ProcessMarkedMenu{PROP:FontColor}=255
    END
    IF FIELD()=107 AND Event()=Event:MouseOut
        ?ProcessMarkedMenu{PROP:FontColor}=0
    END
    IF FIELD()=108 AND Event()=Event:MouseUp
        POST(Event:Accepted,?MarkAll)
        EXIT
    END
    IF FIELD()=108 AND Event()=Event:MouseIn
        ?MarkAllMenu{PROP:FontColor}=255
    END
    IF FIELD()=108 AND Event()=Event:MouseOut
        ?MarkAllMenu{PROP:FontColor}=0
    END
    IF FIELD()=109 AND Event()=Event:MouseUp
        POST(Event:Accepted,?ClearAll)
        EXIT
    END
    IF FIELD()=109 AND Event()=Event:MouseIn
        ?ClearAllMenu{PROP:FontColor}=255
    END
    IF FIELD()=109 AND Event()=Event:MouseOut
        ?ClearAllMenu{PROP:FontColor}=0
    END
    IF FIELD()=110 AND Event()=Event:MouseUp
        POST(Event:Accepted,?About)
        EXIT
    END
    IF FIELD()=110 AND Event()=Event:MouseIn
        ?AboutMenu{PROP:FontColor}=255
    END
    IF FIELD()=110 AND Event()=Event:MouseOut
        ?AboutMenu{PROP:FontColor}=0
    END
    IF FIELD()=111 AND Event()=Event:MouseUp
        POST(Event:Accepted,?Close)
        EXIT
    END
    IF FIELD()=111 AND Event()=Event:MouseIn
        ?CloseMenu{PROP:FontColor}=255
    END
    IF FIELD()=111 AND Event()=Event:MouseOut
        ?CloseMenu{PROP:FontColor}=0
    END
    IF FIELD()=112 AND Event()=Event:MouseUp
        POST(Event:Accepted,?ExportToXML)
        EXIT
    END
    IF FIELD()=112 AND Event()=Event:MouseIn
        ?ExportToXMLMenu{PROP:FontColor}=255
    END
    IF FIELD()=112 AND Event()=Event:MouseOut
        ?ExportToXMLMenu{PROP:FontColor}=0
    END
    IF FIELD()=113 AND Event()=Event:MouseUp
        POST(Event:Accepted,?ExportToText)
        EXIT
    END
    IF FIELD()=113 AND Event()=Event:MouseIn
        ?ExportToTextMenu{PROP:FontColor}=255
    END
    IF FIELD()=113 AND Event()=Event:MouseOut
        ?ExportToTextMenu{PROP:FontColor}=0
    END
    IF FIELD()=114 AND Event()=Event:MouseUp
        POST(Event:Accepted,?ExportToClipboard)
        EXIT
    END
    IF FIELD()=114 AND Event()=Event:MouseIn
        ?ExportToClipboardMenu{PROP:FontColor}=255
    END
    IF FIELD()=114 AND Event()=Event:MouseOut
        ?ExportToClipboardMenu{PROP:FontColor}=0
    END
    IF FIELD()=115 AND Event()=Event:MouseUp
        POST(Event:Accepted,?EmailResults)
        EXIT
    END
    IF FIELD()=115 AND Event()=Event:MouseIn
        ?EmailLog{PROP:FontColor}=255
    END
    IF FIELD()=115 AND Event()=Event:MouseOut
        ?EmailLog{PROP:FontColor}=0
    END

ThisWindow.Init                             PROCEDURE

ReturnValue                                     BYTE,AUTO

    CODE
    !!dbg.init('RunTests')
    !!dbg.debugactive = true
  	
  	
  
  	
    !!dbg.Message('command(): ' & TestDll)
    GlobalErrors.SetProcedureName('RunTests')
    if TestDll = ''
    end
    SELF.Request = GlobalRequest                             ! Store the incoming request
    ReturnValue = PARENT.Init()
    IF ReturnValue THEN RETURN ReturnValue.
    SELF.FirstField = ?BOX1
    SELF.VCRRequest &= VCRRequest
    SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
    SELF.AddItem(Toolbar)
    LL_NotifyType = NC_File_Notify_Change_File_Name  + |
        NC_File_Notify_Change_Dir_Name   + |
        NC_File_Notify_Change_Attributes + |
        NC_File_Notify_Change_Size       + |
        NC_File_Notify_Change_Last_Write
  	
  	
    CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
    CLEAR(GlobalResponse)
    IF SELF.Request = SelectRecord
        SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
    ELSE
        SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
    END
    SELF.Open(Window)                                        ! Open window
    ?SHEET1{PROP:Wizard} = True
    ?SHEET1{PROP:NoSheet} = True
    ?list{PROPSTYLE:TextColor, Style:Default}     = -1
    ?list{PROPSTYLE:BackColor, Style:Default}     = -1
    ?list{PROPSTYLE:TextSelected, Style:Default}  = -1
    ?list{PROPSTYLE:BackSelected, Style:Default}  = -1
  
    ?list{PROPSTYLE:TextColor, Style:Passed}     = color:green
    ?list{PROPSTYLE:BackColor, Style:Passed}     = color:white
    ?list{PROPSTYLE:TextSelected, Style:Passed}  = -1
    ?list{PROPSTYLE:BackSelected, Style:Passed}  = -1
  
    ?list{PROPSTYLE:TextColor, Style:Failed}     = color:red
    ?list{PROPSTYLE:BackColor, Style:Failed}     = color:white
    ?list{PROPSTYLE:TextSelected, Style:Failed}  = -1
    ?list{PROPSTYLE:BackSelected, Style:Failed}  = -1
  	
    ?list{PROPSTYLE:FontStyle, Style:Bold}     = FONT:Bold
    ?list{PROPSTYLE:TextSelected, Style:Failed}  = -1
    ?list{PROPSTYLE:BackSelected, Style:Failed}  = -1
        
    ?List{PROP:LineHeight} = 12
    TestDll = clip(left(COMMAND(1)))
    if TestDLL <> ''
        if instring('\',testdll,1,1) = 0
            TestDll = longpath() & '\' & TestDll 
            display(?testdll)
        end
    END
    DO LoadSetup
    if TestDLL <> ''
        do refresh
    end
  	
  
    if command('/run')
        post(event:accepted,?runall)
    end
    !WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
    Do DefineListboxStyle
    DO CreateILControls
    Window{PROP:MinWidth} = 754                              ! Restrict the minimum window width
    Window{PROP:MinHeight} = 380                             ! Restrict the minimum window height
    Resizer.Init(AppStrategy:Resize)                         ! Controls will change size as the window gets bigger
    SELF.AddItem(Resizer)                                    ! Add resizer to window manager
    FileLookup1.Init
    FileLookup1.ClearOnCancel = True
    FileLookup1.Flags=BOR(FileLookup1.Flags,FILE:LongName)   ! Allow long filenames
    FileLookup1.SetMask('Test DLL','*.dll')                  ! Set the file mask
    FileLookup1.WindowTitle='Load DLL containing test procedures'
    !do UpdateList
    !ds_VisibleOnDesktop()
    SELF.SetAlerts()
    RETURN ReturnValue


ThisWindow.Kill                             PROCEDURE

ReturnValue                                     BYTE,AUTO

    CODE
    !If self.opened Then WinAlert().
    ReturnValue = PARENT.Kill()
    IF ReturnValue THEN RETURN ReturnValue.
    GlobalErrors.SetProcedureName
    RETURN ReturnValue


ThisWindow.TakeAccepted                     PROCEDURE

ReturnValue                                     BYTE,AUTO

Looped                                          BYTE
    CODE
    LOOP                                                     ! This method receive all EVENT:Accepted's
        IF Looped
            RETURN Level:Notify
        ELSE
            Looped = 1
        END
        CASE ACCEPTED()
        OF ?TestDll
            do Refresh
        OF ?BUTTON1
            loop x = 1 to records(DCL_DisplayQueue)
                get(DCL_DisplayQueue,x)
      	 
                IF DCL_DisplayQueue.qPointer = 0;CYCLE.
                get(ProceduresQ,DCL_DisplayQueue.qPointer)
                ProceduresQ.TestResultStyle = Style:Passed
                ProceduresQ.TestResult = ''
      	 
                put(ProceduresQ)
      			
                DCL_DisplayQueue.qTestResult = ProceduresQ.TestResult
                DCL_DisplayQueue.qTestResultStyle = ProceduresQ.TestResultStyle
                PUT(DCL_DisplayQueue)
            END
        OF ?RunSelected
            runall = FALSE
            do RunTests
        OF ?Reload
            do Refresh      
        OF ?RunAll
            runall = TRUE
            do RunTests
        OF ?BUTTON2
            LOOP N# = 1 To Records(DCL_DisplayQueue)
                GET(DCL_DisplayQueue,N#)
                DCL_DisplayQueue.qMark = 0
                PUT(DCL_DisplayQueue)
            END
        OF ?ProcessMarked
            FREE(LogQ)
            LOOP N# = 1 To Records(TestDllsQ)
                GET(TestDllsQ,N#)
                IF TestDllsQ.fQMarked
      		
                    TestDLL = CLIP(Set:FolderToMonitor) & '\' & TestDllsQ.fQName  !CLIP(Set:FolderToMonitor) & '\' & 
                    DO Refresh
                    Display()
                    runall = TRUE
                    do RunTests
      	
                    TestDllsQ.fQMarked = 0
                    PUT(TestDllsQ)
      		 
                END
      	
            END
      
      
        OF ?MarkAll
            LOOP N# = 1 To Records(TestDllsQ)
                GET(TestDllsQ,N#)
                TestDllsQ.fqMarked = 1
                PUT(TestDllsQ)
            END
        OF ?ClearAll
            LOOP N# = 1 To Records(TestDllsQ)
                GET(TestDllsQ,N#)
                TestDllsQ.fqMarked = 0
                PUT(TestDllsQ)
            END
        END
        ReturnValue = PARENT.TakeAccepted()
        CASE ACCEPTED()
        OF ?LookupFile
            ThisWindow.Update
            TestDll = FileLookup1.Ask(0)
            DISPLAY
        OF ?SetupButton
            ThisWindow.Update
            GlobalRequest = ChangeRecord
            SettingsForm()
            ThisWindow.Reset
            DO LoadSetup
            myChg.Kill
            l:DoNotMonitor = False
            IF Set:FolderToMonitor = LongPath()
                l:DoNotMonitor = True
            END
            IF l:DoNotMonitor       
            ELSE
                if myChg.Init( cTarget, thread(), eMyNotifyCode, eMyNotifyParam, LL_NotifyType, Watch_NoSubDirectories,Watch_autoreset)
      
                end 		
            END
            !	DO LoadDirectory
            !	DO Refresh
      			 
        OF ?ReloadAndRun
            ThisWindow.Update
            Do Refresh
            runall = TRUE
            do RunTests
        OF ?About
            ThisWindow.Update
            About()
            ThisWindow.Reset
        END
        RETURN ReturnValue
    END
    ReturnValue = Level:Fatal
    RETURN ReturnValue


ThisWindow.TakeFieldEvent                   PROCEDURE

ReturnValue                                     BYTE,AUTO

Looped                                          BYTE
    CODE
    LOOP                                                     ! This method receives all field specific events
        IF Looped
            RETURN Level:Notify
        ELSE
            Looped = 1
        END
        DO InternetLinkEvents
        CASE FIELD()
        OF ?LookupFile
            do Refresh          
        END
        ReturnValue = PARENT.TakeFieldEvent()
        RETURN ReturnValue
    END
    ReturnValue = Level:Fatal
    RETURN ReturnValue


ThisWindow.TakeNewSelection                 PROCEDURE

ReturnValue                                     BYTE,AUTO

Looped                                          BYTE
    CODE
    LOOP                                                     ! This method receives all NewSelection events
        IF Looped
            RETURN Level:Notify
        ELSE
            Looped = 1
        END
        CASE FIELD()
        OF ?LIST
            LB_Selected = ?List{PROP:Selected}
            GET(DCL_DisplayQueue,LB_Selected)
            LB_Description = DCL_DisplayQueue.qTestDescription
            IF DCL_DisplayQueue.qType = eGroup
                LB_Marked = DCL_DisplayQueue.qMark
                LB_Selected += 1
                LOOP
                    GET(DCL_DisplayQueue,LB_Selected)
                    IF ERROR();Break.
                    IF DCL_DisplayQueue.qType = eGroup;Break.
                    DCL_DisplayQueue.qMark = LB_Marked
                    PUT(DCL_DisplayQueue)
                    LB_Selected+=1
                END
            END
            Display()
        OF ?LIST1
            GET(TestDllsQ,0+?List1{PROP:Selected})
            !TestDllsQ.fqMarked = ABS(TestDllsQ.fqMarked - 1)
            !PUT(TestDllsQ)
            TestDLL = CLIP(Set:FolderToMonitor) & '\' & TestDllsQ.fQName  !CLIP(Set:FolderToMonitor) & '\' & 
            DO Refresh
            Display()
        END
        ReturnValue = PARENT.TakeNewSelection()
        RETURN ReturnValue
    END
    ReturnValue = Level:Fatal
    RETURN ReturnValue


ThisWindow.TakeWindowEvent                  PROCEDURE

ReturnValue                                     BYTE,AUTO

Looped                                          BYTE
    CODE
    LOOP                                                     ! This method receives all window specific events
        IF Looped
            RETURN Level:Notify
        ELSE
            Looped = 1
        END
        CASE EVENT()
        OF EVENT:CloseDown
            myChg.kill()
        OF EVENT:Notify
            if notification(notifyCode, , notifyParam)
                if notifyCode = eMyNotifyCode !notifyParam=0
                    !            				Message('FileChanged ' & notifyCode)
                    DO LoadDirectory
                    !      					DO Refresh
                    IF Records(ChangedDllsQ)
                        POST(Event:User)
                    END
                end
            end
        OF EVENT:OpenWindow
            IF l:DoNotMonitor       
            ELSE
                if myChg.Init( cTarget, thread(), eMyNotifyCode, eMyNotifyParam, LL_NotifyType, Watch_NoSubDirectories,Watch_autoreset)
      
                end 		
            END
      		
        END
        ReturnValue = PARENT.TakeWindowEvent()
        CASE EVENT()
        OF Event:User
            IF Records(ChangedDllsQ)
  
  		
                DO RunTests
                IF Records(ChangedDllsQ)
                    POST(Event:User)
                END
            END
  		
        ELSE
    
        END
        RETURN ReturnValue
    END
    ReturnValue = Level:Fatal
    RETURN ReturnValue


Resizer.Init                                PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


    CODE
    PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
    SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window
    SELF.SetStrategy(?SHEET1, Resize:LockXPos+Resize:LockYPos, Resize:ConstantRight+Resize:ConstantBottom) ! Override strategy for ?SHEET1
    SELF.SetStrategy(?BOX1, Resize:LockXPos+Resize:LockYPos, Resize:ConstantRight+Resize:LockHeight) ! Override strategy for ?BOX1
    SELF.SetStrategy(?LIST, Resize:LockXPos+Resize:LockYPos, Resize:ConstantRight+Resize:ConstantBottom) ! Override strategy for ?LIST
    SELF.SetStrategy(?LIST1, Resize:LockXPos+Resize:LockYPos, Resize:LockWidth+Resize:ConstantBottom) ! Override strategy for ?LIST1
    SELF.SetStrategy(?SetupMenu, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?SetupMenu
    SELF.SetStrategy(?LIST3, Resize:LockXPos+Resize:FixBottom, Resize:ConstantRight+Resize:LockHeight) ! Override strategy for ?LIST3
    SELF.SetStrategy(?AboutMenu, Resize:FixRight+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?AboutMenu
    SELF.SetStrategy(?CloseMenu, Resize:FixRight+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?CloseMenu
    SELF.SetStrategy(?ExportToXMLMenu, Resize:FixRight+Resize:FixBottom, Resize:LockSize) ! Override strategy for ?ExportToXMLMenu
    SELF.SetStrategy(?ExportToTextMenu, Resize:FixRight+Resize:FixBottom, Resize:LockSize) ! Override strategy for ?ExportToTextMenu
    SELF.SetStrategy(?ExportToClipboardMenu, Resize:FixRight+Resize:FixBottom, Resize:LockSize) ! Override strategy for ?ExportToClipboardMenu
    SELF.SetStrategy(?EmailLog, Resize:FixRight+Resize:FixBottom, Resize:LockSize) ! Override strategy for ?EmailLog
    SELF.RemoveControl(?BOX2)                                ! Remove ?BOX2 from the resizer, it will not be moved or sized
    SELF.RemoveControl(?TestDll:Prompt)                      ! Remove ?TestDll:Prompt from the resizer, it will not be moved or sized
    SELF.RemoveControl(?TestDll)                             ! Remove ?TestDll from the resizer, it will not be moved or sized
    SELF.RemoveControl(?LookupFile)                          ! Remove ?LookupFile from the resizer, it will not be moved or sized
    SELF.RemoveControl(?LIST2)                               ! Remove ?LIST2 from the resizer, it will not be moved or sized
    SELF.RemoveControl(?ReloadMenu)                          ! Remove ?ReloadMenu from the resizer, it will not be moved or sized
    SELF.RemoveControl(?ReloadAndRunMenu)                    ! Remove ?ReloadAndRunMenu from the resizer, it will not be moved or sized
    SELF.RemoveControl(?RunAllMenu)                          ! Remove ?RunAllMenu from the resizer, it will not be moved or sized
    SELF.RemoveControl(?RunSelectedMenu)                     ! Remove ?RunSelectedMenu from the resizer, it will not be moved or sized
    SELF.RemoveControl(?ClearResultsMenu)                    ! Remove ?ClearResultsMenu from the resizer, it will not be moved or sized
    SELF.RemoveControl(?ClearMarksMenu)                      ! Remove ?ClearMarksMenu from the resizer, it will not be moved or sized
    SELF.RemoveControl(?SET:FolderToMonitor:Prompt)          ! Remove ?SET:FolderToMonitor:Prompt from the resizer, it will not be moved or sized
    SELF.RemoveControl(?SET:FolderToMonitor)                 ! Remove ?SET:FolderToMonitor from the resizer, it will not be moved or sized
    SELF.RemoveControl(?MarkAllMenu)                         ! Remove ?MarkAllMenu from the resizer, it will not be moved or sized
    SELF.RemoveControl(?ClearAllMenu)                        ! Remove ?ClearAllMenu from the resizer, it will not be moved or sized
    SELF.RemoveControl(?ProcessMarkedMenu)                   ! Remove ?ProcessMarkedMenu from the resizer, it will not be moved or sized

!!! <summary>
!!! Generated from procedure template - Window
!!! Form Settings
!!! </summary>
SettingsForm                                PROCEDURE 

CurrentTab                                      STRING(80)                            !
ActionMessage                                   CSTRING(40)                           !
QuickWindow                                     WINDOW('Form Settings'),AT(,,466,273),FONT('MS Sans Serif',8,,FONT:regular,CHARSET:DEFAULT), |
                                                    RESIZE,CENTER,GRAY,IMM,HLP('SettingsForm'),SYSTEM
                                                    PANEL,AT(13,10,443,231),USE(?PANEL1),BEVEL(1)
                                                    PROMPT('SMTPS erver:'),AT(20,138),USE(?Set:SMTPServer:Prompt),TRN
                                                    ENTRY(@s120),AT(104,124,258,10),USE(SET:Domain)
                                                    ENTRY(@s120),AT(104,138,258,10),USE(SET:SMTPServer)
                                                    ENTRY(@s120),AT(104,153,258,10),USE(SET:SMTPPort)
                                                    ENTRY(@s120),AT(104,166,258,10),USE(SET:SMTPUser)
                                                    ENTRY(@s120),AT(104,180,258,10),USE(SET:SMTPPassword)
                                                    ENTRY(@s120),AT(104,194,258,10),USE(SET:SenderAddress)
                                                    ENTRY(@s120),AT(104,209,258,10),USE(SET:FromHeaderAddress)
                                                    PROMPT('From Header Address:'),AT(20,209),USE(?Set:FromHeaderAddress:Prompt),TRN
                                                    PROMPT('Sender Address:'),AT(20,194),USE(?Set:SenderAddress:Prompt),TRN
                                                    PROMPT('SMTPP assword:'),AT(20,180),USE(?Set:SMTPPassword:Prompt),TRN
                                                    PROMPT('SMTPU ser:'),AT(20,166),USE(?Set:SMTPUser:Prompt),TRN
                                                    PROMPT('SMTPP ort:'),AT(20,153),USE(?Set:SMTPPort:Prompt),TRN
                                                    PROMPT('Domain:'),AT(20,124),USE(?Set:Domain:Prompt),TRN
                                                    CHECK('Auto Run Test On DLL Change'),AT(103,56,120,8),USE(SET:AutoRunTest)
                                                    CHECK('Launch In Monitor Mode'),AT(103,44,100,8),USE(SET:MonitorMode)
                                                    PROMPT('From Header Name:'),AT(20,223),USE(?Set:FromHeaderName:Prompt),TRN
                                                    ENTRY(@s120),AT(104,223,257,9),USE(SET:FromHeaderName)
                                                    BUTTON('&Cancel'),AT(406,251,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),MSG('Cancel operation'), |
                                                        TIP('Cancel operation')
                                                    PROMPT('Folder To Monitor:'),AT(33,31),USE(?Set:FolderToMonitor:Prompt)
                                                    ENTRY(@s220),AT(104,30,335,10),USE(SET:FolderToMonitor)
                                                    BUTTON('...'),AT(442,28,12,12),USE(?LookupFile),SKIP
                                                    BUTTON('OK'),AT(361,251,41),USE(?BUTTON1)
                                                    BUTTON('Read'),AT(137,251,39,14),USE(?BUTTON1:2)
                                                END

ThisWindow                                      CLASS(WindowManager)
Init                                                PROCEDURE(),BYTE,PROC,DERIVED
Kill                                                PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted                                        PROCEDURE(),BYTE,PROC,DERIVED
                                                END

Toolbar                                         ToolbarClass
MyBlowfish                                      CLASS(JPWBlowfish)
                                                END

FileLookup7                                     SelectFileClass
Resizer                                         CLASS(WindowResizeClass)
Init                                                PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                                                END

CurCtrlFeq                                      LONG
FieldColorQueue                                 QUEUE
Feq                                                 LONG
OldColor                                            LONG
                                                END

    CODE
    GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle                          ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init                             PROCEDURE

ReturnValue                                     BYTE,AUTO

    CODE
    GlobalErrors.SetProcedureName('SettingsForm')
    SELF.Request = GlobalRequest                             ! Store the incoming request
    ReturnValue = PARENT.Init()
    IF ReturnValue THEN RETURN ReturnValue.
    SELF.FirstField = ?PANEL1
    SELF.VCRRequest &= VCRRequest
    SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
    SELF.AddItem(Toolbar)
    CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
    CLEAR(GlobalResponse)
    SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
    SELF.Open(QuickWindow)                                   ! Open window
    !WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
    Do DefineListboxStyle
    IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
        ?SET:Domain{PROP:ReadOnly} = True
        ?SET:SMTPServer{PROP:ReadOnly} = True
        ?SET:SMTPPort{PROP:ReadOnly} = True
        ?SET:SMTPUser{PROP:ReadOnly} = True
        ?SET:SMTPPassword{PROP:ReadOnly} = True
        ?SET:SenderAddress{PROP:ReadOnly} = True
        ?SET:FromHeaderAddress{PROP:ReadOnly} = True
        ?SET:FromHeaderName{PROP:ReadOnly} = True
        ?SET:FolderToMonitor{PROP:ReadOnly} = True
        DISABLE(?LookupFile)
        DISABLE(?BUTTON1)
        DISABLE(?BUTTON1:2)
    END
    Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
    SELF.AddItem(Resizer)                                    ! Add resizer to window manager
    INIMgr.Fetch('SettingsForm',QuickWindow)                 ! Restore window settings from non-volatile store
    Resizer.Resize                                           ! Reset required after window size altered by INI manager
    FileLookup7.Init
    FileLookup7.ClearOnCancel = True
    FileLookup7.Flags=BOR(FileLookup7.Flags,FILE:LongName)   ! Allow long filenames
    FileLookup7.Flags=BOR(FileLookup7.Flags,FILE:Directory)  ! Allow Directory Dialog
    FileLookup7.SetMask('All Files','*.*')                   ! Set the file mask
    FileLookup7.WindowTitle='Select Path'
    !ds_VisibleOnDesktop()
    SELF.SetAlerts()
    RETURN ReturnValue


ThisWindow.Kill                             PROCEDURE

ReturnValue                                     BYTE,AUTO

    CODE
    !If self.opened Then WinAlert().
    ReturnValue = PARENT.Kill()
    IF ReturnValue THEN RETURN ReturnValue.
    IF SELF.Opened
        INIMgr.Update('SettingsForm',QuickWindow)              ! Save window data to non-volatile store
    END
    GlobalErrors.SetProcedureName
    RETURN ReturnValue


ThisWindow.TakeAccepted                     PROCEDURE

ReturnValue                                     BYTE,AUTO

Looped                                          BYTE
    CODE
    LOOP                                                     ! This method receive all EVENT:Accepted's
        IF Looped
            RETURN Level:Notify
        ELSE
            Looped = 1
        END
        CASE ACCEPTED()
        OF ?Cancel
            !
        END
        ReturnValue = PARENT.TakeAccepted()
        CASE ACCEPTED()
        OF ?LookupFile
            ThisWindow.Update
            SET:FolderToMonitor = FileLookup7.Ask(1)
            DISPLAY
        OF ?BUTTON1
            ThisWindow.Update
            if not xml:createXMLFILE('Myconfig.xml')
                xml:CreateParent('Configuration')
                XML:CreateAttribute('Version','1.00')
                xml:AddParent()
                ! encrypt here(blowfish encryption from Gary at Strategy ONLINE) FREE !!@!@!!!!  USE HEX!!!
                if SET:SMTPPassword <> ''
                    MyBlowfish.Key32 = MyKey
                    MyBlowfish.Size = len(clip(Set:SMTPPassword)) + (8-(len(clip(Set:SMTPPassword))%8))
                    loop X = (len(clip(Set:SMTPPassword))+1) to MyBlowfish.Size
                        Set:SMTPPassword[X] = '<0>'
                    end
                    MyBlowfish.BinData = address(Set:SMTPPassword)
                    MyBlowfish.EncodeHex()
                END
      				
                xml:AddFromgroup(Setup,'SMTPSettings',True)
                if SET:SMTPPassword <> ''
                    ! put it back here
                    MyBlowfish.Key32 = MyKey
                    MyBlowfish.BinData = address(Set:SMTPPassword)
                    MyBlowfish.DecodeHex()
                    MyBlowfish.Clip (Set:SMTPPassword)
                END
                xml:CloseParent()
                !      			xml:CreateParent('UserSettings');xml:addParent()
                !      			! here
                !      			xml:closeParent()
      	
                xml:closeXMLFILE(True)
            END	
            !xml:viewfile('myconfig.xml')
            ReturnValue = Level:Fatal
      
      
        OF ?BUTTON1:2
            ThisWindow.Update
            if not xml:LoadFromFIle('myconfig.xml')
                recs = xml:loadQueue(MyConfigQueue,true,true)
                if recs <> 1
                    message('WE REALLY MESSED UP')
                ELSE
                    get(MyConfigQueue,1)
                END
                xml:DebugMyQueue(myconfigqueue,'this is my queue')
                clear(Setup)	
                Setup :=: myConfigQueue
                MyBlowfish.Key32 = MyKey
                MyBlowfish.BinData = address(Set:SMTPPassword)
                MyBlowfish.DecodeHex()
                MyBlowfish.Clip (Set:SMTPPassword)
                xml:free()
            END
            !        Message(Set:SMTPPassword)
            
        END
        RETURN ReturnValue
    END
    ReturnValue = Level:Fatal
    RETURN ReturnValue


Resizer.Init                                PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


    CODE
    PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
    SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
About                                       PROCEDURE 

Window                                          WINDOW('About ClarionTest'),AT(,,285,153),FONT('Microsoft Sans Serif',10,,FONT:regular,CHARSET:DEFAULT), |
                                                    CENTER,GRAY,SYSTEM
                                                    PANEL,AT(10,11,264,131),USE(?PANEL1),BEVEL(1)
                                                    PROMPT('ClarionTest'),AT(20,22),USE(?PROMPT1)
                                                    STRING('Concept By: Dave Harms'),AT(24,34,81,11),USE(?STRING1)
                                                    STRING('Programming By:'),AT(24,48),USE(?STRING2)
                                                    STRING('Dave Harms'),AT(42,64),USE(?STRING3)
                                                    STRING('John Hickey'),AT(42,77),USE(?STRING4)
                                                    STRING('Robert Paresi'),AT(42,90),USE(?STRING5)
                                                    STRING('John Dunn'),AT(42,103),USE(?STRING6)
                                                    STRING('Version .04'),AT(232,126),USE(?STRING7)
                                                END

ThisWindow                                      CLASS(WindowManager)
Init                                                PROCEDURE(),BYTE,PROC,DERIVED
Kill                                                PROCEDURE(),BYTE,PROC,DERIVED
                                                END

Toolbar                                         ToolbarClass

    CODE
    GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle                          ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init                             PROCEDURE

ReturnValue                                     BYTE,AUTO

    CODE
    GlobalErrors.SetProcedureName('About')
    SELF.Request = GlobalRequest                             ! Store the incoming request
    ReturnValue = PARENT.Init()
    IF ReturnValue THEN RETURN ReturnValue.
    SELF.FirstField = ?PANEL1
    SELF.VCRRequest &= VCRRequest
    SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
    SELF.AddItem(Toolbar)
    CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
    CLEAR(GlobalResponse)
    SELF.Open(Window)                                        ! Open window
    !WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
    Do DefineListboxStyle
    INIMgr.Fetch('About',Window)                             ! Restore window settings from non-volatile store
    !ds_VisibleOnDesktop()
    SELF.SetAlerts()
    RETURN ReturnValue


ThisWindow.Kill                             PROCEDURE

ReturnValue                                     BYTE,AUTO

    CODE
    !If self.opened Then WinAlert().
    ReturnValue = PARENT.Kill()
    IF ReturnValue THEN RETURN ReturnValue.
    IF SELF.Opened
        INIMgr.Update('About',Window)                          ! Save window data to non-volatile store
    END
    GlobalErrors.SetProcedureName
    RETURN ReturnValue

