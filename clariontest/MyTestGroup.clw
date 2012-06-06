

   MEMBER('DemoDLL.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('MYTESTGROUP.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
_002_CompareTwoIntegers_Verify PROCEDURE  (*long addr)     ! Declare Procedure
FilesOpened          LONG                                  !

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('_002_CompareTwoIntegers_Verify')
	AssertThat(123,IsNotEqualTo(1234),'Wrong number')
	AssertThat(123,IsEqualTo(123))
  DO ProcedureReturn
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
_001_CompareTwoGroups_Verify PROCEDURE  (*long addr)       ! Declare Procedure
FilesOpened          LONG                                  !
Group1	GROUP
s1	string('abc')
	end
Group2	GROUP
s1	string('abcd')
	end

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('_001_CompareTwoGroups_Verify')
    AssertThat(Group1,IsNotEqualTo(Group2))
    !gdbg.write('test')
  DO ProcedureReturn
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - GroupProcedure
!!! </summary>
_001_Group1          PROCEDURE  ()                         ! Declare Procedure
FilesOpened          LONG                                  !

  CODE
!!! <summary>
!!! Generated from procedure template - GroupProcedure
!!! </summary>
_002_Group2          PROCEDURE  ()                         ! Declare Procedure
FilesOpened          LONG                                  !

  CODE
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
_003_CompareTwsoStrings PROCEDURE  (*long addr)            ! Declare Procedure
FilesOpened          LONG                                  !
!

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('_003_CompareTwsoStrings')
  DO ProcedureReturn
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - GroupProcedure
!!! </summary>
_003_AnotherGroup    PROCEDURE                             ! Declare Procedure
FilesOpened          LONG                                  !

  CODE
