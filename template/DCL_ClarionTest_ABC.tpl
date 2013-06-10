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
#!*****************************************************************************
#UTILITY(CreateATestDLLFromTXA,'Create a ')
#! #PROMPT('File to import',@s64),%TestDllTXA
#Display('Run this utility on a new, empty DLL')
#Display('APP to make it into a unit test APP.')
#Display('')
#Display('This will add the necessary global ')
#Display('extension, one test procedure and a')
#Display('reference to DevRoadmapsClarion.lib')
#Display('(just in case you need any functionality')
#Display('contained in the library).')
#Display('')
#Display('IMPORTANT!')
#Display('')
#Display('When you create a DLL app the project')
#Display('Output Type defaults to EXE. You will ')
#Display('need to go to Project | Project Options')
#Display('and change the Output Type to DLL.')
#Display('')
#Display('Once you have successfully built your')
#Display('test DLL, run ClarionTest.exe, point it')
#Display('at your DLL, and run your tests.')
#Display('')
#Import('DCL_TestDll.txa')
#PROJECT('DevRoadmapsClarion.lib')
#!*****************************************************************************