                                        MEMBER()   
                                        pragma('link(C%V%MSS%X%%L%.LIB)')
!
!--------------------------
!ClarionLive Skeleton Class
!--------------------------

    INCLUDE('EQUATES.CLW')
    INCLUDE('UltimateSQL.INC'),ONCE
    INCLUDE('UltimateDebug.INC'),ONCE   
    INCLUDE('UltimateSQLstring.INC'),ONCE
    INCLUDE('UltimateSQLScripts.INC'),ONCE  
!    INCLUDE('UltimateSQLDirect.INC'),ONCE  



                                        MAP
                                            Module('ODBC32')
                                                USQLAllocHandle(short HandleType, Long InputHandle, *Long OutputHandle), Short, Pascal ,NAME('SQLAllocHandle'),PROC
                                                USQLBrowseConnect(Long hdbc, *CString ConnectStringIn, Short CSInSize, *CString ConnectStringOut, Short BufferSize, *Short ReturnSize), Short, Pascal, Raw ,NAME('SQLBrowseConnect'), PROC
                                                USQLDisconnect(Long hdbc), Short, Pascal ,NAME('SQLDisconnect'), PROC
                                                USQLFreeHandle(Short HandleType, Long Handle), Short, Pascal ,NAME('SQLFreeHandle'), PROC
                                                USQLSetConnectAttr(Long DBCHandle, Long Attribute, Long ValuePtr, Long ValueLen), Short, Pascal ,NAME('SQLSetConnectAttr'), PROC
                                                USQLSetEnvAttr(Long EnvironmentHandle, Long Attribute, Long ValuePtr, Long ValueLen), Short, Pascal ,NAME('SQLSetEnvAttr'), PROC
                                            End
                                        END

DatabaseCheckOwnerString                STRING(200)
TestConnectionString                    STRING(200) 


QueryResults                            FILE,DRIVER('MSSQL','/LOGONSCREEN=FALSE,/SAVESTOREDPROC=FALSE,/IGNORETRUNCATION = TRUE'),OWNER(DatabaseConnectionString),PRE(QueryResults),CREATE,BINDABLE,THREAD
Record                                      RECORD,PRE()
C01                                             CSTRING(18000)
C02                                             CSTRING(18000)
C03                                             CSTRING(18000)
C04                                             CSTRING(256)
C05                                             CSTRING(256)
C06                                             CSTRING(256)
C07                                             CSTRING(256)
C08                                             CSTRING(256)
C09                                             CSTRING(256)
C10                                             CSTRING(256)
C11                                             CSTRING(256)
C12                                             CSTRING(256)
C13                                             CSTRING(256)
C14                                             CSTRING(256)
C15                                             CSTRING(256)
C16                                             CSTRING(256)
C17                                             CSTRING(256)
C18                                             CSTRING(256)
C19                                             CSTRING(256)
C20                                             CSTRING(256)
C21                                             CSTRING(256)
C22                                             CSTRING(256)
C23                                             CSTRING(256)
C24                                             CSTRING(256)
C25                                             CSTRING(256)
C26                                             CSTRING(256)
C27                                             CSTRING(256)
C28                                             CSTRING(256)
C29                                             CSTRING(256)
C30                                             CSTRING(256)
                                            END
                                        END    

!!us_ud                                   UltimateDebug    
!us_Direct                                   UltimateSQLDirect  

!ViewResults                             UltimateSQLResultsViewClass


DebugInitted                            BYTE(FALSE) 


! -----------------------------------------------------------------------
!!! <summary>Prompts for SQL Connection Information. Note that ALL Parameters are required, even if blank.</summary>           
!!! <param name="Server">Server Name</param>
!!! <param name="UserName">User Name</param>        
!!! <param name="Password">Password</param>        
!!! <param name="Database">Database Name</param>        
!!! <param name="Trusted">True is a Trusted Connection, False if not.</param> 
!!! <param name="LoginNamePasswordOnly"Optional paramater, you will be prompted only for name and password.  You should pass server and database information.</param> 
! -----------------------------------------------------------------------
UltimateSQL.Connect                     PROCEDURE(*STRING pServer,*STRING pUserName,*STRING pPassword,*STRING pDatabase,*BYTE pTrusted,<BYTE pLoginNamePasswordOnly>)  ! ,STRING

TheServer                                   STRING(200)
TheUserName                                 STRING(200)
ThePassword                                 STRING(200) 
TheDatabase                                 STRING(200)
Trusted                                     BYTE(0)

TheResult                                   STRING(800)

ConnectStr                                  STRING(100)  
TestResult                                  STRING(200)   

SQLServers                                  QUEUE,PRE(SQLServers)               
Name                                            STRING(512)                           
                                            END
SQLDatabases                                QUEUE,PRE(SQLDatabases)               
Name                                            STRING(512)                           
                                            END
                                                  
Scripts                                     UltimateSQLScripts

Window                                      WINDOW('Connect'),AT(,,364,165),CENTER,GRAY,FONT('MS Sans Serif',8)
                                                PANEL,AT(18,14,322,105),USE(?PANEL1),BEVEL(1)
                                                COMBO(@s200),AT(85,25,224,12),USE(TheServer),VSCROLL,DROP(10),FROM(SQLServers), |
                                                    FORMAT('1020L(2)@s255@')
                                                LIST,AT(85,42,224,11),USE(?LISTAuthentication),DROP(2),FROM('Windows Aut' & |
                                                    'hentication|SQL Server Authentication')
                                                ENTRY(@s200),AT(85,58,224),USE(TheUserName) 
                                                ENTRY(@s200),AT(85,76,224),USE(ThePassword),PASSWORD
                                                COMBO(@s200),AT(85,93,224,12),USE(TheDatabase),VSCROLL,DROP(10), |
                                                    FROM(SQLDatabases),FORMAT('1020L(2)|M@s255@')
                                                BUTTON('OK'),AT(201,131,65,21),USE(?OkButton),DEFAULT
                                                BUTTON('Cancel'),AT(271,131,69,21),USE(?CancelButton)
                                                STRING('Username:'),AT(46,62),USE(?STRING3)
                                                STRING('Database:'),AT(47,96),USE(?STRING2)
                                                STRING('Server Host:'),AT(41,28),USE(?STRING1)
                                                STRING('Password:'),AT(47,79),USE(?STRING4)
                                                STRING('Authentication:'),AT(33,44),USE(?STRING5)
                                                BUTTON('Test'),AT(18,131,65,21),USE(?BUTTONTest)
                                            END
    CODE
    
    TheServer = pServer
    TheDatabase = pDatabase
    TheUserName = pUserName
    ThePassword = pPassword    
        
    IF TheServer AND TheDatabase  
        IF SELF.TestConnection(TheServer,TheUserName,ThePassword,pTrusted)
            TheResult = CLIP(TheServer) & ',' & CLIP(TheDatabase) & ',' & CLIP(TheUserName) & ',' & CLIP(ThePassword) 
            IF pTrusted
                TheResult = CLIP(TheServer) & ',' & CLIP(TheDatabase) & ';TRUSTED_CONNECTION=Yes'   
            END    
            DO ProcedureReturn
        END
    END
        
    OPEN(Window)    
        
    EXECUTE pTrusted + 1
        ?LISTAuthentication{PROP:Selected} = 2   
        ?LISTAuthentication{PROP:Selected} = 1
    END
    DO SetUserPasswordFields

    ACCEPT
        CASE FIELD() 
        OF ?TheServer
            CASE EVENT()
            OF EVENT:DroppingDown
                If ~Records(SQLServers)
                    ConnectStr = 'Driver=SQL Server;'
                    SELF.GetConnectionInformation(ConnectStr, SQLServers,CHOOSE(?LISTAuthentication{PROP:Selected}=1,1,0))
                    Display()
                End
            END 
        OF ?LISTAuthentication
            CASE EVENT()
            OF EVENT:Accepted
                DO SetUserPasswordFields
            END
            
        OF ?TheDatabase
            CASE EVENT()
            OF EVENT:DroppingDown
                If ~Records(SQLDatabases)
                    ConnectStr = 'Driver={{SQL Server};Server=' & Clip(TheServer) & ';User ID=' & Clip(TheUserName) & ';Password=' & Clip(ThePassword) & ';'
                    SELF.GetConnectionInformation(ConnectStr, SQLDatabases,CHOOSE(?LISTAuthentication{PROP:Selected}=1,1,0))
                    Display()
                End
            END  
        OF ?ButtonTest  
            CASE EVENT()
            OF EVENT:Accepted
                TheResult = SELF.TestConnection(TheServer,TheUserName,ThePassword,CHOOSE(?LISTAuthentication{PROP:Selected}=1,1,0),TestResult)  
                MESSAGE(CLIP(TestResult))
                CYCLE
            END
        OF ?OkButton  
            CASE EVENT()
            OF EVENT:Accepted
                TheResult = CLIP(TheServer) & ',' & CLIP(TheDatabase) & ',' & CLIP(TheUserName) & ',' & CLIP(ThePassword) 
                IF ?LISTAuthentication{PROP:Selected}=1
                    TheResult = CLIP(TheServer) & ',' & CLIP(TheDatabase) & ';TRUSTED_CONNECTION=Yes'   
                END
                BREAK
            END
            
        OF ?CancelButton
            CASE EVENT()
            OF EVENT:Accepted
                TheResult = ''
                BREAK
            END
            
        END
    END
    
ProcedureReturn                         ROUTINE
    
    SELF.Catalog = TheDatabase 
        
    pServer = TheServer
    pDatabase = TheDatabase
    pUserName = TheUserName
    pPassword = ThePassword  
                      
    IF ~SELF.TableExists(QueryResults)
        SELF.SetQueryConnection(TheResult) 
        SELF.QueryODBC(Scripts.CreateQueryTable())
         
    END
    
        
    RETURN TheResult
 
SetUserPasswordFields                   ROUTINE
    
    ?TheUserName{PROP:Disable}    = CHOOSE(?LISTAuthentication{PROP:Selected}=1,1,0)
    ?TheUserName{PROP:Background} = CHOOSE(?LISTAuthentication{PROP:Selected}=1,COLOR:BTNFACE,COLOR:NONE)
    ?ThePassword{PROP:Disable}    = CHOOSE(?LISTAuthentication{PROP:Selected}=1,1,0)        
    ?ThePassword{PROP:Background} = CHOOSE(?LISTAuthentication{PROP:Selected}=1,COLOR:BTNFACE,COLOR:NONE)
    


