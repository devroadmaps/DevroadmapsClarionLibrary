   PROGRAM



   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE

   MAP
    MODULE('REPORTS.DLL')
CustReport             PROCEDURE,DLL                       ! 
    END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('UPDATES001.CLW')
ViewCustomers          PROCEDURE   !
ViewOrders             PROCEDURE   !
ViewProducts           PROCEDURE   !
     END
    ! Declare functions defined in this DLL
Updates:Init           PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
Updates:Kill           PROCEDURE
    ! Declare init functions defined in a different dll
     MODULE('ALLFILES.DLL')
allfiles:Init          PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>),DLL
allfiles:Kill          PROCEDURE,DLL
     END
     MODULE('REPORTS.DLL')
Reports:Init           PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>),DLL
Reports:Kill           PROCEDURE,DLL
     END
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
Customer             FILE,DRIVER('TOPSPEED'),PRE(CUS),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode) !                    
KeyCustNumber            KEY(CUS:CustNumber),NOCASE,OPT    !                    
KeyCompany               KEY(CUS:Company),DUP,NOCASE       !                    
KeyZipCode               KEY(CUS:ZipCode),DUP,NOCASE       !                    
Record                   RECORD,PRE()
CustNumber                  LONG                           !                    
Company                     STRING(20)                     !                    
FirstName                   STRING(20)                     !                    
LastName                    STRING(20)                     !                    
Address                     STRING(20)                     !                    
City                        STRING(20)                     !                    
State                       STRING(2)                      !                    
ZipCode                     LONG                           !                    
                         END
                     END                       

Orders               FILE,DRIVER('TOPSPEED'),PRE(ORD),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode) !Order header file   
KeyOrderNumber           KEY(ORD:OrderNumber),NOCASE,OPT,PRIMARY !                    
KeyCustNumber            KEY(ORD:CustNumber),DUP,NOCASE,OPT !                    
Record                   RECORD,PRE()
CustNumber                  LONG                           !                    
OrderNumber                 SHORT                          !                    
InvoiceAmount               DECIMAL(7,2)                   !                    
OrderDate                   LONG                           !                    
OrderNote                   STRING(80)                     !                    
                         END
                     END                       

Detail               FILE,DRIVER('TOPSPEED'),PRE(DTL),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode) !Order detail file   
KeyProdNumber            KEY(DTL:ProdNumber),DUP,NOCASE,OPT !                    
KeyOrderNumber           KEY(DTL:OrderNumber),DUP,NOCASE,OPT !                    
Record                   RECORD,PRE()
OrderNumber                 SHORT                          !                    
ProdNumber                  SHORT                          !                    
Quantity                    SHORT                          !                    
ProdAmount                  DECIMAL(5,2)                   !                    
TaxRate                     DECIMAL(2,2)                   !                    
                         END
                     END                       

Products             FILE,DRIVER('TOPSPEED'),PRE(PRD),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode) !Products for sale   
KeyProdNumber            KEY(PRD:ProdNumber),NOCASE,OPT,PRIMARY !                    
KeyProdDesc              KEY(PRD:ProdDesc),DUP,NOCASE,OPT  !                    
Record                   RECORD,PRE()
ProdNumber                  SHORT                          !                    
ProdDesc                    STRING(25)                     !                    
ProdAmount                  DECIMAL(5,2)                   !                    
TaxRate                     DECIMAL(2,2)                   !                    
                         END
                     END                       

Phones               FILE,DRIVER('TOPSPEED'),PRE(PHO),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode) !                    
KeyCustNumber            KEY(PHO:CustNumber),DUP,NOCASE    !                    
Record                   RECORD,PRE()
CustNumber                  DECIMAL(4)                     !                    
Area                        LONG                           !                    
Phone                       LONG                           !                    
Description                 STRING(20)                     !                    
                         END
                     END                       

!endregion

Access:Customer      &FileManager,THREAD,EXTERNAL,DLL      ! FileManager for Customer
Relate:Customer      &RelationManager,THREAD,EXTERNAL,DLL  ! RelationManager for Customer
Access:Orders        &FileManager,THREAD,EXTERNAL,DLL      ! FileManager for Orders
Relate:Orders        &RelationManager,THREAD,EXTERNAL,DLL  ! RelationManager for Orders
Access:Detail        &FileManager,THREAD,EXTERNAL,DLL      ! FileManager for Detail
Relate:Detail        &RelationManager,THREAD,EXTERNAL,DLL  ! RelationManager for Detail
Access:Products      &FileManager,THREAD,EXTERNAL,DLL      ! FileManager for Products
Relate:Products      &RelationManager,THREAD,EXTERNAL,DLL  ! RelationManager for Products
Access:Phones        &FileManager,THREAD,EXTERNAL,DLL      ! FileManager for Phones
Relate:Phones        &RelationManager,THREAD,EXTERNAL,DLL  ! RelationManager for Phones

