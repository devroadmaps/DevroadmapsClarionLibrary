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
   						!API Prototypes
						Module('api')
							lstrlen(long),SIGNED,PASCAL,NAME('lstrLenA')
							FormatMessage(ulong,long,ulong,ulong,long,ulong,long),ulong,PASCAL,RAW,Name('FormatMessageA')
							LocalFree(long),long,PASCAL,proc
							memcpy(long,long,long),long,name('_memcpy'),proc
							getlasterror(),ulong,pascal,name('getlasterror')
							LoadLibrary(*cstring),unsigned,PASCAL,RAW,NAME('LoadLibraryA')
							FreeLibrary(unsigned),BOOL,PASCAL,proc
							GetProcAddress(unsigned, *Cstring),long,pascal,raw
							strcpy(long,long),long,pascal,raw,name('lstrcpy'),proc
						end
						module('DCL_CallA')
							CallA_P0(long,long,long,long),long,name('CALLA')
							CallA_P1(long,long,long,long,long),long,Name('CALLA')
							CallA_P2(long,long,long,long,long,long),long,Name('CALLA')
							callA_p3(long,long,long,long,long,long,long),long,Name('CALLA')
							callA_p4(long,long,long,long,long,long,long,long),long,Name('CALLA')
							callA_p5(long,long,long,long,long,long,long,long,long),long,Name('CALLA')
							callA_p6(long,long,long,long,long,long,long,long,long,long),long,Name('CALLA')
							callA_p7(long,long,long,long,long,long,long,long,long,long,long),long,Name('CALLA')
							callA_p8(long,long,long,long,long,long,long,long,long,long,long,long),long,Name('CALLA')
							callA_p9(long,long,long,long,long,long,long,long,long,long,long,long,long),long,Name('CALLA')
							callA_p10(long,long,long,long,long,long,long,long,long,long,long,long,long,long),long,Name('CALLA')
							fixstack(long,long,long,long),long,name('FIXSTACK')
						End
						module('')
							clastart(long lpproc,long pStackSize),long,proc,name('CLA$START')
							clastart1(long lpproc,long pStackSize,string param1),long,proc,name('CLA$START1')
							clastart2(long lpproc,long pStackSize,string param1, string param2),long,proc,name('CLA$START2') 
							clastart3(long lpproc,long pStackSize,string param1, string param2, string param3),long,proc,name('CLA$START3') 
						end
					END

	include('DCL_System_Runtime_Dll.inc'),once
	include('DCL_System_Diagnostics_Logger.inc'),once

!global data for this module
Return:Benign       equate(0)
Return:Fatal        equate(3)
Return:Notify       equate(5)

AddressQtype        queue,type
procname                string(120)
lpaddress               long
					end


FilenameVariable            CSTRING(FILE:MaxFilePath+FILE:MaxFileName+1),STATIC     ! File name for input and output files

!! LIBfile is used to read and write import library files
!
LIBfile             FILE,DRIVER('DOS','/FILEBUFFERS=20'),PRE(LIB),CREATE,NAME(FilenameVariable)
Record                  RECORD
RawBytes                    BYTE,DIM(1024)
header                      GROUP,OVER(RawBytes)
typ                             BYTE             ! OMF record type = 88H (Coment)
len                             USHORT           ! Size of OMF record to follow
kind                            USHORT           ! Comment kind = 0A000H
bla                             BYTE             ! Always 1 for our purposes
ordflag                         BYTE             ! ditto
							END
! For the records we want, the header is follower by the pubname
! and modname in PSTRING format, then the ordinal export number (USHORT)

pstringval                  PSTRING(128),OVER(RawBytes)
ushortval                   USHORT,OVER(RawBytes)
						END
					END

TxtFile             FILE,PRE(Txt),DRIVER('ASCII','/FILEBUFFERS=20'),CREATE,NAME(FilenameVariable)
Record                  RECORD
Line                        STRING(256)
						END
					END

! EXEfile is used for reading NE and PE format executable files

EXEfile             FILE,DRIVER('DOS','/FILEBUFFERS=20'),PRE(EXE),NAME(FilenameVariable)
Record                  RECORD
RawBytes                    BYTE,DIM(1024)
cstringval                  CSTRING(128),OVER(RawBytes)
pstringval                  PSTRING(128),OVER(RawBytes)
ulongval                    ULONG,OVER(RawBytes)
ushortval                   USHORT,OVER(RawBytes)

! DOSheader is the old exe (stub) header format
DOSheader                   GROUP,OVER(RawBytes)
dos_magic                       STRING(2)         ! contains 'MZ'
dos_filler                      USHORT,DIM(29)    ! we don't care about these fields
dos_lfanew                      ULONG             ! File offset of new exe header
							END

