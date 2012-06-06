!Category(tpr)
!-----------------------------------------------------------------------
! UltimateDB.inc - Include for table class
!-----------------------------------------------------------------------
  OMIT('_EndOfInclude', _UltimateDBPresent_)
_UltimateDBPresent_      EQUATE(1)

!-----------------------------------------------------------------------
! Miscellaneous definitions required by class
!-----------------------------------------------------------------------
roList              QUEUE, TYPE                 ! List of readonly fields
Fieldname             CSTRING(129)
                    END
!
!-----------------------------------------------------------------------
! Class specification
!-----------------------------------------------------------------------
UltimateDB               CLASS,MODULE('UltimateDB.clw'),TYPE,LINK('UltimateDB.clw')
!---------------------------------------
! Private and protected properties
!---------------------------------------
roQ                   &roList, PRIVATE          ! Queue of readonly fields
CallError             BYTE, PRIVATE             ! T = SQLCall or SQLCallReturn error was encountered

Error                 CSTRING(500),PROTECTED    ! Error message
_Column               LONG, PROTECTED           ! [1] Column to be returned
_ColumnName           CSTRING(81), PROTECTED    ! [] Name of column to be returned, blank = use number
_ConnectionString     CSTRING(512),PROTECTED    ! Full connection string
_Driver               LONG,PROTECTED            ! 0 = Sybase, 1 = MS SQL
_Length               LONG,PROTECTED            ! 0 = All of text, nn = Limit return text to nn characters
_Replace              BYTE,PROTECTED            ! [F]=Replace cr/lf with '..', T=Do replace
_Separator            CSTRING(11), PROTECTED    ! [<cr/lf>] = Separator between lines, multiline return

!---------------------------------------
! Public properties
!---------------------------------------
ColNames              BYTE                      ! T=Use column names, [F]=Use *

!---------------------------------------
! Virtual methods
!---------------------------------------
Set_ConnectionString  PROCEDURE(STRING pConnectionString, <LONG pDriver>), VIRTUAL
Set_Driver            PROCEDURE(LONG pDriver=0), VIRTUAL

!---------------------------------------
! Public methods
!---------------------------------------
AddReadOnly                     PROCEDURE(<STRING pFieldname>)
Construct                       PROCEDURE()
Destruct                        PROCEDURE()
FieldBind                       PROCEDURE(*FILE pTbl, LONG pInstance=1)
FieldFind                       PROCEDURE(*FILE pTbl, STRING pField), LONG
FieldUnbind                     PROCEDURE(*FILE pTbl, LONG pInstance=1)
FindPK                          PROCEDURE(*FILE pTbl), LONG
FormatColData                   PROCEDURE(*FILE pTbl, LONG pInstance, <LONG pDriver>), STRING
FormatColName                   PROCEDURE(*FILE pTbl, LONG pInstance, BYTE pTblName=True), STRING
FormatColNames                  PROCEDURE(*FILE pTbl, LONG pPKey=0, BYTE pTblName=True), STRING
GetError                        PROCEDURE(), STRING
GetKey                          PROCEDURE(*FILE pTbl, STRING pKey), *KEY
Get_ColName                     PROCEDURE(*FILE pTbl, LONG pInstance), STRING 
GetColData                      PROCEDURE(*FILE pTbl, LONG pInstance, <LONG pDriver>), STRING
Get_Driver                      PROCEDURE(), LONG
Get_ConnectionString            PROCEDURE(), STRING
IsReadOnly                      PROCEDURE(*FILE pTbl, LONG pInstance), BYTE  
Quote                           PROCEDURE(STRING pText), STRING
SQLBuildFetchChildren           PROCEDURE(*KEY pKey, <STRING pSelect>), STRING
SQLBuildOrderChildren           PROCEDURE(*KEY pKey, BYTE pReverse=False), STRING

SQLDelete                       PROCEDURE(*FILE pTbl), BYTE, PROC
SQLFetch                        PROCEDURE(*KEY pKey, <STRING pSelect>), BYTE, PROC
SQLFetchChildren                PROCEDURE(*KEY pKey, <STRING pSelect>, BYTE pReverse=False)
SQLHaveChildren                 PROCEDURE(*KEY pKey, <STRING pSelect>), BYTE
SQLInsert                       PROCEDURE(*FILE pTbl, BYTE pIncludePK=False), STRING, PROC
SQLList                         PROCEDURE(*KEY pKey, <STRING pSelect>, BYTE pReverse=False)
SQLLog                          PROCEDURE(*FILE pTbl, <STRING pLogfile>)
SQLReverseChildren              PROCEDURE(*KEY pKey, <STRING pSelect>)
SQLUpdate                       PROCEDURE(*FILE pTbl), BYTE, PROC

!---------------------------------------
! Private and protected methods
!---------------------------------------
                    END

_EndOfInclude_