GlobalRequest        BYTE,EXTERNAL,DLL,THREAD              ! Exported from a dll, set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE,EXTERNAL,DLL,THREAD              ! Exported from a dll, set to the response from the form
VCRRequest           LONG,EXTERNAL,DLL,THREAD              ! Exported from a dll, set to the request from the VCR buttons
FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
LocalErrorStatus     ErrorStatusClass,THREAD
LocalErrors          ErrorClass
LocalINIMgr          INIClass
GlobalErrors         &ErrorClass
INIMgr               &INIClass
DLLInitializer       CLASS                                 ! An object of this type is used to initialize the dll, it is created in the generated bc module
Construct              PROCEDURE
Destruct               PROCEDURE
                     END

  CODE
DLLInitializer.Construct PROCEDURE


  CODE
  LocalErrors.Init(LocalErrorStatus)
  LocalINIMgr.Init('.\Updates.INI', NVD_INI)               ! Initialize the local INI manager to use windows INI file
  INIMgr &= LocalINIMgr
  IF GlobalErrors &= NULL
    GlobalErrors &= LocalErrors                            ! Assign local managers to global managers
  END
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  
!These procedures are used to initialize the DLL. It must be called by the main executable when it starts up
Updates:Init PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
Updates:Init_Called    BYTE,STATIC

  CODE
  IF Updates:Init_Called
     RETURN
  ELSE
     Updates:Init_Called = True
  END
  IF ~curGlobalErrors &= NULL
    GlobalErrors &= curGlobalErrors
  END
  IF ~curINIMgr &= NULL
    INIMgr &= curINIMgr
  END
  Access:Customer.SetErrors(GlobalErrors)
  Access:Orders.SetErrors(GlobalErrors)
  Access:Detail.SetErrors(GlobalErrors)
  Access:Products.SetErrors(GlobalErrors)
  Access:Phones.SetErrors(GlobalErrors)
  allfiles:Init(curGlobalErrors, curINIMgr)                ! Initialise dll - (ABC) -
  Reports:Init(curGlobalErrors, curINIMgr)                 ! Initialise dll - (ABC) -

!This procedure is used to shutdown the DLL. It must be called by the main executable before it closes down

Updates:Kill PROCEDURE
Updates:Kill_Called    BYTE,STATIC

  CODE
  IF Updates:Kill_Called
     RETURN
  ELSE
     Updates:Kill_Called = True
  END
  allfiles:Kill()                                          ! Kill dll - (ABC) -
  Reports:Kill()                                           ! Kill dll - (ABC) -
  

DLLInitializer.Destruct PROCEDURE

  CODE
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher
  LocalINIMgr.Kill                                         ! Kill local managers and assign NULL to global refernces
  INIMgr &= NULL                                           ! It is an error to reference these object after this point
  GlobalErrors &= NULL


!================================================================================
! Updates.SingleInvoiceReport
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\TestData\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\TestOutput\Updates.SingleInvoiceReport.clw
!
! This file may also be included in a combined source file called
! Updates._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Updates.SingleInvoiceReport will have a more complete history than
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
SingleInvoiceReport PROCEDURE

