#!*****************************************************************************
#TEMPLATE(ClarionMag,'Clarion Magazine Templates'),FAMILY('ABC')
#!*****************************************************************************
#!
#EXTENSION(ProcIniPreserve,'Procedure level INI save/restore v1.0'),WINDOW

#!====== Template Prompts =======
#BOXED('Template options')
  #DISPLAY('Clarion Mag Procedure Level INI Preserve')
  #DISPLAY('Template version: 1.0')
  #DISPLAY('Last updated by Tom H. on 12-10-00')
  #DISPLAY(' ')
  #DISPLAY('This template will save/restore all variables')
  #DISPLAY('on the list, using the following section.')
  #DISPLAY(' ')
  #PROMPT('INI Section (no brackets):',@S25),%PreserveSection,DEFAULT('Preference')
  #DISPLAY(' ')
  #PROMPT('Restore only on Insert',CHECK),%PreserveOnInsert
  #DISPLAY(' ')
  #DISPLAY('Local Variable - Default Value')
  #BUTTON ('Variables to preserve'), MULTI(%PreserveVars, %PreserveVar & ' - ' & %PreserveDefault), INLINE
    #PROMPT('Variable Name:',FIELD),%PreserveVar
    #PROMPT('Default Value:',@S45),%PreserveDefault
    #DISPLAY(' ')
    #DISPLAY('NOTE: Use quotes for string values.')
  #ENDBUTTON
#ENDBOXED

#!----------------------------------------------------------------------------
#AT( %WindowManagerMethodCodeSection, 'Init', '(),BYTE'),PRIORITY(2001),WHERE(~%PreserveOnInsert)
#FOR(%PreserveVars)
#IF( %PreserveDefault )
%PreserveVar = %PreserveDefault
IniMgr.Fetch('%PreserveSection','%PreserveVar',%PreserveVar)
#ELSE
%PreserveVar = IniMgr.TryFetch('%PreserveSection','%PreserveVar')
#ENDIF
#ENDFOR
#ENDAT

#!----------------------------------------------------------------------------
#AT( %WindowManagerMethodCodeSection, 'PrimeFields'),PRIORITY(6001),WHERE(%PreserveOnInsert)
#FOR(%PreserveVars)
#IF( %PreserveDefault )
%PreserveVar = %PreserveDefault
IniMgr.Fetch('%PreserveSection','%PreserveVar',%PreserveVar)
#ELSE
%PreserveVar = IniMgr.TryFetch('%PreserveSection','%PreserveVar')
#ENDIF
#ENDFOR
#ENDAT

#!----------------------------------------------------------------------------
#AT( %WindowManagerMethodCodeSection, 'Kill', '(),BYTE'),PRIORITY(2001)
If Self.Response = RequestCompleted
	update()
#FOR(%PreserveVars)
   IniMgr.Update('%PreserveSection','%PreserveVar',%PreserveVar)
#ENDFOR
End
#ENDAT
