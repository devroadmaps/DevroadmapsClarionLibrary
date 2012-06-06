  MEMBER()
  pragma('link(C%V%ODB%X%%L%.LIB)')
 
  
!-----------------------------------------------------------------------
! UltimateDB.clw - Source for table class
!-----------------------------------------------------------------------

  MAP
  .

  INCLUDE('UltimateDB.inc'), ONCE
  INCLUDE('UltimateSQLString.inc'), ONCE
!  INCLUDE('DynFile.inc'), ONCE
  INCLUDE('Errors.clw'), ONCE


! -----------------------------------------------------------------------
!!! <summary>Add to list of read only fields</summary>
!!! <param name="Field">Name of read only field in the form of Table:File</param>
!!! <remarks>Adding readonly fields to object allows the system to
!!! know what fields not to write back to the database. When
!!! invoked without arguments, current values are discarded.
!!! </remarks>
! -----------------------------------------------------------------------
UltimateDB.AddReadOnly PROCEDURE(<STRING pFieldname>)
  CODE
  IF OMITTED(pFieldname)
    FREE(SELF.roQ)
  ELSE
    CLEAR(SELF.roQ)
    SELF.roQ.Fieldname = UPPER(pFieldname)
    ADD(SELF.roQ, +SELF.roQ.Fieldname)
    ASSERT(~ERRORCODE())
  END


! -----------------------------------------------------------------------
!!! <summary>Allocate dynamic memory for class.</summary>
! -----------------------------------------------------------------------
UltimateDB.Construct PROCEDURE()
  CODE
  SELF.roQ          &= NEW(roList)
  SELF._Column      = 1
  SELF._Separator   = '<13,10>'


! -----------------------------------------------------------------------
!!! <summary>Deallocate dynamic memory when class goes out of scope.</summary>
! -----------------------------------------------------------------------
UltimateDB.Destruct PROCEDURE()
  CODE
  FREE(SELF.roQ)
  DISPOSE(SELF.roQ)
  SELF.roQ          &= NULL


! -----------------------------------------------------------------------
!!! <summary>Bind all field in table</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Instance">Instance to be bound</param>
!!! <remarks>Fields will be bound as 'Tablename<instance>_Fieldname'.
!!! This is used by the report writer and calculation processes.</remarks>
! -----------------------------------------------------------------------
UltimateDB.FieldBind PROCEDURE(*FILE pTbl, LONG pInstance=1)

curTableName        CSTRING(81), AUTO
curCol              LONG, AUTO
curColCount         LONG, AUTO
curColName          UltimateSQLString

  CODE
  !---------------------------------------
  ! Build name of table
  !---------------------------------------
  curTableName      = pTbl{PROP:Name}
  IF pInstance > 1
    curTableName    = curTableName & pInstance
  END
  curTableName      = curTableName & '_'
  !---------------------------------------
  ! Build and bind each field
  !---------------------------------------
  curColCount       = pTbl{PROP:Fields}
  LOOP curCol = 1 TO curColCount
    curColName      = SELF.Get_ColName(pTbl, curCol)
    BINDEXPRESSION(curTableName & curColName.Get(), pTbl{PROP:Name} & ':' & curColName.Get())
  END


! -----------------------------------------------------------------------
!!! <summary>Find field in table</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Field">Name of field to be found</param>
!!! <remarks>Returns True if field is in table, False if field is
!!! not in table.</remarks>
! -----------------------------------------------------------------------
UltimateDB.FieldFind PROCEDURE(*FILE pTbl, STRING pField)

curReturn           BYTE
curCol              LONG, AUTO
curColCount         LONG, AUTO
curColName          CSTRING(128), AUTO

  CODE
  curColCount       = pTbl{PROP:Fields}
  LOOP curCol = 1 TO curColCount
    IF UPPER(pField) = UPPER(SELF.Get_ColName(pTbl, curCol))
      RETURN curCol
    END
  END
  RETURN 0


! -----------------------------------------------------------------------
!!! <summary>Unbind all field in table</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Instance">Instance to be unbound</param>
!!! <remarks>This is used by the report writer and calculation
!!! processes after a table is no longer needed.</remarks>
! -----------------------------------------------------------------------
UltimateDB.FieldUnbind PROCEDURE(*FILE pTbl, LONG pInstance=1)

curTableName        CSTRING(81), AUTO
curCol              LONG, AUTO
curColCount         LONG, AUTO

  CODE
  !---------------------------------------
  ! Build name of table
  !---------------------------------------
  curTableName      = pTbl{PROP:Name}
  IF pInstance > 1
    curTableName    = curTableName & pInstance
  END
  curTableName      = curTableName & '_'
  !---------------------------------------
  ! Unbind each field
  !---------------------------------------
  curColCount       = pTbl{PROP:Fields}
  LOOP curCol = 1 TO curColCount
    UNBIND(curTableName & SELF.Get_ColName(pTbl, curCol))
  END


