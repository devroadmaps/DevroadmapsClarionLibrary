rem This file is executed in the context of the bin (output) directory
rem so all file locations need to be relative to that location
@echo off
xcopy DevRoadmapsClarion.dll ..\bin /D /Y
xcopy DevRoadmapsClarion.dll ..\UnitTests /D /Y
xcopy DevRoadmapsClarion.dll ..\ClarionTest /D /Y
xcopy ..\build\obj\debug\DevRoadmapsClarion.lib ..\lib /D /Y
xcopy ..\build\obj\release\DevRoadmapsClarion.lib ..\lib /D /Y