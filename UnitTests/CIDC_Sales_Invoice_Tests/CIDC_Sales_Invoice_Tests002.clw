

   MEMBER('CIDC_Sales_Invoice_Tests.clw')                  ! This is a MEMBER module

                     MAP
                       INCLUDE('CIDC_SALES_INVOICE_TESTS002.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateLineItem_GetTotal_Verify PROCEDURE  (*long addr)     ! Declare Procedure
LineItem                            CIDC_Sales_LineItem
log                                 DCL_System_Diagnostics_Logger

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateLineItem_GetTotal_Verify')
    LineItem.TaxCodes &= GetTaxCodesObject()
    LineItem.SetPrice(12.34)
    LineItem.SetQuantity(5)
	AssertThat(LineItem.GetTotal(),IsEqualTo(61.70),'Wrong invoice total')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