! -----------------------------------------------------------------------
!!! <summary>Find primary key column instance</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <remarks>Find column instance containing primary key
!!! to table. Used by methods when primary key is
!!! to be excluded. Use in conjunction with FormatColName
!!! to build name of primary key. Returns 0 if there is no
!!! primary key.</remarks>
! -----------------------------------------------------------------------
UltimateDB.FindPK PROCEDURE(*FILE pTbl)

curKeyCount         LONG, AUTO
curKey              LONG, AUTO
curKRef             &KEY
curColCount         LONG, AUTO
curCol              LONG, AUTO

  CODE
        curKeyCount       = pTbl{PROP:Keys}  
  LOOP curKey = 1 TO curKeyCount
    curKRef         &= pTbl{PROP:Key, curKey}
        IF curKRef{PROP:Primary}
      curColCount   = curkRef{PROP:Components}
      LOOP curCol   = 1 TO curColCount
        RETURN curkRef{PROP:Field, curCol}
      END
    END
  END
  RETURN 0

! -----------------------------------------------------------------------
!!! <summary>Format column data for insert or update</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Instance">Field instance</param>
!!! <param name="Driver">Optional driver</param>
!!! <remarks>Returns the formatted column data for writing back
!!! to database.</remarks>
! -----------------------------------------------------------------------
UltimateDB.GetColData                PROCEDURE(*FILE pTbl, LONG pInstance, <LONG pDriver>)

curRecord                                   &GROUP
curColType                                  CSTRING(81), AUTO
curColName                                  CSTRING(81), AUTO
curDriver                                   LONG, AUTO
curByte                                     BYTE, AUTO
curNull                                     BYTE, AUTO
curData                                     ANY
curBlob                                     &BLOB
curReturn                                   UltimateSQLString

    CODE
   
  !---------------------------------------
  ! Extract record buffer, field name and type
  ! Determine if a null is allowed in field
  !---------------------------------------
        curRecord         &= pTbl{PROP:Record}
        curColType        = UPPER(pTbl{PROP:Type, pInstance})
        curColName        = UPPER(pTbl{PROP:Name, pInstance})
        IF ~curColName
            curColName      = UPPER(pTbl{PROP:Label, pInstance})
        END
        IF INLIST(UPPER(curColType), 'BLOB', 'MEMO')
           curReturn.Assign('NULL')
        ELSE
            curData         &= WHAT(curRecord, pInstance)   
            curReturn.Assign(curData)
        END 
        RETURN curReturn.Get()
        
        
        
! -----------------------------------------------------------------------
!!! <summary>Format column data for insert or update</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Instance">Field instance</param>
!!! <param name="Driver">Optional driver</param>
!!! <remarks>Returns the formatted column data for writing back
!!! to database.</remarks>
! -----------------------------------------------------------------------
UltimateDB.FormatColData PROCEDURE(*FILE pTbl, LONG pInstance, <LONG pDriver>)

curRecord           &GROUP
curColType          CSTRING(81), AUTO
curColName          CSTRING(81), AUTO
curDriver           LONG, AUTO
curByte             BYTE, AUTO
curNull             BYTE, AUTO
curData             ANY
curBlob             &BLOB
curReturn           UltimateSQLString

  CODE
  !---------------------------------------
  ! Determine data formatting
  !---------------------------------------
  IF OMITTED(4)
    curDriver       = SELF._Driver
  ELSE
    curDriver       = pDriver
  END
  !---------------------------------------
  ! Extract record buffer, field name and type
  ! Determine if a null is allowed in field
  !---------------------------------------
  curRecord         &= pTbl{PROP:Record}
  curColType        = UPPER(pTbl{PROP:Type, pInstance})
  curColName        = UPPER(pTbl{PROP:Name, pInstance})
  IF ~curColName
    curColName      = UPPER(pTbl{PROP:Label, pInstance})
  END
  IF INLIST(UPPER(curColType), 'BLOB', 'MEMO')
    curNull         = True
  ELSE
    curData         &= WHAT(curRecord, pInstance)
    IF INLIST(UPPER(curColType), 'DATE', 'TIME')
      curNull         = True
    ELSIF INLIST(UPPER(curColName), 'CREATEID', 'CREATEDATE', 'CREATETIME', 'CHANGEID', 'CHANGEDATE', 'CHANGETIME')
      curNull         = True
    ELSIF UPPER(RIGHT(curColName, 2)) = 'ID' |
    AND UPPER(curColType) = 'LONG'
      curNull         = True
    ELSE
      curNull         = False
    END
  END
  !---------------------------------------
  ! Format using type of data
  !---------------------------------------
  CASE curColType
  OF 'BLOB'
  OROF 'MEMO'
    !! No code yet
  OF 'BYTE'
    IF curData |
    OR ~curNull
      curByte       = curData
      curReturn.Assign(curByte)
    ELSE
      curReturn.Assign('NULL')
    END
  OF 'CSTRING'
  OROF 'STRING'
    IF curData |
    OR ~curNull
      curReturn.Assign(curData)
      curReturn.Quote(curDriver)
    ELSE
      curReturn.Assign('NULL')
    END
  OF 'DATE'
    IF curData |
    OR ~curNull
      curReturn.Assign(FORMAT(curData, @d010))
      curReturn.Quote(curDriver)
    ELSE
      curReturn.Assign('NULL')
    END
  OF 'TIME'
    IF curData |
    OR ~curNull
      curReturn.Assign(FORMAT(curData, @t04))
      curReturn.Quote(curDriver)
    ELSE
      curReturn.Assign('NULL')
    END
  ELSE
    IF curData |
    OR ~curNull
      curReturn.Assign(curData)
    ELSE
      curReturn.Assign('NULL')
    END
  END
  RETURN curReturn.Get()


