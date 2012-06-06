  OMIT('_EndOfInclude_',_UltimateSQLConnectPresent_)
_UltimateSQLConnectPresent_  EQUATE(1)
  PRAGMA('link(ODBC32.LIB)')

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
                                          
    Include('UltimateDebug.Inc'),ONCE

    INCLUDE('UltimateSQLConnect.equ'),once

!cTimeStampType group,Type
!wYear  short
!wMonth ushort
!wDay   ushort
!wHour  ushort
!wMin   ushort
!wSec   ushort
!frac   ulong
!  end

BackupSetQueueType                      Queue,TYPE
BackupName                                  CSTRING(129)
BackupDescription                           CSTRING(256)
BackupStartDate                             DATE
BackupStartTime                             TIME
BackupFinishDate                            DATE
BackupFinishTime                            TIME
                                        End

ConflictQueueType                       Queue,TYPE
ConfType                                    long
DataSource                                  CString(256)
ReasonText                                  CString(721)
UniqueValue                                 Long
GUIDColumn                                  CString(37)
ConfDateTime                                String(25)
PubID                                       CSTRING(37)
                                        End


SQLErrorMsgQType                        Queue,Type
ErrorState                                  CSTRING(6)
ErrorMsg                                    CSTRING(1024)
                                        End

ServerListQType                         Queue,Type
SName                                       String(50)
                                        End

DatabaseListQType                       Queue,Type
DName                                       String(126)
                                        End

!SQL Direct Equates
SQLDirect:FreeResults                   EQUATE(1)
SQLDirect:AppendResults                 EQUATE(0)
SQLDirect:QuietModeTrue                 EQUATE(1)
SQLDirect:QuietModeFalse                EQUATE(0)
SQLDirect:ProcessResultSets             EQUATE(1)
SQLDirect:CallerHandleResultSets        EQUATE(2)
 
UltimateSQLConnect                      CLASS(UltimateDebug),TYPE,MODULE('UltimateSQLConnect.CLW'),LINK('UltimateSQLConnect.CLW')   !,_UP_SQLClassesLinkMode_),DLL(_UP_SQLClassesDllMode_)   

QueryShowInDebugView                        BYTE(FALSE) ! Set to TRUE to send your Query to DebugView, FALSE to turn it off
QueryAddToClipboard                         BYTE(FALSE) ! Set to TRUE to send your Query to the Clipboard, FALSE to turn it off
QueryAppendToClipboard                      BYTE(FALSE) ! Set to TRUE to send your Query to the Clipboard, FALSE to turn it off

ErrorShowInDebugView                        BYTE(FALSE) ! Set to TRUE to send your error to DebugView, FALSE to turn it off
ErrorAddToClipboard                         BYTE(FALSE) ! Set to TRUE to send your error to the Clipboard, FALSE to turn it off
ErrorAppendToClipboard                      BYTE(FALSE) ! Set to TRUE to send your error to the Clipboard, FALSE to turn it off
ErrorShowAsMessage                          BYTE(FALSE) ! Set to TRUE to display your error as a Message, FALSE to turn it off

ODBCVersionSet                              Byte
Hdbc                                        Long
henv                                        Long
hwnd                                        Long
hstmt                                       Long
Quiet                                       LONG
ShowDiagMsgs                                LONG
CurrentResult                               Short
ErrorMsg                                    &SQLErrorMsgQType
AppRolename                                 CSTRING(76)
AppRolePassword                             CSTRING(76)
Construct                                   Procedure()
Destruct                                    Procedure()
DisplayErrorWindow                          procedure()
DummyMethod                                 Procedure()
BuildConnectionFromOwner                    Procedure(STRING pOwner),STRING
ConvertDateTime                             PROCEDURE(cTimeStampType pSQLTimeStamp, *DATE CLADate, *TIME ClaTime)
FreeConnection                              Procedure(),LONG,Proc
GetDatabaseList                             Procedure(Long myHenv, *cString server, *cString Login, *cString Password,Byte AuthType, *DatabaseListQType DLQ)
GetLastError                                Procedure(Long HandleType, Long Handle)
GetSQLMessages                              procedure(Long HandleType, Long Handle)
GetNewHdbc                                  Procedure(Long myHenv),Byte
GetServerList                               Procedure(Long myHenv, *ServerListQType SLQ)
ProcessNonErrorDiagnosticMsgs               Procedure()
SetAppRoleInfo                              Procedure(STRING pRoleName, STRING pPassword)
SetAppRole                                  Procedure(),LONG
SetODBCVersion                              PROCEDURE(Long myHenv)
                                        END
    _EndOfInclude_
