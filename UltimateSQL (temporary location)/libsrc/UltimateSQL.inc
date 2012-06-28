
    OMIT('_EndOfInclude_',_UltimateSQL_)

                                        PRAGMA('link(ODBC32.LIB)')   

!    INCLUDE('UltimateSQLConnect.INC'),ONCE  
    INCLUDE('UltimateSQLDirect.INC'),ONCE  
                                          



_UltimateSQL_                           EQUATE(1)    

Sybase                                  EQUATE(0)
MS_SQL                                  EQUATE(1)
Postgres                                EQUATE(2)
My_SQL                                  EQUATE(3) 
ODBC_Direct                             EQUATE(4)


BusyHandlingDoNothing                   EQUATE(1)
BusyHandlingOneConnectionPerThread      EQUATE(2)
BusyHandlingRetryOnBusy                 EQUATE(3)
BusyHandlingConnectionLocking           EQUATE(4) 

SQL_HANDLE_ENV                          EQUATE(1)
SQL_HANDLE_DBC                          EQUATE(2)
SQL_HANDLE_STMT                         EQUATE(3)
SQL_HANDLE_DESC                         EQUATE(4)

SQL_SUCCESS                             EQUATE(0)
SQL_SUCCESS_WITH_INFO                   EQUATE(1)
SQL_ERROR                               EQUATE(-1)
SQL_INVALID_HANDLE                      EQUATE(-2)

SQL_NULL_HANDLE                         EQUATE(0)

SQL_ATTR_ODBC_VERSION                   EQUATE(200)

SQL_OV_ODBC2                            EQUATE(2)
SQL_OV_ODBC3                            EQUATE(3)

SQL_COPT_SS_INTEGRATED_SECURITY         EQUATE(1203)

LoginConnections                        Queue,Type
Name                                        STRING(512)
                                        End      

DatabaseConnectionString                STRING(200)  

QueryMethodDummyFile                    EQUATE(1)
QueryMethodODBC                         EQUATE(2)


   
!
!--------------------------
!ClarionLive Debug Class
!--------------------------
!--------------------------------------------------------------------------------
!Category: Clarion Live!
!--------------------------------------------------------------------------------
! Debug Class used to begin building your own classes with!
! The OMIT at the top is used to load the class only once, so you do not have to use the "once" statement when you INCLUDE the class in your global includes
!
!--------------------------------------------------------------------------------
UltimateSQL                             CLASS(UltimateSQLDirect),TYPE,MODULE('UltimateSQL.CLW'),LINK('UltimateSQL.CLW')     !,_ABCLinkMode_),DLL(_ABCDllMode_)
!
!--------------------------------------------------------------------------------
! Add properties here, which are variables
!--------------------------------------------------------------------------------
!Properties
!----------
QueryTableName                              STRING(200),PRIVATE  

!ASCIIFileName                               STRING(100)


TheDatabaseConnectionString                 STRING(200),PRIVATE 
Catalog                                     STRING(200),PRIVATE
_Driver                                     LONG,PROTECTED            ! 0 = Sybase, 1 = MS SQL 
LoginConnections                            &LoginConnections,PROTECTED  
QueryResultsShowInPopUp                     BYTE(FALSE) ! Set to TRUE to view your Query Results in a Pop-Up, FALSE to turn it off
ShowQueryInDebugView                        BYTE(FALSE) ! Set to TRUE to send your Query to DebugView, FALSE to turn it off
AddQueryToClipboard                         BYTE(FALSE) ! Set to TRUE to send your Query to the Clipboard, FALSE to turn it off
AppendQueryToClipboard                      BYTE(FALSE) ! Set to TRUE to send your Query to the Clipboard, FALSE to turn it off 


HINT                                        STRING(220)
LOGONSCREEN                                 BYTE(TRUE)
SAVESTOREDPROC                              BYTE(TRUE)
TRUSTEDCONNECTION                           BYTE(FALSE)  
MULTIPLEACTIVERESULTSETS                    BYTE(TRUE)
ALLOWDETAILS                                BYTE(TRUE)
APPENDBUFFER                                LONG
AUTOINC                                     STRING(100)
BINDCOLORDER                                BYTE(0)
BINDCONSTANTS                               BYTE(TRUE)
BUSYHANDLING                                BYTE(3)
BUSYMESSAGE                                 STRING(200)
BUSYRETRIES                                 BYTE(20)
CLIPSTRINGS                                 BYTE(TRUE)
FASTCOLUMNFETCH                             BYTE(TRUE)
FORCEUPPERCASE                              BYTE(FALSE)
GATHERATOPEN                                BYTE(FALSE)
IGNORETRUNCATION                            BYTE(FALSE)
ISOLATIONLEVEL                              BYTE(1)
LOGFILEPATH                                 STRING(220)
LOGFILEMESSAGE                              STRING(220)
NESTING                                     BYTE(TRUE)
ODBCCALL                                    BYTE(TRUE)
ORDERINSELECT                               BYTE(FALSE)
PREAUTOINC                                  BYTE(TRUE)
TURBOSQL                                    BYTE(FALSE)
USEINNERJOIN                                BYTE(TRUE)
VERIFYVIASELECT                             BYTE(FALSE)
WHERE                                       STRING(220)
ZEROISNULL                                  BYTE(TRUE)      

