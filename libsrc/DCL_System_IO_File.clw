!---------------------------------------------------------------------------------------------!
! Copyright (c) 2013, CoveComm Inc.
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

										member()

	include('DCL_Windows_API_Equates.inc'),once

										MAP
											include('DCL_Windows_API_Functions.inc'),once
!											MODULE('Windows.lib')
!												FileTimeToSystemTime(*FileTimeGroup,*SystemTimeGroup),BOOL,PASCAL,RAW
!												FileTimeToLocalFileTime(*FileTimeGroup,*FileTimeGroup),BOOL,PASCAL,RAW
!												FileTimeToDosDateTime(*FileTimeGroup,*WORD,*WORD),BOOL,PASCAL,RAW
!												SystemTimeToFileTime(*SystemTimeGroup,*FileTimeGroup),BOOL,PASCAL,RAW
!												SetFileTime(HANDLE,*FileTimeGroup,*FileTimeGroup,*FileTimeGroup),BOOL,PASCAL,RAW
!												CreateFileA( *CSTRING lpFileName, 	|
!													ulong dwDesiredAccess, 	|
!													ulong dwShareMode, 		|
!													ulong lpSecurityAttributes, 	|
!													ulong dwCreationDisposition, | 
!													ulong dwFlagsAndAttributes,	| 
!													ulong hTemplateFile),long, raw, pascal
!											END
										END




	INCLUDE('DCL_System_IO_File.inc'),ONCE
	include('DCL_System_String.inc'),once
	include('DCL_System_Diagnostics_Logger.inc'),once

FileTimeGroup                           GROUP,TYPE
dwLowDateTime                               unsigned ! api_DWORD
dwHighDateTime                              unsigned ! api_DWORD
										END

SystemTimeGroup                         GROUP,TYPE              !System time struct
wYear                                       USHORT
wMonth                                      USHORT
wDayOfWeek                                  USHORT
wDay                                        USHORT
wHour                                       USHORT
wMinute                                     USHORT
wSecond                                     USHORT
wMilliseconds                               USHORT
										END

Generic_Write                           equate(040000000H)
Generic_Read                            equate(080000000H) 
OpenExisting                            equate(3)


dbg                                     DCL_System_Diagnostics_Logger

DCL_System_IO_File.SetFileTime          procedure(long newdate, long newtime)		
stime                                       group(DCL_API_SYSTEMTIME)
											end
ftime                                       group(DCL_API_FILETIMEType)
											end
hnd                                         DCL_API_HANDLE


	CODE
	dbg.SetPrefix('DCL_System_IO_File.SetFileTime')
	clear(stime)
	stime.wyear = year(newdate)
	stime.wMonth = month(newdate)
	!stime.wDayOfWeek = 
	stime.wDay = day(newdate)
	DCL_API_SystemTimetoFiletime(stime,ftime)
	!dbg.write('ftime.dwLowDateTime ' & ftime.dwLowDateTime)
	!dbg.write('ftime.dwHighDateTime ' & ftime.dwHighDateTime)
	hnd = DCL_API_CreateFile(self.filename,Generic_Read,0,0,OpenExisting,0,0)
	dbg.Write('handle: ' & hnd)
	DCL_API_SetFileTime(hnd,ftime,ftime,ftime)
	
	


DCL_System_IO_File.Init                 procedure(string filename)
	CODE
	self.FileName = filename
	
DCL_System_IO_File.GetSafeFilename      procedure!,string
x                                           long
PrevCharIsSpace                             byte(false)
str                                         DCL_System_String
	code
	str.Assign('')
	loop x = 1 to len(clip(self.filename))
		case self.FileName[x]
		of '*'
			PrevCharIsSpace = false
			str.append('&')
		of '?'
			PrevCharIsSpace = false
			str.append('~')
		of '<<'
			PrevCharIsSpace = false
			str.append('{{')
		of '>'
			PrevCharIsSpace = false
			str.append('}')
		of ':'
			PrevCharIsSpace = false
			str.append('!')
		of ' '
			if self.RemoveDuplicateSpaces
				if ~PrevCharIsSpace
					str.Append(' ')
				end
			else
				str.append(' ')
			end
			PrevCharIsSpace = true
		of '/'
		orof '\'
		orof '|'
		orof '"'
			PrevCharIsSpace = false
			str.append('_')
		ELSE
			PrevCharIsSpace = false
			str.append(self.FileName[x])
		end
	end
	return str.Get()
			
