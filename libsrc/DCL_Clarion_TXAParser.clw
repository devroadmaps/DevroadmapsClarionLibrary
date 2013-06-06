!---------------------------------------------------------------------------------------------!
! Copyright (c) 2012, CoveComm Inc.
! All rights reserved.
!---------------------------------------------------------------------------------------------!
!region
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
!endregion

										Member
										Map
										End



	Include('DCL_Clarion_TXAParser.inc'),Once
	include('DCL_System_Diagnostics_Logger.inc'),once
	INCLUDE('DCL_System_IO_AsciiFile.inc'),ONCE
	include('DCL_System_String.inc'),once
	include('DCL_System_StringUtility.inc'),once

StringUtility                           DCL_System_StringUtility
dbg                                     DCL_System_Diagnostics_Logger

DCL_Clarion_TXAParser.Construct     Procedure()
	code
	self.Errors &= new DCL_System_ErrorManager


DCL_Clarion_TXAParser.Destruct      Procedure()
	code
	dispose(self.Errors)
	
                        
DCL_Clarion_TXAParser.AddNewProcedure   procedure(string procname)
	code
	!dbg.write('AddNewProcedure receives ' & procname)
	self.ProcedureQ.ProcedureName = procname
	get(self.ProcedureQ,self.ProcedureQ.ProcedureName)
	if errorcode()
		self.ProcedureQ.ProcedureName = procname
		!dbg.write('Procedure name: ' & self.ProcedureQ.ProcedureName)
		self.ProcedureQ.EmbedQ &= new DCL_Clarion_TXAParser_EmbedQueue
		add(self.ProcedureQ,self.ProcedureQ.ProcedureName)
		!dbg.write('AddNewProcedure added procedure ' & procname)
	ELSE
		!dbg.write('Found existing ProcedureQ record for ' & procName)
	end        

DCL_Clarion_TXAParser.AddNewEmbed       procedure(string embed,string embedparam1,string embedparam2,string embedparam3,string embedpriority)
s                                           cstring(500)
	code
	s = clip(embed)
	s = choose(clip(embedparam1) = '',s,s & ' ' & clip(embedparam1))
	s = choose(embedparam2 = '',s,s & ' ' & clip(embedparam2))
	s = choose(embedparam3 = '',s,s & ' ' & clip(embedparam3))
	s = choose(embedpriority = '',s,s & ' ' & clip(embedpriority))
	self.ProcedureQ.embedq.embedname = s
	self.ProcedureQ.embedq.EmbedLinesQ &= new DCL_Clarion_TXAParser_EmbedLinesQueue
	!dbg.write('AddNewEmbed adding ' & s)
	add(self.ProcedureQ.EmbedQ)
    
    

DCL_Clarion_TXAParser.CheckForMissedEmbed       procedure(string s,long lineno,long state)    
	CODE
	if sub(s,1,8) = '[SOURCE]'
		!dbg.write('*** MISSED EMBED at line ' & lineno & ', state ' &  state & ' ***')
	end		


DCL_Clarion_TXAParser.GetEmbedCount     procedure!,long
x                                           LONG
y                                           long
z                                           long
Count                                       long
	CODE
	if self.ProcedureQ &= null then  return 0.
	loop x = 1 to records(self.ProcedureQ)
		get(self.ProcedureQ,x)
		!dbg.write('** Procedure: ' & self.ProcedureQ.ProcedureName)
		Count += records(self.ProcedureQ.EmbedQ)
		loop y = 1 to records(self.ProcedureQ.EmbedQ)
			get(self.ProcedureQ.EmbedQ,y)
			!dbg.write('* Embed: ' & self.ProcedureQ.EmbedQ.embedname)
			!dbg.write('------------------------------------------------------------------------------------------')
			loop z = 1 to records(self.ProcedureQ.EmbedQ.EmbedLinesQ)
				get(self.ProcedureQ.EmbedQ.EmbedLinesQ,z)
				!dbg.write(z & ' ' & self.ProcedureQ.EmbedQ.EmbedLinesQ.line)
			END
			!dbg.write('------------------------------------------------------------------------------------------')
		END
	END
	return Count
	
