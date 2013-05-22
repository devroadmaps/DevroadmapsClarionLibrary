

   MEMBER('DCL_System_String_Tests.clw')                   ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_STRING_TESTS004.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
ReplaceWord_Bug_1_VerifyFix PROCEDURE  (*long addr)        ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('ReplaceWord_Bug_1_VerifyFix')
	str.Assign('abc ltda')
	str.ReplaceWord('ltd','limited')
	AssertThat(str.Get(),IsEqualTo('abc ltda'),'Test 1 failed')

    str.Assign('abc ltda')
    str.ReplaceWord('ltda','limited')
    AssertThat(str.Get(),IsEqualTo('abc limited'),'Test 1 failed')

  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
ReplaceStringWithClearedCString_Verify PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
str                                         DCL_System_String
repSTr                                      cstring(10)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('ReplaceStringWithClearedCString_Verify')
    clear(repstr)
    str.Assign('abcdef')
    str.Replace('a',repstr)
    AssertThat(str.Get(),IsEqualTo('bcdef'),'Failed test 1')

  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
AppendSpace_Verify   PROCEDURE  (*long addr)               ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('AppendSpace_Verify')
    str.Assign('a')
    str.Append(' ')
    str.Append('b')
    AssertThat(str.Get(), IsEqualTo('a b'))
	!SetUnitTestFailed('Forced failure')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
AppendNothing_Verify PROCEDURE  (*long addr)               ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('AppendNothing_Verify')
    str.Assign('a')
    str.Append('')
    str.Append('b')
	AssertThat(str.Get(), IsEqualTo('ab'))
	!SetUnitTestFailed('forced failure')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
