

   MEMBER('DemoDLL.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('DEMODLL002.INC'),ONCE        !Local module procedure declarations
                     END


Deliberate_Failure_For_Demo_Purposes PROCEDURE  (*long addr) ! Declare Procedure
!TestResult  &TestResultT
  CODE
    addr = address(UnitTestResult)
    BeginUnitTest('Deliberate_Failure_For_Demo_Purposes')
    !-------------------------------------------------------------------
    ! Write your code to test for a result, using the AssertThat syntax.
    ! At present there are two different assertions you can use, IsEqualto
    ! and IsNotEqualTo. You can pass in any data type that Clarion can
    ! automatically convert to a string. 
    ! 
    ! 	AssertThat('a',IsEqualTo('a'),'this is an optional extra message')
    !	AssertThat(1,IsNotEqualTo(2))
    !
    ! As soon as an Assert statement fails there remaining tests will
    ! not be executed. 
    !-------------------------------------------------------------------
    
    AssertThat(true,IsEqualTo(false))
    return 0
