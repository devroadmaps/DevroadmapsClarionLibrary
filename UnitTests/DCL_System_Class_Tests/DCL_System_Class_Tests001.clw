

   MEMBER('DCL_System_Class_Tests.clw')                    ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_CLASS_TESTS001.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - TestProcedure
!!! </summary>
ParseClassFile_VerifyClassName PROCEDURE  (*long addr)     ! Declare Procedure
parser                                 DCL_System_ClassParser
cls                                 &DCL_System_Class

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('ParseClassFile_VerifyClassName')
    parser.Parse('DCL_System_String.inc.test')
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
parser                                 DCL_System_ClassParser
cls                                 &DCL_System_Class
ExportsQ                        queue
text                              cstring(500)
                                end
x                               long

  CODE
  addr = address(UnitTestResult)
  BeginUnitTest('ParseClassFile_GetExports')
    parser.Parse('DCL_System_String.inc.test')
    AssertThat(parser.ClassCount(),IsEqualTo(1),'Wrong number of classes found')
    if parser.ClassCount() = 1
        cls &= parser.GetClass(1)
        if cls &= null
            SetUnitTestFailed('retrieved class instance is null')
        else
            AssertThat(cls.Name,IsEqualTo('DCL_SYSTEM_STRING'),'Wrong class name')
            cls.debug()
            cls.GetExports(ExportsQ)
            AssertThat(RECORDS(ExportsQ),IsNotEqualTo(0),'No export records found')
        end
    end
  DO ProcedureReturn ! dgh
ProcedureReturn   ROUTINE
  RETURN 0