DCL_Clarion_TXAParser.GetFormattedEmbedData     procedure(*Queue q,*cstring qField)
x                                           LONG
y                                           long
z                                           long
Count                                       long
str                                         DCL_System_String
	CODE
	free(q)
	if self.ProcedureQ &= null then return.
	loop x = 1 to records(self.ProcedureQ)
		get(self.ProcedureQ,x)
		if x > 1 then do AddBlankLine.
		qField = 'PROCEDURE: ' & self.ProcedureQ.ProcedureName
		add(q)
		Count += records(self.ProcedureQ.EmbedQ)
		loop y = 1 to records(self.ProcedureQ.EmbedQ)
			get(self.ProcedureQ.EmbedQ,y)
			do AddBlankLine
			qField = '  EMBED: ' & clip(self.ProcedureQ.EmbedQ.embedname)
			add(q)
			do AddBlankLine
			loop z = 1 to records(self.ProcedureQ.EmbedQ.EmbedLinesQ)
				get(self.ProcedureQ.EmbedQ.EmbedLinesQ,z)
				StringUtility.ReplaceSingleQuoteWithTilde(self.ProcedureQ.EmbedQ.EmbedLinesQ.line)
				qField = '    ' & clip(self.ProcedureQ.EmbedQ.EmbedLinesQ.line)
				add(q)
			END
		END
	END
	
AddBlankLine                            routine
	clear(qField)
	add(q)

DCL_Clarion_TXAParser.GetRawEmbedData        procedure(*Queue q,*cstring qField)
x                                           LONG
y                                           long
z                                           long
Count                                       long
str                                         DCL_System_String
	CODE
	free(q)
	if self.ProcedureQ &= null then return.
	loop x = 1 to records(self.ProcedureQ)
		get(self.ProcedureQ,x)
		qField = self.ProcedureQ.ProcedureName
		add(q)
		Count += records(self.ProcedureQ.EmbedQ)
		loop y = 1 to records(self.ProcedureQ.EmbedQ)
			get(self.ProcedureQ.EmbedQ,y)
			qField = clip(self.ProcedureQ.EmbedQ.embedname)
			add(q)
			loop z = 1 to records(self.ProcedureQ.EmbedQ.EmbedLinesQ)
				get(self.ProcedureQ.EmbedQ.EmbedLinesQ,z)
				StringUtility.ReplaceSingleQuoteWithTilde(self.ProcedureQ.EmbedQ.EmbedLinesQ.line)
				qField = clip(self.ProcedureQ.EmbedQ.EmbedLinesQ.line)
				add(q)
			END
		END
	END


	
DCL_Clarion_TXAParser.GetProcedureCount procedure!,long
	CODE
	if self.ProcedureQ &= null then  return 0.
	return records(self.ProcedureQ)


	
DCL_Clarion_TXAParser.Parse PROCEDURE(string filename)
AsciiText                                   cstring(1000)
vars                                        group,pre()
procname                                        string(200)
procFromABC                                     string(60)
procCategory                                    string(60)
embedname                                       string(60)
embedPriority                                   long
embedParam1                                     string(200)
embedParam2                                     string(200)
embedParam3                                     string(200)
whenLevel                                       byte
											end
dumptrace                                   byte(0)
LastProcName                                like(procname)
lastEmbedName                               string(500)
currembedname                               string(500)
state                                       long
prevstate                                   LONG
lineno                                      LONG
x                                           LONG
y                                           LONG
z                                           long
found                                       Byte

