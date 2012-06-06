!-----------------------------------------------------------------------
! UltimateSQLString.inc - Include for SQL string processing class
!-----------------------------------------------------------------------
    OMIT('_EndOfInclude_', _UltimateSQLStringPresent_)  

    INCLUDE('UltimateString.inc'), ONCE
    INCLUDE('UltimateDB.inc'), ONCE

_UltimateSQLStringPresent_              EQUATE(1)   
                                    
us_Handle                               EQUATE(UNSIGNED)
us_Bool                                 EQUATE(SIGNED)    
us_GenericRead                          EQUATE(80000000h)
us_File_Share_Null                      EQUATE(0)     
us_File_Share_Read                      EQUATE(000000001h)
us_Open_Existing                        EQUATE(3)
us_File_Attribute_Normal                EQUATE(000000080h)
us_Invalid_Handle_Value                 EQUATE(-1) 

        

!-----------------------------------------------------------------------
! Class specification
!-----------------------------------------------------------------------
UltimateSQLString                       CLASS(UltimateString),TYPE,MODULE('UltimateSQLString.clw'),LINK('UltimateSQLString.clw')    !,_abcLinkMode_),DLL(_abcDllMode_)
!---------------------------------------
! Private and protected properties
!---------------------------------------
_Driver                                     LONG,PROTECTED            ! 0 = Sybase, 1 = MS SQL

!---------------------------------------
! Public methods
!---------------------------------------
AppendCat                                   PROCEDURE(<LONG pDriver>)
AssignBinary                                PROCEDURE(STRING pValue, <LONG pDriver>)
Quote                                       PROCEDURE(<LONG pDriver>)
Split                                       PROCEDURE()

Set_Driver                                  PROCEDURE(LONG pDriver)
Set_Driver                                  PROCEDURE(UltimateDB pDB)  

ReadFile                                    PROCEDURE(STRING pFilename),STRING
                                        END       

  _EndOfInclude_