! NEheader is the new exe (16-bit) header format
NEheader                    GROUP,OVER(RawBytes)
ne_magic                        STRING(2)         ! Contains 'NE'
ne_ver                          BYTE
ne_rev                          BYTE
ne_enttab                       USHORT
ne_cbenttab                     USHORT
ne_crc                          LONG
ne_flags                        USHORT
ne_autodata                     USHORT
ne_heap                         USHORT
ne_stack                        USHORT
ne_csip                         ULONG
ne_sssp                         ULONG
ne_cseg                         USHORT
ne_cmod                         USHORT
ne_cbnrestab                    USHORT
ne_segtab                       USHORT
ne_rsrctab                      USHORT
ne_restab                       USHORT
ne_modtab                       USHORT
ne_imptab                       USHORT
ne_nrestab                      ULONG
ne_cmovent                      USHORT
ne_align                        USHORT
ne_rescount                     USHORT
ne_osys                         BYTE
ne_flagsother                   BYTE
ne_gangstart                    USHORT
ne_ganglength                   USHORT
ne_swaparea                     USHORT
ne_expver                       USHORT           ! Expected Window version number
							END

! PEheader is the flat-model (32-bit) header format (PE signature)
PEheader                    GROUP,OVER(RawBytes)
pe_signature                    ULONG
pe_machine                      USHORT
pe_nsect                        USHORT
pe_stamp                        ULONG
pe_psymbol                      ULONG
pe_nsymbol                      ULONG
pe_optsize                      USHORT
pe_character                    USHORT
							END

! Optheader is the "optional header" that follows the PEheader

OptHeader                   GROUP,OVER(RawBytes)
opt_Magic                       USHORT
opt_MajorLinkerVer              BYTE
opt_MinorLinkerVer              BYTE
opt_SizeOfCode                  ULONG
opt_SizeOfInitData              ULONG
opt_SizeOfUninit                ULONG
opt_EntryPoint                  ULONG
opt_BaseOfCode                  ULONG
opt_BaseOfData                  ULONG
opt_ImageBase                   ULONG
opt_SectAlignment               ULONG
opt_FileAlignment               ULONG
opt_MajorOSVer                  USHORT
opt_MinorOSVer                  USHORT
opt_MajorImageVer               USHORT
opt_MinorImageVer               USHORT
opt_MajorSubVer                 USHORT
opt_MinorSubVer                 USHORT
opt_Reserved1                   ULONG
opt_SizeOfImage                 ULONG
opt_SizeOfHeaders               ULONG
opt_CheckSum                    ULONG
opt_Subsystem                   USHORT
opt_DllChar                     USHORT
opt_StackReserve                ULONG
opt_StackCommit                 ULONG
opt_HeapReserve                 ULONG
opt_HeapCommit                  ULONG
opt_LoaderFlags                 ULONG
opt_DataDirNum                  ULONG
							END

! The Optional header is followed by an array of the following structures

DataDir                     GROUP,OVER(RawBytes)
data_VirtualAddr                ULONG
data_Size                       ULONG
							END

! SectHeader describes a section in a PE file
SectHeader                  GROUP,OVER(RawBytes)
sh_SectName                     CSTRING(8)
sh_VirtSize                     ULONG
sh_PhysAddr                     ULONG,OVER(sh_VirtSize)
sh_VirtAddr                     ULONG
sh_RawSize                      ULONG
sh_RawPtr                       ULONG
sh_Reloc                        ULONG
sh_LineNum                      ULONG
sh_RelCount                     USHORT
sh_LineCount                    USHORT
sh_Character                    ULONG
							END

! ExpDirectory is at start of a .edata section in a PE file
ExpDirectory                GROUP,OVER(RawBytes)
exp_Character                   ULONG
exp_stamp                       ULONG
exp_Major                       USHORT
exp_Minor                       USHORT
exp_Name                        ULONG
exp_Base                        ULONG
exp_NumFuncs                    ULONG
exp_NumNames                    ULONG
exp_AddrFuncs                   ULONG
exp_AddrNames                   ULONG
exp_AddrOrds                    ULONG
							END
						END
					END

newoffset           ULONG   ! File offset to NE/PE header





!dbg                 DCL_System_Diagnostics_Logger

DCL_System_Runtime_Dll.construct     procedure()
	code
	clear(SELF)
	self.ExportQ &= new(DCL_System_Runtime_DllExportQueue)
	SELF.AddressQ &= New AddressQtype
	
	
DCL_System_Runtime_Dll.destruct      procedure()
	code
	dispose(SELF.AddressQ)
	free(self.ExportQ)
	dispose(self.ExportQ)
	
	