! -----------------------------------------------------------------------
!!! <summary>Format column name for insert or update</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Instance">Field instance</param>
!!! <param name="TableName">[T]=Include table name, F=No table name needed</param>
!!! <remarks>Returns the formatted column name for writing back
!!! to database. Format of name is Table."ColumnName".</remarks>
! -----------------------------------------------------------------------
UltimateDB.FormatColName PROCEDURE(*FILE pTbl, LONG pInstance, BYTE pTblName=True)
  CODE
  IF pTblName
    RETURN UPPER(pTbl{PROP:Name}) & '.[' & SELF.Get_ColName(pTbl, pInstance) & ']'
  END
  RETURN '"' & SELF.Get_ColName(pTbl, pInstance) & '"'


! -----------------------------------------------------------------------
!!! <summary>Format list of column names for insert or update</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="PKey">Primary key instance to be skipped or zero</param>
!!! <param name="TableName">[T]=Include table name, F=No table name needed</param>
!!! <remarks>Returns the list of formatted column names used for writing back
!!! to database. Format of each name is Table."ColumnName".</remarks>
! -----------------------------------------------------------------------
UltimateDB.FormatColNames               PROCEDURE(*FILE pTbl, LONG pPKey=0, BYTE pTblName=True)

curColNames                                 UltimateSQLString
curColCount                                 LONG, AUTO
curCol                                      LONG, AUTO
curCount                                    LONG, AUTO

    CODE
        curColCount       = pTbl{PROP:Fields}
        CLEAR(curCount)
        LOOP curCol = 1 TO curColCount
            IF curCol = pPKey
                CYCLE
            END
            IF curCount
                curColNames.Append(', ' & SELF.FormatColName(pTbl, curCol, pTblName))
            ELSE
                curColNames.Append(SELF.FormatColName(pTbl, curCol, pTblName))
            END
            curCount        += 1
        END
        RETURN curColNames.Get()


! -----------------------------------------------------------------------
!!! <summary>Get current error</summary>
! -----------------------------------------------------------------------
UltimateDB.GetError PROCEDURE()
  CODE
  RETURN SELF.Error


! -----------------------------------------------------------------------
!!! <summary>Get key reference</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Key">Text containing key name as in Table:Key_Name</param>
!!! <remarks>Returns a reference to the requested key or null.</remarks>
! -----------------------------------------------------------------------
UltimateDB.GetKey PROCEDURE(*FILE pTbl, STRING pKey)

curKeyCount         LONG, AUTO
curKey              LONG, AUTO
curKRef             &KEY

  CODE
  curKeyCount       = pTbl{PROP:Keys}
  LOOP curKey = 1 TO curKeyCount
    curKRef         &= pTbl{PROP:Key, curKey}
    IF LOWER(curKRef{PROP:Label}) = LOWER(pKey)
      RETURN curKRef
    END
  END
  RETURN NULL


! -----------------------------------------------------------------------
!!! <summary>Get name for column (Private)</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Instance">Instance desired</param>
!!! <remarks>Quoted field names are stripped of surrounding
!!! quotes. The label for the column is used when there is
!!! no column name.</remarks>
! -----------------------------------------------------------------------
UltimateDB.Get_ColName PROCEDURE(*FILE pTbl, LONG pInstance)

curColLength        LONG, AUTO
curColName          UltimateSQLString

  CODE
  curColName.Assign(UPPER(pTbl{PROP:Name, pInstance}))
  IF curColName.Length() = 0
    curColName.Assign(UPPER(pTbl{PROP:Label, pInstance}))
  END
  IF curColName.Left(1) = '"'
    curColLength    = curColName.Length() - 2
    curColName.Assign(SUB(curColName.Get(), 2, curColLength))
  END
  RETURN curColName.Get()


