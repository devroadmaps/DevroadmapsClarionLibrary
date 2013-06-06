

   MEMBER('DCL_System_Pool_Tests.clw')                     ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_POOL_TESTS001.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
GetPoolItem_VerifyItemsLeft PROCEDURE  (*long addr)        ! Declare Procedure
pool                            DCL_System_Pool
used1                           long

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('GetPoolItem_VerifyItemsLeft')
	pool.Init(10)
	used1 = pool.GetItemNumber()
	AssertThat(pool.GetFreeItemCount(),IsEqualTo(9),'Wrong number of free items left')
	
	
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
GetThree_RemoveOne_GetOne_VerifyReuse PROCEDURE  (*long addr) ! Declare Procedure
pool                            DCL_System_Pool
used1                                       long
used2                                       long
used3                                       long
used4                                       long

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('GetThree_RemoveOne_GetOne_VerifyReuse')
	pool.Init(10)
	used1 = pool.GetItemNumber()
	AssertThat(used1,IsEqualTo(1),'Wrong first number')
	used2 = pool.GetItemNumber()
	AssertThat(used2,IsEqualTo(2),'Wrong second number')
	used3 = pool.GetItemNumber()
	AssertThat(used3,IsEqualTo(3),'Wrong third number')
	AssertThat(pool.GetFreeItemCount(),IsEqualTo(7),'Wrong free item count after adding three')
	pool.ReleaseItemNumber(2)
	AssertThat(pool.GetFreeItemCount(),IsEqualTo(8),'Wrong free item count after releasing one')
	used4 = pool.GetItemNumber()
	AssertThat(used4,IsEqualTo(2),'Wrong fourth (reclaimed) number')
	
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