! -----------------------------------------------------------------------
!!! <summary>Gets a list of MSSQL Servers or Databases</summary>           
!!! <param name="ConnectStr">The Connection string</param>
!!! <param name="LoginConnections">The LoginConnections data type, a Queue to hold Server or Database names</param>        
!!! <param name="Trusted">Whether or not this is a Trusted connection.  TRUE = Trusted</param>        
! -----------------------------------------------------------------------        
UltimateSQL.GetConnectionInformation    PROCEDURE(STRING pConnectStr,*LoginConnections pConnectionList,BYTE pTrusted=0)
                                        

SQLReturn                                   Long
EnvHandle                                   Long
DBCHandle                                   Long
ConnectStrIn                                CString(2000)
ConnectStrOut                               CString(2000)
ReturnSize                                  Short
TestStringIN                                CString(50)
TestString                                  CString(50)
StartPos                                    Short
EndPos                                      Short

    CODE                                                     ! Begin processed code
                                              
    SetCursor(CURSOR:Wait)
    ConnectStrIn = pConnectStr
    SQLReturn = USQLAllocHandle(SQL_HANDLE_ENV, SQL_NULL_HANDLE, EnvHandle)
        
    If SQLReturn >= 0 Then !If No Error
        SQLReturn = USQLSetEnvAttr(EnvHandle, SQL_ATTR_ODBC_VERSION, SQL_OV_ODBC3, 0)
        If SQLReturn >= 0 Then   !If No Error
            SQLReturn = USQLAllocHandle(SQL_HANDLE_DBC, EnvHandle, DBCHandle)
            If SQLReturn >= 0 Then !If No Error
                If pTrusted Then
                    SQLReturn = USQLSetConnectAttr(DBCHandle, SQL_COPT_SS_INTEGRATED_SECURITY, 1, 0)
                Else
                    SQLReturn = USQLSetConnectAttr(DBCHandle, SQL_COPT_SS_INTEGRATED_SECURITY, 0, 0)
                End
                If SQLReturn >= 0 Then !If No Error
                    SQLReturn = USQLBrowseConnect(DBCHandle, ConnectStrIn, Size(ConnectStrIn), ConnectStrOut, Size(ConnectStrOut), ReturnSize)
                    If SQLReturn >= 0 Then !If Error Browsing Network
                        TestStringIn = 'SERVER='
                        StartPos = Instring(TestStringIn, UPPER(ConnectStrIn), 1, 1)
                        If StartPOS = 0 Then
                            TestString = 'SERVER={{'
                        Else
                            TestString = 'DATABASE={{'
                        End

                        StartPos = Instring(TestString, UPPER(ConnectStrOut), 1, 1)

                        If StartPOS > 0 Then
                            StartPOS += Len(TestString)
                            ConnectStrOut = Sub(ConnectStrOut, StartPos, Len(ConnectStrOut))
                            EndPOS = Instring('}', UPPER(ConnectStrOut), 1, 1) - 1
                            ConnectStrOut = Sub(ConnectStrOut, 1, EndPOS)

                            Free(pConnectionList)

                            Loop Until Len(Clip(ConnectStrOut)) <= 0
                                I# += 1
                                Clear(pConnectionList)

                                EndPOS = Instring(',', UPPER(ConnectStrOut), 1, 1)
                                If EndPOS > 0 Then
                                    pConnectionList.Name = Clip(Sub(ConnectStrOut, 1, EndPOS - 1))
                                    ConnectStrOut = Sub(ConnectStrOut, EndPOS + 1, Len(ConnectStrOut))

                                Else
                                    pConnectionList.Name = Clip(ConnectStrOut)
                                    ConnectStrOut = ''
                                End
                                Add(pConnectionList, pConnectionList.Name)
                            End !Loop Until Len(Clip(ConnectStrOut)) <= 0
                        End !If StartPOS > 0 Then
                    End
                    USQLDisconnect(DBCHandle)
                End
            End
            USQLFreeHandle(SQL_HANDLE_DBC, DBCHandle)
        End !If ret# >= 0 Then
        USQLFreeHandle(SQL_HANDLE_ENV, ENVHandle)
    End !If SQLReturn >= 0 Then
    SetCursor()
    SORT(pConnectionList,pConnectionList.Name)
    Return SQLReturn

! -----------------------------------------------------------------------
!!! <summary>Tests to make sure an MSSQL connection is valid/summary>           
!!! <param name="Server">Server Name</param>
!!! <param name="Username">User Name</param>        
!!! <param name="Password">Password</param>   
!!! <param name="Trusted">Whether or not this is a Trusted connection.  TRUE = Trusted</param>        
!!! <param name="ErrorOut">If included, the results of the test are returned in the passed String</param>        
!!! <param name="Return Value">Returns TRUE if successful, FALSE if unsuccessful</param>        
! -----------------------------------------------------------------------        
UltimateSQL.TestConnection              PROCEDURE(STRING Server, STRING USR, STRING PWD, <BYTE Trusted>, <*STRING ErrorOut>) ! BYTE

StatusString                                STRING(2000)
FileErr                                     STRING(512)
SQLStr                                      STRING(1024)
DBCount                                     LONG
ReturnVal                                   BYTE

SysDatabases                                FILE,DRIVER('MSSQL'),OWNER(TestConnectionString), Name('SysDatabases')
Record                                          RECORD,PRE()
name                                                CSTRING(129)
dbid                                                SHORT
sid                                                 STRING(85)
mode                                                SHORT
status                                              LONG
status2                                             LONG
crdate                                              STRING(8)
crdate_GROUP                                        GROUP,OVER(crdate)
crdate_DATE                                             DATE
crdate_TIME                                             TIME
                                                    END
reserved                                            STRING(8)
reserved_GROUP                                      GROUP,OVER(reserved)
reserved_DATE                                           DATE
reserved_TIME                                           TIME
                                                    END
category                                            LONG
cmptlevel                                           BYTE
filename                                            CSTRING(261)
version                                             LONG
                                                END
                                            END
    CODE                                                     ! Begin processed code
    !Return Values

    !True   =   Connection Successful
    !False  =   Connection Failed

    StatusString = 'BEGIN TEST...<13><10><13><10>'
    If Omitted(4) Then
        Trusted = False
    End

    ReturnVal = True

    If Len(Clip(Server)) <= 0 Then
        ReturnVal = False
    End

    If (Len(Clip(USR)) <= 0) AND (~Trusted) Then
        ReturnVal = False
    End

    If ReturnVal And Trusted Then
        Send(SysDatabases, '/TRUSTEDCONNECTION = TRUE')
    Else
        Send(SysDatabases, '/TRUSTEDCONNECTION = FALSE')
    End

    StatusString = Clip(StatusString) & 'Testing Provided Values...'

    If ReturnVal Then
        StatusString = Clip(StatusString) & 'SUCCESS!<13><10>'
        StatusString = Clip(StatusString) & 'Attempting Connection...'
        TestConnectionString = Clip(Server) & ',master,' & Clip(USR) & ',' & Clip(PWD)
        SysDatabases{Prop:Logonscreen} = False
        
        Open(SysDatabases)

        If Error() Then
            FileErr = 'Error['
            If FileError() Then
                FileErr = Clip(FileErr) & FileErrorCode() & ']: ' & FileError()
            Else
                FileErr = Clip(FileErr) & ErrorCode() & ']: ' & Error()
            End
            StatusString = Clip(StatusString) & 'FAILED!<13><10>' & Clip(FileErr) & '<13><10>'
            ReturnVal = False
        End

        If ReturnVal Then
            StatusString = Clip(StatusString) & 'SUCCESS!<13><10>'
            StatusString = Clip(StatusString) & 'Running Simple Query...'

            SQLStr = 'SELECT COUNT(*) FROM SYSDATABASES'
            SysDatabases{Prop:SQL} = SQLStr
            If Error() Then
                FileErr = 'Error['
                If FileError() Then
                    FileErr = Clip(FileErr) & FileErrorCode() & ']: ' & FileError()
                Else
                    FileErr = Clip(FileErr) & ErrorCode() & ']: ' & Error()
                End
                StatusString = Clip(StatusString) & 'FAILED!<13><10>' & Clip(FileErr) & '<13><10>'
                ReturnVal = False
            Else
                StatusString = Clip(StatusString) & 'SUCCESS!<13><10>'
            End

            Close(SysDatabases)
            SysDatabases{Prop:Disconnect}
        End
    Else
        StatusString = Clip(StatusString) & 'FAILED!<13><10>'
    End

    IF ReturnVal Then
        StatusString = Clip(StatusString) & '<13><10>Test Succeeded!<13><10>'
    Else
        StatusString = Clip(StatusString) & '<13><10>Test FAILED! Please Correct Problems and Try Again!<13><10>'
    End
        
    If ~Omitted(ErrorOut) Then
        ErrorOut = StatusString   
    End

    Return ReturnVal     
        
! -----------------------------------------------------------------------
!!! <summary>Sets the Query table connection string</summary>           
!!! <param name="Ownername">The complete connection string</param>
!!! <param name="QueryTableName">The default Table name is 'dbo.Queries'.  You can change this by passing this parameter.</param>        
! -----------------------------------------------------------------------
UltimateSQL.SetQueryConnection          PROCEDURE(STRING pOwnerName,<STRING pQueryTableName>) !Initialize the Connection String, optionally set the name of the Query Table in your SQL database 

szSQL                                       CSTRING(501)

    CODE	       
         
    SELF.TheDatabaseConnectionString = pOwnerName  
    DatabaseConnectionString = pOwnerName
    IF pQueryTableName = ''
        pQueryTableName = 'dbo.Queries'
    END
    SELF.QueryTableName = pQueryTableName  
         
    QueryResults{PROP:LogonScreen}=FALSE   
         
        
        
! -----------------------------------------------------------------------
!!! <summary>Initializes the Debug class</summary>                   
! -----------------------------------------------------------------------        
UltimateSQL.Init                        PROCEDURE()

    CODE
         
    IF ~DebugInitted

        SELF._Driver = MS_SQL 
    END
    DebugInitted = TRUE  
    
                                            
!-----------------------------------
UltimateSQL.Kill                        PROCEDURE()
!-----------------------------------

    CODE

    RETURN



UltimateSQL.QueryResult                 FUNCTION (STRING pQuery)   !,STRING 

Result                                      STRING(500)

    CODE
        
    Result = ''
    SELF.Query(pQuery,,Result)

    RETURN Result 
        

UltimateSQL.SetCatalog                  FUNCTION (STRING pCatalog)   !,STRING 

Result                                      STRING(500)

    CODE
        
    SELF.Catalog = pCatalog

    RETURN       
                 