! -----------------------------------------------------------------------
!!! <summary>Get current connection string</summary>
! -----------------------------------------------------------------------
UltimateDB.Get_ConnectionString PROCEDURE()
  CODE
  RETURN SELF._ConnectionString


! -----------------------------------------------------------------------
!!! <summary>Get current driver</summary>
! -----------------------------------------------------------------------
UltimateDB.Get_Driver PROCEDURE()
  CODE
  RETURN SELF._Driver



! -----------------------------------------------------------------------
!!! <summary>Determine if field is readonly.</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Instance">[T]=Field instance</param>
!!! <remarks>Returns True=Field is read only, False=Not read only.
!!! Fields must first be loaded via AddReadOnly method.</remarks>
! -----------------------------------------------------------------------
UltimateDB.IsReadOnly PROCEDURE(FILE pTbl, LONG pInstance)
  CODE
  CLEAR(SELF.roQ)
  SELF.roQ.Fieldname = UPPER(pTbl{PROP:Name} & ':' & SELF.Get_ColName(pTbl, pInstance))
  GET(SELF.roQ, +SELF.roQ.Fieldname)
  IF ERRORCODE()
    RETURN False
  END
  RETURN True


! -----------------------------------------------------------------------
!!! <summary>Format text value</summary>
!!! <param name="Text">Value to be quoted</param>
!!! <remarks>Format the text value for processing. Format depends
!!! on driver being used.</remarks>
! -----------------------------------------------------------------------
UltimateDB.Quote PROCEDURE(STRING pText)

curReturn           UltimateSQLString

  CODE
  curReturn.Assign(pText)
  curReturn.Quote(SELF._Driver)
  RETURN curReturn.Get()


! -----------------------------------------------------------------------
!!! <summary>Set connection information (Virtual)</summary>
!!! <param name="ConnectionString">Connection string</param>
!!! <param name="Driver">(optional)0 = Sybase, 1 = MS SQL</param>
! -----------------------------------------------------------------------
UltimateDB.Set_ConnectionString PROCEDURE(STRING pConnectionString, <LONG pDriver>)
  CODE
  SELF._ConnectionString = pConnectionString
  IF ~OMITTED(pDriver)
    SELF.Set_Driver(pDriver)
  END


! -----------------------------------------------------------------------
!!! <summary>Set driver information (Virtual)</summary>
!!! <param name="Driver">[0] = Sybase, 1 = MS SQL</param>
! -----------------------------------------------------------------------
UltimateDB.Set_Driver PROCEDURE(LONG pDriver=0)
  CODE
  CASE pDriver
  OF 0
    SELF._Driver    = 0
  OF 1
    SELF._Driver    = 1
  ELSE
    SELF._Driver    = 0
  END


! -----------------------------------------------------------------------
!!! <summary>Return SQL needed to fetch subset of child records</summary>
!!! <param name="Key">Reference to key (index) to be used</param>
!!! <param name="Select">Optional additional selection criteria</param>
!!! <remarks>Create a SQL where clause that can be used to select
!!! a set of child records. Example:
!!!     INtac:APInvoiceID = APinv:APInvoiceID
!!!     db.SQLBuildFetchChildren(INtac:Key_APInvoiceIDActivityDate)
!!! SQL Generated:
!!!     f1 = v1 [AND (select)]</remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLBuildFetchChildren PROCEDURE(*KEY pKey, <STRING pSelect>)

curTbl              &File
curField            LONG, AUTO
curFK               LONG, AUTO
curFKName           UltimateSQLString
curWhere            UltimateSQLString

  CODE
  !---------------------------------------
  ! Find PK for search result
  !---------------------------------------
  curTbl            &= pKey{PROP:File}
  !---------------------------------------
  ! Find find key information
  !---------------------------------------
  LOOP curField = 1 TO pKey{PROP:Components}
    curFK           = pKey{PROP:Field, curField}
    curFKName.Assign(SELF.FormatColName(curTbl, curFK))
    IF curField = 1
      curWhere.Assign(curFKName.Get() & '>=' & SELF.FormatColData(curTbl, curFK))
      IF ~OMITTED(3)
        IF pSelect
          curWhere.Append(' AND (' & pSelect & ')')
        END
      END
      BREAK
    END
  END
  RETURN curWhere.Get()


