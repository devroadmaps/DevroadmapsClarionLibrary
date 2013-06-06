!---------------------------------------------------------------------------------------------!
! Copyright (c) 2012, CoveComm Inc.
! All rights reserved.
!---------------------------------------------------------------------------------------------!
!region
! 
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met: 
! 
! 1. Redistributions of source code must retain the above copyright notice, this
!    list of conditions and the following disclaimer. 
! 2. Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution. 
! 3. The use of this software in a paid-for programming toolkit (that is, a commercial 
!    product that is intended to assist in the process of writing software) is 
!    not permitted.
! 
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
! ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
! WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
! DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
! ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
! (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
! ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
! (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
! SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
! 
! The views and conclusions contained in the software and documentation are those
! of the authors and should not be interpreted as representing official policies, 
! either expressed or implied, of www.DevRoadmaps.com or www.ClarionMag.com.
! 
! If you find this software useful, please support its creation and maintenance
! by taking out a subscription to www.DevRoadmaps.com.
!---------------------------------------------------------------------------------------------!
!endregion
                    MEMBER
                    MAP
                    END

! Generic string handling class method declarations.
                    
    INCLUDE('DCL_System_String.INC'),ONCE
    include('DCL_System_Diagnostics_Logger.inc'),once

!dbg                                     DCL_System_Diagnostics_Logger

  !Public Methods
!!!  
!!! <summary>Assign a new value to the string class</summary>
!!! <param name="NewValue">The new string to assign to the class</param>
!!! <remarks>A new value can be assigned to the class regardless
!!! if it already has a value. The old value is automatically disposed.</remarks>


DCL_System_String.Assign        PROCEDURE(STRING pNewValue)
stringLength                          LONG!,AUTO
    CODE
    Self.DisposeStr()
    stringLength = LEN(pNewValue)
    IF stringLength > 0
        Self.Value &= NEW STRING(stringLength)
        Self.Value = pNewValue
    END

    
DCL_System_String.AssignToLine           PROCEDURE(STRING pNewValue,long lineNumber)
    code
    IF not Self.Lines &= NULL
        get(self.lines,lineNumber)
        if not errorcode()
            if not self.lines.line &= null
                dispose(self.lines.line)
            end
            self.lines.Line &= new string(len(pNewValue))
            self.Lines.Line = pNewValue
            put(self.Lines)
        end
    end
   
    
!!!
!!! <summary>Append the new value to the end of the existing class string.</summary>
!!! <remarks>If no value already exists then the new value is assigned
!!! as if Assign had been called instead of Append.</remarks>
DCL_System_String.Append        PROCEDURE(STRING pNewValue)
	CODE
    IF NOT Self.Value &= NULL
        Self.Assign(Self.Value & pNewValue)
    ELSE
        Self.Assign(pNewValue)
    END                       
    
DCL_System_String.AppendLine             PROCEDURE()
    CODE               
    self.AppendLine('')

DCL_System_String.AppendLine             PROCEDURE(STRING pNewValue)
    CODE               
    self.Append(pNewValue & '<13,10>')
    

DCL_System_String.BeginsWith    procedure(string s)!,byte
thislength                      long
otherlength                     long
	CODE
    s = upper(clip(s))
    IF NOT Self.Value &= NULL
        if s = '' 
            return FALSE
        end
        thislength = len(clip(self.value))
        otherlength = len(s)
        if otherlength > thislength
            return FALSE
        end
        if SUB(upper(self.value),1,otherlength) = s
            return TRUE
        end         
    END
    return false
    
    
!!!
!!! <summary>Return the offset of the sub-string in existing class string.</summary>
!!! <param name="TestValue">Sub-string to search for</param>
!!! <param name="NoCase">Optional parameter to ignore case. Default is case-sensitive.</param>
!!! <remarks>If the sub-string does not exist then zero is returned.</remarks>
DCL_System_String.Contains      PROCEDURE(STRING pTestValue, LONG pNoCase=0)!,LONG
    CODE
    RETURN InString(Choose(pNoCase,UPPER(pTestValue),pTestValue),Choose(pNoCase,UPPER(Self.Value),Self.Value),1,1)

!!!
!!! <summary>Append the new value to the beginning of the existing class string.</summary>
!!! <remarks>If no value already exists then the new value is assigned
!!! as if Assign had been called instead of Append.</remarks>
DCL_System_String.Prepend       PROCEDURE(STRING pNewValue)
    CODE
    IF NOT Self.Value &= NULL
        Self.Assign(pNewValue & Self.Value)
    ELSE
        Self.Assign(pNewValue)
    END

!!!
!!! <summary>Deprecated - use Prepend method.</summary>
DCL_System_String.PreAppend     PROCEDURE(STRING pNewValue)
    CODE
    self.Prepend(pNewvalue)
!!!
!!! <summary>Deallocate dynamic memory when class goes out of scope.</summary>
DCL_System_String.Destruct      PROCEDURE()
    CODE
    Self.DisposeStr()
    Self.DisposeLines()

DCL_System_String.EndsWith      procedure(string s)!,byte
thislength                      long
otherlength                     long
    CODE
    s = upper(clip(s))
    IF NOT Self.Value &= NULL
        if s = ''
            return FALSE
        end
        thislength = len(clip(self.value))
        otherlength = len(s)
        if otherlength > thislength
            return FALSE
        end
        if SUB(upper(self.value),thislength-otherlength+1,otherlength) = s
            return TRUE
        end         
    END
    return false

!!!
!!! <summary>Return current string</summary>
!!! <remarks>If no string has been assigned an empty string is returned.</remarks>
DCL_System_String.Get   PROCEDURE() !,STRING
    CODE
    IF NOT Self.Value &= NULL
        RETURN Self.Value
    ELSE
        RETURN ''
    END

!!!
!!! <summary>Return the index of the start of the specified string value.</summary>
!!! <remarks>If no match is found zero is returned.</remarks>
DCL_System_String.IndexOf       PROCEDURE(string s,long startPos = 1) !,LONG
    CODE
    IF NOT Self.Value &= NULL
        return INSTRING(s,self.value,startPos)
    END
    return 0;

DCL_System_String.IsAlpha    PROCEDURE(string s) !,bool
x	long
	CODE
	if s = ''
		return FALSE
	END
	loop x = 1 to len(s)
		if ~inrange(val(s[x]),65,90) and ~inrange(val(s[x]),97,122)
			return FALSE
		END
	END
	return true
			
	
	
!!!
!!! <summary>Return the last index of the start of the specified string value.</summary>
!!! <remarks>If no match is found zero is returned.</remarks>
DCL_System_String.LastIndexOf   PROCEDURE(string s) !,LONG
idx                             long
lastidx                         long(0)
startidx                        long(1)
msg                             cstring(100)
    CODE
    LOOP
        idx = instring(s,self.value,1,startidx)
        if idx = 0 then break end
        lastidx = idx
        startidx = idx + 1
    END
    return lastidx

!!!
!!! <summary>Return the last index of the start of the specified string value.</summary>
!!! <remarks>If no match is found zero is returned.</remarks>
DCL_System_String.InsertAt      PROCEDURE(string s, long pos) !,LONG
insertPosition                  long
    CODE
    if pos < 1 then pos = 1 end
    IF NOT Self.Value &= NULL
        insertPosition = pos 
        if self.length() < pos 
            self.Append(s)
        ELSE
            !self.value = self.substring(1,pos) & s & self.substring(pos+1,self.length())
            !self.value = self.substring(1,pos-1) & s & self.substring(pos,self.length())
            self.assign(self.substring(1,pos-1) & s & self.substring(pos,self.length()))
        end
    END
    

!!!
!!! <summary>Return the length of the existing string value.</summary>
!!! <remarks>If no string has been assigned zero is returned.</remarks>
DCL_System_String.Length        PROCEDURE() !,LONG
    CODE
    IF NOT Self.Value &= NULL
        RETURN LEN(Self.Value)
    ELSE
        RETURN 0
    END

!!!
!!! <summary>Replace occurences of one string with another in class value.</summary>
!!! <param name="OldValue">Sub-string to search for</param>
!!! <param name="NewValue">New value to replace with</param>
!!! <param name="Count">Optional parameter: How many occurences to replace. Default is all.</param>
!!! <remarks>This operation is non-overlapping. If the OldValue occurs in the NewValue the
!!! occurences from inserting NewValue will not be replaced.</remarks>
DCL_System_String.Replace       PROCEDURE(STRING pOldValue, STRING pNewValue,<LONG pCount>,<bool wholeWord>)
lCount                          LONG,AUTO
lStrPos                         LONG,AUTO
lStartPos                       LONG(1)
!dbg                                 DCL_System_Diagnostics_Logger
skip                                BOOL
endPos                              long
!http://www.clarionmag.com/cmag/v9/v9n11stringclass.html

    CODE
    !dbg.SetPrefix('DCL_System_String.Replace')
    !dbg.write('Current string: ' & self.value)
    !dbg.write('replacing ' & pOldValue & ' with ' & pNewValue)
    IF NOT Self.Value &= NULL
		LOOP
			skip = false
            lStrPos = INSTRING(pOldValue,Self.Value,1,lStartPos)
            !dbg.write('lstrPos ' & lstrpos)
			IF lStrPos
                if not omitted(wholeWord) and wholeWord
                    !dbg.write('if not omitted(wholeWord) and wholeWord')
                    if lStrPos > 1
                        !dbg.write('Checking IsAlpha on position ' & lstrpos - 1 & ': ' & self.Value[lStrPos -1])
                        if self.ISALPHA(self.Value[lStrPos -1])
                            !dbg.write('looking for string ' & pOldValue)
                            !dbg.write('looking in string ' & self.Value)
                            !dbg.write('                  123456789012345678901234567890123456789012345678901234567890')
                            !dbg.write('character prior to word start at ' & lStrPos -1 & ' is >' & self.Value[lStrPos -1] & '<<, skipping')
                            skip = TRUE
                        END
                    else
                        !dbg.write('at start of word')
					END
					if ~skip
                        endPos = lStrPos + len(pOldValue)
                        !dbg.write('endpos: ' & endpos & ', len(self.value): ' & len(self.value))
                        if endPos <= len(self.Value)
                            !dbg.write('Checking isAlpha on position ' & endpos & ': ' & self.Value[endPos])
                            if self.IsAlpha(self.Value[endPos])
                                !dbg.write('looking for string ' & pOldValue)
                                !dbg.write('looking in string ' & self.Value)
                                !dbg.write('                  123456789012345678901234567890123456789012345678901234567890')
                                !dbg.write('character after word end at ' & endPos & ' is >' & self.Value[endPos] & '<<, skipping')
                                skip = TRUE
                            END
                        else
                            !dbg.write('at end of word')
						END
					END
				END
                if ~skip
                    !dbg.write('Self.Assign(Self.Value[1 : lStrPos-1 ] & pNewValue & Self.Value[ (lStrPos + LEN(pOldValue)) : LEN(Self.Value) ])')
                    !dbg.write('Self.Assign(Self.Value[1 : ' & lStrPos-1 & ' ] & pNewValue & Self.Value[ (' & lStrPos & ' + ' & LEN(pOldValue) & ') : ' & LEN(Self.Value) & ' ])')
                    if (lStrPos + LEN(pOldValue)) =< LEN(Self.Value)
                        Self.Assign(Self.Value[1 : lStrPos-1 ] & pNewValue & Self.Value[ (lStrPos + LEN(pOldValue)) : LEN(Self.Value) ])
                    else
                        Self.Assign(Self.Value[1 : lStrPos-1 ] & pNewValue)
                    end
                    
				END
                !dbg.write('New string: ' & self.value)             
                if len(pNewValue) = 0
                    lStartPos = lStrPos + 1
                else
                    lStartPos = lStrPos + LEN(pNewValue)
                end
                
                lCount += 1
                IF NOT OMITTED(pCount) AND lCount = pCount
                    BREAK
                END
            ELSE
                BREAK
            END
        END
    END

DCL_System_String.ReplaceWord                PROCEDURE(STRING pOldValue, STRING pNewValue,<LONG pCount>)
    CODE
    if omitted(pCount)
        self.Replace(pOldvalue,pNewValue,,true)
    else
        self.Replace(pOldvalue,pNewValue,pCount,true)
    end
    
        
!!! <summary>Count the occurences of a sub-string in class value.</summary>
!!! <param name="SearchValue">Sub-string to search for</param>
!!! <param name="StartPos">Optional parameter to indicate what position to start search. Default is beginning.</param>
!!! <param name="EndPos">Optional parameter to indicate what position to end search. Default is end of string.</param>
!!! <param name="NoCase">Optional parameter: Ignore case in comparision. Default is case-sensitive.</param>
DCL_System_String.Count PROCEDURE(STRING pSearchValue, <LONG pStartPos>, <LONG pEndPos>, BYTE pNoCase=0) !,LONG
lCount                  LONG(0)
lStrPos                 LONG,AUTO
lStartPos               LONG(1)
SearchString            DCL_System_String
    CODE
    IF NOT Self.Value &= NULL
        IF OMITTED(pStartPos) AND OMITTED(pEndPos)
            SearchString.Assign(Self.Value)
        ELSIF OMITTED(pStartPos) 
            SearchString.Assign(Self.SubString(1,pEndPos))
        ELSE
            SearchString.Assign(Self.SubString(pStartPos,Self.Length()))
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
    
DCL_System_String.GetAllLines            PROCEDURE(<string delimiter>)!,STRING    
strLength                                   long
x                                           long
newString                                   &cstring
newDelimiter                                &string
delimiterLength                             long
    code
    if self.lines &= null then return ''.
    if omitted(delimiter) or delimiter = '' or delimiter = ' '
        newDelimiter &= new string(1)
        newDelimiter = ' '
        delimiterLength = 1
    else
        delimiterLength = len(delimiter)
        newDelimiter &= new string(delimiterLength)
        newDelimiter = delimiter        
    end
    loop x = 1 to records(self.Lines)
        get(self.lines,x)
        strLength += size(self.lines.Line)
    end
    strLength += (x - 1) * delimiterLength
    newString &= new cstring(strlength + 1)
    loop x = 1 to records(self.Lines)
        get(self.lines,x)
        if x = 1
            newString = clip(self.lines.Line)
        else
            newString = clip(newString) & newDelimiter & clip(self.lines.line)
        end
    end
    return newString
    
    
    

!!!
!!! <summary>Return specific line after calling Split method.</summary>
!!! <param name="LineNumber">Line to return. If LineNumber is greater than the number of lines in queue
!!! then an empty string is returned.</param>
!!! <remarks>If split has not been called an empty string is returned.</remarks>
DCL_System_String.GetLine       PROCEDURE(LONG pLineNumber) !,STRING
    CODE
    IF Self.Lines &= NULL
        RETURN ''
    ELSE
        GET(Self.Lines,pLineNumber)
        IF ERRORCODE()
            RETURN ''
        ELSE
            RETURN Self.Lines.Line
        END
    END



!!! <summary>Return the number of lines a string value was broken into after calling Split.</summary>
!!! <remarks>If split has not been called zero is returned.</remarks>
DCL_System_String.Records       PROCEDURE() !,LONG
    CODE
    IF Self.Lines &= NULL
        RETURN 0
    ELSE
        RETURN RECORDS(Self.Lines)
    END

!!!
!!! <summary>Breakdown the current string value into a series of string. Use the passed string value
!!! as a delimiter.</summary>
!!! <param name="SplitStr">Sub-String used to break up string. </param>
!!! <remarks>The sub-string is consumed by the command and does not appear in the lines.
!!! Use Records and GetLine methods to return information about the split queue.</remarks>
DCL_System_String.Split PROCEDURE(STRING pSplitStr)
q                       queue
s                           string(100)
                        end
    CODE
    q.s = pSplitStr
    add(q)  ! dgh demo
    self.Split(q)
    

!!!
!!! <summary>Breakdown the current string value into a series of string. Use the queue of passed string values
!!! as delimiters.</summary>
!!! <param name="SplitStrQ">Single-value queue of substrings used to break up string. </param>
!!! <remarks>The substrings are consumed by the command and do not appear in the lines.
!!! Use Records and GetLine methods to return information about the split queue.</remarks>
DCL_System_String.Split PROCEDURE(queue q)
SplitStrPos             LONG,AUTO
LowestSplitStrPos       LONG,AUTO
StartPos                LONG(1)
x                       long
y                       long
z                           long
limit                       long
DelimiterQ              QUEUE
value                       cstring(100)
                        end
chars                   long
    CODE
    !gdbg.write('begin split')
    loop x = 1 to records(q)
        get(q,x)
        DelimiterQ.Value = clip(q)
        if len(DelimiterQ.Value) = 0
            delimiterQ.value = ' '
        end
        add(DelimiterQ)
    end
    IF NOT Self.Value &= NULL AND self.Value <> ''
        Self.DisposeLines
        Self.Lines &= NEW(SplitStringQType)
        !gdbg.write('splitting ' & self.value)
        LOOP
            !gdbg.write('loop top')
            LowestSplitStrPos = 0
            SplitStrPos = 0
            loop x = 1 to records(DelimiterQ)
                get(DelimiterQ,x)
                !gdbg.write('testing delimiter >' & delimiterq.value & '<<')
                !SplitStrPos = INSTRING(DelimiterQ.Value,Self.Value,1,StartPos)
                chars = len(delimiterq.value) - 1
                !gdbg.write('looping ' & startpos & ' to ' & self.length())
                limit = self.length() - chars
                !gdbg.write('looping ' & startpos & ' to ' & limit)
                loop y = StartPos to limit !self.length()
                    z  = y + chars
                    !gdbg.write('y:' & y & ', chars ' & chars & ', length of self.value is ' & len(self.Value))
                    if self.value[y : y+chars] = delimiterq.value
                        if y < LowestSplitStrPos or LowestSplitStrPos = 0
                            LowestSplitStrPos = y
                        END
                    end
                end
            end
            !gdbg.write('loop middle')
            SplitStrPos = LowestSplitStrPos
            !gdbg.Write('SplitStrPos: ' & SplitStrPos)
            IF SplitStrPos
                !gdbg.write('1')
                Self.Lines.Line &= NEW(STRING(LEN(Self.Value[StartPos : SplitStrPos-1])))
                !gdbg.write('2')
                Self.Lines.Line = Self.Value[StartPos : SplitStrPos-1]
                !gdbg.write('3')
                !gdbg.write('Line: >' & self.lines.line & '<<')
                if self.Lines.Line <> ''
                    ADD(Self.Lines)
                end
                StartPos = SplitStrPos + LEN(DelimiterQ.Value)
                IF StartPos > LEN(Self.Value)
                    BREAK
                END
                IF STARTPOS + 100 > LEN(Self.Value)
                    Z# =  1 !Debug
                END
            ELSE
                !gdbg.write('4')
                Self.Lines.Line &= NEW(STRING(LEN(Self.Value[StartPos : LEN(Self.Value)])))
                !gdbg.write('5')
                Self.Lines.Line = Self.Value[StartPos : LEN(Self.Value)]
                !gdbg.write('6')
                ADD(Self.Lines)
                BREAK
            END
           !gdbg.write('loop bottom')
        END
    END
    !gdbg.write('End split')

!!!
!!! <summary>Return sub-string from the current string value.</summary>
!!! <param name="Start">Start of sub-string.</param>
!!! <param name="Stop">Stop position of sub-string.</param>
!!! <remarks>If the Stop position is greater than the length of the string the string length is used
!!! as the stop position. If the Start position greater than the stop position or the length
!!! of the string then an empty string is returned.</remarks>
DCL_System_String.SubString     PROCEDURE(LONG pStart, LONG pStop) !,STRING
	CODE
	!return '' ! dgh demo
    IF pStop > LEN(SELF.Value)
        pSTOP = LEN(SELF.VALUE)
    ELSIF pStart > LEN(Self.Value)
        RETURN ''
    ELSIF pStart > pStop
        RETURN ''
    END
    RETURN SELF.Value[pStart : pStop]  

  !Private Methods
!!!
!!! <summary>Private method to dispose of dynamic memory allocated by Split method.</summary>
DCL_System_String.DisposeLines  PROCEDURE() !,PRIVATE
I                               LONG
    CODE
    IF NOT Self.Lines &= NULL
        LOOP I = 1 TO RECORDS(Self.Lines)
            GET(Self.Lines,I)
            DISPOSE(Self.Lines)
        END
        FREE(Self.Lines)
    END

!!!
!!! <summary>Private method to dispose of string value.</summary>
DCL_System_String.DisposeStr    PROCEDURE() !,PRIVATE
    CODE
    IF NOT Self.Value &= NULL
        DISPOSE(Self.Value)
    END
    self.DisposeLines()
    
DCL_System_String.Reset                  procedure()
    code
    self.Assign('')

    

DCL_System_String.Trim                   PROCEDURE() !,PRIVATE

    CODE
    IF NOT Self.Value &= NULL
        self.assign(clip(left(self.get())))
    END
    
