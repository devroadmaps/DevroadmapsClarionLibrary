

   MEMBER('CIDC_Sales_UI_Invoice_Tests.clw')               ! This is a MEMBER module

                     MAP
                       INCLUDE('CIDC_SALES_UI_INVOICE_TESTS001.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
NoName               PROCEDURE  (*long addr)               ! Declare Procedure
Invoice CIDC_Sales

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('NoName')
	AssertThat(1,IsEqualTo(1),'This test should never fail, so this message should never appear')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