TxaFile                                     DCL_System_IO_AsciiFile
	code
	!TxaFile &= DCL_System_IO_AsciiFileManager.GetAsciiFileInstance(DCL_System_IO_AsciiFile_InstanceNumber1)
	self.Reset()
	if self.ProcedureQ &= null
		self.ProcedureQ &= new DCL_Clarion_TXAParser_ProcedureQueue
	end
	!dbg.write('Opening ' & filename)
	IF TxaFile.OpenFile(filename) ~= LEVEL:Benign
		!dbg.write('Error opening ' & filename & ' ' & error())
		self.Errors.AddError(-1,'Unable to open ' & clip(filename) & '; ' & Errorcode() & ' - ' & Error())
		return FALSE
		
	END
	!dbg.write('success opening txa file')
	lineno = 0
	state = 0
	prevstate = 0
	clear(procname)
	clear(lastprocname)
	clear(lastembedname)
	clear(currembedname)
	self.AddNewProcedure('Global')
	LOOP WHILE TxaFile.Read(AsciiText) = LEVEL:Benign
        
		lineNo += 1
		if state <> prevstate
			!dbg.write('state change from ' & prevstate & ' to ' & state & ' at line ' & lineno)
			prevstate = state
		end
		!dbg.write('line ' & lineno & ', state ' & state)

		!   if dumptrace
		!            if sub(AsciiText,1,5) = '[END]'
		!               state = state - 1
		!            elsif sub(AsciiText,1,1) = '[' and sub(AsciiText,1,6) <> '[DEFIN' 
		!               state = state + 1
		!            end
		!            if sub(AsciiText,1,8) = '[SOURCE]'
		!               !dbg.write(all(' ',state*2) & clip(AsciiText) & ' **************************************** ')
		!            else
		!               !dbg.write(all(' ',state*2) & AsciiText)
		!            end
		!
		!   else ! if not dumptrace

 
		!dbg.write('<-- state ' & state & ' -- ' & AsciiText)
		CASE state
		OF 0 ! search for the start of a module or procedure, or an embed
			if sub(AsciiText,1,11) = '[PROCEDURE]'
				! Clear procedure/embed names
				clear(vars)
				state = 10
			elsif sub(AsciiText,1,8) = '[MODULE]'
				! New module, so clear the vars and set the proc name to [module]
				clear(vars)
				procName = '[MODULE]'
			elsif sub(AsciiText,1,7) = 'EMBED %'
				embedName = sub(AsciiText,7,len(AsciiText))
				state = 30
			elsif sub(AsciiText,1,8) = '[SOURCE]'
				!dbg.write('MISSED EMBED at line ' & lineNo & ' - ' & AsciiText)
				state = 50

			end
		OF 10 ! get procedure name details
			if sub(AsciiText,1,4) = 'NAME'
				procName = sub(AsciiText,6,len(AsciiText))
				!dbg.write('found procedure named: ' & procname)
				state = 11
			end
			self.CheckForMissedEmbed(AsciiText,lineno,state)
		OF 11
			if sub(AsciiText,1,8) = 'FROM ABC'
				procFromABC = sub(AsciiText,10,len(AsciiText))
				!dbg.write('found procedure template: ' & procFromABC)
				state = 12
			end
			self.CheckForMissedEmbed(AsciiText,lineno,state)
		OF 12
			if sub(AsciiText,1,8) = 'CATEGORY'
				procCategory = sub(AsciiText,11,len(clip(AsciiText))-11)
				!dbg.write('found procedure type: ' & procCategory)
			end
			! Category is optional but if there will always follow FROM ABC
			! - go automatically back to state 0
			state = 0
			self.CheckForMissedEmbed(AsciiText,lineno,state)

		of 30 ! Look for a first embed parameter 
			if sub(AsciiText,1,11) = '[INSTANCES]'
				state = 41
			elsif sub(AsciiText,1,8) = '[SOURCE]'
				state = 50
				!dbg.write('start of embed')
			end

		of 41 ! Get first parameter
			if sub(AsciiText,1,6) = 'WHEN '''
				embedParam1 = sub(AsciiText,7,len(clip(AsciiText))-7)
				WhenLevel = 1
				!dbg.write('whenlevel=' & whenlevel)
			end
			state = 42
			self.CheckForMissedEmbed(AsciiText,lineno,state)

		of 42 ! Look for a second embed parameter
			if sub(AsciiText,1,11) = '[INSTANCES]'
				state = 43
			elsif sub(AsciiText,1,8) = '[SOURCE]'
				state = 50
				!dbg.write('found PRIORITY')
			elsif sub(AsciiText,1,11) = '[PROCEDURE]'
				! Clear procedure/embed names
				clear(vars)
				state = 10
			end

		of 43 ! Get second parameter
			if sub(AsciiText,1,6) = 'WHEN '''
				embedParam2 = sub(AsciiText,7,len(clip(AsciiText))-7)
				WhenLevel = 2
				!dbg.write('whenlevel=' & whenlevel)
			end
			state = 44
			self.CheckForMissedEmbed(AsciiText,lineno,state)

		of 44 ! Look for a third embed parameter
			if sub(AsciiText,1,11) = '[INSTANCES]'
				state = 45
			elsif sub(AsciiText,1,8) = '[SOURCE]'
				state = 50
				!dbg.write('found PRIORITY')
			end

		of 45 ! Get third parameter
			if sub(AsciiText,1,6) = 'WHEN '''
				embedParam3 = sub(AsciiText,7,len(clip(AsciiText))-7)
				WhenLevel = 3
				!dbg.write('whenlevel=' & whenlevel)
                
			end
			state = 50
			self.CheckForMissedEmbed(AsciiText,lineno,state)


		of 50  ! look for the priority
			if sub(AsciiText,1,8) = 'PRIORITY'
				embedPriority = sub(AsciiText,10,len(AsciiText))
				if lastprocname <> procname
					self.AddNewProcedure(procname)
				end
				! Add the embed record
				!dbg.write('Adding embed at line no ' & lineno)
				self.AddNewEmbed(EmbedName,EmbedParam1,EmbedParam2,EmbedParam3,EmbedPriority)
                
				state = 51
			end

		of 51
			state = 60
			self.CheckForMissedEmbed(AsciiText,lineno,state)

		OF 60  ! capturing embed
			! Quit when [END] encountered
			if sub(AsciiText,1,1) = '['
				if sub(AsciiText,1,5) = '[END]'
					case WhenLevel
					of 3
						WhenLevel = 2
						embedParam3 = ''
					of 2
						WhenLevel = 1
						embedParam2 = ''
					of 1
						WhenLevel = 0
						embedParam1 = ''
					end
					state = 0

				elsif sub(AsciiText,1,8) = '[SOURCE]'
					! look for another embed under this [EMBED] point
					state = 50
				else
					! could be we're done
					state = 0
				end
