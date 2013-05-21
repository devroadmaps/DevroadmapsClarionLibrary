!================================================================================
! Reports.CustReport
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\testdata\REPORTS001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\testoutput\Reports.CustReport.clw
!
! This file may also be included in a combined source file called
! Reports._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Reports.CustReport will have a more complete history than
! Reports.allprocedures.clw provided the original extracted procedure
! file was renamed in the version control system)
!================================================================================
! Start of original module header
!================================================================================
!
!
!   MEMBER('Reports.clw')                                   ! This is a MEMBER module
!
!
!   INCLUDE('ABBROWSE.INC'),ONCE
!   INCLUDE('ABREPORT.INC'),ONCE
!
!                     MAP
!                       INCLUDE('REPORTS001.INC'),ONCE        !Local module procedure declarations
!                     END
!
!
!================================================================================
! End of original module header
!================================================================================
CustReport PROCEDURE                                       ! Generated from procedure template - Report

Progress:Thermometer BYTE                                  !
FilesOpened          BYTE                                  !
Process:View         VIEW(Customer)
                       PROJECT(CUS:Address)
                       PROJECT(CUS:City)
                       PROJECT(CUS:Company)
                       PROJECT(CUS:CustNumber)
                       PROJECT(CUS:FirstName)
                       PROJECT(CUS:LastName)
                       PROJECT(CUS:State)
                       PROJECT(CUS:ZipCode)
                     END
ReportPageNumber     LONG,AUTO
ProgressWindow       WINDOW('Progress...'),AT(,,142,59),DOUBLE,CENTER,GRAY,TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Cancel'),AT(45,42,50,15),USE(?Progress:Cancel)
                     END

Report               REPORT,AT(1000,2000,6000,7000),PRE(RPT),FONT('Arial',12,COLOR:Black,FONT:regular),THOUS
                       HEADER,AT(1000,1000,6000,1000)
                         STRING(@N3),AT(1225,83),USE(ReportPageNumber)
                         STRING('Page Number:'),AT(115,83),USE(?String1),TRN
                       END
detail                 DETAIL,AT(,,,1067)
                         STRING(@s20),AT(108,100),USE(CUS:Company)
                         STRING(@s20),AT(2067,308),USE(CUS:LastName)
                         STRING(@s20),AT(108,308),USE(CUS:FirstName)
                         STRING(@s20),AT(108,517),USE(CUS:Address)
                         STRING(@P#####P),AT(2317,708),USE(CUS:ZipCode),RIGHT(1)
                         STRING(@s2),AT(2033,708),USE(CUS:State)
                         STRING(@s20),AT(108,708),USE(CUS:City)
                       END
                       FOOTER,AT(1000,9000,6000,1000)
                       END
                       FORM,AT(1000,1000,6000,9000)
                       END
                     END
ThisWindow           CLASS(ReportManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED       ! Method added to host embed code
Kill                   PROCEDURE(),BYTE,PROC,DERIVED       ! Method added to host embed code
OpenReport             PROCEDURE(),BYTE,PROC,DERIVED       ! Method added to host embed code
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED       ! Method added to host embed code
                     END

ProgressMgr          StepLongClass                         ! Progress Manager
Previewer            PrintPreviewClass                     ! Print Previewer

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('CustReport')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:Customer.Open                                     ! File Customer used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('CustReport',ProgressWindow)                ! Restore window settings from non-volatile store
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  ProgressMgr.Init(ScrollSort:AllowNumeric,)
  ThisReport.Init(Process:View, Relate:Customer, ?Progress:PctText, Progress:Thermometer, ProgressMgr, CUS:CustNumber)
  ThisReport.AddSortOrder(CUS:KeyCustNumber)
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,Report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:Customer.SetQuickScan(1,Propagate:OneMany)
  SELF.SkipPreview = False
  Previewer.SetINIManager(INIMgr)
  Previewer.AllowUserZoom = True
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Customer.Close
  END
  IF SELF.Opened
    INIMgr.Update('CustReport',ProgressWindow)             ! Save window data to non-volatile store
  END
  ProgressMgr.Kill()
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.OpenReport PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.OpenReport()
  IF ReturnValue = Level:Benign
    Report$?ReportPageNumber{PROP:PageNo} = True
  END
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:detail)
  RETURN ReturnValue

