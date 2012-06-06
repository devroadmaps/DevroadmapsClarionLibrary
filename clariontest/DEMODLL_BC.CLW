  MEMBER('DemoDLL.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('DemoDLL_BC0.CLW')
DemoDLL_BC0:DctInit             PROCEDURE
DemoDLL_BC0:DctKill             PROCEDURE
DemoDLL_BC0:FilesInit           PROCEDURE
    END
  END

DLLInit              DllInitializer                          !This object is used to initialize the dll, it is defined in the main program module

DctInit PROCEDURE
  CODE
  DemoDLL_BC0:DctInit
  DemoDLL_BC0:FilesInit


DctKill PROCEDURE
  CODE
  DemoDLL_BC0:DctKill

