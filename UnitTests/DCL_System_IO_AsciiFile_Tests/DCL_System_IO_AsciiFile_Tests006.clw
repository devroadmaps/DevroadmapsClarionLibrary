

   MEMBER('DCL_System_IO_AsciiFile_Tests.clw')             ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_IO_ASCIIFILE_TESTS006.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! </summary>
GetTestDirectory     PROCEDURE                             ! Declare Procedure
TestDirectory               cstring(500)

  CODE
    TestDirectory = longpath() & '\DCL_System_IO_AsciiFile_Tests'
    if not exists(TestDirectory) then TestDirectory = LongPath().
    TestDirectory = TestDirectory & '\testdata'
    return TestDirectory
        
        
    
    
