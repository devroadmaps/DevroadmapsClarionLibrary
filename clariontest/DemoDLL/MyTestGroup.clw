

   MEMBER('DemoDLL.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('MYTESTGROUP.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CompareTwoIntegers_Verify PROCEDURE  (*long addr)          ! Declare Procedure
FilesOpened          LONG                                  !

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CompareTwoIntegers_Verify')
	AssertThat(123,IsNotEqualTo(1234),'Wrong number')
	AssertThat(123,IsEqualTo(123))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! This test will compare two groups of numbers, and verify that they match.  
!!! This test will compare two groups of numbers, and verify that they match.  
!!! 
!!! The values compared:
!!! 
!!! Group1	GROUP
!!! s1	string('abc')
!!! 	end
!!! Group2	GROUP
!!! s1	string('abcd')
!!! 	end
!!! </summary>
CompareTwoGroups_Verify PROCEDURE  (*long addr)            ! Declare Procedure
FilesOpened          LONG                                  !
Group1	GROUP
s1	string('abc')
	end
Group2	GROUP
s1	string('abcd')
	end

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CompareTwoGroups_Verify')
	AssertThat(Group1,IsNotEqualTo(Group2))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - GroupProcedure
!!! </summary>
Group1               PROCEDURE  ()                         ! Declare Procedure
FilesOpened          LONG                                  !

  CODE
!!! <summary>
!!! Generated from procedure template - GroupProcedure
!!! </summary>
Group2               PROCEDURE  ()                         ! Declare Procedure
FilesOpened          LONG                                  !

  CODE
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CompareTwoStrings    PROCEDURE  (*long addr)               ! Declare Procedure
FilesOpened          LONG                                  !
!

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CompareTwoStrings')
    AssertThat('string1',IsNotEqualTo('string2'))
    AssertThat('string1',IsEqualTo('string1'))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
