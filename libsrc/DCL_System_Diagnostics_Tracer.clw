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
					member()

	! Do NOT remove the following line. It turns off profiling for this
	! module and is needed by DCL_System_Diagnostics_Profiler
	pragma('define(profile=>0)')

	include('DCL_System_Diagnostics_Tracer.inc'),once
	include('DCL_System_Diagnostics_Logger.inc'),once

!gdbg                                    DCL_System_Diagnostics_Logger,external




					map
						TraceToolbox(string Addr)
					end



TraceLog            file,driver('ascii'),create,pre(trace),thread
Record                  record,pre()
Text                        string(1000)
						end
					end

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.Construct  procedure
	code
    !!gdbg.write('DCL_System_Diagnostics_Tracer.Construct ' & address(self))	
    self.LogFileName = 'trace.log'
	self.Timer &= new DCL_System_Diagnostics_Timer
	self.TraceQ &= new(DCL_System_Diagnostics_Tracer_TraceQueue)
	self.ThreadQ &= new(DCL_System_Diagnostics_Tracer_ThreadIndentQueue)
	self.CollapseQ &= new(DCL_System_Diagnostics_Tracer_SimpleQueue)
    self.EventNameQ &= new(DCL_System_Diagnostics_Tracer_EventNameQueue)
    self.WriteToWin32Debug = true
    self.NoiseSuppression = true;
    self.StayOnLastLine = true
    self.ThreadAware = true
    self.TreeView = true
    self.WriteToWin32Debug = true
    self.CacheSize = 10    
    self.Reset()
	self.AddEvent('EVENT:Accepted      ',01H)
	self.AddEvent('EVENT:NewSelection  ',02H)
	self.AddEvent('EVENT:ScrollUp      ',03H)
	self.AddEvent('EVENT:ScrollDown    ',04H)
	self.AddEvent('EVENT:PageUp        ',05H)
	self.AddEvent('EVENT:PageDown      ',06H)
	self.AddEvent('EVENT:ScrollTop     ',07H)
	self.AddEvent('EVENT:ScrollBottom  ',08H)
	self.AddEvent('EVENT:Locate        ',09H)
	self.AddEvent('EVENT:MouseDown     ',01H)
	self.AddEvent('EVENT:MouseUp       ',0aH)
	self.AddEvent('EVENT:MouseIn       ',0bH)
	self.AddEvent('EVENT:MouseOut      ',0cH)
	self.AddEvent('EVENT:MouseMove     ',0dH)
	self.AddEvent('EVENT:VBXevent      ',0eH)
	self.AddEvent('EVENT:AlertKey      ',0fH)
	self.AddEvent('EVENT:PreAlertKey   ',10H)
	self.AddEvent('EVENT:Dragging      ',11H)
	self.AddEvent('EVENT:Drag          ',12H)
	self.AddEvent('EVENT:Drop          ',13H)
	self.AddEvent('EVENT:ScrollDrag    ',14H)
	self.AddEvent('EVENT:TabChanging   ',15H)
	self.AddEvent('EVENT:Expanding     ',16H)
	self.AddEvent('EVENT:Contracting   ',17H)
	self.AddEvent('EVENT:Expanded      ',18H)
	self.AddEvent('EVENT:Contracted    ',19H)
	self.AddEvent('EVENT:Rejected      ',1AH)
	self.AddEvent('EVENT:DroppingDown  ',1BH)
	self.AddEvent('EVENT:DroppedDown   ',1CH)
	self.AddEvent('EVENT:ScrollTrack   ',1DH)
	self.AddEvent('EVENT:ColumnResize  ',1EH)
	self.AddEvent('EVENT:Selected      ',101H)
	self.AddEvent('EVENT:CloseWindow   ',201H)
	self.AddEvent('EVENT:CloseDown     ',202H)
	self.AddEvent('EVENT:OpenWindow    ',203H)
	self.AddEvent('EVENT:OpenFailed    ',204H)
	self.AddEvent('EVENT:LoseFocus     ',205H)
	self.AddEvent('EVENT:GainFocus     ',206H)
	self.AddEvent('EVENT:Suspend       ',208H)
	self.AddEvent('EVENT:Resume        ',209H)
	self.AddEvent('EVENT:Timer         ',20BH)
	self.AddEvent('EVENT:DDErequest    ',20CH)
	self.AddEvent('EVENT:DDEadvise     ',20DH)
	self.AddEvent('EVENT:DDEdata       ',20EH)
	self.AddEvent('EVENT:DDEcommand    ',20FH)
	self.AddEvent('EVENT:DDEexecute    ',20FH)
	self.AddEvent('EVENT:DDEpoke       ',210H)
	self.AddEvent('EVENT:DDEclosed     ',211H)
	self.AddEvent('EVENT:Move          ',220H)
	self.AddEvent('EVENT:Size          ',221H)
	self.AddEvent('EVENT:Restore       ',222H)
	self.AddEvent('EVENT:Maximize      ',223H)
	self.AddEvent('EVENT:Iconize       ',224H)
	self.AddEvent('EVENT:Completed     ',225H)
	self.AddEvent('EVENT:Moved         ',230H)
	self.AddEvent('EVENT:Sized         ',231H)
	self.AddEvent('EVENT:Restored      ',232H)
	self.AddEvent('EVENT:Maximized     ',233H)
	self.AddEvent('EVENT:Iconized      ',234H)
	self.AddEvent('EVENT:BuildFile     ',240H)
	self.AddEvent('EVENT:BuildKey      ',241H)
	self.AddEvent('EVENT:BuildDone     ',242H)
	self.AddEvent('EVENT:User          ',400H)
	self.AddEvent('EVENT:Last          ',0FFFH)

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.Destruct  procedure
	code
	!!gdbg.write('DCL_System_Diagnostics_Tracer.Destruct ' & address(self))	
	self.WriteTrace()
	self.Reset()
	dispose(self.TraceQ)
	dispose(self.EventNameQ)
	dispose(self.ThreadQ)
	dispose(self.CollapseQ)
	dispose(self.Timer)
	

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.AddCollapseString     procedure(string Collapse)
	code
	self.CollapseQ.Text = Upper(Collapse)
	add(self.CollapseQ)

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.AddEvent      procedure(string EventName,long EventNo)
	code
	if self.FindEvent(EventNo)
		self.EventNameQ.name = eventName
		put(self.EventNameQ,self.EventNameQ.No)
	else
		clear(self.EventNameQ)
		self.EventNameQ.name = eventName
		self.EventNameQ.no = eventNo
		add(self.EventNameQ,self.EventNameQ.No)
	end

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.CloseLogFile      procedure()
    code
    if self.LogFileOpen 
        !!gdbg.write('closing ' & self.LogFileName)
        close(TraceLog)
        self.LogFileOpen = false
    end

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.Count         procedure() !,string  
	code
	!!gdbg.write(records(self.traceq) & ' records in traceq')
	return records(self.TraceQ)
	
