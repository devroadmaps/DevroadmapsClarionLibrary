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
                                            Member
                                            Map
                                            End



    Include('DCL_System_ClassParser.inc'),Once
    Include('DCL_System_String.inc'),Once
    include('DCL_System_IO_AsciiFile.inc'),once
    include('DCL_System_Diagnostics_Logger.inc'),once

dbg                                         DCL_System_Diagnostics_Logger

DCL_System_ClassParser.Construct            Procedure()
    code
    self.Errors &= new DCL_System_ErrorManager
    self.ClassQ &= new DCL_System_Class_Queue


DCL_System_ClassParser.Destruct             Procedure()
    code
    self.Reset()
    dispose(self.ClassQ)
    dispose(self.Errors)

DCL_System_ClassParser.AddClass             procedure(string classname)!,*DCL_System_Class
    code
    CLEAR(self.ClassQ)
    self.ClassQ.Class_ &= new DCL_System_Class
    self.ClassQ.class_.Name = classname
    ADD(self.ClassQ)
    return self.ClassQ.Class_

DCL_System_ClassParser.ClassCount           procedure!,long
    code
    return RECORDS(self.ClassQ)
    
DCL_System_ClassParser.GetClass             procedure(long index)!,*DCL_System_Class
    code
    GET(self.ClassQ,index)
    if ERRORCODE() then return null.
    return self.ClassQ.Class_
    
DCL_System_ClassParser.Parse                procedure(string filename)!,BOOL,proc
!FileMgr                                         DCL_System_IO_AsciiFileManager
ClassFile                                       DCL_System_IO_AsciiFile
Txt                                             cstring(1000)
TxtUpper                                        cstring(1000)
str                                             DCL_System_String
State                                           long
State:LookingForClass                           equate(1)
State:LookingForMethods                         equate(2)
CurrentClass                                    &DCL_System_Class
    code
    State = State:LookingForClass
    !ClassFile &= FileMgr.GetAsciiFileInstance(1)
    ClassFile.OpenFile(filename)
    if ClassFile.Errors.Count() > 0
        !dbg.write('Error opening ' & filename)
        self.Errors.AddErrors(ClassFile.Errors)
        return FALSE
    end
    loop while ClassFile.Read(Txt) = level:benign
        str.Assign(Txt)
        str.Trim()
        if str.BeginsWith('!') then cycle.
        str.Split('!')
        str.Assign(UPPER(str.GetLine(1))) ! Remove any comments
        str.Trim()
        !dbg.write('State: ' & state & ', Line: ' & txtupper)
        case state
        of State:LookingForClass
            if str.Contains(' CLASS,') or str.Contains(' CLASS(')
                CurrentClass &= self.AddClass(str.SubString(1,str.IndexOf(' ')-1))
                !dbg.write('class name set to ' & CurrentClass.Name)
                State = State:LookingForMethods
            end
        of State:LookingForMethods
            if str.Get() = 'END'
                State = State:LookingForClass
            else
                if str.Contains(' PROCEDURE(') or str.Contains(' PROCEDURE,') or str.EndsWith(' PROCEDURE') |
                    or str.Contains(' FUNCTION(') or str.Contains(' FUNCTION,') or str.EndsWith(' FUNCTION')
                    CurrentClass.AddMethod(str.Get())
                end
            end
        end
        
    end
    ClassFile.CloseFile()
    return false

DCL_System_ClassParser.Reset                procedure
x   long    
    code
    loop x = 1 to RECORDS(self.ClassQ)
        GET(self.ClassQ,x)
        dispose(self.ClassQ.Class_)
    end
    FREE(self.ClassQ)



!    loop while ClassFile.Read(Txt) = level:benign
!        str.Assign(Txt)
!        str.Split('!')
!        str.Assign(UPPER(str.GetLine(1))) ! Remove any comments
!        TxtUpper = str.Get()
!        !dbg.write('State: ' & state & ', Line: ' & txtupper)
!        case state
!        of State:LookingForClass
!            if INSTRING(' CLASS,',TxtUpper,1,1) or Instring(' CLASS(',TxtUpper,1,1)
!                self.Name = str.SubString(1,INSTRING(' ',Txt,1,1))
!                !dbg.write('class name set to ' & self.Name)
!                State = State:LookingForMethods
!            else
!                !dbg.write('class name not found')
!            end
!        end
!        
!    end
