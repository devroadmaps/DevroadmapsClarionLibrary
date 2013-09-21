                                        MEMBER('ClarionTest.clw')                               ! This is a MEMBER module



Logger                                  DCL_System_Diagnostics_Logger


Main                                    PROCEDURE 

Resizer                                     CLASS(WindowResizeClass)
Init                                            PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                                            END

DirectoryWatcher                            class(DCL_System_Runtime_DirectoryWatcher)
DoTask                                          procedure,VIRTUAL
                                            end
StdOut                                      DCL_System_IO_StdOut

                                            itemize(1),pre(Style)
Default                                         equate
Failed                                          equate
Passed                                          equate
Bold                                            equate
NoResult                                        equate
                                            end

FailedTestCount                             long
FirstFailedTest                             long

TestDllPathAndName                          CSTRING(File:MaxFilePath + File:MaxFileName + 1)

PreviousGroupOrTestName                     string(200)
TestsQ                                      QUEUE,PRE(TestsQ)
GroupOrTestName                                 STRING(200)                           
GroupOrTestLevel                                LONG                                  
GroupOrTestStyle                                LONG                                  
TestResult                                      STRING(400)                           
TestResultStyle                                 LONG                                  
! Following fields are not used for display
TestDescription                                 STRING(100)                           
TestLongDescription                             STRING(5000)                          
TestStatus                                      Long
GroupOrTestPriority                             real
GroupOrTestPriorityStyle                        LONG                                  
Mark                                            BYTE                                  
ProcedureQIndex                                 LONG                                  
Type                                            BYTE                                  
                                            END                                   

TestRunner                                  DCL_ClarionTest_TestRunner
ProceduresQ                                 queue(DCL_ClarionTest_TestProceduresQueue)
                                            end
TestResult                                  &DCL_ClarionTest_TestResult
str                                         DCL_System_String
RunTestsOnDllChange                         bool
ListOfDlls                                  DCL_System_IO_Directory


Window                                      WINDOW('ClarionTest'),AT(,,600,170),CENTER,GRAY,IMM,SYSTEM,MAX, |
                                                ICON('ClarionTest.ico'),FONT('Segoe UI',8,,FONT:regular),TIMER(100),RESIZE
                                                TOOLBAR,AT(0,0,600,20),USE(?TOOLBAR1)
                                                    BUTTON('Select All'),AT(2,3,63),USE(?SelectAll),FLAT,TRN
                                                    BUTTON('Run Selected'),AT(69,3,63,14),USE(?RunSelectedTests),FLAT,TRN
                                                    BUTTON('Clear Results'),AT(202,3,63,14),USE(?ClearResults),FLAT,TRN
                                                    CHECK('Run on DLL change'),AT(269,6),USE(RunTestsOnDllChange),TRN
                                                    BUTTON('Close'),AT(513,3,63,14),USE(?Close),FLAT,TRN
                                                    BUTTON('Run All'),AT(135,3,63,14),USE(?RunAllTests),FLAT,TRN
                                                END
                                                PROMPT('Test DLL:'),AT(8,6,35,12),USE(?TestDllPathAndName:Prompt),TRN
                                                ENTRY(@s255),AT(42,4,533,12),USE(TestDllPathAndName),COLOR(COLOR:BTNFACE), |
                                                    READONLY
                                                BUTTON('...'),AT(579,3,12,12),USE(?LookupTestDllPathAndName)
                                                PROGRESS,AT(3,20,595,8),USE(?Progress),RANGE(0,100)
                                                LIST,AT(3,32,595,116),USE(?TestList),HVSCROLL,FONT(,10),MARK(testsq.Mark), |
                                                    FROM(TestsQ),FORMAT('259L(2)|MYT(1)~Test~@s200@1020L(2)Y~Result~' & |
                                                    '@s255@')
                                            END


ProcedureName                               equate('Main')
ProgramDirectory                            cstring(File:MaxFilePath + 1)
TestDllDirectory                            cstring(File:MaxFilePath + 1)
TestDllName                                 cstring(FILE:MaxFileName + 1)
x                                           long
RunAllTests                                 bool
TimeOfLastDirectoryChange                   long
TestsToRun                                  long
CurrentTestIndex                            long
DelayBeforeAutorun                          long(90)
PreviousDllsChecksum                        REAL
CurrentDllsChecksum                         real
ShowUI                                      bool

    CODE
    if command('CIS') = 'TC' 
        ! Called as a command line utility
        ShowUI = false
        RunAllTests = true
        do PrepareProcedure
        if exists(TestDllPathAndName)
            StdOut.Write('##teamcity[testSuiteStarted name=<39>' & TestDllName & '<39>]]')
            do LoadTests
            do RunTests
            StdOut.Write('##teamcity[testSuiteFinished name=<39>' & TestDllName & '<39>]]')
        else
            StdOut.Write('##teamcity[testFailed message=<39>DLL not found<39> details=<39>' & TestDllPathAndName & '<39>]]')
        end
        !message('done')
        return
    end
    ShowUI = true        
    ProgramDirectory = longpath()
    open(window)
    Window{PROP:MinWidth} = 400
    Window{PROP:MinHeight} = 170
    !Resizer.Init(AppStrategy:Resize)
    Resizer.Init(AppStrategy:Spread)
    do PrepareProcedure
    ACCEPT
        DirectoryWatcher.TakeEvent()
        case event()
        of EVENT:OpenWindow
            do PrepareWindow
            do LoadTests
        of EVENT:Sized
            Resizer.Resize()
            ?Close{PROP:Xpos} = 0{prop:width} - 70
        of EVENT:Timer
            if TimeOfLastDirectoryChange > 0
                if clock() < TimeOfLastDirectoryChange or clock() >  TimeOfLastDirectoryChange + DelayBeforeAutorun
                    TimeOfLastDirectoryChange = 0
                    ListOfDlls.GetDirectoryListing()
                    CurrentDllsChecksum = ListOfDlls.GetChecksum()
                    if CurrentDllsChecksum <> PreviousDllsChecksum
                        PreviousDllsChecksum = CurrentDllsChecksum
                        do RunTests
                    END
					
                end
            end
        END
        case accepted()
        of ?Close
            post(event:closewindow)
        of ?LookupTestDllPathAndName
            FILEDIALOG('Chose a test dll',TestDllPathAndName,'Test DLLs|*.dll')
            display(?TestDllPathAndName)
            logger.write('dgh selected DLL ' & TestDllPathAndName)
            !update(?TestDllPathAndName)
            do LoadTests
        of ?RunSelectedTests
            RunAllTests = false
            do RunTests
        of ?RunAllTests
            RunAllTests = true
            do RunTests
        of ?RunTestsOnDllChange
            do SetDirectoryWatcher
        of ?SelectAll
            loop x = 1 to records(testsq)
                get(testsq,x)
                if testsq.ProcedureQIndex = 0 then cycle.
                if ?SelectAll{prop:text} = 'Select All' 
                    testsq.Mark = TRUE
                else
                    testsq.Mark = FALSE
                end
                put(testsq)
            end
            if ?SelectAll{prop:text} = 'Select All' 
                ?SelectAll{prop:text} = 'Clear All' 
            else
                ?SelectAll{prop:text} = 'Select All' 
            end
        end
    end
    settings.Update(ProcedureName,window)
    logger.write('calling settings.update with ' & ProcedureName & ',TestDllPathAndName,' & TestDllPathAndName)
    settings.Update(ProcedureName,'TestDllPathAndName',TestDllPathAndName)
    settings.Update(ProcedureName,'DelayBeforeAutorun',DelayBeforeAutorun)
    close(window)