!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.FindEvent     procedure(long EventNo)
	code
	self.EventNameQ.No = EventNo
	get(self.EventNameQ,self.EventNameQ.No)
	if errorcode()
      !self.Trace('Error retrieving event ' & EventNo & ' from
		return(False)
	else
		return(True)
	end

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.Flush        procedure()
    code
    self.WriteTrace()
    

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.FormatQueue   procedure(bool TreeView=False)
x                               long
	code
	setcursor(cursor:wait)
	loop x = 1 to records(self.TraceQ)
		get(self.TraceQ,x)
		self.TraceQ.Text = self.FormatText(self.TraceQ.Text,TreeView)
		put(self.TraceQ)
	end
	setcursor()

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.FormatText    procedure(string Text,bool TreeView=False)
	code
	if TreeView or self.IndentLevel = 0
		return(left(Text))
	else
		return(clip(format(self.TraceQ.IndentLevel,@n03) & ' ' & all(' ',(abs(self.TraceQ.IndentLevel)-1)*self.IndentSpacing) & left(Text)))
	end

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.GetEventName  procedure(long EventNo)
	code
	if self.FindEvent(EventNo)
		return(self.EventNameQ.Name)
	else
		return('(??EVENT:' & EventNo & ' isn''t in the event list)') ! jcm
	end

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.GetThread     procedure(long thread)
	code
	if not self.ThreadAware then return.
	if self.ThreadQ.Thread <> Thread
!--------------------------------------------------------------------!
! If the thread has changed, update the record for the thread you
! just left with the last indent level.
!--------------------------------------------------------------------!
		self.ThreadQ.IndentLevel = self.IndentLevel
		put(self.ThreadQ)
!--------------------------------------------------------------------!
! Try to locate a record for the new thread. If not found, create
! one, and set its starting indent level to the current level. If
! one is found, reset the current indent level to what it was when
! you last left that thread.
!--------------------------------------------------------------------!
		self.ThreadQ.Thread = Thread
		get(self.ThreadQ,self.ThreadQ.Thread)
		if errorcode()
			clear(self.ThreadQ)
			self.ThreadQ.Thread = Thread
			self.ThreadQ.IndentLevel = self.IndentLevel
			add(self.ThreadQ,self.ThreadQ.Thread)
		end
		self.Trace(' ')
		self.Trace('******************** Switching from thread ' & self.CurrThread & ' to thread ' & Thread & ' ********************')
		self.Trace(' ')
		self.IndentLevel = self.ThreadQ.IndentLevel
		self.CurrThread = Thread
	end

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.GetTrace procedure(long index, bool showIndent = false) !,string
x	long
	code
	if index > self.count()
		return ''
	END
	get(self.traceq,x)
	if showIndent
		return self.FormatText(self.traceq.text,false)
	END	
	return clip(self.traceq.text)
	
!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.HideTraceToolbox      procedure
	code
	if self.ToolboxThread then post(event:closewindow,,self.ToolboxThread).


!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.OpenLogFile       procedure()
    code
    if ~self.LogFileOpen
      IF self.LogFileName
        TraceLog{PROP:Name} = self.LogfileName
        share(TraceLog)
        if errorcode()
            !!gdbg.write('Error sharing ' & self.LogFileName & ', trying to create')
            create(TraceLog)
            share(TraceLog)
            if errorcode()
                !!gdbg.write('Unable to open error log: ' & error())
                return false
            end
        end
        !!gdbg.write(self.LogFileName & ' successfully opened')
        self.LogFileOpen = true
      END
    else
        !!gdbg.write(self.LogFileName & ' already open')
    end
    return true

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.Reset procedure
	code
	!!gdbg.write('DCL_System_Diagnostics_Tracer.Reset - freeing traceq')
	free(self.traceq)
	free(self.CollapseQ)
	free(self.ThreadQ)
	self.ThreadQ.Thread = 1
    self.ThreadQ.IndentLevel = 1
    add(self.ThreadQ)
    self.NextLineToWrite = 1
    !!gdbg.write('Reset self.NextLineToWrite to 1')
    self.CurrThread = 1
	
DCL_System_Diagnostics_Tracer.SetCacheSize       procedure(long cacheSize)
PrevCacheSize                                       long
    code
    if cacheSize < 1 then cacheSize = 0.
    PrevCacheSize = self.CacheSize
    self.CacheSize = cacheSize
    if self.CacheSize < PrevCacheSize then self.Flush().
    
    
!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.SetFilename     procedure(string filename)
    code
    self.LogFileName = filename
    self.CloseLogFile()
!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.SetIndentLevel     procedure(long IndentLevel)
    code
    self.IndentLevel = IndentLevel

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.ShowTraceToolbox      procedure
	code
	if self.ToolboxThread = 0
		self.ToolboxThread = start(TraceToolbox,25000,address(self))
	end

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.Trace procedure(string Text)
x                       long
debugmsg	cstring(1000)
	code
	if self.Disabled then return.
	if self.ThreadAware then self.GetThread(Thread()).
	self.TraceQ.Text = Text
	self.TraceQ.IndentLevel = self.IndentLevel
	if self.AutoCollapse = True
		loop x = 1 to records(self.CollapseQ)
			get(self.CollapseQ,x)
			if instring(upper(clip(self.CollapseQ.Text)),clip(Text),1,1)
				self.TraceQ.IndentLevel = 0 - self.IndentLevel
				break
			end
		end
	end
    if self.TreeView = False then self.TraceQ.Text = all(' ',(self.IndentLevel-1)*self.IndentSpacing) & self.TraceQ.Text.
    self.Timer.GetCurrentTime(self.traceq.Timestamp)
	add(self.TraceQ)
	if self.CacheSize = 0 or records(self.TraceQ) % self.CacheSize = 0 then self.WriteTrace().
	
	if self.WriteToWin32Debug
		debugmsg = self.FormatText(text)
		!gdbg.write(debugmsg)		
	end 
	
		

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.TraceIn       procedure(string Text)
	code
	self.Trace(Text)
	self.IndentLevel += 1

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.TraceOut      procedure(string Text)
	code
	self.IndentLevel -= 1
	self.Trace(Text)

!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.ViewTrace     procedure

window                          WINDOW('Trace Queue'),AT(,,482,247),FONT('MS Sans Serif',8,,),SYSTEM,GRAY,DOUBLE
									LIST,AT(6,6,473,222),USE(?List1),HVSCROLL,FONT('Courier New',8,,FONT:regular),FORMAT('600L@s255@'), |
										FROM(self.TraceQ)
									BUTTON('Close'),AT(225,231,,14),USE(?Close)
								END

	code
	self.FormatQueue()
	open(window)
	accept
		if field() = ?Close and event() = event:Accepted then post(event:CloseWindow).
	end
	close(window)
	self.FormatQueue(self.TreeView)


!--------------------------------------------------------------------!
DCL_System_Diagnostics_Tracer.WriteTrace    procedure
x                               long
	code
    if self.WriteToLogFile
        if ~self.OpenLogFile()
            !!gdbg.write('Unable to open error log: ' & error())
            return
        end
        !!gdbg.write('Writing trace from line ' & self.NextLineToWrite & ' to ' & records(self.traceq))
		loop x = self.NextLineToWrite to records(self.TraceQ)
			get(self.TraceQ,x)
			TraceLog.Text = self.FormatText(self.TraceQ.Text) !& all(' ',10) &  ' [' & self.traceq.Timestamp & ']'
			add(TraceLog)
		end
        self.NextLineToWrite = records(self.TraceQ) + 1
        !!gdbg.write('set NextLineToWrite to ' & self.NextLineToWrite)
        self.CloseLogFile()
	end

!--------------------------------------------------------------------!
TraceToolbox        procedure(string Addr)

dbg                     &DCL_System_Diagnostics_Tracer
Levels                  long
DebugObjAddress         long

window                  WINDOW('To avoid GPF, Close BEFORE Quitting the App!!'), |            ! jcm
                            AT(,,349,189),FONT('MS Sans Serif',8),IMM,TIMER(20),SYSTEM, |     ! jcm
							TOOLBOX,GRAY,MAX,RESIZE
							LIST,AT(6,6,337,161),USE(?List),HVSCROLL,FONT('Courier New',8,,FONT:regular),FORMAT('65LT@s255@')
							PROMPT('Levels to show:'),AT(7,175),USE(?LevelsPrompt)
							SPIN(@n3),AT(61,175,30,10),USE(Levels),RANGE(1,999),STEP(1)
							BUTTON('Clear'),AT(259,174,40,14),USE(?clear)
							BUTTON('Close'),AT(304,174,40,14),USE(?Close)
						END
LastCount               long
x                       long
	code
	LastCount = 0
	DebugObjAddress = Addr
	dbg &= (DebugObjAddress)
	Levels = dbg.LevelsToShow
	open(window)
	?list{proplist:Tree} = True
	?list{prop:from} = dbg.TraceQ
	accept
		case event()
		of event:timer
			if records(dbg.TraceQ) > LastCount
				if dbg.StayOnLastLine
					select(?list,records(dbg.TraceQ))
				end
				Lastcount = records(dbg.TraceQ)
			end
		of event:sized
			do ResizeControls
		end
		case field()
		of ?Levels
			case event()
			of event:Accepted
			orof event:NewSelection
				dbg.LevelsToShow = Levels
				loop x = 1 to records(dbg.TraceQ)
					get(dbg.TraceQ,x)
					if abs(dbg.TraceQ.IndentLevel) => Levels
						if dbg.TraceQ.IndentLevel => 0
							dbg.TraceQ.IndentLevel = 0 - dbg.TraceQ.IndentLevel
						end
					else
						dbg.TraceQ.IndentLevel = abs(dbg.TraceQ.IndentLevel)
					end
					put(dbg.TraceQ)
				end
			end
		of ?Clear
			case event()
			of event:Accepted
				dbg.WriteTrace()
				free(dbg.TraceQ)
			end
		of ?Close
			case event()
			of event:Accepted
				post(event:CloseWindow)
			end
		end
	end
	clear(dbg.ToolboxThread)
	close(window)

ResizeControls      routine
	hide(FirstField(),LastField())
	?list{prop:width} = window{prop:width} - 12
	?list{prop:height} = window{prop:height} - 25
	?close{prop:ypos} = window{prop:height} - 17
	?clear{prop:ypos} = window{prop:height} - 17
	?LevelsPrompt{prop:ypos} = window{prop:height} - 15
	?Levels{prop:ypos} = window{prop:height} - 15
	?close{prop:xpos} = window{prop:width} - 50
	?clear{prop:xpos} = window{prop:width} - 100
	unhide(FirstField(),LastField())
	display()

