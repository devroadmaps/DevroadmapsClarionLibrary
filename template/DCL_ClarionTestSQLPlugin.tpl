#TEMPLATE(ClarionTestSQLPlugin, 'Clarion Unit Testing SQL Plugin'),FAMILY('ABC')
#!---------------------------------------------------------------------
#Extension(ClarionTestSQLPlugin,'Add SQL Plugin Support For ClarionTest'),APPLICATION(ClarionTestSQLPluginProcExtension),LAST
#DISPLAY('This is the SQL Plugin template for ClarionTest.')
#DISPLAY('Created by: John Hickey')
#DISPLAY('')
#PROMPT('Include Database Handling class',CHECK),%IncludeDBH,AT(10),DEFAULT(1)
#PROMPT('Procedure Instantiation Name:',@S50),%SQLPluginName,DEFAULT('oCSP')
#!---------------------------------------------------------------------
#AT(%AfterGlobalIncludes)
  INCLUDE('DCL_ClarionTest_SQLPlugin.inc'),ONCE
#ENDAT
#!---------------------------------------------------------------------
#AT(%CustomGlobalDeclarations),Last
#FIX(%Driver, 'MSSQL')
#PROJECT(%DriverLIB)
#FIX(%Driver, 'ODBC')
#PROJECT(%DriverLIB)
#ENDAT
#Extension(ClarionTestSQLPluginProcExtension,'ClarionTestSQLPluginProcExtension'),PROCEDURE
#DISPLAY('This is the SQL Plugin template for ClarionTest.')
#AT(%DataSection)
#IF(%ProcedureTemplate = 'TestProcedure')
%SQLPluginName     DCL_ClarionTest_SQLPlugin
#ENDIF
#ENDAT