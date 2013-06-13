

   MEMBER('CIDC_Sales_Invoice_Tests.clw')                  ! This is a MEMBER module

                     MAP
                       INCLUDE('CIDC_SALES_INVOICE_TESTS008.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateInvoice_AddItemsAndMultipleTaxes_GetTotal_Verify PROCEDURE  (*long addr) ! Declare Procedure
TaxList                                                     CIDC_Sales_TaxList

Invoice                                                     CIDC_Sales_Invoice
LineItem                                                    &CIDC_Sales_LineItem

TaxA                                                        equate('A')
TaxB                                                        equate('B')
TaxC                                                        equate('C')

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateInvoice_AddItemsAndMultipleTaxes_GetTotal_Verify')
    TaxList.AddTax(TaxA,5)
    TaxList.AddTax(TaxB,6)
    TaxList.AddTax(TaxC,7)
    Invoice.Init(TaxList)
    
    LineItem &= Invoice.AddDetail()
	LineItem.SetPrice(11)
    LineItem.SetQuantity(1)
    LineItem.AddTaxCode(taxA)
    LineItem.Description = 'Product A'
    
    LineItem &= Invoice.AddDetail()
    LineItem.SetPrice(22)
    LineItem.SetQuantity(2)
    LineItem.AddTaxCode(taxB)
    LineItem.Description = 'Product B'

    LineItem &= Invoice.AddDetail()
    LineItem.SetPrice(33)
    LineItem.SetQuantity(3)
    LineItem.AddTaxCode(taxA)
    LineItem.AddTaxCode(taxB)
    LineItem.Description = 'Product C'

    LineItem &= Invoice.AddDetail()
    LineItem.SetPrice(44)
    LineItem.SetQuantity(4)
    LineItem.AddTaxCode(taxC)
    LineItem.Description = 'Product D'

    LineItem &= Invoice.AddDetail()
    LineItem.SetPrice(55)
    LineItem.SetQuantity(5)
    LineItem.AddTaxCode(taxA)
    LineItem.AddTaxCode(taxC)
    LineItem.Description = 'Product E'

    LineItem &= Invoice.AddDetail()
    LineItem.SetPrice(66)
    LineItem.SetQuantity(6)
    LineItem.AddTaxCode(taxB)
    LineItem.AddTaxCode(taxC)
    LineItem.Description = 'Product F'

    LineItem &= Invoice.AddDetail()
    LineItem.SetPrice(77)
    LineItem.SetQuantity(7)
    LineItem.AddTaxCode(taxA)
    LineItem.AddTaxCode(taxB)
    LineItem.AddTaxCode(taxC)
    LineItem.Description = 'Product G'

    AssertThat(Invoice.GetTotal(),IsEqualTo(1747.9),'Wrong invoice grand total')
    AssertThat(Invoice.GetTax(),IsEqualTo(207.9),'Wrong tax grand total')
    AssertThat(invoice.TaxCodesUsed.GetCount(),IsEqualTo(3),'Wrong number of tax codes used')

    AssertThat(invoice.TaxCodesUsed.GetTaxableTotal(TaxA),IsEqualTo(924),'Wrong taxable total for TaxA')
    AssertThat(invoice.TaxCodesUsed.GetTaxableTotal(TaxB),IsEqualTo(1078),'Wrong taxable total for TaxB')
    AssertThat(invoice.TaxCodesUsed.GetTaxableTotal(TaxC),IsEqualTo(1386),'Wrong taxable total for TaxC')

  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
