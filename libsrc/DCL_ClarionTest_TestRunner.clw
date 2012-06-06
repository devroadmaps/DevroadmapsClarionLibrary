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

	include('DCL_ClarionTest_TestRunner.inc'),once
	include('DCL_ClarionTest_TestResult.inc'),once
	include('DCL_System_Diagnostics_Logger.inc'),once

!gdbg                 DCL_System_Diagnostics_Logger,external,dll

DCL_ClarionTest_TestRunner.Construct                       PROCEDURE
	CODE
	self.Procedures &= new DCL_ClarionTest_ProceduresQueue
	
DCL_ClarionTest_TestRunner.Destruct                        procedure
	code
	free(self.Procedures)
	dispose(self.Procedures)

DCL_ClarionTest_TestRunner.Init          procedure(string dllname)
    CODE
    if self.dllmgr &= NULL
        self.DllMgr &= new DCL_System_Runtime_Dll
        self.DllName = dllname
        self.DllMgr.Init(self.dllname)
    end
    
	
DCL_ClarionTest_TestRunner.Kill	procedure
	CODE
	if ~self.dllmgr &= NULL
        self.DllMgr.kill()
        dispose(self.DllMgr)
	end
	
	
DCL_ClarionTest_TestRunner.GetTestProcedures               procedure(*DCL_ClarionTest_ProceduresQueue q)	
ProcsQ                                                      QUEUE
ProcName                                                        cstring(200)
															end
x                                                           long
ListProcedureFound                                                   byte(false)
GetListProc string('CLARIONTEST_GETLISTOFTESTPROCEDURES')
ctProcedures                                                &DCL_ClarionTest_Procedures
lptr                                                          long
utr                                                         &DCL_ClarionTest_TestResult
DllInitialized                                              byte
	CODE
	!!gdbg.write('DCL_ClarionTest_TestRunner.GetTestProcedures')
	clear(q)
	! Close the DLL so the list of exported procedures can be extracted
	! But save the current state so it can be restored
	DllInitialized = self.DllMgr.IsInitialized()
	if DllInitialized = true
		self.DllMgr.kill()
	end
	if self.DllMgr.GetExportedProcedures(self.Dllname,procsq) = Level:Benign
		if ~self.DllMgr &= null
			free(self.Procedures)
			! Look for the CLARIONTEST_GETLISTOFTESTPROCEDURES procedure
			loop x = 1 to records(procsq)
				get(procsq,x)
				!!!gdbg.Write('>' & upper(left(clip(procsq.ProcName))) & '<<')
				if upper(sub(left(procsq.procname),1,len(GetListproc))) = GetListProc
					! Get the list of procedures from that method
					!!gdbg.write('************** found ' & GetListProc & ' *************')
					ListProcedureFound = TRUE
					BREAK
				END
				if upper(sub(procsq.ProcName,1,5)) = 'TEST_'
					clear(self.Procedures)
					self.Procedures.testname = procsq.ProcName
					add(self.Procedures)
					!!gdbg.write('DCL_ClarionTest_TestRunner.GetTestProcedures added test procedure ' & q)
				end				
			end
			if ListProcedureFound
				if self.DllMgr.Init(self.DllName) = Level:Benign
					!!gdbg.write('calling ' & GetListProc & ' with address(lptr) ' & address(lptr))
					r# = self.DllMgr.Call(GetListProc,address(lptr))
					!!gdbg.write('return value: ' & r#)
				end
				!!gdbg.write('lptr ' & lptr)
				ctProcedures &= (lptr)
				!utr &= (lptr)
				!!dbg.write('utr.Message: ' & utr.Message)
				if ~ctProcedures &= null 
					!!gdbg.write('ctProcedures is not null')
					!!gdbg.write('ctProcedures.Names: ' & ctProcedures.Names[1])
					!!gdbg.write(records(ctProcedures.List) & ' records found')
					free(q)
					loop x = 1 to records(ctProcedures.List)
						!gdbg.write('record ' & x)
						!gdbg.write('Group: ' & clip(ctprocedures.List.TestGroup) & ', priority: ' & ctProcedures.list.Priority & ', Test: ' & clip(ctProcedures.list.TestName))
						get(ctProcedures.List,x)
						self.Procedures.testname = ctProcedures.List.testname
						self.Procedures.Priority = ctProcedures.List.Priority
						self.Procedures.TestGroup = ctProcedures.list.TestGroup
						self.Procedures.TestGroupOrder = ctProcedures.List.TestGroupOrder
						add(self.Procedures,self.Procedures.TestGroupOrder,self.Procedures.TestGroup,self.Procedures.Priority,self.Procedures.Priority)
						!!gdbg.write('Added test procedure to self.procedures: ' & self.Procedures.testname)
					END
					loop x = 1 to records(self.Procedures)
						get(self.Procedures,x)
						!gdbg.write('record ' & x)
						!gdbg.write('Group: ' & clip(self.Procedures.TestGroup) & ', priority: ' & self.Procedures.Priority & ', Test: ' & clip(self.Procedures.TestName))
					END
					
					ELSE
					!!gdbg.write('ctProcedures is null')
				end
				self.DllMgr.Kill()
			end
		end
		free(q)
		loop x = 1 to records(self.Procedures)
			get(self.Procedures,x)
			q.TestName = self.Procedures.testname
			q.Priority = self.Procedures.Priority
			q.TestGroup = self.Procedures.TestGroup
			q.TestGroupOrder = self.Procedures.TestGroupOrder
			add(q)
			!!dbg.write('Added procedure ' & q)
		END
		if DllInitialized = true and self.DllMgr.IsInitialized() = FALSE
			self.DllMgr.Init(self.dllname)
		end
	end

DCL_ClarionTest_TestRunner.GetFailedTest     procedure(string errormsg)
result                                          &DCL_ClarionTest_TestResult
	CODE
	result &= new DCL_ClarionTest_TestResult
	result.passed = FALSE
	result.Message = errormsg
	return result
	
	
DCL_ClarionTest_TestRunner.RunTest                         procedure(long index)!,DCL_ClarionTest_TestResult	
result	&DCL_ClarionTest_TestResult
lptr	long
	code
	if self.DllMgr &= NULL 
		return self.GetFailedTest('The DLL manager object is null')
	end
	if self.DllMgr.IsInitialized() = false
		return self.GetFailedTest('The DLL was not initialized')
	end
	!!gdbg.write('DCL_ClarionTest_TestRunner.RunTest: ' & records(self.Procedures) & ' records in self.procedures')
	get(self.Procedures,index)
	if errorcode()
		return self.GetFailedTest('Could not find the requested test (index ' & index & ') ' & error())
	end
	r# = self.DllMgr.Call(upper(clip(self.Procedures.testname)),address(lptr))
	if r# <> 0
		return self.GetFailedTest('Could not execute the test: ' & self.DllMgr.ErrorStr)
	END
	result &= (lptr)
	return result

	
DCL_ClarionTest_TestRunner.RunTestByName       procedure(string name)!,*DCL_ClarionTest_TestResult	
x                       long
	CODE
	loop x = 1 to records(self.Procedures)
		get(self.Procedures,x)
		if lower(clip(self.Procedures.TestName)) = lower(clip(name))
			return self.RunTest(x)
		END
	END
	return self.GetFailedTest('The test ' & clip(name) & ' could not be found')
	
			
