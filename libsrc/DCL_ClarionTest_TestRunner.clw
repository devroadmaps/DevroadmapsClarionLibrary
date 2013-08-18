!---------------------------------------------------------------------------------------------!
! Copyright (c) 2013, CoveComm Inc.
! All rights reserved.
!---------------------------------------------------------------------------------------------!
!region
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
!endregion

										member()


										MAP
										END

	include('DCL_ClarionTest_TestRunner.inc'),once
	include('DCL_ClarionTest_TestResult.inc'),once
	include('DCL_System_Diagnostics_Logger.inc'),once

logger                                  DCL_System_Diagnostics_Logger

DCL_ClarionTest_TestRunner.Construct    PROCEDURE
	CODE
	self.Procedures &= new DCL_ClarionTest_TestProceduresQueue
	
DCL_ClarionTest_TestRunner.Destruct     procedure
	code
	free(self.Procedures)
	dispose(self.Procedures)

DCL_ClarionTest_TestRunner.Init         procedure(string dllname)
	CODE
 !logger.write('calling DCL_ClarionTest_TestRunner.Init')
	if self.dllmgr &= NULL
	 !logger.write('Creating DLLMgr')
		self.DllMgr &= new DCL_System_Runtime_Dll
	ELSE
	 !logger.write('DLLMgr already exsists')
	end
	self.DllName = dllname
	self.DllMgr.Init(self.dllname)
    
	
DCL_ClarionTest_TestRunner.Kill         procedure
	CODE
 !logger.write('calling DCL_ClarionTest_TestRunner.Kill')
	if ~self.dllmgr &= NULL 
	 !logger.write('Disposing of DLLMgr')
		self.DllMgr.kill()
		dispose(self.DllMgr) 
	ELSE 
	 !logger.write('DLLMgr is already null')		
	end
	
	
DCL_ClarionTest_TestRunner.GetTestProcedures    procedure(*DCL_ClarionTest_TestProceduresQueue q)	
ProcsQ                                              QUEUE
ProcName                                                cstring(200)
													end
x                                                   long
Found_GetListOfTestProcedures                       byte(false)
GetListProc                                         string('CLARIONTEST_GETLISTOFTESTPROCEDURES')
TestProcedures                                      &DCL_ClarionTest_TestProcedures
lptr                                                long
!utr                                                 &DCL_ClarionTest_TestResult
DllInitialized                                      byte
	CODE
 !logger.write('DCL_ClarionTest_TestRunner.GetTestProcedures')
	clear(q)
	! Close the DLL so the list of exported procedures can be extracted
	! But save the current state so it can be restored
	DllInitialized = self.DllMgr.IsInitialized()
	if DllInitialized = true
		self.DllMgr.kill()
	end
 !logger.write('Calling self.DllMgr.GetExportedProcedures with dllname ' & self.DllName)
	if self.DllMgr.GetExportedProcedures(self.Dllname,procsq) = Level:Benign
		free(self.Procedures)
		! Look for the CLARIONTEST_GETLISTOFTESTPROCEDURES procedure
		loop x = 1 to records(procsq)
			get(procsq,x)
			!logger.Write('>' & upper(left(clip(procsq.ProcName))) & '<<')
			if upper(sub(left(procsq.procname),1,len(GetListproc))) = GetListProc
				! Get the list of procedures from that method
			 !logger.write('************** found ' & GetListProc & ' *************')
				Found_GetListOfTestProcedures = TRUE
				BREAK
			END