! -----------------------------------------------------------------------
!!! <summary>Return SQL order clause to fetch subset of child records</summary>
!!! <param name="Key">Reference to key (index) to be used</param>
!!! <param name="Reverse">T=Reverse order of key, [F]=Use key order</param>
!!! <remarks>Create a SQL order clause that can be used to select
!!! child records in the proper order. Example:
!!!     INtac:APInvoiceID = APinv:APInvoiceID
!!!     db.SQLBuildOrderChildren(INtac:Key_APInvoiceIDActivityDate)
!!! SQL Generated:
!!!     ORDER BY f1 ASC, ...</remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLBuildOrderChildren PROCEDURE(*KEY pKey, BYTE pReverse=False)

curTbl              &File
curField            LONG, AUTO
curFK               LONG, AUTO
curFKName           UltimateSQLString
curOrder            UltimateSQLString

  CODE
  !---------------------------------------
  ! Find PK for search result
  !---------------------------------------
  curTbl            &= pKey{PROP:File}
  !---------------------------------------
  ! Find find key information
  !---------------------------------------
  LOOP curField = 1 TO pKey{PROP:Components}
    curFK           = pKey{PROP:Field, curField}
    curFKName.Assign(SELF.FormatColName(curTbl, curFK))
    IF curOrder.Length()
      curOrder.Append(', ')
    END
    curOrder.Append(curFKName)
    IF curField > 1
      IF ~pKey{PROP:Ascending, curField}
        IF pReverse
          curOrder.Append(' ASC')
        ELSE
          curOrder.Append(' DESC')
        END
      END
    END
  END
  RETURN curOrder.Get()



! -----------------------------------------------------------------------
!!! <summary>Delete current record in table</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <remarks>Returns True on success, False on failure. Uses SQL
!!! to delete record using primary key value. Assumes that the primary
!!! key value has been filled into the record buffer. Example:
!!!     APinv:APInvoiceID = 1
!!!     db.SQLDelete(APinv)
!!! SQL Generated:
!!!     DELETE FROM tablename WHERE pk = pkValue</remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLDelete PROCEDURE(*FILE pTbl)

curPK               LONG, AUTO
curPKName           UltimateSQLString
curPKData           UltimateSQLString

  CODE
  !---------------------------------------
  ! Find PK for placement of update
  !---------------------------------------
  curPK             = SELF.FindPK(pTbl)
  curPKName.Assign(SELF.FormatColName(pTbl, curPK))
  curPKData.Assign(SELF.FormatColData(pTbl, curPK))
  !---------------------------------------
  ! Delete row from requested table
  !---------------------------------------
  pTbl{PROP:SQL}  = 'DELETE FROM ' & pTbl{PROP:Name} & ' WHERE ' & curPKName.Get() & '=' & curPKData.Get()
  IF ERRORCODE()
    RETURN False
  ELSE
    RETURN True
  END


! -----------------------------------------------------------------------
!!! <summary>Fetch record by key</summary>
!!! <param name="Key">Reference to key in table</param>
!!! <param name="Select">Optional additional SQL selection criteria</param>
!!! <remarks>
!!! Returns True on success, False on failure. Use SQL to fetch a 
!!! record using the indicated key. Assumes that the key
!!! values have been filled into the record buffer. Example:
!!!     GLcls:ClassificationID = loc:ClassificationID
!!!     IF db.SQLFetch(GLcls:Key_ClassificationID) THEN ...
!!! SQL Generated:
!!!     SELECT * FROM tablename WHERE f1 = v1 [AND f2 = v2...]
!!!         [AND (pSelect)]
!!! </remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLFetch PROCEDURE(*KEY pKey, <STRING pSelect>)

curTbl              &File
curField            LONG, AUTO
curFK               LONG, AUTO
curFKName           UltimateSQLString
curFKData           UltimateSQLString
curWhere            UltimateSQLString

  CODE
  !---------------------------------------
  ! Find PK for search result
  !---------------------------------------
  curTbl            &= pKey{PROP:File}
  !---------------------------------------
  ! Find find key information
  !---------------------------------------
  CLEAR(curWhere)
  LOOP curField = 1 TO pKey{PROP:Components}
    curFK           = pKey{PROP:Field, curField}
    curFKName.Assign(SELF.FormatColName(curTbl, curFK))
    curFKData.Assign(SELF.FormatColData(curTbl, curFK))
    IF curField = 1
      curWhere.Assign(' WHERE '  & curFKName.Get() & '=' & curFKData.Get())
    ELSE
      curWhere.Append(' AND '  & curFKName.Get() & '=' & curFKData.Get())
    END
  END
  !---------------------------------------
  ! Add additional where clause
  !---------------------------------------
  IF ~OMITTED(3)
    IF pSelect
      IF ~curWhere.Length()
        curWhere.Assign(' WHERE ' & pSelect)
      ELSE
        curWhere.Append(' AND (' & pSelect & ')')
      END
    END
  END
  !---------------------------------------
  ! Select row from requested table
  !---------------------------------------