DCL_System_Runtime_Dll.Init  Procedure(string pDllPath, byte pDebug=0)
cPath                   cstring(File:maxfilepath),auto
	Code
	if ~self.Initialized
		!dbg..write('DCL_System_Runtime_Dll.Init DLL ' & FilenameVariable)
		clear(SELF.eProcFail)
		SELF.Debug=pDebug
		if ~pDllPath then
			SELF.IgnoreDllHandle=true
		else
			SELF.IgnoreDllHandle=false
			cpath=clip(pDllPath)
			!gdbg.write('Calling LoadLibary for ' & cpath)
			SELF.DllHandle=loadlibrary(cpath)
			if ~SELF.DllHandle then
				SELF.TakeError('LoadLibrary failed for: ' & cpath)
				return return:fatal
			end
			!gdbg.write('Loaded library, got handle ' & self.dllhandle & ' for dll ' & cpath)
		end
		!dbg..write('DLL initialized')
		self.Initialized = true
	ELSE
		!dbg..write('DCL_System_Runtime_Dll.Init not needed for DLL ' & FilenameVariable)
	end
	Return return:benign

DCL_System_Runtime_Dll.IsInitialized       procedure!,byte	
	CODE
	return self.Initialized

DCL_System_Runtime_Dll.Kill  Procedure()
!destroy any dynamic objects and clean up
	Code
	if self.Initialized
		!gdbg.write('DCL_System_Runtime_Dll.Kill')
		if ~SELF.addressQ &= NULL then free(SELF.AddressQ).
		if SELF.DllHandle and ~SELF.IgnoreDllHandle 
			!gdbg.write('Calling FreeLibrary')
			freelibrary(SELF.DllHandle)
			clear(SELF.DllHandle)
		END
		
		self.Initialized = false
	ELSE
		!dbg..write('DCL_System_Runtime_Dll.Kill skipped for DLL ' & FilenameVariable)
	end
	RETURN

DCL_System_Runtime_Dll.TakeError     Procedure(string pError)
	code
	SELF.Errorstr=pError
	If SELF.Debug then message(pError).
	return



!----------  Address management ----------------------------------------------

DCL_System_Runtime_Dll.SetProcFailCode       procedure(long pFailcode)
	Code
	SELF.eProcFail = pFailcode
	return 0


DCL_System_Runtime_Dll.addaddress    Procedure(string procname, long lpProcName)
	code
	SELF.AddressQ.procname=procname
	get(SELF.AddressQ, SELF.AddressQ.Procname)
	if Errorcode() then
		SELF.AddressQ.lpaddress=lpProcname
		add(SELF.AddressQ,SELF.AddressQ.ProcName)
		if errorcode() then return 3.
	else
		SELF.AddressQ.lpAddress=lpProcName
		put(SELF.AddressQ)
		if errorcode() then return 3.
	end
	return 0

DCL_System_Runtime_Dll.GetAddress    Procedure(string procname)
cProcName                       cstring(80),auto
lpaddress                       long,auto
	code
	!gdbg.write('DCL_System_Runtime_Dll.GetAddress receives ' & procname)
	if ~SELF.DllHandle and ~SELF.IgnoreDllHandle then
		!gdbg.write('Get Address called before a dll is loaded!!!')
		SELF.TakeError('Get Address called before a dll is loaded!!!')
		Return SELF.eProcFail
	end

	SELF.AddressQ.procname=procname
	get(SELF.AddressQ, SELF.AddressQ.Procname)
	if ~Errorcode() then
		!gdbg.write('Using address from addressq')
		return SELF.AddressQ.lpAddress
	end

  !exit now if no dll loaded - the next block of code
  !  requires an DllHandle.
	if SELF.IgnoreDllHandle 
		!gdbg.write('Exiting, self.IgnoreDllHandle set to true (this is a fail)')
		return SELF.eProcFail
	end

	cProcName=clip(procname)
	lpAddress=GetProcAddress(SELF.DllHandle,cProcName)
	!gdbg.write('lpAddress ' & lpaddress)
	if lpAddress then
		SELF.AddressQ.procname=procname
		SELF.AddressQ.lpAddress=lpaddress
		add(SELF.AddressQ,SELF.Addressq.procname)
	else
		!gdbg.write('GetProcAddress failed for ' & cProcName & ' using handle ' & self.DllHandle & ', error ' & getlasterror())
		SELF.TakeError('get adress failed for ' & cProcName)
		Return SELF.eProcFail
	end
	return lpaddress
!------------------------- Pascal Calling convention call functions -------------------
DCL_System_Runtime_Dll.call  procedure(string procname, <long p1>,<long p2>,<long p3>,<long p4>,<long p5>,<long p6>,<long p7>,<long p8>,<long p9>,<long p10>)
lpaddress               long,auto
	code
	!gdbg.write('Calling procedure ' & procname)
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	if omitted(3) then return callA_p0(lpaddress,0,0,0).  !p0
	if omitted(4) then return callA_p1(lpaddress,0,0,0,p1). !p1
	if omitted(5) then return callA_p2(lpaddress,0,0,0,p2,p1). !p2
	if omitted(6) then return callA_p3(lpaddress,0,0,0,p3,p2,p1). !p3
	if omitted(7) then return callA_p4(lpaddress,0,0,0,p4,p3,p2,p1). !p4
	if omitted(8) then return callA_p5(lpaddress,0,0,0,p5,p4,p3,p2,p1). !p5
	if omitted(9) then return callA_p6(lpaddress,0,0,0,p6,p5,p4,p3,p2,p1). !p6
	if omitted(10) then return callA_p7(lpaddress,0,0,0,p7,p6,p5,p4,p3,p2,p1). !p7
	if omitted(11) then return callA_p8(lpaddress,0,0,0,p8,p7,p6,p5,p4,p3,p2,p1). !p8
	if omitted(12) then return callA_p9(lpaddress,0,0,0,p9,p8,p7,p6,p5,p4,p3,p2,p1). !p9
	return callA_p10(lpaddress,0,0,0,p10,p9,p8,p7,p6,p5,p4,p3,p2,p1)

