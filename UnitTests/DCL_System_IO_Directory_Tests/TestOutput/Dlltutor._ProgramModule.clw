   PROGRAM



   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE

   MAP
     MODULE('Windows API')
SystemParametersInfo PROCEDURE (LONG uAction, LONG uParam, *? lpvParam, LONG fuWinIni),LONG,RAW,PROC,PASCAL,DLL(TRUE),NAME('SystemParametersInfoA')
     END
    MODULE('REPORTS.DLL')
CustReport             PROCEDURE,DLL                       ! 
InvoiceReport          PROCEDURE,DLL                       ! 
    END
    MODULE('UPDATES.DLL')
CustInvoiceReport      PROCEDURE,DLL                       ! 
ViewCustomers          PROCEDURE,DLL                       ! 
ViewOrders             PROCEDURE,DLL                       ! 
ViewProducts           PROCEDURE,DLL                       ! 
    END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('DLLTUTOR001.CLW')
Main                   PROCEDURE   !
     END
    ! Declare init functions defined in a different dll
     MODULE('ALLFILES.DLL')
allfiles:Init          PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>),DLL
allfiles:Kill          PROCEDURE,DLL
     END
     MODULE('REPORTS.DLL')
reports:Init           PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>),DLL
reports:Kill           PROCEDURE,DLL
     END
     MODULE('UPDATES.DLL')
updates:Init           PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>),DLL
updates:Kill           PROCEDURE,DLL
     END
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
!endregion


FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE,EXTERNAL,DLL(dll_mode),THREAD    ! Exported from a dll, set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE,EXTERNAL,DLL(dll_mode),THREAD    ! Exported from a dll, set to the response from the form
VCRRequest           LONG,EXTERNAL,DLL(dll_mode),THREAD    ! Exported from a dll, set to the request from the VCR buttons
lCurrentFDSetting    LONG                                  ! Used by window frame dragging
lAdjFDSetting        LONG                                  ! ditto

  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\Dlltutor.INI', NVD_INI)                   ! Configure INIManager to use INI file
  SystemParametersInfo (38, 0, lCurrentFDSetting, 0)       ! Configure frame dragging
  IF lCurrentFDSetting = 1
    SystemParametersInfo (37, 0, lAdjFDSetting, 3)
  END
  allfiles:Init(GlobalErrors, INIMgr)                      ! Initialise dll (ABC)
  reports:Init(GlobalErrors, INIMgr)                       ! Initialise dll (ABC)
  updates:Init(GlobalErrors, INIMgr)                       ! Initialise dll (ABC)
  Main
  INIMgr.Update
  allfiles:Kill()                                          ! Kill dll (ABC)
  reports:Kill()                                           ! Kill dll (ABC)
  updates:Kill()                                           ! Kill dll (ABC)
  IF lCurrentFDSetting = 1
    SystemParametersInfo (37, 1, lAdjFDSetting, 3)
  END
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher

