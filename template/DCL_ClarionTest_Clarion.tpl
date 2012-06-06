#!*****************************************************************************
#!*****************************************************************************
#TEMPLATE(ClarionTestClarion, 'Clarion Unit Testing - Clarion Template Chain'),FAMILY('CW20')
#INCLUDE('DCL_ClarionTest.tpw')
#!*****************************************************************************
#!*****************************************************************************
#PROCEDURE(GroupProcedure, 'Group Procedure (DO NOT USE - select Group Procedure from the Default tab, not from here)'), PARENT(Source(Clarion))
#DEFAULT
NAME DefaultTestGroupProcedureClarion
GLOBAL
CATEGORY 'Group procedures'
PROTOTYPE ''
[COMMON]
DESCRIPTION 'Group Procedure'
FROM Clarion Source
#ENDDEFAULT
#!*****************************************************************************
#!*****************************************************************************
#PROCEDURE(TestProcedure, 'Test Procedure (DO NOT USE - select Test Procedure from the Default tab, not from here)'), PARENT(Source(Clarion))
#DEFAULT
NAME DefaultTestProcedureClarion
GLOBAL
CATEGORY 'Test procedures'
PROTOTYPE '(*long addr),long,pascal'
[COMMON]
DESCRIPTION 'Test Procedure'
FROM Clarion Source
[PROMPTS]
%Parameters DEFAULT  ('(*long addr)')
[ADDITION]
NAME ClarionTest TestSupport
[INSTANCE]
INSTANCE 1
[WINDOW]
Window WINDOW('Dummy')
       END
#ENDDEFAULT
#!*****************************************************************************
