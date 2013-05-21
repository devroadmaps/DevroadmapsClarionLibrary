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
	! Original code by Jim Kane
! http://www.clarionmag.com/cmag/v3/v3n11byaddress1.html
! http://www.clarionmag.com/cmag/v3/v3n11byaddress2.html
! Later additions by Dave Harms

DCL_System_Runtime_DllExportQueue       QUEUE,PRE(EXQ),type
Symbol                                  CSTRING(129)
icon                                    SHORT
treelevel                               SHORT
ordinal                                 USHORT
module                                  CSTRING(21)
libno                                   USHORT
									END

LastLib             USHORT(0)

DCL_System_Runtime_Dll  class,type,module('DCL_System_Runtime_Dll.clw'),link('DCL_System_Runtime_Dll.clw')!,_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_)
!Member Data
DllHandle               long
debug                   byte
Initialized	byte(false),private
ApiErrorcode            long
AddressQ                &AddressQType
eProcFail               long !Result to return if getaddress fails during an call_pX function call.
ErrorStr                string(256)
ignoreDllHandle         byte  !if true are using the class without loading a dll 
!Methods - all return 0 for success if they return anything
construct               procedure()
destruct                procedure()
init                    procedure(string pDllPath, byte pDebug=0),byte,proc
IsInitialized           procedure,byte
SetProcFailCode         procedure(long pFailcode),byte,proc !default is 0
kill                    procedure()
!add an address to the addressQ.  
addaddress              Procedure(string procname, long lpProcName),byte,proc
!see also addaddressDeRef() in the utility section
! If procname is not found in the addressq,
!  getprocaddress is called to find the address if a dll has been loaded
GetAddress              Procedure(string procname),long
!call options using the pascal calling convention
call                    procedure(string procname, <long p1>,<long p2>,<long p3>,<long p4>,<long p5>,<long p6>,<long p7>,<long p8>,<long p9>,<long p10>),long,proc
callbyAddress           procedure(long lpAddress, <long p1>,<long p2>,<long p3>,<long p4>,<long p5>,<long p6>,<long p7>,<long p8>,<long p9>,<long p10>),long,proc
!call options using the c calling convention
ccall                   procedure(string procname, <long p1>,<long p2>,<long p3>,<long p4>,<long p5>),long,proc
ccallbyAddress          procedure(long lpAddress, <long p1>,<long p2>,<long p3>,<long p4>,<long p5>),long,proc
!Start options
Start                   procedure(String pMdiForm, long StackSize=0,<string pS1>,<String pS2>,<String pS3>),long,proc
StartByAddress          procedure(long lpMDiForm, long StackSize=0,<string ps1>,<string pS2>, <string pS3>),long,proc
!alternative call formats - no advantage to these other than a slight speed advantage
call_p0                 procedure(string procname),long,proc
call_p1                 procedure(string procname, long p1),long,proc
call_p2                 procedure(string procname, long p1, long p2),long,proc
call_p3                 procedure(string procname, long p1, long p2, long p3),long,proc
call_p4                 procedure(string procname, long p1, long p2, long p3, long p4),long,proc
call_p5                 procedure(string procname, long p1, long p2, long p3, long p4,long p5),long,proc
call_p8                 procedure(string procname, long p1, long p2, long p3, long p4,long p5,long p6,long p7,long p8),long,proc
ccall_p0                procedure(string procname),long,proc
ccall_p1                procedure(string procname, long p1),long,proc
ccall_p2                procedure(string procname, long p1, long p2),long,proc
ccall_p3                procedure(string procname, long p1, long p2, long p3),long,proc
ccall_p4                procedure(string procname, long p1, long p2, long p3, long p4),long,proc
ccall_p5                procedure(string procname, long p1, long p2, long p3, long p4,long p5),long,proc
!wraps the formatmessage api
GetLastError            procedure(),ulong
FormatErrMsg            procedure(*string msg,long EC),byte,proc
FormatErrMsg            Procedure(*string msg),byte,proc
!saves and optionally displays any errors generated by the class
takeError               procedure(string pErrorStr)  !Error messages not suitable for the user
!utility functions for dereferencing an address - typically an address returned by address() where
! the function or variable is in a dll
DerefPointer            procedure(long lpPointer, *long pDeref),byte !return the value stored at lpPointer in pDeRef
AddAddressDeref         procedure(long lpPointer, string pName),byte !add deref() of lpPointer to the addressQ rather then lpPointer

! new declarations added by Dave Harms
ExportQ                 &DCL_System_Runtime_DllExportQueue
LastError               string(100)
GetExportedProcedures   procedure(string filename,Queue q),long
DumpPEExportTable       procedure(ULONG RawAddr, ULONG VirtAddr)
DumpNEExports           procedure
!!WriteLib                	 procedure
!!ReadLib                 	 procedure
!!WriteText               	 procedure
					end
