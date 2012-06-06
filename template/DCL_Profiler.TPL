#!-----------------------------------------------------------------------------!
#! Clarion Magazine Profiler Class version 2.0
#! Template
#!----------------------------------------------------------------------------!
#!
#! You can reach CoveComm Inc at:
#!
#!     CoveComm Inc.
#! 	  1036 McMillan Ave
#!     Winnipeg, MB  R3M 0V8
#!     
#!	  www.covecomm.com
#!     www.clarionmag.com
#! 
#! 
#!
#!----------------------------------------------------------------------------!
#! V1.3 Updates: Matías A. Flores (matias_flores@hotmail.com)
#!----------------------------------------------------------------------------!
#!----------------------------------------------------------------------------!
#! V1.4 Updates: David Harms
#!----------------------------------------------------------------------------!
#!----------------------------------------------------------------------------!
#! V2.0 Updates: David Harms
#!----------------------------------------------------------------------------!
#TEMPLATE (ClarionMag_ProfilerTracer,'Profiling and Tracing Classes - CCIPROF.TPL'),FAMILY('ABC')
#!----------------------------------------------------------------------------!
#Extension(ClarionMag_ProfilerTracerGlobals,'Profiling and Tracing Global Settings'),APPLICATION
#SHEET
   #TAB('Basics')
   	#Boxed('Hidden'),hide
      #Prompt('Base class name',@s100),%ptBaseClassName
   	#EndBoxed
      #PROMPT('&Enable',CHECK),%EnableTracer,DEFAULT(%True),AT(10)
      #ENABLE(%EnableTracer)
         #DISPLAY('')
         #BOXED('Options')
	         #DISPLAY('')
	         #Prompt('Object name',@s100),%BaseDebugObjectName,default('Tracer')
	         #Prompt('Write to log file',CHECK),%WriteToLogFile,default(%True),AT(10)
	         #DISPLAY('')
	         #Prompt('Write Win32 debug msgs',CHECK),%WriteToWin32Debug,default(%True),AT(10)
	         #DISPLAY('(view using DbgView)')
	         #DISPLAY('')
	         #PROMPT('&Record all events',CHECK),%RecordAllEvents,DEFAULT(%False),AT(10)
	         #DISPLAY('')
	         #PROMPT('&Start Disabled',CHECK),%StartDisabled,DEFAULT(%False),AT(10)
	         #DISPLAY('')
	         #DISPLAY('')
	         #PROMPT('&Jump To Last Message',CHECK),%StayOnLastLine,DEFAULT(%False),AT(10)
	         #DISPLAY('')
	         #DISPLAY('You can have the trace toolbox always jump to')
	         #DISPLAY('the last trace message, but this may cause')
	         #DISPLAY('display problems with some applications.')
	         #DISPLAY('')
           	 #Prompt('Enable profiling',CHECK),%EnableProfiler,Default(%False),At(10)
	         #BOXED('Profiling options')
	         	#Enable(%EnableProfiler)
	         		#Prompt('Profile all code',Check),%ProfileEverything,AT(10)
	         		#Display('')
	         		#Display('You must choose Profile all code if you ')
	         		#Display('want to trace ABC library calls.')
	         		#Display('')
	         		#Display('If you turn this option on two defines will be')
	         		#Display('added to your project:')
	         		#Display('')
	         		#Display('profile=>on')
	         		#Display('debug=>on')
	         		#Display('')
	         		#Display('If you want to disable profiling you will need')
	         		#Display('to manually remove the profile=>on define.')
	         		#Display('')
	         		#Display('You can also turn on profiling individually for')
	         		#Display('modules by manually adding the profile=>on define')
	         		#Display('to the module properties. Make sure you have ')
	         		#Display('debugging enabled as well. ')
	         		#Display('')
	         	#EndEnable
	         #ENDBOXED
          #EndBoxed
       #ENDENABLE
   #END
#ENDSHEET
#AtStart
	#If(%EnableTracer and %EnableProfiler)
		#Set(%ptBaseClassName,'DCL_System_Diagnostics_Profiler')
	#Else
		#Set(%ptBaseClassName,'DCL_System_Diagnostics_Tracer')
	#End
#EndAt
#AT(%AfterGlobalIncludes)
   #IF(%EnableTracer)
      INCLUDE('%ptBaseClassName.inc'),ONCE
   #ENDIF
