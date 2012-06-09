OMIT('_EndOfInclude_',IFDef_UltimateSQLScripts)
IFDef_UltimateSQLScripts EQUATE(1)

!-----------------------------------------------------------------------
!Purpose        : Returns SQL Scripts with tokens that can be replaced and then run in the Ultimate SQL Class
!Usage          :
!Created        : By John Hickey, 5/7/2012
!Updates        :
!Assumptions    :
!Known Bugs     :
!Future Features:
!-----------------------------------------------------------------------

!
!--------------------------
!ClarionLive Skeleton Class
!--------------------------

!
UltimateSQLScripts  CLASS,TYPE,MODULE('UltimateSQLScripts.CLW'),LINK('UltimateSQLScripts.CLW')  !,_ABCLinkMode_),DLL(_ABCDllMode_)
!
!Properties
!----------
InDebug             BYTE
!
!Methods
!-------
Construct               PROCEDURE()
Destruct                PROCEDURE()
Init                    PROCEDURE()
Kill                    PROCEDURE()
InsertExtendedProperty  PROCEDURE(),STRING
UpdateExtendedProperty  PROCEDURE(),STRING
RemoveExtendedProperty  PROCEDURE(),STRING 
GetExtendedProperty     PROCEDURE(),STRING 
DropAllDependencies     PROCEDURE(),STRING    
CreateQueryTable        PROCEDURE(),STRING
RaiseError          PROCEDURE(STRING pErrorMsg)
               END


 !END-OMIT('_EndOfInclude_',IFDef_UltimateSQLScripts)



!-----------------------------------------------------------------------
 OMIT('Instructions on how to use this ClarionLive Skeleton')
!-----------------------------------------------------------------------
!  Search and Replace:  [Family] [YourFamily]
!                          set project defines for YourFamily (automatically done for properly templated classes)
!                           _YourFamilyLinkMode_=>1
!                           _YourFamilyDllMode_=>0
!                           or
!                           _YourFamilyLinkMode_=>0
!                           _YourFamilyDllMode_=>1
!                          You`ll use the first set, unless this class was in a DLL and was exported
!                          If you`re only doing single EXE work, you could just rem the conditional LINK/DLLL
!                             UltimateSQLScripts  CLASS,TYPE,MODULE('UltimateSQLScripts.CLW'),LINK('UltimateSQLScripts.CLW',_FamilyLinkMode_),DLL(_FamilyDllMode_)
!                             becomes
!                             UltimateSQLScripts  CLASS,TYPE,MODULE('UltimateSQLScripts.CLW'),LINK('UltimateSQLScripts.CLW') ! ,_FamilyLinkMode_),DLL(_FamilyDllMode_)
!
!
!  Search and Replace:  [UltimateSQLScripts] [ctYourClass]
!  Save This files as:  [ctYourClass.inc]
!
!  Make Changes to   :  [CLiveSkeleton.clw]
!  Change the INCLUDE:  [INCLUDE('UltimateSQLScripts.INC')] [INCLUDE('ctYourClass.INC')]
!  Save as              [ctYourClass.clw]
!
!  IF your class needs to access your global scope
!     THEN replace [MEMBER()] with [MEMBER('YourExe')]
!  NOTE: this will tie this class to that one EXE/DLL
!
!-----------------------------------------------------------------------
! END-OMIT('Instructions on how to use this ClarionLive Skeleton')
!-----------------------------------------------------------------------



!-----------------------------------------------------------------------
   OMIT('Internal Documentation')
!-----------------------------------------------------------------------
! This Document:
! Downloaded from ClarionLive.com - Live! Open Class project
! Created by: ___??___
! Updates   : Dec/30/2010 Mark.Goldberg - reformatted, added Instructions
!                                       - added the QUEUE work, as an example of how to add a QUEUE,TYPE to a class
!
!-----------------------------------------------------------------------
!-END OMIT('Internal Documentation')
!-----------------------------------------------------------------------