!        IF SELF.ColNames
            curTbl{PROP:SQL}  = 'SELECT ' & SELF.FormatColNames(curTbl) & ' FROM ' & curTbl{PROP:Name} & curWhere.Get()
!        ELSE
!            curTbl{PROP:SQL}  = 'SELECT * FROM ' & curTbl{PROP:Name} & curWhere.Get()
!        END   
        NEXT(curTbl)  
        IF ERROR()    ! Need better error checking here
            RETURN False
        ELSE
            RETURN True
        END          
        


! -----------------------------------------------------------------------
!!! <summary>Fetch all child records by key</summary>
!!! <param name="Key">Reference to key in table</param>
!!! <param name="Select">Optional additional selection criteria</param>
!!! <param name="Reverse">T=Reverse order of key, [F]=Use key order</param>
!!! <remarks>Use SQL to fetch a subset of child records using the indicated key.
!!! Assumes that the first field of the key has been filled into the record buffer.
!!! Example:
!!!     INtac:APInvoiceID = APinv:APInvoiceID
!!!     db.SQLFetchChildren(INtac:Key_APInvoiceIDActivityDate)
!!!     LOOP
!!!       NEXT(INtac)
!!!       IF ERRORCODE() THEN BREAK.
!!!         ...
!!!     END
!!! SQL Generated:
!!!     SELECT * FROM tablename WHERE f1 = v1 [AND (pSelect)] ORDER BY f1, ...</remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLFetchChildren PROCEDURE(*KEY pKey, <STRING pSelect>, BYTE pReverse=False)

curTbl              &File
curWhere            UltimateSQLString

  CODE
  !---------------------------------------
  ! Get table being processed
  !---------------------------------------
  curTbl            &= pKey{PROP:File}
  !---------------------------------------
  ! Build where and order by clauses
  !---------------------------------------
  IF OMITTED(3)
    curWhere.Assign(' WHERE ' & SELF.SQLBuildFetchChildren(pKey,))
  ELSIF pSelect
    curWhere.Assign(' WHERE ' & SELF.SQLBuildFetchChildren(pKey, pSelect))
  ELSE
    curWhere.Assign(' WHERE ' & SELF.SQLBuildFetchChildren(pKey,))
  END
  curWhere.Append(' ORDER BY ' & SELF.SQLBuildOrderChildren(pKey, pReverse))
  !---------------------------------------
  ! Select row from requested table
  !---------------------------------------
!  IF SELF.ColNames
    curTbl{PROP:SQL}  = 'SELECT ' & SELF.FormatColNames(curTbl) & ' FROM ' & curTbl{PROP:Name} & curWhere.Get()
!  ELSE
!    curTbl{PROP:SQL}  = 'SELECT * FROM ' & curTbl{PROP:Name} & curWhere.Get()
!  END

! -----------------------------------------------------------------------
!!! <summary>Check for child records by key</summary>
!!! <param name="Key">Reference to key in table</param>
!!! <param name="Select">Optional additional selection criteria</param>
!!! <remarks>Uses SQL to determine if there are child records for the indicated key.
!!! Returns True if there are child records, otherwise False is returned.
!!! Assumes that the first field of the key has been filled into the record buffer.
!!! Example:
!!!     GLcls:ParentID = cls:ParentID
!!!     IF db.SQLHaveChild(GLcls:Key_ParentIDOrder) THEN ...
!!! Generated SQL:
!!!     SELECT TOP 1 pk FROM tablename WHERE f1 = v1 [AND (pSelect)]</remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLHaveChildren PROCEDURE(*KEY pKey, <STRING pSelect>)

curTbl              &File
curPK               LONG, AUTO
curPKName           UltimateSQLString
curFK               LONG, AUTO
curFKName           UltimateSQLString
curFKData           UltimateSQLString

  CODE
  !---------------------------------------
  ! Find PK for search result
  !---------------------------------------
  curTbl            &= pKey{PROP:File}
  curPK             = SELF.FindPK(curTbl)
  curPKName.Assign(SELF.FormatColName(curTbl, curPK))
  !---------------------------------------
  ! Find find key information
  !---------------------------------------
  curFK             = pKey{PROP:Field, 1}
  curFKName.Assign(SELF.FormatColName(curTbl, curFK))
  curFKData.Assign(SELF.FormatColData(curTbl, curFK))
  !---------------------------------------
  ! Select row from requested table
  !---------------------------------------
  IF OMITTED(3)
    curTbl{PROP:SQL}  = 'SELECT TOP 1 ' & curPKName.Get() & ' FROM ' & curTbl{PROP:Name} & ' WHERE ' & curFKName.Get() & '=' & curFKData.Get()
  ELSIF pSelect
    curTbl{PROP:SQL}  = 'SELECT TOP 1 ' & curPKName.Get() & ' FROM ' & curTbl{PROP:Name} & ' WHERE ' & curFKName.Get() & '=' & curFKData.Get() & ' AND (' & pSelect & ')'
  ELSE
    curTbl{PROP:SQL}  = 'SELECT TOP 1 ' & curPKName.Get() & ' FROM ' & curTbl{PROP:Name} & ' WHERE ' & curFKName.Get() & '=' & curFKData.Get()
  END
  NEXT(curTbl)
  IF ERRORCODE()
    RETURN False
  ELSE
    RETURN True
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
UltimateDB.SQLInsert PROCEDURE(*FILE pTbl, BYTE pIncludePK=False)

