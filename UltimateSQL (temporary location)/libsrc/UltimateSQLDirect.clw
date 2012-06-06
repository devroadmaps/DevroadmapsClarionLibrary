  Member()
  MAP
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


  Include('UltimateSQLDirect.Inc'),ONCE
  Include('UltimateString.INC'),ONCE     

!  INCLUDE('SpecialFolder.inc'), ONCE
!  INCLUDE('CSIDL.EQU'), ONCE

  PRAGMA('link(C%V%ASC%X%%L%.LIB)')

!
UltimateSQLDirect.AddMessagesToResultSet        Procedure()

lCnt                                                LONG         

    Code
        
        Loop lCnt = 1 To Records(Self.ErrorMsg)
            Get(Self.ErrorMsg,lCnt)
            Self.ResultSets.MessageQ = Self.ErrorMsg
            Add(Self.ResultSets.MessageQ)
        End
!
        
UltimateSQLDirect.AddResultRow          Procedure()

ReturnValue                                 LONG(Level:Benign)
hresult                                     LONG,AUTO
lCnt                                        LONG,AUTO
ColBuffer                                   CSTRING(1024)
ColData                                     UltimateString
ColDataLength                               LONG

    Code
        
        If Not Records(Self.CurrentColumnDescriptor)
            R# = Self.GatherColumnInfo()
        End   
        
        Clear(Self.CurrentResultSet)
        Self.CurrentResultSet.SQLColumns &= New(SQLResultsRowQueueType)
        Add(Self.CurrentResultSet)
        Loop lCnt = 1 To Self.SQLColCount
            ColData.Assign('')
            LOOP
                hresult = usd_SQLGetData(self.hstmt, lCnt, UltimateSQL_C_CHAR, Address(ColBuffer), Size(ColBuffer), ColDataLength)
                If hresult = UltimateSQL_Success OR hresult = UltimateSQL_Success_with_Info
                    If ColDataLength > 0
                        If ColDataLength > Size(ColBuffer)
                            ColData.Append(ColBuffer)
                        Else
                            ColData.Append(ColBuffer[1 : ColDataLength])
                        End
                    End
                ElsIf hresult=UltimateSQL_No_Data 
                    Break
                Else
                    ReturnValue = Level:Notify
                    Self.GetLastError(UltimateSQL_HANDLE_STMT,Self.hstmt)
                    Break
                End
            End 
            If ReturnValue = Level:Notify
                Break
            ElsIf ColData.Length()
                Clear(Self.CurrentResultSet.SQLColumns)
                Self.CurrentResultSet.SQLColumns.SQLColumnValue &= New(STRING(ColData.Length()))
                Self.CurrentResultSet.SQLColumns.SQLColumnValue = ColData.Get()
                Add(Self.CurrentResultSet.SQLColumns)
            End
        End   
        
        Return ReturnValue
!
        
UltimateSQLDirect.AssignCurrentResultSet        Procedure(LONG pResultSet) !,LONG

RetVal                                              LONG(Level:Benign)

    Code
        
        If pResultSet <= Records(Self.ResultSets)
            Get(Self.ResultSets,pResultSet)
            Self.AssignCurrentResultSet()
        Else
            RetVal = Level:Notify
        End
        Return RetVal
!
        
UltimateSQLDirect.AssignCurrentResultSet        Procedure()

    Code
        
        Self.CurrentResultSet &= Self.ResultSets.ResultSet
        Self.CurrentColumnDescriptor &= Self.ResultSets.ColumnDescriptions
        Self.CurrentStmt &= Self.ResultSets.Stmt
!
        
UltimateSQLDirect.CancelStatement       PROCEDURE()

StartTime                                   LONG

    Code
        
        z# = usd_SQLCancel(Self.hstmt)
        If z# = UltimateSQL_Error
            Self.GetLastError(UltimateSQL_HANDLE_STMT,Self.hstmt)
            Self.AddMessagesToResultSet()
        ELSE
            Loop 
                Case usd_SQLExecDirect(self.hstmt, Self.CurrentStmt, Len(Clip(Self.CurrentStmt)) )
                Of UltimateSQL_STILL_EXECUTING
                    Cycle
                ELSE
                    BREAK
                END
      !Should we do something here in case it doesn't cancel right away?
            END
        END
!
        
UltimateSQLDirect.CloseConnection       Procedure()

