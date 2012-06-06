

   MEMBER('DemoDLL.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('DEMODLL004.INC'),ONCE        !Local module procedure declarations
                     END


Test_String_Comparison PROCEDURE  (*long addr)             ! Declare Procedure
  CODE
    addr = address(UnitTestResult)
    BeginUnitTest('Test_String_Comparison')
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
    

	AssertThat('ad',IsEqualTo('ad'))
    return 0
Test_Integer_Comparison PROCEDURE  (*long addr)            ! Declare Procedure
  CODE
    addr = address(UnitTestResult)
    BeginUnitTest('Test_Integer_Comparison')
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
    return 0
Test_Group_Comparison PROCEDURE  (*long addr)              ! Declare Procedure
Group1	GROUP
s1	string('abc')
	end
Group2	GROUP
s1	string('abcd')
	end
  CODE
    addr = address(UnitTestResult)
    BeginUnitTest('Test_Group_Comparison')
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
    return 0
