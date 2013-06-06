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



    Include('DCL_System_Pool.inc'),Once
    !include('DCL_System_Diagnostics_Logger.inc'),once

!dbg                                     DCL_System_Diagnostics_Logger

DCL_System_Pool.Construct                     Procedure()
    code
	!self.Errors &= new DCL_System_ErrorManager
	self.ItemQ &= new DCL_System_PoolItemQueue
	self.AccessLock &= new DCL_System_Threading_CriticalSection
	self.StopOnErrorMessage = 'All pool items are in use'



DCL_System_Pool.Destruct                      Procedure()
    code
	!dispose(self.Errors)
	free(self.ItemQ)
	dispose(self.ItemQ)
	dispose(self.AccessLock)

DCL_System_Pool.GetFreeItemCount        procedure!,long
FreeItemCount                               long
x                                           long
	code
	self.AccessLock.Wait()
	loop x = 1 to records(self.ItemQ)
		get(self.ItemQ,x)
		if not self.ItemQ.InUse then FreeItemCount += 1.
	end
	self.AccessLock.Release()
	return FreeItemCount
	
	
DCL_System_Pool.GetItemNumber           procedure!,long
x                                           long
retval                                      long
	code
	self.AccessLock.Wait()
	retval = -1
	loop x = 1 to records(self.ItemQ)
		get(self.ItemQ,x)
		if not self.itemq.InUse
			self.ItemQ.InUse = true
			put(self.ItemQ)
			retval = self.ItemQ.ItemNumber
			break
		end
	end
	self.AccessLock.Release()
	if retval = -1 and self.StopOnError then Stop(self.StopOnErrorMessage).
	return retval
	
DCL_System_Pool.Init                    procedure(long maxItems)
x                                           long
	code
	self.AccessLock.Wait()
	free(self.ItemQ)
	loop x = 1 to maxItems
		self.ItemQ.ItemNumber = x
		self.ItemQ.InUse = false
		add(self.ItemQ)
	end
	self.AccessLock.Release()
	
	
DCL_System_Pool.ReleaseItemNumber   procedure(long itemNumber)
	code
	self.AccessLock.Wait()
	self.ItemQ.ItemNumber = itemNumber
	get(self.ItemQ,self.ItemQ.ItemNumber)
	if not errorcode()
		self.itemq.InUse = false
		put(self.ItemQ)
	end
	self.AccessLock.Release()
	
DCL_System_Pool.SetStopOnError          procedure(bool StopOnError,<string errorMessage>)
	code
	self.StopOnError = StopOnError
	if not omitted(errorMessage) then self.StopOnErrorMessage = errorMessage.
		



