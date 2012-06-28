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
                                            END

    INCLUDE('DCL_System_Stack.inc'),ONCE

StackNodeQ                                  QUEUE,TYPE
NodeVal                                         ULONG
prevNode                                        &DCL_System_StackNode
                                            END




!----------------------------------------------------
DCL_System_Stack.Construct                  PROCEDURE()
!----------------------------------------------------

    CODE
    self.Init()



!----------------------------------------------------
DCL_System_Stack.Destruct                   PROCEDURE()
!----------------------------------------------------

    CODE
    self.Kill()
    self.Init()


!-----------------------------------------------------------------------------
DCL_System_Stack.Init                       PROCEDURE()
!-----------------------------------------------------------------------------

    CODE

    self.StackNode &= NULL

!-----------------------------------------------------------------------------
DCL_System_Stack.Kill                       PROCEDURE()
!-----------------------------------------------------------------------------

    CODE
    LOOP UNTIL SELF.isEmpty()
        SELF.pop()
    END


!-----------------------------------------------------------------------------
DCL_System_Stack.IsEmpty                    PROCEDURE()
!-----------------------------------------------------------------------------

    CODE
    RETURN CHOOSE(self.StackNode &= NULL,TRUE,FALSE)

!-----------------------------------------------------------------------------
DCL_System_Stack.OutOfMemory                PROCEDURE(DCL_System_StackNode t)
!-----------------------------------------------------------------------------

    CODE
    RETURN CHOOSE(t &= NULL,TRUE,FALSE)


!-----------------------------------------------------------------------------
DCL_System_Stack.Push                       PROCEDURE(ANY nodeVal)
!-----------------------------------------------------------------------------

t                                               &DCL_System_StackNode

    CODE
    t &= self.StackNode
    self.StackNode &= NEW(DCL_System_StackNode)
?   ASSERT(~SELF.OutOfMemory(self.StackNode))
    self.StackNode.nodeVal = nodeVal
    self.StackNode.prevNode &= t
    RETURN TRUE

!-----------------------------------------------------------------------------
DCL_System_Stack.Pop                        PROCEDURE()
!-----------------------------------------------------------------------------

t                                               &DCL_System_StackNode

    CODE

?   ASSERT(~SELF.isEmpty())
    t &= self.StackNode
    self.StackNode &= t.prevNode
    DISPOSE(t)
    RETURN TRUE


!-----------------------------------------------------------------------------
DCL_System_Stack.Top                        PROCEDURE()
!-----------------------------------------------------------------------------

    CODE


?   ASSERT(~SELF.isEmpty())
    RETURN self.StackNode.nodeVal


!-----------------------------------------------------------------------------
DCL_System_Stack.StackSum                   PROCEDURE()
!-----------------------------------------------------------------------------

t                                               &DCL_System_StackNode

    CODE
    t &= self.StackNode
    RETURN self.StackSum(t)

!-----------------------------------------------------------------------------
DCL_System_Stack.StackSum                   PROCEDURE(DCL_System_StackNode t)
!-----------------------------------------------------------------------------

    CODE
    IF t &= NULL THEN RETURN 0.
    RETURN t.NodeVal + self.StackSum(t.prevNode)