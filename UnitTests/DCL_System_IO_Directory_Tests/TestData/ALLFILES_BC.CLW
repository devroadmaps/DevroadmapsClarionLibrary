  MEMBER('Allfiles.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('Allfiles_BC0.CLW')
Allfiles_BC0:DctInit             PROCEDURE
Allfiles_BC0:DctKill             PROCEDURE
Allfiles_BC0:FilesInit           PROCEDURE
    END
  END

DLLInit              DllInitializer                          !This object is used to initialize the dll, it is defined in the main program module

DctInit PROCEDURE
  CODE
  Allfiles_BC0:DctInit
  Allfiles_BC0:FilesInit


DctKill PROCEDURE
  CODE
  Allfiles_BC0:DctKill