UltimateSQL.Query                       FUNCTION (STRING pQuery, <*QUEUE pQ>, <*? pC1>, <*? pC2>, <*? pC3>, <*? pC4>, <*? pC5>, <*? pC6>, <*? pC7>, <*? pC8>, <*? pC9>, <*? pC10>, <*? pC11>, <*? pC12>, <*? pC13>, <*? pC14>, <*? pC15>, <*? pC16>, <*? pC17>,<*? pC18>, <*? pC19>, <*? pC20>, <*? pC21>, <*? pC22>, <*? pC23>, <*? pC24>, <*? pC25>, <*? pC26>, <*? pC27>, <*? pC28>, <*? pC29>, <*? pC30>)  !,BYTE,PROC

    CODE
    SELF.Debug('querymethod ' & SELF.QueryMethod)    
    Execute SELF.QueryMethod
        RETURN SELF.QueryDummy(pQuery,pQ,pC1,pC2,pC3,pC4,pC5,pC6,pC7,pC8,pC9,pC10,pC11,pC12,pC13,pC14,pC15,pC16,pC17,pC18,pC19,pC20,pC21,pC22,pC23,pC24,pC25,pC26,pC27,pC28,pC29,pC30)  !,BYTE,PROC
        RETURN SELF.QueryODBC(pQuery,pQ,pC1,pC2,pC3,pC4,pC5,pC6,pC7,pC8,pC9,pC10,pC11,pC12,pC13,pC14,pC15,pC16,pC17,pC18,pC19,pC20,pC21,pC22,pC23,pC24,pC25,pC26,pC27,pC28,pC29,pC30)  !,BYTE,PROC
    END

        
        
! -----------------------------------------------------------------------
!!! <summary>Sends Queries to the SQL database</summary>           
!!! <param name="Query">The actual Query to be sent to the SQL database</param>
!!! <param name="Q">A Queue to receive Query results.  This is optional if you are only receiving a single row.</param>        
!!! <param name="C1...C30">Variables belonging to the passed Queue, or stand-alone variables to reeive a single result.</param>        
! -----------------------------------------------------------------------
UltimateSQL.QueryDummy                       FUNCTION (STRING pQuery, <*QUEUE pQ>, <*? pC1>, <*? pC2>, <*? pC3>, <*? pC4>, <*? pC5>, <*? pC6>, <*? pC7>, <*? pC8>, <*? pC9>, <*? pC10>, <*? pC11>, <*? pC12>, <*? pC13>, <*? pC14>, <*? pC15>, <*? pC16>, <*? pC17>,<*? pC18>, <*? pC19>, <*? pC20>, <*? pC21>, <*? pC22>, <*? pC23>, <*? pC24>, <*? pC25>, <*? pC26>, <*? pC27>, <*? pC28>, <*? pC29>, <*? pC30>)  !,BYTE,PROC



QueryView                                   VIEW(QueryResults)
                                            END


ExecOK                                      BYTE(0)
ResultQ                                     &QUEUE
Recs                                        ULONG(0)

QString                                     CSTRING(LEN(pQuery)+1)  !8192)   ! 8K Limit ???  !MG

NoRetVal                                    BYTE(0)         ! NO Return Values (True/False)
BindVars                                    BYTE(0)         ! Binded Variables Exist (True/False)
BindVarQ                                    QUEUE           ! Binded Variables
No                                              BYTE          ! No
Name                                            STRING(18)    ! Name
                                            END     