hresult                                     Short

    Code
        
        if self.hstmt
            hresult = usd_SQLFreeHandle(UltimateSQL_HANDLE_STMT, self.hstmt)
            If hresult <> UltimateSQL_SUCCESS AND hresult <> UltimateSQL_SUCCESS_WITH_INFO
                Self.GetLastError(UltimateSQL_HANDLE_ENV,self.henv)
            End
        END

        if self.hdbc
            hresult = usd_SQLDisconnect(self.hdbc)
            If hresult <> UltimateSQL_SUCCESS AND hresult <> UltimateSQL_SUCCESS_WITH_INFO
                Self.GetLastError(UltimateSQL_HANDLE_dbc,self.hdbc)
            End

            hresult = usd_SQLFreeHandle(UltimateSQL_HANDLE_DBC, self.hdbc)
            If hresult <> UltimateSQL_SUCCESS AND hresult <> UltimateSQL_SUCCESS_WITH_INFO
                Self.GetLastError(UltimateSQL_HANDLE_dbc,self.hdbc)    
            End
            Clear(self.hstmt)
        END
!
        
UltimateSQLDirect.Construct             Procedure()

    Code
        
        If Self.ResultSets &= NULL
            Self.ResultSets &= New(SQLResultsSetsQueueType)
        End
!
        
UltimateSQLDirect.Destruct              Procedure()

lCnt                                        LONG

    Code
        
        If self.hstmt
            Assert(0,'You forgot to close connection')
            self.CloseConnection()
        End
        Self.FreeAllResultSets()
!
        
UltimateSQLDirect.ExecDirect            Procedure(String SqlStmt, LONG pFreeAllResults=1, LONG pQuiet=0, LONG pProcessResultSets=1)!,Byte,Proc

ReturnValue                                 LONG(UltimateSQL_Success)

    Code
        
        Self.Quiet = pQuiet
        If pFreeAllResults = SQLDirect:FreeResults
            Self.FreeAllResultSets()
        End  
        Self.StatementCompleted = false
        Self.InitializeResultSet(SQLStmt)
        if pProcessResultSets = SQLDirect:CallerHandleResultSets
            If usd_SQLSetStmtAttr(self.hstmt, UltimateSQL_ATTR_ASYNC_ENABLE, UltimateSQL_ASYNC_ENABLE_ON, 0) <> UltimateSQL_Success
                pProcessResultSets = SQLDirect:ProcessResultSets
            END
        END 
        Loop
            Self.CurrentResult = usd_SQLExecDirect(self.hstmt, Self.CurrentStmt, Len(Clip(Self.CurrentStmt)) )
            Case Self.CurrentResult
            Of UltimateSQL_Success OROF UltimateSQL_Success_with_Info  
                ReturnValue = Self.ProcessResultSet()
                Self.StatementCompleted = true
                Break
            OF UltimateSQL_STILL_EXECUTING             
                If pProcessResultSets = SQLDirect:ProcessResultSets
                    Cycle
                ELSE
                    ReturnValue = Self.CurrentResult
                    BREAK
                END
            Of UltimateSQL_NO_DATA
                ReturnValue = UltimateSQL_Success
            Else
                Self.GetLastError(UltimateSQL_HANDLE_STMT,Self.hstmt)
                Self.AddMessagesToResultSet()
                If pProcessResultSets = SQLDirect:CallerHandleResultSets
                    Self.CancelStatement()
                END
                ReturnValue = UltimateSQL_Error
                Break
            End
        End 
        Return ReturnValue
! 
        
UltimateSQLDirect.ExecDirectContinue    Procedure(LONG pProcessResultSets=1)!,Byte,Proc

ReturnValue                                 LONG(UltimateSQL_Success)

    Code
        
        if NOT Self.StatementCompleted 
            Self.CurrentResult = usd_SQLExecDirect(self.hstmt, Self.CurrentStmt, Len(Clip(Self.CurrentStmt)) )
            Case Self.CurrentResult
            Of UltimateSQL_Success OROF UltimateSQL_Success_with_Info 
                If pProcessResultSets = SQLDirect:ProcessResultSets
                    ReturnValue = Self.ProcessResultSet()
                ELSE
                    ReturnValue = Self.CurrentResult
                END
                Self.StatementCompleted = true
            OF UltimateSQL_STILL_EXECUTING
                ReturnValue = Self.CurrentResult
            Else
                Self.GetLastError(UltimateSQL_HANDLE_STMT,Self.hstmt)
                Self.AddMessagesToResultSet()
                Self.CancelStatement()
                Self.StatementCompleted = true
                ReturnValue = UltimateSQL_Error
            End
        END
        Return ReturnValue
!
        
