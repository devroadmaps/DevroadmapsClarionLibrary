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
					member()


					MAP
						MODULE('Winapi')
							OutputDebugSTRING(*CSTRING),PASCAL,RAW,NAME('OutputDebugStringA')
							QueryPerformanceCounter(ulong ptrLARGE_INTEGER),BOOL,PASCAL,name('QueryPerformanceCounter'),PROC
							QueryPerformanceFrequency(ulong ptrLARGE_INTEGER),BOOL,PASCAL,name('QueryPerformanceFrequency')
							GetLastError(),long,PASCAL,name('GetLastError')
						end
					END

	include('DCL_System_Diagnostics_Timer.inc'),once
	include('DCL_System_Diagnostics_Logger.inc'),once

FrequencyData                   group(System_Diagnostics_LargeInteger).
CurrentTimeData                 group(System_Diagnostics_LargeInteger).


DCL_System_Diagnostics_Timer.Construct  Procedure 
	code 
	self.enabled = false
	self.Enabled = QueryPerformanceFrequency(address(FrequencyData)) 
	!gdbg.write('Enabled: ' & self.Enabled)
	if self.Enabled
		self.TicksPerSecond = FrequencyData.LowUlong
		!gdbg.write('Ticks per second: ' & self.TicksPerSecond)
	ELSE
		!gdbg.write('Error calling QueryPerformanceFrequency: ' & GetLastError())
	end
	self.Bit32 =10000h
	self.Bit32*=10000h   !32-bit clarion can't init to 100000000h
	

DCL_System_Diagnostics_Timer.ConvertTimeDataToDecimal   procedure(System_Diagnostics_LargeInteger li, *decimal dec)
	code
	!gdbg.write('ConvertTimeDataToDecimal decimal in is ' & dec)
	if li.HighLong=0
		dec=li.LowUlong
?       assert(dec=li.LowUlong)
	else    
		dec =li.HighLong
		dec*=self.bit32
		dec+=li.LowUlong
	end  	
	!gdbg.write('ConvertTimeDataToDecimal decimal out is ' & dec)

DCL_System_Diagnostics_Timer.Destruct   Procedure 
	code 

    
DCL_System_Diagnostics_Timer.GetCurrentTime      procedure(*decimal timestamp)
    CODE
    QueryPerformanceCounter(address(CurrentTimeData)) 
    self.ConvertTimeDataToDecimal(CurrentTimeData, timestamp)
    
    

DCL_System_Diagnostics_Timer.GetElapsedSeconds Procedure!,long
	code 
	if self.Enabled 
		!gdbg.write(self.EndTime & ' - ' & self.StartTime & ' /  ' & self.TicksPerSecond)
		return (self.EndTime - self.StartTime) / self.TicksPerSecond
	end
	return 0
	
DCL_System_Diagnostics_Timer.GetTimesPerSecond               Procedure(long count)!,real
elapsed                                                         real
	code
	elapsed = self.GetElapsedSeconds()
	return count / elapsed
	
	

DCL_System_Diagnostics_Timer.IsEnabled  Procedure!,byte
	CODE
	return self.Enabled
	
DCL_System_Diagnostics_Timer.Start      Procedure
	code 
    if self.Enabled
        self.GetCurrentTime(self.StartTime)
	end
	
	
DCL_System_Diagnostics_Timer.Stop       Procedure 
	code 
	if self.Enabled
		QueryPerformanceCounter(address(CurrentTimeData))
		self.ConvertTimeDataToDecimal(CurrentTimeData, self.EndTime)
	end
	




