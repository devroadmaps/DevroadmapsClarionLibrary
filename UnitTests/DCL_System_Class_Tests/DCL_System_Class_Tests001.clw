

   MEMBER('DCL_System_Class_Tests.clw')                    ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_CLASS_TESTS001.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
ParseClassFile_VerifyClassName PROCEDURE  (*long addr)     ! Declare Procedure
parser                              DCL_System_ClassParser
cls                                 &DCL_System_Class
dbg                                 DCL_System_Diagnostics_Logger
TestFile                            cstring(500)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('ParseClassFile_VerifyClassName')
    TestFile = 'DCL_System_String.inc.test'
    if not EXISTS(TestFile)
        TestFile = 'DCL_System_Class_Tests\' & TestFile
        if not EXISTS(TestFile)
            SetUnitTestFailed('Could not find test file ' & TestFile)
            do ProcedureReturn
        end
    end
    
        
    parser.Parse(TestFile)
    AssertThat(parser.ClassCount(),IsEqualTo(1),'Wrong number of classes found')
    if parser.ClassCount() = 1
        cls &= parser.GetClass(1)
        if cls &= null
            SetUnitTestFailed('retrieved class instance is null')
        else
            AssertThat(cls.Name,IsEqualTo('DCL_SYSTEM_STRING'),'Wrong class name')
            cls.debug()
        end
    end
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
ParseClassFile_GetExports PROCEDURE  (*long addr)          ! Declare Procedure
parser                          DCL_System_ClassParser
cls                             &DCL_System_Class
dbg                             DCL_System_Diagnostics_Logger
ExportsQ                        queue
text                              cstring(500)
                                end
x                               long
TestFile                        cstring(500)

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('ParseClassFile_GetExports')
    TestFile = 'DCL_System_String.inc.test'
    if not EXISTS(TestFile)
        TestFile = 'DCL_System_Class_Tests\' & TestFile
        if not EXISTS(TestFile)
            SetUnitTestFailed('Could not find test file ' & TestFile)
            do ProcedureReturn
        end
    end
    
    parser.Parse(TestFile)
    
    AssertThat(parser.ClassCount(),IsEqualTo(1),'Wrong number of classes found')
    if parser.ClassCount() = 1
        cls &= parser.GetClass(1)
        if cls &= null
            SetUnitTestFailed('retrieved class instance is null')
        else
            AssertThat(cls.Name,IsEqualTo('DCL_SYSTEM_STRING'),'Wrong class name')
            cls.debug()
            cls.GetExports(ExportsQ,ExportsQ.text)
            AssertThat(records(ExportsQ),IsEqualTo(31))
            loop x = 1 to records(ExportsQ)
                get(ExportsQ,x)
                dbg.write(x & ' ' & ExportsQ.text)
            end
            get(ExportsQ,31)
            AssertThat(ErrorCode(),IsEqualTo(0),'Unexpected error getting record 31')
            AssertThat(ExportsQ.text,IsEqualTo('  TESTOFAPROCEDUREWITHAREALLYLONGMANGLEDNAME@F17DCL_SYSTEM_STRING47VERYLONGCLASSNAMEPURELYFORDEMONSTRATIONPURPOSES47VERYLONGCLASSNAMEPURELYFORDEMONSTRATIONPURPOSES @?'),'Wrong export value')
        end
    end
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
