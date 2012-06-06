  MEMBER('ClarionTest.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('ClarionTest_BC0.CLW')
ClarionTest_BC0:DctInit             PROCEDURE
ClarionTest_BC0:DctKill             PROCEDURE
ClarionTest_BC0:FilesInit           PROCEDURE
    END
  END

DctInit PROCEDURE
  CODE
  ClarionTest_BC0:DctInit
  ClarionTest_BC0:FilesInit


DctKill PROCEDURE
  CODE
  ClarionTest_BC0:DctKill

