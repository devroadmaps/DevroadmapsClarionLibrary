!================================================================================
! Updates.ViewOrders
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\testdata\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\testoutput\Updates.UpdateOrder.clw
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
UpdateOrder PROCEDURE

FilesOpened          BYTE                                  !
ActionMessage        CSTRING(40)                           !
ItemTotal            DECIMAL(7,2)                          !
BRW5::View:Browse    VIEW(Detail)
                       PROJECT(DTL:ProdNumber)
                       PROJECT(DTL:Quantity)
                       PROJECT(DTL:ProdAmount)
                       PROJECT(DTL:OrderNumber)
                       JOIN(PRD:KeyProdNumber,DTL:ProdNumber)
                         PROJECT(PRD:ProdDesc)
                         PROJECT(PRD:ProdNumber)
                       END
                     END
Queue:Browse         QUEUE                            !Queue declaration for browse/combo box using ?List
DTL:ProdNumber         LIKE(DTL:ProdNumber)           !List box control field - type derived from field
DTL:Quantity           LIKE(DTL:Quantity)             !List box control field - type derived from field
DTL:ProdAmount         LIKE(DTL:ProdAmount)           !List box control field - type derived from field
ItemTotal              LIKE(ItemTotal)                !List box control field - type derived from local data
PRD:ProdDesc           LIKE(PRD:ProdDesc)             !List box control field - type derived from field
DTL:OrderNumber        LIKE(DTL:OrderNumber)          !Browse key field - type derived from field
PRD:ProdNumber         LIKE(PRD:ProdNumber)           !Related join file key field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
History::ORD:Record  LIKE(ORD:RECORD),THREAD
FormWindow           WINDOW('Order Form'),AT(18,5,289,171),CENTER,GRAY,MDI,SYSTEM
                       PROMPT('Order Date:'),AT(8,6),USE(?ORD:OrderDate:Prompt)
                       ENTRY(@d1),AT(55,4),USE(ORD:OrderDate),RIGHT(1)
                       PROMPT('Order Note:'),AT(91,5),USE(?ORD:OrderNote:Prompt)
                       ENTRY(@s80),AT(130,3),USE(ORD:OrderNote)
                       PROMPT('&Cust Number:'),AT(8,22),USE(?ORD:CustNumber:Prompt)
                       ENTRY(@n4),AT(55,20),USE(ORD:CustNumber),RIGHT(1)
                       STRING(@s20),AT(91,22),USE(CUS:Company)
                       LIST,AT(8,39,263,66),USE(?List),HVSCROLL,FORMAT('47R(1)~Prod Number~L(0)@n-7@37R(1)~Qua' & |
  'ntity~L(0)@n-7@47D(12)~Prod Amount~L(0)@n-7.2@43D(12)~Item Total~L(0)@n-10.2@100D(12' & |
  ')~Prod Desc~L(0)@s25@'),FROM(Queue:Browse),IMM,MSG('Browsing Records')
                       BUTTON('&Insert'),AT(9,109,42,12),USE(?Insert)
                       BUTTON('&Change'),AT(51,109,42,12),USE(?Change)
                       BUTTON('&Delete'),AT(93,109,42,12),USE(?Delete)
                       STRING(@n-10.2),AT(231,111),USE(ORD:InvoiceAmount)
                       BUTTON('OK'),AT(8,154,40,12),USE(?OK),DEFAULT,REQ
                       BUTTON('Cancel'),AT(53,154,40,12),USE(?Cancel)
                       STRING(@S40),AT(98,154),USE(ActionMessage)
                     END

LocalErrGroup   GROUP
                    USHORT(1)
                    USHORT(99)
                    BYTE(Level:Notify)
                    PSTRING('Save the Order!')
                    PSTRING('Some Item changed -- Press the OK button.')
                END
SaveTotal       LIKE(ORD:InvoiceAmount)
ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Reset                  PROCEDURE(BYTE Force=0),DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeSelected           PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
BRW5                 CLASS(BrowseClass)                    ! Browse using ?List
Q                      &Queue:Browse                  !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
ResetFromView          PROCEDURE(),DERIVED
SetQueueRecord         PROCEDURE(),DERIVED
                     END

