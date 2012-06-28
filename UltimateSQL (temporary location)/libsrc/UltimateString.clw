  MEMBER()
! -----------------------------------------------------------------------
!!! UltimateString.clw - Source for string processing class
!!!
!!! This class is used to process a dynamically allocated string. This
!!! came from source code provided
! -----------------------------------------------------------------------

  MAP
  .

  INCLUDE('UltimateString.inc'), ONCE


! -----------------------------------------------------------------------
!!! <summary>Append the new value to the end of the existing class string.</summary>
!!! <param name="NewValue">New value to be appended</param>
!!! <remarks>If no value already exists then the new value is assigned
!!! as if Assign had been called instead of Append.</remarks>
! -----------------------------------------------------------------------
UltimateString.Append PROCEDURE(STRING pNewValue)
  CODE
  IF NOT SELF.Value &= NULL
    SELF.Assign(CLIP(SELF.Value) & pNewValue)
  ELSE
    SELF.Assign(pNewValue)
  END

! -----------------------------------------------------------------------
!!! <summary>Append value to the string class from an existing class</summary>
!!! <param name="Source">Existing string class to append to the class</param>
!!! <remarks>If no value already exists then the new value is assigned
!!! as if Assign had been called instead of Append.</remarks>
! -----------------------------------------------------------------------
UltimateString.Append PROCEDURE(UltimateString pSource)
  CODE
  SELF.Append(pSource.Get())

! -----------------------------------------------------------------------
!!! <summary>Assign null string to class</summary>
!!! <remarks>Completely clears object for reuse.</remarks>
! -----------------------------------------------------------------------
UltimateString.Assign PROCEDURE()
  CODE
  SELF.DisposeStr()
    
! -----------------------------------------------------------------------
!!! <summary>Assign a new value to the string class</summary>
!!! <param name="NewValue">The new string to assign to the class</param>
!!! <remarks>A new value can be assigned to the class regardless
!!! if it already has a value. The old value is automatically disposed.</remarks>
! -----------------------------------------------------------------------
UltimateString.Assign PROCEDURE(STRING pNewValue)

strLen              LONG,AUTO

  CODE
  SELF.DisposeStr()
  strLen = LEN(pNewValue)
  IF strLen > 0
    SELF.Value &= NEW STRING(strLen)
    SELF.Value = pNewValue
  END
    
! -----------------------------------------------------------------------
!!! <summary>Assign a new value to the string class from an existing class</summary>
!!! <param name="Source">Existing string class to assign to the class</param>
!!! <remarks>A new value can be assigned to the class regardless
!!! if it already has a value. The old value is automatically disposed.</remarks>
! -----------------------------------------------------------------------
UltimateString.Assign PROCEDURE(UltimateString pSource)
  CODE
  SELF.Assign(pSource.Get())
    
! -----------------------------------------------------------------------
!!! <summary>Assign a new value to the string class from an existing class</summary>
!!! <param name="pNewValue">New BLOB reference to assign to the class</param>
!!! <remarks>A new BLOB reference can be assigned to the class regardless
!!! if it already has a reference. The old reference is automatically disposed.</remarks>
! -----------------------------------------------------------------------
UltimateString.Assign PROCEDURE(BLOB pNewValue)

strLen              LONG,AUTO

  CODE
  SELF.DisposeStr()
  strLen = pNewValue{PROP:Size}
  IF strLen > 0
    SELF.Value &= NEW STRING(strLen)
    SELF.Value = pNewValue[0 : strLen-1]
  END

! -----------------------------------------------------------------------
!!! <summary>Return the offset of the sub-string in existing class string.</summary>
!!! <param name="TestValue">Sub-string to search for</param>
!!! <param name="NoCase">Optional parameter to ignore case. Default is case-sensitive.</param>
!!! <remarks>If the sub-string does not exist then zero is returned.</remarks>
! -----------------------------------------------------------------------
UltimateString.Contains PROCEDURE(STRING pTestValue, LONG pNoCase=0)
  CODE
  RETURN INSTRING(CHOOSE(pNoCase,UPPER(pTestValue),pTestValue),CHOOSE(pNoCase,UPPER(SELF.Value),SELF.Value),1,1)

