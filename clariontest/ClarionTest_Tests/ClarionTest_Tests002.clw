

   MEMBER('ClarionTest_Tests.clw')                         ! This is a MEMBER module

                     MAP
                       INCLUDE('CLARIONTEST_TESTS002.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
Test_GetListOfExportedProceduresFromDLL PROCEDURE  (*long addr) ! Declare Procedure
!Tester                              ClarionTestManager
!ProcQ                               TestProcedureQueue
ProcQ                                                   QUEUE,pre()
ProcName                                                    string(255)
														end
DllName                                                 string(255)
DllMgr                                                  DCL_System_Runtime_Dll

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('Test_GetListOfExportedProceduresFromDLL')
	dllname = longpath() & '\demodll\demodll.dll'
	!DllMgr.Init(dllname)
	r# = DllMgr.GetExportedProcedures(dllname,ProcQ)
	!message('Message before assert:' & GlobalTestResultInstance.Message)
	AssertThat(r#,IsEqualTo(Level:Benign),'Unable to open DemoDll ' & dllname & ', error ' & DllMgr.LastError)
	!message('Message after assert:' & GlobalTestResultInstance.Message)
	!DllMgr.Kill()

	!AssertThat(true,isequalto(False),'true does not equal false')
	!AssertThat(true,isequalto(true),'true equals true')
	
  DO ProcedureReturn ! dgh
ProcedureReturn                             routine
    return 0
!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
Test_GetListOfExportedTestProceduresFromDLL PROCEDURE  (*long addr) ! Declare Procedure
ProcQ                                                   DCL_ClarionTest_ProceduresQueue
DllName                                                 string(255)
TestRunner                                                  DCL_ClarionTest_TestRunner

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('Test_GetListOfExportedTestProceduresFromDLL')
	dllname = longpath() & '\demodll\demodll.dll'
	TestRunner.Init(dllname)
	TestRunner.GetTestProcedures(ProcQ)
	AssertThat(records(ProcQ),IsEqualTo(4),'Wrong number of procedures found in ' & dllname)
	get(procq,1)
	AssertThat(procq.TestName,isequalto('Deliberate_Failure_For_Demo_Purposes'))
	get(procq,2)
	AssertThat(procq.TestName,isequalto('Test_Group_Comparison'))
	get(procq,3)
	AssertThat(procq.TestName,isequalto('Test_Integer_Comparison'))
	get(procq,4)
	AssertThat(procq.TestName,isequalto('Test_String_Comparison'))
	TestRunner.Kill()
	
  DO ProcedureReturn ! dgh
ProcedureReturn                             routine
    return 0
!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
Test_BasicLogic      PROCEDURE  (*long addr)               ! Declare Procedure


  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('Test_BasicLogic')
	AssertThat(1,IsNotEqualTo(2))	
	AssertThat('abc',IsNotEqualTo('ABC'))
	AssertThat('abc',IsEqualTo('abc'))
  DO ProcedureReturn ! dgh
ProcedureReturn                             routine
    return 0
!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
Test_ExecuteTest     PROCEDURE  (*long addr)               ! Declare Procedure
ProcQ                       DCL_ClarionTest_ProceduresQueue
DllName                     string(255)
TestRunner                  DCL_ClarionTest_TestRunner
TestResult                  &DCL_ClarionTest_TestResult

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('Test_ExecuteTest')
	dllname = longpath() & '\demodll\demodll.dll'
	!dllname = 'D:\dev-IES\UnitTests\IES_DeniedParties_Tests\IES_DeniedParties_Tests.dll'
	TestRunner.Init(dllname)
	TestRunner.GetTestProcedures(ProcQ)
	AssertThat(records(ProcQ),IsNotEqualTo(0),'No tests found in ' & dllname)
	TestResult &= TestRunner.RunTest(1)
	if testresult &= null
		AssertThat(true,IsEqualTo(false),'Test result 1 was null')
	else
		AssertThat(TestResult.Passed,IsEqualTo(false),'Test 1 passed, expected fail - ' & TestResult.Message)
		AssertThat(TestResult.ProcedureName,IsEqualTo('Deliberate_Failure_For_Demo_Purposes'))
	end
	TestResult &= TestRunner.RunTest(2)
	if testresult &= null
		AssertThat(true,IsEqualTo(false),'Test 2 result was null')
	else
		AssertThat(TestResult.Passed,IsEqualTo(true),'Test 2 failed - ' & TestResult.Message)
		AssertThat(TestResult.ProcedureName,IsEqualTo('Test_Group_Comparison'),,'This is a custom "test succeeded" message')
	end
	TestRunner.Kill()
  DO ProcedureReturn ! dgh
ProcedureReturn                             routine
    return 0