UltimateSQLDirect.ExecDirectSingleValue         Procedure(*? pUpdateField, String SqlStmt, long pRow=1, long pColumn=1, LONG pQuiet=0)!,LONG

ReturnValue                                         long

    code
        
        clear(pUpdateField)
        ReturnValue = self.ExecDirect(SqlStmt,,pQuiet,SQLDirect:ProcessResultSets)
        if ReturnValue = UltimateSQL_Success
            if self.AssignCurrentResultSet(1) = Level:Benign
                pUpdateField = Self.GetColumnValue(pRow,pColumn)
            end
        end
        return ReturnValue
!       
        
UltimateSQLDirect.FreeAllResultSets     Procedure()

lCnt                                        LONG

    Code
        
        If NOT Self.ResultSets &= NULL
            Loop lCnt = 1 To Records(Self.ResultSets)
                Get(Self.ResultSets,lCnt)
                If Not Self.ResultSets.ResultSet &= NULL
                    Self.AssignCurrentResultSet()
                    Self.FreeResultSet()
                    If NOT Self.CurrentResultSet &= NULL
                        Dispose(Self.CurrentResultSet)
                    End
                    If Not Self.ResultSets.ColumnDescriptions &= NULL
                        Dispose(Self.ResultSets.ColumnDescriptions)
                    End
                End
                If Not Self.ResultSets.Stmt &= NULL
                    Dispose(Self.ResultSets.Stmt)
                End
                If Not Self.ResultSets.MessageQ &= NULL
                    Dispose(Self.ResultSets.MessageQ)
                End
            End
            Free(Self.ResultSets)
        End
!
        
UltimateSQLDirect.FreeResultRow         Procedure(SQLResultsRowQueueType pResultRowQ)

lCnt                                        LONG

    Code
        
        Loop lCnt = 1 To Records(pResultRowQ)
            Get(pResultRowQ,lCnt)
            Do DisposeColumn
        End
        Free(pResultRowQ)
!
DisposeColumn                           Routine
    
    If NOT pResultRowQ.SQLColumnValue &= NULL
        Dispose(pResultRowQ.SQLColumnValue)
    End
!
    
UltimateSQLDirect.FreeResultSet         Procedure()

lCnt                                        LONG

    Code
        
        If Not Self.CurrentResultSet &= NULL
            Loop lCnt = Records(Self.CurrentResultSet) To 1 By -1
                Get(Self.CurrentResultSet,lCnt)
                Do FreeResultRow
            End
            Free(Self.CurrentResultSet)
        End

FreeResultRow                           Routine
    
    If Not Self.CurrentResultSet.SQLColumns &= Null
        Self.FreeResultRow(Self.CurrentResultSet.SQLColumns)
        Dispose(Self.CurrentResultSet.SQLColumns)
        Delete(Self.CurrentResultSet)
    End
!   
    
UltimateSQLDirect.GatherColumnInfo      Procedure()

hresult                                     LONG,AUTO
NameLength                                  SHORT,AUTO
SQLColumnSize                               LONG,AUTO
DecimalDigits                               SHORT,AUTO
Nullable                                    SHORT,AUTO
ReturnValue                                 LONG(Level:Benign)
lCnt                                        LONG

    Code
        
        Loop lCnt = 1 To Self.SQLColCount
            hresult = usd_SQLDescribeCol(self.hstmt                                  |
                ,lCnt                                        |
                ,Self.CurrentColumnDescriptor.SQLColumnName         |
                ,SIZE(Self.CurrentColumnDescriptor.SQLColumnName)   |
                ,NameLength                                  |
                ,Self.CurrentColumnDescriptor.SQLColumnType         |
                ,SQLColumnSize                               |
                ,DecimalDigits                               |
                ,Nullable)
                            
            If hresult = UltimateSQL_Success OR hresult = UltimateSQL_Success_with_Info
                Add(Self.CurrentColumnDescriptor)
            Else
                ReturnValue = Level:Notify
                Self.GetLastError(UltimateSQL_HANDLE_STMT,Self.hstmt)
                Break
            End
        End  
        Return ReturnValue
!       
        
UltimateSQLDirect.GetColumnName         Procedure(LONG pColumn) !,String

    Code
        
        Get(Self.CurrentColumnDescriptor,pColumn)
        If ErrorCode()
            Return ''
        Else
            Return Self.CurrentColumnDescriptor.SQLColumnName
        End
        
!
UltimateSQLDirect.GetColumnValue        Procedure(LONG pRow, LONG pCol) !,STRING 

