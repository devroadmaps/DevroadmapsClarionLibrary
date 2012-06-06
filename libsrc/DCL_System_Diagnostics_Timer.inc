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

	! Adapted from Philip Prohm's article at http://www.clarionmag.com/cmag/v9/v9n07profiling.html


System_Diagnostics_LargeInteger         GROUP,TYPE
LowUlong                                    ULONG
HighLong                                    LONG
                                        END
!LargeInteger                    &System_Diagnostics_LargeInteger


Int64Type                               decimal(20),type



DCL_System_Diagnostics_Timer             class,type,module('DCL_System_Diagnostics_Timer.clw'),link('DCL_System_Diagnostics_Timer.clw',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
StartTime                                   like(Int64Type)
EndTime                                     like(Int64Type)
Enabled                                     byte,private
Bit32                                       like(Int64Type),private
TicksPerSecond                              ulong
Construct                                   Procedure 
ConvertTimeDataToDecimal                    procedure(System_Diagnostics_LargeInteger li, *decimal dec)
Destruct                                    Procedure
GetCurrentTime                              procedure(*decimal timestamp)
GetElapsedSeconds                           Procedure,real
GetTimesPerSecond                           Procedure(long times),real
IsEnabled                                   Procedure,byte
Start                                       Procedure
Stop                                        Procedure 
                                        end


    