BRW5::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW5::EIPManager     BrowseEIPManager                      ! Browse EIP Manager for Browse using ?List
EditInPlace::DTL:ProdNumber CLASS(EditEntryClass)          ! Edit-in-place class for field DTL:ProdNumber
TakeEvent              PROCEDURE(UNSIGNED Event),BYTE,DERIVED
                     END

EditInPlace::DTL:Quantity CLASS(EditEntryClass)            ! Edit-in-place class for field DTL:Quantity
Init                   PROCEDURE(UNSIGNED FieldNumber,UNSIGNED ListBox,*? UseVar),DERIVED
TakeEvent              PROCEDURE(UNSIGNED Event),BYTE,DERIVED
                     END

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
  GlobalErrors.SetProcedureName('UpdateOrder')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?ORD:OrderDate:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  BIND('ItemTotal',ItemTotal)                              ! Added by: BrowseBox(ABC)
    GlobalErrors.AddErrors(LocalErrGroup)           !Add custom error
    IF SELF.Request = ChangeRecord                  !If Changing a record
        SaveTotal = ORD:InvoiceAmount               !Save the original order total
    END
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = 734
  SELF.AddHistoryFile(ORD:Record,History::ORD:Record)
  SELF.AddHistoryField(?ORD:OrderDate,4)
  SELF.AddHistoryField(?ORD:OrderNote,5)
  SELF.AddHistoryField(?ORD:CustNumber,1)
  SELF.AddHistoryField(?ORD:InvoiceAmount,3)
  SELF.AddUpdateFile(Access:Orders)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Customer.SetOpenRelated()
  Relate:Customer.Open                                     ! File Customer used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Orders
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
  BRW5.Init(?List,Queue:Browse.ViewPosition,BRW5::View:Browse,Queue:Browse,Relate:Detail,SELF) ! Initialize the browse manager
  SELF.Open(FormWindow)                                    ! Open window
  Do DefineListboxStyle
  BRW5.Q &= Queue:Browse
  BRW5.AddSortOrder(,DTL:KeyOrderNumber)                   ! Add the sort order for DTL:KeyOrderNumber for sort order 1
  BRW5.AddRange(DTL:OrderNumber,Relate:Detail,Relate:Orders) ! Add file relationship range limit for sort order 1
  BRW5.AddLocator(BRW5::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW5::Sort0:Locator.Init(,DTL:OrderNumber,1,BRW5)        ! Initialize the browse locator using  using key: DTL:KeyOrderNumber , DTL:OrderNumber
  BRW5.AddField(DTL:ProdNumber,BRW5.Q.DTL:ProdNumber)      ! Field DTL:ProdNumber is a hot field or requires assignment from browse
  BRW5.AddField(DTL:Quantity,BRW5.Q.DTL:Quantity)          ! Field DTL:Quantity is a hot field or requires assignment from browse
  BRW5.AddField(DTL:ProdAmount,BRW5.Q.DTL:ProdAmount)      ! Field DTL:ProdAmount is a hot field or requires assignment from browse
  BRW5.AddField(ItemTotal,BRW5.Q.ItemTotal)                ! Field ItemTotal is a hot field or requires assignment from browse
  BRW5.AddField(PRD:ProdDesc,BRW5.Q.PRD:ProdDesc)          ! Field PRD:ProdDesc is a hot field or requires assignment from browse
  BRW5.AddField(DTL:OrderNumber,BRW5.Q.DTL:OrderNumber)    ! Field DTL:OrderNumber is a hot field or requires assignment from browse
  BRW5.AddField(PRD:ProdNumber,BRW5.Q.PRD:ProdNumber)      ! Field PRD:ProdNumber is a hot field or requires assignment from browse
  INIMgr.Fetch('UpdateOrder',FormWindow)                   ! Restore window settings from non-volatile store
  SELF.AddItem(ToolbarForm)
  BRW5.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    GlobalErrors.RemoveErrors(LocalErrGroup)            !Remove custom error
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Customer.Close
  END
  IF SELF.Opened
    INIMgr.Update('UpdateOrder',FormWindow)                ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Reset PROCEDURE(BYTE Force=0)

  CODE
  SELF.ForcedReset += Force
  IF FormWindow{Prop:AcceptAll} THEN RETURN.
  CUS:CustNumber = ORD:CustNumber                          ! Assign linking field value
  Access:Customer.Fetch(CUS:KeyCustNumber)
  PARENT.Reset(Force)


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    ViewCustomers
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
    OF ?ORD:CustNumber
      CUS:CustNumber = ORD:CustNumber
      IF Access:Customer.TryFetch(CUS:KeyCustNumber)
        IF SELF.Run(1,SelectRecord) = RequestCompleted
          ORD:CustNumber = CUS:CustNumber
        ELSE
          SELECT(?ORD:CustNumber)
          CYCLE
        END
      END
      ThisWindow.Reset(1)
      IF Access:Orders.TryValidateField(1)                 ! Attempt to validate ORD:CustNumber in Orders
        SELECT(?ORD:CustNumber)
        FormWindow{PROP:AcceptAll} = False
        CYCLE
      ELSE
        FieldColorQueue.Feq = ?ORD:CustNumber
        GET(FieldColorQueue, FieldColorQueue.Feq)
        IF ERRORCODE() = 0
          ?ORD:CustNumber{PROP:FontColor} = FieldColorQueue.OldColor
          DELETE(FieldColorQueue)
        END
      END
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


ThisWindow.TakeSelected PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all Selected events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE FIELD()
    OF ?ORD:CustNumber
      ?ORD:CustNumber{PROP:Touched} = TRUE
    END
  ReturnValue = PARENT.TakeSelected()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE EVENT()
    OF EVENT:CloseWindow
      IF SELF.Request = ChangeRecord                  AND |   !If Changing a record
       SELF.Response <> RequestCompleted               AND |   ! and OK button not pressed
       SaveTotal <> ORD:InvoiceAmount                         ! and detail recs changed
      GlobalErrors.Throw(99)                                  !Display custom error
      SELECT(?OK)                                             ! then select the OK button
      CYCLE
      END
    END
  ReturnValue = PARENT.TakeWindowEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


BRW5.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  SELF.EIP &= BRW5::EIPManager                             ! Set the EIP manager
  SELF.AddEditControl(EditInPlace::DTL:ProdNumber,1)
  SELF.AddEditControl(EditInPlace::DTL:Quantity,2)
  SELF.AddEditControl(,3) ! DTL:ProdAmount Disable
  SELF.AddEditControl(,4)
  SELF.AddEditControl(,5)
  SELF.DeleteAction = EIPAction:Always
  SELF.ArrowAction = EIPAction:Default+EIPAction:Remain+EIPAction:RetainColumn
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert
    SELF.ChangeControl=?Change
    SELF.DeleteControl=?Delete
  END


BRW5.ResetFromView PROCEDURE

ORD:InvoiceAmount:Sum REAL                                 ! Sum variable for browse totals
  CODE
  SETCURSOR(Cursor:Wait)
  Relate:Detail.SetQuickScan(1)
  SELF.Reset
  IF SELF.UseMRP
     IF SELF.View{PROP:IPRequestCount} = 0
          SELF.View{PROP:IPRequestCount} = 60
     END
  END
  LOOP
    IF SELF.UseMRP
       IF SELF.View{PROP:IPRequestCount} = 0
            SELF.View{PROP:IPRequestCount} = 60
       END
    END
    CASE SELF.Next()
    OF Level:Notify
      BREAK
    OF Level:Fatal
      SETCURSOR()
      RETURN
    END
    SELF.SetQueueRecord
    ORD:InvoiceAmount:Sum += ItemTotal
  END
  SELF.View{PROP:IPRequestCount} = 0
  ORD:InvoiceAmount = ORD:InvoiceAmount:Sum
  PARENT.ResetFromView
  Relate:Detail.SetQuickScan(0)
  SETCURSOR()


BRW5.SetQueueRecord PROCEDURE

  CODE
  ItemTotal = DTL:Quantity * DTL:ProdAmount
  PARENT.SetQueueRecord

  SELF.Q.ItemTotal = ItemTotal                             !Assign formula result to display queue


EditInPlace::DTL:ProdNumber.TakeEvent PROCEDURE(UNSIGNED Event)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.TakeEvent(Event)
  UPDATE(SELF.Feq)                                              !Update Q field
  IF (ReturnValue AND ReturnValue <> EditAction:Cancel) OR |
     EVENT() = EVENT:Accepted
                                                                !Parent return an action?
    PRD:ProdNumber = BRW5.Q.DTL:ProdNumber                      !Set for lookup
    IF Access:Products.Fetch(PRD:KeyProdNumber)                 !Lookup Products rec
        GlobalRequest = SelectRecord                            !If no rec, set for select
        ViewProducts                                            ! then call Lookup proc
        IF GlobalResponse <> RequestCompleted                   !Rec selected?
            CLEAR(PRD:Record)                                   ! if not, clear the buffer
            ReturnValue = EditAction:None                       ! and set the action to
        END                                                     ! stay on same entry field
     END
     BRW5.Q.DTL:ProdNumber = PRD:ProdNumber                     !Assign Products file
     BRW5.Q.DTL:ProdAmount = PRD:ProdAmount                     ! values to Browse QUEUE
     BRW5.Q.PRD:ProdDesc = PRD:ProdDesc                         ! fields
     DISPLAY                                                    ! and display them
   END

  RETURN ReturnValue


EditInPlace::DTL:Quantity.Init PROCEDURE(UNSIGNED FieldNumber,UNSIGNED ListBox,*? UseVar)

!  SELF.Feq = CREATE(0,CREATE:Spin)                     !Create a SPIN control
!  ASSERT(~ERRORCODE())                                 !Assumes no errors
!  SELF.Feq{PROP:Text} = ListBox{PROPLIST:Picture,FieldNumber}
!                                                       !Set entry picture token
!  SELF.Feq{PROP:Use} = UseVar                          !Set USE to passed *? parameter
!  SELF.Feq{PROP:Alrt,1} = TabKey                       !Alert standard field navigation
!  SELF.Feq{PROP:Alrt,2} = ShiftTab                     ! keys for TakeEvent to handle
!  SELF.Feq{PROP:Alrt,3} = EnterKey
!  SELF.Feq{PROP:Alrt,4} = EscKey
!  SELF.Feq{PROP:RangeLow} = 1                          !Set RANGE values for the SPIN
!  SELF.Feq{PROP:RangeHigh} = 9999
!  RETURN                                                !Return before Parent method call
  CODE
  SELF.Feq = CREATE(0,CREATE:Spin)                     !Create a SPIN control
  ASSERT(~ERRORCODE())                                 !Assumes no errors
  SELF.Feq{PROP:Text} = ListBox{PROPLIST:Picture,FieldNumber}
                                                       !Set entry picture token
  SELF.Feq{PROP:Use} = UseVar                          !Set USE to passed *? parameter
  SELF.Feq{PROP:Alrt,1} = TabKey                       !Alert standard field navigation
  SELF.Feq{PROP:Alrt,2} = ShiftTab                     ! keys for TakeEvent to handle
  SELF.Feq{PROP:Alrt,3} = EnterKey
  SELF.Feq{PROP:Alrt,4} = EscKey
  SELF.Feq{PROP:RangeLow} = 1                          !Set RANGE values for the SPIN
  SELF.Feq{PROP:RangeHigh} = 9999
  RETURN                                                !Return before Parent method call
  PARENT.Init(FieldNumber,ListBox,UseVar)


EditInPlace::DTL:Quantity.TakeEvent PROCEDURE(UNSIGNED Event)

ReturnValue          BYTE,AUTO

  CODE
  CASE Event                                            !Evaluate passed in event
  OF EVENT:AlertKey                                     ! and handle only AlertKey events
    CASE KEYCODE()
    OF EnterKey                                         !On Enter
        RETURN(EditAction:Complete)                     ! set action complete
    OF EscKey                                           !On Escape
        RETURN(EditAction:Cancel)                       ! set action cancelled
    OF TabKey                                           !On Tab
        RETURN(EditAction:Forward)                      ! set action forward
    OF ShiftTab                                         !On Shift+Tab
        RETURN(EditAction:Backward)                     ! set action backward
    END
  END
  RETURN(EditAction:None)                               !No action for everything else
  ReturnValue = PARENT.TakeEvent(Event)
  RETURN ReturnValue

!!! <summary>
!!! Generated from procedure template - Report
!!! </summary>