!                  !dbg.write('*************************************************************************************************')
			elsif sub(AsciiText,1,6) = 'WHEN '''
				case WhenLevel
				of 0
					! get the first param
					embedParam1 = sub(AsciiText,7,len(clip(AsciiText))-7)
					WhenLevel = 1
					state = 42
				of 1
					! get the second param
					embedParam2 = sub(AsciiText,7,len(clip(AsciiText))-7)
					WhenLevel = 2
					state = 50
				of 2
					state = 50
				end
!                  !dbg.write('*************************************************************************************************')
			elsif sub(AsciiText,1,13) = 'PROPERTY:END '
			else
				! write embed buffer to file
				if ~self.ProcedureQ &= null and ~self.ProcedureQ.embedq &= null and ~self.ProcedureQ.embedq.EmbedLinesQ &= NULL
					self.ProcedureQ.embedq.embedlinesq.line = AsciiText
					add(self.ProcedureQ.embedq.embedlinesq)
					!dbg.write('** text        : ' & AsciiText)
				ELSE
					!dbg.write('** Could not write to queue')
				END
                
			end
		else
			!dbg.write('*** no code for state ' & state & ' ***')
			self.CheckForMissedEmbed(AsciiText,lineno,state)
		END
		!end ! if dumptrace
		!?progressVar{prop:progress} = records(txaq)
		!setcursor()
	END
	! Remove any embeds that don't contain text
	loop x = records(self.ProcedureQ) to 1 by -1
		get(self.ProcedureQ,x)
		!dbg.write('post-processing record ' & x & ', ' & records(self.ProcedureQ.EmbedQ)  & ' records in embedq')
		if records(self.ProcedureQ.EmbedQ)
			loop y = records(self.ProcedureQ.embedq) to 1 by -1
				get(self.ProcedureQ.embedq,y)
				found = false
				!dbg.write('set found to false')
				loop z = 1 to records(self.ProcedureQ.embedq.EmbedLinesQ)
					get(self.ProcedureQ.embedq.EmbedLinesQ,z)
					if clip(self.ProcedureQ.embedq.EmbedLinesQ.line) <> ''
						!dbg.write('found content in line: ' & self.ProcedureQ.embedq.EmbedLinesQ.line)
						found = TRUE
						BREAK
					END
				END
				!dbg.write('found is ' & found & ', records ' & records(self.ProcedureQ.embedq.EmbedLinesQ))
				if ~found or ~records(self.ProcedureQ.embedq.EmbedLinesQ)
					free(self.ProcedureQ.embedq.embedlinesq)
					dispose(self.ProcedureQ.embedq.embedlinesq)
					delete(self.ProcedureQ.embedq)
					!dbg.write('deleting embedq record')
				END
			END
		end
	END
	! Remove any procedures without embeds
	!dbg.write('************************')
	loop x = records(self.ProcedureQ) to 1 by -1
		get(self.ProcedureQ,x)
		!dbg.write('post-processing record ' & x & ', ' & records(self.ProcedureQ.EmbedQ)  & ' records in embedq')
		if ~records(self.ProcedureQ.EmbedQ)
			!dbg.write('removing procedure ' & self.ProcedureQ.ProcedureName)
			self.RemoveCurrentProcedureFromQueue
		end
	END
	!dbg.write('************************')
	TxaFile.CloseFile()
	return true
	
	