curColNames         UltimateSQLString
curColData          UltimateSQLString
curPK               LONG, AUTO
curColCount         LONG, AUTO
curCol              LONG, AUTO

  CODE
  !---------------------------------------
  ! Determine if PK to be included
  !---------------------------------------
         
  IF ~pIncludePK
    CLEAR(curPK)
  ELSE
    curPK           = SELF.FindPK(pTbl)
  END
  !---------------------------------------
  ! Extract column names and values
  !---------------------------------------
  curColCount       = pTbl{PROP:Fields}
  LOOP curCol = 1 TO curColCount
    IF curCol = curPK |
    OR SELF.IsReadOnly(pTbl, curCol)
      CYCLE
    END
    IF curColNames.Length()
      curColNames.Append(', ')
    END
    curColNames.Append(SELF.FormatColName(pTbl, curCol, False))
    IF curColData.Length()
      curColData.Append(', ')
    END
    curColData.Append(SELF.FormatColData(pTbl, curCol))
  END
  !---------------------------------------
  ! Extract blob names and values
  !---------------------------------------
  curColCount       = pTbl{PROP:Blobs}
  LOOP curCol = 1 TO curColCount
    IF SELF.IsReadOnly(pTbl, -curCol)
      CYCLE
    END
    IF curColNames.Length()
      curColNames.Append(', ')
    END
    curColNames.Append(SELF.FormatColName(pTbl, -curCol, False))
    IF curColData.Length()
      curColData.Append(', ')
    END
    curColData.Append(SELF.FormatColData(pTbl, -curCol))
  END
  !---------------------------------------
  ! Insert into requested table
  !---------------------------------------
!        pTbl{PROP:SQL}    = 'INSERT INTO ' & pTbl{PROP:Name} & ' (' & curColNames.Get() & ') VALUES (' & curColData.Get() & ')'  
        RETURN 'INSERT INTO ' & pTbl{PROP:Name} & ' (' & curColNames.Get() & ') VALUES (' & curColData.Get() & ')'  
         
  !---------------------------------------
  ! If succesful, get id for row
  !---------------------------------------
!!  IF ~ERRORCODE()
!!    pTbl{PROP:SQL} = 'SELECT @@identity'
!!    NEXT(pTbl)
!!    RETURN True
!!  ELSE
!!    RETURN False
!!  END


! -----------------------------------------------------------------------
!!! <summary>Fetch records by key</summary>
!!! <param name="Key">Reference to key in table</param>
!!! <param name="Select">Optional additional selection criteria</param>
!!! <param name="Reverse">T=Reverse order of key, [F]=Use key order</param>
!!! <remarks>Uses SQL to fetch a list of child records using the indicated key.
!!! All selection is done through the optional select argument.
!!! Example:
!!!     db.SQLList(INtac:Key_APInvoiceIDActivityDate)
!!!     LOOP
!!!       NEXT(INtac)
!!!       IF ERRORCODE() THEN BREAK.
!!!         ...
!!!     END
!!! SQL Generated:
!!!     SELECT * FROM tablename [WHERE pSelect] ORDER BY f1, ...</remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLList PROCEDURE(*KEY pKey, <STRING pSelect>, BYTE pReverse=False)

curTbl              &File
curWhere            UltimateSQLString

  CODE
  !---------------------------------------
  ! Get table being processed
  !---------------------------------------
  curTbl            &= pKey{PROP:File}
  !---------------------------------------
  ! Build where and order by clauses
  !---------------------------------------
  IF ~OMITTED(3)
    IF pSelect
      curWhere.Assign(' WHERE ' & pSelect)
    END
  END
  curWhere.Append(' ORDER BY ' & SELF.SQLBuildOrderChildren(pKey, pReverse))
  !---------------------------------------
  ! Select row from requested table
  !---------------------------------------
!  IF SELF.ColNames
    curTbl{PROP:SQL}  = 'SELECT ' & SELF.FormatColNames(curTbl) & ' FROM ' & curTbl{PROP:Name} & curWhere.Get()
