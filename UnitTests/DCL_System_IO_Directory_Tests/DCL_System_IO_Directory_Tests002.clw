

   MEMBER('DCL_System_IO_Directory_Tests.clw')             ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_IO_DIRECTORY_TESTS002.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
GetListOfAppsInDirectory_VerifyNames PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
dm                                          DCL_System_IO_Directory
!filesq                                      DCL_System_IO_DirectoryQueue
x                                           long	
dirname                                                             cstring(500)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('GetListOfAppsInDirectory_VerifyNames')
	dirname = longpath() & '\testdata'
	AssertThat(exists(Dirname),IsEqualTo(true),'Could not find directory ' & dirname)
	dm.Init(dirname)
	dm.SetFilter('*.app')
	dm.SetFilesOnly(true)
	AssertThat(dm.FileCount(),IsEqualTo(4), 'Did not find four dlls')
	!Dm.LoadnamesQueue(filesq)
	get(dm.filesq,1)
	AssertThat(lower(dm.FilesQ.name),IsEqualTo('allfiles.app'))
	get(dm.FilesQ,2)
	AssertThat(lower(dm.FilesQ.name),IsEqualTo('dlltutor.app'))
	get(dm.FilesQ,3)
	AssertThat(lower(dm.FilesQ.name),IsEqualTo('reports.app'))
	get(dm.FilesQ,4)
	AssertThat(lower(dm.FilesQ.name),IsEqualTo('updates.app'))
    return 0
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateRemoveDirectory PROCEDURE  (*long addr)              ! Declare Procedure
FilesOpened          LONG                                  !
dm                              DCL_System_IO_Directory
dirname                         cstring(500)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateRemoveDirectory')
	dirname = longpath() & '\temporary directory for testing purposes'
	dm.Init(dirname)
	if exists(dirname)
		dm.RemoveDirectory()
	END
	AssertThat(exists(Dirname),IsEqualTo(false),'could not delete pre-existing directory ' & dirname)
	dm.CreateDirectory(dirname)
	AssertThat(exists(Dirname),IsEqualTo(true),'could not create directory ' & dirname)
	dm.RemoveDirectory()
	AssertThat(exists(Dirname),IsEqualTo(false),'could not delete just-created directory ' & dirname)
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
CreateRemoveNonEmptyDirectory PROCEDURE  (*long addr)      ! Declare Procedure
FilesOpened          LONG                                  !
dm                                      DCL_System_IO_Directory
dirname                                 cstring(500)
testfile                                &DCL_System_IO_AsciiFile
testfilename                        cstring(500)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('CreateRemoveNonEmptyDirectory')
    testfile &= DCL_System_IO_AsciiFileManager.GetAsciiFileInstance(DCL_System_IO_AsciiFile_InstanceNumber1)
    dirname = longpath() & '\temporary_directory_for_testing_purposes'
	dm.Init(dirname)
	dm.RemoveDirectory()
	AssertThat(exists(Dirname),IsEqualTo(false),'could not delete directory ' & dirname)
	dm.CreateDirectory(dirname)
	AssertThat(exists(Dirname),IsEqualTo(true),'could not create directory ' & dirname)
	testfilename = dirname & '\test.txt'
	testfile.CreateFile(testfilename)
	testfile.Write('blah blah blah')
	testfile.CloseFile()
	AssertThat(exists(testfilename),IsEqualTo(true),'Could not create ' & testfilename)
	dm.RemoveDirectory()
	AssertThat(exists(Dirname),IsEqualTo(false),'could not delete directory ' & dirname)
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
DirectoryManager_GetListOfOneAppInDirectory_VerifyAppName PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
dm                                                                  DCL_System_IO_Directory
!filesq                                                              DCL_System_IO_DirectoryQueue
x                                                                   long	
pathname                                                            cstring(500)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('DirectoryManager_GetListOfOneAppInDirectory_VerifyAppName')
	pathname = longpath() & '\testdata'
	dm.Init(pathname)
	dm.SetFilter('updates.app')
	dm.SetFilesOnly(true)
	AssertThat(dm.FileCount(),IsEqualTo(1), 'Did not find updates.app in ' & pathname)
	!Dm.LoadFilenamesQueue(filesq)
	get(dm.filesq,1)
	AssertThat(lower(dm.filesq.name),IsEqualTo('updates.app'))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
GetChecksumOfFilesInDirectory_Verify PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
dm                                          DCL_System_IO_Directory
!filesq                                      DCL_System_IO_DirectoryQueue
!x                                           long	
dirname                                                             cstring(500)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('GetChecksumOfFilesInDirectory_Verify')
	dirname = longpath() & '\testdata'
	AssertThat(exists(Dirname),IsEqualTo(true),'Could not find directory ' & dirname)
	dm.Init(dirname)
	dm.SetFilter('*.app')
	dm.SetFilesOnly(true)
	AssertThat(dm.FileCount(),IsEqualTo(4), 'Did not find four dlls')
	AssertThat(dm.GetChecksum(),IsEqualTo(310433.7135404),'Wrong checksum for directory listing')
    return 0
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - GroupProcedure
!!! </summary>
CurrentTests         PROCEDURE                             ! Declare Procedure

  CODE
