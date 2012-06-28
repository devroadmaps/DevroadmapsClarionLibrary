!Category(tpr)
!-----------------------------------------------------------------------
! UltimateString.inc - Include for string processing class
!-----------------------------------------------------------------------
  OMIT('_EndOfInclude', _UltimateStringPresent_)
_UltimateStringPresent_  EQUATE(1)


!-----------------------------------------------------------------------
! Miscellaneous definitions required by class
!-----------------------------------------------------------------------
UltimateStringList       QUEUE,TYPE
Line                  &STRING
                    END

!-----------------------------------------------------------------------
! Class specification
!-----------------------------------------------------------------------
UltimateString           CLASS,TYPE,MODULE('UltimateString.clw'),LINK('UltimateString.clw')    !,_abcLinkMode_),DLL(_abcDllMode_)
!---------------------------------------
! Private and protected properties
!---------------------------------------
Value                 &STRING,PROTECTED
Lines                 &UltimateStringList,PROTECTED

!---------------------------------------
! Public methods
!---------------------------------------
Append                PROCEDURE(STRING pNewValue)
Append                PROCEDURE(UltimateString pSource)
Assign                PROCEDURE()
Assign                PROCEDURE(STRING pNewValue)
Assign                PROCEDURE(UltimateString pSource)
Assign                PROCEDURE(BLOB pNewValue)
Contains              PROCEDURE(STRING pTestValue, LONG pNoCase=0), LONG
Count                 PROCEDURE(STRING pSearchValue, <LONG pStartPos>, <LONG pEndPos>, BYTE pNoCase=0), LONG
Decode                PROCEDURE()
Decrypt               PROCEDURE(STRING argKey)
Destruct              PROCEDURE()
DoubleQuote           PROCEDURE()
Encode                PROCEDURE()
Encrypt               PROCEDURE(STRING argKey)
Equals                PROCEDURE(UltimateString pTestSource, LONG pNoCase=0), BYTE
Equals                PROCEDURE(STRING pTestValue, LONG pNoCase=0), BYTE
Equals                PROCEDURE(BLOB pTestValue, LONG pNoCase=0), BYTE
Reformat              PROCEDURE(STRING argFormat, <STRING pNewValue>), STRING, PROC
Get                   PROCEDURE(), STRING
Get                   PROCEDURE(*BLOB pNewValue)
GetLine               PROCEDURE(LONG pLineNumber), STRING
Left                  PROCEDURE(LONG pLength), STRING
Length                PROCEDURE(BYTE pClipIt = 0), LONG
PreAppend             PROCEDURE(STRING pNewValue)
PreAppend             PROCEDURE(UltimateString pSource)
Records               PROCEDURE(), LONG
Replace               PROCEDURE(STRING pOldValue, STRING pNewValue,<LONG pCount>)
Right                 PROCEDURE(LONG pLength), STRING
Split                 PROCEDURE(STRING pSplitStr)
Sub                   PROCEDURE(LONG pStart, LONG pLength), STRING

!---------------------------------------
! Private methods
!---------------------------------------
DisposeLines          PROCEDURE(), PRIVATE
DisposeStr            PROCEDURE(), PRIVATE
                    END

  _EndOfInclude_