QueryMethod                                 BYTE(1)


!
!--------------------------------------------------------------------------------
! Add Methods here, which are just procedures or functions
!--------------------------------------------------------------------------------
!Methods
!-------
      
AddColumn                                   PROCEDURE(STRING pTable,STRING pColumn,STRING pType,<STRING pLength>,<STRING pOptions>),LONG,PROC
AlterColumn                                 PROCEDURE(STRING pTable,STRING pColumn,STRING pType,<STRING pLength>,<STRING pOptions>),LONG,PROC    
CheckQueryTableExists                       PROCEDURE(STRING pConnectionString)
ColumnExists                                PROCEDURE(STRING pTable,STRING pColumn,<STRING pCatalog>,<STRING pSchema>),LONG
Connect                                     PROCEDURE(*STRING pServer,*STRING pUser,*STRING pPassword,*STRING pDatabase,*BYTE pTrusted,<BYTE pLoginNamePasswordOnly>),STRING,PROC  
CreateDatabase                              FUNCTION (String Server, String USR, String PWD, String Database, <Byte Trusted>),BYTE,PROC
DatabaseExists                              PROCEDURE(STRING pDatabase),BYTE
DropColumn                                  PROCEDURE(STRING pTable,STRING pColumn),LONG,PROC
DropDatabase                                PROCEDURE(STRING pDatabase),LONG,PROC 
DropDependencies                            PROCEDURE(STRING pTable,STRING pColumn),LONG,PROC  
DropFunction                                PROCEDURE(STRING pFunction),LONG  !,PROC 
DropProcedure                               PROCEDURE(STRING pProcedure),LONG  !,PROC 
DropTable                                   PROCEDURE(FILE pFile),LONG,PROC 
DropTable                                   PROCEDURE(STRING pFile),LONG,PROC 
DropTrigger                                 PROCEDURE(STRING pTrigger),LONG  !,PROC 
DropView                                    PROCEDURE(STRING pView),LONG,PROC 
Empty                                       PROCEDURE(FILE pFile),LONG,PROC 
ExecuteScript                               PROCEDURE(STRING pFileName),BYTE,PROC
ExecuteScriptFromBlob                       PROCEDURE(*BLOB pBlob),BYTE,PROC  
Get                                         PROCEDURE(*FILE pFile, *KEY pKey, <STRING pSelect>), BYTE, PROC
Get                                         PROCEDURE(*KEY pKey, <STRING pSelect>), BYTE, PROC
GetColumnLength                             PROCEDURE(STRING pTable,STRING pColumn),LONG,PROC
GetConnectionInformation                    PROCEDURE(STRING pConnectStr,*LoginConnections pConnectionList,BYTE pTrusted=0),LONG,PROC,PRIVATE 
HandleError                                 PROCEDURE(LONG pErrorCode,STRING pError,LONG pFileErrorCode,STRING pFileError)  
ProcessScript                               PROCEDURE(STRING pScript),BYTE,PROC
Quote                                       PROCEDURE(STRING pText), STRING     
Records                                     PROCEDURE(*FILE pFile,<STRING pFilter>),LONG
RemoveIllegalCharacters                     PROCEDURE(String pString),STRING
SendDriverString                            PROCEDURE(STRING pMessage),STRING,PROC 
Set                                         PROCEDURE(*KEY pKey, <STRING pSelect>, BYTE pReverse=False)
Set                                         PROCEDURE(*KEY pKeyIgnored, *KEY pKey, <STRING pSelect>, BYTE pReverse=False)
SetCatalog                                  PROCEDURE(STRING pCatalog)
SetQueryConnection                          PROCEDURE(STRING pOwnerName,<STRING pQueryTableName>)
TableExists                                 PROCEDURE(FILE pFile,<STRING pCatalog>,<STRING pSchema>),BYTE
TableExists                                 PROCEDURE(STRING pTable,<STRING pCatalog>,<STRING pSchema>),BYTE
TestConnection                              PROCEDURE(STRING Server, STRING USR, STRING PWD, <Byte Trusted>, <*STRING ErrorOut>),BYTE 
Trace                                       PROCEDURE(*FILE pTbl, <STRING pLogfile>)  
Truncate                                    PROCEDURE(FILE pFile),LONG,PROC 

