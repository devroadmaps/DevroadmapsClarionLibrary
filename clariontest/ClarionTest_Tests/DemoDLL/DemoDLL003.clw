

   MEMBER('DemoDLL.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('DEMODLL003.INC'),ONCE        !Local module procedure declarations
                     END


Test_DoesSomethingElse PROCEDURE  (*long addr)             ! Declare Procedure
TestResult  &TestResultT
tr  &TestResult
  CODE
    !-------------------------------------------------------------------
    ! Create a new instance of the class used to pass information
    ! back to the test runner and set some default values
    !-------------------------------------------------------------------
    TestResult &= new TestResultT
    TestResult.Passed = false ! default to failure
    TestResult.Message = 'Please set an appropriate result message'
    TestResult.ProcedureName = 'Test_DoesSomethingElse'
    TestResult.Description = ''
    tr &= TestResult ! So you can use tr or TestResult in your code...
    addr = address(TestResult)
    !-------------------------------------------------------------------
    ! Write your code to test for a result. If the test failed,  set 
    ! the message to something descriptive. If the test passed,
    ! set tr.passed to true.
    !
    ! if (some condition failed)
    !     tr.Message = 'Expected A, got B'
    ! else
    !     tr.passed = true
    ! end
    !-------------------------------------------------------------------
    tr.Passed = true
    return 0
