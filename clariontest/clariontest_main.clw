                                        MEMBER('ClarionTest.clw')

!Region Logger
Logger                                  CLASS(DCL_System_Diagnostics_Logger)
Construct                                 PROCEDURE
                                        END
                                        
Logger.Construct  PROCEDURE
   CODE
   SELF.Prefix = '`'
!EndRegion Logger
   
Main                                    PROCEDURE 

!Region Data Directly used by the Window
TestsQ                                      QUEUE,PRE(TestsQ)
GroupOrTestName                                 STRING(200)                           
GroupOrTestLevel                                LONG        !Tree Level
GroupOrTestStyle                                LONG        !PropStyle Value
                              
TestResult                                      STRING(400)                           
TestResultStyle                                 LONG        !PropStyle Value                          
!--------------  Following fields are not used for display
TestDescription                                 STRING(100)                           
TestLongDescription                             STRING(5000)                          
TestStatus                                      Long
GroupOrTestPriority                             real
GroupOrTestPriorityStyle                        LONG                                  
Mark                                            BYTE                                  
ProcedureQIndex                                 LONG                                  
Type                                            BYTE                                  
                                            END                                   

TestDllPathAndName                          CSTRING(File:MaxFilePath + 1) ! File:MaxFileName + 1) !<-- MG, Was a bug
RunTestsOnDllChange                         BOOL

!EndRegion Data Directly used by the Window

Window  WINDOW('ClarionTest'),AT(,,600,170),CENTER,GRAY,IMM,SYSTEM,MAX, |
                  ICON('ClarionTest.ico'),FONT('Segoe UI',8,,FONT:regular),RESIZE
                  TOOLBAR,AT(0,0,600,20),USE(?TOOLBAR1)
                      BUTTON('Select All'),AT(2,3,63),USE(?SelectAll),FLAT,TRN
                      BUTTON('Run Selected'),AT(69,3,63,14),USE(?RunSelectedTests),FLAT,TRN
                      BUTTON('Clear Results'),AT(202,3,63,14),USE(?ClearResults),FLAT,TRN
                      CHECK('Run on DLL change'),AT(269,6),USE(RunTestsOnDllChange),TRN
                      BUTTON('Close'),AT(513,3,63,14),USE(?Close),FLAT,TRN
                      BUTTON('Run All'),AT(135,3,63,14),USE(?RunAllTests),FLAT,TRN
                  END
                  PROMPT('Test DLL:'),AT(8,6,35,12),USE(?TestDllPathAndName:Prompt),TRN
                  ENTRY(@s255),AT(42,4,533,12),USE(TestDllPathAndName),COLOR(COLOR:BTNFACE),READONLY
                  BUTTON('...'),AT(579,3,12,12),USE(?LookupTestDllPathAndName)
                  PROGRESS,AT(3,20,595,8),USE(?Progress),RANGE(0,100)
                  LIST,AT(3,32,595,116),USE(?TestList),HVSCROLL,FONT(,10),MARK(TestsQ.Mark),FROM(TestsQ)|
                    ,FORMAT('259L(2)|MYT(1)~Test~@s200@' & |
                           '1020L(2)Y~Result~@s255@')
        END



Resizer                                CLASS(WindowResizeClass)
Init                                            PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                                       END

RunTests:All      EQUATE(TRUE)
RunTests:Selected EQUATE(FALSE)

DirectoryWatcher                       CLASS(DCL_System_Runtime_DirectoryWatcher)
ListOfDlls                                  &DCL_System_IO_Directory
TimeOfLastDirectoryChange                   LONG
PreviousDllsChecksum                        REAL
CurrentDllsChecksum                         REAL
DelayBeforeAutorun                          long(90) !Retrieved from Settings
WhichTests                                  LONG

