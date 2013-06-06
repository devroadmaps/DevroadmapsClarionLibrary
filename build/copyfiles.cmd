@echo off
xcopy DevRoadmapsClarion.dll ..\bin /D /Y
xcopy DevRoadmapsClarion.dll ..\UnitTests /D /Y
xcopy DevRoadmapsClarion.dll ..\ClarionTest /D /Y
xcopy obj\debug\DevRoadmapsClarion.lib ..\lib /D /Y
xcopy obj\release\DevRoadmapsClarion.lib ..\lib /D /Y