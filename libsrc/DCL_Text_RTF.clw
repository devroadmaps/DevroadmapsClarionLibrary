!---------------------------------------------------------------------------------------------!
! Copyright (c) 2012, CoveComm Inc.
! All rights reserved.
!---------------------------------------------------------------------------------------------!
!region
!
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
!
! 1. Redistributions of source code must retain the above copyright notice, this
!    list of conditions and the following disclaimer.
! 2. Redistributions in binary form must reproduce the above copyright notice,
!    this list of conditions and the following disclaimer in the documentation
!    and/or other materials provided with the distribution.
! 3. The use of this software in a paid-for programming toolkit (that is, a commercial
!    product that is intended to assist in the process of writing software) is
!    not permitted.
!
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
! ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
! WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
! DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
! ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
! (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
! ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
! (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
! SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
!
! The views and conclusions contained in the software and documentation are those
! of the authors and should not be interpreted as representing official policies,
! either expressed or implied, of www.DevRoadmaps.com or www.ClarionMag.com.
!
! If you find this software useful, please support its creation and maintenance
! by taking out a subscription to www.DevRoadmaps.com.
!---------------------------------------------------------------------------------------------!
!endregion

                                            Member
                                            Map
                                            End



    Include('DCL_Text_RTF.inc'),Once
    !include('DCL_System_Diagnostics_Logger.inc'),once

!dbg                                     DCL_System_Diagnostics_Logger

	include('DCL_System_String.inc'),once


DCL_Text_RTF.Construct                   procedure
	code 
	self.HeaderText = '{{\rtf1\ansi\ansicpg1252\deff0\deflang4105' |
		& '{{\fonttbl{{\f0\fnil\fcharset0 MS Sans Serif;}}' 
	self.ColorsQ &= new DCL_Text_RTF_ColorsQueue
	self.HighlightsQ &= new DCL_Test_RTF_HighlightsQueue
			
DCL_Text_RTF.Destruct                    procedure
	code 
	free(self.ColorsQ)
	dispose(self.ColorsQ)
	free(self.HighlightsQ)
	dispose(self.HighlightsQ)
	
DCL_Text_RTF.GetColorTableEntry          procedure(long color)!,string,private	
clr                                         Long
rgb                                         Group,Over(clr)
red                                             Byte
green                                           Byte
blue                                            Byte
reserved                                        Byte
											End
	CODE
	clr = color 
	return '\red' & rgb.red & '\green' & rgb.green & '\blue' & rgb.blue & ';'
	
	

DCL_Text_RTF.GetText                     procedure !,STRING
rtfStr                                      DCL_System_String
docStr                                      DCL_System_String
x                                           long
	code
	rtfStr.Assign(self.HeaderText)
	rtfStr.Append('{{\colortbl ;')
	rtfStr.Append(self.GetColorTableEntry(color:black))
	loop x = 1 to records(self.ColorsQ)
		get(self.ColorsQ,x)
		rtfStr.Append(self.GetColorTableEntry(self.ColorsQ.Color))
	END
	rtfStr.Append('}{{\*\generator Msftedit 5.41.21.2509;}')
	rtfStr.Append('\viewkind4\uc1\pard\cf1\highlight0\f0\fs17 ')
	! Do the text highlighting
	docStr.Assign(self.text)
	loop x = 1 to records(self.HighlightsQ)
		get(self.HighlightsQ,x)
		self.ColorsQ.Color = self.HighlightsQ.FgColor
		get(self.ColorsQ,self.ColorsQ.Color)
		docStr.Replace(self.HighlightsQ.Text,|
			'\cf' & pointer(self.ColorsQ)+1  & ' '|
			& self.HighlightsQ.Text & '\cf1 ',,true)
	END
	rtfStr.Append(docstr.Get())
	rtfStr.Append('}')
	return rtfStr.Get()

	
	
DCL_Text_RTF.HighlightText               procedure(string text,long fgColor)
	CODE
	self.ColorsQ.Color = fgColor
	get(self.ColorsQ,self.ColorsQ.Color)
	if errorcode()
		self.ColorsQ.Color = fgColor
		add(self.ColorsQ,self.ColorsQ.Color)
	END
	self.HighlightsQ.text = text
	get(self.HighlightsQ,self.HighlightsQ.text)
	if errorcode()
		self.HighlightsQ.text = text
		self.HighlightsQ.FgColor = fgColor
		add(self.HighlightsQ,self.HighlightsQ.text)
	END	
		
	
DCL_Text_RTF.SetText                     procedure(string text)
	code 
	self.Text = text
	

