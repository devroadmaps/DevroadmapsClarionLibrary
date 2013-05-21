!================================================================================
! Updates.ViewOrders
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\testdata\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\testoutput\Updates.ViewOrders.clw
!
! This file may also be included in a combined source file called
! Updates._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Updates.ViewOrders will have a more complete history than
! Updates.allprocedures.clw provided the original extracted procedure
! file was renamed in the version control system)
!================================================================================
! Start of original module header
!================================================================================
!
!
!   MEMBER('Updates.clw')                                   ! This is a MEMBER module
!
!
!   INCLUDE('ABBROWSE.INC'),ONCE
!   INCLUDE('ABEIP.INC'),ONCE
!   INCLUDE('ABPOPUP.INC'),ONCE
!   INCLUDE('ABREPORT.INC'),ONCE
!   INCLUDE('ABRESIZE.INC'),ONCE
!   INCLUDE('ABTOOLBA.INC'),ONCE
!   INCLUDE('ABWINDOW.INC'),ONCE
!
!                     MAP
!                       INCLUDE('UPDATES001.INC'),ONCE        !Local module procedure declarations
!                     END
!
!
!!!! <summary>
!!!! Generated from procedure template - Window
!!!! </summary>
!================================================================================
! End of original module header
!================================================================================
ViewOrders PROCEDURE

FilesOpened          BYTE                                  !
BRW1::View:Browse    VIEW(Orders)
                       PROJECT(ORD:CustNumber)
                       PROJECT(ORD:OrderNumber)
                       PROJECT(ORD:InvoiceAmount)
                       PROJECT(ORD:OrderDate)
                       PROJECT(ORD:OrderNote)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
ORD:CustNumber         LIKE(ORD:CustNumber)           !List box control field - type derived from field
ORD:OrderNumber        LIKE(ORD:OrderNumber)          !List box control field - type derived from field
ORD:InvoiceAmount      LIKE(ORD:InvoiceAmount)        !List box control field - type derived from field
ORD:OrderDate          LIKE(ORD:OrderDate)            !List box control field - type derived from field
ORD:OrderNote          LIKE(ORD:OrderNote)            !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BRW3::View:Browse    VIEW(Detail)
                       PROJECT(DTL:OrderNumber)
                       PROJECT(DTL:ProdNumber)
                       PROJECT(DTL:Quantity)
                       PROJECT(DTL:ProdAmount)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?List:2
DTL:OrderNumber        LIKE(DTL:OrderNumber)          !List box control field - type derived from field
DTL:ProdNumber         LIKE(DTL:ProdNumber)           !List box control field - type derived from field
DTL:Quantity           LIKE(DTL:Quantity)             !List box control field - type derived from field
DTL:ProdAmount         LIKE(DTL:ProdAmount)           !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
window               WINDOW('Orders'),AT(,,231,148),RESIZE,GRAY,MAX,MDI,SYSTEM,IMM
                       LIST,AT(4,5,221,56),USE(?List),FONT('Times New Roman',8,COLOR:Black,FONT:regular),HVSCROLL, |
  FORMAT('45C(2)~Cust Number~L(0)@n4@47C(1)~Order Number~L(0)@n-7@52D(12)~Invoice Amoun' & |
  't~L(0)@n-10.2@40C(1)~Order Date~L(0)@d1@320L(5)~Order Note~L(0)@s80@'),FROM(Queue:Browse), |
  IMM,MSG('Browsing Records')
                       BUTTON('&Insert'),AT(4,65,42,12),USE(?Insert)
                       BUTTON('&Change'),AT(46,65,42,12),USE(?Change)
                       BUTTON('&Delete'),AT(88,65,42,12),USE(?Delete)
                       BUTTON('Print Invoice'),AT(135,65,42,12),USE(?PrintInvoice)
                       LIST,AT(4,80,178,65),USE(?List:2),FONT('Times New Roman',8,COLOR:Black,FONT:regular),HVSCROLL, |
  FORMAT('47R(1)~Order Number~L(0)@n-7@44R(1)~Prod Number~L(0)@n-7@34R(1)~Quantity~L(0)' & |
  '@n-7@46D(12)~Prod Amount~L(0)@n-7.2@'),FROM(Queue:Browse:1),IMM,MSG('Browsing Records')
                       BUTTON('Close'),AT(196,131),USE(?Close)
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW3                 CLASS(BrowseClass)                    ! Browse using ?List:2
Q                      &Queue:Browse:1                !Reference to browse queue
                     END

