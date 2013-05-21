!---------------------------------------------------------------------------------------------!
! Copyright (c) 2013, CoveComm Inc.
! All rights reserved.
!---------------------------------------------------------------------------------------------!
!region
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
!endregion

    include('DCL_IncludeInAllClassHeaderFiles.inc'),once
	!include('DCL_System_ErrorManager.inc'),once

	include('DCL_System_IO_FileInfo.inc'),once
	include('DCL_System_ErrorManager.inc'),once
	!include('windows.inc'),once

DCL_System_IO_DirectoryQueue             queue,TYPE
FilePath                                    cstring(FILE:MaxFilePath+1)
FileName                                    cstring(FILE:MaxFileName+1)
										end




DCL_System_IO_Directory                               Class,Type,Module('DCL_System_IO_Directory.CLW'),Link('DCL_System_IO_Directory.CLW',_DCL_Classes_LinkMode_),Dll(_DCL_Classes_DllMode_)
Path                                                        cstring(FILE:MaxFilePath+1),protected
Filter                                                      cstring(100)
FileQ                                                       &DCL_System_IO_FileInfoQueue,protected
MaxDaysOld                                                  long(0),protected
RefreshNeeded                                               byte(false),protected
UseRmDir                                                    bool
Construct                                                   procedure
Destruct                                                    procedure
CreateDirectory                                             procedure(byte force=false)
FileCount                                                   procedure,long
GetDirectoryListing                                         procedure
Init                                                        procedure(string path)
LoadFilenamesQueue                                          procedure(*DCL_System_IO_DirectoryQueue q)
RemoveDirectory                                             procedure(byte OnlyIfEmpty=true)
SetFilesOnly                                                procedure(byte flag)
SetFilter                                                   procedure(string filter)
SetMaxDaysOld                                               procedure(long maxdays)
														End


