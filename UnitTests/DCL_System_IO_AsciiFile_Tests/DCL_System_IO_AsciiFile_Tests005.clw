

   MEMBER('DCL_System_IO_AsciiFile_Tests.clw')             ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_IO_ASCIIFILE_TESTS005.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
Read50KText_VerifyLength PROCEDURE  (*long addr)           ! Declare Procedure
FilesOpened          LONG                                  !
testfilename                        cstring(500)
testfile                            DCL_System_IO_AsciiFile
txt                                 cstring(65000)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('Read50KText_VerifyLength')
    testfilename = GetTestDirectory()
    if not exists(testfilename)
		CreateDirectory(testfilename)
	end
	AssertThat(exists(testfilename),IsEqualTo(true),'Directory does not exist: ' & testfilename)
	testfilename = testfilename & '\longrecord.txt'
	testfile.openfile(testfilename)
    AssertThat(testfile.read(txt),IsEqualTo(level:benign),'Could not read text file ' & testfilename)
    AssertThat(len(txt),IsEqualTo(57390),'Wrong text length')


  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
