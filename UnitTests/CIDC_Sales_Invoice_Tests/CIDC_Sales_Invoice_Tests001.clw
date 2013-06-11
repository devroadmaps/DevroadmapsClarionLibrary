

   MEMBER('CIDC_Sales_Invoice_Tests.clw')                  ! This is a MEMBER module

                     MAP
                       INCLUDE('CIDC_SALES_INVOICE_TESTS001.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateInvoice_AddItem_GetTotal_Verify PROCEDURE  (*long addr) ! Declare Procedure
Invoice                                     CIDC_Sales_Invoice
LineItem                                    &CIDC_Sales_LineItem


  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateInvoice_AddItem_GetTotal_Verify')
    Invoice.Init(GetTaxCodesObject())
    LineItem &= Invoice.AddDetail()
	LineItem.SetPrice(12.34)
	LineItem.SetQuantity(5)
	AssertThat(Invoice.GetTotal(),IsEqualTo(61.70),'Wrong invoice total')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