Insert                                      PROCEDURE(*FILE pTbl, BYTE pIncludePK=False, BYTE pGetIdentity=FALSE), LONG, PROC
Update                                      PROCEDURE(*FILE pTbl), BYTE, PROC
Delete                                      PROCEDURE(*FILE pTbl), BYTE, PROC

Construct                                   PROCEDURE()
Destruct                                    PROCEDURE()       

Init                                        PROCEDURE()  
Kill                                        PROCEDURE()

Query                                       FUNCTION (STRING pQuery, <*QUEUE pQ>, <*? pC1>, <*? pC2>, <*? pC3>, <*? pC4>, <*? pC5>, <*? pC6>, <*? pC7>, <*? pC8>, <*? pC9>, <*? pC10>, <*? pC11>, <*? pC12>, <*? pC13>, <*? pC14>, <*? pC15>, <*? pC16>, <*? pC17>,<*? pC18>, <*? pC19>, <*? pC20>, <*? pC21>, <*? pC22>, <*? pC23>, <*? pC24>, <*? pC25>, <*? pC26>, <*? pC27>, <*? pC28>, <*? pC29>, <*? pC30>),BYTE,PROC
QueryDummy                                  FUNCTION (STRING pQuery, <*QUEUE pQ>, <*? pC1>, <*? pC2>, <*? pC3>, <*? pC4>, <*? pC5>, <*? pC6>, <*? pC7>, <*? pC8>, <*? pC9>, <*? pC10>, <*? pC11>, <*? pC12>, <*? pC13>, <*? pC14>, <*? pC15>, <*? pC16>, <*? pC17>,<*? pC18>, <*? pC19>, <*? pC20>, <*? pC21>, <*? pC22>, <*? pC23>, <*? pC24>, <*? pC25>, <*? pC26>, <*? pC27>, <*? pC28>, <*? pC29>, <*? pC30>),BYTE,PROC
QueryODBC                                   FUNCTION (STRING pQuery, <*QUEUE pQ>, <*? pC1>, <*? pC2>, <*? pC3>, <*? pC4>, <*? pC5>, <*? pC6>, <*? pC7>, <*? pC8>, <*? pC9>, <*? pC10>, <*? pC11>, <*? pC12>, <*? pC13>, <*? pC14>, <*? pC15>, <*? pC16>, <*? pC17>,<*? pC18>, <*? pC19>, <*? pC20>, <*? pC21>, <*? pC22>, <*? pC23>, <*? pC24>, <*? pC25>, <*? pC26>, <*? pC27>, <*? pC28>, <*? pC29>, <*? pC30>),BYTE,PROC
QueryResult                                 FUNCTION (STRING pQuery),STRING

ExtendedProperty_Insert                     PROCEDURE(STRING pObjectName,STRING pPropertyName,STRING pPropertyValue), LONG, PROC
ExtendedProperty_Update                     PROCEDURE(STRING pObjectName,STRING pPropertyName,STRING pPropertyValue), LONG, PROC
ExtendedProperty_Delete                     PROCEDURE(STRING pObjectName,STRING pPropertyName), LONG, PROC
ExtendedProperty_GetValue                   PROCEDURE(STRING pObjectName,STRING pPropertyName), STRING
ExtendedProperty_Exists                     PROCEDURE(STRING pObjectName,STRING pPropertyName), BYTE

BusyHandling                                PROCEDURE(BYTE pBusyHandling),STRING,PROC
GatherAtOpen                                PROCEDURE(BYTE pTrueFalse),STRING,PROC
IgnoreTruncation                            PROCEDURE(BYTE pTrueFalse),STRING,PROC
MultipleActiveResultSets                    PROCEDURE(BYTE pTrueFalse),STRING,PROC
SaveStoredProcedure                         PROCEDURE(BYTE pTrueFalse),STRING,PROC   
TurboSQL                                    PROCEDURE(BYTE pTrueFalse),STRING,PROC
VerifyViaSelect                             PROCEDURE(BYTE pTrueFalse),STRING,PROC      

                                        END    


    _EndOfInclude_
