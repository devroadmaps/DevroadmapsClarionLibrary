   PROGRAM



   INCLUDE('ABASCII.INC'),ONCE
   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABDROPS.INC'),ONCE
   INCLUDE('ABEIP.INC'),ONCE
   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABPRHTML.INC'),ONCE
   INCLUDE('ABPRPDF.INC'),ONCE
   INCLUDE('ABQUERY.INC'),ONCE
   INCLUDE('ABREPORT.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABTBLSYN.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE
   INCLUDE('ABWMFPAR.INC'),ONCE
   INCLUDE('ALSUZCLA.INC'),ONCE
   INCLUDE('CSIDLFOLDER.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('SPECIALFOLDER.INC'),ONCE
   INCLUDE('ABBREAK.INC'),ONCE
   INCLUDE('ABCPTHD.INC'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE
   INCLUDE('ABGRID.INC'),ONCE
   INCLUDE('ABPRNAME.INC'),ONCE
   INCLUDE('ABPRTARG.INC'),ONCE
   INCLUDE('ABPRTARY.INC'),ONCE
   INCLUDE('ABPRTEXT.INC'),ONCE
   INCLUDE('ABPRXML.INC'),ONCE
   INCLUDE('ABQEIP.INC'),ONCE
   INCLUDE('ABRPATMG.INC'),ONCE
   INCLUDE('ABRPPSEL.INC'),ONCE
   INCLUDE('ABRULE.INC'),ONCE
   INCLUDE('ABVCRFRM.INC'),ONCE
   INCLUDE('ALSZCLA.INC'),ONCE
   INCLUDE('CFILTBASE.INC'),ONCE
   INCLUDE('CFILTERLIST.INC'),ONCE
   INCLUDE('CWSYNCHC.INC'),ONCE
   INCLUDE('MDISYNC.INC'),ONCE
   INCLUDE('QPROCESS.INC'),ONCE
   INCLUDE('RTFCTL.INC'),ONCE
   INCLUDE('SUBCLASSWINDOW.INC'),ONCE
   INCLUDE('TRIGGER.INC'),ONCE
   INCLUDE('WINEXT.INC'),ONCE
   INCLUDE('XPWINDOW.INC'),ONCE
include('CM_System_Diagnostics_Debugger.inc'),once


gdbg                                    CM_System_Diagnostics_Debugger,external,dll

   MAP
     MODULE('DEMODLL_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('ANOTHERTESTGROUP.CLW')
_001_CompareTwoStrings_Verify FUNCTION(*long addr),long,pascal   !
_002_CompareTruetoFalse_DeliberateTestFailure FUNCTION(*long addr),long,pascal   !
     END
     MODULE('MYTESTGROUP.CLW')
_002_CompareTwoIntegers_Verify FUNCTION(*long addr),long,pascal   !
_001_CompareTwoGroups_Verify FUNCTION(*long addr),long,pascal   !This test will compare two groups of numbers, and verify that they match.  
_001_Group1            PROCEDURE   !
_002_Group2            PROCEDURE   !
_003_CompareTwsoStrings FUNCTION(*long addr),long,pascal   !
_003_AnotherGroup      PROCEDURE   !
     END
       include('CM_ClarionTest_GlobalCodeAndData.inc','GlobalMap'),once
ClarionTest_GetListOfTestProcedures PROCEDURE(*LONG Addr),LONG,PASCAL
    ! Declare functions defined in this DLL
DemoDLL:Init           PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
DemoDLL:Kill           PROCEDURE
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
!endregion

  include('CM_ClarionTest_GlobalCodeAndData.inc','GlobalData'),once
ClarionTest_ctpl    CM_ClarionTest_Procedures

TestClass   CLASS
Construct       PROCEDURE
            END

GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons
FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
LocalErrorStatus     ErrorStatusClass,THREAD
LocalErrors          ErrorClass
LocalINIMgr          INIClass
GlobalErrors         &ErrorClass
INIMgr               &INIClass
DLLInitializer       CLASS,TYPE                            ! An object of this type is used to initialize the dll, it is created in the generated bc module
Construct              PROCEDURE
Destruct               PROCEDURE
                     END

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
DLLInitializer.Construct PROCEDURE


  CODE
  LocalErrors.Init(LocalErrorStatus)
  LocalINIMgr.Init('.\DemoDLL.INI', NVD_INI)               ! Initialize the local INI manager to use windows INI file
  INIMgr &= LocalINIMgr
  IF GlobalErrors &= NULL
    GlobalErrors &= LocalErrors                            ! Assign local managers to global managers
  END
  DctInit
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  
  INCLUDE('CM_ClarionTest_GlobalCodeAndData.inc','ProgramProcedures')
ClarionTest_GetListOfTestProcedures PROCEDURE(*LONG Addr)
  CODE
  Addr = ADDRESS(ClarionTest_ctpl)
  FREE(ClarionTest_ctpl.List)
  ClarionTest_ctpl.List.Priority       = 3
  ClarionTest_ctpl.List.TestGroup      = '_001_Group1'
  ClarionTest_ctpl.List.testname       = '_003_CompareTwsoStrings'
  ClarionTest_ctpl.List.TestGroupOrder = 1
  
  ADD(ClarionTest_ctpl.List)
  ClarionTest_ctpl.List.Priority       = 2
  ClarionTest_ctpl.List.TestGroup      = '_001_Group1'
  ClarionTest_ctpl.List.testname       = '_002_CompareTruetoFalse_DeliberateTestFailure'
  ClarionTest_ctpl.List.TestGroupOrder = 1
  
  ADD(ClarionTest_ctpl.List)
  ClarionTest_ctpl.List.Priority       = 1
  ClarionTest_ctpl.List.TestGroup      = '_001_Group1'
  ClarionTest_ctpl.List.testname       = '_001_CompareTwoGroups_Verify'
  ClarionTest_ctpl.List.TestGroupOrder = 1
  
  ADD(ClarionTest_ctpl.List)
  ClarionTest_ctpl.List.Priority       = 2
  ClarionTest_ctpl.List.TestGroup      = '_002_Group2'
  ClarionTest_ctpl.List.testname       = '_002_CompareTwoIntegers_Verify'
  ClarionTest_ctpl.List.TestGroupOrder = 2
  
  ADD(ClarionTest_ctpl.List)
  ClarionTest_ctpl.List.Priority       = 1
  ClarionTest_ctpl.List.TestGroup      = '_002_Group2'
  ClarionTest_ctpl.List.testname       = '_001_CompareTwoStrings_Verify'
  ClarionTest_ctpl.List.TestGroupOrder = 2
  
  ADD(ClarionTest_ctpl.List)
  RETURN 0
TestClass.Construct                     PROCEDURE
    CODE
    !MESSAGE('Hello')
!These procedures are used to initialize the DLL. It must be called by the main executable when it starts up
DemoDLL:Init PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
DemoDLL:Init_Called    BYTE,STATIC

  CODE
  IF DemoDLL:Init_Called
     RETURN
  ELSE
     DemoDLL:Init_Called = True
  END
  IF ~curGlobalErrors &= NULL
    GlobalErrors &= curGlobalErrors
  END
  IF ~curINIMgr &= NULL
    INIMgr &= curINIMgr
  END

!This procedure is used to shutdown the DLL. It must be called by the main executable before it closes down

DemoDLL:Kill PROCEDURE
DemoDLL:Kill_Called    BYTE,STATIC

  CODE
  IF DemoDLL:Kill_Called
     RETURN
  ELSE
     DemoDLL:Kill_Called = True
  END
  

DLLInitializer.Destruct PROCEDURE

  CODE
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher
  LocalINIMgr.Kill                                         ! Kill local managers and assign NULL to global refernces
  INIMgr &= NULL                                           ! It is an error to reference these object after this point
  GlobalErrors &= NULL



Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