DCL_System_Runtime_Dll.callbyAddress procedure(long lpAddress, <long p1>,<long p2>,<long p3>,<long p4>,<long p5>,<long p6>,<long p7>,<long p8>,<long p9>,<long p10>)
	code
	!gdbg.write('Calling procedure by address')
	if omitted(3) then return callA_p0(lpaddress,0,0,0).  !p0
	if omitted(4) then return callA_p1(lpaddress,0,0,0,p1). !p1
	if omitted(5) then return callA_p2(lpaddress,0,0,0,p2,p1). !p2
	if omitted(6) then return callA_p3(lpaddress,0,0,0,p3,p2,p1). !p3
	if omitted(7) then return callA_p4(lpaddress,0,0,0,p4,p3,p2,p1). !p4
	if omitted(8) then return callA_p5(lpaddress,0,0,0,p5,p4,p3,p2,p1). !p5
	if omitted(9) then return callA_p6(lpaddress,0,0,0,p6,p5,p4,p3,p2,p1). !p6
	if omitted(10) then return callA_p7(lpaddress,0,0,0,p7,p6,p5,p4,p3,p2,p1). !p7
	if omitted(11) then return callA_p8(lpaddress,0,0,0,p8,p7,p6,p5,p4,p3,p2,p1). !p8
	if omitted(12) then return callA_p9(lpaddress,0,0,0,p9,p8,p7,p6,p5,p4,p3,p2,p1). !p9
	return callA_p10(lpaddress,0,0,0,p10,p9,p8,p7,p6,p5,p4,p3,p2,p1)

!--------------------- Clarion Start Wrapper --------------------------------
DCL_System_Runtime_Dll.Start procedure(String pMdiForm, long StackSize=0,<string pS1>,<String pS2>,<String pS3>)
lpMdiForm               long,auto
	code
	lpMdiForm = SELF.GetAddress(pMdiForm)
	if lpMdiForm=SELF.eProcFail then
		SELF.TakeError('Start address resolution failed')
		return 0
	end
	if OMITTED(4) and Omitted(5) and Omitted(6) then
		Return CLASTART(lpMdiForm, Stacksize)
	end
	if ~Omitted(4) and Omitted(5) and Omitted(6) then
		Return CLASTART1(lpMdiForm, StackSize, pS1)
	end
	if ~Omitted(4) and ~Omitted(5) and Omitted(6) then
		Return ClaStart2(lpMdiForm, stacksize, pS1, pS2)
	end
	if ~Omitted(4) and ~Omitted(5) and ~Omitted(6) then
		Return ClaStart3(lpMdiForm, stacksize, pS1, pS2, pS3)
	end
	SELF.TakeError('Start called with illegal parameters')
	return 0
  
DCL_System_Runtime_Dll.StartbyAddress        procedure(long lpMDiForm, long StackSize=0,<string pS1>,<String pS2>,<String pS3>)
	code
	if OMITTED(4) and Omitted(5) and Omitted(6) then
		Return CLASTART(lpMdiForm, Stacksize)
	end
	if ~Omitted(4) and Omitted(5) and Omitted(6) then
		Return CLASTART1(lpMdiForm, StackSize, pS1)
	end
	if ~Omitted(4) and ~Omitted(5) and Omitted(6) then
		Return ClaStart2(lpMdiForm, stacksize, pS1, pS2)
	end
	if ~Omitted(4) and ~Omitted(5) and ~Omitted(6) then
		Return ClaStart3(lpMdiForm, stacksize, pS1, pS2, pS3)
	end
	SELF.TakeError('Start called with illegal parameters')
	return 0



!---------------- API error handling wrappers --------------------------

DCL_System_Runtime_Dll.getLasterror  procedure()
	code
	return getlasterror()

DCL_System_Runtime_Dll.FormatErrMsg  procedure(*string msg)
	code
	Return SELF.FormatErrMsg(msg,SELF.GetLastError())

