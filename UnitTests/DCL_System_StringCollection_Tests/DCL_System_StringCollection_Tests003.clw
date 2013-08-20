

   MEMBER('DCL_System_StringCollection_Tests.clw')         ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_STRINGCOLLECTION_TESTS003.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
AddTwoStringsToCollection_CaseSensitive_VerifyCountIsTwo PROCEDURE  (*long addr) ! Declare Procedure
StringColl                              DCL_System_StringCollection

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('AddTwoStringsToCollection_CaseSensitive_VerifyCountIsTwo')
    StringColl.Add('abc')
    StringColl.Add('aBc')
    StringColl.CaseInsensitive = false
    AssertThat(StringColl.GetCount(),IsEqualTo(2),'Wrong number of strings in collection')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