PrepareProcedure                        routine
    settings.Fetch(ProcedureName,window)
    settings.Fetch(ProcedureName,'DelayBeforeAutorun',DelayBeforeAutorun)
    TestDllPathAndName = clip(left(COMMAND(1)))
    !logger.write('TestDllPathAndName
    if TestDllPathAndName <> ''
        if instring('\',TestDllPathAndName,1,1) = 0
            TestDllPathAndName = longpath() & '\' & TestDllPathAndName 
        end
    else
        settings.Fetch(ProcedureName,'TestDllPathAndName',TestDllPathAndName)
    end
  
	
PrepareWindow                           routine	

    ?TestList{PROPSTYLE:TextColor, Style:Default}     = -1
    ?TestList{PROPSTYLE:BackColor, Style:Default}     = -1
    ?TestList{PROPSTYLE:TextSelected, Style:Default}  = -1
    ?TestList{PROPSTYLE:BackSelected, Style:Default}  = -1
    ?TestList{PROPSTYLE:FontStyle, Style:Default}  	 = -1

    ?TestList{PROPSTYLE:TextColor, Style:NoResult}     = color:black
    ?TestList{PROPSTYLE:BackColor, Style:NoResult}     = color:white
    ?TestList{PROPSTYLE:TextSelected, Style:NoResult}  = color:black
    ?TestList{PROPSTYLE:BackSelected, Style:NoResult}  = color:white
    ?TestList{PROPSTYLE:FontStyle, Style:NoResult}  	 = -1
  
    ?TestList{PROPSTYLE:TextColor, Style:Passed}     = color:green
    ?TestList{PROPSTYLE:BackColor, Style:Passed}     = color:white
    ?TestList{PROPSTYLE:TextSelected, Style:Passed}  = color:green
    ?TestList{PROPSTYLE:BackSelected, Style:Passed}  = color:white
    ?TestList{PROPSTYLE:FontStyle, Style:Passed}  	 = -1
  
    ?TestList{PROPSTYLE:TextColor, Style:Failed}     = color:red
    ?TestList{PROPSTYLE:BackColor, Style:Failed}     = color:white
    ?TestList{PROPSTYLE:TextSelected, Style:Failed}  = color:red
    ?TestList{PROPSTYLE:BackSelected, Style:Failed}  = color:white
    ?TestList{PROPSTYLE:FontStyle, Style:Failed}     = FONT:Bold


    ?TestList{PROPSTYLE:FontStyle, Style:Bold}     = FONT:Bold
    ?TestList{PROPSTYLE:TextSelected, Style:Bold}  = -1
    ?TestList{PROPSTYLE:BackSelected, Style:Bold}  = -1			

    if command('/run')
        post(event:accepted,?RunAllTests)
    end

SetDirectoryWatcher                     routine
    logger.write('SetDirectoryWatcher routine')
    if RunTestsOnDllChange and exists(TestDllDirectory)
        DirectoryWatcher.Init(TestDllDirectory)
        DirectoryWatcher.noNotifyOnStartup = true
        ListOfDlls.Init(TestDllDirectory)
        ListOfDlls.SetFilter('*.dll')
        ListOfDlls.GetDirectoryListing()
        PreviousDllsChecksum = ListOfDlls.GetChecksum()
    else
        DirectoryWatcher.Kill
    end
	


LoadTests                               ROUTINE
    do SetDirectoryWatcher
    free(TestsQ)
    free(ProceduresQ)
    logger.Write('Loading tests from ' & TestDllPathAndName)
    str.Assign(TestDllPathAndName)
    TestDllDirectory = str.SubString(1,str.LastIndexOf('\'))
    if TestDllDirectory <> ''
        if not exists(TestDllDirectory)
            message('The test directory ' & TestDllDirectory & ' does not exist')
        ELSE
            setpath(TestDllDirectory)
            TestDllName = str.SubString(str.LastIndexOf('\') + 1,str.Length())
            logger.write('dgh Loading test procedures for ' & TestDllName)
            TestRunner.Init(TestDllName)
            TestRunner.GetTestProcedures(ProceduresQ)
            logger.Write('Found ' & records(ProceduresQ) & ' tests')
        END
    END

    sort(ProceduresQ,ProceduresQ.TestGroupPriority,ProceduresQ.TestGroupName,ProceduresQ.TestPriority,ProceduresQ.TestName)
    loop x = 1 to records(ProceduresQ)
        get(ProceduresQ,x)
        IF ProceduresQ.TestGroupName <> PreviousGroupOrTestName
            PreviousGroupOrTestName = ProceduresQ.TestGroupName
            CLEAR(TestsQ)
            TestsQ.GroupOrTestName = ProceduresQ.TestGroupName
            TestsQ.GroupOrTestLevel = 1
            TestsQ.ProcedureQIndex = 0
            TestsQ.GroupOrTestStyle = Style:Bold
            ADD(TestsQ)
        END
        TestsQ.GroupOrTestStyle = Style:Default
        TestsQ.GroupOrTestName = ProceduresQ.TestName
        TestsQ.GroupOrTestLevel = 2
        TestsQ.ProcedureQIndex = x
        TestsQ.TestResult = ''
        TestsQ.TestResultStyle = Style:NoResult
        TestsQ.Mark = false
        Add(TestsQ)
    END

RunTests                                ROUTINE
    FailedTestCount = 0
    FirstFailedTest = 0
    setcursor(cursor:wait)
    !dbg.write('RunTests routine is initializing the dll') 
    TestRunner.Init(TestDllName)
    TestsToRun = 0
    loop x = 1 to records(TestsQ)
        get(TestsQ,x)
        get(ProceduresQ,TestsQ.ProcedureQIndex)
        if ~errorcode()
            if RunAllTests or TestsQ.Mark = true then TestsToRun += 1.
        end
    end
    CurrentTestIndex = 0
    ?Progress{prop:RangeHigh} = TestsToRun
    loop x = 1 to records(TestsQ)
        get(TestsQ,x)
        if ~RunAllTests and TestsQ.mark = FALSE
            !!dbg.Message('Skipping this item')
            TestsQ.TestResult = ''
            TestsQ.Mark = False
            PUT(TestsQ)
            CYCLE
        END
        IF TestsQ.ProcedureQIndex = 0 then cycle.
        get(ProceduresQ,TestsQ.ProcedureQIndex)
        if ~errorcode()
!		!dbg.write('Got record ' & TestsQ.qPointer & ', test ' & ProceduresQ.TestName)
!		!dbg.write('Running test ' & ProceduresQ.TestName)
            if not ShowUI
                StdOut.Write('##teamcity[testStarted name=<39>' & clip(TestsQ.GroupOrTestName) & '<39>]]')
            end
            TestResult &= TestRunner.RunTestByName(TestsQ.GroupOrTestName)
            CurrentTestIndex += 1
            if ShowUI
                ?Progress{PROP:Progress} = CurrentTestIndex
                display(?Progress)			
            end
            !ProceduresQ.TestResultStyle = Style:Failed
            if TestResult &= null
                TestsQ.TestDescription = 'Failed: TestResult object was null'
                TestsQ.TestStatus = dcl_ClarionTest_Status_Fail
                FailedTestCount += 1
            else                
                TestsQ.TestStatus = TestResult.Status
                if TestResult.Status = DCL_ClarionTest_Status_Pass
                    TestsQ.TestResult = 'Passed ' & TestResult.Description
                    TestsQ.TestResultStyle = Style:Passed
                elsif TestResult.Status = DCL_ClarionTest_Status_Ignore
                    TestsQ.TestResult = 'Ignored: ' & TestResult.Message
                else
                    TestsQ.TestResult = 'Failed: ' & TestResult.Message
                    TestsQ.TestResultStyle = Style:Failed
                    FailedTestCount += 1 
                        
                END
            END
            PUT(TestsQ)  
            if not ShowUI
                IF TestsQ.TestResultStyle = Style:Failed  
                    StdOut.Write('##teamcity[testFailed name=<39>' & clip(TestsQ.GroupOrTestName) & '<39> message=<39>' & clip(TestResult.Message) & '<39> details=<39>' & clip(TestResult.Message) & '<39>]]')
                end  
                StdOut.Write('##teamcity[testFinished name=<39>' & clip(TestsQ.GroupOrTestName) & '<39>]]')
            end
            IF TestsQ.TestResultStyle = Style:Failed |
                AND FirstFailedTest = 0
                FirstFailedTest = x
            END
        END
    END
    TestRunner.Kill()
    if ShowUI
        display()
        setcursor()
        0{prop:text} = 'ClarionTest - ' & FailedTestCount & ' failed tests'
        if FailedTestCount > 0
            beep(BEEP:SystemHand)
            if FailedTestCount = 1
                0{prop:text} = 'ClarionTest - 1 failed test'
            end
            ?TestList{PROP:Selected} = FirstFailedTest
        else
            beep(BEEP:SystemExclamation)
        end
        0{prop:text} = 0{prop:text} & ' at ' & format(clock(),@t6)
    else
        !message('done')
    end
    
	

Resizer.Init                            PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
    CODE
    PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
    SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window
    SELF.SetStrategy(?Progress, Resize:FixLeft+Resize:FixTop, Resize:LockHeight+Resize:Resize) ! Override strategy for ?TestList1
    SELF.SetStrategy(?TestList, Resize:LockXPos+Resize:LockYPos, Resize:ConstantRight+Resize:ConstantBottom) ! Override strategy for ?TestList1
    self.SetStrategy(?TestDllPathAndName:Prompt,Resize:FixLeft+Resize:FixTop,Resize:LockSize)
    self.SetStrategy(?TestDllPathAndName,Resize:FixLeft+Resize:FixTop,Resize:LockHeight+resize:resize)
    self.SetParentControl(?LookupTestDllPathAndName,?TestDllPathAndName)

DirectoryWatcher.DoTask                 procedure!,VIRTUAL
    code
    !message('Directory changed')
    !logger.write('DirectoryWatcher.DoTask')
    !post(event:accepted,?RunAllTests)
    TimeOfLastDirectoryChange = clock()


!	GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
!
!LoadDirectory                           Routine
!!	myChg.kill()
!	Free(AllFiles)
!	DIRECTORY(AllFiles,CLIP(Set:FolderToMonitor) & '\*.DLL',ff_:DIRECTORY)
!	FREE(ChangedDllsQ)
!	IF Set:AutoRunTest
!		LOOP x = 1 To Records(AllFiles)
!			GET(AllFiles,x)
!			TestDllPathAndNamesQ.fQName = FIL:Name
!			GET(TestDllPathAndNamesQ,TestDllPathAndNamesQ.fQName)
!			IF TestDllPathAndNamesQ.fQDate = FIL:Date AND TestDllPathAndNamesQ.fQTime = FIL:Time
!			ELSE
!				ChangedDllsQ.DllName = FIL:Name
!				ADD(ChangedDllsQ,ChangedDllsQ.DllName)
!			END
!		END
!	END
!	
!	
!	FREE(TestDllPathAndNamesQ)
!	LOOP x = 1 To Records(AllFiles)
!		GET(AllFiles,x)
!		TestDllPathAndNamesQ.fQName = FIL:Name
!		TestDllPathAndNamesQ.fQDate = FIL:Date
!		TestDllPathAndNamesQ.fQTime = FIL:Time
!		ADD(TestDllPathAndNamesQ,TestDllPathAndNamesQ.fQName)
!	END
!	cTarget = Set:FolderToMonitor
!	
!	
!LoadDisplayQueue                        Routine
!	FREE(TestsQ)
!	CLEAR(TestsQ)
!	LB_qTestGroup = ''
!	loop x = 1 to records(ProceduresQ)
!		get(ProceduresQ,x)
!		IF ProceduresQ.TestGroup <> LB_qTestGroup
!			LB_qTestGroup = ProceduresQ.TestGroup
!			CLEAR(TestsQ)
!			TestsQ.qTestGroup = ProceduresQ.TestGroup
!			TestsQ.qLevel = 1
!			TestsQ.qPointer = 0
!			TestsQ.qTestGroupStyle = Style:Bold
!			TestsQ.qType = eGroup
!			ADD(TestsQ)
!		END
!		
!		CLEAR(TestsQ)
!		DO FillDisplayQueue
!		TestsQ.qType = eChild
!		ADD(TestsQ)
!	END
!	
!	
!FillDisplayQueue                        ROUTINE
!	
!	TestsQ.qTestGroup = ProceduresQ.TestName
!	TestsQ.qLevel = 2
!	TestsQ.qPriority = ProceduresQ.Priority
!	TestsQ.qTestResult = ProceduresQ.TestResult
!	TestsQ.qTestGroupStyle = ProceduresQ.TestGroupStyle
!	TestsQ.qPriorityStyle = ProceduresQ.PriorityStyle
!	TestsQ.qTestResultStyle = ProceduresQ.TestResultStyle
!	TestsQ.qPointer = x
!
!	
!		
!	
!Refresh                                 routine
!	setcursor(cursor:wait)
!	firstDisplay = false
!	TestRunner.Init(TestDllPathAndName)
!	TestRunner.GetTestProcedures(ProceduresQ)
!	
!	loop x = 1 to records(ProceduresQ)
!		get(ProceduresQ,x)
!		ProceduresQ.TestNameStyle = Style:Default
!		ProceduresQ.TestGroupStyle = Style:Default
!		ProceduresQ.PassedStyle = Style:Default
!		ProceduresQ.TestResultStyle = Style:Default
!		ProceduresQ.Mark = false		 
!		put(ProceduresQ)
!	END
!	IF ~records(ProceduresQ)
!		ProceduresQ.TestName = 'No tests loaded'
!		add(ProceduresQ)
!	END
!	DO LoadDisplayQueue
!	TestRunner.Kill()
!	setcursor()
!	display()
!    
!RunTests                                ROUTINE
!	setcursor(cursor:wait)
!	!dbg.write('RunTests routine is initializing the dll') 
!	IF RECORDS(ChangedDllsQ)
!		GET(ChangedDllsQ,1)
!		IF ~error()
!			TestDllPathAndName = CLIP(Set:FolderToMonitor) & '\' & ChangedDllsQ.DllName
!			RunAllTests = true
!			DO Refresh
!		END
!		Delete(ChangedDllsQ)
!		 
!	END
!	LogQ.lQDate = Today()
!	LogQ.lQStartTime = Clock()
!	LogQ.lQEndTime = 0
!	LogQ.lQTest = 'Processing ' & CLIP(Set:FolderToMonitor) & '\' & TestDllPathAndNamesQ.fQName
!	ADD(LogQ)
!	?TestList3{PROP:Selected} = Records(LogQ)
!	TestRunner.Init(TestDllPathAndName)
!	 
!	loop x = 1 to records(TestsQ)
!		get(TestsQ,x)
!		if ~RunAllTests and TestsQ.qmark = FALSE
!			!!dbg.Message('Skipping this item')
!			TestsQ.qTestResult = ''
!			TestsQ.qMark = False
!			PUT(TestsQ)
!			CYCLE
!		END
!		IF TestsQ.qPointer = 0
!			TestsQ.qMark = False
!			PUT(TestsQ)
!			CYCLE
!		END
!		
!		get(ProceduresQ,TestsQ.qPointer)
!!		!dbg.write('Got record ' & TestsQ.qPointer & ', test ' & ProceduresQ.TestName)
!		LogQ.lQDate = Today()
!		LogQ.lQStartTime = CLock()
!		LogQ.lQEndTime = 0
!		LogQ.lQTest = '  Running Test: ' & ProceduresQ.TestName
!		ADD(LogQ)
!		?TestList3{PROP:Selected} = Records(LogQ)
!!		!dbg.write('Running test ' & ProceduresQ.TestName)
!		TestResult &= TestRunner.RunTest(TestsQ.qPointer)
!		ProceduresQ.TestResultStyle = Style:Failed
!		if TestResult &= null
!			ProceduresQ.passed = false
!			ProceduresQ.TestResult = 'Failed: TestResult object was null'
!		ELSE
!			ProceduresQ.TestName = TestResult.ProcedureName
!			if TestResult.Passed
!				ProceduresQ.TestResult = 'Passed ' & TestResult.Description
!				ProceduresQ.TestResultStyle = Style:Passed
!			ELSE
!				ProceduresQ.TestResult = 'Failed: ' & TestResult.Message
!			END
!		END
!		put(ProceduresQ)
!		LogQ.lQEndTime = Clock()
!		LogQ.lQResult = '     Test Result: ' & ProceduresQ.TestResult
!		PUT(LogQ)
!		?TestList3{PROP:Selected} = Records(LogQ)	
!		TestsQ.qTestResult = ProceduresQ.TestResult
!		TestsQ.qTestResultStyle = ProceduresQ.TestResultStyle
!		TestsQ.qPassed = ProceduresQ.Passed
!		TestsQ.qMark = False
!		PUT(TestsQ)
!	END
!	LogQ.lQTest = ' Tests Processed ==================================='
!	ADD(LogQ)
!	?TestList3{PROP:Selected} = Records(LogQ)	
!	
!	TestRunner.Kill()
!	display()
!	setcursor()
!    
!LoadSetup                               Routine
!	
!!	CLEAR(Setup)
!!	FREE(MyConfigQueue)
!!	if not xml:LoadFromFIle('myconfig.xml')
!!		recs = xml:loadQueue(MyConfigQueue,true,true)
!!		if recs <> 1
!!			message('WE REALLY MESSED UP')
!!		ELSE
!!			get(MyConfigQueue,1)
!!		END
!!		!xml:DebugMyQueue(myconfigqueue,'this is my queue')
!!      	
!!		clear(Setup)	
!!		Setup :=: myConfigQueue
!!		if SET:SMTPPassword <> ''
!!			MyBlowfish.Key32 = MyKey
!!			MyBlowfish.Size = len(clip(Set:SMTPPassword)) + (8-(len(clip(Set:SMTPPassword))%8))
!!			loop X = (len(clip(Set:SMTPPassword))+1) to MyBlowfish.Size
!!				Set:SMTPPassword[X] = '<0>'
!!			end
!!			MyBlowfish.BinData = address(Set:SMTPPassword)
!!			MyBlowfish.DecodeHex()
!!			MyBlowfish.Clip(Set:SMTPPassword)
!!		END
!!		
!!		xml:free()
!!	END 
!!	IF Set:FolderToMonitor = ''
!!		Set:FolderToMonitor = LongPath()
!!	End
!!  	
!!	IF Set:FolderToMonitor = LongPath()
!!		l:DoNotMonitor = True
!!	END
!!	
!!	IF l:DoNotMonitor
!!	ELSE
!!		DO LoadDirectory
!!		IF TestDllPathAndName = ''
!!			GET(TestDllPathAndNamesQ,1)
!!			IF ~error()
!!				TestDllPathAndName = CLIP(Set:FolderToMonitor) & '\' & TestDllPathAndNamesQ.fQName
!!			END
!!		END
!!  	
!!		do refresh
!!	END
!	
!ThisWindow.Init                         PROCEDURE
!
!ReturnValue                                 BYTE,AUTO
!
!	CODE
!	!!dbg.init('RunTests')
!	!!dbg.debugactive = true
!  	
!  	
!  
!  	
!	!!dbg.Message('command(): ' & TestDllPathAndName)
!	GlobalErrors.SetProcedureName('RunTests')
!	if TestDllPathAndName = ''
!	end
!	SELF.Request = GlobalRequest                             ! Store the incoming request
!	ReturnValue = PARENT.Init()
!	IF ReturnValue THEN RETURN ReturnValue.
!	SELF.FirstField = ?BOX1
!	SELF.VCRRequest &= VCRRequest
!	SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
!	SELF.AddItem(Toolbar)
!	LL_NotifyType = NC_File_Notify_Change_File_Name  + |
!		NC_File_Notify_Change_Dir_Name   + |
!		NC_File_Notify_Change_Attributes + |
!		NC_File_Notify_Change_Size       + |
!		NC_File_Notify_Change_Last_Write
!  	
!  	
!	CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
!	CLEAR(GlobalResponse)
!	IF SELF.Request = SelectRecord
!		SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
!	ELSE
!		SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
!	END
!	SELF.Open(Window)                                        ! Open window
!	?SHEET1{PROP:Wizard} = True
!	?SHEET1{PROP:NoSheet} = True
!	?TestList{PROPSTYLE:TextColor, Style:Default}     = -1
!	?TestList{PROPSTYLE:BackColor, Style:Default}     = -1
!	?TestList{PROPSTYLE:TextSelected, Style:Default}  = -1
!	?TestList{PROPSTYLE:BackSelected, Style:Default}  = -1
!  
!	?TestList{PROPSTYLE:TextColor, Style:Passed}     = color:green
!	?TestList{PROPSTYLE:BackColor, Style:Passed}     = color:white
!	?TestList{PROPSTYLE:TextSelected, Style:Passed}  = -1
!	?TestList{PROPSTYLE:BackSelected, Style:Passed}  = -1
!  
!	?TestList{PROPSTYLE:TextColor, Style:Failed}     = color:red
!	?TestList{PROPSTYLE:BackColor, Style:Failed}     = color:white
!	?TestList{PROPSTYLE:TextSelected, Style:Failed}  = -1
!	?TestList{PROPSTYLE:BackSelected, Style:Failed}  = -1
!  	
!	?TestList{PROPSTYLE:FontStyle, Style:Bold}     = FONT:Bold
!	?TestList{PROPSTYLE:TextSelected, Style:Failed}  = -1
!	?TestList{PROPSTYLE:BackSelected, Style:Failed}  = -1
!        
!	?TestList{PROP:LineHeight} = 12
!	TestDllPathAndName = clip(left(COMMAND(1)))
!	if TestDllPathAndName <> ''
!		if instring('\',TestDllPathAndName,1,1) = 0
!			TestDllPathAndName = longpath() & '\' & TestDllPathAndName 
!			display(?TestDllPathAndName)
!		end
!	END
!	DO LoadSetup
!	if TestDllPathAndName <> ''
!		do refresh
!	end
!  	
!  
!	if command('/run')
!		post(event:accepted,?RunAllTests)
!	end
!	!WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
!	!Do DefineListboxStyle
!	!DO CreateILControls
!	Window{PROP:MinWidth} = 754                              ! Restrict the minimum window width
!	Window{PROP:MinHeight} = 380                             ! Restrict the minimum window height
!	Resizer.Init(AppStrategy:Resize)                         ! Controls will change size as the window gets bigger
!	SELF.AddItem(Resizer)                                    ! Add resizer to window manager
!	FileLookup1.Init
!	FileLookup1.ClearOnCancel = True
!	FileLookup1.Flags=BOR(FileLookup1.Flags,FILE:LongName)   ! Allow long filenames
!	FileLookup1.SetMask('Test DLL','*.dll')                  ! Set the file mask
!	FileLookup1.WindowTitle='Load DLL containing test procedures'
!	!do UpdateList
!	!ds_VisibleOnDesktop()
!	SELF.SetAlerts()
!	RETURN ReturnValue
!
!
!ThisWindow.Kill                         PROCEDURE
!
!ReturnValue                                 BYTE,AUTO
!
!	CODE
!	!If self.opened Then WinAlert().
!	ReturnValue = PARENT.Kill()
!	IF ReturnValue THEN RETURN ReturnValue.
!	GlobalErrors.SetProcedureName
!	RETURN ReturnValue
!
!
!ThisWindow.TakeAccepted                 PROCEDURE
!
!ReturnValue                                 BYTE,AUTO
!
!Looped                                      BYTE
!	CODE
!	LOOP                                                     ! This method receive all EVENT:Accepted's
!		IF Looped
!			RETURN Level:Notify
!		ELSE
!			Looped = 1
!		END
!		CASE ACCEPTED()
!		OF ?TestDllPathAndName
!			do Refresh
!		OF ?BUTTON1
!			loop x = 1 to records(TestsQ)
!				get(TestsQ,x)
!      	 
!				IF TestsQ.qPointer = 0;CYCLE.
!				get(ProceduresQ,TestsQ.qPointer)
!				ProceduresQ.TestResultStyle = Style:Passed
!				ProceduresQ.TestResult = ''
!      	 
!				put(ProceduresQ)
!      			
!				TestsQ.qTestResult = ProceduresQ.TestResult
!				TestsQ.qTestResultStyle = ProceduresQ.TestResultStyle
!				PUT(TestsQ)
!			END
!		OF ?RunSelected
!			RunAllTests = FALSE
!			do RunTests
!		OF ?Reload
!			do Refresh      
!		OF ?RunAllTests
!			RunAllTests = TRUE
!			do RunTests
!		OF ?BUTTON2
!			LOOP x = 1 To Records(TestsQ)
!				GET(TestsQ,x)
!				TestsQ.qMark = 0
!				PUT(TestsQ)
!			END
!		OF ?ProcessMarked
!			FREE(LogQ)
!			LOOP x = 1 To Records(TestDllPathAndNamesQ)
!				GET(TestDllPathAndNamesQ,x)
!				IF TestDllPathAndNamesQ.fQMarked
!      		
!					TestDllPathAndName = CLIP(Set:FolderToMonitor) & '\' & TestDllPathAndNamesQ.fQName  !CLIP(Set:FolderToMonitor) & '\' & 
!					DO Refresh
!					Display()
!					RunAllTests = TRUE
!					do RunTests
!      	
!					TestDllPathAndNamesQ.fQMarked = 0
!					PUT(TestDllPathAndNamesQ)
!      		 
!				END
!      	
!			END
!      
!      
!		OF ?MarkAll
!			LOOP x = 1 To Records(TestDllPathAndNamesQ)
!				GET(TestDllPathAndNamesQ,x)
!				TestDllPathAndNamesQ.fqMarked = 1
!				PUT(TestDllPathAndNamesQ)
!			END
!		OF ?ClearAll
!			LOOP x = 1 To Records(TestDllPathAndNamesQ)
!				GET(TestDllPathAndNamesQ,x)
!				TestDllPathAndNamesQ.fqMarked = 0
!				PUT(TestDllPathAndNamesQ)
!			END
!		END
!		ReturnValue = PARENT.TakeAccepted()
!		CASE ACCEPTED()
!		OF ?LookupFile
!			ThisWindow.Update
!			TestDllPathAndName = FileLookup1.Ask(0)
!			DISPLAY
!		OF ?SetupButton
!			ThisWindow.Update
!			GlobalRequest = ChangeRecord
!			SettingsForm()
!			ThisWindow.Reset
!			DO LoadSetup
!			myChg.Kill
!			l:DoNotMonitor = False
!			IF Set:FolderToMonitor = LongPath()
!				l:DoNotMonitor = True
!			END
!			IF l:DoNotMonitor       
!			ELSE
!				if myChg.Init( cTarget, thread(), eMyNotifyCode, eMyNotifyParam, LL_NotifyType, Watch_NoSubDirectories,Watch_autoreset)
!      
!				end 		
!			END
!			!	DO LoadDirectory
!			!	DO Refresh
!      			 
!		OF ?ReloadAndRun
!			ThisWindow.Update
!			Do Refresh
!			RunAllTests = TRUE
!			do RunTests
!		OF ?About
!			ThisWindow.Update
!			About()
!			ThisWindow.Reset
!		END
!		RETURN ReturnValue
!	END
!	ReturnValue = Level:Fatal
!	RETURN ReturnValue
!
!
!ThisWindow.TakeFieldEvent               PROCEDURE
!
!ReturnValue                                 BYTE,AUTO
!
!Looped                                      BYTE
!	CODE
!	LOOP                                                     ! This method receives all field specific events
!		IF Looped
!			RETURN Level:Notify
!		ELSE
!			Looped = 1
!		END
!		!DO InternetLinkEvents
!		CASE FIELD()
!		OF ?LookupFile
!			do Refresh          
!		END
!		ReturnValue = PARENT.TakeFieldEvent()
!		RETURN ReturnValue
!	END
!	ReturnValue = Level:Fatal
!	RETURN ReturnValue
!
!
!ThisWindow.TakeNewSelection             PROCEDURE
!
!ReturnValue                                 BYTE,AUTO
!
!Looped                                      BYTE
!	CODE
!	LOOP                                                     ! This method receives all NewSelection events
!		IF Looped
!			RETURN Level:Notify
!		ELSE
!			Looped = 1
!		END
!		CASE FIELD()
!		OF ?TestList
!			LB_Selected = ?TestList{PROP:Selected}
!			GET(TestsQ,LB_Selected)
!			LB_Description = TestsQ.qTestDescription
!			IF TestsQ.qType = eGroup
!				LB_Marked = TestsQ.qMark
!				LB_Selected += 1
!				LOOP
!					GET(TestsQ,LB_Selected)
!					IF ERROR();Break.
!					IF TestsQ.qType = eGroup;Break.
!					TestsQ.qMark = LB_Marked
!					PUT(TestsQ)
!					LB_Selected+=1
!				END
!			END
!			Display()
!		OF ?TestList1
!			GET(TestDllPathAndNamesQ,0+?TestList1{PROP:Selected})
!			!TestDllPathAndNamesQ.fqMarked = ABS(TestDllPathAndNamesQ.fqMarked - 1)
!			!PUT(TestDllPathAndNamesQ)
!			TestDllPathAndName = CLIP(Set:FolderToMonitor) & '\' & TestDllPathAndNamesQ.fQName  !CLIP(Set:FolderToMonitor) & '\' & 
!			DO Refresh
!			Display()
!		END
!		ReturnValue = PARENT.TakeNewSelection()
!		RETURN ReturnValue
!	END
!	ReturnValue = Level:Fatal
!	RETURN ReturnValue
!
!
!ThisWindow.TakeWindowEvent              PROCEDURE
!
!ReturnValue                                 BYTE,AUTO
!
!Looped                                      BYTE
!	CODE
!	LOOP                                                     ! This method receives all window specific events
!		IF Looped
!			RETURN Level:Notify
!		ELSE
!			Looped = 1
!		END
!		CASE EVENT()
!		OF EVENT:CloseDown
!			myChg.kill()
!		OF EVENT:Notify
!			if notification(notifyCode, , notifyParam)
!				if notifyCode = eMyNotifyCode !notifyParam=0
!					!            				Message('FileChanged ' & notifyCode)
!					DO LoadDirectory
!					!      					DO Refresh
!					IF Records(ChangedDllsQ)
!						POST(Event:User)
!					END
!				end
!			end
!		OF EVENT:OpenWindow
!			IF l:DoNotMonitor       
!			ELSE
!				if myChg.Init( cTarget, thread(), eMyNotifyCode, eMyNotifyParam, LL_NotifyType, Watch_NoSubDirectories,Watch_autoreset)
!      
!				end 		
!			END
!      		
!		END
!		ReturnValue = PARENT.TakeWindowEvent()
!		CASE EVENT()
!		OF Event:User
!			IF Records(ChangedDllsQ)
!  
!  		
!				DO RunTests
!				IF Records(ChangedDllsQ)
!					POST(Event:User)
!				END
!			END
!  		
!		ELSE
!    
!		END
!		RETURN ReturnValue
!	END
!	ReturnValue = Level:Fatal
!	RETURN ReturnValue
!
!
!
!!!! <summary>
!!!! Generated from procedure template - Window
!!!! Form Settings
!!!! </summary>
!myConfigQueue                           QUEUE,PRE()
!FolderToMonitor                             STRING(220)
!MonitorMode                                 STRING(20)
!AutoRunTest                                 STRING(20)
!Domain                                      STRING(120)
!SMTPServer                                  STRING(120)
!SMTPPort                                    STRING(120)
!SMTPUser                                    STRING(120)
!SMTPPassword                                STRING(120)
!SenderAddress                               STRING(120)
!FromHeaderAddress                           STRING(120)
!FromHeaderName                              STRING(120)
!										END
!recs                                    LONG
!X                                       LONG
!MyKey                                   STRING('ClarionTestFTW456 {15}')
!MyText                                  STRING(10000)
!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
!firstdisplay                                byte(true)
!TestRunner                                  DCL_ClarionTest_TestRunner
!ProceduresQ                                 queue(DCL_ClarionTest_ProceduresQueue)
!											end
!TestResult                              &DCL_ClarionTest_TestResult
!FolderToMonitor                         cstring(500)
!											itemize(1),pre(Style)
!Default                                         equate
!Passed                                          equate
!Failed                                          equate
!Bold                                            equate
!											end
!
!eGroup                                      equate(1)
!eChild                                      equate(2)
!
!RunAllTests                                      byte(true)
!DllNameAndPath                              cstring(255)
!!dbg             DCL_system_diagnostics_debugger
!
!
!LS_SMTPPassword                             CSTRING(120)                          !
!LL_NotifyType                               LONG                                  !
!LogQ                                        QUEUE,PRE()                           !
!lQDate                                          LONG                                  !
!lQStartTime                                     LONG                                  !
!lQEndTime                                       LONG                                  !
!lQTest                                          STRING(200)                           !
!lQResult                                        STRING(200)                           !
!											END                                   !
!l:DoNotMonitor                              BYTE                                  !
!ChangedDllsQ                                QUEUE,PRE()                           !
!DllName                                         STRING(100)                           !
!											END                                   !
!AllFiles                                    QUEUE(File:queue),PRE(FIL)            !
!											END                                   !
!LB_Description                              STRING(200)                           !
!TestDllPathAndNamesQ                                   QUEUE,PRE()                           !
!fQName                                          STRING(100)                           !
!fQDate                                          LONG                                  !
!fQTime                                          LONG                                  !
!fQMarked                                        BYTE                                  !
!											END                                   !
!LB_Passed                                   BYTE                                  !
!LB_UnitTest                                 STRING(100)                           !
!LB_Result                                   STRING(200)                           !
!LB_TestGroup                                STRING(30)                            !
!LB_Priority                                 DECIMAL(7,2)                          !
!LB_Selected                                 LONG                                  !
!LB_Marked                                   BYTE                                  !
!LB_qTestGroup                               STRING(200)                           !

    !											! LIST,AT(13,31,349,219),USE(?TestList),HVSCROLL,FORMAT('162L(2)MY~Test Name~@s100@800L(2)Y~Result~@s200@'),FROM(ProceduresQ),MARK(ProceduresQ.mark)
!                
!cTarget                                     cstring(220)
!eMyNotifyCode                               equate(222)
!eMyNotifyParam                              equate(0)
!myChg                                       DCL_System_Runtime_DirectoryWatcher
!notifyCode                                  unsigned
!notifyParam                                 long

!										LIST,AT(385,205,101,60),USE(?TestList1),HVSCROLL,MARK(TestDllPathAndNamesQ.fQMarked), |
!											FROM(TestDllPathAndNamesQ),FORMAT('57L(2)|M~Test DLLs~@s100@54R(2)|M~Date~C(0)@D17@60R(' & |
!											'2)|M~Time~C(0)@T7@'),Hide

!OriginalWindow                                  WINDOW('ClarionTest'),AT(,,754,380),FONT('Segoe UI',8,,FONT:regular),RESIZE,CENTER, |
!											ICON('ClarionTest.ico'),GRAY,SYSTEM,IMM
!											SHEET,AT(0,0,752,378),USE(?SHEET1),BELOW
!												TAB('Tab1'),USE(?TAB1)
!													PROMPT('Test DLL:'),AT(295,260,45),USE(?TestDllPathAndName:Prompt),FONT(,10,,FONT:regular),RIGHT,HIDE, |
!														TRN
!													ENTRY(@s255),AT(345,259,378,15),USE(TestDllPathAndName),HIDE
!													BUTTON('...'),AT(727,258,18,16),USE(?LookupFile),HIDE
!													LIST,AT(582,335,87,12),USE(?TestList2),HVSCROLL,FORMAT('85L(2)MY~Test Group~@s30@41L(2)MY~P' & |
!														'riority~@n_5.2@261L(2)MY~Test Name~@s100@800L(2)Y~Result~@s200@'),FROM(ProceduresQ),HIDE, |
!														MARK(proceduresq.mark)
!													LIST,AT(197,31,555,270),USE(?TestList),FONT(,10),HVSCROLL,FORMAT('259L(2)|MYT(1)~Test Group' & |
!														'~@s200@#1#1020L(2)Y~Test Result~@s255@#6#'),FROM(TestsQ),MARK(TestsQ.qMark)
!													STRING('Reload'),AT(264,2),USE(?ReloadMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
!													STRING('Reload & Run All'),AT(264,15,70),USE(?ReloadAndRunMenu),FONT(,10,,FONT:regular+FONT:underline), |
!														TRN
!													STRING('Run All'),AT(203,2),USE(?RunAllTestsMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
!													STRING('Run Selected'),AT(203,15),USE(?RunSelectedMenu),FONT(,10,,FONT:regular+FONT:underline), |
!														TRN
!													STRING('Clear Results'),AT(341,2),USE(?ClearResultsMenu),FONT(,10,,FONT:regular+FONT:underline), |
!														TRN
!													STRING('Clear Marks'),AT(341,15),USE(?ClearMarksMenu),FONT(,10,,FONT:regular+FONT:underline), |
!														TRN
!													LIST,AT(5,49,187,322),USE(?TestList1),HVSCROLL,FORMAT('57L(2)|M~Test DLLs~@s100@54R(2)|M~Da' & |
!														'te~C(0)@D17@60R(2)|M~Time~C(0)@T7@'),FROM(TestDllPathAndNamesQ),MARK(TestDllPathAndNamesQ.fQMarked)
!													STRING('Setup'),AT(665,12),USE(?SetupMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
!													LIST,AT(197,303,481,68),USE(?TestList3),VSCROLL,FORMAT('53R(2)|M~Date~C(2)@D17@39R(2)|M~Sta' & |
!														'rt~C(1)@T4@40R(2)|M~End~C(1)@T4@187L(2)|M~Test~@s200@800L(2)~Result~@s200@'),FROM(LogQ)
!													PROMPT('Folder To Monitor:'),AT(4,4,59),USE(?SET:FolderToMonitor:Prompt),TRN
!													ENTRY(@s220),AT(4,14,188,10),USE(FolderToMonitor),FLAT,SKIP,TRN
!													STRING('Mark All'),AT(6,33),USE(?MarkAllMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
!													STRING('Clear All'),AT(47,33),USE(?ClearAllMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
!													STRING('Process Marked'),AT(87,33),USE(?ProcessMarkedMenu),FONT(,10,,FONT:regular+FONT:underline), |
!														TRN
!													STRING('About'),AT(694,12),USE(?AboutMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
!													STRING('Close'),AT(723,12),USE(?CloseMenu),FONT(,10,,FONT:regular+FONT:underline),TRN
!													STRING('Export To XML'),AT(683,305,61,12),USE(?ExportToXMLMenu),FONT(,10,,FONT:regular+FONT:underline), |
!														TRN
!													STRING('Export To Text'),AT(683,321,61,12),USE(?ExportToTextMenu),FONT(,10,,FONT:regular+FONT:underline), |
!														TRN
!													STRING('Export To Clipbrd'),AT(683,337,68,12),USE(?ExportToClipboardMenu),FONT(,10,,FONT:regular+FONT:underline), |
!														TRN
!													STRING('Email Log'),AT(683,353,68,12),USE(?EmailLog),FONT(,10,,FONT:regular+FONT:underline), |
!														TRN
!												END
!												TAB('Tab2'),USE(?TAB2)
!													BUTTON('Setup'),AT(423,234,83),USE(?SetupButton),HIDE
!													BUTTON('Clear Results'),AT(422,141,84),USE(?BUTTON1),HIDE
!													BUTTON('Run &Selected'),AT(422,159,84),USE(?RunSelected),HIDE
!													BUTTON('Re&load'),AT(422,175,84),USE(?Reload),HIDE
!													BUTTON('&Reload and Run All'),AT(422,194,84,14),USE(?ReloadAndRun),HIDE
!													BUTTON('Run &All'),AT(422,212,84),USE(?RunAllTests),HIDE
!													BUTTON('Clear Marks'),AT(421,122,85),USE(?BUTTON2),HIDE
!													BUTTON('Process Marked'),AT(511,122),USE(?ProcessMarked),SKIP
!													BUTTON('Mark All'),AT(511,168,43),USE(?MarkAll),SKIP
!													BUTTON('Clear All'),AT(511,150),USE(?ClearAll),SKIP
!													BUTTON('About'),AT(521,209),USE(?About)
!													BUTTON('&Close'),AT(521,228,67,20),USE(?Close)
!													BUTTON('Export To XML'),AT(520,265),USE(?ExportToXML)
!													BUTTON('Export To Clipboard'),AT(520,282),USE(?ExportToClipboard)
!													BUTTON('Export To Text'),AT(521,300,67,20),USE(?ExportToText)
!													BUTTON('EMail Results'),AT(525,330),USE(?EmailResults)
!												END
!											END
!										END

!ThisWindow                                  CLASS(WindowManager)
!Init                                            PROCEDURE(),BYTE,PROC,DERIVED
!Kill                                            PROCEDURE(),BYTE,PROC,DERIVED
!TakeAccepted                                    PROCEDURE(),BYTE,PROC,DERIVED
!TakeFieldEvent                                  PROCEDURE(),BYTE,PROC,DERIVED
!TakeNewSelection                                PROCEDURE(),BYTE,PROC,DERIVED
!TakeWindowEvent                                 PROCEDURE(),BYTE,PROC,DERIVED
!											END
!
!Toolbar                                     ToolbarClass
!!MyBlowfish                                  CLASS(JPWBlowfish)
!!											END
!
!FileLookup1                                 SelectFileClass
!Resizer                                     CLASS(WindowResizeClass)
!Init                                            PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
!											END
	
	
!	INCLUDE('ABRESIZE.INC'),ONCE
!	INCLUDE('ABTOOLBA.INC'),ONCE
!	INCLUDE('ABUTIL.INC'),ONCE
!	INCLUDE('ABWINDOW.INC'),ONCE
	