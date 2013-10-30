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
                                        end


    include('DCL_System_ErrorManager.inc'),once

DCL_System_ErrorManager.AddError        procedure(string err)
	code
	self.AddError(0,err)
	
DCL_System_ErrorManager.AddError         procedure(long errcode, string err)
    CODE
    self.errorsq.errorcode = ERRCODE
    self.errorsq.error = ERR
    add(self.errorsq)
    
DCL_System_ErrorManager.AddErrors        procedure(*DCL_System_ErrorManager errors)
x                                           long
    CODE
    loop x = 1 to records(errors.ErrorsQ)
        get(errors.ErrorsQ,x)
        self.AddError(errors.ErrorsQ.ErrorCode,errors.ErrorsQ.Error)
    END
    
    
    
    
DCL_System_ErrorManager.Construct        PROCEDURE
    CODE
    self.errorsq &= new DCL_System_ErrorManager_ErrorsQueue
    
DCL_System_ErrorManager.Destruct         procedure 
    code
    self.Reset()
    dispose(self.errorsq)
    
    
DCL_System_ErrorManager.Count            procedure !,LONG
    code
    return records(self.errorsq)

DCL_System_ErrorManager.GetLastErrorCode procedure !,LONG
    CODE
    if ~records(self.errorsq)
        return 0
    end
    get(self.errorsq,records(self.errorsq))
    return self.errorsq.errorcode
    
DCL_System_ErrorManager.GetLastError     procedure !,string
    CODE
    if ~records(self.errorsq)
        return ''
    end
    get(self.errorsq,records(self.errorsq))
    return self.errorsq.error
    
DCL_System_ErrorManager.Reset            procedure
    code
    free(self.errorsq)
    return

    