Progress:Thermometer BYTE                                  !
FilesOpened          BYTE                                  !
ItemTotal            DECIMAL(7,2)                          !
InvoiceCount         LONG                                  !
Process:View         VIEW(Orders)
                       PROJECT(ORD:OrderDate)
                       PROJECT(ORD:OrderNumber)
                       PROJECT(ORD:CustNumber)
                       JOIN(CUS:KeyCustNumber,ORD:CustNumber)
                         PROJECT(CUS:Address)
                         PROJECT(CUS:City)
                         PROJECT(CUS:Company)
                         PROJECT(CUS:FirstName)
                         PROJECT(CUS:LastName)
                         PROJECT(CUS:State)
                         PROJECT(CUS:ZipCode)
                       END
                       JOIN(DTL:KeyOrderNumber,ORD:OrderNumber)
                         PROJECT(DTL:ProdAmount)
                         PROJECT(DTL:ProdNumber)
                         PROJECT(DTL:Quantity)
                         JOIN(PRD:KeyProdNumber,DTL:ProdNumber)
                           PROJECT(PRD:ProdDesc)
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
ORD:OrderNumberBreak   BREAK(ORD:OrderNumber)
                         HEADER,AT(0,0,,1067)
                           STRING(@s20),AT(100,25),USE(CUS:Company)
                           STRING('Order Number:'),AT(3604,42),USE(?String17),TRN
                           STRING(@n-7),AT(4531,52),USE(ORD:OrderNumber),RIGHT(1)
                           STRING(@s20),AT(1725,217),USE(CUS:LastName)
                           STRING(@s20),AT(100,217),USE(CUS:FirstName)
                           STRING(@d1),AT(4533,275),USE(ORD:OrderDate),RIGHT(1)
                           STRING('Order Date:'),AT(3600,225),USE(?String18),TRN
                           STRING(@P#####P),AT(1850,600),USE(CUS:ZipCode),RIGHT(1)
                           STRING('Item Total'),AT(4469,792),USE(?String22),TRN
                           LINE,AT(125,950,4958,10),USE(?Line1),COLOR(COLOR:Black),LINEWIDTH(50)
                           STRING('Quantity'),AT(104,792),USE(?String19),TRN
                           STRING('Product'),AT(844,792),USE(?String20),TRN
                           STRING('At:'),AT(3740,792),USE(?String21),TRN
                           STRING(@s20),AT(100,408),USE(CUS:Address)
                           STRING(@s20),AT(100,600),USE(CUS:City)
                           STRING(@s2),AT(1650,600),USE(CUS:State)
                         END
detail                   DETAIL
                           STRING(@n-7),AT(104,42),USE(DTL:Quantity),RIGHT(1)
                           STRING(@n-7),AT(771,42),USE(DTL:ProdNumber),RIGHT(1)
                           STRING(@s25),AT(1438,42),USE(PRD:ProdDesc)
                           STRING(@n-7.2),AT(3533,42),USE(DTL:ProdAmount),DECIMAL(12)
                           STRING(@n-10.2),AT(4350,42),USE(ItemTotal),DECIMAL(12)
                         END
                         FOOTER,AT(0,0),PAGEAFTER(-1)
                           LINE,AT(3683,50,1469,-10),USE(?Line2),COLOR(COLOR:Black),LINEWIDTH(20)
                           STRING(@n9.2),AT(4433,75),USE(ItemTotal,,?ItemTotal:2),SUM,RESET(ORD:OrderNumberBreak),TRN
                           STRING('Order Total:'),AT(3567,75),USE(?String23),TRN
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
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
                     END

ThisReport           CLASS(ProcessClass)                   ! Process Manager
TakeRecord             PROCEDURE(),BYTE,PROC,DERIVED
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
  GlobalErrors.SetProcedureName('SingleInvoiceReport')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Progress:Thermometer
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  Relate:Orders.SetOpenRelated()
  Relate:Orders.Open                                       ! File Orders used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(ProgressWindow)                                ! Open window
  Do DefineListboxStyle
  INIMgr.Fetch('SingleInvoiceReport',ProgressWindow)       ! Restore window settings from non-volatile store
  ProgressWindow{PROP:Timer} = 10                          ! Assign timer interval
  ProgressMgr.Init(ScrollSort:AllowNumeric,)
  ThisReport.Init(Process:View, Relate:Orders, ?Progress:PctText, Progress:Thermometer, ProgressMgr, ORD:OrderNumber)
  ThisReport.AddSortOrder(ORD:KeyOrderNumber)
  ThisReport.AddRange(ORD:OrderNumber)
  ThisReport.SetFilter('ORD:OrderNumber <<> 0')
  SELF.AddItem(?Progress:Cancel,RequestCancelled)
  SELF.Init(ThisReport,Report,Previewer)
  ?Progress:UserString{PROP:Text} = ''
  Relate:Orders.SetQuickScan(1,Propagate:OneMany)
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
    Relate:Orders.Close
  END
  IF SELF.Opened
    INIMgr.Update('SingleInvoiceReport',ProgressWindow)    ! Save window data to non-volatile store
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

!================================================================================
! Updates.UpdateCustomer
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\TestData\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\TestOutput\Updates.UpdateCustomer.clw
!
! This file may also be included in a combined source file called
! Updates._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Updates.UpdateCustomer will have a more complete history than
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
!================================================================================
! Updates.UpdateOrder
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\TestData\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\TestOutput\Updates.UpdateOrder.clw
!
! This file may also be included in a combined source file called
! Updates._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Updates.UpdateOrder will have a more complete history than
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
!================================================================================
! Updates.UpdateProduct
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\TestData\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\TestOutput\Updates.UpdateProduct.clw
!
! This file may also be included in a combined source file called
! Updates._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Updates.UpdateProduct will have a more complete history than
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
!================================================================================
! Updates.ViewCustomers
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\TestData\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\TestOutput\Updates.ViewCustomers.clw
!
! This file may also be included in a combined source file called
! Updates._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Updates.ViewCustomers will have a more complete history than
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
!================================================================================
! Updates.ViewOrders
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\TestData\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\TestOutput\Updates.ViewOrders.clw
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
!================================================================================
! Updates.ViewProducts
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\TestData\UPDATES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\TestOutput\Updates.ViewProducts.clw
!
! This file may also be included in a combined source file called
! Updates._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Updates.ViewProducts will have a more complete history than
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
