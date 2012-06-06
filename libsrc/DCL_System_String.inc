!---------------------------------------------------------------------------------------------!
! Copyright (c) 2012, CoveComm Inc.
! All rights reserved.
! 
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
    include('DCL_IncludeInAllClassHeaderFiles.inc'),once


	! Generic string handling class definition.
                    
                    
SplitStringQType    Queue,TYPE
Line                    &STRING
					END


DCL_System_String    CLASS,TYPE,MODULE('DCL_System_String.CLW'),LINK('DCL_System_String.CLW',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
Value                   &STRING,PRIVATE
Lines                   &SplitStringQType,PRIVATE
						!Public Methods
Append                  PROCEDURE(STRING pNewValue)
AppendLine              PROCEDURE()
AppendLine              PROCEDURE(STRING pNewValue)
Assign                  PROCEDURE(STRING pNewValue)
AssignToLine            PROCEDURE(STRING pNewValue,long lineNumber)
BeginsWith              procedure(string s),byte
Contains                PROCEDURE(STRING pTestValue, LONG pNoCase=0),LONG
Count                   PROCEDURE(STRING pSearchValue, <LONG pStartPos>, <LONG pEndPos>, BYTE pNoCase=0),LONG
Destruct                PROCEDURE()
EndsWith                procedure(string s),byte
Get                     PROCEDURE(),STRING
GetAllLines             PROCEDURE(<string delimiter>),STRING
GetLine                 PROCEDURE(LONG pLineNumber),STRING
IndexOf                 Procedure(string s,long startPos=1),long
InsertAt                Procedure(string s, long pos)
IsAlpha                 procedure(string),bool,virtual
LastIndexOf             Procedure(string s),long
Length                  PROCEDURE(),LONG
PreAppend               PROCEDURE(STRING pNewValue)
Prepend                 PROCEDURE(STRING pNewValue)
Records                 PROCEDURE(),LONG
Replace                 PROCEDURE(STRING pOldValue, STRING pNewValue,<LONG pCount>,<bool wholeWord>)
ReplaceWord                 PROCEDURE(STRING pOldValue, STRING pNewValue,<LONG pCount>)
Reset                   procedure()
Split                   PROCEDURE(STRING pSplitStr)
Split                   PROCEDURE(Queue pSplitStrq)
SubString               PROCEDURE(LONG pStart, LONG pStop),STRING
Trim                    procedure()

						!Private Methods
DisposeLines            PROCEDURE(),PRIVATE
DisposeStr              PROCEDURE(),PRIVATE
					END


