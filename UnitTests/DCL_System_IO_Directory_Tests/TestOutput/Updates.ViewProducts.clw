!================================================================================
! Updates.ViewOrders
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\testdata\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\testoutput\Updates.ViewProducts.clw
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
ViewProducts PROCEDURE

FilesOpened          BYTE                                  !
BRW1::View:Browse    VIEW(Products)
                       PROJECT(PRD:ProdNumber)
                       PROJECT(PRD:ProdDesc)
                       PROJECT(PRD:ProdAmount)
                       PROJECT(PRD:TaxRate)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
PRD:ProdNumber         LIKE(PRD:ProdNumber)           !List box control field - type derived from field
PRD:ProdDesc           LIKE(PRD:ProdDesc)             !List box control field - type derived from field
PRD:ProdAmount         LIKE(PRD:ProdAmount)           !List box control field - type derived from field
PRD:TaxRate            LIKE(PRD:TaxRate)              !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BrowseWindow         WINDOW('Browse Products'),AT(0,0,247,155),RESIZE,GRAY,MAX,MDI,SYSTEM,IMM
                       PROMPT('Prod Desc:'),AT(5,5),USE(?PRD:ProdDesc:Prompt)
                       ENTRY(@s25),AT(55,3),USE(PRD:ProdDesc)
                       LIST,AT(5,20,235,120),USE(?List),HVSCROLL,FORMAT('48L(1)|M~Prod Number~@n-7@100L(1)|M~P' & |
  'rod Desc~@s25@45D(12)|M~Prod Amount~L(1)@n-7.2@16D(12)|M~Tax Rate~L(1)@n-4.2@'),FROM(Queue:Browse), |
  IMM,MSG('Browsing Records')
                       BUTTON('&Insert'),AT(9,95,40,12),USE(?Insert),KEY(InsertKey),HIDE
                       BUTTON('&Change'),AT(54,95,40,12),USE(?Change),KEY(CtrlEnter),DEFAULT,HIDE
                       BUTTON('&Delete'),AT(99,95,40,12),USE(?Delete),KEY(DeleteKey),HIDE
                       BUTTON('&Select'),AT(149,95,40,12),USE(?Select),KEY(EnterKey),HIDE
                       BUTTON('Close'),AT(200,95,40,12),USE(?Close),HIDE
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW1::Sort0:Locator  EntryLocatorClass                     ! Default Locator
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
  GlobalErrors.SetProcedureName('ViewProducts')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?PRD:ProdDesc:Prompt
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
  Relate:Products.Open                                     ! File Products used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?List,Queue:Browse.ViewPosition,BRW1::View:Browse,Queue:Browse,Relate:Products,SELF) ! Initialize the browse manager
  SELF.Open(BrowseWindow)                                  ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse
  BRW1.AddSortOrder(,PRD:KeyProdDesc)                      ! Add the sort order for PRD:KeyProdDesc for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(?PRD:ProdDesc,PRD:ProdDesc,1,BRW1) ! Initialize the browse locator using ?PRD:ProdDesc using key: PRD:KeyProdDesc , PRD:ProdDesc
  BRW1.AddField(PRD:ProdNumber,BRW1.Q.PRD:ProdNumber)      ! Field PRD:ProdNumber is a hot field or requires assignment from browse
  BRW1.AddField(PRD:ProdDesc,BRW1.Q.PRD:ProdDesc)          ! Field PRD:ProdDesc is a hot field or requires assignment from browse
  BRW1.AddField(PRD:ProdAmount,BRW1.Q.PRD:ProdAmount)      ! Field PRD:ProdAmount is a hot field or requires assignment from browse
  BRW1.AddField(PRD:TaxRate,BRW1.Q.PRD:TaxRate)            ! Field PRD:TaxRate is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('ViewProducts',BrowseWindow)                ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Products.Close
  END
  IF SELF.Opened
    INIMgr.Update('ViewProducts',BrowseWindow)             ! Save window data to non-volatile store
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
    UpdateProduct
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  SELF.SelectControl = ?Select
  SELF.HideSelect = 1                                      ! Hide the select button when disabled
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

!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
