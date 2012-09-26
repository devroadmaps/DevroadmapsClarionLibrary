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

    include('DCL_IncludeInAllClassHeaderFiles.inc'),once


    INCLUDE('ABfile.equ'),ONCE
    include('DCL_System_ErrorManager.inc'),once

ASCII_IO_RECORD_SIZE                    EQUATE(5000)
MaxPathLength                           equate(FILE:MaxFileName + FILE:MaxFilePath + 1)

DCL_System_IO_AsciiFile_InstanceNumber1  equate(1)
DCL_System_IO_AsciiFile_InstanceNumber2  equate(2)
DCL_System_IO_AsciiFile_InstanceNumber3  equate(3)

DCL_System_IO_AsciiFileManager           CLASS,MODULE('DCL_System_IO_AsciiFile.clw'),LINK('DCL_System_IO_AsciiFile.clw',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
GetAsciiFileInstance                        procedure(long instanceNumber),*DCL_System_IO_AsciiFile    
                                        end

!--------------------------------------------------------------------------------
! Sample usage    
!--------------------------------------------------------------------------------
!AsciiFile                               &DCL_System_IO_AsciiFile
!	code
!	AsciiFile &= DCL_System_IO_AsciiFileManager.GetAsciiFileInstance(DCL_System_IO_AsciiFile_InstanceNumber1)

DCL_System_IO_AsciiFile                  CLASS,TYPE,MODULE('DCL_System_IO_AsciiFile.clw'),LINK('DCL_System_IO_AsciiFile.clw',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
Errors                                      &DCL_System_ErrorManager
FileRef                                     &File,protected
FileTxtRef                                  &string,protected
FileNameRef                                 &string,protected
CurrentFileName                             cstring(MaxPathLength)
OpenMode                                    long
Autoflush                                   byte(false)
!AsciiText                       &string
Construct                                   PROCEDURE
Destruct                                    procedure
!Reset                           PROCEDURE(*STRING Filename),BYTE
CloseFile                                   PROCEDURE()
CreateFile                                  PROCEDURE(STRING AsciiFileName, LONG OpenMode=ReadWrite+DenyWrite),byte,proc
GetName                                     procedure,string
Init                                        PROCEDURE(<STRING AsciiFileName>, BYTE CreateFile=False, LONG OpenMode=ReadWrite+DenyWrite),byte,proc
Init                                        PROCEDURE(FILE AFile,*STRING FileLine,*STRING FName)
IsOpen                                      procedure,byte
LoadFile                                    procedure(*queue q,*cstring qField)
OpenFile                                    PROCEDURE(STRING fname, LONG OpenMode=ReadWrite+DenyWrite), BYTE, PROC
Read                                        PROCEDURE(*CSTRING TextLine), BYTE, PROC
Replace                                     procedure(string filename,*queue q,*cstring qField),long
Write                                       PROCEDURE(STRING TextLine),byte,proc
Write                                       procedure(*queue q,*cstring qfield)
                                        END

