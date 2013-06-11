

   MEMBER('CIDC_Sales_Invoice_Tests.clw')                  ! This is a MEMBER module

                     MAP
                       INCLUDE('CIDC_SALES_INVOICE_TESTS006.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateLineItem_GetTax_Verify PROCEDURE  (*long addr)       ! Declare Procedure
LineItem                                    CIDC_Sales_LineItem


  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateLineItem_GetTax_Verify')
    LineItem.TaxCodes &= GetTaxCodesObject()
    LineItem.SetPrice(12.34)
    LineItem.SetTaxCode(TaxCodePST)
	AssertThat(LineItem.GetTax(),IsEqualTo(0.86),'Wrong invoice total')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
