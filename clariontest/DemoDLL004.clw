

   MEMBER('DemoDLL.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('DEMODLL004.INC'),ONCE        !Local module procedure declarations
                     END


CompareTwoStrings_Verify PROCEDURE  (*long addr)           ! Declare Procedure
  CODE
    addr = address(UnitTestResult)
    BeginUnitTest('CompareTwoStrings_Verify')
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
    

	AssertThat('ad',IsEqualTo('ad'))!,,'This is a custom "success" message')
    DO ProcedureReturn
ProcedureReturn   ROUTINE
    return 0
CompareTwoIntegers_Verify PROCEDURE  (*long addr)          ! Declare Procedure
  CODE
    addr = address(UnitTestResult)
    BeginUnitTest('CompareTwoIntegers_Verify')
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
    
	AssertThat(123,IsNotEqualTo(1234),'Wrong number')
	AssertThat(123,IsEqualTo(123))
    DO ProcedureReturn
ProcedureReturn   ROUTINE
    return 0
CompareTwoGroups_Verify PROCEDURE  (*long addr)            ! Declare Procedure
Group1	GROUP
s1	string('abc')
	end
Group2	GROUP
s1	string('abcd')
	end
  CODE
    addr = address(UnitTestResult)
    BeginUnitTest('CompareTwoGroups_Verify')
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
    
	AssertThat(Group1,IsNotEqualTo(Group2))
    DO ProcedureReturn
ProcedureReturn   ROUTINE
    return 0