DCL_System_Runtime_Dll.FormatErrMsg     procedure(*string msg,long EC)!,byte,proc
lpMsgBuf                        long,auto  !Address of message string formated by FormatMessage Call
lenMsgBuf                       long,auto  !char in cstring return by formatMessage
res                             byte(3)
	code
	SELF.ApiErrorcode=EC
	If FormatMessage(1100H, | !Format_Message_Allocate_Buffer + Format_message_From_System
		0, EC,0,Address(lpMsgBuf),0,0)
		lenMsgBuf = lstrlen(lpmsgBuf)
		If lenMsgBuf then
			lenMsgBuf = choose(lenMsgBuf>size(Msg), size(Msg), lenmsgbuf)
			Clear(Msg)
			memcpy(Address(Msg), lpMsgBuf, lenMsgBuf)
			res=0
		end
		If lpMsgBuf then  LocalFree(lpMsgBuf). !clean up allocated memory
	end
	Return res
!------------------- c-call stuff ------------------------------------
DCL_System_Runtime_Dll.ccall procedure(string procname, <long p1>,<long p2>,<long p3>,<long p4>,<long p5>)
lpaddress               long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	!gdbg.write('ccalling procedure ' & procname)
	if omitted(3) then return callA_p0(lpaddress,0,0,0).  !p0
	if omitted(4) then return fixstack(CallA_p1(lpaddress,0,0,0,p1),4,0,0). !p1
	if omitted(5) then return fixstack(CallA_p2(lpaddress,0,0,0,p2,p1),8,0,0). !p2
	if omitted(6) then return fixstack(CallA_p3(lpaddress,0,0,0,p3,p2,p1),12,0,0). !p3
	if omitted(7) then return fixstack(CallA_p4(lpaddress,0,0,0,p4,p3,p2,p1),16,0,0). !p4
	return fixstack(CallA_p5(lpaddress,0,0,0,p5,p4,p3,p2,p1),20,0,0)

DCL_System_Runtime_Dll.ccallbyAddress        procedure(long lpAddress, <long p1>,<long p2>,<long p3>,<long p4>,<long p5>)
	code
	!gdbg.write('ccalling procedure by address')
	if omitted(3) then return callA_p0(lpaddress,0,0,0).  !p0
	if omitted(4) then return fixstack(CallA_p1(lpaddress,0,0,0,p1),4,0,0). !p1
	if omitted(5) then return fixstack(CallA_p2(lpaddress,0,0,0,p2,p1),8,0,0). !p2
	if omitted(6) then return fixstack(CallA_p3(lpaddress,0,0,0,p3,p2,p1),12,0,0). !p3
	if omitted(7) then return fixstack(CallA_p4(lpaddress,0,0,0,p4,p3,p2,p1),16,0,0). !p4
	return fixstack(CallA_p5(lpaddress,0,0,0,p5,p4,p3,p2,p1),20,0,0)


!---------------utility function for dereferenceing a variable----------------
DCL_System_Runtime_Dll.DeRefPointer  procedure(long lpPointer, *long pDeref)
!typical use
!  mydllfunc is a function in a dll loaded by clarion ,dll(dll_mode) atribute
!  CallDllCl.DerefPointer(Address(MyDllFunct),lpMyDllFunct)
	code
	if ~lpPointer then clear(pDeref);return return:fatal.
	memcpy(Address(pDeref),lpPointer,4)
	Return Return:Benign

DCL_System_Runtime_Dll.AddAddressDeref       procedure(long lpPointer, string pName)
pDeref                                  long,auto
	code
	if ~pName then return return:fatal. 
	if SELF.DerefPointer(lppointer,pDeref) then return return:fatal.
	Return(SELF.addaddress(pname, pDeref))

!----- redundant not terribly usefull -------------------------

DCL_System_Runtime_Dll.ccall_p0      procedure(string procname)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return callA_p0(lpaddress,0,0,0)
DCL_System_Runtime_Dll.ccall_p1      procedure(string procname, long p1)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return fixstack(CallA_p1(lpaddress,4,0,0,p1),2,0,0)

DCL_System_Runtime_Dll.ccall_p2      procedure(string procname, long p1, long p2)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return fixstack(CallA_p2(lpaddress,0,0,0,p2, p1),8,0,0)


DCL_System_Runtime_Dll.ccall_p3      procedure(string procname, long p1, long p2, long p3)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return fixstack(CallA_p3(lpaddress,0,0,0,p3,p2,p1),12,0,0)

DCL_System_Runtime_Dll.ccall_p4      procedure(string procname, long p1, long p2, long p3, long p4)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return fixstack(CallA_p4(lpaddress,0,0,0,p4,p3,p2,p1),16,0,0)

DCL_System_Runtime_Dll.ccall_p5      procedure(string procname, long p1, long p2, long p3, long p4,long p5)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return fixstack(CallA_p5(lpaddress,0,0,0,p5,p4,p3,p1,p1),20,0,0)

DCL_System_Runtime_Dll.call_p0       procedure(string procname)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return callA_p0(lpaddress,0,0,0)

DCL_System_Runtime_Dll.call_p1       procedure(string procname, long p1)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return callA_p1(lpaddress,0,0,0,p1)

