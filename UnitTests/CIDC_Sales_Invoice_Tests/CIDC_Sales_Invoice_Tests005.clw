

   MEMBER('CIDC_Sales_Invoice_Tests.clw')                  ! This is a MEMBER module

                     MAP
                       INCLUDE('CIDC_SALES_INVOICE_TESTS005.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateLineItem_GetExtended_Verify PROCEDURE  (*long addr)  ! Declare Procedure
LineItem                                    CIDC_Sales_LineItem


  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateLineItem_GetExtended_Verify')
    LineItem.TaxCodes &= GetTaxCodesObject()
    LineItem.SetPrice(12.34)
	LineItem.SetQuantity(5)
	AssertThat(LineItem.GetExtended(),IsEqualTo(61.70),'Wrong invoice total')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