DCL_Clarion_TXAParser.RemoveCurrentProcedureFromQueue   procedure
y                                                           long
	code
	if ~self.ProcedureQ.embedq &= null
		! Loop through all the embed records
		loop y = records(self.ProcedureQ.embedq) to 1 by -1
			! Get each embed record
			get(self.ProcedureQ.EmbedQ,y)
			! If the embed record has a queue of lines, free and dispose
			if ~self.ProcedureQ.EmbedQ.EmbedLinesQ &= NULL
				free(self.ProcedureQ.embedq.EmbedLinesQ)
				dispose(self.ProcedureQ.embedq.EmbedLinesQ)
			END
		END
		! delete and dispose 
		free(self.ProcedureQ.EmbedQ)
		dispose(self.ProcedureQ.EmbedQ)
	END
	delete(self.ProcedureQ)

DCL_Clarion_TXAParser.Reset PROCEDURE
x                                           LONG
y                                           LONG
z                                           LONG

	CODE
	if ~self.ProcedureQ &= null
		loop x = records(self.ProcedureQ) to 1 by -1
			get(self.ProcedureQ,x)
			self.RemoveCurrentProcedureFromQueue
		END
	END
	free(self.ProcedureQ)
	if ~self.ProcedureQIsExternal
		dispose(self.ProcedureQ)
	END    
		
DCL_Clarion_TXAParser.SetQueue                              procedure(DCL_Clarion_TXAParser_ProcedureQueue procedureQ)
	CODE
	self.ProcedureQ &= procedureQ     
	self.ProcedureQIsExternal = true
