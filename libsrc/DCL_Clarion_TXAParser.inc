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
	include('DCL_IncludeInAllClassHeaderFiles.inc'),once
	include('DCL_System_ErrorManager.inc'),once


DCL_Clarion_TXAParser                   Class,Type,Module('DCL_Clarion_TXAParser.CLW'),Link('DCL_Clarion_TXAParser.CLW',_DCL_Classes_LinkMode_),Dll(_DCL_Classes_DllMode_)
ProcedureQ                                  &DCL_Clarion_TXAParser_ProcedureQueue
ProcedureQIsExternal                        bool
Errors                                      &DCL_System_ErrorManager
Construct                                   Procedure()
Destruct                                    Procedure()
AddNewEmbed                                 procedure(string embed,string embedparam1,string embedparam2,string embedparam3,string embedpriority),private
AddNewProcedure                             procedure(string pname),private
CheckForMissedEmbed                         procedure(string s,long lineno,long state),private
GetEmbedCount                               procedure,long
GetFormattedEmbedData                       procedure(*Queue q,*cstring qField)
GetRawEmbedData                             procedure(*Queue q,*cstring qField)
GetProcedureCount                           procedure,long
Parse                                       PROCEDURE(string filename),bool,proc
RemoveCurrentProcedureFromQueue             procedure,private
Reset                                       PROCEDURE
SetQueue                                    procedure(DCL_Clarion_TXAParser_ProcedureQueue procedureQ)
										End

DCL_Clarion_TXAParser_ProcedureQueue    queue,TYPE
ProcedureName                               string(40)
EmbedQ                                      &DCL_Clarion_TXAParser_EmbedQueue
										END

DCL_Clarion_TXAParser_EmbedQueue        queue,type
embedname                                   string(100)
EmbedLinesQ                                 &DCL_Clarion_TXAParser_EmbedLinesQueue                        
										END

DCL_Clarion_TXAParser_EmbedLinesQueue   queue,TYPE
line                                        cstring(1000)
										END