ColumnValue                                 UltimateString

    Code
        
        ColumnValue.Assign('')
        Get(Self.CurrentResultSet,pRow)
        If Not ErrorCode() AND NOT Self.CurrentResultSet.SQLColumns &= NULL
            Get(Self.CurrentResultSet.SQLColumns,pCol)
            If Not ErrorCode() AND NOT Self.CurrentResultSet.SQLColumns.SQLColumnValue &= NULL
                ColumnValue.Assign(Self.CurrentResultSet.SQLColumns.SQLColumnValue)
            End
        End
        Return ColumnValue.Get()
!       
        
UltimateSQLDirect.GetResultSetMessages          procedure(<String pSeperator>)!,string  
Messages                                            UltimateString
SeparatorChars                                      UltimateString
lCnt                                                long
    code
        If Omitted(pSeperator)
            SeparatorChars.Assign('|')
        else
            SeparatorChars.Assign(pSeperator)
        end
        Loop lCnt = 1 To Records(Self.ResultSets.MessageQ)
            Get(Self.ResultSets.MessageQ,lCnt)
            if not ERRORCODE()
                If lCnt > 1
                    Messages.Append(SeparatorChars.Get())
                end
                Messages.Append(Self.ResultSets.MessageQ.ErrorState & ' - ' & Clip(Self.ResultSets.MessageQ.ErrorMsg))
            End
        End
        Return Messages.Get()
!
UltimateSQLDirect.GetStmtForPresentation        Procedure(STRING pStmt) !,STRING,VIRTUAL

SubStmt                                             UltimateString  

    Code
        
        SubStmt.Assign(pStmt)
        If SubStmt.Contains('<13,10>')
            SubStmt.Split('<13,10>')
            SubStmt.Assign(SubStmt.GetLine(1))
        End
        If SubStmt.Length() > 512
            SubStmt.Assign(SubStmt.Sub(1,512))
        End
        Return SubStmt.Get()
        
!
UltimateSQLDirect.InitializeResultSet   Procedure(STRING pStmt)

    Code
        Self.FreeAllResultSets() 
        Clear(Self.ResultSets)              
        Self.ResultSets.ResultSet &= New(SQLResultsQueueType)
        Self.ResultSets.ColumnDescriptions &= New(SQLResultsColumnDefType)
        Self.ResultSets.MessageQ           &= NEW(SQLErrorMsgQType)
        Self.ResultSets.Stmt               &= NEW(STRING(LEN(Clip(Left(pStmt)))))
        Self.ResultSets.Stmt               = Clip(Left(pStmt))
        Add(Self.ResultSets)
        Self.AssignCurrentResultSet()
        
        
!
UltimateSQLDirect.NumberOfResultSets    Procedure() !,LONG 

    Code
        
        Return Records(Self.ResultSets)
        
!
UltimateSQLDirect.OpenConnection        Procedure(*FILE pFile)!,LONG

    code
        
        RETURN Self.OpenConnection(Self.BuildConnectionFromOwner(pFile{Prop:Owner}),pFile{PROP:HENV},pFile{PROP:Handle})
        
!  
UltimateSQLDirect.OpenConnection        Procedure(String pConnectionStr, Long pHenv, Long pHwnd)!,LONG

hresult                                     Short
ReturnValue                                 Byte(Level:Benign)
ConnStrInfo                                 String(1024)
ConnectionStr                               String(1024)
cbCsOut                                     Short 
SQL_IS_UINTEGER                             LONG


    Code                     
        
        If self.hstmt
            Assert(0,'Connection already open')
            Return Level:Benign
        End

        self.henv = pHenv
        self.hwnd = pHwnd
        ConnectionStr = pConnectionStr
        hresult = usd_SQLAllocHandle(UltimateSQL_HANDLE_DBC, self.henv, self.hdbc); 
        If hresult = UltimateSQL_SUCCESS OR hresult = UltimateSQL_SUCCESS_WITH_INFO   
            hresult = usd_SQLSetConnectAttr(SELF.Hdbc,SQL_COPT_SS_MARS_ENABLED,SQL_MARS_ENABLED_YES,SQL_IS_UINTEGER)
            hresult = usd_SQLDriverConnect(self.hdbc,self.hwnd,ConnectionStr,Len(clip(ConnectionStr)),ConnStrInfo,Len(ConnStrInfo),cbCsOut,UltimateSQL_DRIVER_NOPROMPT)
            If hresult = UltimateSQL_SUCCESS OR hresult = UltimateSQL_SUCCESS_WITH_INFO
                hresult = usd_SQLAllocHandle(UltimateSQL_HANDLE_STMT, self.hdbc, self.hstmt)
                If hresult = UltimateSQL_SUCCESS OR hresult = UltimateSQL_SUCCESS_WITH_INFO
                    hresult = Self.SetAppRole()
                    If hresult = UltimateSQL_SUCCESS OR hresult = UltimateSQL_SUCCESS_WITH_INFO
                    Else
                        Self.GetLastError(UltimateSQL_HANDLE_STMT,Self.hstmt)
                        ReturnValue = Level:Notify
                    End
                Else
                    Self.GetLastError(UltimateSQL_HANDLE_dbc,self.hdbc)
                    ReturnValue = Level:Notify
                End
            Else          
                Self.GetLastError(UltimateSQL_HANDLE_dbc,self.hdbc)
                ReturnValue = Level:Notify
            End
        Else
            Self.GetLastError(UltimateSQL_HANDLE_ENV,self.henv)
            ReturnValue = Level:Notify
        End   
        Return ReturnValue
        
