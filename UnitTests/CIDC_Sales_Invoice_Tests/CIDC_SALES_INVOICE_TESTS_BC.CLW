  MEMBER('CIDC_Sales_Invoice_Tests.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('CIDC_Sales_Invoice_Tests_BC0.CLW')
CIDC_Sales_Invoice_Tests_BC0:DctInit             PROCEDURE
CIDC_Sales_Invoice_Tests_BC0:DctKill             PROCEDURE
CIDC_Sales_Invoice_Tests_BC0:FilesInit           PROCEDURE
    END
  END

DLLInit              DllInitializer                          !This object is used to initialize the dll, it is defined in the main program module

DctInit PROCEDURE
  CODE
  CIDC_Sales_Invoice_Tests_BC0:DctInit
  CIDC_Sales_Invoice_Tests_BC0:FilesInit


DctKill PROCEDURE
  CODE
  CIDC_Sales_Invoice_Tests_BC0:DctKill

