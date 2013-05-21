!================================================================================
! Updates.ViewOrders
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\testdata\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\testoutput\Updates.ViewCustomers.clw
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
ViewCustomers PROCEDURE

FilesOpened          BYTE                                  !
BRW1::View:Browse    VIEW(Customer)
                       PROJECT(CUS:Company)
                       PROJECT(CUS:FirstName)
                       PROJECT(CUS:LastName)
                       PROJECT(CUS:Address)
                       PROJECT(CUS:City)
                       PROJECT(CUS:State)
                       PROJECT(CUS:ZipCode)
                       PROJECT(CUS:CustNumber)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
CUS:Company            LIKE(CUS:Company)              !List box control field - type derived from field
CUS:FirstName          LIKE(CUS:FirstName)            !List box control field - type derived from field
CUS:LastName           LIKE(CUS:LastName)             !List box control field - type derived from field
CUS:Address            LIKE(CUS:Address)              !List box control field - type derived from field
CUS:City               LIKE(CUS:City)                 !List box control field - type derived from field
CUS:State              LIKE(CUS:State)                !List box control field - type derived from field
CUS:ZipCode            LIKE(CUS:ZipCode)              !List box control field - type derived from field
CUS:CustNumber         LIKE(CUS:CustNumber)           !Browse key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
BrowseWindow         WINDOW('Browse Customers'),AT(0,0,317,179),FONT('Microsoft Sans Serif',10,,,CHARSET:DEFAULT), |
  RESIZE,GRAY,MAX,MDI,SYSTEM,IMM
                       SHEET,AT(1,6,315,145),USE(?Sheet1)
                         TAB('KeyCustNumber'),USE(?Tab1)
                         END
                         TAB('KeyCompany'),USE(?Tab2)
                         END
                         TAB('KeyZipCode'),USE(?Tab3)
                         END
                       END
                       LIST,AT(5,20,308,120),USE(?List),HVSCROLL,FORMAT('80L|M~Company~L(1)@s20@64L|~First Nam' & |
  'e~L(1)@s20@58L|M~Last Name~L(1)@s20@[80L|M~Address~L(1)@s20@80L|M~City~L(1)@s20@8L|M' & |
  '~State~L(1)@s2@20R(1)|M~Zip Code~L@P#####P@]|M~Address Info~'),FROM(Queue:Browse),IMM,MSG('Browsing Records')
                       BUTTON('&Insert'),AT(9,95,40,12),USE(?Insert),KEY(InsertKey),HIDE
                       BUTTON('&Change'),AT(54,95,40,12),USE(?Change),KEY(CtrlEnter),DEFAULT,HIDE
                       BUTTON('&Delete'),AT(99,95,40,12),USE(?Delete),KEY(DeleteKey),HIDE
                       BUTTON('&Select'),AT(149,95,40,12),USE(?Select),KEY(EnterKey),HIDE
                       BUTTON('Close'),AT(200,95,40,12),USE(?Close),HIDE
                       BUTTON('Customer Report'),AT(9,160),USE(?BUTTON1)
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
ResetSort              PROCEDURE(BYTE Force),BYTE,PROC,DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW1::Sort1:Locator  StepLocatorClass                      ! Conditional Locator - CHOICE(?Sheet1) = 2
BRW1::Sort2:Locator  StepLocatorClass                      ! Conditional Locator - CHOICE(?Sheet1) = 3
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
  GlobalErrors.SetProcedureName('ViewCustomers')
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
  Relate:Customer.Open                                     ! File Customer used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?List,Queue:Browse.ViewPosition,BRW1::View:Browse,Queue:Browse,Relate:Customer,SELF) ! Initialize the browse manager
  SELF.Open(BrowseWindow)                                  ! Open window
  Do DefineListboxStyle
  BRW1.Q &= Queue:Browse
  BRW1.AddSortOrder(,CUS:KeyCompany)                       ! Add the sort order for CUS:KeyCompany for sort order 1
  BRW1.AddLocator(BRW1::Sort1:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort1:Locator.Init(,CUS:Company,1,BRW1)            ! Initialize the browse locator using  using key: CUS:KeyCompany , CUS:Company
  BRW1.AddSortOrder(,CUS:KeyZipCode)                       ! Add the sort order for CUS:KeyZipCode for sort order 2
  BRW1.AddLocator(BRW1::Sort2:Locator)                     ! Browse has a locator for sort order 2
  BRW1::Sort2:Locator.Init(,CUS:ZipCode,1,BRW1)            ! Initialize the browse locator using  using key: CUS:KeyZipCode , CUS:ZipCode
  BRW1.AddSortOrder(,CUS:KeyCustNumber)                    ! Add the sort order for CUS:KeyCustNumber for sort order 3
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 3
  BRW1::Sort0:Locator.Init(,CUS:CustNumber,1,BRW1)         ! Initialize the browse locator using  using key: CUS:KeyCustNumber , CUS:CustNumber
  BRW1.AddField(CUS:Company,BRW1.Q.CUS:Company)            ! Field CUS:Company is a hot field or requires assignment from browse
  BRW1.AddField(CUS:FirstName,BRW1.Q.CUS:FirstName)        ! Field CUS:FirstName is a hot field or requires assignment from browse
  BRW1.AddField(CUS:LastName,BRW1.Q.CUS:LastName)          ! Field CUS:LastName is a hot field or requires assignment from browse
  BRW1.AddField(CUS:Address,BRW1.Q.CUS:Address)            ! Field CUS:Address is a hot field or requires assignment from browse
  BRW1.AddField(CUS:City,BRW1.Q.CUS:City)                  ! Field CUS:City is a hot field or requires assignment from browse
  BRW1.AddField(CUS:State,BRW1.Q.CUS:State)                ! Field CUS:State is a hot field or requires assignment from browse
  BRW1.AddField(CUS:ZipCode,BRW1.Q.CUS:ZipCode)            ! Field CUS:ZipCode is a hot field or requires assignment from browse
  BRW1.AddField(CUS:CustNumber,BRW1.Q.CUS:CustNumber)      ! Field CUS:CustNumber is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('ViewCustomers',BrowseWindow)               ! Restore window settings from non-volatile store
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
    Relate:Customer.Close
  END
  IF SELF.Opened
    INIMgr.Update('ViewCustomers',BrowseWindow)            ! Save window data to non-volatile store
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
    UpdateCustomer
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
    OF ?BUTTON1
      ThisWindow.Update
      CustReport()
      ThisWindow.Reset
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
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


BRW1.ResetSort PROCEDURE(BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  IF CHOICE(?Sheet1) = 2
    RETURN SELF.SetSort(1,Force)
  ELSIF CHOICE(?Sheet1) = 3
    RETURN SELF.SetSort(2,Force)
  ELSE
    RETURN SELF.SetSort(3,Force)
  END
  ReturnValue = PARENT.ResetSort(Force)
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