!
UltimateSQLDirect.ProcessResultSet   PROCEDURE()!,LONG
lFirstSet                         LONG(true)
error_Return                      LONG
ReturnValue                                 LONG(UltimateSQL_Success)

  Code
        Loop            
            If NOT lFirstSet   
                Self.CurrentResult = usd_SQLMoreResults(Self.hstmt)
                Case Self.CurrentResult
                Of UltimateSQL_NO_DATA   
                    BREAK
                OF UltimateSQL_Success
                OROF UltimateSQL_Success_with_Info
                    Self.InitializeResultSet(Self.CurrentStmt)
                ELSE
                    Self.GetLastError(UltimateSQL_HANDLE_STMT,Self.hstmt)
                    ReturnValue = UltimateSQL_Error
                    Break
                END        
            ELSE
                lFirstSet = false
            END                  
            
            If Self.CurrentResult = UltimateSQL_Success_with_Info
      !Process the diagnostic messages (these will be the PRINT statements plus anything else the driver returns
                Self.ProcessNonErrorDiagnosticMsgs()
                Self.AddMessagesToResultSet()
            End          
            
    !Check to make sure there is an actual result set returned. The column count will be zero if there is no set.
            error_Return = usd_SQLNumResultCols(Self.hstmt, Self.SQLColCount);
            If error_Return = UltimateSQL_Error
                Self.GetLastError(UltimateSQL_HANDLE_STMT,Self.hstmt)
                ReturnValue = UltimateSQL_Error
                Break
            End          
            
    !Get Result Set
            If Self.SQLColCount > 0 !Note we are only doing the SQLFetch if there is a result set
                Loop While (Self.CurrentResult = UltimateSQL_Success OR Self.CurrentResult = UltimateSQL_Success_with_Info) 
                    Self.CurrentResult = usd_SQLFetch(Self.hstmt)
                    If Self.CurrentResult = UltimateSQL_Success OR Self.CurrentResult = UltimateSQL_Success_with_Info
                        If Self.AddResultRow() <> Level:Benign
                            ReturnValue = UltimateSQL_Error
                            Break
                        End
                    ElsIf Self.CurrentResult = UltimateSQL_ERROR
                        Self.GetLastError(UltimateSQL_HANDLE_STMT,Self.hstmt)
                        Self.AddMessagesToResultSet()
                        ReturnValue = UltimateSQL_Error
                        Break
                    End
                End     
            End
        End   
        RETURN ReturnValue
        
!
UltimateSQLDirect.SaveResultsToCSV   Procedure(String pFileName) !,LONG
AsciiOutput FILE,DRIVER('ASCII'),CREATE,PRE(OUT)
Record  Record
Output        STRING(65520)
        End
            End
lCnt    LONG            
  Code
  AsciiOutput{Prop:Name} = pFileName
  Create(AsciiOutput)
  If ErrorCode()
    Do HandleError
  Else
    Open(AsciiOutput)
    If ErrorCode()
      Do HandleError
    Else
      Loop lCnt = 1 To Records(Self.ResultSets)
        Get(Self.ResultSets,lCnt)
        If ErrorCode()
          Break
        End
        Do WriteResultSet
      End
      Close(AsciiOutput)
    End
  End
  Return Level:Benign
!
WriteResultSet Routine
  Data
lRowCnt LONG
lColCnt LONG
CSVOutput UltimateString
  Code
  If NOT Self.ResultSets.ResultSet &= NULL
    If Pointer(Self.ResultSets) > 1
      Do WriteBlankRow
    End
    Do WriteStatementRow
    Do WriteMessages
    Do WriteColumnHeaderRow
    Loop lRowCnt = 1 To Records(Self.ResultSets.ResultSet)
      Get(Self.ResultSets.ResultSet,lRowCnt)
      Do WriteResultRow
    End
  End
!  
WriteResultRow  Routine
  Data
lColCnt LONG
CSVOutput UltimateString
CleanColumnValue  UltimateString
  Code
  Loop lColCnt = 1 To Records(Self.ResultSets.ResultSet.SQLColumns)
    Get(Self.ResultSets.ResultSet.SQLColumns,lColCnt)
    If ErrorCode()
      Cycle
    End
    If NOT Self.ResultSets.ResultSet.SQLColumns.SQLColumnValue &= NULL
      CleanColumnValue.Assign(Self.ResultSets.ResultSet.SQLColumns.SQLColumnValue)
      If CleanColumnValue.Contains('''')
        CleanColumnValue.Assign('''' & CleanColumnValue.Get() & '''')
      End
      CSVOutput.Append(CleanColumnValue.Get() & ',')
    Else
      CSVOutput.Append(',')
    End
  End
  If CSVOutput.Length() > 1
    CSVOutput.Assign(CSVOutput.Sub(1,CSVOutput.Length()-1))
  End
  OUT:Output = CSVOutput.Get()
  Do WriteRowToFile
!  
WriteColumnHeaderRow  Routine
  Data
lColCnt LONG
CSVOutput UltimateString
  Code
  OUT:Output = 'Result Set: ' & Pointer(Self.ResultSets)
  Do WriteRowToFile
  If Not Self.ResultSets.ColumnDescriptions &= NULL
    Loop lColCnt = 1 To Records(Self.ResultSets.ColumnDescriptions)
      Get(Self.ResultSets.ColumnDescriptions,lColCnt)
      If ErrorCode()
        Cycle
      End
      CSVOutput.Append(Self.ResultSets.ColumnDescriptions.SQLColumnName & ',')
    End
    If CSVOutput.Length() > 1
      CSVOutput.Assign(CSVOutput.Sub(1,CSVOutput.Length()-1))
    End
    OUT:Output = CSVOutput.Get()
    Do WriteRowToFile
  End
!
WriteStatementRow Routine  
  If NOT Self.ResultSets.Stmt &= NULL
    OUT:Output = Self.GetStmtForPresentation(Self.ResultSets.Stmt)
    Do WriteRowToFile
  End
!  
WriteMessages Routine
  Data
lCnt  LONG  
MessageString UltimateString
  Code
  Loop lCnt = 1 To Records(Self.ResultSets.MessageQ)
    Get(Self.ResultSets.MessageQ,lCnt)
    MessageString.Assign(Clip(Self.ResultSets.MessageQ.ErrorMsg))
    If MessageString.Contains('''')
      MessageString.Assign('''' & MessageString.Get() & '''')
    End
    OUT:Output = Self.ResultSets.MessageQ.ErrorState & ',' & MessageString.Get()
    Do WriteRowToFile
  End
  If Records(Self.ResultSets.MessageQ)
    Do WriteBlankRow
  End
!
WriteBlankRow Routine
  Clear(OUT:Output)
  Do WriteRowToFile
!
WriteRowToFile  Routine
  Add(AsciiOutput)
  If ErrorCode()
    Do HandleError
  End
!
HandleError Routine
  If ErrorCode()
    Message('Error creating SQL Result CSV File|' & Error() & ' (' & ErrorCode() & ')','Error',ICON:Asterisk)
  End
  
!!
!!
!!
UltimateSQLResultsViewClass.Construct               Procedure()
  Code
  Self.MaxColumns = 15
  Self.DefaultColumnWidth = 45
!  
UltimateSQLResultsViewClass.DisplayResults   Procedure(UltimateSQLDirect pSQLDirect, <STRING pTitle>)
ResultsWindow                                       WINDOW('SQL Results'),AT(,,491,297),CENTER,GRAY,SYSTEM, |
                                                        FONT('Tahoma',8,,,CHARSET:DEFAULT),VSCROLL
                                                        SHEET,AT(2,23,487,258),USE(?Sheet1)
                                                            TAB('Results'),USE(?tabResults)
                                                                STRING('Statement'),AT(8,44,361,10),USE(?strStmt)
                                                                LIST,AT(8,57,475,222),USE(?ResultsList),HVSCROLL,FORMAT('40L(2)*')
                                                            END
                                                            TAB('Messages'),USE(?tabMessages)
                                                                TEXT,AT(7,41,477,235),USE(?MsgText),BOXED,VSCROLL,READONLY
                                                            END
                                                        END
                                                        STRING('Total Number of Result Sets: '),AT(3,286),USE(?strNumResultSets),LEFT
                                                        BUTTON('&Close'),AT(438,2,45,14),USE(?btnClose),SKIP,ICON('WACLOSE.ICO'), |
                                                            DEFAULT,LEFT
                                                        BUTTON('&Save'),AT(389,2,45,14),USE(?btnSave),SKIP,ICON('SAVE.ico'),LEFT
                                                    END
lFEQ                                      LONG
lStrFEQ                                   LONG
lCnt                                      LONG
lResultsFound                             LONG
CurSQLResults                             &UltimateSQLResultsViewClass
SQLResultsCL1                             UltimateSQLResultsViewClass
SQLResultsCL2                             UltimateSQLResultsViewClass
SQLResultsCL3                             UltimateSQLResultsViewClass
SQLResultsCL4                             UltimateSQLResultsViewClass
ResultsFileName                           CSTRING(FILE:MaxFilePath)
  Code
  Open(ResultsWindow)
  If NOT Omitted(pTitle)
    0{Prop:Text} = pTitle
  END
  Do CreateListControls
  Do AddjustOtherControls
  ?strNumResultSets{Prop:Text} = ?strNumResultSets{Prop:Text} & pSQLDirect.NumberOfResultSets()
  If Not lResultsFound
    ?Sheet1{Prop:Selected} = 2    !Select Message tab if no result sets
  End
  Accept
    Case Event()
    Of Event:Accepted
      Case Field()
      Of ?btnClose
        Post(Event:CloseWindow)
      Of ?btnSave
        Do SaveResults
      End
    End
  End
  Close(ResultsWindow)
!
CreateListControls  Routine
  Data
lCntMsg LONG
  Code
  Loop lCnt = 1 To 4
    If pSQLDirect.AssignCurrentResultSet(lCnt) = Level:Benign
      If Records(pSQLDirect.CurrentResultSet)
        lResultsFound = true
        Do AssignCurrentResultClass
        CurSQLResults.CurrentResultSet        &= pSQLDirect.CurrentResultSet
        CurSQLResults.CurrentColumnDescriptor &= pSQLDirect.CurrentColumnDescriptor
        Do AssignListFEQ
        lStrFEQ{Prop:Text} = pSQLDirect.GetStmtForPresentation(pSQLDirect.ResultSets.Stmt)
        CurSQLResults.Init(lFEQ,pSQLDirect.CurrentResultSet,pSQLDirect.CurrentColumnDescriptor)
      End
      If Records(pSQLDirect.ResultSets.MessageQ)
        if ?MsgText{Prop:Text}
          ?MsgText{Prop:Text} = '<13,10>'
        end
        Loop lCntMsg = 1 To Records(pSQLDirect.ResultSets.MessageQ)
          Get(pSQLDirect.ResultSets.MessageQ,lCntMsg)
          ?MsgText{Prop:Text} = ?MsgText{Prop:Text} & pSQLDirect.ResultSets.MessageQ.ErrorState & ' - ' & Clip(pSQLDirect.ResultSets.MessageQ.ErrorMsg) & '<13,10>'
        End
      End
    Else
      Break
    End
  End
!
AddjustOtherControls    Routine
  Data
lAdjustment LONG
  Code
  lAdjustment    = ((lCnt-2) * (?ResultsList{Prop:Height} + 15))
  0{Prop:Height} = 0{Prop:Height} + lAdjustment
  ?Sheet1{Prop:Height} = ?Sheet1{Prop:Height} + lAdjustment
  ?MsgText{Prop:Height} = ?MsgText{Prop:Height} + lAdjustment
  ?btnClose{Prop:YPos} = ?btnClose{Prop:YPos} + lAdjustment
  ?btnSave{Prop:YPos} = ?btnSave{Prop:YPos} + lAdjustment
  ?strNumResultSets{Prop:YPos} = ?strNumResultSets{Prop:YPos} + lAdjustment
!
AssignListFEQ       Routine
  If lCnt = 1
    lFEQ = ?ResultsList
    lStrFEQ = ?strStmt
  Else
    lFEQ = Create(0,Create:List,?tabResults)
    lStrFEQ = Create(0,Create:String,?tabResults)
    Do AssignListPosition
  End
!
AssignListPosition  Routine
  lFEQ{Prop:YPos} = ?ResultsList{Prop:YPos} + ((lCnt-1) * (?ResultsList{Prop:Height} + 15))
  lFEQ{Prop:XPos} = ?ResultsList{Prop:XPos}
  lFEQ{Prop:Width} = ?ResultsList{Prop:Width}
  lFEQ{Prop:Height} = ?ResultsList{Prop:Height}
  lFEQ{Prop:VSCROLL} = 1
  lFEQ{Prop:HSCROLL} = 1
  lFEQ{Prop:Hide} = ''
  lStrFEQ{Prop:yPos} = ?strStmt{Prop:yPos} + ((lCnt-1) * (?ResultsList{Prop:Height} + 15))
  lStrFEQ{Prop:xPos} = ?strStmt{Prop:xPos}
  lStrFEQ{Prop:Hide} = ''
!
AssignCurrentResultClass    Routine
  Case lCnt
  Of 1
    CurSQLResults &= SQLResultsCL1
  Of 2
    CurSQLResults &= SQLResultsCL2
  Of 3
    CurSQLResults &= SQLResultsCL3
  Of 4
    CurSQLResults &= SQLResultsCL4
  End
!
SaveResults         Routine
  DATA
!loc:GetDocuments SpecialFolder
  CODE
  
!  ResultsFileName = loc:GetDocuments.GetDir(SV:CSIDL_PERSONAL) & '\SQLResults.CSV'
  ResultsFileName = 'SQLResults.CSV'
  If FileDialog('Save SQL Results',ResultsFileName,'*.CSV',FILE:Save+FILE:KeepDir+FILE:LongName+FILE:AddExtension)
    pSQLDirect.SaveResultsToCSV(ResultsFileName)
  End
  
  
UltimateSQLResultsViewClass.GetColumnName    Procedure(LONG pColumn) !,String
  Code
  Get(Self.CurrentColumnDescriptor,pColumn)
  If ErrorCode()
    Return ''
  Else
    Return Self.CurrentColumnDescriptor.SQLColumnName
  End
!  
UltimateSQLResultsViewClass.GetListFormat           Procedure() !,STRING
ListFormat  UltimateString
lCnt        LONG
  Code
  Loop lCnt = 1 To Self.NumberOfListBoxColumns()
    ListFormat.Append(Self.DefaultColumnWidth & 'L~' & Self.GetColumnName(lCnt) & '~@S255@|M')
  End
  Return ListFormat.Get()
!  
UltimateSQLResultsViewClass.Init                    PROCEDURE(SIGNED pFEQ, *SQLResultsQueueType pResultSet, *SQLResultsColumnDefType pColumnDescriptor)
  Code
  pFEQ{PROP:VLBval} = Address(Self)
  pFEQ{PROP:VLBproc} = Address(Self.VLBproc)
  pFEQ{Prop:Format} = Self.GetListFormat()
  SELF.CurrentResultSet        &= pResultSet
  SELF.CurrentColumnDescriptor &= pColumnDescriptor
  SELF.ochanges = CHANGES(Self.CurrentResultSet)
!
UltimateSQLResultsViewClass.NumberOfListBoxColumns     Procedure() !,Long
  Code
  If Self.MaxColumns < Records(Self.CurrentColumnDescriptor)
    Return Self.MaxColumns
  Else
    Return Records(Self.CurrentColumnDescriptor)
  End
!  
UltimateSQLResultsViewClass.VLBproc                 PROCEDURE(LONG row, SHORT col) !,STRING
nchanges LONG
ReturnValue UltimateString
  CODE
  CASE row
  OF -1                    ! How many rows?
    ReturnValue.Assign(RECORDS(Self.CurrentResultSet))
  OF -2                    ! How many columns?
    ReturnValue.Assign(Self.NumberOfListBoxColumns())
  OF -3                    ! Has it changed
    nchanges = CHANGES(Self.CurrentResultSet)
    IF nchanges <> SELF.ochanges THEN
      SELF.ochanges = nchanges
      ReturnValue.Assign(1)
    ELSE
      ReturnValue.Assign(0)
    END
  ELSE
    GET(SELF.CurrentResultSet, row)
    If SELF.CurrentResultSet.SQLColumns &= NULL
      ReturnValue.Assign('')
    Else
      Get(SELF.CurrentResultSet.SQLColumns,Col)
      If ErrorCode() OR SELF.CurrentResultSet.SQLColumns.SQLColumnValue &= NULL
        ReturnValue.Assign('')
      Else
        ReturnValue.Assign(SELF.CurrentResultSet.SQLColumns.SQLColumnValue)
      End
    End
  END
  Return ReturnValue.Get()

  