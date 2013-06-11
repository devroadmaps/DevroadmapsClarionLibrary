

   MEMBER('CIDC_Sales_Invoice_Tests.clw')                  ! This is a MEMBER module

                     MAP
                       INCLUDE('CIDC_SALES_INVOICE_TESTS003.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
SetValueAndTaxCode_GetTaxAmount_Verify PROCEDURE  (*long addr) ! Declare Procedure

Invoice                                     CIDC_Sales_Invoice
LineItem                                    &CIDC_Sales_LineItem

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('SetValueAndTaxCode_GetTaxAmount_Verify')
    Invoice.Init(GetTaxCodesObject())
    
    LineItem &= Invoice.AddDetail()
    LineItem.SetPrice(12.34)
    LineItem.SetQuantity(5)
    LineItem.SetTaxCode(TaxCode:PST)
    LineItem.Description = 'Item 1'
    
    LineItem &= Invoice.AddDetail()
    LineItem.SetPrice(182.20)
    LineItem.SetQuantity(2)
    LineItem.SetTaxCode(TaxCode:GST)
    LineItem.Description = 'Item 2'
    
    AssertThat(Invoice.GetTotal(),IsEqualTo(448.64),'Wrong invoice total')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
