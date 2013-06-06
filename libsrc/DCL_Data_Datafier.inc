!---------------------------------------------------------------------------------------------!
! Copyright © Jeff Slarve
! All Rights Reserved
!---------------------------------------------------------------------------------------------!
!region
! The Datafier Class is for creation of on-the-fly variables that are usable in a thread-safe manner and accessible globally
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
	include('DCL_IncludeInAllClassHeaderFiles.inc'),once
	!include('DCL_System_ErrorManager.inc'),once
	include('DCL_System_Threading_CriticalSection.inc'),once




DCL_DataFier_Default_Namespace          EQUATE('DEFAULT')

DataType:JSDFUnset                      EQUATE(254)
DataType:JSDFExpression                 EQUATE(255)                           

DCL_DataFier_QType                      Queue,Type
Label                                       CString(60)
Label_Sort                                  CString(60)
Var                                         ANY
Picture                                     CString(20)
DataType                                    Byte
Address                                     Long
ReadOnly                                    Byte
Bindable                                    Byte
										end

DCL_DataFier_NameSpaceQType             Queue,Type
NameSpace                                   CString(60)
NameSpace_Sort                              CString(60)
Q                                           &DCL_DataFier_QType
										end

DCL_Data_Datafier                       Class,Type,MODULE('DCL_Data_Datafier.CLW'),LINK('DCL_Data_Datafier.CLW',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
IsThreadSafe                                Byte
OptionExplicit                              Byte
IsBound                                     Byte,PRIVATE
NameSpace                                   &DCL_DataFier_NameSpaceQType,PRIVATE
QLock                                       &DCL_System_Threading_CriticalSection,PRIVATE
BindData                                    Procedure(<String pNameSpace>)
ClearValue                                  Procedure(String pLabel,<Short pDir>,<String pNameSpace>) !Allows for clearing high or low
Construct                                   Procedure
CSRelease                                   Procedure,PRIVATE
CSWait                                      Procedure,PRIVATE
Declare                                     Procedure(String pLabel,<String pNameSpace>,Byte pBindable=FALSE),Long
Destruct                                    Procedure
DisposeValue                                Procedure(String pLabel,Byte pNoLock=False,Byte pUseCurrent=False,<String pNameSpace>),Long,Proc
Fetch                                       Procedure(String pLabel,Byte pUseCurrent=False),Long,PRIVATE
FetchNameSpace                              Procedure(<String pNameSpace>,Byte pUseCurrent=FALSE),Long,PRIVATE,Proc
GetAddress                                  Procedure(String pLabel,<String pNameSpace>),Long
GetValue                                    Procedure(String pLabel,Byte pFormatted=False,<String pNameSpace>),ANY
GetValueList                                Procedure(*Queue pQ,Short pLabelColumn=1,Short pValueColumn=2,Short pSortLabelColumn=3,Byte pFormatted=False,<String pNameSpace>)
SetReadOnly                                 Procedure(String pLabel,<String pNameSpace>,Byte pReadOnly=TRUE)
SetValue                                    Procedure(String pLabel,? pValue,<String pPicture>,Byte pDataType=0,Byte pDigits=0,Byte pPrecision=0,Byte pBindable=FALSE,<String pNameSpace>),Long,Proc
UnbindData                                  Procedure
										end


