!================================================================================
! Updates.ViewOrders
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\testdata\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\testoutput\Updates.UpdateCustomer.clw
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
UpdateCustomer PROCEDURE

FilesOpened          BYTE                                  !
ActionMessage        CSTRING(40)                           !
BRW6::View:Browse    VIEW(Phones)
                       PROJECT(PHO:CustNumber)
                       PROJECT(PHO:Area)
                       PROJECT(PHO:Phone)
                       PROJECT(PHO:Description)
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
PHO:CustNumber         LIKE(PHO:CustNumber)           !List box control field - type derived from field
PHO:Area               LIKE(PHO:Area)                 !List box control field - type derived from field
PHO:Phone              LIKE(PHO:Phone)                !List box control field - type derived from field
PHO:Description        LIKE(PHO:Description)          !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
History::CUS:Record  LIKE(CUS:RECORD),THREAD
FormWindow           WINDOW('Update Records...'),AT(18,5,309,173),FONT('Microsoft Sans Serif',10,,FONT:regular, |
  CHARSET:DEFAULT),RESIZE,GRAY,MAX,MDI,SYSTEM,IMM
                       PROMPT('&Cust Number:'),AT(10,4),USE(?CUS:CustNumber:Prompt)
                       STRING(@n4),AT(56,4),USE(CUS:CustNumber),RIGHT(1)
                       PROMPT('&Company:'),AT(10,24),USE(?CUS:Company:Prompt)
                       ENTRY(@s20),AT(56,20),USE(CUS:Company)
                       PROMPT('&First Name:'),AT(10,44),USE(?CUS:FirstName:Prompt)
                       ENTRY(@s20),AT(56,42),USE(CUS:FirstName)
                       PROMPT('&Last Name:'),AT(144,44),USE(?CUS:LastName:Prompt)
                       ENTRY(@s20),AT(188,42),USE(CUS:LastName)
                       PROMPT('&Address:'),AT(10,64),USE(?CUS:Address:Prompt)
                       ENTRY(@s20),AT(56,61),USE(CUS:Address)
                       PROMPT('&City:'),AT(10,82),USE(?CUS:City:Prompt)
                       ENTRY(@s20),AT(56,80),USE(CUS:City)
                       PROMPT('&State:'),AT(144,82),USE(?CUS:State:Prompt)
                       LIST,AT(167,78),USE(CUS:State),DROP(5),FROM('AL|MS|FL|GA|LA|SC')
                       PROMPT('&Zip Code:'),AT(238,82),USE(?CUS:ZipCode:Prompt)
                       ENTRY(@P#####P),AT(271,80),USE(CUS:ZipCode),RIGHT(1)
                       LIST,AT(10,96,272,43),USE(?List),FORMAT('16L(1)~Cust Number~L(0)@n4@20L(1)~Area~L(0)@P(' & |
  '###)P@32L(1)~Phone~L(0)@P###-####P@80L(1)~Description~L(0)@s20@'),FROM(Queue:Browse),IMM, |
  MSG('Browsing Records')
                       BUTTON('&Insert'),AT(10,144,42,12),USE(?Insert)
                       BUTTON('&Change'),AT(52,144,42,12),USE(?Change)
                       BUTTON('&Delete'),AT(94,144,42,12),USE(?Delete)
                       BUTTON('OK'),AT(10,160,40,12),USE(?OK),DEFAULT,REQ
                       BUTTON('Cancel'),AT(54,160,40,12),USE(?Cancel)
                       STRING(@S40),AT(100,160),USE(ActionMessage)
                     END

ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

BRW6                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW6::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW6::EIPManager     BrowseEIPManager                      ! Browse EIP Manager for Browse using ?List
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
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

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record will be Added'
  OF ChangeRecord
    ActionMessage = 'Record will be Changed'
  END
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateCustomer')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?CUS:CustNumber:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = 734
  SELF.AddHistoryFile(CUS:Record,History::CUS:Record)
  SELF.AddHistoryField(?CUS:CustNumber,1)
  SELF.AddHistoryField(?CUS:Company,2)
  SELF.AddHistoryField(?CUS:FirstName,3)
  SELF.AddHistoryField(?CUS:LastName,4)
  SELF.AddHistoryField(?CUS:Address,5)
  SELF.AddHistoryField(?CUS:City,6)
  SELF.AddHistoryField(?CUS:State,7)
  SELF.AddHistoryField(?CUS:ZipCode,8)
  SELF.AddUpdateFile(Access:Customer)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Customer.Open                                     ! File Customer used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Customer
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  BRW6.Init(?List,Queue:Browse.ViewPosition,BRW6::View:Browse,Queue:Browse,Relate:Phones,SELF) ! Initialize the browse manager
  SELF.Open(FormWindow)                                    ! Open window
  Do DefineListboxStyle
  Resizer.Init(AppStrategy:Spread)                         ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  BRW6.Q &= Queue:Browse
  BRW6.AddSortOrder(,PHO:KeyCustNumber)                    ! Add the sort order for PHO:KeyCustNumber for sort order 1
  BRW6.AddRange(PHO:CustNumber,Relate:Phones,Relate:Customer) ! Add file relationship range limit for sort order 1
  BRW6.AddLocator(BRW6::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW6::Sort0:Locator.Init(,PHO:CustNumber,1,BRW6)         ! Initialize the browse locator using  using key: PHO:KeyCustNumber , PHO:CustNumber
  BRW6.AddField(PHO:CustNumber,BRW6.Q.PHO:CustNumber)      ! Field PHO:CustNumber is a hot field or requires assignment from browse
  BRW6.AddField(PHO:Area,BRW6.Q.PHO:Area)                  ! Field PHO:Area is a hot field or requires assignment from browse
  BRW6.AddField(PHO:Phone,BRW6.Q.PHO:Phone)                ! Field PHO:Phone is a hot field or requires assignment from browse
  BRW6.AddField(PHO:Description,BRW6.Q.PHO:Description)    ! Field PHO:Description is a hot field or requires assignment from browse
  INIMgr.Fetch('UpdateCustomer',FormWindow)                ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  SELF.AddItem(ToolbarForm)
  BRW6.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
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
    INIMgr.Update('UpdateCustomer',FormWindow)             ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
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
    OF ?OK
      ThisWindow.Update
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window


BRW6.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  SELF.EIP &= BRW6::EIPManager                             ! Set the EIP manager
  SELF.DeleteAction = EIPAction:Always
  SELF.ArrowAction = EIPAction:Default+EIPAction:Remain+EIPAction:RetainColumn
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END

!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
