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
   INCLUDE('XPLORE.INC'),ONCE
   INCLUDE('XPLORERT.INC'),ONCE

   MAP
     MODULE('DEMODLL_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('DEMODLL001.CLW')
Main                   PROCEDURE   !
     END
     MODULE('DEMODLL002.CLW')
Deliberate_Failure_For_Demo_Purposes FUNCTION(*long addr),long,pascal   !
     END
     MODULE('DEMODLL004.CLW')
Test_String_Comparison FUNCTION(*long addr),long,pascal   !
Test_Integer_Comparison FUNCTION(*long addr),long,pascal   !
Test_Group_Comparison  FUNCTION(*long addr),long,pascal   !
     END
      include('CM_ClarionTest_GlobalCodeAndData.inc','GlobalMap'),once
ClarionTest_GetListOfTestProcedures	procedure(*long addr),long,pascal
    ! Declare functions defined in this DLL
DemoDLL:Init           PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
DemoDLL:Kill           PROCEDURE
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
!endregion

 include('CM_ClarionTest_GlobalCodeAndData.inc','GlobalData'),once
ClarionTest_ctpl 			CM_ClarionTest_Procedures

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
  
 include('CM_ClarionTest_GlobalCodeAndData.inc','ProgramProcedures'),once
ClarionTest_GetListOfTestProcedures	procedure(*long addr)
 code
 addr = address(ClarionTest_ctpl)
 free(ClarionTest_ctpl.List)
 ClarionTest_ctpl.List.testname = 'Test_Integer_Comparison' ! Test procedures
 add(ClarionTest_ctpl.List,ClarionTest_ctpl.List.testname)
 ClarionTest_ctpl.List.testname = 'Deliberate_Failure_For_Demo_Purposes' ! 
 add(ClarionTest_ctpl.List,ClarionTest_ctpl.List.testname)
 ClarionTest_ctpl.List.testname = 'Test_Group_Comparison' ! Test procedures
 add(ClarionTest_ctpl.List,ClarionTest_ctpl.List.testname)
 ClarionTest_ctpl.List.testname = 'Test_String_Comparison' ! Test procedures
 add(ClarionTest_ctpl.List,ClarionTest_ctpl.List.testname)
 return true
 
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