! -----------------------------------------------------------------------
!!! <summary>Count the occurences of a sub-string in class value.</summary>
!!! <param name="SearchValue">Sub-string to search for</param>
!!! <param name="StartPos">Optional parameter to indicate what position to start search. Default is beginning.</param>
!!! <param name="EndPos">Optional parameter to indicate what position to end search. Default is end of string.</param>
!!! <param name="NoCase">Optional parameter: Ignore case in comparision. Default is case-sensitive.</param>
! -----------------------------------------------------------------------
UltimateString.Count PROCEDURE(STRING pSearchValue, <LONG pStartPos>, <LONG pEndPos>, BYTE pNoCase=0)

lCount              LONG(0)
lStrPos             LONG,AUTO
lStartPos           LONG(1)
SearchString        UltimateString

  CODE
  IF NOT SELF.Value &= NULL
    IF OMITTED(pStartPos) AND OMITTED(pEndPos)
      SearchString.Assign(SELF.Value)
    ELSIF OMITTED(pStartPos) 
      SearchString.Assign(SELF.Sub(1,SELF.Length()))
    ELSE
      SearchString.Assign(SELF.Sub(pStartPos,SELF.Length()-pStartPos))
    END
    IF pNoCase
      SearchString.Assign(UPPER(SearchString.Get()))
      pSearchValue = UPPER(pSearchValue)
    END
    LOOP
      lStrPos = INSTRING(pSearchValue,SearchString.Get(),1,lStartPos)
      IF lStrPos
        lStartPos = lStrPos + LEN(pSearchValue)
        lCount += 1
      ELSE
        BREAK
      END
    END
  END
  RETURN lCount

! -----------------------------------------------------------------------
!!! <summary>Decode string so that it can be used.</summary>
!!! <remarks>This operation converts all <nnn> encoded values to their
!!! ascii representation.</remarks>
! -----------------------------------------------------------------------
UltimateString.Decode PROCEDURE()

curAscii            LONG, AUTO
curStartPos         LONG, AUTO
curLeft             LONG, AUTO
curRight            LONG, AUTO

  CODE
  IF NOT SELF.Value &= NULL
    curStartPos     = 1
    LOOP
      curLeft = INSTRING('<<', SELF.Value, 1, curStartPos)
      IF curLeft
        curRight = INSTRING('>', SELF.Value, 1, curStartPos)
        IF curRight
          curAscii  = SUB(SELF.Value, curLeft+1, curRight-curLeft-1)
          SELF.Assign(SELF.Value[1 : curLeft-1] & CHR(curAscii) & SELF.Value[curRight + 1 : LEN(SELF.Value)])
          curStartPos = curLeft + 1
        ELSE
          BREAK
        END
      ELSE
        BREAK
      END
    END
  END

! -----------------------------------------------------------------------
!!! <summary>Decrypt obfuscated string to get the value.</summary>
!!! <remarks>This is a very simple algorithm that undoes the Encrypt method.</remarks>
! -----------------------------------------------------------------------
UltimateString.Decrypt PROCEDURE(STRING argKey)

curPos              LONG, AUTO
curPosVal           LONG, AUTO
curKey              LONG, AUTO
curKeyVal           LONG, AUTO

  CODE
  IF NOT SELF.Value &= NULL
    curPos          = 1
    curKey          = 1
    LOOP WHILE curPos < LEN(SELF.Value)
      curPosVal     = VAL(SELF.Value[curPos : curPos])
      curKeyVal     = BAND(VAL(SUB(argKey, curKey, 1)) * curKey, 0FFh)
      curPosVal     = curPosVal - curKeyVal
      IF curPos < 0
        curPosVal   = 0100h - curPosVal - curKeyVal
      END
      SELF.Value[curPos : curPos] = CHR(curPosVal)
      curPos        += 1
      curKey        += 1
      IF curKey > LEN(argKey)
        curKey      = 1
      END
    END
  END

