  OMIT('_EndOfInclude_',_UltimateSQLDIRECTSupportPresent_)
_UltimateSQLDIRECTSupportPresent_  EQUATE(1)
 Map
 End

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
 
SQLResultsColumnDefType                 Queue,Type
SQLColumnName                               CSTRING(101)
SQLColumnType                               SHORT
                                        End
SQLResultsRowQueueType                  Queue,Type
SQLColumnValue                              &STRING
                                        End
SQLResultsQueueType                     Queue,Type
SQLColumns                                  &SQLResultsRowQueueType
                                        End
SQLResultsSetsQueueType                 Queue,Type
ResultSet                                   &SQLResultsQueueType
ColumnDescriptions                          &SQLResultsColumnDefType
Stmt                                        &STRING
MessageQ                                    &SQLErrorMsgQType
                                        End  

!  
UltimateSQLDirect                       CLASS(UltimateSQLConnect),TYPE,MODULE('UltimateSQLDirect.CLW'),LINK('UltimateSQLDirect.CLW')  !,_UltimateSQLClassesLinkMode_),DLL(_UltimateSQLClassesDllMode_)
!Attributes  

SQLColCount                                 LONG
StatementCompleted                          LONG
CurrentStmt                                 &STRING
ResultSets                                  &SQLResultsSetsQueueType
CurrentResultSet                            &SQLResultsQueueType
CurrentColumnDescriptor                     &SQLResultsColumnDefType
!Methods
AddMessagesToResultSet                      Procedure()
AddResultRow                                Procedure(),LONG
AssignCurrentResultSet                      Procedure()
AssignCurrentResultSet                      Procedure(LONG pResultSet),LONG
CancelStatement                             PROCEDURE()
CloseConnection                             Procedure()
Construct                                   Procedure()
Destruct                                    Procedure() !Call Close connection if not closed
ExecDirect                                  Procedure(String SqlStmt, LONG pFreeResults=1, LONG pQuiet=0, LONG pProcessResultSets=1),Byte,Proc
ExecDirectContinue                          Procedure(LONG pProcessResultSets=1),Byte,Proc
ExecDirectSingleValue                       Procedure(*? pUpdateField, String SqlStmt, long pRow=1, long pColumn=1, LONG pQuiet=0),LONG,proc
FreeAllResultSets                           Procedure()
FreeResultRow                               Procedure(SQLResultsRowQueueType pResultRowQ)
FreeResultSet                               Procedure()
GatherColumnInfo                            Procedure(),LONG
GetColumnName                               Procedure(LONG pColumn),String
GetColumnValue                              Procedure(LONG pRow, LONG pCol),STRING
GetResultSetMessages                        procedure(<String pSeperator>),string  
GetStmtForPresentation                      Procedure(STRING pStmt),STRING,VIRTUAL
InitializeResultSet                         Procedure(STRING pStmt)
NumberOfResultSets                          Procedure(),LONG
OpenConnection                              Procedure(*FILE pFile),LONG
OpenConnection                              Procedure(String connectionStr, Long pHenv, Long pHwnd),Byte
ProcessResultSet                            PROCEDURE(),LONG
SaveResultsToCSV                            Procedure(String pFileName) ,LONG,Proc
                                        END

UltimateSQLResultsViewClass             CLASS(),TYPE,MODULE('UltimateSQLDirect.CLW'),LINK('UltimateSQLDirect.CLW')  !,_UltimateSQLClassesLinkMode_),DLL(_UltimateSQLClassesDllMode_)
MaxColumns                                  LONG
DefaultColumnWidth                          LONG
ochanges                                    LONG,PRIVATE
CurrentResultSet                            &SQLResultsQueueType
CurrentColumnDescriptor                     &SQLResultsColumnDefType
!
Construct                                   Procedure()
DisplayResults                              Procedure(UltimateSQLDirect pSQLDirect, <STRING pTitle>)
GetColumnName                               Procedure(LONG pColumn),String
GetListFormat                               Procedure(),STRING
Init                                        PROCEDURE(SIGNED pfeq, *SQLResultsQueueType pResultSet, *SQLResultsColumnDefType pColumnDescriptor)
NumberOfListBoxColumns                      Procedure() ,Long
VLBproc                                     PROCEDURE(LONG row, SHORT col),STRING
                                        End
 _EndOfInclude_