!			if upper(sub(procsq.ProcName,1,5)) = 'TEST_'
!				clear(self.Procedures)
!				self.Procedures.testname = procsq.ProcName
!				add(self.Procedures)
!			 !logger.write('DCL_ClarionTest_TestRunner.GetTestProcedures added test procedure ' & q)
!			end				
		end
		if Found_GetListOfTestProcedures
		 !logger.write('Found_GetListOfTestProcedures = true')
			if self.DllMgr.Init(self.DllName) = Level:Benign
			 !logger.write('calling ' & GetListProc & ' with address(lptr) ' & address(lptr))
				r# = self.DllMgr.Call(GetListProc,address(lptr))
			 !logger.write('return value: ' & r#)
			end
		 !logger.write('lptr ' & lptr)
			TestProcedures &= (lptr)
			!utr &= (lptr)
		 !logger.write('ref address now ' & address(TestProcedures))
			if ~TestProcedures &= null 
			 !logger.write('TestProcedures is not null')
				!logger.write('TestProcedures.Names: ' & TestProcedures.Names[1])
			 !logger.write(records(TestProcedures.List) & ' records found')
				free(q)
				loop x = 1 to records(TestProcedures.List)
				 !logger.write('record ' & x)
				 !logger.write('Group: ' & clip(TestProcedures.List.TestGroupName) & ', priority: ' & TestProcedures.List.TestPriority & ', Test: ' & clip(TestProcedures.list.TestName))
					get(TestProcedures.List,x)
					self.Procedures.testname = TestProcedures.List.testname
					self.Procedures.TestPriority = TestProcedures.List.TestPriority
					self.Procedures.TestGroupName = TestProcedures.list.TestGroupName
					self.Procedures.TestGroupPriority = TestProcedures.List.TestGroupPriority
					add(self.Procedures,self.Procedures.TestGroupPriority,self.Procedures.TestGroupName,self.Procedures.TestPriority,self.Procedures.TestPriority)
				 !logger.write('Added test procedure to self.procedures: ' & self.Procedures.testname)
				END
				loop x = 1 to records(self.Procedures)
					get(self.Procedures,x)
				 !logger.write('record ' & x)
				 !logger.write('Group: ' & clip(self.Procedures.TestGroupName) & ', priority: ' & self.Procedures.TestPriority & ', Test: ' & clip(self.Procedures.TestName))
				END
					
			ELSE
			 !logger.write('TestProcedures is null')
			end
			self.DllMgr.Kill()
		end
	end
	free(q)
	loop x = 1 to records(self.Procedures)
		get(self.Procedures,x)
		q.TestName = self.Procedures.testname
		q.TestPriority = self.Procedures.TestPriority
		q.TestGroupName = self.Procedures.TestGroupName
		q.TestGroupPriority = self.Procedures.TestGroupPriority
		add(q)
	 !logger.write('Added procedure ' & q)
	END
	self.DllMgr.Kill()
!	if DllInitialized = true and self.DllMgr.IsInitialized() = FALSE
!		self.DllMgr.Init(self.dllname)
!	end
	

DCL_ClarionTest_TestRunner.GetFailedTest        procedure(string errormsg)
result                                              &DCL_ClarionTest_TestResult
	CODE
	result &= new DCL_ClarionTest_TestResult
	result.status = DCL_ClarionTest_Status_Fail
	result.Message = errormsg
	return result
	
	
DCL_ClarionTest_TestRunner.RunTest      procedure(long index)!,DCL_ClarionTest_TestResult	
result                                      &DCL_ClarionTest_TestResult
lptr                                        long
	code
	if self.DllMgr &= NULL 
		return self.GetFailedTest('The DLL manager object is null')
	end
	if self.DllMgr.IsInitialized() = false
		return self.GetFailedTest('The DLL was not initialized')
	end
 !logger.write('DCL_ClarionTest_TestRunner.RunTest: ' & records(self.Procedures) & ' records in self.procedures')
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

	
DCL_ClarionTest_TestRunner.RunTestByName        procedure(string name)!,*DCL_ClarionTest_TestResult	
x                                                   long
	CODE
	loop x = 1 to records(self.Procedures)
		get(self.Procedures,x)
		if lower(clip(self.Procedures.TestName)) = lower(clip(name))
			return self.RunTest(x)
		END
	END
	return self.GetFailedTest('The test ' & clip(name) & ' could not be found')
	
			
