   PROGRAM



   INCLUDE('ABASCII.INC'),ONCE
   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABDROPS.INC'),ONCE
   INCLUDE('ABEIP.INC'),ONCE
   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABPRHTML.INC'),ONCE
   INCLUDE('ABPRPDF.INC'),ONCE
   INCLUDE('ABQUERY.INC'),ONCE
   INCLUDE('ABREPORT.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE
   INCLUDE('ABWMFPAR.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABBREAK.INC'),ONCE
   INCLUDE('ABCPTHD.INC'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE
   INCLUDE('ABGRID.INC'),ONCE
   INCLUDE('ABPRNAME.INC'),ONCE
   INCLUDE('ABPRTARG.INC'),ONCE
   INCLUDE('ABPRTARY.INC'),ONCE
   INCLUDE('ABPRTEXT.INC'),ONCE
   INCLUDE('ABPRXML.INC'),ONCE
   INCLUDE('ABQEIP.INC'),ONCE
   INCLUDE('ABRPATMG.INC'),ONCE
   INCLUDE('ABRPPSEL.INC'),ONCE
   INCLUDE('ABRULE.INC'),ONCE
   INCLUDE('ABVCRFRM.INC'),ONCE
   INCLUDE('CFILTBASE.INC'),ONCE
   INCLUDE('CFILTERLIST.INC'),ONCE
   INCLUDE('CWSYNCHC.INC'),ONCE
   INCLUDE('MDISYNC.INC'),ONCE
   INCLUDE('QPROCESS.INC'),ONCE
   INCLUDE('RTFCTL.INC'),ONCE
   INCLUDE('TRIGGER.INC'),ONCE
   INCLUDE('WINEXT.INC'),ONCE

   MAP
     MODULE('ALLFILES_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('ALLFILES001.CLW')
Main                   PROCEDURE   !
     END
     INCLUDE('CWUtil.INC')
    ! Declare functions defined in this DLL
Allfiles:Init          PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
Allfiles:Kill          PROCEDURE
   END

SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
Customer             FILE,DRIVER('TOPSPEED'),PRE(CUS),CREATE,BINDABLE,THREAD
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

Orders               FILE,DRIVER('TOPSPEED'),PRE(ORD),CREATE,BINDABLE,THREAD
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

Detail               FILE,DRIVER('TOPSPEED'),PRE(DTL),CREATE,BINDABLE,THREAD
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

Products             FILE,DRIVER('TOPSPEED'),PRE(PRD),CREATE,BINDABLE,THREAD
KeyProdNumber            KEY(PRD:ProdNumber),NOCASE,OPT,PRIMARY
KeyProdDesc              KEY(PRD:ProdDesc),DUP,NOCASE,OPT
Record                   RECORD,PRE()
ProdNumber                  SHORT
ProdDesc                    STRING(25)
ProdAmount                  DECIMAL(5,2)
TaxRate                     DECIMAL(2,2)
                         END
                     END                       

Phones               FILE,DRIVER('TOPSPEED'),PRE(PHO),CREATE,BINDABLE,THREAD
KeyCustNumber            KEY(PHO:CustNumber),DUP,NOCASE
Record                   RECORD,PRE()
CustNumber                  DECIMAL(4)
Area                        LONG
Phone                       LONG
Description                 STRING(20)
                         END
                     END                       

!endregion

Access:Customer      &FileManager,THREAD                   ! FileManager for Customer
Relate:Customer      &RelationManager,THREAD               ! RelationManager for Customer
Access:Orders        &FileManager,THREAD                   ! FileManager for Orders
Relate:Orders        &RelationManager,THREAD               ! RelationManager for Orders
Access:Detail        &FileManager,THREAD                   ! FileManager for Detail
Relate:Detail        &RelationManager,THREAD               ! RelationManager for Detail
Access:Products      &FileManager,THREAD                   ! FileManager for Products
Relate:Products      &RelationManager,THREAD               ! RelationManager for Products
Access:Phones        &FileManager,THREAD                   ! FileManager for Phones
Relate:Phones        &RelationManager,THREAD               ! RelationManager for Phones

GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons
FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
LocalErrorStatus     ErrorStatusClass,THREAD
LocalErrors          ErrorClass
LocalINIMgr          INIClass
GlobalErrors         &ErrorClass
INIMgr               &INIClass
DLLInitializer       CLASS,TYPE                            ! An object of this type is used to initialize the dll, it is created in the generated bc module
Construct              PROCEDURE
Destruct               PROCEDURE
                     END

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
DLLInitializer.Construct PROCEDURE

  CODE
  LocalErrors.Init(LocalErrorStatus)
  LocalINIMgr.Init('.\Allfiles.INI', NVD_INI)              ! Initialize the local INI manager to use windows INI file
  INIMgr &= LocalINIMgr
  IF GlobalErrors &= NULL
    GlobalErrors &= LocalErrors                            ! Assign local managers to global managers
  END
  DctInit
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  
!These procedures are used to initialize the DLL. It must be called by the main executable when it starts up
Allfiles:Init PROCEDURE(<ErrorClass curGlobalErrors>, <INIClass curINIMgr>)
Allfiles:Init_Called    BYTE,STATIC

  CODE
  IF Allfiles:Init_Called
     RETURN
  ELSE
     Allfiles:Init_Called = True
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

!This procedure is used to shutdown the DLL. It must be called by the main executable before it closes down

Allfiles:Kill PROCEDURE
Allfiles:Kill_Called    BYTE,STATIC

  CODE
  IF Allfiles:Kill_Called
     RETURN
  ELSE
     Allfiles:Kill_Called = True
  END
  

DLLInitializer.Destruct PROCEDURE

  CODE
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher
  LocalINIMgr.Kill                                         ! Kill local managers and assign NULL to global refernces
  INIMgr &= NULL                                           ! It is an error to reference these object after this point
  GlobalErrors &= NULL



Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

!================================================================================
! Allfiles.Main
!================================================================================
! This procedure has been extracted from its source module for version control
! purposes only - it is NOT compilable.
!
! Original file: D:\dev-IES\ExtractProceduresTest\TestData\ALLFILES001.CLW
!
! New file:      D:\dev-IES\ExtractProceduresTest\TestOutput\Allfiles.Main.clw
!
! This file may also be included in a combined source file called
! Allfiles._AllProcedures.clw.
!
! If this procedure has been moved from another application then
! Allfiles.Main will have a more complete history than
! Allfiles.allprocedures.clw provided the original extracted procedure
! file was renamed in the version control system)
!================================================================================
! Start of original module header
!================================================================================
!
!
!   MEMBER('Allfiles.clw')                                  ! This is a MEMBER module
!
!                     MAP
!                       INCLUDE('ALLFILES001.INC'),ONCE        !Local module procedure declarations
!                     END
!
!
!================================================================================
! End of original module header
!================================================================================
Main                 PROCEDURE                             ! Declare Procedure
  CODE