Construct                                       PROCEDURE()
Destruct                                        PROCEDURE()
DoTask                                          PROCEDURE,VIRTUAL
OnTimer                                         PROCEDURE()
Set                                             PROCEDURE(BOOL IsActive, STRING DirectoryToWatch)
                                       END
                                            
                                            
StdOut                                 DCL_System_IO_StdOut !Only used by CommandLineUtility

                                            itemize(1),pre(Style)
Default                                         equate
Failed                                          equate
Passed                                          equate
GroupName                                       equate
NoResult                                        equate
                                            end

FailedTestCount                             long
FirstFailedTest                             long


TestRunner                                  DCL_ClarionTest_TestRunner
ProceduresQ                                 queue(DCL_ClarionTest_TestProceduresQueue)
                                            end
TestResult                                  &DCL_ClarionTest_TestResult

ProcedureName                               EQUATE('Main')
ProgramDirectory                            cstring(FILE:MaxFilePath + 1)
TestDllDirectory                            cstring(FILE:MaxFilePath + 1)
TestDllName                                 cstring(FILE:MaxFileName + 1)
ShowUI                                      bool

    MAP
      LoadTests()
      RunTests (BOOL RunAllTests)
    END
    
    CODE
    IF COMMAND('CIS') = 'TC' 
        DO CommandLineUtility
    ELSE
        DO Interactive
    END
    

CommandLineUtility   ROUTINE         
   ShowUI      = FALSE
   DO PrepareProcedure
   IF EXISTS(TestDllPathAndName)
       StdOut.Write('##teamcity[testSuiteStarted name=<39>' & TestDllName & '<39>]]')
       LoadTests()
       RunTests(RunTests:All)
       StdOut.Write('##teamcity[testSuiteFinished name=<39>' & TestDllName & '<39>]]')
   ELSE
       StdOut.Write('##teamcity[testFailed message=<39>DLL not found<39> details=<39>' & TestDllPathAndName & '<39>]]')
   END

Interactive          ROUTINE    
    ShowUI = true        
    ProgramDirectory = longpath()
    open(window)
    Window{PROP:MinWidth } = 400
    Window{PROP:MinHeight} = 170
    Resizer.Init(AppStrategy:Spread)
    
    DO PrepareProcedure
    DO AcceptLoop

    settings.Update(ProcedureName,window)
    logger.write('calling settings.update with ' & ProcedureName & ',TestDllPathAndName,' & TestDllPathAndName)
    settings.Update(ProcedureName,'TestDllPathAndName',TestDllPathAndName)
    settings.Update(ProcedureName,'DelayBeforeAutorun',DirectoryWatcher.DelayBeforeAutorun) !Saved, but never altered
    
    CLOSE(window)

