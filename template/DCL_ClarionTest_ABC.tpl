#!*****************************************************************************
#!*****************************************************************************
#TEMPLATE(ClarionTest, 'Clarion Unit Testing - ABC Template Chain'),FAMILY('ABC')
#INCLUDE('DCL_ClarionTest.tpw')
#!*****************************************************************************
#!*****************************************************************************
#PROCEDURE(GroupProcedure, 'Group Procedure (DO NOT USE - select Group Procedure from the Default tab, not from here)'), PARENT(Source(ABC))
#DEFAULT
NAME DefaultTestGroupProcedureABC
GLOBAL
CATEGORY 'Group procedures'
PROTOTYPE ''
[COMMON]
DESCRIPTION 'Group Procedure'
FROM ABC Source
#ENDDEFAULT
#!*****************************************************************************
#!*****************************************************************************
#PROCEDURE(TestProcedure, 'Test Procedure (DO NOT USE - select Test Procedure from the Default tab, not from here)'), PARENT(Source(ABC))
#DEFAULT
NAME DefaultTestProcedureABC
GLOBAL
CATEGORY 'Test procedures'
PROTOTYPE '(*long addr),long,pascal'
[COMMON]
DESCRIPTION 'Test Procedure'
FROM ABC Source
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
