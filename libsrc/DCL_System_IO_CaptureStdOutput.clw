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


										member()


	include('DCL_Windows_API_Equates.inc'),once
										map
											include('DCL_Windows_API_Functions.inc'),once
	
										end


	Include('Equates.CLW'),ONCE
	Include('Keycodes.CLW'),ONCE
	Include('Errors.CLW'),ONCE
	include('DCL_System_Diagnostics_Logger.inc'),once
	Include('DCL_System_IO_CaptureStdOutput.inc'),ONCE
	!------------------------------------------------------------------------------
DCL_System_IO_CaptureStdOutput.ErrorHandler     PROCEDURE  (<STRING pErrorMsg>)  ! Declare Procedure 3
lErrMsg                                             CSTRING(512)
VA_List                                             CSTRING(20)
	CODE
	SELF.ErrMsg = ''
	IF OMITTED(2)
		Self.ErrorCode = DCL_API_GetLastError()
		IF DCL_API_FormatMessage(BOR(BOR(DCL_api_FORMAT_MESSAGE_FROM_SYSTEM,DCL_api_FORMAT_MESSAGE_IGNORE_INSERTS),DCL_api_FORMAT_MESSAGE_MAX_WIDTH_MASK)|
			, 0, Self.ErrorCode, DCL_API_LANG_USER_DEFAULT, lErrMsg, SIZE(lErrMsg), VA_List)
			Self.ErrMsg = lErrMsg
		ELSE
			SELF.ErrMsg = 'An unknown error has occurred.'
		END
	ELSE
		SELF.ErrMsg = CLIP(LEFT(pErrorMsg))
	END

	IF Self.SupressErrors
		Self.DebugOutput('------- error Create Process: ' & SELF.ErrMsg)
	ELSE
		MESSAGE('An error has occurred while attempting to create the requested process.' & |
			'|Error posted: ' & SELF.ErrMsg, |
			'Error creating process', ICON:Hand)
	END
DCL_System_IO_CaptureStdOutput.DebugOutput      PROCEDURE  (STRING pDebugString) 
lCString                                            &CSTRING
	CODE
	lCString &= NEW CSTRING(LEN(CLIP(pDebugString)) + 3)
	lCString = CLIP(pDebugString) & '<13,10,0>'
	DCL_api_OutPutDebugString(lCString)
	DISPOSE(lCString)
	
DCL_System_IO_CaptureStdOutput.Run      PROCEDURE (STRING pExecCmd, <*DCL_System_String pResults>,USHORT pExecMode=DCL_System_IO_CaptureStdOutput_Window_HIDE, BYTE pUseCMD=1)!,LONG,PROC ,VIRTUAL 
	CODE
	!gdbg.write('Calling run on cmd ' & pExecCmd)
	return self.CreateProcessCaptureOutput(pExecCmd,pExecCmd,pUseCMD, , , , , pResults)
	
	!------------------------------------------------------------------------------
DCL_System_IO_CaptureStdOutput.CreateProcessCaptureOutput       PROCEDURE  (STRING pExecCmd, USHORT pExecMode, BYTE pUseCMD=1, <STRING pPath>, <STRING pMessage>, <STRING pTitle>, <*LONG pExitCommand>, <*DCL_System_String pResults>) !,LONG,PROC ! Declare Procedure 3
WindowOpened                                                        BYTE
CommandPrefix                                                       CSTRING(132)                          ! either CMD.EXE /C or COMMAND.COM /C depening upon platform
ProcessID                                                           LONG                                  !
RetVal                                                              BYTE                                  !
rVal                                                                LONG
ExecCmdWinCommand                                                   &CSTRING
ExecCmdWinExecMode                                                  USHORT
procPath                                                            CSTRING(File:MaxFilePath)
lEnvironStr                                                         CSTRING(256),AUTO
ExecWindow                                                          WINDOW('Execute Command'),AT(,,302,117),FONT('MS Sans Serif',10,,FONT:regular),CENTER,IMM, |
																		CURSOR(CURSOR:Wait),TIMER(10),GRAY,DOUBLE
																		STRING('Executing Command...'),AT(44,11,213,10),USE(?Message),CENTER
																		TEXT,AT(2,23,297,89),USE(?OutputText),BOXED,HVSCROLL,READONLY
																	END