PrepareProcedure     ROUTINE !called by Both CommandLine and Interactive
    settings.Fetch(ProcedureName,window)
    settings.Fetch(ProcedureName,'DelayBeforeAutorun',DirectoryWatcher.DelayBeforeAutorun)
    
    TestDllPathAndName = clip(left(COMMAND(1)))
    if TestDllPathAndName <> ''
        !v-- seems like a bug, MG thinks we want to test for NOT AbsolutePath THEN Prepend LONGPATH() and also test for leading '\'
        if INSTRING('\',TestDllPathAndName,1,1) = 0              
            TestDllPathAndName = longpath() & '\' & TestDllPathAndName 
        end
    else
        settings.Fetch(ProcedureName,'TestDllPathAndName',TestDllPathAndName)
    end
  
AcceptLoop           ROUTINE    
  ACCEPT
    DirectoryWatcher.TakeEvent()
    
    case EVENT()
        of EVENT:OpenWindow           ; DO OnOpenWindow
        of EVENT:Sized                ; Resizer.Resize() ; ?Close{PROP:Xpos} = 0{prop:width} - 70
        of EVENT:Timer                ; DirectoryWatcher.OnTimer()
    END
        
    CASE ACCEPTED()
        of ?Close                     ; POST(Event:CloseWindow)
        of ?LookupTestDllPathAndName  ; FILEDIALOG('Chose a test dll',TestDllPathAndName,'Test DLLs|*.dll')
                                        display(?TestDllPathAndName)
                                        logger.write('dgh selected DLL ' & TestDllPathAndName)
                                        LoadTests()
                                       
        of ?RunSelectedTests          ; RunTests(RunTests:Selected)
        of ?RunAllTests               ; RunTests(RunTests:All)
        of ?RunTestsOnDllChange       ; DirectoryWatcher.Set(RunTestsOnDllChange, TestDllDirectory)
        of ?SelectAll                 ; DO OnSelectAll
    END    
  END  
    
OnSelectAll          ROUTINE        
  DATA
QPtr      LONG,AUTO 
MarkValue BOOL,AUTO
  CODE
  MarkValue = CHOOSE( ?SelectAll{prop:text} = 'Select All') 
  LOOP QPtr = 1 to records(TestsQ)
      GET(TestsQ,QPtr)
      IF TestsQ.ProcedureQIndex <> 0
         TestsQ.Mark = MarkValue
         PUT(TestsQ)
      END
  END
  ?SelectAll{prop:text} = CHOOSE( ?SelectAll{prop:text} = 'Select All' ,  'Clear All' , 'Select All' )


OnOpenWindow         ROUTINE 
    DO SetPropStyle
    LoadTests()
    IF COMMAND('/run')
       POST(Event:Accepted,?RunAllTests)
    END

SetPropStyle         ROUTINE  
    DATA
CurrStyle LONG,AUTO
    CODE    
    CurrStyle = Style:Default
       ?TestList{PROPSTYLE:TextColor   , CurrStyle}  = -1
       ?TestList{PROPSTYLE:BackColor   , CurrStyle}  = -1
       ?TestList{PROPSTYLE:TextSelected, CurrStyle}  = ?TestList{PROPSTYLE:TextColor   , CurrStyle}
       ?TestList{PROPSTYLE:BackSelected, CurrStyle}  = ?TestList{PROPSTYLE:BackColor   , CurrStyle}
       ?TestList{PROPSTYLE:FontStyle   , CurrStyle}  = -1

    CurrStyle = Style:NoResult
       ?TestList{PROPSTYLE:TextColor   , CurrStyle}  = color:black
       ?TestList{PROPSTYLE:BackColor   , CurrStyle}  = color:white
       ?TestList{PROPSTYLE:TextSelected, CurrStyle}  = ?TestList{PROPSTYLE:TextColor   , CurrStyle}
       ?TestList{PROPSTYLE:BackSelected, CurrStyle}  = ?TestList{PROPSTYLE:BackColor   , CurrStyle}
       ?TestList{PROPSTYLE:FontStyle   , CurrStyle}  = -1
     
   CurrStyle = Style:Passed
       ?TestList{PROPSTYLE:TextColor   , CurrStyle}  = color:green
       ?TestList{PROPSTYLE:BackColor   , CurrStyle}  = color:white
       ?TestList{PROPSTYLE:TextSelected, CurrStyle}  = ?TestList{PROPSTYLE:TextColor   , CurrStyle}
       ?TestList{PROPSTYLE:BackSelected, CurrStyle}  = ?TestList{PROPSTYLE:BackColor   , CurrStyle}
       ?TestList{PROPSTYLE:FontStyle   , CurrStyle}  = -1
  
  CurrStyle = Style:Failed
       ?TestList{PROPSTYLE:TextColor   , CurrStyle}  = color:red
       ?TestList{PROPSTYLE:BackColor   , CurrStyle}  = color:white
       ?TestList{PROPSTYLE:TextSelected, CurrStyle}  = ?TestList{PROPSTYLE:TextColor   , CurrStyle}
       ?TestList{PROPSTYLE:BackSelected, CurrStyle}  = ?TestList{PROPSTYLE:BackColor   , CurrStyle}
       ?TestList{PROPSTYLE:FontStyle   , CurrStyle}  = FONT:Bold

   CurrStyle = Style:GroupName
       ?TestList{PROPSTYLE:FontStyle   , CurrStyle}  = FONT:Bold
       ?TestList{PROPSTYLE:TextSelected, CurrStyle}  = -1
       ?TestList{PROPSTYLE:BackSelected, CurrStyle}  = -1        

   
LoadTests           PROCEDURE()
   CODE
    FREE(TestsQ)
    FREE(ProceduresQ)

    DirectoryWatcher.Set(RunTestsOnDllChange, TestDllDirectory)
    DO Load:FillProceduresQ

    SORT(ProceduresQ  , ProceduresQ.TestGroupPriority |
                      , ProceduresQ.TestGroupName     |
                      , ProceduresQ.TestPriority      |
                      , ProceduresQ.TestName          )
    DO Load:ProceduresQ_to_TestQ                      
    
Load:ProceduresQ_to_TestQ  ROUTINE
   DATA
QPtr                      LONG,AUTO
PreviousGroupOrTestName   LIKE(ProceduresQ.TestGroupName)
   CODE  
   LOOP QPtr = 1 to RECORDS(ProceduresQ)
        GET(ProceduresQ,QPtr)
        IF  PreviousGroupOrTestName <> ProceduresQ.TestGroupName  OR QPtr = 1
            PreviousGroupOrTestName =  ProceduresQ.TestGroupName
            CLEAR(TestsQ)
            TestsQ.GroupOrTestStyle = Style:GroupName
            TestsQ.GroupOrTestName  = ProceduresQ.TestGroupName
            TestsQ.GroupOrTestLevel = 1
            TestsQ.ProcedureQIndex  = 0
            ADD(TestsQ)
        END
        TestsQ.GroupOrTestStyle = Style:Default
        TestsQ.GroupOrTestName  = ProceduresQ.TestName
        TestsQ.GroupOrTestLevel = 2
        TestsQ.ProcedureQIndex  = QPtr
        
        TestsQ.TestResult       = ''
        TestsQ.TestResultStyle  = Style:NoResult
        TestsQ.Mark = false
        Add(TestsQ)
   END

Load:FillProceduresQ       ROUTINE    
   DATA
str                                         DCL_System_String
   CODE  
                                                      logger.Write('Loading tests from ' & TestDllPathAndName)
    str.Assign(TestDllPathAndName)
    TestDllDirectory = str.SubString(1,str.LastIndexOf('\'))
    IF TestDllDirectory <> ''
        IF NOT EXISTS(TestDllDirectory)
            MESSAGE('The test directory ' & TestDllDirectory & ' does not exist')
        ELSE
            setpath(TestDllDirectory)
            TestDllName = str.SubString(str.LastIndexOf('\') + 1,str.Length())
                                                      logger.write('dgh Loading test procedures for ' & TestDllName)
            !----------------------------------------------
            TestRunner.Init(TestDllName)              
            TestRunner.GetTestProcedures(ProceduresQ)
            !----------------------------------------------
                                                      logger.Write('Found ' & records(ProceduresQ) & ' tests')
        END
    END



RunTests             PROCEDURE(BOOL RunAllTests)
TestsToRun           LONG,AUTO
CurrentTestIndex     LONG
   CODE
    SETCURSOR(cursor:wait)
    FailedTestCount = 0
    FirstFailedTest = 0
    
    TestRunner.Init(TestDllName)    
    DO RunTests:CountTestsToRun
    ?Progress{prop:RangeHigh} = TestsToRun

    Do RunTests:RunTestQ
    TestRunner.Kill()    
    DO RunTests:ShowSummaryOfResults
    
    DirectoryWatcher.WhichTests = RunAllTests 
    SETCURSOR()

RunTests:CountTestsToRun ROUTINE    
   DATA
QPtr LONG,AUTO
   CODE   
                                       !dbg.write('RunTests routine is initializing the dll') 
    TestsToRun = 0
    loop QPtr = 1 to records(TestsQ)
        get(TestsQ,QPtr)
        get(ProceduresQ,TestsQ.ProcedureQIndex)
        if ~errorcode()
            IF RunAllTests=RunTests:All OR TestsQ.Mark = TRUE then TestsToRun += 1 END
        end
    end
 
RunTests:RunTestQ                 ROUTINE
   DATA
QPtr  LONG,AUTO

   CODE   
    CurrentTestIndex = 0   !Tests Run So far
    LOOP QPtr = 1 TO RECORDS(TestsQ)
        GET(TestsQ,QPtr)
        
        IF RunAllTests=RunTests:Selected AND TestsQ.mark = FALSE  !THEN dbg.Message('Skipping this item')
            TestsQ.TestResult = ''    !Should there be more indication, like setting the sytle to Ignored?
            PUT(TestsQ)
            CYCLE
            
        ELSIF TestsQ.ProcedureQIndex <> 0 
           GET(ProceduresQ,TestsQ.ProcedureQIndex)
           IF ~ERRORCODE()
               DO RunTests:LogBeforeRun
               TestResult &= TestRunner.RunTestByName(TestsQ.GroupOrTestName) !<----
               DO RunTests:SaveResultsToTestQ
               DO RunTests:LogAfterRun
               
               IF FirstFailedTest = 0    AND TestsQ.TestResultStyle = Style:Failed 
                  FirstFailedTest = QPtr
               END
           END
        END           
    END
  
RunTests:ShowSummaryOfResults     ROUTINE    
    if ShowUI
        !display()
        0{prop:text} = 'ClarionTest - ' & |
                          FailedTestCount & ' failed test' & CHOOSE(FailedTestCount=1,'','s') & |
                          ' at ' & FORMAT(CLOCK(),@T6)          
                          
        if FailedTestCount > 0
            beep(BEEP:SystemHand)
            ?TestList{PROP:Selected} = FirstFailedTest
        else
            beep(BEEP:SystemExclamation)
        end
    end

RunTests:LogBeforeRun             ROUTINE         
!     !dbg.write('Got record ' & TestsQ.qPointer & ', test ' & ProceduresQ.TestName)
!     !dbg.write('Running test ' & ProceduresQ.TestName)
    if not ShowUI
        StdOut.Write('##teamcity[testStarted name=<39>' & clip(TestsQ.GroupOrTestName) & '<39>]]')
    end
            
RunTests:LogAfterRun              ROUTINE            
    CurrentTestIndex += 1
    if ShowUI
        ?Progress{PROP:Progress} = CurrentTestIndex
        display(?Progress)        
    end
    
    if not ShowUI
        IF TestsQ.TestResultStyle = Style:Failed  
            StdOut.Write('##teamcity[testFailed name=<39>' & clip(TestsQ.GroupOrTestName) & '<39> message=<39>' & clip(TestResult.Message) & '<39> details=<39>' & clip(TestResult.Message) & '<39>]]')
        end  
        StdOut.Write('##teamcity[testFinished name=<39>'   & clip(TestsQ.GroupOrTestName) & '<39>]]')
    end

RunTests:SaveResultsToTestQ       ROUTINE            
    !ProceduresQ.TestResultStyle = Style:Failed
    if TestResult &= NULL                  ; TestsQ.TestDescription = 'Failed: TestResult object was null'
                                             TestsQ.TestStatus = DCL_ClarionTest_Status_Fail
                                             FailedTestCount += 1
    ELSE                
                                             TestsQ.TestStatus = TestResult.Status
        CASE TestResult.Status 
          OF DCL_ClarionTest_Status_Pass   ; TestsQ.TestResult = 'Passed ' & TestResult.Description
                                             TestsQ.TestResultStyle = Style:Passed
                                             
          OF DCL_ClarionTest_Status_Ignore ; TestsQ.TestResult = 'Ignored: ' & TestResult.Message
          
        ELSE                               ; TestsQ.TestResult = 'Failed: ' & TestResult.Message
                                             TestsQ.TestResultStyle = Style:Failed
                                             FailedTestCount += 1                         
        END
    END
    PUT(TestsQ)  
    

!Region  DirectoryWatcher Methods
DirectoryWatcher.Construct                   PROCEDURE()
   CODE
   SELF.TimeOfLastDirectoryChange =  0 
   SELF.PreviousDllsChecksum      =  0
   SELF.CurrentDllsChecksum       =  0
   SELF.DelayBeforeAutorun        = 90 !Retrieved from Settings
   SELF.WhichTests                = RunTests:All
   
   SELF.ListOfDlls               &= NEW DCL_System_IO_Directory
   
DirectoryWatcher.Destruct                                        PROCEDURE()   
   CODE
   DISPOSE(SELF.ListOfDlls)


DirectoryWatcher.Set PROCEDURE(BOOL IsActive, STRING DirectoryToWatch)
   CODE
    logger.write('DirectoryWatcher.Set DirectoryName['& DirectoryToWatch &'] IsActive['& IsActive &']')
    if IsActive AND EXISTS(DirectoryToWatch)
        SELF.Init(DirectoryToWatch)
        SELF.noNotifyOnStartup = TRUE
        
        SELF.ListOfDlls.Init(DirectoryToWatch)
        SELF.ListOfDlls.SetFilter('*.dll')
        SELF.ListOfDlls.GetDirectoryListing()
        SELF.PreviousDllsChecksum = SELF.ListOfDlls.GetChecksum()
    else
        SELF.Kill()
    end

DirectoryWatcher.OnTimer              PROCEDURE()
   CODE
    IF SELF.TimeOfLastDirectoryChange > 0 |
       AND ~INRANGE( CLOCK(), SELF.TimeOfLastDirectoryChange, SELF.TimeOfLastDirectoryChange + SELF.DelayBeforeAutorun)  |
    THEN
        0{PROP:Timer} = 0
        SELF.TimeOfLastDirectoryChange = 0
        
        SELF.ListOfDlls.GetDirectoryListing()
        SELF.CurrentDllsChecksum = SELF.ListOfDlls.GetChecksum()
        if SELF.PreviousDllsChecksum <> SELF.CurrentDllsChecksum 
           SELF.PreviousDllsChecksum =  SELF.CurrentDllsChecksum
           
           RunTests( SELF.WhichTests ) !<=====================
        END       
    END

DirectoryWatcher.DoTask    PROCEDURE!,VIRTUAL  !Watched Folder Has Changed
   CODE
   SELF.TimeOfLastDirectoryChange = CLOCK()
   IF SELF.DelayBeforeAutorun 
      0{PROP:Timer} = SELF.DelayBeforeAutorun  + 1
   ELSE
      SELF.OnTimer()
   END

   
!EndRegion  DirectoryWatcher Methods   

Resizer.Init               PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
    CODE
    PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
    SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window
    SELF.SetStrategy(?Progress                  , Resize:FixLeft  + Resize:FixTop    ,Resize:LockHeight    + Resize:Resize) ! Override strategy for ?TestList1
    SELF.SetStrategy(?TestList                  , Resize:LockXPos + Resize:LockYPos  ,Resize:ConstantRight + Resize:ConstantBottom) ! Override strategy for ?TestList1
    self.SetStrategy(?TestDllPathAndName:Prompt , Resize:FixLeft  + Resize:FixTop    ,Resize:LockSize)
    self.SetStrategy(?TestDllPathAndName        , Resize:FixLeft  + Resize:FixTop    ,Resize:LockHeight    + Resize:Resize)
    self.SetParentControl(?LookupTestDllPathAndName,?TestDllPathAndName)


