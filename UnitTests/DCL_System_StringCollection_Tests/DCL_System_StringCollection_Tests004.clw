

   MEMBER('DCL_System_StringCollection_Tests.clw')         ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_STRINGCOLLECTION_TESTS004.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
AddTwoStringsToCollection_RemoveOne_VerifyCount PROCEDURE  (*long addr) ! Declare Procedure
StringColl                              DCL_System_StringCollection

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('AddTwoStringsToCollection_RemoveOne_VerifyCount')
    StringColl.Add('abc')
    StringColl.Add('def')
    AssertThat(StringColl.GetCount(),IsEqualTo(2),'Wrong number of strings in collection')
    StringColl.Remove('def')
    AssertThat(StringColl.GetCount(),IsEqualTo(1),'Wrong number of strings in collection after removing one')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