DCL_System_Runtime_Dll.call_p2       procedure(string procname, long p1, long p2)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return callA_p2(lpaddress,0,0,0,p2, p1)


DCL_System_Runtime_Dll.call_p3       procedure(string procname, long p1, long p2, long p3)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return callA_p3(lpaddress,0,0,0,p3,p2,p1)

DCL_System_Runtime_Dll.call_p4       procedure(string procname, long p1, long p2, long p3, long p4)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return callA_p4(lpaddress,0,0,0,p4,p3,p2,p1)

DCL_System_Runtime_Dll.call_p5       procedure(string procname, long p1, long p2, long p3, long p4,long p5)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return callA_p5(lpaddress,0,0,0,p5,p4,p3,p2,p1)

DCL_System_Runtime_Dll.call_p8       procedure(string procname, long p1, long p2, long p3, long p4,long p5, long p6, long p7,long p8)
lpaddress                       long,auto
	code
	lpaddress=SELF.GetAddress(procname)
	if ~lpaddress then Return SELF.eProcFail.
	return callA_p8(lpaddress,0,0,0,p8,p7,p6,p5,p4,p3,p2,p1)

   
  

DCL_System_Runtime_Dll.GetExportedProcedures    procedure(string filename,Queue procq)
x                                               long
errcode                                         long
err                                             STRING(100)
retval                                          byte
sectheaders                             ULONG   ! File offset to section headers
sections                                USHORT  ! File offset to section headers
VAexport                                ULONG   ! Virtual address of export table, according to data directory
	CODE
	!dbg..write('GetExportedProcedures')
	if self.DllHandle
		!dbg..write('DLL is already open')
		return Level:Fatal
	end
	FilenameVariable = filename
	free(ProcQ)
	free(self.ExportQ)

                    ! This is used as an alternative way to find table if .edata not found
	!dbg..write('Attempting to open  DLL for reading: ' & FilenameVariable)
	OPEN(EXEfile, 0)
	e# = errorcode()
	!dbg..write('e#: ' & e#)
	if e# > 0
		self.LastError = error()
		!dbg..write('Errorcode ' & e# & ' ' & error())
		return errorcode()
!    if errorcode()
!        return errorcode()
	END
	!dbg..write('DLL opened')
	GET(EXEfile, 1, SIZE(EXE:DOSheader))
	IF EXE:dos_magic = 'MZ' THEN
		newoffset = EXE:dos_lfanew
		GET(EXEfile, newoffset+1, SIZE(EXE:PEheader))

		IF EXE:pe_signature = 04550H THEN
			sectheaders = EXE:pe_optsize+newoffset+SIZE(EXE:PEheader)
			sections = EXE:pe_nsect
       ! Read the "Optional header"
			GET(EXEfile, newoffset+SIZE(EXE:PEheader)+1, SIZE(EXE:Optheader))
			IF EXE:opt_DataDirNum THEN
          ! First data directory describes where to find export table
				GET (EXEfile, newoffset+SIZE(EXE:PEheader)+SIZE(EXE:OptHeader)+1, SIZE(EXE:DataDir))
				VAexport = EXE:data_VirtualAddr
			END

			LOOP i# = 1 TO sections
				GET(EXEfile,sectheaders+1,SIZE(EXE:sectheader))
				sectheaders += SIZE(EXE:sectheader)
				IF EXE:sh_SectName = '.edata' THEN
					self.DumpPEExportTable(EXE:sh_VirtAddr, EXE:sh_VirtAddr - EXE:sh_rawptr)
				ELSIF EXE:sh_VirtAddr <= VAexport AND |
					EXE:sh_VirtAddr+EXE:sh_RawSize > VAexport
					self.DumpPEExportTable(VAexport, EXE:sh_VirtAddr - EXE:sh_rawptr)
				END
			END
		ELSE
			GET(EXEfile, newoffset+1, SIZE(EXE:NEheader))
			self.DumpNEExports
		END
	END
	CLOSE(EXEfile)
	!dbg..write('got ' & records(self.exportq) & ' exported procedures')
	free(procq)
	loop x = 1 to records(self.ExportQ)
		get(self.ExportQ,x) 
		!if sub(upper(self.ExportQ.Symbol),1,5) = 'TEST_'
			!procq.ProcName = sub(self.exportq.Symbol,1,instring('@',self.exportq.Symbol,1,1)-1)
		procq = self.exportq.Symbol
		!dbg.write('Found procedure ' & procq)
		add(procq)
	END
	return level:benign

 !DumpPEexportTable gets export table from a PE format file (32-bit)

DCL_System_Runtime_Dll.DumpPEExportTable        PROCEDURE (ULONG VirtualAddress, ULONG ImageBase)

NumNames                                        ULONG,AUTO
Names                                           ULONG,AUTO
Ordinals                                        ULONG,AUTO
Base                                            ULONG,AUTO

j                                               UNSIGNED,AUTO

	CODE
	GET(EXEfile, VirtualAddress-ImageBase+1, SIZE(EXE:ExpDirectory))
	NumNames = EXE:exp_NumNames
	Names    = EXE:exp_AddrNames
	Ordinals = EXE:exp_AddrOrds
	Base     = EXE:exp_Base
	GET(EXEfile, EXE:exp_Name-ImageBase+1, SIZE(EXE:cstringval))

	self.ExportQ.Module   = EXE:cstringval
	self.ExportQ.Symbol    = EXE:cstringval
	self.ExportQ.TreeLevel = 1
	self.ExportQ.Icon      = 1
	self.ExportQ.Ordinal   = 0
	self.ExportQ.Libno     = LastLib
	ADD(self.ExportQ)

	self.ExportQ.TreeLevel = 2
	self.ExportQ.Icon      = 0

	LOOP j = 0 TO NumNames - 1
		GET(EXEfile, Names+j*4-ImageBase+1, SIZE(EXE:ulongval))
		GET(EXEfile, EXE:ulongval-ImageBase+1, SIZE(EXE:cstringval))
		self.ExportQ.Symbol = EXE:cstringval

		GET(EXEfile, Ordinals+j*2-ImageBase+1, SIZE(EXE:ushortval))
		self.ExportQ.Ordinal = EXE:ushortval+Base
		self.ExportQ.Libno   = LastLib + 1
		ADD(self.ExportQ)
	END
!!
!!! DumpNEexports gets export table from a NE format file (16-bit)
!!
DCL_System_Runtime_Dll.DumpNEExports    PROCEDURE ()

j                                       LONG,AUTO
r                                       LONG,AUTO

	CODE
!    ! First get the module name - stored as first entry in resident name table
!    j = EXE:ne_nrestab+1
!    r = newoffset+EXE:ne_restab+1
!    GET(EXEfile, r, SIZE(EXE:pstringval))
!
!    self.ExportQ.Module    = EXE:pstringval
!    self.ExportQ.Symbol    = EXE:pstringval
!    self.ExportQ.Ordinal   = 0
!    self.ExportQ.TreeLevel = 1
!    self.ExportQ.Icon      = 1
!    self.ExportQ.Libno     = LastLib
!    ADD(self.ExportQ)
!
!    r += LEN(EXE:pstringval)+1    !move past module name
!    r += 2                        !move past ord#
!
!! Now pull apart the resident name table. First entry is the module name, read above
!
!    self.ExportQ.TreeLevel = 2
!    self.ExportQ.Icon = 0
!
!    LOOP
!        GET(EXEfile, r, SIZE(EXE:pstringval))
!        IF LEN(EXE:pstringval) = 0 THEN
!            BREAK
!        END
!        self.ExportQ.Symbol = EXE:pstringval
!        r += LEN(EXE:pstringval)+1
!        GET(EXEfile, r, SIZE(EXE:ushortval))
!        r += 2
!        self.ExportQ.Ordinal = EXE:ushortval
!        self.ExportQ.Libno   = LastLib + 1
!        ADD(self.ExportQ)
!    END
!
!! Now pull apart the non-resident name table. First entry is the description, and is skipped
!    GET(EXEfile, j, SIZE(EXE:pstringval))
!    j += LEN(EXE:pstringval)+1
!    GET(EXEfile, j, SIZE(EXE:ushortval))
!    j += 2
!    LOOP
!        GET(EXEfile, j, SIZE(EXE:pstringval))
!        IF LEN(EXE:pstringval)=0 THEN
!            BREAK
!        END
!        self.ExportQ.Symbol = EXE:pstringval
!        j += LEN(EXE:pstringval)+1
!        GET(EXEfile, j, SIZE(EXE:ushortval))
!        j += 2
!        self.ExportQ.Ordinal = EXE:ushortval
!        self.ExportQ.libno = LastLib + 1
!        ADD(self.ExportQ)
!    END
!!
!!! WriteLib writes out all info in the export Q to a LIB file
!!
!!TestDllProcFinder.WriteLib            PROCEDURE ()
!!
!!rec                     UNSIGNED,AUTO
!!
!!    CODE
!!    CREATE(LIBfile)
!!    OPEN(LIBfile)
!!
!!    LOOP rec = 1 TO RECORDS(ExportQ)
!!        GET(ExportQ, rec)
!!        IF ExportQ.TreeLevel = 2 THEN
!!        ! Record size is length of the strings, plus two length bytes, a two byte
!!        ! ordinal, plus the header length (excluding the first three bytes)
!!            LIB:typ = 88H
!!            LIB:kind = 0A000H
!!            LIB:bla = 1
!!            LIB:ordflag = 1
!!            LIB:len = LEN(CLIP(exq:module))+LEN(CLIP(exq:Symbol))+2+2+SIZE(LIB:header)-3
!!            ADD(LIBfile, SIZE(LIB:header))
!!            LIB:pstringval = ExportQ.Symbol
!!            ADD(LIBfile, LEN(LIB:pstringval)+1)
!!            LIB:pstringval = ExportQ.Module
!!            ADD(LIBfile, LEN(LIB:pstringval)+1)
!!            LIB:ushortval = ExportQ.Ordinal
!!            ADD(LIBfile, SIZE(LIB:ushortval))
!!        END
!!    END
!!    CLOSE(LIBfile)
!
!!! Readlib reads back in a LIB file output by WriteLib above or by IMPLIB etc
!!
!!TestDllProcFinder.ReadLib             PROCEDURE
!!
!!ii                      LONG,AUTO
!!jj                      LONG,AUTO
!!ordinal                 USHORT,AUTO
!!lastmodule              CSTRING(21)
!!modulename              CSTRING(21)
!!Symbolname              CSTRING(129),AUTO
!!
!!    CODE
!!    OPEN(LIBfile, 40h)
!!    ii = 1
!!
!!    LOOP 
!!        GET(LIBfile, ii, SIZE(LIB:header))     ! Read next OMF record
!!        IF ERRORCODE()
!!            BREAK                              ! All done
!!        END
!!        IF LIB:typ = 0 OR LIB:len = 0
!!            BREAK
!!        END
!!
!!        jj   = ii + SIZE(LIB:header)             ! Read export info from here
!!        ii  += LIB:len + 3                       ! Read next OMF record from here
!!
!!        IF LIB:typ = 88H AND LIB:kind = 0A000H AND LIB:bla = 1 AND LIB:ordflag = 1 THEN
!!            GET(LIBfile, jj, SIZE(LIB:pstringval))
!!            Symbolname = LIB:pstringval
!!            jj += LEN(LIB:Pstringval)+1
!!            GET(LIBfile, jj, SIZE(LIB:pstringval))
!!            modulename = LIB:pstringval
!!            jj += LEN(LIB:Pstringval)+1
!!            GET(LIBfile, jj, SIZE(LIB:ushortval))
!!            ordinal = LIB:ushortval
!!
!!            IF modulename <> lastmodule      ! A LIB can describe multiple DLLs
!!                IF  lastmodule[1] <> '<0>'
!!                    LastLib += 2
!!                END
!!                lastmodule = modulename
!!
!!                ExportQ.TreeLevel = 1
!!                ExportQ.Icon      = 1
!!                ExportQ.Symbol    = modulename
!!                ExportQ.Module    = modulename
!!                ExportQ.Ordinal   = 0
!!                ExportQ.Libno     = LastLib
!!                ADD(ExportQ)
!!            END
!!
!!            ExportQ.TreeLevel = 2
!!            ExportQ.Icon      = 0
!!            ExportQ.Symbol    = SymbolName
!!            ExportQ.Module    = modulename
!!            ExportQ.Ordinal   = ordinal
!!            ExportQ.Libno     = LastLib + 1
!!            ADD(ExportQ)
!!        END
!!    END
!!    CLOSE(LIBfile)
!!
!
!!WriteText           PROCEDURE
!!
!!Rec                     UNSIGNED,AUTO
!!Opened                  BYTE,AUTO
!!Dot                     UNSIGNED,AUTO
!!
!!    CODE
!!    SORT (ExportQ, +ExportQ.libno, +ExportQ.Ordinal)
!!    Opened = FALSE
!!    LOOP Rec = 1 TO RECORDS (ExportQ)
!!        Get(ExportQ, rec)
!!        IF ExportQ.Ordinal <> 0
!!            IF Opened
!!                TxtFile.Line = '  ' & ExportQ.Symbol & ' @' & ExportQ.Ordinal
!!                ADD(TxtFile)
!!                CYCLE
!!            END
!!            FilenameVariable = 'DEFAULT.EXP'
!!        ELSE
!!            IF STATUS (TxtFile)
!!                CLOSE(TxtFile)
!!            END
!!            dot = INSTRING ('.', ExportQ.Symbol, 1, 1)
!!            IF  dot
!!                FilenameVariable = ExportQ.Symbol [1 : dot] & 'EXP'
!!            ELSE
!!                FilenameVariable = ExportQ.Symbol & '.EXP'
!!            END
!!            opened = TRUE
!!        END
!!
!!        MESSAGE('Export file, ' & CLIP(FilenameVariable) & ' being written in ' & |
!!            LongPath(PATH()),'Library exported!',ICON:Exclamation)
!!
!!        CREATE (TxtFile)
!!        OPEN (TxtFile)
!!        TxtFile.Line = 'EXPORTS'
!!        ADD (TxtFile)
!!        IF  NOT opened
!!            TxtFile.Line = '  ' & ExportQ.Symbol & ' @' & ExportQ.Ordinal
!!            ADD (TxtFile)
!!            opened = TRUE
!!        END
!!    END
!!    CLOSE (TxtFile)

