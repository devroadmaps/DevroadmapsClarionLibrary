

   MEMBER('DemoDLL.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('ANOTHERTESTGROUP.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CompareTwoStrings_Verify PROCEDURE  (*long addr)           ! Declare Procedure
FilesOpened          LONG                                  !

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CompareTwoStrings_Verify')

	AssertThat('ad',IsEqualTo('ad'))!,,'This is a custom "success" message')
	
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CompareTruetoFalse_DeliberateTestFailure PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
!TestResult  &TestResultT

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CompareTruetoFalse_DeliberateTestFailure')
    AssertThat(true,IsEqualTo(false))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