!  ELSE
!    curTbl{PROP:SQL}  = 'SELECT * FROM ' & curTbl{PROP:Name} & curWhere.Get()
!  END
   stop( curTbl{PROP:SQL})

! -----------------------------------------------------------------------
!!! <summary>Turn on/off logging</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <param name="Logfile">Name of file where logging is to occur</param>
!!! <remarks>Omitting the Logfile argument turns off logging.</remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLLog PROCEDURE(*FILE pTbl, <STRING pLogfile>)
  CODE
  IF OMITTED(3)
    pTbl{PROP:LogSQL} = '=================== End log'
    pTbl{PROP:Details} = 0
    pTbl{PROP:LogSQL} = 0
    pTbl{PROP:Profile} = ''
  ELSE
    pTbl{PROP:Profile} = pLogfile
    pTbl{PROP:LogSQL} = '=================== Begin log'
    pTbl{PROP:Details} = 1
    pTbl{PROP:LogSQL} = 1
  END


! -----------------------------------------------------------------------
!!! <summary>Fetch all child records by key in reverse order</summary>
!!! <param name="Key">Reference to key in table</param>
!!! <param name="Select">Optional additional selection criteria</param>
!!! <remarks>Uses SQL to fetch a subset of child records using the indicated key
!!! in reverse order. Assumes that the first field of the key has been
!!! filled into the record buffer.
!!! Example:
!!!     INtac:APInvoiceID = APinv:APInvoiceID
!!!     db.SQLReverseChildren(INtac:Key_APInvoiceIDActivityDate)
!!!     LOOP
!!!       NEXT(INtac)
!!!       IF ERRORCODE() THEN BREAK.
!!!         ...
!!!     END
!!! SQL Generated:
!!!     SELECT * FROM tablename WHERE f1 = v1 [AND (pSelect)] ORDER BY f1 DESC, ...</remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLReverseChildren PROCEDURE(*KEY pKey, <STRING pSelect>)
  CODE
  IF OMITTED(3)
    SELF.SQLFetchChildren(pKey, , True)
  ELSIF pSelect
    SELF.SQLFetchChildren(pKey, pSelect, True)
  ELSE
    SELF.SQLFetchChildren(pKey, , True)
  END


! -----------------------------------------------------------------------
!!! <summary>Update record in database</summary>
!!! <param name="Tbl">Reference to table</param>
!!! <remarks>Uses SQL to build an update to the database for a table.
!!! Returns True on success, False on failure. Assumes that all the fields
!!! of the table have been filled into the record buffer. Does NOT handle
!!! blocs.
!!! Generated SQL:
!!!     UPDATE tablename (f1 = v1, ...) WHERE pk = pkValue</remarks>
! -----------------------------------------------------------------------
UltimateDB.SQLUpdate PROCEDURE(*FILE pTbl)

curUpdate           UltimateSQLString
curPK               LONG, AUTO
curPKName           UltimateSQLString
curPKData           UltimateSQLString
curColCount         LONG, AUTO
curCol              LONG, AUTO

  CODE
  !---------------------------------------
  ! Find PK for placement of update
  !---------------------------------------
  curPK             = SELF.FindPK(pTbl)
  !---------------------------------------
  ! Extract column names and values
  !---------------------------------------
  curColCount       = pTbl{PROP:Fields}
  LOOP curCol = 1 TO curColCount
    IF curCol = curPK
      curPKName.Assign(SELF.FormatColName(pTbl, curCol))
      curPKData.Assign(SELF.FormatColData(pTbl, curCol))
      CYCLE
    END
    IF SELF.IsReadOnly(pTbl, curCol)
      CYCLE
    END
    IF curUpdate.Length()
      curUpdate.Append(', ')
    END
    curUpdate.Append(SELF.FormatColName(pTbl, curCol, False) & '=' & SELF.FormatColData(pTbl, curCol))
  END
  !---------------------------------------
  ! Extract blob names and values
  !---------------------------------------
  curColCount       = pTbl{PROP:Blobs}
  LOOP curCol = 1 TO curColCount
    IF SELF.IsReadOnly(pTbl, -curCol)
      CYCLE
    END
    IF curUpdate.Length()
      curUpdate.Append(', ')
    END
    curUpdate.Append(SELF.FormatColName(pTbl, -curCol, False) & '=' & SELF.FormatColData(pTbl, -curCol))
  END
  !---------------------------------------
  ! Update requested table
  !---------------------------------------
  pTbl{PROP:SQL}  = 'UPDATE ' & pTbl{PROP:Name} & ' SET ' & curUpdate.Get() & ' WHERE ' & curPKName.Get() & '=' & curPKData.Get()
  IF ERRORCODE()
    RETURN False
  ELSE
    RETURN True
  END
