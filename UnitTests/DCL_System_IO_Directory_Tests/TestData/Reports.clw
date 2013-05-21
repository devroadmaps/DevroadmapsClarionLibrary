   PROGRAM



   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE

   MAP
    MODULE('UPDATES.DLL')
ViewCustomers          PROCEDURE,DLL                       ! 
    END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('REPORTS001.CLW')
CustReport             PROCEDURE   !
InvoiceReport          PROCEDURE   !
CustInvoiceReport      PROCEDURE   !
     END
    ! Declare functions defined in this DLL
Reports:Init           PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
Reports:Kill           PROCEDURE
    ! Declare init functions defined in a different dll
     MODULE('ALLFILES.DLL')
allfiles:Init          PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>),DLL
allfiles:Kill          PROCEDURE,DLL
     END
     MODULE('UPDATES.DLL')
updates:Init           PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>),DLL
updates:Kill           PROCEDURE,DLL
     END
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
Customer             FILE,DRIVER('TOPSPEED'),PRE(CUS),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode)
KeyCustNumber            KEY(CUS:CustNumber),NOCASE,OPT
KeyCompany               KEY(CUS:Company),DUP,NOCASE
KeyZipCode               KEY(CUS:ZipCode),DUP,NOCASE
Record                   RECORD,PRE()
CustNumber                  LONG
Company                     STRING(20)
FirstName                   STRING(20)
LastName                    STRING(20)
Address                     STRING(20)
City                        STRING(20)
State                       STRING(2)
ZipCode                     LONG
                         END
                     END                       

Orders               FILE,DRIVER('TOPSPEED'),PRE(ORD),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode)
KeyOrderNumber           KEY(ORD:OrderNumber),NOCASE,OPT,PRIMARY
KeyCustNumber            KEY(ORD:CustNumber),DUP,NOCASE,OPT
Record                   RECORD,PRE()
CustNumber                  LONG
OrderNumber                 SHORT
InvoiceAmount               DECIMAL(7,2)
OrderDate                   LONG
OrderNote                   STRING(80)
                         END
                     END                       

Detail               FILE,DRIVER('TOPSPEED'),PRE(DTL),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode)
KeyProdNumber            KEY(DTL:ProdNumber),DUP,NOCASE,OPT
KeyOrderNumber           KEY(DTL:OrderNumber),DUP,NOCASE,OPT
Record                   RECORD,PRE()
OrderNumber                 SHORT
ProdNumber                  SHORT
Quantity                    SHORT
ProdAmount                  DECIMAL(5,2)
TaxRate                     DECIMAL(2,2)
                         END
                     END                       

Products             FILE,DRIVER('TOPSPEED'),PRE(PRD),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode)
KeyProdNumber            KEY(PRD:ProdNumber),NOCASE,OPT,PRIMARY
KeyProdDesc              KEY(PRD:ProdDesc),DUP,NOCASE,OPT
Record                   RECORD,PRE()
ProdNumber                  SHORT
ProdDesc                    STRING(25)
ProdAmount                  DECIMAL(5,2)
TaxRate                     DECIMAL(2,2)
                         END
                     END                       

Phones               FILE,DRIVER('TOPSPEED'),PRE(PHO),CREATE,BINDABLE,THREAD,EXTERNAL(''),DLL(dll_mode)
KeyCustNumber            KEY(PHO:CustNumber),DUP,NOCASE
Record                   RECORD,PRE()
CustNumber                  DECIMAL(4)
Area                        LONG
Phone                       LONG
Description                 STRING(20)
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
  LocalINIMgr.Init('.\Reports.INI', NVD_INI)               ! Initialize the local INI manager to use windows INI file
  INIMgr &= LocalINIMgr
  IF GlobalErrors &= NULL
    GlobalErrors &= LocalErrors                            ! Assign local managers to global managers
  END
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  
!These procedures are used to initialize the DLL. It must be called by the main executable when it starts up
Reports:Init PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
Reports:Init_Called    BYTE,STATIC

  CODE
  IF Reports:Init_Called
     RETURN
  ELSE
     Reports:Init_Called = True
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
  updates:Init(curGlobalErrors, curINIMgr)                 ! Initialise dll - (ABC) -

!This procedure is used to shutdown the DLL. It must be called by the main executable before it closes down

Reports:Kill PROCEDURE
Reports:Kill_Called    BYTE,STATIC

  CODE
  IF Reports:Kill_Called
     RETURN
  ELSE
     Reports:Kill_Called = True
  END
  allfiles:Kill()                                          ! Kill dll - (ABC) -
  updates:Kill()                                           ! Kill dll - (ABC) -
  

DLLInitializer.Destruct PROCEDURE

  CODE
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher
  LocalINIMgr.Kill                                         ! Kill local managers and assign NULL to global refernces
  INIMgr &= NULL                                           ! It is an error to reference these object after this point
  GlobalErrors &= NULL


