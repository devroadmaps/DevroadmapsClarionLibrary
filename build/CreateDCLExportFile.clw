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

  PROGRAM


                                            MAP
                                            END

    include('DCL_System_ExpFileWriter.inc'),once

ExpWriter                                   DCL_System_ExpFileWriter

    CODE
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_Clarion_TXAParser.inc')
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_ClarionTest_TestProcedures.inc')
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_Data_Datafier.inc')
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Class.inc')
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_ClassParser.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Diagnostics_FileLogger.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Diagnostics_Logger.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Diagnostics_Profiler.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Diagnostics_Timer.inc') 
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Diagnostics_Tracer.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_ErrorManager.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_ExpFileWriter.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_IO_AsciiFile.inc')
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_IO_CaptureStdOutput.inc')
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_IO_Directory.inc')
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_IO_File.inc')
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_IO_FileInfo.inc')
	ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Mangle.inc')
    !ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Runtime_DirectoryWatcher.inc') ! DO NOT INCLUDE
    !ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Runtime_DLL.inc') ! DO NOT INCLUDE
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Stack.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_StackNode.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_String.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_StringUtility.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_System_Threading_CriticalSection.inc')
    ExpWriter.AddClassHeaderFile('..\libsrc\DCL_Text_RTF.inc')
	ExpWriter.AddCustomExportStatement('  $gdbg @?') 
	ExpWriter.AddCustomExportStatement('  $gDatafier @?') 
	ExpWriter.AddCustomExportStatement('  $DCL_SYSTEM_IO_ASCIIFILEMANAGER @?') 

	ExpWriter.WriteExpFile('DevRoadmapsClarion')
