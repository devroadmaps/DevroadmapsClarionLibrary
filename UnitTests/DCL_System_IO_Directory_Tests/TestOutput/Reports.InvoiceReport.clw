!================================================================================
! Reports.CustReport
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\testdata\REPORTS001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\testoutput\Reports.InvoiceReport.clw
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
InvoiceReport PROCEDURE                                    ! Generated from procedure template - Report

                                                & 'asdf',
Progress:Thermometer BYTE                                  !
FilesOpened          BYTE                                  !
ItemTotal            DECIMAL(7,2)                          !
InvoiceCount         LONG                                  !
sadf asd fasd
Process:View         VIEW(Customer)
                       PROJECT(CUS:Address)
                       PROJECT(CUS:City)
                       PROJECT(CUS:Company)
                       PROJECT(CUS:CustNumber)
                       PROJECT(CUS:FirstName)
                       PROJECT(CUS:LastName)
                       PROJECT(CUS:State)
                       PROJECT(CUS:ZipCode)
                       JOIN(ORD:KeyCustNumber,CUS:CustNumber)
                         PROJECT(ORD:OrderDate)
                         PROJECT(ORD:OrderNumber)
                         JOIN(DTL:KeyOrderNumber,ORD:OrderNumber)
                           PROJECT(DTL:ProdAmount)
                           PROJECT(DTL:ProdNumber)
                           PROJECT(DTL:Quantity)
                           JOIN(PRD:KeyProdNumber,DTL:ProdNumber)
                             PROJECT(PRD:ProdDesc)
                           END
                         END
                       END
                     END
ProgressWindow       WINDOW('Invoice Progress'),AT(,,142,59),DOUBLE,CENTER,GRAY,TIMER(1)
                       PROGRESS,AT(15,15,111,12),USE(Progress:Thermometer),RANGE(0,100)
                       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
                       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
                       BUTTON('Cancel'),AT(45,42,50,15),USE(?Progress:Cancel)
                     END

Report               REPORT,AT(1000,2000,6000,7000),PRE(RPT),FONT('Arial',10,COLOR:Black,FONT:regular),THOUS
                       HEADER,AT(1000,1000,6000,1000)
                       END
CUS:CustNumberBreak    BREAK(CUS:CustNumber)
ORD:OrderNumberBreak     BREAK(ORD:OrderNumber)
                           HEADER,AT(0,0,,1067)
                             STRING(@s20),AT(100,25),USE(CUS:Company)
                             STRING('Order Number:'),AT(3604,42),USE(?String17),TRN
                             STRING(@n-7),AT(4531,52),USE(ORD:OrderNumber),RIGHT(1)
                             STRING(@s20),AT(1729,219),USE(CUS:LastName)
                             STRING(@s20),AT(100,225),USE(CUS:FirstName)
                             STRING(@d1),AT(4533,275),USE(ORD:OrderDate),RIGHT(1)
                             STRING('Order Date:'),AT(3600,225),USE(?String18),TRN
                             STRING(@P#####P),AT(1908,600),USE(CUS:ZipCode),RIGHT(1)
                             STRING('Item Total'),AT(4469,792),USE(?String22),TRN
                             LINE,AT(125,958,4958,10),USE(?Line1),COLOR(COLOR:Black),LINEWIDTH(50)
                             STRING('Quantity'),AT(104,792),USE(?String19),TRN
                             STRING('Product'),AT(844,792),USE(?String20),TRN
                             STRING('At:'),AT(3740,792),USE(?String21),TRN
                             STRING(@s20),AT(100,417),USE(CUS:Address)
                             STRING(@s20),AT(100,600),USE(CUS:City)
                             STRING(@s2),AT(1692,600),USE(CUS:State)
                           END
detail                     DETAIL
                             STRING(@n-7),AT(83,42),USE(DTL:Quantity),RIGHT(1)
                             STRING(@n-7),AT(771,42),USE(DTL:ProdNumber),RIGHT(1)
                             STRING(@s25),AT(1438,42),USE(PRD:ProdDesc)
                             STRING(@n-7.2),AT(3542,42),USE(DTL:ProdAmount),DECIMAL(12)
                             STRING(@n-10.2),AT(4208,42),USE(ItemTotal),DECIMAL(12)
                           END
                           FOOTER,AT(0,0),PAGEAFTER(-1)
                             LINE,AT(3758,50,1469,-10),USE(?Line2),COLOR(COLOR:Black),LINEWIDTH(20)
                             STRING(@n9.2),AT(4508,58),USE(ItemTotal,,?ItemTotal:2),SUM,RESET(ORD:OrderNumberBreak),TRN
                             STRING('Order Total:'),AT(3758,58),USE(?String23),TRN
                           END
                         END
                         FOOTER,AT(0,0),PAGEAFTER(-1)
                           STRING('Invoice Summary for:'),AT(1533,75),USE(?String25),TRN
                           STRING(@s20),AT(2958,58),USE(CUS:Company,,?CUS:Company:2)
                           STRING(@n-10.2),AT(2958,283),USE(ItemTotal,,?ItemTotal:3),SUM,RESET(CUS:CustNumberBreak),TRN
                           STRING(@n3),AT(2483,283),USE(InvoiceCount),CNT,TALLY(ORD:OrderNumberBreak),RESET(CUS:CustNumberBreak), |
  TRN
                           STRING('Total Orders:'),AT(1675,283),USE(?String26),TRN
                         END
                       END
                       FOOTER,AT(1000,9000,6000,1000)
                       END
                       FORM,AT(1000,1000,6000,9000)
                         STRING('Invoice'),AT(2396,125),USE(?String1),FONT('Times New Roman',16,COLOR:Black,FONT:bold), |
  TRN
                         STRING('TopSpeed Corporation'),AT(2000,604),USE(?String2),FONT('Times New Roman',14,COLOR:Black, |
  FONT:bold),TRN
                       END
                     END
ThisWindow           CLASS(ReportManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED       ! Method added to host embed code
Kill                   PROCEDURE(),BYTE,PROC,DERIVED       ! Method added to host embed code
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
  GlobalErrors.SetProcedureName('InvoiceReport')
    asdf asdf
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
    asdf asdf
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
  INIMgr.Fetch('InvoiceReport',ProgressWindow)             ! Restore window settings from non-volatile store
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  ProgressMgr.Init(ScrollSort:AllowNumeric,)
  ThisReport.Init(Process:View, Relate:Customer, ?Progress:PctText, Progress:Thermometer, ProgressMgr, CUS:CustNumber)
  ThisReport.AddSortOrder(CUS:KeyCustNumber)
  ThisReport.SetFilter('ORD:OrderNumber <<> 0')
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
    INIMgr.Update('InvoiceReport',ProgressWindow)          ! Save window data to non-volatile store
  END
  ProgressMgr.Kill()
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisReport.TakeRecord PROCEDURE

ReturnValue          BYTE,AUTO

SkipDetails BYTE
  CODE
  ItemTotal = DTL:Quantity * DTL:ProdAmount
  ReturnValue = PARENT.TakeRecord()
  PRINT(RPT:detail)
  RETURN ReturnValue

