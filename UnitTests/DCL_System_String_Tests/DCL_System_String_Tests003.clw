

   MEMBER('DCL_System_String_Tests.clw')                   ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_STRING_TESTS003.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
TrimString_Verify    PROCEDURE  (*long addr)               ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('TrimString_Verify')
    str.Assign('  abcde ')
    str.trim()
	AssertThat(str.Get(),IsEqualTo('abcde'))
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
ReplaceWholeWord_Verify PROCEDURE  (*long addr)            ! Declare Procedure
FilesOpened          LONG                                  !
str                         DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('ReplaceWholeWord_Verify')
	str.Assign('The quick brown fox jumped over the lazy dog.')
	str.Replace('brown','green')
	AssertThat(str.Get(),IsEqualTo('The quick green fox jumped over the lazy dog.'),'Test 1 failed')

	str.Assign('The quick brown fox jumped over the lazy dog.')
	str.ReplaceWord('brown','green')
	AssertThat(str.Get(),IsEqualTo('The quick green fox jumped over the lazy dog.'),'Test 2 failed')
	
	str.Assign('The quick brown fox jumped over the lazy dog.')
	str.Replace('ox','cow')
	AssertThat(str.Get(),IsEqualTo('The quick brown fcow jumped over the lazy dog.'),'Test 3 failed')

	str.Assign('The quick brown fox jumped over the lazy dog.')
	str.ReplaceWord('ox','cow')
	AssertThat(str.Get(),IsEqualTo('The quick brown fox jumped over the lazy dog.'),'Test 4 failed')
	

	str.Assign('The quick brown fox jumped over the lazy dog.')
	str.ReplaceWord('The quick','A slow')
	AssertThat(str.Get(),IsEqualTo('A slow brown fox jumped over the lazy dog.'),'Test 5 failed')
	
	str.Assign('The quick brown fox jumped over the lazy dog.')
	str.ReplaceWord('dog','horse')
	AssertThat(str.Get(),IsEqualTo('The quick brown fox jumped over the lazy horse.'),'Test 6 failed')
	
    str.Assign('The quick brown fox jumped over the lazy dog.')
    str.ReplaceWord('The','A')
    AssertThat(str.Get(),IsEqualTo('A quick brown fox jumped over the lazy dog.'),'Test 7 failed')
	
    str.Assign('The quick brown fox jumped over the lazy dog.')
    str.ReplaceWord('The','')
    AssertThat(str.Get(),IsEqualTo(' quick brown fox jumped over the lazy dog.'),'Test 8 failed')
	
    str.Assign('The quick brown fox jumped over the lazy dog.')
    str.ReplaceWord('dog','')
    AssertThat(str.Get(),IsEqualTo('The quick brown fox jumped over the lazy .'),'Test 9 failed')
	

  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
IsAlpha_Verify       PROCEDURE  (*long addr)               ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('IsAlpha_Verify')
	AssertThat(str.IsAlpha(''),IsEqualTo(false),'empty string is not alpha')
	AssertThat(str.IsAlpha(' '),IsEqualTo(false),'empty string is not alpha')
	AssertThat(str.IsAlpha('a'),IsEqualTo(true),'a is alpha')
	AssertThat(str.IsAlpha('z'),IsEqualTo(true),'z is alpha')
	AssertThat(str.IsAlpha('A'),IsEqualTo(true),'A is alpha')
	AssertThat(str.IsAlpha('Z'),IsEqualTo(true),'Z is alpha')
	AssertThat(str.IsAlpha('.'),IsEqualTo(false),'. is not alpha')
	AssertThat(str.IsAlpha(','),IsEqualTo(false),', is not alpha')
	AssertThat(str.IsAlpha(''''),IsEqualTo(false),''' is not alpha')
	AssertThat(str.IsAlpha(';'),IsEqualTo(false),'; is not alpha')
	AssertThat(str.IsAlpha('@'),IsEqualTo(false),'@ is not alpha')
	AssertThat(str.IsAlpha('['),IsEqualTo(false),'[ is not alpha')
	AssertThat(str.IsAlpha('`'),IsEqualTo(false),'` is not alpha')
	AssertThat(str.IsAlpha('{{'),IsEqualTo(false),'{{ is not alpha')
	!SetUnitTestFailed('Isalpha')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
ReplaceMultipleWords_Verify PROCEDURE  (*long addr)        ! Declare Procedure
FilesOpened          LONG                                  !
str                         DCL_System_String

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('ReplaceMultipleWords_Verify')
	str.Assign('The quick brown fox jumped over the lazy dog.')
	str.Replace('quick brown','fast green')
	AssertThat(str.Get(),IsEqualTo('The fast green fox jumped over the lazy dog.'))

	
	
	

  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
SplitString_DelmitersOnly_VerifyCountAndValues PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String
count	long

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('SplitString_DelmitersOnly_VerifyCountAndValues')
	str.Assign('; ; ;')
	str.Split(';')
	count = str.Records()
	AssertThat(count,IsEqualto(0),'Wrong number of lines from split')
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
SplitString_LeadingDelmiter_VerifyCountAndValues PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String
count	long

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('SplitString_LeadingDelmiter_VerifyCountAndValues')
	str.Assign('; a.k.a. ''ISYF''')
	str.Split(';')
	count = str.Records()
	AssertThat(count,IsEqualto(1),'Wrong number of lines from split')
	if count = 1
		AssertThat(str.GetLine(1),IsEqualTo(' a.k.a. ''ISYF'''),'Wrong value for line 1')
	end
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
SplitString_BugReport_IndexOutOfRange PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String
count	long

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('SplitString_BugReport_IndexOutOfRange')
    str.Assign('Loop SA (aka Rainstar Ltd.)')
	str.Split('(A.K.A.')
	count = str.Records()
	AssertThat(count,IsEqualto(1),'Wrong number of lines from split')
	if count = 1
		AssertThat(str.GetLine(1),IsEqualTo('Loop SA (aka Rainstar Ltd.)'),'Wrong value for line 1')
	end
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
SplitString_ReplaceOneLine_Verify PROCEDURE  (*long addr)  ! Declare Procedure
FilesOpened          LONG                                  !
str DCL_System_String
count	long

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('SplitString_ReplaceOneLine_Verify')
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
SplitString_ChangeOneLine_VerifyWhole PROCEDURE  (*long addr) ! Declare Procedure
FilesOpened          LONG                                  !
str                                         DCL_System_String
count                                       long

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('SplitString_ChangeOneLine_VerifyWhole')
	str.Assign('Hudsns By Co Ltd')
	str.Split(' ')
	count = str.Records()
	AssertThat(count,IsEqualto(4),'Wrong number of lines from split')
    if count = 4
        str.AssignToLine('Limited',4)
		AssertThat(str.GetAllLines(),IsEqualTo('Hudsns By Co Limited'))
        str.AssignToLine('Company',3)
        AssertThat(str.GetAllLines(),IsEqualTo('Hudsns By Company Limited'))
        str.AssignToLine('Bay',2)
        AssertThat(str.GetAllLines(),IsEqualTo('Hudsns Bay Company Limited'))
        str.AssignToLine('Hudsons',1)
        AssertThat(str.GetAllLines(),IsEqualTo('Hudsons Bay Company Limited'))
    end
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - GroupProcedure
!!! </summary>
CurrentTests         PROCEDURE                             ! Declare Procedure
FilesOpened          LONG                                  !

  CODE
