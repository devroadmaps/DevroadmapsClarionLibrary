                                        Member()
                                        MAP
                                            UltimateDebugOutput(STRING pMessage)
                                        END

!*****************************************************************************************************************
!Copyright (C) 2007-2011 Rick Martin, rick.martin@upperparksolutions.com
!This software is provided 'as-is', without any express or implied warranty. In no event will the authors 
!be held liable for any damages arising from the use of this software. 
!Permission is granted to anyone to use this software for any purpose, 
!including commercial applications, subject to the following restrictions:
!1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. 
!   If you use this software in a product, an acknowledgment in the product documentation would be appreciated 
!   but is not required.
!2. You may not use this software in a commerical product whose primary purpose is a SQL/ODBC Interface.
!3. This notice may not be removed or altered from any source distribution.
!*****************************************************************************************************************

    Include('UltimateSQLConnect.Inc'),ONCE
    Include('UltimateString.INC'),ONCE  
    Include('WinAPI_Equ.INC'),ONCE

cTimeStampType                          group,Type
wYear                                       short
wMonth                                      ushort
wDay                                        ushort
wHour                                       ushort
wMin                                        ushort
wSec                                        ushort
frac                                        ulong
                                        end    

usc_db                                  UltimateDebug

UltimateSQLConnect.Construct            Procedure()  

    Code
        
        Self.ErrorMsg &= New(SQLErrorMsgQType)
        If Command('\DbgSQLMsgs')
            Self.ShowDiagMsgs = true
        End   
        
!  
UltimateSQLConnect.Destruct             Procedure()

    Code     
        
        If NOT Self.ErrorMsg &= Null
            Dispose(Self.ErrorMsg)
        End
!             
        
UltimateSQLConnect.DummyMethod          Procedure()

    Code
        
        usd_SQLDisconnect(0)
                      
        
UltimateSQLConnect.GetServerList        Procedure(Long myhenv,*ServerListQType SLQ)  

BrowseResult                                String(4096)
BrowseResultLen                             Short
lCnt                                        Short
startpos                                    Short
endpos                                      Short
hresult                                     Long
DriverStr                                   String(256)
ServerList                                  UltimateString

    Code
        
        If Self.GetNewHdbc(myHenv)
            DriverStr = 'Driver=SQL SERVER;'
            Free(SLQ)
            Clear(SLQ.SName)
            hresult = usd_SQLBrowseConnect(Self.hdbc,DriverStr,Len(Clip(DriverStr)),BrowseResult,Len(BrowseResult),BrowseResultLen)
            If hresult = UltimateSQL_NEED_DATA
                startpos = Instring('{{',BrowseResult,1,1) + 1
                endpos = Instring('}',BrowseResult,1,1) - 1
                If startpos > 0 and startpos < endpos
                    ServerList.Assign(BrowseResult[startpos : endpos])
                    ServerList.Split(',')
                    Loop lCnt = 1 To ServerList.Records()
                        SLQ.SName = ServerList.GetLine(lCnt)
                        Add(SLQ)
                    End
                End
            End
            Self.GetLastError(UltimateSQL_HANDLE_dbc,Self.hdbc)
!    If Len( Clip(SLQ.SName)) > 0
!      Add(SLQ)
!    End
        End
                
        
UltimateSQLConnect.GetDatabaseList      Procedure(Long myHenv, *cString server, *cString Login, *cString Password,Byte AuthType, *DatabaseListQType DLQ)    

BrowseResult                                String(4096)
BrowseResultLen                             Short
lCnt                                        Short
startpos                                    Short
endpos                                      Short
hresult                                     Long
DriverStr                                   String(256)
DatabaseList                                UltimateString   

    Code

        If Self.GetNewHdbc(myHenv)
            Assert(myHenv,'HENV not specified')
            If AuthType
      !No need to test hresult for error; if somethisg is wrong we ge an error in the next api call anyway
                hresult = usd_SQLSetConnectAttr(Self.hdbc, UltimateSQL_COPT_SS_INTEGRATED_SECURITY, UltimateSQL_IS_ON,UltimateSQL_IS_UINTEGER)
            End
            DriverStr = 'DRIVER=SQL SERVER;SERVER='&server&';UID='&Login&';PWD='&Password&';'
            Free(DLQ)
            Clear(DLQ.DName)
            hresult = usd_SQLBrowseConnect(Self.hdbc,DriverStr,Len(Clip(DriverStr)),BrowseResult,Len(BrowseResult),BrowseResultLen)
            If hresult = UltimateSQL_NEED_DATA
                startpos = Instring('{{',BrowseResult,1,1) + 1
                endpos = Instring('}',BrowseResult,1,1) - 1
                If startpos > 0 and startpos < endpos
                    DatabaseList.Assign(BrowseResult[startpos : endpos])
                    DatabaseList.Split(',')
                    Loop lCnt = 1 To DatabaseList.Records()
                        DLQ.DName = DatabaseList.GetLine(lCnt)
                        Add(DLQ)
                    End
                End
            End
            Self.GetLastError(UltimateSQL_HANDLE_dbc,Self.hdbc)
        End
         
    
