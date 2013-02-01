										member()
	
	include('DCL_System_Threading_CriticalSection.inc'),once


										MAP
											module('')
												NewCriticalSection(),*DCL_System_Threading_ICriticalSection,C,NAME('NewCriticalSection')
											end
										end




DCL_System_Threading_CriticalSection.Construct  PROCEDURE()
	CODE
	self.CriticalSection &= NewCriticalSection()
	RETURN
  
DCL_System_Threading_CriticalSection.Destruct   PROCEDURE()
	CODE
	self.CriticalSection.Kill()
	RETURN
  
  
  
DCL_System_Threading_CriticalSection.GetCriticalSection PROCEDURE()
	CODE
	RETURN self.CriticalSection
	
DCL_System_Threading_CriticalSection.Release    PROCEDURE()
	CODE
	self.CriticalSection.Release()
	RETURN

DCL_System_Threading_CriticalSection.Wait       PROCEDURE()
	CODE
	self.CriticalSection.Wait()
	RETURN
