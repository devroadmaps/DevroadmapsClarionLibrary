!================================================================================
! Updates.ViewOrders
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\testdata\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\testoutput\Updates.UpdateProduct.clw
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
UpdateProduct PROCEDURE

FilesOpened          BYTE                                  !
ActionMessage        CSTRING(40)                           !
History::PRD:Record  LIKE(PRD:RECORD),THREAD
FormWindow           WINDOW('Product Form'),AT(18,5,289,159),CENTER,GRAY,MDI,SYSTEM
                       PROMPT('Prod Number:'),AT(5,5),USE(?PRD:ProdNumber:Prompt)
                       ENTRY(@n-7),AT(55,3),USE(PRD:ProdNumber),RIGHT(1)
                       PROMPT('Prod Desc:'),AT(5,21),USE(?PRD:ProdDesc:Prompt)
                       ENTRY(@s25),AT(55,19),USE(PRD:ProdDesc)
                       PROMPT('Prod Amount:'),AT(5,37),USE(?PRD:ProdAmount:Prompt)
                       ENTRY(@n-7.2),AT(55,35),USE(PRD:ProdAmount),DECIMAL(12)
                       PROMPT('Tax Rate:'),AT(5,53),USE(?PRD:TaxRate:Prompt)
                       ENTRY(@n-4.2),AT(55,51),USE(PRD:TaxRate),DECIMAL(12)
                       BUTTON('OK'),AT(5,140,40,12),USE(?OK),DEFAULT,REQ
                       BUTTON('Cancel'),AT(50,140,40,12),USE(?Cancel)
                       STRING(@S40),AT(95,140),USE(ActionMessage)
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
  GlobalErrors.SetProcedureName('UpdateProduct')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?PRD:ProdNumber:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.HistoryKey = 734
  SELF.AddHistoryFile(PRD:Record,History::PRD:Record)
  SELF.AddHistoryField(?PRD:ProdNumber,1)
  SELF.AddHistoryField(?PRD:ProdDesc,2)
  SELF.AddHistoryField(?PRD:ProdAmount,3)
  SELF.AddHistoryField(?PRD:TaxRate,4)
  SELF.AddUpdateFile(Access:Products)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Products.Open                                     ! File Products used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Products
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
  SELF.Open(FormWindow)                                    ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('UpdateProduct',FormWindow)                 ! Restore window settings from non-volatile store
  SELF.AddItem(ToolbarForm)
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
    INIMgr.Update('UpdateProduct',FormWindow)              ! Save window data to non-volatile store
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

!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
