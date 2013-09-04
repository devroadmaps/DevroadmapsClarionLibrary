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


    Include('DCL_UI_BackgroundProgressDisplay.inc'),Once
    !include('DCL_System_Diagnostics_Logger.inc'),once

!dbg                                     DCL_System_Diagnostics_Logger

DCL_UI_BackgroundProgressDisplay.Construct  Procedure()
    code
    !self.Errors &= new DCL_System_ErrorManager
    self.CriticalSection &= new DCL_System_Threading_CriticalSection
    self.NotifyCode = 9867 ! Some random number unlikely to be used by anyone else
    clear(self.ProgressControlPreviousValue,-1)

DCL_UI_BackgroundProgressDisplay.Destruct   Procedure()
    code
    !dispose(self.Errors)
    dispose(self.CriticalSection)
    self.DisposeStringControlText()
    
        
DCL_UI_BackgroundProgressDisplay.DisposeStringControlText   procedure
    code
    if not self.StringControlValue &= null
        dispose(self.StringControlvalue)
    end

DCL_UI_BackgroundProgressDisplay.Enable     procedure
    code
    self.UIThread = thread()
    register(event:notify,address(self.TakeEvent),address(self))
    

DCL_UI_BackgroundProgressDisplay.SetStringControlFEQ        procedure(long StringControlFEQ)
    code
    self.StringControlFEQ = StringControlFEQ

DCL_UI_BackgroundProgressDisplay.SetStringControlValue      procedure(string StringControlValue)
    code
    self.CriticalSection.Wait()
    self.DisposeStringControlText()
    self.StringControlValue &= new string(len(clip(StringControlValue)))
    self.StringControlValue = StringControlValue
    notify(self.notifyCode,self.UIthread)
    self.CriticalSection.Release()
        
DCL_UI_BackgroundProgressDisplay.SetProgressControlFEQ      procedure(long ProgressBarControlFEQ,<long rangeLow>,<long rangeHigh>)
    code
    self.ProgressControlFEQ = progressBarControlFEQ
    if not omitted(rangeLow)
        self.ProgressControlFEQ{prop:rangelow} = rangeLow
    end
    if not omitted(rangeHigh)
        self.ProgressControlFEQ{prop:rangeHigh} = rangeHigh
    end
    
DCL_UI_BackgroundProgressDisplay.SetProgressControlValue    procedure(long ProgressControlValue)
    code
    ! probably atomic, but just in case... 
    self.CriticalSection.Wait()
    self.ProgressControlValue = ProgressControlValue
    notify(self.notifyCode,self.UIthread)
    self.CriticalSection.Release()    
    
DCL_UI_BackgroundProgressDisplay.TakeEvent  procedure
    code
    if NOTIFICATION(self.notifyCode)
        self.CriticalSection.Wait()
        if self.ProgressControlFEQ <> 0  and self.ProgressControlValue <> self.ProgressControlPreviousValue
            self.ProgressControlFEQ{Prop:Progress} = self.ProgressControlValue
            display(self.ProgressControlFEQ)
            self.ProgressControlPreviousValue = self.ProgressControlValue
        end
        if self.StringControlFEQ <> 0
            self.StringControlFEQ{prop:text} = self.StringControlValue
            display(self.StringControlFEQ)
        end
        self.CriticalSection.Release()    
    end
    return Level:Benign
    

    

    

