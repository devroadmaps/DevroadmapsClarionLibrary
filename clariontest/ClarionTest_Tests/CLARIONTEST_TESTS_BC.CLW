  MEMBER('ClarionTest_Tests.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('ClarionTest_Tests_BC0.CLW')
ClarionTest_Tests_BC0:DctInit             PROCEDURE
ClarionTest_Tests_BC0:DctKill             PROCEDURE
ClarionTest_Tests_BC0:FilesInit           PROCEDURE
    END
  END

DLLInit              DllInitializer                          !This object is used to initialize the dll, it is defined in the main program module

DctInit PROCEDURE
  CODE
  ClarionTest_Tests_BC0:DctInit
  ClarionTest_Tests_BC0:FilesInit


DctKill PROCEDURE
  CODE
  ClarionTest_Tests_BC0:DctKill

