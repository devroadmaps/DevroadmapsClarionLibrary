  MEMBER('DCL_System_Pool_Tests.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('DCL_System_Pool_Tests_BC0.CLW')
DCL_System_Pool_Tests_BC0:DctInit             PROCEDURE
DCL_System_Pool_Tests_BC0:DctKill             PROCEDURE
DCL_System_Pool_Tests_BC0:FilesInit           PROCEDURE
    END
  END

DLLInit              DllInitializer                          !This object is used to initialize the dll, it is defined in the main program module

DctInit PROCEDURE
  CODE
  DCL_System_Pool_Tests_BC0:DctInit
  DCL_System_Pool_Tests_BC0:FilesInit


DctKill PROCEDURE
  CODE
  DCL_System_Pool_Tests_BC0:DctKill

