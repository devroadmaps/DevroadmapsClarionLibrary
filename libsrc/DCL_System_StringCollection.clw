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

                                            Member
                                            Map
                                            End



    Include('DCL_System_StringCollection.inc'),Once
    include('DCL_System_Diagnostics_Logger.inc'),once

!dbg                                     DCL_System_Diagnostics_Logger

DCL_System_StringCollection.Construct                     Procedure()
    code
    !self.Errors &= new DCL_System_ErrorManager
    self.StringQ &= new DCL_System_StringCollection_StringQ
    self.CaseInsensitive = false


DCL_System_StringCollection.Destruct        Procedure()
    code
    free(self.StringQ)
    dispose(self.StringQ)
    
DCL_System_StringCollection.Add             procedure(string text)
    code
    if not self.Contains(text)
        clear(self.StringQ)
        self.StringQ.Text = text
        if self.CaseInsensitive
            self.StringQ.SortText = lower(text)
        else
            self.StringQ.SortText = text
        end
        add(self.StringQ,self.StringQ.SortText)
    end
    
    
DCL_System_StringCollection.Contains        procedure(string text)!,bool
    code
    if self.CaseInsensitive
        self.StringQ.SortText = lower(text)
    else
        self.StringQ.SortText = text
    end
    get(self.StringQ,self.StringQ.SortText)
    if ~errorcode() then return true.
    return false

DCL_System_StringCollection.GetCount        procedure!,long
    code
    return records(self.StringQ)
    
DCL_System_StringCollection.Remove          procedure(string text)
    code
    if self.Contains(text)
        delete(self.StringQ)
    end
    
DCL_System_StringCollection.RemoveAll          procedure
    code
    free(self.stringq)