UsingExec                                   BYTE(0)  
SendToDebug                                 BYTE(0)



    CODE                                                     ! Begin processed code
    PUSHBIND     
    SELF.Init()
    IF DatabaseConnectionString = ''
        DatabaseConnectionString = SELF.TheDatabaseConnectionString
    END
    IF SELF.QueryTableName = ''
        SELF.QueryTableName = 'dbo.Queries'
    END
            
    ExecOK = False  
    QueryResults{PROP:Name} = SELF.QueryTableName
    FREE(BindVarQ) ; BindVars = False ; NoRetVal = False   
    IF (OMITTED(pQ) AND OMITTED(pC1) AND OMITTED(pC2)) THEN NoRetVal = True.  ! No Return Values - Possible an UPDATE/DELETE statement
    IF NOT OMITTED(pQ) THEN ResultQ &= pQ END  ! If Result Queue Exists - Reference Queue
    IF INSTRING('EXEC',UPPER(pQuery),1,1)
        UsingEXEC = TRUE
    END        
    IF pQuery[1:1] = '*' OR SELF.ShowQueryInDebugView OR SELF.AddQueryToClipboard OR SELF.AppendQueryToClipboard
        SendToDebug = FALSE
        IF pQuery[1:1] = '*'
            pQuery = SUB(pQuery,2,10000) 
            SendToDebug = TRUE
        END 
        IF SELF.ShowQueryInDebugView OR SendToDebug
            SELF.Debug(pQuery)  
        END
            
        IF SELF.AppendQueryToClipboard
            SETCLIPBOARD(CLIPBOARD() & '<13,10,13,10>' & CLIP(pQuery))
        ELSIF SELF.AddQueryToClipboard
            SETCLIPBOARD(CLIP(pQuery)      )
        END
    END
    
    IF pQuery = ''
        BEEP ; MESSAGE('Missing Query Statement')
    ELSE
	    !~! Parse Query String for EMBEDDED Variables to be BOUND
        IF INSTRING('CALL ',UPPER(pQuery),1,1) ! Check if Stored Procedure is Called
            QString = CLIP(pQuery)
            S# = 0 ;  L# = LEN(CLIP(QString))
            LOOP C# = 1 TO L#
                IF S# AND INLIST(QString[C#],',',' ',')') 
					! End of Binded Variable
                    BindVarQ.No   = RECORDS(BindVarQ) + 1
                    BindVarQ.Name = QString[(S#+1) : (C#-1)]
                    IF NOT OMITTED(3+BindVarQ.No) ! Bound Variables MUST be at the Beginning of OUTPUT Variables
                        EXECUTE BindVarQ.No
                            BIND(CLIP(BindVarQ.Name),pC1)
                            BIND(CLIP(BindVarQ.Name),pC2)
                            BIND(CLIP(BindVarQ.Name),pC3)
                            BIND(CLIP(BindVarQ.Name),pC4)
                            BIND(CLIP(BindVarQ.Name),pC5)
                            BIND(CLIP(BindVarQ.Name),pC6)
                            BIND(CLIP(BindVarQ.Name),pC7)
                            BIND(CLIP(BindVarQ.Name),pC8)
                            BIND(CLIP(BindVarQ.Name),pC9)
                            BIND(CLIP(BindVarQ.Name),pC10)
                            BIND(CLIP(BindVarQ.Name),pC11)
                            BIND(CLIP(BindVarQ.Name),pC12)
                            BIND(CLIP(BindVarQ.Name),pC13)
                            BIND(CLIP(BindVarQ.Name),pC14)
                            BIND(CLIP(BindVarQ.Name),pC15)
                            BIND(CLIP(BindVarQ.Name),pC16)
                            BIND(CLIP(BindVarQ.Name),pC17)
                            BIND(CLIP(BindVarQ.Name),pC18)
                            BIND(CLIP(BindVarQ.Name),pC19)
                            BIND(CLIP(BindVarQ.Name),pC20)
                            BIND(CLIP(BindVarQ.Name),pC21)
                            BIND(CLIP(BindVarQ.Name),pC22)
                            BIND(CLIP(BindVarQ.Name),pC23)
                            BIND(CLIP(BindVarQ.Name),pC24)
                            BIND(CLIP(BindVarQ.Name),pC25)
                            BIND(CLIP(BindVarQ.Name),pC26)
                            BIND(CLIP(BindVarQ.Name),pC27)
                            BIND(CLIP(BindVarQ.Name),pC28)
                            BIND(CLIP(BindVarQ.Name),pC29)
                            BIND(CLIP(BindVarQ.Name),pC30)
                        END
                    END

                    ADD(BindVarQ,+BindVarQ.No)
                    IF ERRORCODE()
                        BEEP 
                        MESSAGE('BindVarQ : ' & ERROR()) 
                        BREAK
                    END
                    S# = 0
                END
                IF QString[C#] = '&'                      
					! Start of Bound Variable
                    IF S#
                        BEEP
                        MESSAGE('Improper Use of BINDED Variables')
                        BREAK
                    ELSE
                        S# = C#
                    END
                END
            END

            BindVars = RECORDS(BindVarQ)
        END   
        SELF.MULTIPLEACTIVERESULTSETS(TRUE)
        
        IF ~STATUS(QueryResults)
            OPEN(QueryResults) 
            IF ERROR()
                CREATE(QueryResults)
                OPEN(QueryResults) 
            END 
!            BUFFER(QueryResults,100)
        END
        IF ERRORCODE()
            MESSAGE('Error : ' & ERROR() & ' [' & ERRORCODE() &|
                ']|' & 'File Error: ' & FILEERROR() &|
                ' [' & FILEERRORCODE() & ']','OPEN TABLE')
        ELSE
            SEND(QueryResults,'/SAVESTOREDPROC = FALSE')
            SEND(QueryResults,'/GATHERATOPEN = TRUE')
!                SEND(QueryResults,'/TURBOSQL = TRUE')
            QueryResults{PROP:BusyHandling} = 3	
                
            IF UsingEXEC
                OPEN(QueryView)
            END
            IF ERRORCODE() = 90
                IF FILEERRORCODE()
                    MESSAGE('Error : ' & ERROR() & ' [' & ERRORCODE() &|
                        ']|' & 'File Error : ' & FILEERROR() &|
                        ' [' & FILEERRORCODE() & ']','OPEN VIEW')
                END
            ELSIF ERRORCODE()
                MESSAGE('Error : ' & ERROR() & ' [' & ERRORCODE() &|
                    ']|' & 'File : ' & ERRORFILE(),'OPEN VIEW')
            ELSE
                IF UsingEXEC
                    QueryView{PROP:SQL} = CLIP(pQuery)
                ELSE
                    QueryResults{PROP:SQL} = CLIP(pQuery)
                END 
                ErrCode# = ERRORCODE()
                IF ERRORCODE() = 90 AND FILEERRORCODE() = 37000
                    ErrCode# = 0
                END
                IF ErrCode# = 90
                    IF FILEERRORCODE()
	!              MESSAGE('Error : ' & ERROR() & ' [' & ERRORCODE() &|
	!                      ']|' & 'File Error : ' & FILEERROR() &|
	!                      ' [' & FILEERRORCODE() & ']|' &|
	!                      CLIP(pQuery),'EXECUTE QUERY')
                    END
                ELSIF ErrCode#
	!            MESSAGE('Error : ' & ERROR() & ' [' & ERRORCODE() &|
	!                    ']|' & 'File: ' & ERRORFILE() & '|' &|
	!                    CLIP(pQuery),'EXECUTE QUERY')
                ELSE
                    IF BindVars OR NoRetVal
                        ExecOK = True
                    ELSE
                        Recs = 0
                        LOOP
                            IF UsingEXEC
                                NEXT(QueryView)
                            ELSE
                                NEXT(QueryResults)   ! Retrieve Records    
                            END
                            Recs += 1
                            IF NOT ERRORCODE()
                                ExecOK = True
                                IF NOT OMITTED(pQ) THEN CLEAR(ResultQ). ! Clear Result Queue Buffer
                                IF NOT OMITTED(pC1)  THEN pC1 = QueryResults:C01.
                                IF NOT OMITTED(pC2)  THEN pC2 = QueryResults:C02.
                                IF NOT OMITTED(pC3)  THEN pC3 = QueryResults:C03.
                                IF NOT OMITTED(pC4)  THEN pC4 = QueryResults:C04.
                                IF NOT OMITTED(pC5)  THEN pC5 = QueryResults:C05.
                                IF NOT OMITTED(pC6)  THEN pC6 = QueryResults:C06.
                                IF NOT OMITTED(pC7)  THEN pC7 = QueryResults:C07.
                                IF NOT OMITTED(pC8) THEN pC8 = QueryResults:C08.
                                IF NOT OMITTED(pC9) THEN pC9 = QueryResults:C09.
                                IF NOT OMITTED(pC10) THEN pC10 = QueryResults:C10.
                                IF NOT OMITTED(pC11) THEN pC11 = QueryResults:C11.
                                IF NOT OMITTED(pC12) THEN pC12 = QueryResults:C12.
                                IF NOT OMITTED(pC13) THEN pC13 = QueryResults:C13.
                                IF NOT OMITTED(pC14) THEN pC14 = QueryResults:C14.
                                IF NOT OMITTED(pC15) THEN pC15 = QueryResults:C15.
                                IF NOT OMITTED(pC16) THEN pC16 = QueryResults:C16.
                                IF NOT OMITTED(pC17) THEN pC17 = QueryResults:C17.
                                IF NOT OMITTED(pC18) THEN pC18 = QueryResults:C18.
                                IF NOT OMITTED(pC19) THEN pC19 = QueryResults:C19.
                                IF NOT OMITTED(pC20) THEN pC20 = QueryResults:C20.
                                IF NOT OMITTED(pC21) THEN pC21 = QueryResults:C21.
                                IF NOT OMITTED(pC22) THEN pC22 = QueryResults:C22.
                                IF NOT OMITTED(pC23) THEN pC23 = QueryResults:C23.
                                IF NOT OMITTED(pC24) THEN pC24 = QueryResults:C24.
                                IF NOT OMITTED(pC25) THEN pC25 = QueryResults:C25.
                                IF NOT OMITTED(pC26) THEN pC26 = QueryResults:C26.
                                IF NOT OMITTED(pC27) THEN pC27 = QueryResults:C27.
                                IF NOT OMITTED(pC28) THEN pC28 = QueryResults:C28.
                                IF NOT OMITTED(pC29) THEN pC29 = QueryResults:C29.
                                IF NOT OMITTED(pC30) THEN pC30 = QueryResults:C30.
								
                                IF NOT OMITTED(pq) ! Result Queue
                                    ADD(ResultQ)
                                    IF ERRORCODE()
                                        MESSAGE('Error : ' & ERROR() &|
                                            ' [' & ERRORCODE() & ']','ADD TO QUEUE')
                                    END
                                END
                            ELSE
                                IF OMITTED(pq) ! NO Result Queue
                                    IF ERRORCODE() <> 33
                                        IF ERRORCODE() = 90
                                            CASE FILEERRORCODE()
                                            OF ''          
												! Ignore NO File Error
                                            OF '24000'     
												! Ignore Cursor State Error - 
												! Statement Executes BUT Error Returned
                                            OF 'S1010'     
												! Ignore Function Sequencing Error - 
												! Statement Executes BUT Error Returned
                                            ELSE
                                                MESSAGE('Error : ' & ERROR() &|
                                                    ' [' & ERRORCODE() & ']|' & 'File Error : ' &|
                                                    FILEERROR() & ' [' & FILEERRORCODE() &|
                                                    ']','NEXT VIEW')
                                            END
                                        ELSE
                                            MESSAGE('Error : ' & ERROR() & ' [' &|
                                                ERRORCODE() & ']|' &|
                                                'File : ' & ERRORFILE(),'NEXT VIEW')
                                        END
                                    END
                                ELSE
                                    BREAK
                                END
                            END
                            IF OMITTED(pq) THEN BREAK. ! NO Result Queue
                        END
                    END
                END
            END
        END
    END

!!        CLOSE(QueryResults)  
    IF UsingEXEC
        CLOSE(QueryView)
    END
    
    IF BindVars
        LOOP C# = 1 TO BindVars
            GET(BindVarQ, C#)
            IF BindVarQ.Name THEN UNBIND(CLIP(BindVarQ.Name)).   ! Use pushbind popbind??
        END
    END

    FREE(BindVarQ)
	!!  IF NOT OMITTED(2) THEN ResultQ &= NULL.    !MG

    POPBIND
    RETURN ExecOK    
        
UltimateSQL.QueryODBC                       FUNCTION (STRING pQuery, <*QUEUE pQ>, <*? pC1>, <*? pC2>, <*? pC3>, <*? pC4>, <*? pC5>, <*? pC6>, <*? pC7>, <*? pC8>, <*? pC9>, <*? pC10>, <*? pC11>, <*? pC12>, <*? pC13>, <*? pC14>, <*? pC15>, <*? pC16>, <*? pC17>,<*? pC18>, <*? pC19>, <*? pC20>, <*? pC21>, <*? pC22>, <*? pC23>, <*? pC24>, <*? pC25>, <*? pC26>, <*? pC27>, <*? pC28>, <*? pC29>, <*? pC30>)  !,BYTE,PROC

ExecOK                                      BYTE(0)
lCnt                                        long
lRowCnt                                     long
lColCnt                                     long  
ReturnValue                                 LONG                        
SendToDebug                                 BYTE(0)

TheOwnerString                              UltimateSQLString
TheConnectionStr                            UltimateSQLString
        
DirectODBC                                  UltimateSQLDirect    
ViewResults                                 UltimateSQLResultsViewClass


    CODE       
    
    IF ~pQuery
        RETURN Level:Fatal
    END
    
    SELF.Init() 
    IF pQuery[1:1] = '*' OR SELF.QueryShowInDebugView OR SELF.QueryAddToClipboard OR SELF.QueryAppendToClipboard
        SendToDebug = FALSE
        IF pQuery[1:1] = '*'
            pQuery = SUB(pQuery,2,10000) 
            SendToDebug = TRUE
        END 
        IF SELF.QueryShowInDebugView OR SendToDebug
            SELF.Debug(pQuery)  
        END
            
        IF SELF.QueryAppendToClipboard
            SETCLIPBOARD(CLIP(CLIPBOARD()) & '<13,10,13,10>SQL Statement - ' & FORMAT(TODAY(),@D17) & ',' & FORMAT(CLOCK(),@T7) & '<13,10>' & CLIP(pQuery))
        ELSIF SELF.QueryAddToClipboard
            SETCLIPBOARD(CLIP(pQuery)      )
        END
    END
    
    IF SELF.QueryTableName = ''
        SELF.QueryTableName = 'dbo.Queries'
    END                       
        
        
    ExecOK = False                           
    QueryResults{PROP:Name} = SELF.QueryTableName        
    QueryResults{PROP:Owner} = SELF.TheDatabaseConnectionString          
        
    TheOwnerString.Assign(SELF.TheDatabaseConnectionString)
    TheOwnerString.Split(',')
    TheConnectionStr.Assign( 'DRIVER=<7Bh>SQL Server<7Dh>')
        
    TheConnectionStr.Append(';Server='& TheOwnerString.GetLine(1))
    TheConnectionStr.Append(';Database='& TheOwnerString.GetLine(2))
    If TheOwnerString.GetLine(3) = ''
!            TheConnectionStr.Append(';Trusted_Connection=yes')
    Else
        TheConnectionStr.Append(';UID='& TheOwnerString.GetLine(3))
        TheConnectionStr.Append(';PWD='& TheOwnerString.GetLine(4))
    End
            
!    TheConnectionStr.Append(';MARS_Connection=yes')
    ReturnValue = DirectODBC.OpenConnection(TheConnectionStr.Get(),QueryResults{PROP:HENV},QueryResults{PROP:Handle})  
    If DirectODBC.ExecDirect(CLIP(pQuery)) = UltimateSQL_Success  
        Loop lCnt = 1 To Records(DirectODBC.ResultSets)
            if DirectODBC.AssignCurrentResultSet(lCnt) = Level:Benign
                Loop lRowCnt = 1 To Records(DirectODBC.CurrentResultSet)
                    IF NOT OMITTED(PC1);pC1 = DirectODBC.GetColumnValue(lRowCnt,1) END
                    IF NOT OMITTED(PC2);pC2 = DirectODBC.GetColumnValue(lRowCnt,2) END
                    IF NOT OMITTED(PC3);pC3 = DirectODBC.GetColumnValue(lRowCnt,3) END
                    IF NOT OMITTED(PC4);pC4 = DirectODBC.GetColumnValue(lRowCnt,4) END
                    IF NOT OMITTED(PC5);pC5 = DirectODBC.GetColumnValue(lRowCnt,5) END
                    IF NOT OMITTED(PC6);pC6 = DirectODBC.GetColumnValue(lRowCnt,6) END
                    IF NOT OMITTED(PC7);pC7 = DirectODBC.GetColumnValue(lRowCnt,7) END
                    IF NOT OMITTED(PC8);pC8 = DirectODBC.GetColumnValue(lRowCnt,8) END
                    IF NOT OMITTED(PC9);pC9 = DirectODBC.GetColumnValue(lRowCnt,9) END
                    IF NOT OMITTED(PC10);pC10 = DirectODBC.GetColumnValue(lRowCnt,10) END
                    IF NOT OMITTED(PC11);pC11 = DirectODBC.GetColumnValue(lRowCnt,11) END
                    IF NOT OMITTED(PC12);pC12 = DirectODBC.GetColumnValue(lRowCnt,12) END
                    IF NOT OMITTED(PC13);pC13 = DirectODBC.GetColumnValue(lRowCnt,13) END
                    IF NOT OMITTED(PC14);pC14 = DirectODBC.GetColumnValue(lRowCnt,14) END
                    IF NOT OMITTED(PC15);pC15 = DirectODBC.GetColumnValue(lRowCnt,15) END
                    IF NOT OMITTED(PC16);pC16 = DirectODBC.GetColumnValue(lRowCnt,16) END
                    IF NOT OMITTED(PC17);pC17 = DirectODBC.GetColumnValue(lRowCnt,17) END
                    IF NOT OMITTED(PC18);pC18 = DirectODBC.GetColumnValue(lRowCnt,18) END
                    IF NOT OMITTED(PC19);pC19 = DirectODBC.GetColumnValue(lRowCnt,19) END
                    IF NOT OMITTED(PC20);pC20 = DirectODBC.GetColumnValue(lRowCnt,20) END
                    IF NOT OMITTED(PC21);pC21 = DirectODBC.GetColumnValue(lRowCnt,21) END
                    IF NOT OMITTED(PC22);pC22 = DirectODBC.GetColumnValue(lRowCnt,22) END
                    IF NOT OMITTED(PC23);pC23 = DirectODBC.GetColumnValue(lRowCnt,23) END
                    IF NOT OMITTED(PC24);pC24 = DirectODBC.GetColumnValue(lRowCnt,24) END
                    IF NOT OMITTED(PC25);pC25 = DirectODBC.GetColumnValue(lRowCnt,25) END
                    IF NOT OMITTED(PC26);pC26 = DirectODBC.GetColumnValue(lRowCnt,26) END
                    IF NOT OMITTED(PC27);pC27 = DirectODBC.GetColumnValue(lRowCnt,27) END
                    IF NOT OMITTED(PC28);pC28 = DirectODBC.GetColumnValue(lRowCnt,28) END
                    IF NOT OMITTED(PC29);pC29 = DirectODBC.GetColumnValue(lRowCnt,29) END
                    IF NOT OMITTED(PC30);pC30 = DirectODBC.GetColumnValue(lRowCnt,30) END
                    IF NOT OMITTED(pq)
                        ADD(pQ)    
                    ELSE 
                        BREAK ! NO Result Queue
                    END
                end
            end
        end
        IF SELF.QueryResultsShowInPopUp
           ViewResults.DisplayResults(DirectODBC)  
        END
    end
    DirectODBC.CloseConnection()
    IF SELF.QueryShowInDebugView OR SendToDebug
        SELF.Debug('Query Completed')  
    END
            
    IF SELF.QueryAppendToClipboard
        SETCLIPBOARD('Query Completed')
    ELSIF SELF.QueryAddToClipboard
        SETCLIPBOARD('Query Completed')
    END
         
    RETURN ExecOK  
        
! -----------------------------------------------------------------------
!!! <summary>Adds a Column to a Table</summary>           
!!! <param name="Table">Table Name</param>
!!! <param name="Column">Column Name</param>
!!! <param name="Type">Type of Field to add - ex. VCHAR</param>
!!! <param name="Length">Length of Field (if applicable) - ex. 20  ex. 15,2</param>
!!! <param name="Options">Any additional options - ex. DEFAULT 0  ex. NOT NULL</param>
! -----------------------------------------------------------------------        
UltimateSQL.AddColumn                   PROCEDURE(STRING pTable,STRING pColumn,STRING pType,<STRING pLength>,<STRING pOptions>)

Result                                      LONG
VarDefinition                               UltimateSQLString


    CODE

    VarDefinition.Assign(pColumn)
    VarDefinition.Append(' ' & pType)
    IF pLength
        VarDefinition.Append('(' & CLIP(pLength) & ')')
    END
    IF pOptions
        VarDefinition.Append(' ' & CLIP(pOptions))
    END
        
    RETURN SELF.QUERY('IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ' & SELF.Quote(pTable) & |
        ' AND COLUMN_NAME = ' & SELF.Quote(pColumn) & ') ALTER TABLE ' & CLIP(pTable) & ' ADD ' & CLIP(VarDefinition.Get()))        

! -----------------------------------------------------------------------
!!! <summary>Alters a Column in a Table</summary>           
!!! <param name="Table">Table Name</param>
!!! <param name="Column">Column Name</param>
!!! <param name="Type">Type of Field to add - ex. VCHAR</param>
!!! <param name="Length">Length of Field (if applicable) - ex. 20  ex. 15,2</param>
!!! <param name="Options">Any additional options - ex. DEFAULT 0  ex. NOT NULL</param>
! -----------------------------------------------------------------------        
UltimateSQL.AlterColumn                 PROCEDURE(STRING pTable,STRING pColumn,STRING pType,<STRING pLength>,<STRING pOptions>)

Result                                      LONG
VarDefinition                               UltimateSQLString


    CODE

    VarDefinition.Assign(pColumn)
    VarDefinition.Append(' ' & pType)
    IF pLength
        VarDefinition.Append('(' & CLIP(pLength) & ')')
    END
    IF pOptions
        VarDefinition.Append(' ' & CLIP(pOptions))
    END
        
    RETURN SELF.QUERY('ALTER TABLE ' & CLIP(pTable) & ' ALTER COLUMN ' & CLIP(VarDefinition.Get()))        
                         
        
! -----------------------------------------------------------------------
!!! <summary>Checks to see if a Column exists</summary>           
!!! <param name="Table">Table Name</param>
!!! <param name="Column">Column Name</param>        
!!! <param name="Catalog">Catalog (Database) Name, optional</param>
!!! <param name="Schema">Schema Name, optional, default is dbo</param>
!!! <remarks>Returns TRUE if exists, FALSE if does not exist</remarks>        
! ----------------------------------------------------------------------- 
UltimateSQL.ColumnExists                PROCEDURE(STRING pTable,STRING pColumn,<STRING pCatalog>,<STRING pSchema>)  !,LONG

Schema                                      STRING(200)
Catalog                                     STRING(200)
Result                                      LONG

    CODE
        
    Catalog = pCatalog
    Schema = pSchema
    IF Catalog = ''
        Catalog = SELF.Catalog
    END             
    IF Schema = ''
        Schema = 'dbo'
    END
    RETURN SELF.QUERYResult('SELECT count(*) FROM INFORMATION_SCHEMA.COLUMNS' & |  
        ' WHERE TABLE_CATALOG = ' & SELF.Quote(Catalog) & |
        ' AND TABLE_SCHEMA = ' & SELF.Quote(Schema) & | 
        ' AND TABLE_NAME = ' & SELF.Quote(pTable) & |
        ' AND COLUMN_NAME = ' & SELF.Quote(pColumn))    
        
          
        
        
        
! -----------------------------------------------------------------------
!!! <summary>Alters a Column in a Table</summary>           
!!! <param name="Table">Table Name</param>
!!! <param name="Column">Column Name</param>
!!! <remarks>Dropping a Column can fail if Constraints, Indexes, and Statistics exist.
!!! This method drops all of those first, so remove column will succeed.</remarks>
! -----------------------------------------------------------------------         
UltimateSQL.DropColumn                  PROCEDURE(STRING pTable,STRING pColumn)  !,LONG,PROC
Result                                      LONG(0)
VarDefinition                               UltimateSQLString


    CODE
        
    IF SELF.DropDependencies(pTable,pColumn)
        Result = SELF.QUERY('ALTER TABLE ' & CLIP(pTable) & ' DROP COLUMN ' & CLIP(pColumn))   
    END
        
    RETURN Result

        
! -----------------------------------------------------------------------
!!! <summary>Alters a Column in a Table</summary>           
!!! <param name="Table">Table Name</param>
!!! <param name="Column">Column Name</param>
!!! <remarks>Dropping a Column can fail if Constraints, Indexes, and Statistics exist.
!!! This method drops all of those first, so remove column will succeed.</remarks>
! -----------------------------------------------------------------------         
UltimateSQL.DropDependencies            PROCEDURE(STRING pTable,STRING pColumn)  !,LONG,PROC    

Result                                      LONG(0)
Scripts                                     UltimateSQLScripts
ScriptToRun                                 UltimateSQLString

    CODE              
        
    ScriptToRun.Assign(Scripts.DropAllDependencies())
    ScriptToRun.Replace('[PASSEDTABLE]',CLIP(SELF.RemoveIllegalCharacters(pTable)))
    ScriptToRun.Replace('[PASSEDCOLUMN]',CLIP(SELF.RemoveIllegalCharacters(pColumn)))
    RETURN  SELF.Query(ScriptToRun.Get())    
        
        
! -----------------------------------------------------------------------
!!! <summary>Drops a Table from the Database</summary>           
!!! <param name="Table">Table Name</param>
! ----------------------------------------------------------------------- 
UltimateSQL.DropTable                   PROCEDURE(FILE pFile)  !,LONG  !,PROC 

Result                                      LONG

    CODE
        
    RETURN SELF.QUERY('IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ' & SELF.Quote(NAME(pFile)) & ') DROP TABLE ' & CLIP(NAME(pFile)))   
        


    
! -----------------------------------------------------------------------
!!! <summary>Truncates a Table</summary>           
!!! <param name="Table">Table Name</param>
! ----------------------------------------------------------------------- 
UltimateSQL.Empty                    PROCEDURE(FILE pFile)  !,LONG  !,PROC 

Result                                      LONG

    CODE
        
    RETURN SELF.Truncate(pFile)  
        
    
    
! -----------------------------------------------------------------------
!!! <summary>Get record by key</summary>
!!! <param name="Key">Reference to key in table</param>
!!! <param name="Select">Optional additional SQL selection criteria</param>
!!! <remarks>
!!! Returns True on success, False on failure. Use SQL to get a 
!!! record using the indicated key. Assumes that the key
!!! values have been filled into the record buffer. Example:
!!!     GLcls:ClassificationID = loc:ClassificationID
!!!     IF SQL.Get(GLcls:Key_ClassificationID) THEN ...
!!! SQL Generated:
!!!     SELECT * FROM tablename WHERE f1 = v1 [AND f2 = v2...]
!!!         [AND (pSelect)]
!!! </remarks>
! -----------------------------------------------------------------------        
UltimateSQL.Get                         PROCEDURE(*KEY pKey, <STRING pSelect>)  !, BYTE, PROC

oUltimateDB                                   UltimateDB

    CODE

    RETURN  oUltimateDB.SQLFetch(pKey,pSelect)
  
    
UltimateSQL.Get                         PROCEDURE(*FILE pFile, *KEY pKey, <STRING pSelect>)  !, BYTE, PROC

oUltimateDB                                   UltimateDB

    CODE

    RETURN  oUltimateDB.SQLFetch(pKey,pSelect)
        

UltimateSQL.Records                     PROCEDURE(*FILE pFile,<STRING pFilter>) !,LONG

LocalFilter                                 UltimateString

    CODE
 
    IF pFilter
        LocalFilter.Assign(' Where ' & pFilter)
    END
        
    RETURN SELF.QueryResult('Select COUNT(*) FROM ' & NAME(pFile) & CLIP(LocalFilter.Get()))

        
! -----------------------------------------------------------------------
!!! <summary>Fetch records by key</summary>
!!! <param name="Key">Reference to key in table</param>
!!! <param name="Select">Optional additional selection criteria</param>
!!! <param name="Reverse">T=Reverse order of key, [F]=Use key order</param>
!!! <remarks>Uses SQL to fetch a list of child records using the indicated key.
!!! All selection is done through the optional select argument.
!!! Example:
!!!     SQL.Set(INtac:Key_APInvoiceIDActivityDate)
!!!     LOOP
!!!       NEXT(INtac)
!!!       IF ERRORCODE() THEN BREAK.
!!!         ...
!!!     END
!!! SQL Generated:
!!!     SELECT * FROM tablename [WHERE pSelect] ORDER BY f1, ...</remarks>
! -----------------------------------------------------------------------        
UltimateSQL.Set                         PROCEDURE(*KEY pKey, <STRING pSelect>, BYTE pReverse=False)

oUltimateDB                                   UltimateDB

    CODE

    oUltimateDB.SQLFetchChildren(pKey,pSelect)     
        
    RETURN
    
        
UltimateSQL.Set                         PROCEDURE(*KEY pKeyIgnored,*KEY pKey, <STRING pSelect>, BYTE pReverse=False)

oUltimateDB                                   UltimateDB

    CODE

    oUltimateDB.SQLFetchChildren(pKey,pSelect)   
        
    RETURN
        
        
! -----------------------------------------------------------------------
!!! <summary>Truncates a Table</summary>           
!!! <param name="Table">Table Name</param>
! ----------------------------------------------------------------------- 
UltimateSQL.Truncate                    PROCEDURE(FILE pFile)  !,LONG  !,PROC 

Result                                      LONG

    CODE
        
    RETURN SELF.QUERY('TRUNCATE TABLE ' & CLIP(NAME(pFile)))   
        

        
! -----------------------------------------------------------------------
!!! <summary>Checks to see if a Database exists</summary>           
!!! <param name="Database">Database Name</param>
!!! <remarks>Returns TRUE if exists, FALSE if does not exist</remarks>        
! -----------------------------------------------------------------------         
UltimateSQL.DatabaseExists              PROCEDURE(STRING pDatabase)   !,BYTE

    CODE              
        
    RETURN SELF.QueryResult('Select count(*) from master.dbo.sysdatabases where name = ' & SELF.Quote(pDatabase))  
        
        
! -----------------------------------------------------------------------
!!! <summary>Creates a Database</summary>           
!!! <param name="Database">Database Name</param>
!!! <remarks>Returns error status</remarks>        
! -----------------------------------------------------------------------         
UltimateSQL.CreateDatabase              FUNCTION (String Server, String USR, String PWD, String Database, <Byte Trusted>) ! Declare Procedure  

SQLStr                                      String(1024)
FileErr                                     String(20)
DBCount                                     Long
ReturnVal                                   Long

SysObjects                                  FILE,DRIVER('MSSQL'),OWNER(DatabaseCheckOwnerString), Name('SysObjects')
Record                                          RECORD,PRE()
                                                END
                                            END
SysDatabases                                FILE,DRIVER('MSSQL'),OWNER(DatabaseCheckOwnerString), Name('SysDatabases')
Record                                          RECORD,PRE()
name                                                CSTRING(129)
dbid                                                SHORT
sid                                                 STRING(85)
mode                                                SHORT
status                                              LONG
status2                                             LONG
crdate                                              STRING(8)
crdate_GROUP                                        GROUP,OVER(crdate)
crdate_DATE                                             DATE
crdate_TIME                                             TIME
                                                    END
reserved                                            STRING(8)
reserved_GROUP                                      GROUP,OVER(reserved)
reserved_DATE                                           DATE
reserved_TIME                                           TIME
                                                    END
category                                            LONG
cmptlevel                                           BYTE
filename                                            CSTRING(261)
version                                             LONG
                                                END
                                            END

    CODE                                                     ! Begin processed code
    !Return Values

    !-11    =   Tables Exist must be blank database
    !-10    =   Do not have permission to complete operation
    !-9     =   Login Failed
    !-8     =   Server Not Found
    !-7     =   Error Creating Database Object
    !-6     =   Error Reteiving Record
    !-5     =   SQL Query Error
    !-4     =   Could Not Open
    !-3     =   User Name Invalid
    !-2     =   Database Name Invalid
    !-1     =   Server Name Invalid
    !0      =   DB Created Successfully
    !1      =   DB Already Exists

!Select Count(*) From sysobjects Where xtype='U'
    If Omitted(5) Then
        Trusted = False
    End

    ReturnVal = 0

    If Len(Clip(Server)) <= 0 Then
        ReturnVal = -1
    End

    If Len(Clip(Database)) <= 0 Then
        ReturnVal = -2
    End
    If (Len(Clip(USR)) <= 0) AND (~Trusted) Then
        ReturnVal = -3
    End

    If ~ReturnVal And Trusted Then
        Send(SysDatabases, '/TRUSTEDCONNECTION = TRUE')
    Else
        Send(SysDatabases, '/TRUSTEDCONNECTION = FALSE')
    End

    If ~ReturnVal Then
        DatabaseCheckOwnerString = Clip(Server) & ',master,' & Clip(USR) & ',' & Clip(PWD)
        SysDatabases{Prop:Logonscreen} = False
        
        Open(SysDatabases)

        If Error() Then
            If FileError() Then
                FileErr = FileErrorCode()
            Else
                FileErr = ErrorCode()
            End
            ReturnVal = -4
        End

        If ~ReturnVal Then
            !Query for Database in SQL Server
            SQLStr = 'SELECT COUNT(*) FROM SYSDATABASES WHERE name=N''' & Database & ''';'
            SysDatabases{Prop:SQL} = SQLStr
            If Error() Then
                If FileError() Then
                    FileErr = FileErrorCode()
                Else
                    FileErr = ErrorCode()
                End
                ReturnVal = -5
            End

            If ~ReturnVal Then
                !Check Query
                Next(SysDatabases)
                If Error() Then
                    If FileError() Then
                        FileErr = FileErrorCode()
                    Else
                        FileErr = ErrorCode()
                    End
                    ReturnVal = -6
                Else
                    DBCount = SysDatabases.Name
                    If DBCount > 0 Then
                        !Database already exists do not create
                        ReturnVal = 1
                    End
                End

                If ~ReturnVal Then
                    !Create Database
                    SQLStr = 'CREATE DATABASE [' & Clip(Database) & ']'
                    SysDatabases{Prop:SQL} = SQLStr
                    If Error() Then
                        If FileError() Then
                            FileErr = FileErrorCode()
                            !Message(FileErrorCode() & ' = ' & FileError())
                        Else
                            FileErr = ErrorCode()
                        End
                        ReturnVal = -7
                    End
                End
            End
            
            Close(SysDatabases)
            SysDatabases{Prop:Disconnect}
        End
    End

    !Set Specific Error Codes
    IF Len(Clip(FileErr)) > 0 Then
        Case Clip(FileErr)
        Of  '08001'
                !Server Not Found
            ReturnVal = -8
        Of  '28000'
                !Login Failed
            ReturnVal = -9
        Of  '37000'
                !Do not have permission to complete operation
            ReturnVal = -10
        End
    End
    Return ReturnVal


        
! -----------------------------------------------------------------------
!!! <summary>Checks to see if a Table exists</summary>           
!!! <param name="Table">Table Name</param>
!!! <param name="Catalog">Catalog (Database) Name, optional</param>
!!! <param name="Schema">Schema Name, optional, default is dbo</param>
!!! <remarks>Returns TRUE if exists, FALSE if does not exist</remarks>        
! -----------------------------------------------------------------------         
UltimateSQL.TableExists                 PROCEDURE(STRING pTable,<STRING pCatalog>,<STRING pSchema>)  !,BYTE
        
Result                                      LONG 
Schema                                      STRING(200)
Catalog                                     STRING(200)


    CODE     
    
    Catalog = pCatalog
    Schema = pSchema
    IF Catalog = ''
        Catalog = SELF.Catalog
    END             
    IF Schema = ''
        Schema = 'dbo'
    END
    SELF.QUERY('SELECT count(*) FROM INFORMATION_SCHEMA.TABLES' & |  
        ' WHERE TABLE_CATALOG = ' & SELF.Quote(Catalog) & |
        ' AND TABLE_SCHEMA = ' & SELF.Quote(Schema) & | 
        ' AND TABLE_NAME = ' & SELF.Quote(pTable),,Result)
        
    RETURN Result
        
UltimateSQL.TableExists                 PROCEDURE(FILE pFile,<STRING pCatalog>,<STRING pSchema>)  !,BYTE     

    CODE
        
    RETURN SELF.TableExists(NAME(pFile),pCatalog,pSchema)
        
! -----------------------------------------------------------------------
!!! <summary>Drops a Database</summary>           
!!! <param name="Table">Database name</param>
!!! <remarks>Well this can certainly have some ramifications!
!!! Be careful here.</remarks>
! ----------------------------------------------------------------------- 
UltimateSQL.DropDatabase                PROCEDURE(STRING pDatabase)   !,LONG,PROC         

Result                                      LONG

    CODE

    RETURN SELF.QUERY('DROP DATABASEE ' & CLIP(pDatabase))   
        
        
! -----------------------------------------------------------------------
!!! <summary>Reads a script from a file in to memory and executes it.</summary>           
!!! <param name="FileName">Name of the file (with full path) containing the script.</param>
! -----------------------------------------------------------------------
UltimateSQL.ExecuteScript               PROCEDURE(STRING pFileName)   !,BYTE

FetchScript                                 UltimateSQLString                        
QueryStatement                              UltimateSQLString


    CODE
        
    QueryStatement.Assign(CLIP(FetchScript.ReadFile(pFileName))) 
    QueryStatement.Replace('GO<13,10>','')                   
    QueryStatement.Replace('<13,10>GO','')                   
    SELF.Query(QueryStatement.Get())
         
    RETURN TRUE  
        
    
! -----------------------------------------------------------------------
!!! <summary>Executes an SQL Script from a BLOB</summary>           
!!! <param name="BLOB">A BLOB field</param>
!!! <remarks>Useful for storing scripts in an encrypted file such as a TPS file.</remarks>
! -----------------------------------------------------------------------        
UltimateSQL.ExecuteScriptFromBlob       PROCEDURE(*BLOB pBlob)  !,BYTE,PROC  

QueryStatement                              UltimateSQLString    
BlobSize                                    LONG


    CODE
    BlobSize = pBlob{PROP:Size}
        
    QueryStatement.Assign(pBlob[0:BlobSize])  
    RETURN SELF.Query(QueryStatement.Get())
                                                  

! -----------------------------------------------------------------------
!!! <summary>Inserts an Extended Property with a Value into an SQL object</summary>           
!!! <param name="ObjectName">The Object the Extended Property will be added to.  The Object must be fully-formed.  See notes below.</param>
!!! <param name="PropertyName">The Extended Property name.</param>
!!! <param name="PropertyValue">The Value for the Extended Property.</param>
!!! <remarks>The Object must be formatted using the following sequence: schema.object1.object2
!!! To add a Property to your Database, The ObjectName should be blank ''
!!! To add a Property to a Table, the ObjectName should be schema.tablename (ex. dbo.customer)
!!! To add a Property to a Column, the ObjectName should be schema.tablename.column (ex. dbo.customer.firstname)
!!! TO add a Property to a Stored Procedure, the ObjectName should be schema.StoredProcedureName (ex. dbo.MyStoredProcedure)</remarks>
! ----------------------------------------------------------------------- 
UltimateSQL.ExtendedProperty_Insert     PROCEDURE(STRING pObjectName,STRING pPropertyName,STRING pPropertyValue) !, LONG, PROC  

Result                                      STRING(400)
ScriptToRun                                 UltimateSQLString
Scripts                                     UltimateSQLScripts

    CODE        
        
    ScriptToRun.Assign(Scripts.InsertExtendedProperty())
    ScriptToRun.Replace('[OBJECTNAME]',CLIP(SELF.RemoveIllegalCharacters(pObjectName)))
    ScriptToRun.Replace('[PROPERTYNAME]',CLIP(SELF.RemoveIllegalCharacters(pPropertyName)))
    ScriptToRun.Replace('[PROPERTYVALUE]',CLIP(SELF.RemoveIllegalCharacters(pPropertyValue)))   
    RETURN  SELF.Query(ScriptToRun.Get())
        
          
! -----------------------------------------------------------------------
!!! <summary>Updates an Extended Property with a Value into an SQL object</summary>           
!!! <param name="ObjectName">The Object that the Extended Property will be updated from.  The Object must be fully-formed.  See notes below.</param>
!!! <param name="PropertyName">The Extended Property name.</param>
!!! <param name="PropertyValue">The Value for the Extended Property.</param>
!!! <remarks>The Object must be formatted using the following sequence: schema.object1.object2
!!! To add a Property to your Database, The ObjectName should be blank ''
!!! To add a Property to a Table, the ObjectName should be schema.tablename (ex. dbo.customer)
!!! To add a Property to a Column, the ObjectName should be schema.tablename.column (ex. dbo.customer.firstname)
!!! TO add a Property to a Stored Procedure, the ObjectName should be schema.StoredProcedureName (ex. dbo.MyStoredProcedure)</remarks>
! -----------------------------------------------------------------------         
UltimateSQL.ExtendedProperty_Update     PROCEDURE(STRING pObjectName,STRING pPropertyName,STRING pPropertyValue) !, LONG, PROC

Result                                      STRING(400)
ScriptToRun                                 UltimateSQLString
Scripts                                     UltimateSQLScripts

    CODE        
        
    IF SELF.ExtendedProperty_Exists(pObjectName,pPropertyName)
        ScriptToRun.Assign(Scripts.UpdateExtendedProperty())
        ScriptToRun.Replace('[OBJECTNAME]',CLIP(SELF.RemoveIllegalCharacters(pObjectName)))
        ScriptToRun.Replace('[PROPERTYNAME]',CLIP(SELF.RemoveIllegalCharacters(pPropertyName)))
        ScriptToRun.Replace('[PROPERTYVALUE]',CLIP(SELF.RemoveIllegalCharacters(pPropertyValue)))
        RETURN  SELF.Query(ScriptToRun.Get())  
    ELSE
        RETURN SELF.ExtendedProperty_Insert(pObjectName,pPropertyName,pPropertyValue)
    END
        
        
! -----------------------------------------------------------------------
!!! <summary>Deletes an Extended Property from an SQL object</summary>           
!!! <param name="ObjectName">The Object the Extended Property will be deleted from.  The Object must be fully-formed.  See notes below.</param>
!!! <param name="PropertyName">The Extended Property name.</param>
!!! <remarks>The Object must be formatted using the following sequence: schema.object1.object2
!!! To delete a Property from your Database, The ObjectName should be blank ''
!!! To delete a Property from a Table, the ObjectName should be schema.tablename (ex. dbo.customer)
!!! To delete a Property from a Column, the ObjectName should be schema.tablename.column (ex. dbo.customer.firstname)
!!! TO delete a Property from a Stored Procedure, the ObjectName should be schema.StoredProcedureName (ex. dbo.MyStoredProcedure)</remarks>
! -----------------------------------------------------------------------         
UltimateSQL.ExtendedProperty_Delete     PROCEDURE(STRING pObjectName,STRING pPropertyName) !, LONG, PROC  

Result                                      STRING(400)
ScriptToRun                                 UltimateSQLString
Scripts                                     UltimateSQLScripts

    CODE       
        
    IF SELF.ExtendedProperty_Exists(pObjectName,pPropertyName)
        ScriptToRun.Assign(Scripts.UpdateExtendedProperty())        
        ScriptToRun.Replace('[OBJECTNAME]',CLIP(SELF.RemoveIllegalCharacters(pObjectName)))
        ScriptToRun.Replace('[PROPERTYNAME]',CLIP(SELF.RemoveIllegalCharacters(pPropertyName)))
        RETURN  SELF.Query(ScriptToRun.Get()) 
    ELSE
        RETURN ''
    END
        
        
! -----------------------------------------------------------------------
!!! <summary>Gets the Value of an Extended Property with a from an SQL object</summary>           
!!! <param name="ObjectName">The Object the Extended Property will be retrieved from.  The Object must be fully-formed.  See notes below.</param>
!!! <param name="PropertyName">The Extended Property name.</param>
!!! <remarks>The Object must be formatted using the following sequence: schema.object1.object2
!!! To get a Property of your Database, The ObjectName should be blank ''
!!! To get a Property of a Table, the ObjectName should be schema.tablename (ex. dbo.customer)
!!! To get a Property of a Column, the ObjectName should be schema.tablename.column (ex. dbo.customer.firstname)
!!! To get a Property of a Stored Procedure, the ObjectName should be schema.StoredProcedureName (ex. dbo.MyStoredProcedure)
!!! The Method returns the actual Value of the Property</remarks>
! -----------------------------------------------------------------------        
UltimateSQL.ExtendedProperty_GetValue   PROCEDURE(STRING pObjectName,STRING pPropertyName) !, STRING

Result                                      STRING(400)
ScriptToRun                                 UltimateSQLString
Scripts                                     UltimateSQLScripts            

    CODE           
        
    ScriptToRun.Assign(Scripts.GetExtendedProperty())        
    ScriptToRun.Replace('[OBJECTNAME]',CLIP(SELF.RemoveIllegalCharacters(pObjectName)))
    ScriptToRun.Replace('[PROPERTYNAME]',CLIP(SELF.RemoveIllegalCharacters(pPropertyName)))
    ScriptToRun.Replace('[SELECTOPERATION]','Value')
    SELF.Query(ScriptToRun.Get(),,Result)
        
    RETURN Result    
        
! -----------------------------------------------------------------------
!!! <summary>Determines whether the the Property exists in an SQL object</summary>           
!!! <param name="ObjectName">The Object where the Extended Property will be checked.  The Object must be fully-formed.  See notes below.</param>
!!! <param name="PropertyName">The Extended Property name.</param>
!!! <remarks>The Object must be formatted using the following sequence: schema.object1.object2
!!! To determine if a Property exists in your Database, The ObjectName should be blank ''
!!! To determine if a Property exists in a Table, the ObjectName should be schema.tablename (ex. dbo.customer)
!!! To determine if a Property exists in a Column, the ObjectName should be schema.tablename.column (ex. dbo.customer.firstname)
!!! To determine if a Property exists in a Stored Procedure, the ObjectName should be schema.StoredProcedureName (ex. dbo.MyStoredProcedure)
!!! The Method returns TRUE or FALSE</remarks>
! -----------------------------------------------------------------------        
UltimateSQL.ExtendedProperty_Exists     PROCEDURE(STRING pObjectName,STRING pPropertyName) !, BYTE

Result                                      LONG
ScriptToRun                                 UltimateSQLString
Scripts                                     UltimateSQLScripts            

    CODE           
        
    ScriptToRun.Assign(Scripts.GetExtendedProperty())        
    ScriptToRun.Replace('[OBJECTNAME]',CLIP(SELF.RemoveIllegalCharacters(pObjectName)))
    ScriptToRun.Replace('[PROPERTYNAME]',CLIP(SELF.RemoveIllegalCharacters(pPropertyName)))
    ScriptToRun.Replace('[SELECTOPERATION]','COUNT(*)')
    SELF.Query(ScriptToRun.Get(),,Result)
        
    RETURN Result 


! -----------------------------------------------------------------------
!!! <summary>Returns the length of a Column in a Table</summary>           
!!! <param name="Table">Table Name</param>
!!! <param name="Column">Column Name</param>        
! -----------------------------------------------------------------------        
UltimateSQL.GetColumnLength             PROCEDURE(STRING pTable,STRING pColumn)   ! ,LONG
       
Result                                      LONG

    CODE 
        
    SELF.QUERY('SELECT Character_Maximum_Length FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ' & SELF.Quote(pTable) & ' AND COLUMN_NAME = ' & SELF.Quote(pColumn),,Result)
        
    RETURN Result
        
! -----------------------------------------------------------------------
!!! <summary>Format text value with surrounding quotes</summary>
!!! <param name="Text">Value to be quoted</param>
!!! <remarks>Format the text value for processing. Format depends
!!! on driver being used.</remarks>
! -----------------------------------------------------------------------
UltimateSQL.Quote                       PROCEDURE(STRING pText)

oUltimateDB                                   UltimateSQLString

    CODE                            
        
    oUltimateDB.Assign(CLIP(pText))
    oUltimateDB.Quote(SELF._Driver)
    RETURN CLIP(oUltimateDB.Get())    

! -----------------------------------------------------------------------
!!! <summary>Handles display of Query errors</summary>
!!! <param name="ErrorCode">The Errorcode()</param>
!!! <param name="Error">The Error()</param>
!!! <param name="FileErrorCode">The FileErrorcode()</param>
!!! <param name="FileError">The FileError()</param>
!!! <remarks>Formats the error message and displays it in DebugView, the Clipboard, or as a Message
!!! ErrorShowInDebugView = TRUE shows the error in DebugView        
!!! ErrorAddToClipboard = TRUE adds the error to the Clipboard       
!!! ErrorAppendToClipboard = TRUE appends the error to the Clipboard        
!!! ErrorShowAsMessage = TRUE displays the error as a Message</remarks>
! -----------------------------------------------------------------------        
UltimateSQL.HandleError                 PROCEDURE(LONG pErrorCode,STRING pError,LONG pFileErrorCode,STRING pFileError)  

ErrorMessage                                STRING(300)

    CODE 

    ErrorMessage =  'Error: ' & ERRORCODE() & '=' & ERROR() & ' | Errorcode: ' & FILEERRORCODE() & ' = ' & FILEERROR() & '.' 
        
    IF SELF.ErrorShowInDebugView  
        SELF.Debug(ErrorMessage)  
    END
            
    IF SELF.ErrorAppendToClipboard
        SETCLIPBOARD(CLIP(CLIPBOARD()) & '<13,10,13,10>Error - ' & FORMAT(TODAY(),@D17) & ',' & FORMAT(CLOCK(),@T7) & '<13,10>' & CLIP(ErrorMessage))
    ELSIF SELF.ErrorAddToClipboard
        SETCLIPBOARD(CLIP(ErrorMessage))
    END                
        
    IF SELF.ErrorShowAsMessage
        MESSAGE(CLIP(ErrorMessage))
    END 
        
        
! -----------------------------------------------------------------------
!!! <summary>Insert record into database</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="IncludePK">[F]=Do not include primary key, T=Include primary key</param>
!!! <remarks>Uses SQL to build an insert into the database for a table.
!!! Returns True on success, False on failure. Assumes that all the fields
!!! of the table have been filled into the record buffer.
!!! Generated SQL:
!!!     INSERT INTO tablename (f1, ...) VALUES (v1, ...)</remarks>
! -----------------------------------------------------------------------        
UltimateSQL.Insert                      PROCEDURE(*FILE pTbl, BYTE pIncludePK=FALSE, BYTE pGetIdentity=FALSE)   !, LONG, PROC   

oUltimateDB                                   UltimateDB
Identity                                    LONG

    CODE
    
    SELF.Query('*' & oUltimateDB.SQLInsert(pTbl,pIncludePK))
    IF pGetIdentity
        SELF.Query('SELECT @@identity',,Identity)
        RETURN Identity
    ELSE
        RETURN 0
    END
        

        
! -----------------------------------------------------------------------
!!! <summary>Update record in database</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <remarks>Uses SQL to build an update to the database for a table.
!!! Returns True on success, False on failure. Assumes that all the fields
!!! of the table have been filled into the record buffer. Does NOT handle
!!! blobs.
!!! Generated SQL:
!!!     UPDATE tablename (f1 = v1, ...) WHERE pk = pkValue</remarks>
! -----------------------------------------------------------------------        
UltimateSQL.Update                      PROCEDURE(*FILE pTbl)   !, BYTE, PROC  

oUltimateDB                                   UltimateDB

    CODE
    
    RETURN oUltimateDB.SQLUpdate(pTbl)  

! -----------------------------------------------------------------------
!!! <summary>Delete record in database</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <remarks>Returns True on success, False on failure. Uses SQL
!!! to delete record using primary key value. Assumes that the primary
!!! key value has been filled into the record buffer. Example:
!!!     APinv:APInvoiceID = 1
!!!     db.SQLDelete(APinv)
!!! SQL Generated:
!!!     DELETE FROM tablename WHERE pk = pkValue</remarks>
! -----------------------------------------------------------------------        
UltimateSQL.Delete                      PROCEDURE(*FILE pTbl)   !, BYTE, PROC  

oUltimateDB                                 UltimateDB

    CODE
    
    RETURN oUltimateDB.SQLDelete(pTbl)        
        
        
! -----------------------------------------------------------------------
!!! <summary>Sends MultipleActiveResultSets Driver String</summary>           
!!! <param name="TrueFalse">Byte set to TRUE or FALSE</param>
! -----------------------------------------------------------------------                
UltimateSQL.MultipleActiveResultSets    PROCEDURE(BYTE pTrueFalse)

    CODE
        
    RETURN SELF.SendDriverString('/MULTIPLEACTIVERESULTSETS = ' & CHOOSE(pTrueFalse,'TRUE','FALSE'))
             
        
! -----------------------------------------------------------------------
!!! <summary>Sends VerifyViaSelect Driver String</summary>           
!!! <param name="TrueFalse">Byte set to TRUE or FALSE</param>
! -----------------------------------------------------------------------
UltimateSQL.VerifyViaSelect             PROCEDURE(BYTE pTrueFalse) 

    CODE
        
    RETURN SELF.SendDriverString('/VERIFYVIASELECT = ' & CHOOSE(pTrueFalse,'TRUE','FALSE'))
             
        
! -----------------------------------------------------------------------
!!! <summary>Sends SaveStoredProcedure Driver String</summary>           
!!! <param name="TrueFalse">Byte set to TRUE or FALSE</param>
! -----------------------------------------------------------------------
UltimateSQL.SaveStoredProcedure         PROCEDURE(BYTE pTrueFalse)

    CODE
       
    RETURN SELF.SendDriverString('/SAVESTOREDPROCEDURE = ' & CHOOSE(pTrueFalse,'TRUE','FALSE'))
            
        
! -----------------------------------------------------------------------
!!! <summary>Sends GatherAtOpen Driver String</summary>           
!!! <param name="TrueFalse">Byte set to TRUE or FALSE</param>
! -----------------------------------------------------------------------
UltimateSQL.GatherAtOpen                PROCEDURE(BYTE pTrueFalse)

    CODE
       
    RETURN SELF.SendDriverString('/GATHERATOPEN = ' & CHOOSE(pTrueFalse,'TRUE','FALSE'))            
        
        
! -----------------------------------------------------------------------
!!! <summary>Sends TurboSQL Driver String</summary>           
!!! <param name="TrueFalse">Byte set to TRUE or FALSE</param>
! -----------------------------------------------------------------------
UltimateSQL.TurboSQL                    PROCEDURE(BYTE pTrueFalse)

    CODE        
        
    RETURN SELF.SendDriverString('/TURBOSQL = ' & CHOOSE(pTrueFalse,'TRUE','FALSE'))
             
        
        
! -----------------------------------------------------------------------
!!! <summary>Sends IgnoreTruncation Driver String</summary>           
!!! <param name="TrueFalse">Byte set to TRUE or FALSE</param>
! -----------------------------------------------------------------------
UltimateSQL.IgnoreTruncation            PROCEDURE(BYTE pTrueFalse)

    CODE
        
    RETURN SELF.SendDriverString('/IGNORETRUNCATION = ' & CHOOSE(pTrueFalse,'TRUE','FALSE'))          
        
! -----------------------------------------------------------------------
!!! <summary>Sends BusyHandling Driver String</summary>           
!!! <param name="BusyHandling">Numeric from 1 to 4 indicating the type of BusyHandling to use</param>
! -----------------------------------------------------------------------
UltimateSQL.BusyHandling                PROCEDURE(BYTE pBusyHandling)        

    CODE
        
    RETURN SELF.SendDriverString('/BUSYHANDLING = ' & pBusyHandling)
        
        
        
! -----------------------------------------------------------------------
!!! <summary>Send a message to the File Driver</summary>
!!! <param name="Message">Message to send to the driver</param>
! -----------------------------------------------------------------------        
UltimateSQL.SendDriverString            PROCEDURE(STRING pMessage) !,STRING,PROC

    CODE
        
    RETURN SEND(QueryResults,CLIP(pMessage))
        
! -----------------------------------------------------------------------
!!! <summary>Turn on/off tracing</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Logfile">Name of file where trace is to occur</param>
!!! <remarks>Omitting the Logfile argument turns off tracing.</remarks>
! -----------------------------------------------------------------------        
UltimateSQL.Trace                       PROCEDURE(*FILE pTbl, <STRING pLogfile>)
        
oUltimateDB                                   UltimateDB

    CODE                                      
        
    oUltimateDB.SQLLog(pTbl,pLogfile)
    
    RETURN      
        
!-----------------------------------------
UltimateSQL.RemoveIllegalCharacters     PROCEDURE(String pString)
!-----------------------------------------
Result                                      String(5000)

    CODE
    Result = pString
    Y# = 1
    LOOP
        X# = INSTRING('<39>',Result,1,Y#)
        IF ~X#;BREAK.
        Result = SUB(Result,1,X#-1) & '<39><39>' & SUB(Result,X#+1,10000)
        Y# = X# + 2
    END

    RETURN Result        

		
!-----------------------------------------------------------------------
!.Construct - This procedure is recommended
!-----------------------------------------------------------------------
!----------------------------------------
UltimateSQL.Construct                   PROCEDURE()
!----------------------------------------
    CODE

    RETURN

		
!-----------------------------------------------------------------------
!.Destruct - This procedure is recommended
!-----------------------------------------------------------------------
!---------------------------------------
UltimateSQL.Destruct                    PROCEDURE()
!---------------------------------------
    CODE

    RETURN
		
		
!----------------------------------------------------------------------- 
! NOTES:
! Construct procedure executes automatically at the beginning of each procedure 
! Destruct procedure executes automatically at the end of each procedure
! Construct/Destruct Procedures are implicit under the hood but don't have to be declared in the class as such if there is no need.   
! It's ok to have them there for good measure, although some programmers only include them as needed.
! Normally some prefer Init() and Kill(),  but Destruct() can be handy to DISPOSE of stuff (to avoid mem leak)
!-----------------------------------------------------------------------  
        
!Comment Format below:

! -----------------------------------------------------------------------
!!! <summary>Description</summary>           
!!! <param name="Table">Database name</param>
!!! <remarks>Remarks.</remarks>
! -----------------------------------------------------------------------