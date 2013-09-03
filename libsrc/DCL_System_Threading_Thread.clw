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
DemonstrationWorkerProcedure                    procedure(string address)
                                                module('')
sleep                                               procedure(long milliseconds),pascal
                                                end

                                            End

    Include('DCL_System_Threading_Thread.inc'),Once
    !include('DCL_System_Diagnostics_Logger.inc'),once

!dbg                                     DCL_System_Diagnostics_Logger

DCL_System_Threading_Thread.Construct       Procedure()
    code
    self.StopRequest = false
    self.PauseRequest = false
    self.ThreadIsPaused = false
    self.ThreadIsRunning = false


DCL_System_Threading_Thread.Destruct        Procedure()
    code
    
    
DCL_System_Threading_Thread.Pause           procedure
    code
    self.PauseRequest = TRUE
    
DCL_System_Threading_Thread.Paused          procedure!,bool
    code
    return self.ThreadIsPaused
    
DCL_System_Threading_Thread.PauseRequested  procedure!,bool
    code
    return self.PauseRequest
    
DCL_System_Threading_Thread.Resume          procedure
    code
    self.ThreadIsPaused = false
    self.PauseRequest = false

DCL_System_Threading_Thread.Sleep           procedure(long microseconds)
    code
    sleep(microseconds)   

DCL_System_Threading_Thread.Start           procedure
    code
    if ~self.ThreadIsRunning
        self.StartWorkerProcedure()
    end

DCL_System_Threading_Thread.StartWorkerProcedure    procedure!,virtual
    code
    ! To use this class you will typically create a derived class somewhere in your
    ! application code, probably in the procedure that launches your worker
    ! procedure.
    ! That derived class will override this procedure, and instead of the following
    ! line of code that launches DemonstrationWorkerProcedure you'll use your own worker procedure.
    ! For an example the code your procedure should include see DemonstrationWorkerProcedure below.
    start(DemonstrationWorkerProcedure,25000,address(self))
    

DCL_System_Threading_Thread.Stop            procedure
    code
    self.StopRequest = true
    self.ThreadIsPaused = false

DCL_System_Threading_Thread.Stopped         procedure!,bool
    code
    return choose(self.ThreadIsRunning=false,true,false)
    
DCL_System_Threading_Thread.StopRequested   procedure!,bool
    code
    return self.StopRequest
    
DCL_System_Threading_Thread.WaitForResume   procedure(long delayInMilliseconds=100)
    code
    self.ThreadIsPaused = TRUE
    self.PauseRequest = false
    loop 
        if self.ThreadIsPaused = false then break.
        sleep(delayInMilliseconds)
    end
    self.ThreadIsPaused = FALSE
    self.PauseRequest = false

DCL_System_Threading_Thread.WorkerProcedureHasEnded procedure
    code
    self.ThreadIsRunning = FALSE
    self.StopRequest = false

DCL_System_Threading_Thread.WorkerProcedureHasStarted       procedure
    code
    self.ThreadIsRunning = true
    self.StopRequest = false

!---------------------------------------------------------------------------------------------
! This procedure demonstrates how to implement a worker process. Do not make any
! changes here - instead, create your own procedure using the following example. 
! Then derive the class and implement just the StartWorkerMethod to call your procedure.
!---------------------------------------------------------------------------------------------
DemonstrationWorkerProcedure                procedure(string address)
Thread                                          &DCL_System_Threading_Thread
    code
    Thread &= (address)
    if Thread &= NULL
        stop('DemonstrationWorkerProcedure did not receive a valid Thread object')
        return
    end
    ! Implement your own loop structure as you see fit, but be sure to include the code
    ! to terminate the thread as shown in this loop. Your loop will probably not have a fixed
    ! number of iterations - this one does simply so it doesn't go on forever. 
    loop 5 times 
        if Thread.StopRequested() then break.
        ! Do something here. This is a demo procedure so all it does is sleep.
        sleep(1000)
    end
    Thread.WorkerProcedureHasEnded()
    
    