UltimateSQLConnect.GetNewHdbc           PROCEDURE(Long myHenv)!,Byte  

ReturnValue                                 Byte(1)
hresult                                     Long

    CODE
        
!  Assert(Self.ODBCVersionSet,'You must call SetODBCVersion')
        If Self.hdbc
            hresult = usd_SQLDisconnect(Self.hdbc)
            If hresult = UltimateSQL_SUCCESS OR hresult = UltimateSQL_SUCCESS_WITH_INFO
                hresult = usd_SQLFreeHandle(UltimateSQL_HANDLE_DBC, Self.hdbc)
                If hresult <> UltimateSQL_SUCCESS
                    Self.GetLastError(UltimateSQL_HANDLE_dbc,Self.hdbc)
                    Return False
                End
            Else
                Self.GetLastError(UltimateSQL_HANDLE_dbc,Self.hdbc)
                Return False
            End
            Clear(Self.hdbc)
        End
        hresult = usd_SQLAllocHandle(UltimateSQL_HANDLE_DBC, myHenv, Self.hdbc);
        If hresult <> UltimateSQL_SUCCESS AND hresult <> UltimateSQL_SUCCESS_WITH_INFO
            ReturnValue = False
            Self.GetLastError(UltimateSQL_HANDLE_ENV,myHenv)
        End
        Return ReturnValue
      
        
UltimateSQLConnect.SetODBCVersion       PROCEDURE(Long myHenv) 

hresult                                     Long
AttResult                                   LONG
AttLength                                   LONG
strAttrLen                                  LONG

    CODE
        
        Self.ODBCVersionSet = True
  !Check if ODBC Version is 2 if it isn't, set the driver so that it will exhibit ODBC 2. behavior
        Hresult = usd_SQLGetEnvAttr(myHenv,UltimateSQL_ATTR_ODBC_VERSION,AttResult,AttLength,strAttrLen)
        IF (hresult = UltimateSQL_SUCCESS OR hresult = UltimateSQL_SUCCESS_WITH_INFO) AND AttResult <> 2
            hresult = usd_SQLSetEnvAttr(myHenv, UltimateSQL_ATTR_ODBC_VERSION, UltimateSQL_OV_ODBC2, 0)
        END
        If hresult <> UltimateSQL_SUCCESS AND hresult <> UltimateSQL_SUCCESS_WITH_INFO
            Self.GetLastError(UltimateSQL_HANDLE_ENV,myHenv)
        End
        RETURN
!       
        
UltimateSQLConnect.GetLastError         Procedure(Long HandleType, Long Handle)  

ErrorMessage                                STRING(300)  
lCnt                                        LONG

    Code
        
        Self.GetSQLMessages(HandleType, Handle)
        If Records(Self.ErrorMsg) AND Not Self.Quiet = SQLDirect:QuietModeTrue
            If Records(Self.ErrorMsg) = 1
