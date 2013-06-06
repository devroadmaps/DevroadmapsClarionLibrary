

   MEMBER('DCL_System_IO_AsciiFile_Tests.clw')             ! This is a MEMBER module

                     MAP
                       INCLUDE('DCL_SYSTEM_IO_ASCIIFILE_TESTS001.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Procedure not yet defined
!!! </summary>
Main PROCEDURE !Procedure not yet defined
  CODE
  GlobalErrors.ThrowMessage(Msg:ProcedureToDo,'Main')      ! This procedure acts as a place holder for a procedure yet to be defined
  SETKEYCODE(0)
  GlobalResponse = RequestCancelled                        ! Request cancelled is the implied action
