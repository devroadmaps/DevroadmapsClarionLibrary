

   MEMBER('DCL_System_String_Tests.clw')                   ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_STRING_TESTS002.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
ReplaceString_Verify PROCEDURE  (*long addr)               ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('ReplaceString_Verify')
	str.Assign('http://www.clarionmag.com/cmag/v9/v9n11stringclass.html')

    str.Replace('/','\')
	AssertThat(str.Get(),IsEqualTo('http:\\www.clarionmag.com\cmag\v9\v9n11stringclass.html'),'Failed test 1')

    str.Replace('.html','.zip')
	AssertThat(str.Get(),IsEqualTo('http:\\www.clarionmag.com\cmag\v9\v9n11stringclass.zip'),'Failed test 2')

    str.Assign('D:\dev-IES\ExtractProceduresTest\testdata\UPDATES001.CLW')
    
	str.Replace('.CLW','.inc')
	AssertThat(str.Get(),IsEqualTo('D:\dev-IES\ExtractProceduresTest\testdata\UPDATES001.inc'),'Failed test 3')
	
    
    str.Assign('abcdef')
    str.Replace('a','')
    AssertThat(str.Get(),IsEqualTo('bcdef'),'Failed test 4')

  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
PrependString_Verify PROCEDURE  (*long addr)               ! Declare Procedure
FilesOpened          LONG                                  !
str	DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('PrependString_Verify')
	str.Assign('abc')
	str.Prepend('def')
	AssertThat(str.get(),IsEqualTo('defabc'))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
FindLastIndexOf_Verify PROCEDURE  (*long addr)             ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('FindLastIndexOf_Verify')
	str.Assign('ababcd')
	AssertThat(str.LastIndexOf('ab'),IsEqualto(3))
	str.Assign('abc\def\ghi')
	AssertThat(str.LastIndexOf('\'),IsEqualTo(8))	
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
InsertStringIntoString_Verify PROCEDURE  (*long addr)      ! Declare Procedure
FilesOpened          LONG                                  !
str	DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('InsertStringIntoString_Verify')
	str.Assign('abcdef')
	str.InsertAt('xyz',4)
	AssertThat(str.get(),IsEqualTo('abcxyzdef'))
	str.Assign('abcdef')
	str.InsertAt('xyz',-0)
	AssertThat(str.get(),IsEqualTo('xyzabcdef'))
	str.Assign('abcdef')
	str.InsertAt('xyz',1)
	AssertThat(str.get(),IsEqualto('xyzabcdef'))
	str.Assign('abcdef')
	str.InsertAt('xyz',7)
	AssertThat(str.get(),IsEqualTo('abcdefxyz'))
	str.Assign('abcdef')
	str.InsertAt('xyz',23)
	AssertThat(str.get(),IsEqualTo('abcdefxyz'))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
InsertStringIntoFilePath_Verify PROCEDURE  (*long addr)    ! Declare Procedure
FilesOpened          LONG                                  !
str	DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('InsertStringIntoFilePath_Verify')
	str.Assign('\cmag\v1\v1n1news.zip')
	AssertThat(str.LastIndexOf('\'),IsEqualTo(9))
	str.InsertAt('\files',str.LastIndexOf('\'))
	AssertThat(str.get(),IsEqualTo('\cmag\v1\files\v1n1news.zip'))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
FindIndexOf_Verify   PROCEDURE  (*long addr)               ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('FindIndexOf_Verify')
	str.Assign('abcdefghi')
	AssertThat(str.IndexOf('fgh'),IsEqualTo(6))
	str.Assign('ab\cdefghi')
	AssertThat(str.IndexOf('\'),IsEqualTo(3))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
DoesStringBeginWith_Verify PROCEDURE  (*long addr)         ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('DoesStringBeginWith_Verify')
	str.Assign('abcdefghi')
	AssertThat(str.BeginsWith('a'),IsEqualTo(true),'1')
	AssertThat(str.BeginsWith('abc'),IsEqualTo(true),'1')
	AssertThat(str.BeginsWith('abcdefghi'),IsEqualTo(true),'2')
	AssertThat(str.BeginsWith('bc'),IsEqualTo(false),'3')
	AssertThat(str.BeginsWith('abcdefghij'),IsEqualTo(false),'4')
	AssertThat(str.BeginsWith(''),IsEqualTo(false),'5')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
DoesStringEndWith_Verify PROCEDURE  (*long addr)           ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('DoesStringEndWith_Verify')
	str.Assign('abcdefghi')
	AssertThat(str.EndsWith('ghi'),IsEqualTo(true),'1')
	AssertThat(str.EndsWith('i'),IsEqualTo(true),'1')
	AssertThat(str.EndsWith('abcdefghi'),IsEqualTo(true),'2')
	AssertThat(str.EndsWith('bc'),IsEqualTo(false),'3')
	AssertThat(str.EndsWith('abcdefghij'),IsEqualTo(false),'4')
	AssertThat(str.EndsWith(''),IsEqualTo(false),'5')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
SplitString_VerifyCountAndValues PROCEDURE  (*long addr)   ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String
count	long

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('SplitString_VerifyCountAndValues')
	str.Assign('abc,defg,hi')
	str.Split(',')
	count = str.Records()
	AssertThat(count,IsEqualto(3),'Wrong number of lines from split')
	if count = 3
		AssertThat(str.GetLine(1),IsEqualTo('abc'),'Wrong value for line 1')
		AssertThat(str.GetLine(2),IsEqualTo('defg'),'Wrong value for line 2')
		AssertThat(str.GetLine(3),IsEqualTo('hi'),'Wrong value for line 3')
	end
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
SplitStringWithMultipleDelimiters_VerifyCountAndValues PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
str                                                         DCL_System_String
count                                                       long
q                                                           QUEUE
s                                                               string(100)
															end

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('SplitStringWithMultipleDelimiters_VerifyCountAndValues')
	str.Assign('abc;defg, hi j')
	q.s = ' '
	add(q)
	q.s = ';'
	add(q)
	q.s = ','
	add(q)
	str.Split(q)
	count = str.Records()
	AssertThat(count,IsEqualto(4),'Wrong number of lines from split')
	if count = 4
		AssertThat(str.GetLine(1),IsEqualTo('abc'),'Wrong value for line 1')
		AssertThat(str.GetLine(2),IsEqualTo('defg'),'Wrong value for line 2')
		AssertThat(str.GetLine(3),IsEqualTo('hi'),'Wrong value for line 3')
		AssertThat(str.GetLine(4),IsEqualTo('j'),'Wrong value for line 4')
	end
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