!                Message('Message: '&clip(Self.ErrorMsg.ErrorMsg)&'|Sqlstate: '&Clip(Self.ErrorMsg.ErrorState),'SQL Statement Error',Icon:Exclamation)
                ErrorMessage = 'SQL Error: '& clip(Self.ErrorMsg.ErrorMsg) & '| Sqlstate: '& Clip(Self.ErrorMsg.ErrorState)
        
                IF SELF.ErrorShowInDebugView  
                    SELF.Debug(ErrorMessage)  
                END
            
                IF SELF.ErrorAppendToClipboard
                    SETCLIPBOARD(CLIP(CLIPBOARD()) & '<13,10,13,10>Error - ' & FORMAT(TODAY(),@D17) & ',' & FORMAT(CLOCK(),@T7) & '<13,10>' & CLIP(ErrorMessage))
                ELSIF SELF.ErrorAddToClipboard
                    SETCLIPBOARD(CLIP(ErrorMessage))
                END                
        
                IF SELF.ErrorShowAsMessage
                    MESSAGE(CLIP(ErrorMessage),'SQL Statement Error',Icon:Exclamation)
                END 
            Else       
                IF SELF.ErrorShowInDebugView 
                    Loop lCnt =1 To Records(Self.ErrorMsg)
                        Get(Self.ErrorMsg,lCnt)
                        SELF.Debug('SQL Error: '& clip(Self.ErrorMsg.ErrorMsg) & '| Sqlstate: '& Clip(Self.ErrorMsg.ErrorState))  
                    END
                END
            
                IF SELF.ErrorAppendToClipboard OR SELF.ErrorAddToClipboard
                    IF SELF.ErrorAddToClipboard
                        SETCLIPBOARD('')
                    END
                    Loop lCnt =1 To Records(Self.ErrorMsg)
                        Get(Self.ErrorMsg,lCnt)
                        SETCLIPBOARD(CLIP(CLIPBOARD()) & '<13,10,13,10>Error - ' & FORMAT(TODAY(),@D17) & ',' & FORMAT(CLOCK(),@T7) & '<13,10>' & Clip(Self.ErrorMsg.ErrorState) & ' - ' & Clip(Self.ErrorMsg.ErrorMsg) & '<0Dh,0Ah>')
                    END
                END                
        
                IF SELF.ErrorShowAsMessage
                    Self.DisplayErrorWindow()
                END 
            End
        End   
        
!
UltimateSQLConnect.ProcessNonErrorDiagnosticMsgs        Procedure()   

    Code
        
        Self.GetSQLMessages(UltimateSQL_HANDLE_STMT, Self.hstmt)
        If Self.ShowDiagMsgs AND Records(Self.ErrorMsg)
            Self.DisplayErrorWindow()
        End
!          
        
UltimateSQLConnect.GetSQLMessages       procedure(Long HandleType, Long Handle)

ErrorString                                 UltimateString
NativeErrorPtr                              Long
MessageText                                 CString(1024)
TextLengthPtr                               Short
Sqlstate                                    CString(5)
lCnt                                        LONG
error_Return                                LONG

    code
        
        Free(Self.ErrorMsg)
        lCnt = 1
        Loop
            error_Return = usd_SQLGetDiagRec(HandleType, Handle,lCnt,Sqlstate,NativeErrorPtr,MessageText,SIZE(MessageText)-1,TextLengthPtr)
            If error_Return = UltimateSQL_Success OR error_Return = UltimateSQL_Success_with_Info
                Do AddMessageToQueue
            Else
                Break
            End
            lCnt += 1
        End  
!       
        
AddMessageToQueue                       routine      
    
    Self.ErrorMsg.ErrorState = Sqlstate
    ErrorString.Assign(MessageText)
    ErrorString.Replace('[Microsoft]','')
    ErrorString.Replace('[ODBC SQL Server Driver]','')
    ErrorString.Replace('[SQL Server]','')
    Self.ErrorMsg.ErrorMsg = ErrorString.Get()
    Add(Self.ErrorMsg)
    If Command('/Debug')
!        UltimateDebugOutput('Message: '&clip(MessageText)&' - Sqlstate: '&Clip(Sqlstate))
        SELF.Debug('Message: '&clip(MessageText)&' - Sqlstate: '&Clip(Sqlstate))
    End 
!       
    
UltimateSQLConnect.DisplayErrorWindow   procedure()

lCnt                                        LONG
ErrorQueue                                  Queue(SQLErrorMsgQType)
                                            end