#ENDAT
#AT(%BeginningExports),WHERE(~%GlobalExternal)
#INSERT(%AddExpItem(ABC),'$'&%BaseDebugObjectName)
#INSERT(%AddExpItem(ABC),'PROFILE:ENTERPROC')
#INSERT(%AddExpItem(ABC),'PROFILE:LEAVEPROC')
#INSERT(%AddExpItem(ABC),'KILL@F16CCIPROFILERCLASS')
#INSERT(%AddExpItem(ABC),'INIT@F16CCIPROFILERCLASS')
#ENDAT
#AT(%AfterFileDeclarations)
	#IF(%EnableTracer)
		#IF(%GlobalExternal)
%[20 + (%CustomGlobalDataComponentIndent * 2)]BaseDebugObjectName %ptBaseClassName,EXTERNAL,DLL(_ABCDllMode_)
		#ELSE
%[20 + (%CustomGlobalDataComponentIndent * 2)]BaseDebugObjectName %ptBaseClassName
		#ENDIF
	#ENDIF
#END
#ATEND
    #If(%EnableTracer)
      	#FIX(%Driver,'ASCII')
      	#PROJECT(%DriverLib)
		#IF(%EnableProfiler)
	    	#PDEFINE('debug','1')
	      	#PDEFINE('profile','1')
	    #Else
      		#PDEFINE('profile','0')
	    #EndIf
   	#ENDIF
#ENDAT

#AT(%ProgramSetup)
	#IF(%EnableTracer)
#!%BaseDebugObjectName.Init()
%BaseDebugObjectName.Disabled = %StartDisabled
%BaseDebugObjectName.StayOnLastLine = %StayOnLastLine
%BaseDebugObjectName.WriteToLogFile = %WriteToLogFile
%BaseDebugObjectName.WriteToWin32Debug = %WriteToWin32Debug

   	#ENDIF
#ENDAT
#AT(%WindowManagerMethodCodeSection,'TakeEvent','(),BYTE'),PRIORITY(3500)
	#IF(%EnableTracer)
		#IF(%RecordAllEvents)
%BaseDebugObjectName.Trace('*** ' & clip(%BaseDebugObjectName.GetEventName(Event())) & ' on field ' & field() & ' ***')
		#ENDIF
	#ENDIF
#ENDAT
#!----------------------------------------------------------------------------!
#Extension(ClarionMag_ProfilerTracerEnableForProcedure,'Enable the tracer for this procedure'),REQ(ClarionMag_ProfilerTracerGlobals)
#SHEET
	#TAB('Basics')
      	#DISPLAY('')
      	#DISPLAY('This extension resets the profiler and writes')
      	#DISPLAY('the profile log on the procedure exit')
      	#DISPLAY('')
   	#ENDTAB
#ENDSHEET
#!----------------------------------------------------------------------------!
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE')
#PRIORITY(400),DESCRIPTION('Initialize debugger/profiler')
   	#IF(%EnableTraceer)
%BaseDebugObjectName.Disabled = false
   	#ENDIF
#ENDAT
#!----------------------------------------------------------------------------!
#AT(%WindowManagerMethodCodeSection,'Kill','(),BYTE')
   	#IF(%EnableTraceer)
%BaseDebugObjectName.Disabled = true
#! %BaseDebugObjectName.CalcTimes()
   	#ENDIF
#ENDAT
#!----------------------------------------------------------------------------!
#! Code templates
#!----------------------------------------------------------------------------!
#CODE(cciProfilerTracerViewTrace,'View the profiler trace window'),REQ(cciProfilerTracerGlobals)
#DISPLAY('')
#DISPLAY('This code template displays the debugger/profiler')
#DISPLAY('trace window.')
#DISPLAY('')
#IF(%EnableTraceer)
%BaseDebugObjectName.ViewTrace()
#ELSE
MESSAGE('This debugging option has been disabled','cciProfilerTracer')
#ENDIF
#!----------------------------------------------------------------------------!
#CODE(cciProfilerTracerShowTraceToolbox,'Show the profiler trace toolbox'),REQ(cciProfilerTracerGlobals)
#DISPLAY('')
#DISPLAY('This code template displays the debugger/profiler')
#DISPLAY('trace toolbox on its own thread.')
#DISPLAY('')
#IF(%EnableTraceer)
%BaseDebugObjectName.ShowTraceToolbox()
#ELSE
MESSAGE('This debugging option has been disabled','cciProfilerTracer')
#ENDIF