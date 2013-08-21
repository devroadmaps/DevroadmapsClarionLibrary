

   MEMBER('DCL_System_StringCollection_Tests.clw')         ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_STRINGCOLLECTION_TESTS005.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
AddFiveStringsToCollection_GetOne_Verify PROCEDURE  (*long addr) ! Declare Procedure
StringColl                              DCL_System_StringCollection

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('AddFiveStringsToCollection_GetOne_Verify')
    StringColl.Add('defhi')
    StringColl.Add('defhij')
    StringColl.Add('abc')
    StringColl.Add('def')
    StringColl.Add('defg')
    AssertThat(StringColl.GetString(3),IsEqualTo('defg'),'Wrong string retrieved')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