BRW3::Sort0:Locator  StepLocatorClass                      ! Default Locator
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END


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
  GlobalErrors.SetProcedureName('ViewOrders')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?List
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:Detail.SetOpenRelated()
  Relate:Detail.Open                                       ! File Detail used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?List,Queue:Browse.ViewPosition,BRW1::View:Browse,Queue:Browse,Relate:Orders,SELF) ! Initialize the browse manager
  BRW3.Init(?List:2,Queue:Browse:1.ViewPosition,BRW3::View:Browse,Queue:Browse:1,Relate:Detail,SELF) ! Initialize the browse manager
  SELF.Open(window)                                        ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse
  BRW1.AddSortOrder(,ORD:KeyOrderNumber)                   ! Add the sort order for ORD:KeyOrderNumber for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,ORD:OrderNumber,1,BRW1)        ! Initialize the browse locator using  using key: ORD:KeyOrderNumber , ORD:OrderNumber
  BRW1.AddField(ORD:CustNumber,BRW1.Q.ORD:CustNumber)      ! Field ORD:CustNumber is a hot field or requires assignment from browse
  BRW1.AddField(ORD:OrderNumber,BRW1.Q.ORD:OrderNumber)    ! Field ORD:OrderNumber is a hot field or requires assignment from browse
  BRW1.AddField(ORD:InvoiceAmount,BRW1.Q.ORD:InvoiceAmount) ! Field ORD:InvoiceAmount is a hot field or requires assignment from browse
  BRW1.AddField(ORD:OrderDate,BRW1.Q.ORD:OrderDate)        ! Field ORD:OrderDate is a hot field or requires assignment from browse
  BRW1.AddField(ORD:OrderNote,BRW1.Q.ORD:OrderNote)        ! Field ORD:OrderNote is a hot field or requires assignment from browse
  BRW3.Q &= Queue:Browse:1
  BRW3.AddSortOrder(,DTL:KeyOrderNumber)                   ! Add the sort order for DTL:KeyOrderNumber for sort order 1
  BRW3.AddRange(DTL:OrderNumber,Relate:Detail,Relate:Orders) ! Add file relationship range limit for sort order 1
  BRW3.AddLocator(BRW3::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW3::Sort0:Locator.Init(,DTL:OrderNumber,1,BRW3)        ! Initialize the browse locator using  using key: DTL:KeyOrderNumber , DTL:OrderNumber
  BRW3.AddResetField(ORD:InvoiceAmount)                    ! Apply the reset field
  BRW3.AddField(DTL:OrderNumber,BRW3.Q.DTL:OrderNumber)    ! Field DTL:OrderNumber is a hot field or requires assignment from browse
  BRW3.AddField(DTL:ProdNumber,BRW3.Q.DTL:ProdNumber)      ! Field DTL:ProdNumber is a hot field or requires assignment from browse
  BRW3.AddField(DTL:Quantity,BRW3.Q.DTL:Quantity)          ! Field DTL:Quantity is a hot field or requires assignment from browse
  BRW3.AddField(DTL:ProdAmount,BRW3.Q.DTL:ProdAmount)      ! Field DTL:ProdAmount is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Spread,Resize:SetMinSize)       ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('ViewOrders',window)                        ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  BRW3.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
  brw1.popup.AddItemMimic('Print Invoice',?PrintInvoice)
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Detail.Close
  END
  IF SELF.Opened
    INIMgr.Update('ViewOrders',window)                     ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    UpdateOrder
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?PrintInvoice
      ThisWindow.Update
      SingleInvoiceReport()
      ThisWindow.Reset
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window
  SELF.SetStrategy(?Insert, Resize:LockXPos+Resize:FixBottom, Resize:LockSize) ! Override strategy for ?Insert
  SELF.SetStrategy(?Change, Resize:LockXPos+Resize:FixBottom, Resize:LockSize) ! Override strategy for ?Change
  SELF.SetStrategy(?Delete, Resize:LockXPos+Resize:FixBottom, Resize:LockSize) ! Override strategy for ?Delete
  SELF.SetStrategy(?List:2, Resize:LockXPos+Resize:FixBottom, Resize:LockSize) ! Override strategy for ?List:2
  SELF.SetStrategy(?List, Resize:LockXPos+Resize:LockYPos, Resize:LockWidth+Resize:ConstantBottom) ! Override strategy for ?List
  SELF.SetStrategy(?PrintInvoice, Resize:LockXPos+Resize:FixBottom, Resize:LockSize) ! Override strategy for ?PrintInvoice

!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