ErrorString                                 UltimateString
Window                                      WINDOW('SQL Errors List'),AT(,,401,223),GRAY,DOUBLE,CENTER
                                                LIST,AT(3,6,395,190),USE(?List1),HVSCROLL,FORMAT('39R(2)|M~Error State~@S5@100L(2)|M~Description~@s255@'), |
                                                    FROM(ErrorQueue)
                                                BUTTON('Copy'),AT(8,204,45,14),USE(?btnCopy),LEFT,ICON(ICON:Copy)
                                                BUTTON('Close'),AT(60,204,45,14),USE(?btnClose)
                                            END

    code
        
        If Records(Self.ErrorMsg) AND Not Self.Quiet = SQLDirect:QuietModeTrue
            Loop lCnt =1 To Records(Self.ErrorMsg)
                Get(Self.ErrorMsg,lCnt)
                ErrorQueue = Self.ErrorMsg
                Add(ErrorQueue)
                ErrorString.Append(Clip(Self.ErrorMsg.ErrorState) & ' - ' & Clip(Self.ErrorMsg.ErrorMsg) & '<0Dh,0Ah>')
            End
            open(window)
            accept
                case field()
                of ?btnCopy
                    SetClipBoard(ErrorString.Get())
                of ?btnClose
                    if event() = EVENT:Accepted
                        post(EVENT:CloseWindow)
                    end
                end
            end
        End
!       
        
UltimateSQLConnect.FreeConnection       Procedure()!,LONG,Proc

error_Return                                LONG

    Code
        
        If Self.hstmt  
            error_Return = usd_SQLFreeHandle(UltimateSQL_HANDLE_STMT, Self.hstmt);
        End
        error_Return = usd_SQLDisconnect(Self.hdbc);
        Return error_Return
!       
        
UltimateSQLConnect.SetAppRole           Procedure() !,Long

hresult                                     LONG        
SqlStmt                                     STRING(256)

    Code        
        
        If Self.AppRolename
            SqlStmt = '{{Call sp_setapprole(N''' & Self.AppRolename & ''',{{Encrypt N ''' & Self.AppRolePassword & '''}, ''odbc'' )}'
            hresult = usd_SQLExecDirect(Self.hstmt, SqlStmt, Len(Clip(SqlStmt)) )
            If hresult = UltimateSQL_SUCCESS OR hresult = UltimateSQL_SUCCESS_WITH_INFO
                usd_SQLFreeStmt(Self.hstmt,UltimateSQL_CLOSE+UltimateSQL_UNBIND+UltimateSQL_RESET_PARAMS)
            End
        End
        Return hresult
!       
        
UltimateSQLConnect.SetAppRoleInfo       Procedure(STRING pRoleName, STRING pPassword)

    Code
        
        Self.AppRolename = pRoleName 
        Self.AppRolePassword = pPassword 
!       
        
UltimateSQLConnect.BuildConnectionFromOwner     Procedure(STRING pOwner)!,STRING

OwnerString                                         UltimateString
ConnectionStr                                       UltimateString

    Code  
        
        OwnerString.Assign(pOwner)
        OwnerString.Split(',')
        ConnectionStr.Assign( 'DRIVER=<7Bh>SQL Server<7Dh>')

        ConnectionStr.Append(';Server='& OwnerString.GetLine(1))
        ConnectionStr.Append(';Database='& OwnerString.GetLine(2))
        If OwnerString.GetLine(3) = ''
            ConnectionStr.Append(';Trusted_Connection=yes')
        Else
            ConnectionStr.Append(';UID='& OwnerString.GetLine(3))
            ConnectionStr.Append(';PWD='& OwnerString.GetLine(4))
        End
        Return ConnectionStr.Get()
!       
        
UltimateSQLConnect.ConvertDateTime      PROCEDURE(cTimeStampType pSQLTimeStamp, *DATE CLADate, *TIME ClaTime)

    Code
        
        ClaDate=DATE(pSQLTimeStamp.wMonth,pSQLTimeStamp.wDay,pSQLTimeStamp.wYear)
        ClaTime=pSQLTimeStamp.whour*360000+pSQLTimeStamp.wmin*6000+pSQLTimeStamp.wsec*100+ pSQLTimeStamp.frac/10000000+1
        
        
UltimateDebugOutput                     PROCEDURE  (STRING pMessage)          ! Declare Procedure  

OrigHeight                                  UNSIGNED
OrigWidth                                   UNSIGNED
lCstr                                       &CSTRING

    CODE
        
        lCstr &= NEW(CSTRING(LEN(pMessage)+3))
        lCstr = pMessage & '<31,10>'
        api_OutputDebugString(lCstr)
        Dispose(lCstr)
