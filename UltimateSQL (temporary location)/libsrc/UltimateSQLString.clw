                                        MEMBER()
! -----------------------------------------------------------------------
!!! UltimateSQLString.clw - Source for SQL string processing class
!!!
!!! This class is derived from the dynamically allocated string class and
!!! provides the additional functionality required for processing SQL strings.
! -----------------------------------------------------------------------

                                        MAP 
                                            MODULE('WINAPI')
                                                us_CreateFile(*CSTRING,ULONG,ULONG,LONG,ULONG,ULONG,UNSIGNED=0),UNSIGNED,RAW,PASCAL,NAME('CreateFileA')
                                                us_GetFileSize(UNSIGNED,*ULONG),ULONG,PASCAL,NAME('GetFileSize')
                                                us_ReadFile(UNSIGNED,LONG,ULONG,*ULONG,LONG),BOOL,PASCAL,RAW,NAME('ReadFile')
                                                us_CloseHandle(UNSIGNED),BOOL,PASCAL,PROC,NAME('CloseHandle')
                                            END 
                                        END

    INCLUDE('UltimateSQLString.inc'), ONCE


! -----------------------------------------------------------------------
!!! <summary>Append string catenation operator</summary>
!!! <param name="Driver">Optional 0 = Sybase, 1 = MS SQL</param>
!!! <remarks>Appends the string concatenation operator to
!!! the current string</remarks>
! -----------------------------------------------------------------------
UltimateSQLString.AppendCat             PROCEDURE(<LONG pDriver>)

curDriver                                   LONG, AUTO

    CODE
    IF OMITTED(2)
        curDriver       = SELF._Driver
    ELSE
        curDriver       = pDriver
    END
    CASE curDriver
    OF 0              !! Sybase
        SELF.Append(' || ')
    OF 1              !! MS SQL
        SELF.Append('+')
    END


! -----------------------------------------------------------------------
!!! <summary>Assign SQL binary value</summary>
!!! <param name="Value">Binary value to be formatted</param>
!!! <param name="Driver">Optional 0 = Sybase, 1 = MS SQL</param>
!!! <remarks>Appends the binary value to the current string as a constant</remarks>
! -----------------------------------------------------------------------
UltimateSQLString.AssignBinary          PROCEDURE(STRING pValue, <LONG pDriver>)

curDriver                                   LONG, AUTO
curValues                                   STRING('0123456789abcdef')
curChar                                     STRING(1), AUTO
curVal1                                     LONG, AUTO
curVal2                                     LONG, AUTO
curLen                                      LONG, AUTO
curPos                                      LONG, AUTO
curIdx                                      LONG, AUTO

    CODE
    IF OMITTED(2)
        curDriver       = SELF._Driver
    ELSE
        curDriver       = pDriver
    END
    SELF.Assign()
    CASE curDriver
    OF 0              !! Sybase
        curLen          = LEN(pValue)
        IF curLen > 0
            SELF.Value    &= NEW STRING(curLen*4 + 2)
            SELF.Value[1] = ''''
            curIdx        = 2
            LOOP curPos = 1 TO curLen
                curChar     = pValue[curPos : curPos]
                curVal1     = BSHIFT(BAND(VAL(curChar), 11110000b), -4) + 1
                curVal2     = BAND(VAL(curChar), 00001111b) + 1
                SELF.Value[curIdx : curIdx+3] = |
                    '\x' & curValues[curVal1 : curVal1] & curValues[curVal2 : curVal2]
                curIdx      = curIdx + 4
            END
            SELF.Value[curIdx] = ''''
        ELSE
            SELF.Assign('NULL')
        END
    OF 1              !! MS SQL
        curLen          = LEN(pValue)
        IF curLen > 0
            SELF.Value    &= NEW STRING(curLen*4 + 2)
            SELF.Value[1] = ''''
            curIdx        = 2
            LOOP curPos = 1 TO curLen
                curChar     = pValue[curPos : curPos]
                curVal1     = BSHIFT(BAND(VAL(curChar), 11110000b), -4) + 1
                curVal2     = BAND(VAL(curChar), 00001111b) + 1
                SELF.Value[curIdx : curIdx+3] = |
                    '\x' & curValues[curVal1 : curVal1] & curValues[curVal2 : curVal2]
                curIdx      = curIdx + 4
            END
            SELF.Value[curIdx] = ''''
        ELSE
            SELF.Assign('NULL')
        END
    END


! -----------------------------------------------------------------------
!!! <summary>Create a quoted literal</summary>
!!! <param name="Driver">Optional 0 = Sybase, 1 = MS SQL</param>
!!! <remarks>Converts all special characters into an escape sequence
!!! depending upon the driver. For Driver = 0 (Sybase) each special
!!! character is converted to \xnn where nn is the hex representation
!!! of the character. For Driver = 1 (MS SQL) each special character
!!! is converted to CHAR(nn) where nn is the decimal representation
!!! of the character.</remarks>
! -----------------------------------------------------------------------
UltimateSQLString.Quote                 PROCEDURE(<LONG pDriver>)

