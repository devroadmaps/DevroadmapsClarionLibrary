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

                                            Member
                                            Map
                                            End



    Include('DCL_System_Mangle.inc'),Once
    Include('DCL_System_String.inc'),once
    !include('DCL_System_Diagnostics_Debugger.inc'),once

!dbg                                     DCL_System_Diagnostics_Debugger

!DCL_System_Mangle.Construct                 Procedure()
!    code
!    !self.Errors &= new DCL_System_ErrorManager
!
!
!DCL_System_Mangle.Destruct                  Procedure()
!    code
!    !dispose(self.Errors)
    
DCL_System_Mangle.GetExportSymbol           procedure(string DataType,BOOL Omittable, BOOL byAddress)!,string    
str                                             DCL_System_String
PreventByAddressFlag                            bool
    code
    DataType = UPPER(DataType)
    case DataType
    of 'FILE'
        str.Append('Bf')
        if byAddress then PreventByAddressFlag = true.
    of 'BLOB'
        str.Append('Bb')
    of 'KEY'
        str.Append('Bk')
    of 'QUEUE'
        str.Append('Bq')
        PreventByAddressFlag = true
    of 'REPORT'
        str.Append('Br')
    of 'WINDOW'
        str.Append('Bw')
    of 'VIEW'
        str.Append('Bi')
    of 'APPLICATION'
        str.Append('Ba')
    of 'BYTE'
        str.Append('Uc')
    of 'SHORT'
        str.Append('s')
    of 'LONG'
    orof 'BOOL'
    orof 'UNSIGNED'
        str.Append('l')
    of 'USHORT'
        str.Append('Us')
    of 'ULONG'
        str.Append('Ul')
    of 'SREAL'
        str.Append('f')
    of 'REAL'
        str.Append('d')
    of 'DATE'
        str.Append('bd')
    of 'TIME'
        str.Append('bt')
    of 'DECIMAL'
        str.Append('e')
    of 'PDECIMAL'
        str.Append('p')
    of 'BFLOAT4'
        str.Append('b4')
    of 'BFLOAT8'
        str.Append('b8')
    of '?'
        str.Append('u')
    of 'STRING'
        str.Append('sb')
    of 'PSTRING'
        str.Append('sp')
    of 'CSTRING'
        str.Append('sc')
    of 'GROUP'
        str.Append('g')
    else
        str.Append(LEN(CLIP(DataType)) & upper(DataType))
        PreventByAddressFlag = true
    end   
    if omittable and byAddress and not PreventByAddressFlag
        str.Prepend('P')
    else
        if byAddress and not PreventByAddressFlag 
            str.Prepend('R')
        end
        if Omittable and not PreventByAddressFlag then str.Prepend('O') .
    end

    return str.Get()
        
      
       
       
        





