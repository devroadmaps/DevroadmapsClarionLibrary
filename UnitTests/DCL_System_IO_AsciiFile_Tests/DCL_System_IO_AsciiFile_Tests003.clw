

   MEMBER('DCL_System_IO_AsciiFile_Tests.clw')             ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_IO_ASCIIFILE_TESTS003.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateFile_VerifyContents PROCEDURE  (*long addr)          ! Declare Procedure
FilesOpened          LONG                                  !
testfilename                        cstring(500)
testq                               QUEUE
txt                                     cstring(500)
									end
testfile                            DCL_System_IO_AsciiFile
x                                   long
reccount                            long
txt                             cstring(500)
dbg                             DCL_System_Diagnostics_Logger

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateFile_VerifyContents')
	dbg.SetPrefix('***')

    testfilename = GetTestDirectory() & '\testdata'
    if not exists(testfilename)
		CreateDirectory(testfilename)
	end
	AssertThat(exists(testfilename),IsEqualTo(true),'Directory does not exist: ' & testfilename)
	testfilename = testfilename & '\test.txt'
	if exists(testfilename)
		remove(testfilename)
	END
	AssertThat(exists(testfilename),IsEqualTo(false),'Could not delete ' & testfilename)
	dbg.write('Before CreateFile')
	testfile.createfile(testfilename)
	dbg.write('After CreateFile, before writing lines')
	loop x = 1 to 5
		dbg.write('Writing line ' & x)
		testfile.write('line ' & x)
	end
	dbg.write('Before CloseFile')
	testfile.closefile()
	AssertThat(exists(testfilename),IsEqualTo(true),'Could not create ' & testfilename)
	
	testfile.openfile(testfilename)
	reccount = 0
	loop while testfile.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount),'Unexpected text found in ' & testfilename)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename)
	testfile.CloseFile()

  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateFile_CompareAgainstQueue PROCEDURE  (*long addr)     ! Declare Procedure
FilesOpened          LONG                                  !
testfilename                        cstring(500)
testq                               QUEUE
txt                                     cstring(500)
									end
testfile                            DCL_System_IO_AsciiFile
x                                   long
reccount                            long
txt                                 cstring(500)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateFile_CompareAgainstQueue')
	testfilename = GetTestDirectory() & '\testdata'
	if not exists(testfilename)
		CreateDirectory(testfilename)
	end
	AssertThat(exists(testfilename),IsEqualTo(true),'Directory does not exist: ' & testfilename)
	testfilename = testfilename & '\test2.txt'
	if exists(testfilename)
		remove(testfilename)
	END
	AssertThat(exists(testfilename),IsEqualTo(false),'Could not delete ' & testfilename)
	testfile.createfile(testfilename)
	loop x = 1 to 5
		testfile.write('line ' & x)
	end
	testfile.closefile()
	AssertThat(exists(testfilename),IsEqualTo(true),'Could not create ' & testfilename)

	testfile.openfile(testfilename)
	reccount = 0
	loop while testfile.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount),'Unexpected text found in ' & testfilename)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename)
	
	! Create a queu with six lines
	testfile.openfile(testfilename)
	free(testq)
	loop x = 1 to 6
		testq.txt = 'line ' & x - 1
		add(testq)
	end
	AssertThat(testfile.replace(testfilename,testq,testq.txt),IsEqualTo(level:benign),'Replace method failed')
	

	testfile.openfile(testfilename)
	! Verify the new file
	reccount = 0
	loop while testfile.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount -1),'Unexpected text found in ' & testfilename)
	end
	AssertThat(reccount,IsEqualTo(6),'Wrong number of records in ' & testfilename)


  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
