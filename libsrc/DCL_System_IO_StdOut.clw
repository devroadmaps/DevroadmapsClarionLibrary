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
                                            MAP
                                                module('')
                                                    AllocConsole(),BOOL,PASCAL,proc
                                                    FreeConsole(),BOOL,PASCAL,Proc
                                                    GetStdHandle(ulong HandleEquate),long,PASCAL,PROC,RAW
                                                    !CloseHandle( ulong hObject ), short, raw, pascal
                                                    !WriteFile(handle,long,dword,long,long),bool,raw,pascal
                                                    WriteFile(long hFile, *cstring buffer, long nNumberOfButesToWrite, *long lpNumberOfBytesWritten, ulong lpOverlapped), short, raw, pascal,proc
                                                end
                                            END

STD_OUTPUT_HANDLE                           EQUATE(-11)


    Include('DCL_System_IO_StdOut.inc'),Once
    include('DCL_System_Diagnostics_Logger.inc'),once

dbg                                     DCL_System_Diagnostics_Logger

DCL_System_IO_StdOut.Construct              Procedure()
    code
    !self.Errors &= new DCL_System_ErrorManager
    dbg.write('Construct')
    self.ConsoleOpen = false

DCL_System_IO_StdOut.Destruct               Procedure()
    code
    !dispose(self.Errors)
    self.CloseConsole()
    
DCL_System_IO_StdOut.CloseConsole           procedure
    code
    if self.ConsoleOpen
        FreeConsole()
    end
    
DCL_System_IO_StdOut.OpenConsole            procedure
    code
    if not self.ConsoleOpen
        AllocConsole()    
        self.StdOutHandle = GetStdHandle(STD_OUTPUT_HANDLE)
        dbg.write('self.StdOutHandle ' & self.StdOutHandle)
        if self.StdOutHandle > 0
            self.ConsoleOpen = TRUE
        else
            FreeConsole()
            ! Should really log an error
        end
    end
        
DCL_System_IO_StdOut.Write                  procedure(string pMsg)
msg                                             &CString
BytesWritten                                    long
BytesToWrite                                    long
    code
    dbg.write('Calling OpenConsole')
    dbg.write('String length: ' & len(clip(pMsg)))
    msg &= new Cstring(len(clip(pMsg)))
    msg = clip(pMsg)! & '<13,10>'
    self.OpenConsole()
    if self.ConsoleOpen and self.StdOutHandle > 0
        dbg.write('writing >' & msg & '<')
        WriteFile(self.StdOutHandle,msg,len(clip(msg)),BytesWritten,0)
!        BytesToWrite = len(clip(msg))
!        msg = clip(msg) & '<13,10>'
!        WriteFile(self.StdOutHandle,msg,BytesToWrite+2,BytesWritten,0)
        dbg.write('wrote ' & BytesWritten & ' bytes')
    end
    dispose(msg)
    


    