curValues                                   STRING('0123456789abcdef')
curChar                                     STRING(1), AUTO
curAssign                                   CSTRING(21), AUTO
curInstance                                 LONG, AUTO
curVal1                                     LONG, AUTO
curVal2                                     LONG, AUTO
curText                                     BYTE(False)
curDriver                                   LONG, AUTO

    CODE
    IF OMITTED(2)
        curDriver       = SELF._Driver
    ELSE
        curDriver       = pDriver
    END
    CASE curDriver
    OF 0              !! Sybase
        CLEAR(curInstance)
        LOOP
            curInstance   += 1
            IF curInstance > LEN(SELF.Value)
                BREAK
            END
            curChar       = SELF.Value[curInstance : curInstance]
            IF curChar < ' ' |
                OR INSTRING(curChar, '''\')
                curVal1 = BSHIFT(BAND(VAL(curChar), 11110000b), -4) + 1
                curVal2 = BAND(VAL(curChar), 00001111b) + 1
                SELF.Assign(SUB(SELF.Value, 1, curInstance-1) & |
                    '\x' & curValues[curVal1 : curVal1] & curValues[curVal2 : curVal2] & |
                    SUB(SELF.Value, curInstance+1, LEN(SELF.Value)-curInstance))
                curInstance += 3
            END
        END
        SELF.PreAppend('''')
        SELF.Append('''')
    OF 1              !! MS SQL
        CLEAR(curInstance)
        LOOP
            curInstance   += 1
            IF curInstance > LEN(SELF.Value)                   
                BREAK
            END
            curChar       = SELF.Value[curInstance : curInstance]
            IF curChar < ' ' |
                OR curChar = ''''
                curAssign   = 'CHAR(' & VAL(curChar) & ')'
                IF curText
                    SELF.Assign(SELF.Value[1 : curInstance-1] & |
                        '''' & |
                        SELF.Value[curInstance : LEN(SELF.Value)])
                    curText   = False
                    curInstance += 1
                END
                IF curInstance > 1
                    SELF.Assign(SELF.Value[1 : curInstance-1] & |
                        '+' & curAssign & |
                        SELF.Value[curInstance+1 : LEN(SELF.Value)])
                    curInstance += LEN(curAssign)
                ELSE
                    SELF.Assign(SELF.Value[1 : curInstance-1] & |
                        curAssign & |
                        SELF.Value[curInstance+1 : LEN(SELF.Value)])
                    curInstance += (LEN(curAssign) - 1)
                END
            ELSIF ~curText
                IF curInstance > 1
                    SELF.Assign(SELF.Value[1 : curInstance-1] & |
                        '+''' & |
                        SELF.Value[curInstance : LEN(SELF.Value)])
                    curInstance += 2
                ELSE
                    SELF.Assign(SELF.Value[1 : curInstance-1] & |
                        '''' & |
                        SELF.Value[curInstance : LEN(SELF.Value)])
                    curInstance += 1
                END
                curText     = True
            END
        END
        IF curText
            SELF.Append('''')
        ELSIF SELF.Length() = 0
            SELF.Assign('''''')
        END 
        
        SELF.Replace('CHR(','char(')
    END
    RETURN


! -----------------------------------------------------------------------
!!! <summary>Set driver</summary>
!!! <param name="Driver">0 = Sybase, 1 = MS SQL</param>
!!! <remarks>The driver determines how the various string
!!! formatting processes will function. Using this method
!!! allows the driver to only be set once prior to invoking
!!! the various SQL methods.</remarks>
! -----------------------------------------------------------------------
UltimateSQLString.Set_Driver            PROCEDURE(LONG pDriver)
    CODE
    SELF._Driver      = pDriver


! -----------------------------------------------------------------------
!!! <summary>Set driver from db access object</summary>
!!! <param name="DB">Reference to DB object</param>
!!! <remarks>The driver determines how the various string
!!! formatting processes will function.</remarks>
! -----------------------------------------------------------------------
UltimateSQLString.Set_Driver            PROCEDURE(UltimateDB DB)
    CODE
    SELF._Driver      = DB.Get_Driver()


! -----------------------------------------------------------------------
!!! <summary>Breakdown the current string into separate lines</summary>
!!! <remarks>First any lone Line-Feed is replaced with a cr/lf combination.
!!! Then the string is split into individual lines using cr/lf separator.
!!! Use Records and GetLine methods to return information about the split queue.</remarks>
! -----------------------------------------------------------------------
UltimateSQLString.Split                 PROCEDURE()

lCount                                      LONG,AUTO
lStrPos                                     LONG,AUTO
lStartPos                                   LONG(2)

    CODE
    IF NOT SELF.Value &= NULL
        LOOP
            lStrPos = INSTRING('<10>',SELF.Value,1,lStartPos)
            IF lStrPos
                IF SELF.Value[ lStrPos-1 : lStrPos-1 ] <> '<13>'
                    SELF.Assign(SELF.Value[1 : lStrPos-1 ] & '<13,10>' & SELF.Value[ lStrPos + 1 : LEN(SELF.Value) ])
                    lStartPos = lStrPos + 2
                ELSE
                    lStartPos = lStrPos + 1
                END
            ELSE
                BREAK
            END
        END
        SELF.Split('<13,10>')
    END       

! -----------------------------------------------------------------------
!!! <summary>Reads an ASCII file in to a string</summary>
!!! <param name="FileName">Name of the file (with full path) to be read</param>
! -----------------------------------------------------------------------        
UltimateSQLString.ReadFile              PROCEDURE(STRING pFilename)    !,STRING   

FileHandle                                  us_Handle
BytesRead                                   ULONG
FileName                                    CSTRING(500)
FileAccess                                  ULONG
FileSize                                    ULONG
HFileSize                                   ULONG
ReturnValue                                 us_Bool

    CODE
        
    FileName = CLIP(pFilename) 
    FileHandle = us_CreateFile(FileName,us_GenericRead,us_File_Share_Read,0,4,0,0)  
    IF FileHandle = us_Invalid_Handle_Value
    ELSE
        FileSize = us_GetFileSize(FileHandle,HFileSize)
        SELF.Value &= NEW STRING(FileSize)  
        IF ~us_ReadFile(FileHandle,ADDRESS(SELF.Value),FileSize,BytesRead,0)
            Message('error ' & ERROR())
        END          
        ReturnValue = us_CloseHandle(FileHandle)            
    END
        
    RETURN SELF.Value
