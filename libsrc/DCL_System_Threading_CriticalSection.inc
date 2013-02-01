
	include('DCL_System_Threading_ICriticalSection.inc'),once

DCL_System_Threading_CriticalSection    CLASS,MODULE('DCL_System_Threading_CriticalSection.CLW'),LINK('DCL_System_Threading_CriticalSection.CLW',_DCL_Classes_LinkMode_),DLL(_DCL_Classes_DllMode_),type
CriticalSection                             &DCL_System_Threading_ICriticalSection,PRIVATE
Construct                                   PROCEDURE()
Destruct                                    PROCEDURE()
GetCriticalSection                          PROCEDURE(),*DCL_System_Threading_ICriticalSection
Release                                     PROCEDURE()
Wait                                        PROCEDURE()
										END
