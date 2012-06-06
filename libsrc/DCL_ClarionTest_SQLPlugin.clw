!---------------------------------------------------------------------------------------------!
! Copyright (c) 2012, CoveComm Inc.
! All rights reserved.
! 
! 
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met: 
! 
! 1. Redistributions of source code must retain the above copyright notice, this
!    list of conditions and the following disclaimer. 
! 2. Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution. 
! 3. The use of this software in a paid-for programming toolkit (that is, a commercial 
!    product that is intended to assist in the process of writing software) is 
!    not permitted.
! 
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
! ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
! WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
! DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
! ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
! (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
! ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
! (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
! SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
! 
! The views and conclusions contained in the software and documentation are those
! of the authors and should not be interpreted as representing official policies, 
! either expressed or implied, of www.DevRoadmaps.com or www.ClarionMag.com.
! 
! If you find this software useful, please support its creation and maintenance
! by taking out a subscription to www.DevRoadmaps.com.
!---------------------------------------------------------------------------------------------!
	MEMBER()
	omit('***',_c55_)
_ABCDllMode_                    EQUATE(0)
_ABCLinkMode_                   EQUATE(1)
	***
!
!--------------------------
!ClarionLive Skeleton Class
!--------------------------

	INCLUDE('Equates.CLW')
	INCLUDE('DCL_ClarionTest_SQLPlugin.INC'),ONCE


								MAP
									
								END
!gdbg                DCL_System_Diagnostics_Logger
gOwnerName                      String(200)

ctQueryTable                    FILE,DRIVER('MSSQL'),OWNER(gOwnerName),PRE(ctQ),BINDABLE,THREAD,NAME('dbo.ctQueryTable'),Create
Record                              RECORD,PRE()
C01                                     CSTRING(256),NAME('ctQ_C01')
C02                                     CSTRING(256),NAME('ctQ_C02')
C03                                     CSTRING(256),NAME('ctQ_C03')
C04                                     CSTRING(256),NAME('ctQ_C04')
C05                                     CSTRING(256),NAME('ctQ_C05')
C06                                     CSTRING(256),NAME('ctQ_C06')
C07                                     CSTRING(256),NAME('ctQ_C07')
C08                                     CSTRING(256),NAME('ctQ_C08')
C09                                     CSTRING(256),NAME('ctQ_C09')
C10                                     CSTRING(256),NAME('ctQ_C10')
C11                                     CSTRING(256),NAME('ctQ_C11')
C12                                     CSTRING(256),NAME('ctQ_C12')
C13                                     CSTRING(256),NAME('ctQ_C13')
C14                                     CSTRING(256),NAME('ctQ_C14')
C15                                     CSTRING(256),NAME('ctQ_C15')
C16                                     CSTRING(256),NAME('ctQ_C16')
C17                                     CSTRING(256),NAME('ctQ_C17')
C18                                     CSTRING(256),NAME('ctQ_C18')
C19                                     CSTRING(256),NAME('ctQ_C19')
C20                                     CSTRING(256),NAME('ctQ_C20')
C21                                     CSTRING(256),NAME('ctQ_C21')
C22                                     CSTRING(256),NAME('ctQ_C22')
C23                                     CSTRING(256),NAME('ctQ_C23')
C24                                     CSTRING(256),NAME('ctQ_C24')
									END
								END

!-----------------------------------
DCL_ClarionTest_SQLPlugin.Init    PROCEDURE(String pOwnerName)                   
szSQL                               CSTRING(501)
	code	 
	gOwnerName = pOwnerName

!-----------------------------------
DCL_ClarionTest_SQLPlugin.Kill    PROCEDURE()
!-----------------------------------

	CODE
	
	ctQueryTable{PROP:Disconnect}
	
	RETURN

!-----------------------------------------
DCL_ClarionTest_SQLPlugin.DCL_SQLQuery       FUNCTION (INP:Query, OUT:RQ, OUT:C01, OUT:C02, OUT:C03,OUT:C04, OUT:C05, OUT:C06, OUT:C07, OUT:C08, OUT:C09, OUT:C10, OUT:C11,OUT:C12, OUT:C13, OUT:C14, OUT:C15, OUT:C16, OUT:C17, OUT:C18, OUT:C19,OUT:C20, OUT:C21, OUT:C22, OUT:C23, OUT:C24) ! Declare Procedure
		
QueryView                                   VIEW(ctQueryTable)
												PROJECT(C01)
												PROJECT(C02)
												PROJECT(C03)
												PROJECT(C04)
												PROJECT(C05)
												PROJECT(C06)
												PROJECT(C07)
												PROJECT(C08)
												PROJECT(C09)
												PROJECT(C10)
												PROJECT(C11)
												PROJECT(C12)
												PROJECT(C13)
												PROJECT(C14)
												PROJECT(C15)
												PROJECT(C16)
												PROJECT(C17)
												PROJECT(C18)
												PROJECT(C19)
												PROJECT(C20)
												PROJECT(C21)
												PROJECT(C22)
												PROJECT(C23)
												PROJECT(C24)
											END

ctQueryTable::Used                                  BYTE(0)

ExecOK                                              BYTE(0)
ResultQ                                             &QUEUE
Recs                                                ULONG(0)

QString                                             CSTRING(LEN(INP:Query)+1)  !8192)   ! 8K Limit ???  !MG

NoRetVal                                            BYTE(0)         ! NO Return Values (True/False)
BindVars                                            BYTE(0)         ! Binded Variables Exist (True/False)
BindVarQ                                            QUEUE           ! Binded Variables
No                                                      BYTE          ! No
Name                                                    STRING(18)    ! Name
													END
	CODE                                                     ! Begin processed code
	PUSHBIND
	ExecOK = False
	
	FREE(BindVarQ) ; BindVars = False ; NoRetVal = False

	IF (OMITTED(OUT:RQ) AND OMITTED(OUT:C01) AND OMITTED(OUT:C02)) THEN NoRetVal = True.
	IF NOT OMITTED(OUT:RQ) THEN ResultQ &= OUT:RQ END
	IF INP:Query = ''
		BEEP ; ! MESSAGE('Missing Query Statement')
	ELSE
		IF INSTRING('CALL ',UPPER(INP:Query),1,1)  
			QString = CLIP(INP:Query)
			S# = 0 ;  L# = LEN(CLIP(QString))
			LOOP C# = 1 TO L#
				IF S# AND INLIST(QString[C#],',',' ',')') 
					BindVarQ.No   = RECORDS(BindVarQ) + 1
					BindVarQ.Name = QString[(S#+1) : (C#-1)]
					IF NOT OMITTED(3+BindVarQ.No)   
						EXECUTE BindVarQ.No
							BIND(CLIP(BindVarQ.Name),OUT:C01)
							BIND(CLIP(BindVarQ.Name),OUT:C02)
							BIND(CLIP(BindVarQ.Name),OUT:C03)
							BIND(CLIP(BindVarQ.Name),OUT:C04)
							BIND(CLIP(BindVarQ.Name),OUT:C05)
							BIND(CLIP(BindVarQ.Name),OUT:C06)
							BIND(CLIP(BindVarQ.Name),OUT:C07)
							BIND(CLIP(BindVarQ.Name),OUT:C08)
							BIND(CLIP(BindVarQ.Name),OUT:C09)
							BIND(CLIP(BindVarQ.Name),OUT:C10)
							BIND(CLIP(BindVarQ.Name),OUT:C11)
							BIND(CLIP(BindVarQ.Name),OUT:C12)
							BIND(CLIP(BindVarQ.Name),OUT:C13)
							BIND(CLIP(BindVarQ.Name),OUT:C14)
							BIND(CLIP(BindVarQ.Name),OUT:C15)
							BIND(CLIP(BindVarQ.Name),OUT:C16)
							BIND(CLIP(BindVarQ.Name),OUT:C17)
							BIND(CLIP(BindVarQ.Name),OUT:C18)
							BIND(CLIP(BindVarQ.Name),OUT:C19)
							BIND(CLIP(BindVarQ.Name),OUT:C20)
							BIND(CLIP(BindVarQ.Name),OUT:C21)
							BIND(CLIP(BindVarQ.Name),OUT:C22)
							BIND(CLIP(BindVarQ.Name),OUT:C23)
							BIND(CLIP(BindVarQ.Name),OUT:C24)
						END
					END

					ADD(BindVarQ,+BindVarQ.No)
					IF ERRORCODE()
						BEEP 
						BREAK
					END
					S# = 0
				END
				IF QString[C#] = '&'                      
					IF S#
						BEEP
						BREAK
					ELSE
						S# = C#
					END
				END
			END

			BindVars = RECORDS(BindVarQ)
		END
         
		Open(ctQueryTable )	
		IF ERROR()
			CREATE(ctQueryTable)
			OPEN(ctQueryTable)
		END
		IF ERRORCODE()
			ExecOK = ExecOK
		ELSE
			OPEN(QueryView)
			IF ERRORCODE() = 90
				IF FILEERRORCODE()
					MESSAGE('Error : ' & ERROR() & ' [' & ERRORCODE() &|
							']|' & 'File Error : ' & FILEERROR() &|
							' [' & FILEERRORCODE() & ']','OPEN VIEW')
				END
			ELSIF ERRORCODE()
				MESSAGE('Error : ' & ERROR() & ' [' & ERRORCODE() &|
						']|' & 'File : ' & ERRORFILE(),'OPEN VIEW')
			ELSE
				QueryView{PROP:SQL} = CLIP(INP:Query)
				ErrCode# = ERRORCODE()
				IF ERRORCODE() = 90 AND FILEERRORCODE() = 37000
					ErrCode# = 0
				END
				IF ErrCode# = 90
					 
				ELSIF ErrCode#

				ELSE
					IF BindVars OR NoRetVal
						ExecOK = True
					ELSE
						Recs = 0
						LOOP
							NEXT(QueryView)   ! Retrieve Records
							Recs += 1
							IF NOT ERRORCODE()
								ExecOK = True
								IF NOT OMITTED(OUT:RQ) THEN CLEAR(ResultQ). ! Clear Result Queue Buffer
								IF NOT OMITTED(4)  THEN OUT:C01 = ctQ:C01.
								IF NOT OMITTED(5)  THEN OUT:C02 = ctQ:C02.
								IF NOT OMITTED(6)  THEN OUT:C03 = ctQ:C03.
								IF NOT OMITTED(7)  THEN OUT:C04 = ctQ:C04.
								IF NOT OMITTED(8)  THEN OUT:C05 = ctQ:C05.
								IF NOT OMITTED(9)  THEN OUT:C06 = ctQ:C06.
								IF NOT OMITTED(10)  THEN OUT:C07 = ctQ:C07.
								IF NOT OMITTED(11) THEN OUT:C08 = ctQ:C08.
								IF NOT OMITTED(12) THEN OUT:C09 = ctQ:C09.
								IF NOT OMITTED(13) THEN OUT:C10 = ctQ:C10.
								IF NOT OMITTED(14) THEN OUT:C11 = ctQ:C11.
								IF NOT OMITTED(15) THEN OUT:C12 = ctQ:C12.
								IF NOT OMITTED(16) THEN OUT:C13 = ctQ:C13.
								IF NOT OMITTED(17) THEN OUT:C14 = ctQ:C14.
								IF NOT OMITTED(18) THEN OUT:C15 = ctQ:C15.
								IF NOT OMITTED(19) THEN OUT:C16 = ctQ:C16.
								IF NOT OMITTED(20) THEN OUT:C17 = ctQ:C17.
								IF NOT OMITTED(21) THEN OUT:C18 = ctQ:C18.
								IF NOT OMITTED(22) THEN OUT:C19 = ctQ:C19.
								IF NOT OMITTED(23) THEN OUT:C20 = ctQ:C20.
								IF NOT OMITTED(24) THEN OUT:C21 = ctQ:C21.
								IF NOT OMITTED(25) THEN OUT:C22 = ctQ:C22.
								IF NOT OMITTED(26) THEN OUT:C23 = ctQ:C23.
								IF NOT OMITTED(27) THEN OUT:C24 = ctQ:C24.

								IF NOT OMITTED(OUT:RQ) ! Result Queue
									ADD(ResultQ)

								END
							ELSE
								IF OMITTED(OUT:RQ) ! NO Result Queue
									IF ERRORCODE() <> 33
										IF ERRORCODE() = 90
											CASE FILEERRORCODE()
											OF ''          
												! Ignore NO File Error
											OF '24000'     
												! Ignore Cursor State Error - 
												! Statement Executes BUT Error Returned
											OF 'S1010'     
												! Ignore Function Sequencing Error - 
												! Statement Executes BUT Error Returned
											ELSE
											END
										ELSE
										END
									END
								ELSE
									BREAK
								END
							END
							IF OMITTED(OUT:RQ) THEN BREAK. ! NO Result Queue
						END
					END
				END
			END
		END 
	END 
	CLOSE(QueryView)
	CLOSE(ctQueryTable)

	IF BindVars
		LOOP C# = 1 TO BindVars
			GET(BindVarQ, C#)
			IF BindVarQ.Name THEN UNBIND(CLIP(BindVarQ.Name)).   ! Use pushbind popbind??
		END
	END

	FREE(BindVarQ)

	POPBIND
	RETURN ExecOK		

	
!---------------------------------------------------------	
DCL_ClarionTest_SQLPlugin.DCL_RestoreDatabase                 PROCEDURE(STRING pOriginalDataBase,STRING pNewDataBase)  !,BYTE
!---------------------------------------------------------
l:SQLText                                       CString(10000)
l:DataPath                                      CString(200)
l:NewDataName                                   CString(200)
l:OldDataName                                   CString(200)
l:BAKFile                                       CString(200)
rQ                                              Queue
rQname                                              CString(100)
												END
l:Clock                                         LONG

	CODE    
	 
	l:SQLText = ''
	 
	self.DCL_SQLQuery('IF exists(select * from sys.databases where name = <39>' & CLIP(pNewDataBase) & '<39>) drop database ' & CLIP(pNewDataBase)) 
	self.DCL_SQLQuery('SELECT dbo.prm_GetSQLDataPath() as DataPath',,l:DataPath)
	
	FREE(rQ)
	self.DCL_SQLQuery('Restore Filelistonly FROM DISK = <39>' & CLIP(pOriginalDataBase) & '<39>',rQ,rQ.rQName)
	 
	GET(rQ,1)
	
	l:Clock = CLOCK() 	 
	
	l:SQLText = l:SQLText & 'RESTORE DATABASE ' & CLIP(pNewDataBase) & ' FROM DISK = <39>' & clip(pOriginalDataBase) & '<39>'
	l:SQLText = l:SQLText & ' WITH MOVE <39>' & rQ.rQName & '<39> TO <39>' & l:DataPath & '\' & rQ.rQName &  l:Clock & '.mdf<39>,'
	l:SQLText = l:SQLText & ' MOVE <39>' & rQ.rQName & '_log<39> TO <39>' & l:DataPath & '\' & rQ.rQName & l:Clock & '_log.ldf<39>'
	
	setclipboard(l:sqltext)
	
	self.DCL_SQLQuery(CLIP(l:SQLText))	
	
	Return 0
!---------------------------------------------------------
DCL_ClarionTest_SQLPlugin.RaiseError             PROCEDURE(STRING pErrorMsg)
!---------------------------------------------------------

	CODE

	IF SELF.InDebug = TRUE
		BEEP(BEEP:SystemExclamation)
		MESSAGE(CLIP(pErrorMsg), 'ClarionLive Error', ICON:EXCLAMATION)
	END

	RETURN

		
!-----------------------------------------------------------------------
!.Construct - This procedure is recommended
!-----------------------------------------------------------------------
!----------------------------------------
DCL_ClarionTest_SQLPlugin.Construct              PROCEDURE()
!----------------------------------------
	CODE

	RETURN

		
!-----------------------------------------------------------------------
!.Destruct - This procedure is recommended
!-----------------------------------------------------------------------
!---------------------------------------
DCL_ClarionTest_SQLPlugin.Destruct               PROCEDURE()
!---------------------------------------
	CODE

	RETURN
		
!---------------------------------------
DCL_ClarionTest_SQLPlugin.DCL_ExecuteScript        PROCEDURE(STRING pFileName)  !,BYTE
!---------------------------------------
l:SQLText                                           STRING(3000000)
DosFile                                             FILE,DRIVER('ASCII','/QUICKSCAN = ON'),PRE(FIL),CREATE   ! DOS file structure
Record                                                  RECORD                            !
FileLine                                                    STRING(30000)                     !
															. .
r:FileName                                              String(220)
r:Index                                                 BYTE(0)

	CODE	
	DosFile{PROP:Name} = pFileName
	OPEN(DosFIle)
	IF ERROR()
		RETURN False
	END
	OPEN(DosFIle)
	SET(DosFile)
	LOOP
		NEXT(DosFile)
		IF ERROR();Break.
		IF UPPER(FIL:FileLine) = 'GO'
			IF l:SQLText <> ''
				X# = self.DCL_SQLQuery(CLIP(l:SQLText))
			END
			l:SQLText = ''
			CYCLE
		END
		l:SQLText = CLIP(l:SQLText) & CLIP(FIL:FileLine) & '<13,10>'
	END
	CLOSE(DosFile)
	IF l:SQLText <> ''
		X# = self.DCL_SQLQuery(CLIP(l:SQLText))
	END

	CLOSE(DosFile)
	IF l:SQLText <> ''
		X# = self.DCL_SQLQuery(CLIP(l:SQLText))
	END	
	RETURN True
!----------------------------------------------------------------------- 
! NOTES:
! Construct procedure executes automatically at the beginning of each procedure 
! Destruct procedure executes automatically at the end of each procedure
! Construct/Destruct Procedures are implicit under the hood but don't have to be declared in the class as such if there is no need.   
! It's ok to have them there for good measure, although some programmers only include them as needed.
! Normally some prefer Init() and Kill(),  but Destruct() can be handy to DISPOSE of stuff (to avoid mem leak)
!-----------------------------------------------------------------------