ExecCmdwCreateFlags                                                 DCL_API_DWORD
ExecCmdExitCode                                                     DCL_API_DWORD
ExecCmdApplicationName                                              CSTRING(255)
ExecCmdStartupInfo                                                  LIKE(DCL_api_StartupInfo)
ExecCmdProcessInformation                                           LIKE(DCL_api_ProcessInformation)
StdOutRedirectFile                                                  CSTRING(100)
StdErrRedirectFile                                                  CSTRING(100)
stdOutsa                                                            LIKE(DCL_api_SECURITY_ATTRIBUTES)
stdErrsa                                                            LIKE(DCL_api_SECURITY_ATTRIBUTES)
stdoldOut                                                           DCL_API_HANDLE
stdoldErr                                                           DCL_API_HANDLE
lNoFree                                                             BYTE
																	!Pipe Stuff
hChildStdoutRd                                                      DCL_API_HANDLE
hChildStdErrWr                                                      DCL_API_HANDLE
hChildStdoutWr                                                      DCL_API_HANDLE
hChildStdInWr                                                       DCL_API_HANDLE
duphChildStdoutRd                                                   DCL_API_HANDLE
hProc                                                               DCL_API_HANDLE
saAttr                                                              LIKE(DCL_api_SECURITY_ATTRIBUTES)
chBuf                                                               CSTRING(4096)
BUFSIZE                                                             LONG(SIZE(chBuf))
dwRead                                                              LONG
lResults                                                            DCL_System_String
hConsoleWin                                                         DCL_API_HWND

	CODE
	RetVal = FALSE
	lEnvironStr = 'COMSPEC'
	CommandPrefix = DCL_API_GetEnvironment(lEnvironStr)
	CommandPrefix = CommandPrefix & ' /C '

	ExecCmdWinCommand          &= NEW(CSTRING(LEN(CommandPrefix & pExecCmd)+1))
	ExecCmdWinCommand          = CHOOSE(pUseCMD,CommandPrefix,'') & pExecCmd
	ExecCmdWinExecMode         = pExecMode
	ExecCmdwCreateFlags        = DCL_API_CREATE_DEFAULT_ERROR_MODE + DCL_API_NORMAL_PRIORITY_CLASS
	ExecCmdStartupInfo.cb      = SIZE(ExecCmdStartupInfo)
	ExecCmdStartupInfo.dwFlags = DCL_API_STARTF_USESHOWWINDOW + DCL_API_STARTF_USESTDHANDLES

	hProc = DCL_API_GetCurrentProcess()
	CLEAR(saAttr)
	saAttr.bInheritHandle = TRUE
	saAttr.nLength = SIZE(saAttr)
	!create our pipe to capture the process output
	IF NOT DCL_API_CreatePipe(ADDRESS(hChildStdoutRd), |
		ADDRESS(hChildStdoutWr), |
		ADDRESS(saAttr), |
		0)
		Self.ErrorHandler()
		DO CleanupAndReturn
	END

	!create an inheritable duplicate handle to the pipe to use for the stdErr value
	IF NOT DCL_API_DuplicateHandle(hProc, |
		hChildStdoutWr, |
		hProc, |
		ADDRESS(hChildStdErrWr), |
		0, |
		TRUE, |
		DCL_api_DUPLICATE_SAME_ACCESS)
		Self.ErrorHandler()
		DO CleanupAndReturn
	END
	!create a NON inheritable duplicate handle to the pipe to use in this process for reading the pipe
	IF NOT DCL_API_DuplicateHandle(hProc, |
		hChildStdoutRd, |
		hProc,|
		ADDRESS(duphChildStdoutRd), |! Address of new handle.
		0, |
		FALSE,             |! Make it uninheritable.
		DCL_api_DUPLICATE_SAME_ACCESS)
		Self.ErrorHandler()
		DO CleanupAndReturn
	END
	! close the Child read end of the pipe for stdout and stderr. The child process will only write to the pipe.
	IF NOT DCL_API_CloseHandle(hChildStdoutRd)
		Self.ErrorHandler()
		DO CleanupAndReturn
	Else
		Clear(hChildStdoutRd)
	END
	!
	!Set the process startup info handles to the new write handle for our pipe
	ExecCmdStartupInfo.hStdOutput = hChildStdoutWr
	ExecCmdStartupInfo.hStdError  = hChildStdErrWr

	SETCURSOR(CURSOR:Wait)
	IF NOT OMITTED(pPath)
		procPath = pPath
		ProcessID = DCL_API_CreateProcess(0,|
			ADDRESS(ExecCmdWinCommand),|
			0,|
			0,|
			true,|
			ExecCmdwCreateFlags, |
			0,|
			ADDRESS(procPath),|
			ADDRESS(ExecCmdStartupInfo),|
			ADDRESS(ExecCmdProcessInformation))
	ELSE
		ProcessID = DCL_API_CreateProcess(0, |
			ADDRESS(ExecCmdWinCommand),|
			0,|
			0,|
			true,|
			ExecCmdwCreateFlags, |
			0,|
			0,|
			ADDRESS(ExecCmdStartupInfo),|
			ADDRESS(ExecCmdProcessInformation))
	END
	!You need to close the write end of the pipes in THIS process before trying to
	!read from the read end of the pipe. If you don't do this then DCL_API_ReadFile will hang.
	!The child process already has handles to the pipe after CreateProcess so you don't have to worry.
	IF NOT DCL_API_CloseHandle(hChildStdoutWr)
		Self.ErrorHandler()
		DO CleanupAndReturn
	Else
		Clear(hChildStdoutWr)
	END
	IF NOT DCL_API_CloseHandle(hChildStdErrWr)
		Self.ErrorHandler()
		DO CleanupAndReturn
	Else
		Clear(hChildStdErrWr)
	END
	IF ProcessID
		OPEN(ExecWindow)
		WindowOpened=True
		IF NOT pTitle AND NOT pMessage
			ExecWindow{PROP:Hide} = True
		ELSE
			ExecWindow{PROP:Text} = CLIP(pTitle)
			?Message{PROP:Text}   = CLIP(pMessage)
		END
		ACCEPT
			CASE EVENT()
			OF Event:Timer
				rVal = DCL_API_ReadFile( duphChildStdoutRd, ADDRESS(chBuf), BUFSIZE, ADDRESS(dwRead), 0)
				IF NOT rVal OR dwRead = 0
					IF NOT rVal AND DCL_API_GetLastError() <> DCL_API_ERROR_BROKEN_PIPE
						Self.ErrorHandler()
						lResults.Assign(CLIP(Self.ErrMsg))
					END
					0{prop:Timer} = 0
					BREAK
				END
				chBuf[dwRead+1] = '<00>'
				lResults.Append(chBuf)
				?OutputText{Prop:Text} = ?OutputText{Prop:Text} & chBuf
				?OutputText{prop:Vscrollpos} = 255
				DISPLAY(?OutputText)
			END
		END
		rVal = DCL_API_GetExitCodeProcess(ExecCmdProcessInformation.hProcess, ADDRESS(ExecCmdExitCode))
		IF NOT OMITTED(pExitCommand)
			pExitCommand = ExecCmdExitCode
		END
		retVal = true
	ELSE
		Self.ErrorHandler()
		lResults.Assign(CLIP(Self.ErrMsg))
		retVal = False
	END
	SETCURSOR()
	!
	DO CleanupAndReturn

	!---------------------------------------------------------------------------
CleanupAndReturn                        ROUTINE
  
	If hChildStdoutRd
		R# = DCL_API_CloseHandle(hChildStdoutRd)
	End
	If hChildStdoutWr
		R# = DCL_API_CloseHandle(hChildStdoutWr)
	End
	If duphChildStdoutRd
		R# = DCL_API_CloseHandle(duphChildStdoutRd)
	End
	IF ExecCmdProcessInformation.hProcess AND ExecCmdProcessInformation.hProcess <> DCL_API_INVALID_LONG_VALUE
		R# = DCL_API_CloseHandle(ExecCmdProcessInformation.hProcess)
	END
	IF ExecCmdProcessInformation.hThread AND ExecCmdProcessInformation.hThread <> DCL_API_INVALID_LONG_VALUE
		R# = DCL_API_CloseHandle(ExecCmdProcessInformation.hThread)
	END
	IF NOT ExecCmdWinCommand &= NULL
		DISPOSE(ExecCmdWinCommand)
	END
	IF NOT OMITTED(pResults)
		pResults.Assign(lResults.Get())
	END
	IF WindowOpened
		CLOSE(ExecWindow)
	END
	Return RetVal


