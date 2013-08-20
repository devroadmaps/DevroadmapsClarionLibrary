

   MEMBER('DCL_System_StringCollection_Tests.clw')         ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_STRINGCOLLECTION_TESTS002.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
AddTwoStringsToCollection_CaseInsensitive_VerifyCountIsOne PROCEDURE  (*long addr) ! Declare Procedure
StringColl                              DCL_System_StringCollection

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('AddTwoStringsToCollection_CaseInsensitive_VerifyCountIsOne')
    StringColl.CaseInsensitive = true
    StringColl.Add('abc')
    StringColl.Add('aBc')
    AssertThat(StringColl.GetCount(),IsEqualTo(1),'Wrong number of strings in collection')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
