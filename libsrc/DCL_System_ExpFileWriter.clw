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



    Include('DCL_System_ExpFileWriter.inc'),Once
    include('DCL_System_String.inc'),once
    include('DCL_System_Class.inc'),once
    include('DCL_System_ClassParser.inc'),once
    INCLUDE('DCL_System_IO_AsciiFile.inc'),ONCE
    !include('DCL_System_Diagnostics_Logger.inc'),once

!dbg                                     DCL_System_Diagnostics_Logger

DCL_System_ExpFileWriter.Construct          Procedure()
    code
    !self.Errors &= new DCL_System_ErrorManager
    self.ClassHeaderQ &= new DCL_System_ExpFileWriter_HeaderFileQueue


DCL_System_ExpFileWriter.Destruct           Procedure()
    code
    !dispose(self.Errors)
    FREE(self.ClassHeaderQ)
    dispose(self.ClassHeaderQ)

DCL_System_ExpFileWriter.AddClassHeaderFile procedure(string filename)
    code
    CLEAR(self.ClassHeaderQ)
    self.ClassHeaderQ.Filename = filename
    ADD(self.ClassHeaderQ)

DCL_System_ExpFileWriter.WriteExpFile       procedure(string appname,<string directoryname>)
ExportsQ                                        queue
Txt                                                 cstring(500)
                                                end
cls                                             &DCL_System_Class
parser                                          DCL_System_ClassParser
x                                               long
y                                               long
str                                             DCL_System_String
FileMgr                                         DCL_System_IO_AsciiFileManager
ExpFile                                       &DCL_System_IO_AsciiFile
    code
    loop x = 1 to RECORDS(self.classheaderq)
        GET(self.classheaderq,x)
        parser.Reset()
        parser.Parse(self.ClassHeaderQ.Filename)
        loop y = 1 to parser.ClassCount()
            cls &= parser.GetClass(y)
            if not cls &= null
                cls.GetExports(ExportsQ,FALSE)
            end
        end
    end
    if not omitted(directoryname)
        str.Assign(directoryname)
    else
        str.Assign(LONGPATH())
    end
    if ~str.EndsWith('\') then str.Append('\').
    str.Append(CLIP(appname) & '.EXP')
    ExpFile &= FileMgr.GetAsciiFileInstance(1)
    if ExpFile.CreateFile(str.Get()) = Level:Benign
        ExpFile.Write('LIBRARY ''' & CLIP(appname) & ''' GUI')
        Expfile.Write('EXPORTS')
        loop x = 1 to RECORDS(ExportsQ)
            GET(exportsq,x)
            ExpFile.Write(ExportsQ.Txt)
        end
    end
    ExpFile.CloseFile()   
