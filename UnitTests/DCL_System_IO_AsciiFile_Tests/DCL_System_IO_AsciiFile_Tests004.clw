

   MEMBER('DCL_System_IO_AsciiFile_Tests.clw')             ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_IO_ASCIIFILE_TESTS004.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateFile_Replace_Verify PROCEDURE  (*long addr)          ! Declare Procedure
FilesOpened          LONG                                  !
testfilename                        cstring(500)
testq                               QUEUE
txt                                     cstring(500)
									end
x                                   long
reccount                            long
txt                             cstring(500)
TestFile                        DCL_System_IO_AsciiFile

  CODE
    !gdbg.write('test')
  addr = address(UnitTestResult)
  BeginUnitTest('CreateFile_Replace_Verify')
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
	loop x = 1 to 5
        testq.txt = 'line ' & x
        add(testq)
	end
	AssertThat(testfile.Replace(testfilename,testq,testq.txt),IsEqualTo(Level:Benign),'Replace method failed')
	AssertThat(exists(testfilename),IsEqualTo(true),'Could not create ' & testfilename)
	
	testfile.openfile(testfilename)
	reccount = 0
	loop while testfile.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount),'Unexpected text found in ' & testfilename)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename)

  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateTwoFiles_VerifyContents PROCEDURE  (*long addr)      ! Declare Procedure
FilesOpened          LONG                                  !
testfilename1                        cstring(500)
testfilename2                        cstring(500)
!testq                               QUEUE
!txt                                     cstring(500)
!									end
testfile1                            DCL_System_IO_AsciiFile
testfile2                            DCL_System_IO_AsciiFile
testfile3                            DCL_System_IO_AsciiFile
testfile4                            DCL_System_IO_AsciiFile
testfile5                            DCL_System_IO_AsciiFile
!testfile6                            DCL_System_IO_AsciiFile
x                                   long
reccount                            long
txt                             cstring(500)
dbg                                 DCL_System_Diagnostics_Logger



  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateTwoFiles_VerifyContents')
	dbg.SetPrefix('***')
	
	!----- Set up testfile1 ---

    testfilename1 = GetTestDirectory() & '\testdata'
    if not exists(testfilename1)
		CreateDirectory(testfilename1)
	end
	AssertThat(exists(testfilename1),IsEqualTo(true),'Directory does not exist: ' & testfilename1)
	testfilename1 = testfilename1 & '\test1.txt'
	if exists(testfilename1)
		remove(testfilename1)
	END
	AssertThat(exists(testfilename1),IsEqualTo(false),'Could not delete ' & testfilename1)
	dbg.write('Before CreateFile')
	testfile1.createfile(testfilename1)
	
	!----- Set up testfile2 ---

    testfilename2 = GetTestDirectory() & '\testdata'
    if not exists(testfilename2)
		CreateDirectory(testfilename2)
	end
	AssertThat(exists(testfilename2),IsEqualTo(true),'Directory does not exist: ' & testfilename2)
	testfilename2 = testfilename2 & '\test2.txt'
	if exists(testfilename2)
		remove(testfilename2)
	END
	AssertThat(exists(testfilename2),IsEqualTo(false),'Could not delete ' & testfilename2)
	dbg.write('Before CreateFile')
	testfile2.createfile(testfilename2)
	
	
	!--- Write out the text to both files
	dbg.write('After CreateFile, before writing lines')
	loop x = 1 to 5
		dbg.write('Writing line ' & x)
		testfile1.write('line ' & x)
		testfile2.write('line ' & x + 10)
	end
	dbg.write('Before CloseFile')
	testfile1.closefile()
	testfile2.closefile()
	AssertThat(exists(testfilename1),IsEqualTo(true),'Could not create ' & testfilename1)
	AssertThat(exists(testfilename2),IsEqualTo(true),'Could not create ' & testfilename2)
	
	
	!-- Verify file 1 
	testfile1.openfile(testfilename1)
	reccount = 0
	loop while testfile1.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount),'Unexpected text found in ' & testfilename1)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename1)
	testfile1.CloseFile()

	!-- Verify file 2 
	testfile2.openfile(testfilename2)
	reccount = 0
	loop while testfile2.read(txt) = level:benign
		reccount += 1
		AssertThat(txt,isequalto('line ' & reccount + 10),'Unexpected text found in ' & testfilename2)
	end
	AssertThat(reccount,IsEqualTo(5),'Wrong number of records in ' & testfilename2)
	testfile2.CloseFile()
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
