

   MEMBER('DemoDLL.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('DEMODLL001.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CompareEmptyString   PROCEDURE  (*long addr)               ! Declare Procedure
str                         string(10)
FilesOpened          LONG                                  !
!

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CompareEmptyString')
    AssertThat(IsEmpty(str),isEqualto(true),'Isempty() failed test 1')
    str = 'abc'
    AssertThat(IsEmpty(str),isEqualto(false),'Isempty() failed test 2')
    clear(str)
    AssertThat(IsEmpty(str),isEqualto(true),'Isempty() failed test 3')
    
    
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