! -----------------------------------------------------------------------
!!! <summary>Deallocate dynamic memory when class goes out of scope.</summary>
! -----------------------------------------------------------------------
UltimateString.Destruct PROCEDURE()
  CODE
  SELF.DisposeStr()
  SELF.DisposeLines()

! -----------------------------------------------------------------------
!!! <summary>Double up the quotes</summary>
!!! <remarks>Scan current string replacing all quotes with two sets of
!!! quotes. In addition, a quoute is added to the beginning and
!!! to the end of the string. (i.e. He's becomes 'He''s')</Remarks>
! -----------------------------------------------------------------------
UltimateString.DoubleQuote PROCEDURE()
  CODE
  SELF.Replace('''', '''''')
  SELF.Assign('''' & SELF.Get() & '''')

! -----------------------------------------------------------------------
!!! <summary>Encode string so that it can be dumped.</summary>
!!! <remarks>This operation converts the current string so that it can be dumped
!!! for later importation. This is done by converting all characters less than a
!!! space or any escape character to <nnn> format. The nnn represents the decimal
!!! representation of the character. Escape characters are ',<' </remarks>
! -----------------------------------------------------------------------
UltimateString.Encode PROCEDURE()

curChar             STRING(1), AUTO
curEncode           CSTRING(11), AUTO
curPos              LONG, AUTO

  CODE
  IF NOT SELF.Value &= NULL
    curPos          = 1
    LOOP WHILE curPos < LEN(SELF.Value)
      curChar = SELF.Value[curPos : curPos]
      IF curChar < ' ' |
      OR VAL(curChar) > 127 |
      OR INLIST(curChar, ',', '<<')
        curEncode = '<<' & VAL(curChar) & '>'
        SELF.Assign(SELF.Value[1 : curPos-1 ] & curEncode & SELF.Value[curPos + 1 : LEN(SELF.Value)])
        curPos += LEN(curEncode)
      ELSE
        curPos += 1
      END
    END
  END

! -----------------------------------------------------------------------
!!! <summary>Encrypt string to obfuscate the value.</summary>
!!! <remarks>This is a very simple algorithm that hides the value of a string.</remarks>
! -----------------------------------------------------------------------
UltimateString.Encrypt PROCEDURE(STRING argKey)

curPos              LONG, AUTO
curPosVal           LONG, AUTO
curKey              LONG, AUTO
curKeyVal           LONG, AUTO

  CODE
  IF NOT SELF.Value &= NULL
    curPos          = 1
    curKey          = 1
    LOOP WHILE curPos < LEN(SELF.Value)
      curPosVal     = VAL(SELF.Value[curPos : curPos])
      curKeyVal     = BAND(VAL(SUB(argKey, curKey, 1)) * curKey, 0FFh)
      curPosVal     = BAND(curPosVal + curKeyVal, 0FFh)
      SELF.Value[curPos : curPos] = CHR(curPosVal)
      curPos        += 1
      curKey        += 1
      IF curKey > LEN(argKey)
        curKey      = 1
      END
    END
  END

! -----------------------------------------------------------------------
!!! <summary>Compare two UltimateString objects.</summary>
!!! <remarks>Test to determine if the values of two UltimateString objects are
!!! exactly the same.</remarks>
!!! <param name="TestSource">Source UltimateString object to compare (NOT the value of the object).</param>
!!! <param name="NoCase">Optional parameter: Ignore case in comparision. Default is case-sensitive.</param>
! -----------------------------------------------------------------------
UltimateString.Equals PROCEDURE(UltimateString pTestSource, LONG pNoCase=0)!,BYTE
   CODE
   CASE pNoCase
   OF 0
     IF SELF.Get() <> pTestSource.Get()
       RETURN False
     END
   ELSE
     IF UPPER(SELF.Get()) <> UPPER(pTestSource.Get())
       RETURN False
     END
   END
   RETURN True

! -----------------------------------------------------------------------
!!! <summary>Compare value of this object with that of another string.</summary>
!!! <remarks>Test to determine if the value of this UltimateString object is
!!! exactly the same as the value of another string.</remarks>
!!! <param name="TestValue">String to compare.</param>
!!! <param name="NoCase">Optional parameter: Ignore case in comparision. Default is case-sensitive.</param>
! -----------------------------------------------------------------------
UltimateString.Equals PROCEDURE(STRING pTestValue, LONG pNoCase=0)!,BYTE
   CODE
   CASE pNoCase
   OF 0
     IF SELF.Get() <> pTestValue
       RETURN False
     END
   ELSE
     IF UPPER(SELF.Get()) <> UPPER(pTestValue)
       RETURN False
     END
   END
   RETURN True


! -----------------------------------------------------------------------
!!! <summary>Compare the BLOB values of this UltimateString object with that of another BLOB</summary>
!!! <remarks>Test to determine if the BLOB value of this UltimateString object is
!!! exactly the same as the value of another BLOB.</remarks>
!!! <param name="NoCase">Optional parameter: Ignore case in comparision. Default is case-sensitive.</param>
! -----------------------------------------------------------------------
UltimateString.Equals PROCEDURE(BLOB pTestValue, LONG pNoCase=0)!,BYTE

strLen      LONG,AUTO
curString   &STRING

  CODE

  strLen = pTestValue{PROP:Size}
  IF strLen <> SELF.Length()
    RETURN False
  END

  curString &= NEW STRING(strLen)
  curString = pTestValue[0 : strLen-1]

  CASE pNoCase
  OF 0
    IF UPPER(SELF.Value) <> UPPER(curString)
      RETURN False
    END
  ELSE
    IF SELF.Value <> curString
      RETURN False
    END
  END

  RETURN True


! -----------------------------------------------------------------------
!!! <summary>Convert current string using a formatting picture</summary>
!!! <remarks>This method allows a structure to be applied to a string
!!! so that it will have consist structure. Formatting characters in picture:
!!!  # = Right justified numeric
!!!  N = Left justified alpha numeric
!!!  L = Left justified alpha
!!!  X = Right justified alpha
!!! All other characters are left in the resulting string.</remarks>
!!! <param name="Format">Formatting string</param>
!!! <param name="NewValue">Optional new value to be formatted</param>
! -----------------------------------------------------------------------
UltimateString.Reformat PROCEDURE(STRING pFormat, <STRING pNewValue>)

curValue            &STRING
pPos                LONG, AUTO                  ! Current position in picture
pStart              LONG, AUTO                  ! Starting position in picture
pEnd                LONG, AUTO                  ! Ending position in picture
pLength             LONG, AUTO                  ! Length of picture element
pChar               STRING(1), AUTO             ! Character from picture
iPos                LONG, AUTO                  ! Current position in input
iStart              LONG, AUTO                  ! Starting position in input
iEnd                LONG, AUTO                  ! Ending position in input
iLength             LONG, AUTO                  ! Length of input element
iChar               STRING(1), AUTO             ! Current input character being processed

  CODE
  !--------------------------------------
  ! If new value ... assign
  !--------------------------------------
  IF ~OMITTED(pNewValue)
    SELF.Assign(pNewValue)
  END
  !--------------------------------------
  ! If no format ... nothing is done
  !--------------------------------------
  IF ~pFormat
    RETURN SELF.Value
  END
  iPos = 1
  pPos = 1
  SELF.Value        = UPPER(SELF.Value)
  curValue          &= NEW STRING(LEN(pFormat))
  !--------------------------------------
  ! Process all characters from input
  !--------------------------------------
  LOOP
    !--------------------------------------
    ! Find start of next section
    !--------------------------------------
    LOOP
      IF pPos > LEN(pFormat)
        BREAK
      END
      pChar = pFormat[pPos : pPos]
      IF INLIST(pChar, 'N', 'X', 'L', '#')
        BREAK
      ELSE
        curValue[pPos : pPos] = pChar
        IF iPos <= LEN(SELF.Value)
          iChar = SELF.Value[iPos : iPos]
          IF UPPER(iChar) = UPPER(pChar)
            iPos += 1
          END
        END
      END
      pPos += 1
    END
    IF pPos > LEN(pFormat)
      BREAK
    END
    !--------------------------------------
    ! Find next logical element from picture
    !--------------------------------------
    pStart = pPos
    pChar = pFormat[pPos : pPos]
    LOOP
      IF pPos > LEN(pFormat)
        BREAK
      END
      pPos += 1
      IF pFormat[pPos : pPos] <> pChar
        BREAK
      END
    END
    pEnd = pPos - 1
    pLength = pEnd - pStart + 1
    !--------------------------------------
    ! Skip any leading white space in input
    !--------------------------------------
    LOOP
      IF iPos > LEN(SELF.Value)
        BREAK
      END
      IF SELF.Value[iPos : iPos] <> ' '
        BREAK
      END
      iPos += 1
    END
    !--------------------------------------
    ! Determine next logical element from input
    !--------------------------------------
    iStart = iPos
    LOOP
      iLength = iPos - iStart
      IF iPos > LEN(SELF.Value) |
      OR iLength >= pLength
        BREAK
      END
      iChar = SELF.Value[iPos : iPos]
      CASE pChar
      OF 'N'        !! Left alpha-numeric
        IF iChar >= 'A' AND iChar <= 'Z' |
        OR iChar >= '0' AND iChar <= '9'
          iPos += 1
        ELSE
          BREAK
        END
      OF 'X'        !! Alpha
      OROF 'L'
        IF iChar >= 'A' AND iChar <= 'Z'
          iPos += 1
        ELSE
          BREAK
        END
      OF '#'        !! Right numeric
        IF iChar >= '0' AND iChar <= '9'
          iPos += 1
        ELSE
          BREAK
        END
      END
    END
    !--------------------------------------
    ! Pad and store input element
    !--------------------------------------
    IF iLength <= pLength
      CASE pChar
      OF 'L'        !! Left alpha
      OROF 'N'      !! Left alpha-numeric
        curValue[pStart : pEnd] = SUB(SELF.Value, iStart, iLength) & ALL(' ', pLength - iLength)
      OF 'X'        !! Right alpha
        curValue[pStart : pEnd] = ALL(' ', pLength - iLength) & SUB(SELF.Value, iStart, iLength)
      OF '#'        !! Right numeric
        curValue[pStart : pEnd] = ALL('0', pLength - iLength) & SUB(SELF.Value, iStart, iLength)
      END
    ELSE
      SELF.Value[pStart : pEnd] = SUB(SELF.Value, iStart, pLength)
      iPos -= 1
    END
    !--------------------------------------
    ! Skip trailing separator
    !--------------------------------------
    IF iPos <= LEN(SELF.Value)
      iChar = SELF.Value[iPos : iPos]
      IF (iChar < 'A' OR iChar > 'Z') |
      AND (iChar < '0' OR iChar > '9')
        iPos += 1
      END
    END
  END
  !--------------------------------------
  ! Dispose current value and save formatted value
  !--------------------------------------
  SELF.DisposeStr()
  SELF.Value        &= curValue
  RETURN SELF.Value


! -----------------------------------------------------------------------
!!! <summary>Return current string</summary>
!!! <remarks>If no string has been assigned an empty string is returned.</remarks>
! -----------------------------------------------------------------------
UltimateString.Get PROCEDURE() !,STRING
  CODE
    IF NOT SELF.Value &= NULL
      RETURN SELF.Value
    ELSE
      RETURN ''
    END

! -----------------------------------------------------------------------
!!! <summary>Return current string into BLOB reference</summary>
!!! <param name="pNewValue">BLOB reference to assign current to.</param>
!!! <remarks>Remarks go here. FHG</remarks>
! -----------------------------------------------------------------------
UltimateString.Get PROCEDURE(*BLOB pNewValue)
  CODE
  pNewValue{PROP:Size} = 0
  pNewValue{PROP:Size} = LEN(SELF.Value)
  pNewValue[0 : LEN(SELF.Value)-1 ] = SELF.Value[1 : LEN(SELF.Value)]

! -----------------------------------------------------------------------
!!! <summary>Return specific line after calling Split method.</summary>
!!! <param name="LineNumber">Line to return. If LineNumber is greater than the number of lines in queue
!!! then an empty string is returned.</param>
!!! <remarks>If split has not been called an empty string is returned.</remarks>
! -----------------------------------------------------------------------
UltimateString.GetLine PROCEDURE(LONG pLineNumber) !,STRING
  CODE
  IF SELF.Lines &= NULL
    RETURN ''
  ELSE
    GET(SELF.Lines,pLineNumber)
    IF ERRORCODE()
      RETURN ''
    ELSE
      RETURN SELF.Lines.Line
    END
  END
    
! -----------------------------------------------------------------------
!!! <summary>Return left justified portion of current string</summary>
!!! <remarks>The LEFT method returns a left justified string.
!!! Leading spaces are removed, then the string is left justified and
!!! returned with trailing spaces.</remarks>
! -----------------------------------------------------------------------
UltimateString.Left PROCEDURE(LONG pLength) !,STRING
  CODE
  IF NOT SELF.Value &= NULL
    RETURN LEFT(SELF.Value, pLength)
  ELSE
    RETURN LEFT('', pLength)
  END

! -----------------------------------------------------------------------
!!! <summary>Return the length of the existing string value.</summary>
!!! <remarks>If no string has been assigned zero is returned.</remarks>
! -----------------------------------------------------------------------
UltimateString.Length PROCEDURE(BYTE pClipIt=0)
  CODE
    IF NOT SELF.Value &= NULL 
        IF pClipIt
            RETURN LEN(CLIP(SELF.Value))
        ELSE
            RETURN LEN(SELF.Value)
        END
  ELSE
    RETURN 0
  END

! -----------------------------------------------------------------------
!!! <summary>Append the new value to the beginning of the existing class string.</summary>
!!! <param name="NewValue">New value to be preappended</param>
!!! <remarks>If no value already exists then the new value is assigned
!!! as if Assign had been called instead of PreAppend.</remarks>
! -----------------------------------------------------------------------
UltimateString.PreAppend PROCEDURE(STRING pNewValue)
  CODE
  IF NOT SELF.Value &= NULL
    SELF.Assign(pNewValue & SELF.Value)
  ELSE
    SELF.Assign(pNewValue)
  END

! -----------------------------------------------------------------------
!!! <summary>Append value to the beginning of the class string from an existing class</summary>
!!! <param name="Source">Existing string class to preappend to the class</param>
!!! <remarks>If no value already exists then the new value is assigned
!!! as if Assign had been called instead of PreAppend.</remarks>
! -----------------------------------------------------------------------
UltimateString.PreAppend PROCEDURE(UltimateString pSource)
  CODE
  SELF.Append(pSource.Get())

! -----------------------------------------------------------------------
!!! <summary>Return the number of lines a string value was broken into after calling Split.</summary>
!!! <remarks>If split has not been called zero is returned.</remarks>
! -----------------------------------------------------------------------
UltimateString.Records PROCEDURE()
  CODE
  IF SELF.Lines &= NULL
    RETURN 0
  ELSE
    RETURN RECORDS(SELF.Lines)
  END

! -----------------------------------------------------------------------
!!! <summary>Replace occurences of one string with another in class value.</summary>
!!! <param name="OldValue">Sub-string to search for</param>
!!! <param name="NewValue">New value to replace with</param>
!!! <param name="Count">Optional parameter: How many occurences to replace. Default is all.</param>
!!! <remarks>This operation is non-overlapping. If the OldValue occurs in the NewValue the
!!! occurences from inserting NewValue will not be replaced.</remarks>
! -----------------------------------------------------------------------
UltimateString.Replace PROCEDURE(STRING pOldValue, STRING pNewValue, <LONG pCount>)

lCount              LONG,AUTO
lStrPos             LONG,AUTO
lStartPos           LONG(1)

  CODE
  IF NOT SELF.Value &= NULL
    LOOP
      lStrPos = INSTRING(pOldValue,SELF.Value,1,lStartPos)
        IF lStrPos 
            IF (lStrPos + LEN(pOldValue)) > LEN(SELF.Value)
                SELF.Assign(SELF.Value[1 : lStrPos-1 ] & pNewValue)
            ELSE
                SELF.Assign(SELF.Value[1 : lStrPos-1 ] & pNewValue & SELF.Value[ (lStrPos + LEN(pOldValue)) : LEN(SELF.Value) ])
            END
            
        lStartPos = lStrPos + LEN(pNewValue)
        lCount += 1
        IF NOT OMITTED(pCount) AND lCount = pCount
          BREAK
        END
      ELSE
        BREAK
      END
    END
  END

! -----------------------------------------------------------------------
!!! <summary>Return right justified portion of current string</summary>
!!! <remarks>The RIGHT method returns a right justified string.
!!! Trailing spaces are removed, then the string is right justified and
!!! returned with leading spaces.</remarks>
! -----------------------------------------------------------------------
UltimateString.Right PROCEDURE(LONG pLength) !,STRING
  CODE
  IF NOT SELF.Value &= NULL
    RETURN RIGHT(SELF.Value, pLength)
  ELSE
    RETURN RIGHT('', pLength)
  END

! -----------------------------------------------------------------------
!!! <summary>Breakdown the current string value into a series of string. Use the passed string value
!!! as a delimiter.</summary>
!!! <param name="SplitStr">Sub-String used to break up string. </param>
!!! <remarks>The sub-string is consumed by the command and does not appear in the lines.
!!! Use Records and GetLine methods to return information about the split queue.</remarks>
! -----------------------------------------------------------------------
UltimateString.Split PROCEDURE(STRING pSplitStr)

SplitStrPos         LONG,AUTO
StartPos            LONG(1)

  CODE
  IF NOT SELF.Value &= NULL
    SELF.DisposeLines
    SELF.Lines      &= NEW(UltimateStringList)
    LOOP
      SplitStrPos   = INSTRING(pSplitStr,SELF.Value,1,StartPos)
      IF SplitStrPos
        SELF.Lines.Line &= NEW(STRING(LEN(SELF.Value[StartPos : SplitStrPos-1])))
        SELF.Lines.Line = SELF.Value[StartPos : SplitStrPos-1]
        ADD(SELF.Lines)
        StartPos = SplitStrPos + LEN(pSplitStr)
        IF StartPos > LEN(SELF.Value)
          BREAK
        END
        IF STARTPOS + 100 > LEN(SELF.Value)
          Z# =  1   !Debug
        END
      ELSE
        SELF.Lines.Line &= NEW(STRING(LEN(SELF.Value[StartPos : LEN(SELF.Value)])))
        SELF.Lines.Line = SELF.Value[StartPos : LEN(SELF.Value)]
        ADD(SELF.Lines)
        BREAK
      END
    END
  END

! -----------------------------------------------------------------------
!!! <summary>Return sub-string from the current string value.</summary>
!!! <param name="Start">Start of sub-string.</param>
!!! <param name="Length">Length of sub-string.</param>
!!! <remarks>Processing is indentical to the clarion SUB function.</remarks>
! -----------------------------------------------------------------------
UltimateString.Sub PROCEDURE(LONG pStart, LONG pLength) !,STRING
  CODE
  RETURN SUB(SELF.Value, pStart, pLength)

! -----------------------------------------------------------------------
!!! <summary>Private method to dispose of dynamic memory allocated by Split method.</summary>
! -----------------------------------------------------------------------
UltimateString.DisposeLines PROCEDURE()

I                   LONG, AUTO

  CODE
  IF NOT SELF.Lines &= NULL
    LOOP I = 1 TO RECORDS(SELF.Lines)
      GET(SELF.Lines,I)
      DISPOSE(SELF.Lines)
    END
    FREE(SELF.Lines)
  END

! -----------------------------------------------------------------------
!!! <summary>Private method to dispose of string value.</summary>
! -----------------------------------------------------------------------
UltimateString.DisposeStr PROCEDURE()
  CODE
  IF NOT SELF.Value &= NULL
    DISPOSE(SELF.Value)
  END
