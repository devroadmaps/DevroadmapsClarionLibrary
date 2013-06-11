

   MEMBER('CIDC_Sales_Invoice_Tests.clw')                  ! This is a MEMBER module

                     MAP
                       INCLUDE('CIDC_SALES_INVOICE_TESTS003.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
SetValueAndTaxCode_GetTaxAmount_Verify PROCEDURE  (*long addr) ! Declare Procedure

Value                                       decimal(9,2)
TaxAmount                                   decimal(9,2)
TaxRate                                     decimal(5,2)

TaxCodes                                    &CIDC_Sales_TaxCodes

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('SetValueAndTaxCode_GetTaxAmount_Verify')
    TaxCodes &= GetTaxCodesObject()
    AssertThat(TaxCodes.GetTaxRate('P',TaxRate),IsEqualTo(Level:Benign),'Failure getting PST rate')
    AssertThat(TaxRate,IsEqualTo(7),'Wrong PST rate')
    AssertThat(TaxCodes.GetTaxRate('G',TaxRate),IsEqualTo(Level:Benign),'Failure getting GST rate')
    AssertThat(TaxRate,IsEqualTo(5),'Wrong GST rate')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
