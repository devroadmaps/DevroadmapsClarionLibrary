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
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE
   INCLUDE('ABWMFPAR.INC'),ONCE
   INCLUDE('ANYASCII.INC'),ONCE
   INCLUDE('CSIDLFOLDER.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('NETCRIT.INC'),ONCE
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
   INCLUDE('CCICS.INC'),ONCE
   INCLUDE('CFILTBASE.INC'),ONCE
   INCLUDE('CFILTERLIST.INC'),ONCE
   INCLUDE('CWSYNCHC.INC'),ONCE
   INCLUDE('MDISYNC.INC'),ONCE
   INCLUDE('QPROCESS.INC'),ONCE
   INCLUDE('RTFCTL.INC'),ONCE
   INCLUDE('TRIGGER.INC'),ONCE
   INCLUDE('WINEXT.INC'),ONCE

   MAP
     MODULE('DEMODLL_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('ANOTHERTESTGROUP.CLW')
CompareTwoStrings_Verify FUNCTION(*long addr),long,pascal   !
CompareTruetoFalse_DeliberateTestFailure FUNCTION(*long addr),long,pascal   !
     END
     MODULE('MYTESTGROUP.CLW')
CompareTwoIntegers_Verify FUNCTION(*long addr),long,pascal   !
CompareTwoGroups_Verify FUNCTION(*long addr),long,pascal   !This test will compare two groups of numbers, and verify that they match.  
Group1                 PROCEDURE   !
Group2                 PROCEDURE   !
CompareTwoStrings      FUNCTION(*long addr),long,pascal   !
     END
     MODULE('DEMODLL001.CLW')
CompareEmptyString     FUNCTION(*long addr),long,pascal   !
     END
       include('DCL_ClarionTest_GlobalCodeAndData.inc','GlobalMap'),once
ClarionTest_GetListOfTestProcedures PROCEDURE(*LONG Addr),LONG,PASCAL
    ! Declare functions defined in this DLL
DemoDLL:Init           PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
DemoDLL:Kill           PROCEDURE
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
!endregion

  include('DCL_ClarionTest_GlobalCodeAndData.inc','GlobalData'),once
  include('DCL_ClarionTest_TestProcedures.inc'),once
ClarionTest_ctpl    DCL_ClarionTest_TestProcedures

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
  
  INCLUDE('DCL_ClarionTest_GlobalCodeAndData.inc','ProgramProcedures')
ClarionTest_GetListOfTestProcedures PROCEDURE(*LONG Addr)
    CODE
    Addr = ADDRESS(ClarionTest_ctpl)
    FREE(ClarionTest_ctpl.List)
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'CompareTwoStrings'
    ClarionTest_ctpl.List.TestGroupName      = 'Group1'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'CompareTruetoFalse_DeliberateTestFailure'
    ClarionTest_ctpl.List.TestGroupName      = 'Group1'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'CompareTwoGroups_Verify'
    ClarionTest_ctpl.List.TestGroupName      = 'Group1'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'CompareTwoStrings_Verify'
    ClarionTest_ctpl.List.TestGroupName      = 'Group2'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'CompareTwoIntegers_Verify'
    ClarionTest_ctpl.List.TestGroupName      = 'Group2'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'CompareEmptyString'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
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

