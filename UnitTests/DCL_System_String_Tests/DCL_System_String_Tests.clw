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
   INCLUDE('CFILTBASE.INC'),ONCE
   INCLUDE('CFILTERLIST.INC'),ONCE
   INCLUDE('CWSYNCHC.INC'),ONCE
   INCLUDE('MDISYNC.INC'),ONCE
   INCLUDE('QPROCESS.INC'),ONCE
   INCLUDE('RTFCTL.INC'),ONCE
   INCLUDE('TRIGGER.INC'),ONCE
   INCLUDE('WINEXT.INC'),ONCE
	include('DCL_system_string.inc'),once

   MAP
     MODULE('DCL_SYSTEM_STRING_TESTS_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('DCL_SYSTEM_STRING_TESTS001.CLW')
Main                   PROCEDURE   !
     END
     MODULE('DCL_SYSTEM_STRING_TESTS002.CLW')
ReplaceString_Verify   FUNCTION(*long addr),long,pascal   !
PrependString_Verify   FUNCTION(*long addr),long,pascal   !
FindLastIndexOf_Verify FUNCTION(*long addr),long,pascal   !
InsertStringIntoString_Verify FUNCTION(*long addr),long,pascal   !
InsertStringIntoFilePath_Verify FUNCTION(*long addr),long,pascal   !
FindIndexOf_Verify     FUNCTION(*long addr),long,pascal   !
DoesStringBeginWith_Verify FUNCTION(*long addr),long,pascal   !
DoesStringEndWith_Verify FUNCTION(*long addr),long,pascal   !
SplitString_VerifyCountAndValues FUNCTION(*long addr),long,pascal   !
SplitStringWithMultipleDelimiters_VerifyCountAndValues FUNCTION(*long addr),long,pascal   !
     END
     MODULE('DCL_SYSTEM_STRING_TESTS003.CLW')
TrimString_Verify      FUNCTION(*long addr),long,pascal   !
ReplaceWholeWord_Verify FUNCTION(*long addr),long,pascal   !
IsAlpha_Verify         FUNCTION(*long addr),long,pascal   !
ReplaceMultipleWords_Verify FUNCTION(*long addr),long,pascal   !
SplitString_DelmitersOnly_VerifyCountAndValues FUNCTION(*long addr),long,pascal   !
SplitString_LeadingDelmiter_VerifyCountAndValues FUNCTION(*long addr),long,pascal   !
SplitString_BugReport_IndexOutOfRange FUNCTION(*long addr),long,pascal   !
SplitString_ReplaceOneLine_Verify FUNCTION(*long addr),long,pascal   !
SplitString_ChangeOneLine_VerifyWhole FUNCTION(*long addr),long,pascal   !
CurrentTests           PROCEDURE   !
     END
     MODULE('DCL_SYSTEM_STRING_TESTS004.CLW')
ReplaceWord_Bug_1_VerifyFix FUNCTION(*long addr),long,pascal   !
ReplaceStringWithClearedCString_Verify FUNCTION(*long addr),long,pascal   !
AppendSpace_Verify     FUNCTION(*long addr),long,pascal   !
AppendNothing_Verify   FUNCTION(*long addr),long,pascal   !
     END
       include('DCL_ClarionTest_GlobalCodeAndData.inc','GlobalMap'),once
ClarionTest_GetListOfTestProcedures PROCEDURE(*LONG Addr),LONG,PASCAL
    ! Declare functions defined in this DLL
DCL_System_String_Tests:Init PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
DCL_System_String_Tests:Kill PROCEDURE
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
!endregion

  include('DCL_ClarionTest_GlobalCodeAndData.inc','GlobalData'),once
  include('DCL_ClarionTest_TestProcedures.inc'),once
ClarionTest_ctpl    DCL_ClarionTest_TestProcedures

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
  LocalINIMgr.Init('.\DCL_System_String_Tests.INI', NVD_INI) ! Initialize the local INI manager to use windows INI file
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
    ClarionTest_ctpl.List.TestName       = 'AppendSpace_Verify'
    ClarionTest_ctpl.List.TestGroupName      = 'CurrentTests'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'AppendNothing_Verify'
    ClarionTest_ctpl.List.TestGroupName      = 'CurrentTests'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'PrependString_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'SplitString_LeadingDelmiter_VerifyCountAndValues'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'ReplaceString_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'SplitStringWithMultipleDelimiters_VerifyCountAndValues'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'SplitString_BugReport_IndexOutOfRange'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'FindIndexOf_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'IsAlpha_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'SplitString_VerifyCountAndValues'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'ReplaceWord_Bug_1_VerifyFix'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'DoesStringEndWith_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'FindLastIndexOf_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'InsertStringIntoString_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'ReplaceWholeWord_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'ReplaceMultipleWords_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'TrimString_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'SplitString_ReplaceOneLine_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'SplitString_DelmitersOnly_VerifyCountAndValues'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'DoesStringBeginWith_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'SplitString_ChangeOneLine_VerifyWhole'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'ReplaceStringWithClearedCString_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    ClarionTest_ctpl.List.TestPriority       = 10
    ClarionTest_ctpl.List.TestName       = 'InsertStringIntoFilePath_Verify'
    ClarionTest_ctpl.List.TestGroupName      = '_000_Default'
    ClarionTest_ctpl.List.TestGroupPriority = 0
    ADD(ClarionTest_ctpl.List)
        
    RETURN 0
!These procedures are used to initialize the DLL. It must be called by the main executable when it starts up
DCL_System_String_Tests:Init PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
DCL_System_String_Tests:Init_Called    BYTE,STATIC

  CODE
  IF DCL_System_String_Tests:Init_Called
     RETURN
  ELSE
     DCL_System_String_Tests:Init_Called = True
  END
  IF ~curGlobalErrors &= NULL
    GlobalErrors &= curGlobalErrors
  END
  IF ~curINIMgr &= NULL
    INIMgr &= curINIMgr
  END

!This procedure is used to shutdown the DLL. It must be called by the main executable before it closes down

DCL_System_String_Tests:Kill PROCEDURE
DCL_System_String_Tests:Kill_Called    BYTE,STATIC

  CODE
  IF DCL_System_String_Tests:Kill_Called
     RETURN
  ELSE
     DCL_System_String_Tests:Kill_Called = True
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

