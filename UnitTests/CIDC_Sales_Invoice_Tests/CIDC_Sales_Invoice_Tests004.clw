

   MEMBER('CIDC_Sales_Invoice_Tests.clw')                  ! This is a MEMBER module

                     MAP
                       INCLUDE('CIDC_SALES_INVOICE_TESTS004.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
GetTaxCodesObject    PROCEDURE                             ! Declare Procedure
dbg                         DCL_System_Diagnostics_Logger

  CODE
    if ManitobaTaxCodes &= null
        ManitobaTaxCodes &= new CIDC_Sales_TaxCodes_CA_MB
    end
    return ManitobaTaxCodes
