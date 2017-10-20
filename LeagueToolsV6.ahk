
If not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
	ExitApp
}

#SingleInstance, Force
#Persistent
#InstallMouseHook
#InstallKeybdHook
CoordMode,Mouse,Window
CoordMode,Pixel,Window
OnExit, ExitSub
ver = v6.03
Confine = True
UpdateCheck = 0
Menu, Tray, NoStandard
Menu, Tray, UseErrorLevel
Menu, Tray, Tip, League Tools %ver%
ComObjError(0)
WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

IfExist C:\Riot Games\league of legends\LeagueClient.exe
{
	RiotPathF := "C:\Riot Games\league of legends\LeagueClient.exe"
	RiotBasePath := "C:\Riot Games\league of legends"
}
else
{
	x = 0
	SelectLeague:
	FileSelectFile, RiotPath, M3, C:\, Select League Launcher, *.exe
	StringReplace, RiotPathF, RiotPath, `n, \
	StringSplit, RiotPath, RiotPath, `n
	If !RiotPathF
	{
		x++
		If x = 3
			Goto, LauncherNotFound
		Goto, SelectLeague
	}
}
Menu, Tray, Icon, %RiotPathF%, 1
;TrayTip, League Tools %ver%, League launcher found., %tsecs%
LauncherNotFound:

IfNotExist, %A_ScriptDir%\Data
{
	MsgBox % "This is the first run of League Tools. Choosing default configuration."
	GoSub, SetFirstRun
	GoSub, ReadSettings
	Gosub, SettingsSub
}
else
	GoSub, ReadSettings

Menu, GuidesLoading, Add, Loading, Tools
Menu, GuidesLoading, Disable, Loading
Menu, ChampSalesLoading, Add, Loading, Tools
Menu, ChampSalesLoading, Disable, Loading
Menu, SkinSalesLoading, Add, Loading, Tools
Menu, SkinSalesLoading, Disable, Loading
Menu, ProStreamsLoading, Add, Loading, Tools
Menu, ProStreamsLoading, Disable, Loading

Menu, GroupOrSolo, Add, Solo, Tools
Menu, GroupOrSolo, Add, Group, Tools
Menu, GroupOrSolo, Check, Solo

Menu, Tray, Add, Champ Guides, :GuidesLoading
Menu, Tray, Add, Champ Sales, :ChampSalesLoading
Menu, Tray, Add, Skin Sales, :SkinSalesLoading
Menu, Tray, Add, Pro Streams, :ProStreamsLoading

Menu, AutoSelection, Add, 5v5 Blind, AutoStart
Menu, AutoSelection, Add, 5v5 Draft, AutoStart
Menu, AutoSelection, Add, 5v5 Ranked Solo/Duo, AutoStart
Menu, AutoSelection, Add, 5v5 Ranked Flex, AutoStart
Menu, AutoSelection, Add
Menu, AutoSelection, Add, 3v3 Blind, AutoStart
Menu, AutoSelection, Add, 3v3 Ranked Flex, AutoStart
Menu, AutoSelection, Add
Menu, AutoSelection, Add, ARAM, AutoStart

If RiotPathF
{
	Loop,
	{
		If (Login%A_Index%)
			Menu, Accounts, Add, % Login%A_Index%, Tools
		else
			break
	}
	If (Login%lgn%)
	{
		Menu, Accounts, Check, % Login%lgn%
		Menu, Accounts, NoDefault
		if !ErrorLevel
		   Menu, Tray, Add, Select Account, :Accounts
		Menu, Tray, Add, Login, LoginOnly
		;Auto Start not completed
		;Menu, Tray, Add, Login Only, LoginOnly
		;Menu, Tray, Add, Group or Solo, :GroupOrSolo
		;Menu, Tray, Add, Auto Start, :AutoSelection
		;Menu, Tray, Disable, Auto Start
	}
}

Menu, Tray, Add, Change VO/Text, ChangeVO
Menu, Tray, Add, Screenedge Off, Tools
Menu, Tray, Add
Menu, Tray, Add, Settings, SettingsSub
Menu, Tray, Add, Reload, ReloadSub
Menu, Tray, Add, Exit, ExitSub

SetTimer, LoadData, -500
TrayTip, League Tools %ver%, League Tools loaded., %tsecs%
return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;NOT FINISHED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AutoStart:
{
	;Considerations to start game
	;	Must Have:
	;		Login
	;		Pass
	;		RiotPath
	;		WhichQueueType
	;			GroupOrSolo
	
	;MsgBox % Login%lgn% "`n`n" RiotPathF "`n`n" A_ThisMenuItem
	
	global t := A_ThisMenuItem
	
	If !lgn
		lgn = 1
	If (Login%lgn%)
	{
		Login(Login%lgn%, Pass%lgn%, RiotpathF)
		Start(t, sGroup)
	}
	else
		return
	
	/*
	If sGroup
		Err := AutoAccept(QueueWaitTime + 500)
	Else
		Err := AutoAccept(QueueWaitTime)
	If (Err = 1)
	{
		Tooltip, Queue took over %QueueWaitTime% seconds. Please adjust this.
		Sleep 5000
		ToolTip
	}
	*/
}
return

Start(type1, sGroup)
{
	;Types
	;5v5
	;	Blind
	;	Draft
	;	Ranked Solo/Duo
	;	Ranked Flex
	;3v3
	;	Blind
	;	Ranked Flex
	;ARAM
	
	;Positions are mostly correct and will work well enough. rotating game style not done at all
	
	Sleep, 500
	WinGetPos,,, w, h, A
	Sleep, 250
	MouseClick, left, (w*.10), (h*.05),,0
	Sleep, 25
	MouseClick, left, (w*.10), (h*.05),,0
	
	;;;;;;;;;;;;;;;;;;;;;;;;;
	Sleep, 3500	;Replace this with a check for loaded status
	;;;;;;;;;;;;;;;;;;;;;;;;;
	
	If (InStr(type1, "5v5"))
	{
		If (InStr(type1, "Blind"))
			w1 := (w * 0.195), h1 := (h * 0.305), w2 := (w * 0.199), h2 := (h * 0.743)
		else If (InStr(type1, "Draft"))
			w1 := (w * 0.195), h1 := (h * 0.305), w2 := (w * 0.199), h2 := (h * 0.784)
		else If (InStr(type1, "Solo"))
			w1 := (w * 0.195), h1 := (h * 0.305), w2 := (w * 0.199), h2 := (h * 0.826)
		else If (InStr(type1, "Flex"))
			w1 := (w * 0.195), h1 := (h * 0.305), w2 := (w * 0.199), h2 := (h * 0.868)
	}
	else If (InStr(type1, "3v3"))
	{
		If (InStr(type1, "Blind"))
			w1 := (w * 0.390), h1 := (h * 0.305), w2 := (w * 0.398), h2 := (h * 0.715)
		If (InStr(type1, "Flex"))
			w1 := (w * 0.390), h1 := (h * 0.305), w2 := (w * 0.398), h2 := (h * 0.756)
	}
	else If (InStr(type1, "ARAM"))
		w1 := (w * 0.585), h1 := (h * 0.305), w2 := 0, h2 := 0
	
	
	MouseClick, left, w1, h1,,0
	Sleep, 25
	MouseClick, left, w1, h1,,0
	Sleep, 250
	
	If w2 && h2
	{
		Sleep, 250
		MouseClick, left, w2, h2,,0
		Sleep, 25
		MouseClick, left, w2, h2,,0
		Sleep, 250
	}
	
	;Confirm Click
	MouseMove, (w*.421),(h*.944)
	MouseClick, left, (w*.421),(h*.944),,0
	
	;;;;;;;;;;;;;;;;;;;;;;;;;
	Sleep, 5000	;Replace this with a check for loaded status
	;;;;;;;;;;;;;;;;;;;;;;;;;
	
	if sGroup = 1 
	{
		;If group then click invite button and wait
		MouseMove, (w*0.),(h*0.)
		MouseClick, left, (w*0.),(h*0.),,0
		Sleep, 100
	}

	;If solo then go to find match, (same coords as confirm button)
	MouseMove, (w*.421),(h*.944)
	MouseClick, left, (w*.421),(h*.944),,0
	;Sleep, %StartSleep%
	Sleep, 100
}

AutoAccept(q)
{
	;Get new Accept buttton color and relative coords
	return
	
	If q < 120
		q := 120
	p := q - 60
	colorB := "0x133B4D"
	Sleep, 250
	NotReady3:
	Loop
	{
		IfWinActive, ahk_class RCLIENT
		{
			WinGetPos,,, mWi, mHi, A
			x := (mWi * 0.495)
			y := (mHi * 0.769)
			;TrayTip, League Tools %ver%, % "Color Distance: " Distance(colorA, b_Play)
			If ColorCross(x, y, colorB, cDist)
			{
				Sleep, 400
				MouseMove, %x%, %y%
				Click, %x%, %y%
				break
			}
		}
		IfEqual, A_Index, p, ToolTip, Queue is taking a long time. Waiting 60s more.
		IfEqual, A_Index, q, return 1
		Sleep, 1000
	}
	Sleep, 1000
}

;NOT FINISHED
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



Login(u="", p="", installloc="")
{
	StartColor := "0x28231E"
	Run, %installloc%
	
	WinWaitActive ahk_class RCLIENT
	b = 0
	Loop,
	{
		Sleep, 250
		if WinExist("ahk_class RCLIENT")
		{
			WinActivate, ahk_class RCLIENT
			WinGetPos,,, w, h, A
			PixelGetColor, b_Play, (w*.85), (h*.27), RGB
			colorA := "0x28231E"
			ColDist := Distance(colorA, b_Play)
			;TrayTip, League Tools %ver%,  Color Distance: %ColDist%
			If ColDist < 45
				break
			
		}
	}
	Sleep, 100
	WinActivate, ahk_class RCLIENT
	WinWaitActive ahk_class RCLIENT
	WinGetPos,,, w, h, A
	b = 0
	Sleep, 100
	If !p
		InputBox, temppass, Mot de passe, Entrez votre mot de passe. Il ne sera pas sauvegarder.
	Sleep, 100
	WinActivate, ahk_class RCLIENT
 
	If u
	{
		MouseClick, Left, (w*.85), (h*.27),,0
		MouseClick, Left, (w*.85), (h*.27),,0
		Sleep, 100
		SendRaw, %u%
	}
	else
		return
	Sleep, 100
	Send {Tab}
	Sleep, 100
	If temppass
		SendInput {Raw}%temppass%
	If p
	{
		ObfPass := Obf(p, 0, 1234)
		SendInput {Raw}%ObfPass%
	}
	else
		return
	temppass := 
	ObfPass := 
	Sleep, 100
	Send {enter}
	Sleep, 100
	
	;Checking for loaded client
	Loop,
	{
		Sleep, 500
		IfWinActive, ahk_class RCLIENT
		{
			WinGetPos,,, w, h, A
			PixelGetColor, b_Play, (w*.10), (h*.05), RGB
			colorA := "0x16313F"
			ColDist := Distance(colorA, b_Play)
			;TrayTip, League Tools %ver%,  Color Distance: %ColDist%
			If ColDist < 45
				break
		}
	}
	return
}

LoginOnly:
{
	global t := A_ThisMenuItem
	If !lgn
		lgn = 1
	Login(Login%lgn%, Pass%lgn%, RiotpathF)
}
return

ChangeVO:
{	
	MsgBox, 4, WARNING, This option will change the voice and text language of League.`n`nWould you like to continue? (press Yes or No)
	IfMsgBox No
		return
	else
	{
		Gui, ChangeVO:Add, Text,,
(
Warning: This will change the language for League of Legends. This changes voices and text.
		These changes are made to the following file, 
			\Riot Games\League of Legends\Config\LeagueClientSettings.yaml
		A backup file is kept under the same folder, renamed to the .old extension.
		Not all languages are available for all regions.
Warning: This will cause the league client to download an update to the new language set.
)
		Gui, ChangeVO:Add, DropDownList, vVOchoice, en_US|es_ES|fr_FR|de_DE|it_IT|pl_PL|ko_KR|ro_RO|el_GR|pt_BR|
		Gui, ChangeVO:Add, Button, Default gSetVO, OK
		Gui, ChangeVO:Add, Button, gCancelVO, Cancel
		Gui, ChangeVO:Show
	}
}
return

SetVO:
{
	Gui, ChangeVO:Submit
	IfExist, % RiotBasePath "\Config\LeagueClientSettings.yaml"
	{
		FileRead, LeagueClientSettings, % RiotBasePath "\Config\LeagueClientSettings.yaml"
		LeagueClientSettingsF := RegExReplace(LeagueClientSettings, "i)(locale: .).*(.\R)", "$1" VOchoice "$2")
		FileMove, % RiotBasePath "\Config\LeagueClientSettings.yaml", % RiotBasePath "\Config\LeagueClientSettings.old", 1
		FileAppend, %LeagueClientSettingsF%, % RiotBasePath "\Config\LeagueClientSettings.yaml"
	}
	else
		MsgBox, % "LeagueClientSettings.yaml Not Found. Cannot change voice overs."
}
return

CancelVO:
{
	Gui, ChangeVO:Destroy
}
return

Tools:
{
	;MsgBox % A_ThisMenu "`n`n" A_ThisMenuItem
	If A_ThisMenuItem = ScreenEdge Off
	{
		Menu, Tray, ToggleCheck, ScreenEdge Off
		Menu, Tray, Rename, ScreenEdge Off, ScreenEdge On
		SetTimer, ScreenEdge, 250
	}
	else If A_ThisMenuItem = ScreenEdge On
	{
		Menu, Tray, ToggleCheck, ScreenEdge On
		Menu, Tray, Rename, ScreenEdge On, ScreenEdge Off
		SetTimer, ScreenEdge, Off
		Sleep, 100
		ClipCursor(Confine)
	}
	else If A_ThisMenu = Accounts
	{
		lgn := A_ThisMenuItemPos
		Loop,
		{
			If !(Login%A_Index%)
				break
			Menu, Accounts, UnCheck, % Login%A_Index%
		}
		Menu, Accounts, Check, % Login%lgn%
	}
	else If A_ThisMenu = GroupOrSolo
	{
		If A_ThisMenuItem = Solo
		{
			Menu, GroupOrSolo, Check, Solo
			Menu, GroupOrSolo, UnCheck, Group
			sGroup = 1
		}
		else If A_ThisMenuItem = Group
		{
			Menu, GroupOrSolo, Check, Group
			Menu, GroupOrSolo, UnCheck, Solo
			sGroup = 0
		}
	}
}
return

Sales:
{
	;MsgBox % A_ThisMenu "`n`n" A_ThisMenuItem
	If (A_ThisMenu = "SkinSaleNames")
		SplashImage, %A_ScriptDir%\Data\Skins\%A_ThisMenuItem%_splash.png, M2, %A_ThisMenuItem%, , %A_ThisMenuItem%
}
return

Guides:
{
	;MsgBox % A_ThisMenu "`n`n" A_ThisMenuItem
	CName := A_ThisMenu
	
	;LOLNexus
	StringReplace, n, CName, ', , All
	StringReplace, n, n, `., , All
	StringReplace, n, n, %A_Space%, -, All
	
	;LOLKing
	StringLower, a, CName
	StringReplace, a, a, %A_Space%, , All
	StringReplace, a, a, `., , All
	StringReplace, a, a, ', , All
	
	;ProBuilds
	StringReplace, b, CName, ', %A_Space%, All
	StringReplace, b, b, `., %A_Space%, All
	StringLower, b, b, T
	StringReplace, b, b, %A_space%, , All
	
	;SoloMid
	StringReplace, c, CName, %A_Space%, , All

	;LolCounter
	IfEqual, A_ThisMenuItem, LolCounter, Run, http://lolcounter.com/champions/%n%
	
	;Op.GG
	IFEqual, A_ThisMenuItem, Op.GG, Run, http://na.op.gg/champion/%a%
	
	;MobaFire - Naming convention changed, non conformative new stylem - Test Guide page
	IfEqual, A_ThisMenuItem, MobaFire, Run, http://www.mobafire.com/league-of-legends/%n%-guide
	
	;case sensitive(Lowercase), no punctuation, no spaces
	IfEqual, A_ThisMenuItem, LOLKing, Run, http://www.lolking.net/guides/champion/%a%
	
	;Not case sensitive, spaces become -, no punctuation
	IfEqual, A_ThisMenuItem, LOLNexus, Run, http://www.lolnexus.com/champions/%n%
	
	;Not case sensitive, no spaces, periods left in, ' left in
	IfEqual, A_ThisMenuItem, SoloMid, Run, http://www.solomid.net/guides/%c%
	
	;Case sensitive(title), no spaces, no punctuation
	IfEqual, A_ThisMenuItem, ProBuilds, Run, http://www.probuilds.net/champions/details/%b%
	
	;Not case sensitive
	IfEqual, A_ThisMenuItem, Lol-Game.ru, Run, http://lol-game.ru/guides/%CName%/
	
	;TBD
	IfEqual, A_ThisMenuItem, lol.inven.co.kr, Run, http://lol.inven.co.kr/dataninfo/champion/manualTool.php	
}
return

Streams:
{
	;MsgBox % A_ThisMenu "`n`n" A_ThisMenuItem
	If (A_ThisMenu = "AStreams")
		Run, https://www.azubu.tv/%A_ThisMenuItem%
	Else If (A_ThisMenu = "TStreams")
		Run, http://www.twitch.tv/%A_ThisMenuItem%
}
return

ScreenEdge:
{
	If WinActive("ahk_class RiotWindowClass")
		ClipCursor( Confine, 13, 13, A_screenwidth-13, A_screenheight-13)
}
Return

LoadData:
{
	If ChampList && !(IsObject(ChampDataObj)) && !ChampListLoaded && !ChampListError
	{
		;TrayTip, League Tools %ver%, Getting champion list.
		URL := "https://ddragon.leagueoflegends.com/api/versions.json"
		WebRequest.Open("GET", URL, true)
		WebRequest.Send()
		WebRequest.WaitForResponse()
		VersionDataObj := JSON.Load(WebRequest.ResponseText)
		ChampDataURL := "http://ddragon.leagueoflegends.com/cdn/" VersionDataObj[1] "/data/en_US/champion.json"
		WebRequest.Open("GET", ChampDataURL)
		WebRequest.Send()
		ChampData := WebRequest.ResponseText()
		If ChampData
		{
			Try
				ChampDataObj := JSON.Load(ChampData)
			catch e
				Goto, ChampError
		}
		Else
			Goto ChampError
		
		FreeChampURL := "https://www.championrotation.net/"
		WebRequest.Open("GET", FreeChampURL)
		WebRequest.Send()
		StringReplace, FreeChampData, % WebRequest.ResponseText(), `", , All			;"
		If FreeChampData
		{
			P := 0
			Loop,
			{
				P := RegExMatch(FreeChampData, "i)name itemprop=name>(.*?)<", ChampName, (P + 5))
				If !P
					break
				ChampDataObj.data[ChampName1].freeToPlay := True
			}
		}
		else
			Goto ChampError
		
		MenuSize = 0
		For k, v in ChampDataObj.data
		{
			cID := v.key, cName := v.name, cTitle := v.title
			Menu, %cName%, Add, %cTitle%, Guides
			Menu, %cName%, Disable, %cTitle%
			Menu, %cName%, Add
			Menu, %cName%, Add, OP.GG, Guides
			Menu, %cName%, Add, MobaFire, Guides
			Menu, %cName%, Add, LOLKing, Guides
			Menu, %cName%, Add, LOLNexus, Guides
			Menu, %cName%, Add, SoloMid, Guides
			Menu, %cName%, Add, ProBuilds, Guides
			Menu, %cName%, Add, LolCounter, Guides
		}
		
		For k, v in ChampDataObj.data
			tempList := templist . "`n" . v.name
		
		Menu, GuidesLoading, Delete
		Sort, tempList, U
		Loop, Parse, tempList, `n
		{
			If !A_LoopField
				continue
			If (MenuSize > 790)
			{
				Menu, GuidesLoading, Add, %A_LoopField%, :%A_LoopField%, +BarBreak
				MenuSize = 0
			}
			Else
			{
				Menu, GuidesLoading, Add, %A_LoopField%, :%A_LoopField%
				MenuSize := MenuSize + 20
			}
		}
		Menu, Tray, Insert, Champ Sales, Champ Guides, :GuidesLoading
		;TrayTip, League Tools %ver%, Champion list loaded successfully.
		SetTimer, LoadData, -500
		ChampListLoaded := 1
		return
		
		ChampError:
		TrayTip, League Tools %ver%, There was a problem loading the Champion list.
		ChampListError := 1
		SetTimer, LoadData, -500
		return
	}
	
	If Sales && !(IsObject(ChampDataObj.ChampSales)) && !SkinListLoaded && !SkinListError
	{
		;TrayTip, League Tools %ver%, Getting sales.
		SalesURL := "http://na.leagueoflegends.com/en/news/store/sales"
		WebRequest.Open("GET", SalesURL)
		WebRequest.Send()
		SalesStr := WebRequest.ResponseText()
		StringReplace, SalesStr, SalesStr, ", , All		;"
		Q := 0
		CheckNextSale:
		Q := RegExMatch(SalesStr, "i)a href=/en/news/store/sales/champion-and-skin-sale-(.*?) title", Sdates, Q + 1000)
		If Sdates1
		{
			StringSplit, SalesD, Sdates1, -
			Date1 := A_YYYY . SalesD1 . "00000000"
			Date2 := A_YYYY . SalesD2 . "00000000"
			DateDay1 :=
			DateDay2 :=
			DateDay1 -= Date1, Seconds
			DateDay2 -= Date2, Seconds
			if (DateDay1 > 0 and DateDay2 < 86400)
			{	;Sales Found
				RegExMatch(SalesStr, "i)a href=(/en/news/store/sales/champion-and-skin-sale-.*?) title", CurSales, Q)
				CurSalesURL := "http://na.leagueoflegends.com" CurSales1
				WebRequest.Open("GET", CurSalesURL)
				WebRequest.Send()
				CurSalesStr := WebRequest.ResponseText()
				StringReplace, CurSalesStr, CurSalesStr, ", , All	;"
				RegExMatch(CurSalesStr, "i)(Champion Sales.*?)</div></div>", ChampSales)
				P := 1
				Loop,
				{
					P := RegExMatch(ChampSales1, "i)/loading/(.*?)_0.jpg", ChampName, P + 1)
					RegExMatch(ChampSales1, "i)777777>(.*?)</strike", ChampHiPrice, P + 1)
					RegExMatch(ChampSales1, "i)strike> (.*?)</p>", ChampLoPrice, P + 1)

					If !ChampName1
						break
					else
						ChampDataObj.ChampSales[A_Index] := {SaleName: ChampName1, HiPrice: ChampHiPrice1, LoPrice: ChampLoPrice1}
				}
				
				RegExMatch(CurSalesStr, "i)(Skin Sales.*?)</div></div>", SkinSales)
				P := 1
				Loop,
				{
					P := RegExMatch(SkinSales1, "i)cboxElement href=(.*?)</h4>", SkinName, P + 1)
					If !SkinName1
						break
					else
					{
						RegExMatch(SkinName1, "i)(.*?Splash.jpg)", sURL)
						RegExMatch(SkinName1, "i)img src=(.*?thumb.jpg)", tURL)
						RegExMatch(SkinName1, "i)<h4>(.*)", sName)
						ChampDataObj.SkinSales[A_Index] := {SaleName: sName1, sURL: sURL1, tURL: tURL1}
					}
				}
			}
			else
				Goto, CheckNextSale
		}
		
		Menu, ChampSalesLoading, Delete
		For k, v in ChampDataObj.ChampSales
		{
			Menu, % "Sale" . v.SaleName, Add, % v.HiPrice " ---> " v.LoPrice, Tools
			Menu, ChampSaleNames, Add, % v.SaleName, % ":Sale" v.SaleName
		}
		Menu, Tray, Insert, Skin Sales, Champ Sales, :ChampSaleNames
		
		Menu, SkinSalesLoading, Delete
		For k, v in ChampDataObj.SkinSales
		{
			Menu, SkinSaleNames, Add, % v.SaleName, Sales
		}
		Menu, Tray, Insert, Pro Streams, Skin Sales, :SkinSaleNames
		
		;TrayTip, League Tools %ver%, Sales loaded successfully.
		SetTimer, LoadData, -500
		SkinListLoaded := 1
		return
		
		SalesError:
		;TrayTip, League Tools %ver%, There was a problem loading the sales.
		Sales := 0
		return
	}
	
	;StreamCheck before picture check
	If Streams
	{
		Menu, ProStreamsLoading, NoDefault
		If !ErrorLevel
		{
			;TrayTip, League Tools %ver%, Pro Streams Loading - This should only dislpay once.
			GoSub, StreamCheck
			SetTimer, LoadData, -500
			return
		}
	}
	
	;Check for pictures
	If ChampListLoaded
	{
		;TrayTip, League Tools %ver%, Getting champion icons.
		DDver := ChampDataObj.version
		For k,v in ChampDataObj.data
		{
			n1 := v.id
			n2 := v.name
			IfNotExist, %A_ScriptDir%\Data\ChampIcons\%n1%.png
			{
				urlchamp = http://ddragon.leagueoflegends.com/cdn/%DDver%/img/champion/%n1%.png
				UrlDownloadToFile, %urlchamp%, %A_ScriptDir%\Data\ChampIcons\%n1%.png
				If ErrorLevel
					CIconErr := 1
			}
			If v.freeToPlay
			{
				Menu, GuidesLoading, Icon, %n2%, %A_ScriptDir%\Data\ChampIcons\%n1%.png,,30
				MenuSize := MenuSize + 30
			}
			else
			{
				Menu, GuidesLoading, Icon, %n2%, %A_ScriptDir%\Data\ChampIcons\%n1%.png,,20
				MenuSize := MenuSize + 20
			}
		}
		Loop % ChampDataObj.ChampSales.Length()
		{
			sName := ChampDataObj.ChampSales[A_Index].SaleName
			Menu, ChampSaleNames, Icon, %sName%, %A_ScriptDir%\Data\ChampIcons\%sName%.png
		}
		;TrayTip, League Tools %ver%, Champ Icons downloaded.
	}
	
	;Skin download
	If SkinListLoaded
	{
		;TrayTip, League Tools %ver%, Getting skin icons.
		Loop % ChampDataObj.SkinSales.Length()
		{
			sName := ChampDataObj.SkinSales[A_Index].SaleName
			sURL := ChampDataObj.SkinSales[A_Index].sURL
			tURL := ChampDataObj.SkinSales[A_Index].tURL

			If !(FileExist(A_ScriptDir "\Data\Skins\" sName "_splash.png"))
				UrlDownloadToFile, % ChampDataObj.SkinSales[A_Index].sURL, %A_ScriptDir%\Data\Skins\%sName%_splash.png
			If !(FileExist(A_ScriptDir "\Data\Skins\" sName "_thumb.png"))
				UrlDownloadToFile, % ChampDataObj.SkinSales[A_Index].tURL, %A_ScriptDir%\Data\Skins\%sName%_thumb.png
			If ErrorLevel
				SIconErr := 1
			Menu, SkinSaleNames, Icon, %sName%, %A_ScriptDir%\Data\Skins\%sName%_thumb.png,,20
		}
		;TrayTip, League Tools %ver%, Skin icons downloaded.
	}
		
	SetTimer, UpdateCheck, -1000
}
return

StreamCheck:
{
	/* Example Calls
	'twitch': 'https://api.twitch.tv/kraken/streams?game=League+of+Legends&limit=100',
	'azubu': 'http://api.azubu.tv/public/channel/live/list/game/league-of-legends',
	'hitbox': 'http://api.hitbox.tv/media/live/list',
	'youtube': 'https://gdata.youtube.com/feeds/api/users/lolchampseries/live/events?v=2&itemsPerPage=100&inline=true&alt=json&status=active'
	*/
	
	TwitchURL := "https://api.twitch.tv/kraken/streams?game=League+of+Legends&limit=100&stream_type=live&client_id=pbta8w0375tir2u2victdhoe6ip4bbk"
	WebRequest.Open("GET", TwitchURL)
	WebRequest.Send()
	TwitchData := WebRequest.ResponseText()
	Try
		TwitchDataObj := JSON.Load(TwitchData)
	catch e
		TrayTip, League Tools %ver%, There was a problem loading Twitch streamers.
	
	;Create Menus and Attach
	Menu, TStreams, Delete
	Menu, AStreams, Delete
	Menu, ProStreamsLoading, Delete
	Menu, Pro Streams, Delete
	
	MenuSize = 0
	Loop % TwitchDataObj.streams.MaxIndex()
	{
		If (MenuSize > 620)
		{
			Menu, TStreams, Add, % TwitchDataObj.streams[A_Index].channel.name, Streams, +BarBreak
			MenuSize = 0
		}
		Else
		{
			Menu, TStreams, Add, % TwitchDataObj.streams[A_Index].channel.name, Streams
			MenuSize := MenuSize + 20
		}
	}
	
	Menu, Pro Streams, Add, AzubuTV, :AStreams
	Menu, Pro Streams, Add, TwitchTV, :TStreams
	;Menu, Tray, Insert, Login, Pro Streams, :Pro Streams
	Menu, Tray, Insert, Select Account, Pro Streams, :Pro Streams
	SetTimer, StreamCheck, -100000
}
return

UpdateCheck:
{
	;AHK Core Update check
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "https://autohotkey.com/download/1.1/version.txt", true)
	whr.Send()
	whr.WaitForResponse()
	version1 := whr.ResponseText
	ver1 := A_AhkVersion
	If !(Version1 = ver1)
		Traytip, League Tools %ver%, Core AHK update available, 2
	
	;Script update check
	UpdateURL := "https://autohotkey.com/boards/viewtopic.php?f=19&t=10818"
	WebRequest.Open("GET", UpdateURL, true)
	WebRequest.Send()
	WebRequest.WaitForResponse()
	Data := WebRequest.ResponseText()
	RegExMatch(Data, "i)<title>League Tools (.*?) ", Version)
	
	If !(Version1 = ver)
		Traytip, League Tools %ver%, League Tools update available!, 2
}
return

SettingsSub:
{
	Gui, Settings: New, -SysMenu, League Tools %ver%

	Gui, Settings: Add, Text, x10 y10 w60 h20 +0x200, Hotkeys:
	Gui, Settings: Add, Text, x35 y30 w60 h20 +0x200, Login 1:
	Gui, Settings: Add, Edit, x130 y30 w60 h20 vLogin1Key, %Login1Key%
	Gui, Settings: Add, Text, x35 y50 w60 h20 +0x200, Login 2:
	Gui, Settings: Add, Edit, x130 y50 w60 h20 vLogin2Key, %Login2Key%
	Gui, Settings: Add, Text, x35 y70 w60 h20 +0x200, Login 3:
	Gui, Settings: Add, Edit, x130 y70 w60 h20 vLogin3Key, %Login3Key%
	Gui, Settings: Add, Text, x35 y90 w75 h20 +0x200, Restart Queue:
	Gui, Settings: Add, Edit, x130 y90 w60 h20 vReStartQKey, %ReStartQKey%
	Gui, Settings: Add, Text, x35 y110 w75 h20 +0x200, Reload Script:
	Gui, Settings: Add, Edit, x130 y110 w60 h20 vReloadKey, %ReloadKey%

	Gui, Settings: Add, Text, x35 y160 w60 h20 +0x200, Region
	Reg := "NA"
	RegList := "RU|TR|BR|OCE|LAS|EUNE|EUW|NA|KR|LAN|"
	If Reg
	{
		selReg := Reg . "|"
		StringReplace, RegList, RegList, %selReg%, , All
		selReg := Reg . "||"
		RegList := Reglist . selReg
	}
	Gui, Settings: Add, DropDownList, x128 y160 w60 Sort vReg, %RegList%
	
	Gui, Settings: Add, Text, x35 y180 w60 h20 +0x200, Locale
	Loc := "en_US"
	LocList := "en_US|es_ES|fr_FR|de_DE|it_IT|pl_PL|ko_KR|ro_RO|el_GR|pt_BR|"
	If Loc
	{
		selLoc := Loc . "|"
		StringReplace, LocList, LocList, %selLoc%, , All
		selLoc := Loc . "||"
		LocList := LocList . selLoc
	}
	Gui, Settings: Add, DropDownList, x128 y180 w60 Sort vLoc, %LocList%
	
	Gui, Settings: Add, Text, x10 y210 w60 h20 +0x200, Defaults:
	Gui, Settings: Add, Text, x35 y230 w75 h20 +0x200, Default Login
	Gui, Settings: Add, Edit, x130 y230 w60 h20 vLgn, %lgn%
	Gui, Settings: Add, Text, x35 y250 w75 h20 +0x200, Queue Wait(ms)
	Gui, Settings: Add, Edit, x130 y250 w60 h20 vQueueWaitTime, %QueueWaitTime%
	
	Gui, Settings: Add, Text, x10 y280 h20 +0x200, Toaster Mode: (1 = Don't load this)
	Gui, Settings: Add, Text, x35 y300 w75 h20 +0x200, ChampList
	Gui, Settings: Add, Edit, x130 y300 w60 h20 vToaster, %ChampList%
	Gui, Settings: Add, Text, x35 y320 w75 h20 +0x200, Streams
	Gui, Settings: Add, Edit, x130 y320 w60 h20 vStreams, %Streams%
	
	Gui, Settings: Add, Text, x35 y340 w75 h20 +0x200, Sales
	Gui, Settings: Add, Edit, x130 y340 w60 h20 vSales, %Sales%
	
	Gui, Settings: Add, Text, x200 y8 w130 h20 +0x200, Login Information:
	Gui, Settings: Add, Listview, x224 y32 w249 h300 gLoginChange AltSubmit -Hdr, Auto Login Information:|Pass
	LV_ModifyCol(2, 1)
	Loop,
	{
		If !Login%A_Index%
			break
		LV_Add(, Login%A_Index%, Pass%A_Index%)
	}
	
	Gui, Settings: Add, Button, x225 y335 w60 h15 gLoginAdd, Add
	Gui, Settings: Add, Button, x295 y335 w60 h15 gLoginRemove, Remove
	
	Gui, Settings: Add, Button, x304 y392 w80 h23 gSettingsOK, &OK
	Gui, Settings: Add, Button, x392 y392 w80 h23 gSettingsCancel, &Cancel
	
	Gui, Settings: Show, w481 h424
	WinWaitClose, League Tools
}
return

SettingsOK:
{
	Gui, Settings: Submit
	;Verify good results before writing
	If !NewLoginKey1
		NewLoginKey1 := "F7"
	If !NewLoginKey2
		NewLoginKey2 := "F8"
	If !NewLoginKey3
		NewLoginKey3 := "F9"
	If !ReStartQKey
		ReStartQKey := "F10"
	If !ReloadSubKey
		ReloadSubKey := "F12"
	
	;Write good results and destroy the unnecessary GUI elements
	GoSub, WriteSettings
	GoSub, ReadSettings
	
	Gui, Settings: Destroy
	Menu, Accounts, Delete
	;Menu, Login, Delete
	;Menu, Group or Solo, Delete
	Loop,
	{
		If Login%A_Index%
			Menu, Accounts, Add, % Login%A_Index%, Tools
		else
			break
	}
	
	;Menu, Tray, Insert, Screenedge Off, Auto Start, :AutoSelection
	;Menu, Tray, Insert, Screenedge On, Auto Start, :AutoSelection
	;Menu, Tray, Insert, Auto Start, Group or Solo, :GroupOrSolo
	;Menu, Tray, Insert, Group or Solo, Login Only, LoginOnly
	Menu, Tray, Insert, Login, Select Account, :Accounts
}
return

SettingsCancel:
{
	Gui, Settings: Destroy
}
return

LoginChange:
{
	If (A_GuiEvent = "DoubleClick")
	{
		LoginNum := A_EventInfo
		Gui +OwnDialogs
		InputBox, Login%LoginNum%, League Tools %ver%, Enter new username
		If ErrorLevel
			return
		InputBox, Pass%LoginNum%, League Tools %ver%, Enter new password, HIDE
		If ErrorLevel
			return
		
		If (Login%LoginNum%) && (Pass%LoginNum%)
		{
			ObfPass := Obf(Pass%LoginNum%, 1, 1234)
			LV_Modify(LoginNum, , Login%LoginNum%, ObfPass)
		}
	}
	
	If (A_GuiEvent = "Normal")
		global SelectedRow := A_EventInfo
}
return

LoginAdd:
{
	Gui +OwnDialogs
	InputBox, Login, League Tools %ver%, Enter new username
	InputBox, Pass, League Tools %ver%, Enter new password, HIDE
	ObfPass := Obf(Pass, 1, 1234)
	LV_Add(, Login, ObfPass)
}
return

LoginRemove:
{
	If SelectedRow = 0
		return
	LV_Delete(SelectedRow)
	SelectedRow := 0
}
return

ReloadSub:
{
	GoSub, WriteSettings
	reload
}
return

ExitSub:
{
	GoSub, WriteSettings
	ExitApp
}
return

SetFirstRun:
{
	IfNotExist, %A_ScriptDir%\Data
	{
		FileCreateDir, %A_ScriptDir%\Data
		FileCreateDir, %A_ScriptDir%\Data\Skins
		FileCreateDir, %A_ScriptDir%\Data\ChampIcons
	}
	config=
(
[Login1]
Username=
Password=
[Login2]
Username=
Password=
[Login3]
Username=
Password=
[Region]
Reg=%Reg%
[Locale]
Loc=%Loc%
[DefaultLogin]
lgn=1
[QueueTime]
QueueWaitTime=300
[Toaster]
ChampList=1
Sales=1
Streams=1
[Hotkeys]
Login1Key=F7
Login2Key=F8
Login3Key=F9
ReStartQKey=F10
ReloadKey=F12
)
	FileAppend, %config%, %A_ScriptDir%\Data\Config.Ini
}
return

ReadSettings:
{
	IniRead, Reg, %A_ScriptDir%\Data\Config.ini, Region, Reg
	IniRead, Loc, %A_ScriptDir%\Data\Config.ini, Locale, Loc
	IniRead, lgn, %A_ScriptDir%\Data\Config.ini, DefaultLogin, lgn, 1
	IniRead, QueueWaitTime, %A_ScriptDir%\Data\Config.ini, QueueTime, QueueWaitTime, 500
	IniRead, Key1, %A_ScriptDir%\Data\Config.ini, Keys, Key1
	IniRead, Login1Key, %A_ScriptDir%\Data\Hotkeys.ini, Hotkeys, Login1Key, F7
	IniRead, Login2Key, %A_ScriptDir%\Data\Hotkeys.ini, Hotkeys, Login2Key, F8
	IniRead, Login3Key, %A_ScriptDir%\Data\Hotkeys.ini, Hotkeys, Login3Key, F9
	IniRead, ReStartQKey, %A_ScriptDir%\Data\Hotkeys.ini, Hotkeys, ReStartQKey, F10
	IniRead, ReloadKey, %A_ScriptDir%\INI\Data\Hotkeys.ini, Hotkeys, ReloadKey, F12
	
	IniRead, ChampList, %A_ScriptDir%\Data\Config.ini, Toaster, ChampList, 1
	IniRead, Streams, %A_ScriptDir%\Data\Config.ini, Toaster, Streams, 1
	IniRead, Sales, %A_ScriptDir%\Data\Config.ini, Toaster, Sales, 1
	
	Loop,
	{
		IniRead, Login%A_Index%, %A_ScriptDir%\Data\Config.ini, Login%A_Index%, Username
		IniRead, Pass%A_Index%, %A_ScriptDir%\Data\Config.ini, Login%A_Index%, Password
		IfInString, Login%A_Index%, ERROR
		{
			Login%A_Index% := 
			break
		}
		else
			Login[A_Index] := {Name: Login%A_Index%, Pass: Pass%A_Index%}
	}
}
return

WriteSettings:
{
	IniWrite, %Login1Key%, %A_ScriptDir%\Data\Config.ini, HotKeys, Login1Key
	IniWrite, %Login2Key%, %A_ScriptDir%\Data\Config.ini, HotKeys, Login2Key
	IniWrite, %Login3Key%, %A_ScriptDir%\Data\Config.ini, HotKeys, Login3Key
	IniWrite, %ReStartQKey%, %A_ScriptDir%\Data\Config.ini, HotKeys, ReStartQKey
	IniWrite, %ReloadKey%, %A_ScriptDir%\Data\Config.ini, HotKeys, ReloadKey
	
	IniWrite, %Reg%, %A_ScriptDir%\Data\Config.ini, Region, Reg
	IniWrite, %Loc%, %A_ScriptDir%\Data\Config.ini, Locale, Loc
	IniWrite, %lgn%, %A_ScriptDir%\Data\Config.ini, DefaultLogin, lgn
	IniWrite, %QueueWaitTime%, %A_ScriptDir%\Data\Config.ini, QueueTime, QueueWaitTime
	
	IniWrite, %ChampList%, %A_ScriptDir%\Data\Config.ini, Toaster, ChampList
	IniWrite, %Sales%, %A_ScriptDir%\Data\Config.ini, Toaster, Sales
	IniWrite, %Streams%, %A_ScriptDir%\Data\Config.ini, Toaster, Streams
	
	IniWrite, %Key1%, %A_ScriptDir%\Data\Config.ini, Keys, Key1
	Loop,
	{
		LV_GetText(Login, A_Index, 1)
		If !Login
			break
		LV_GetText(Pass, A_Index, 2)
		IniWrite, %Login%, %A_ScriptDir%\Data\Config.ini, Login%A_Index%, Username
		IniWrite, %Pass%, %A_ScriptDir%\Data\Config.ini, Login%A_Index%, Password
	}
}
return

ColorCross(x, y, col, v)
{
	PixelGetColor, b, x, (y + 2), RGB
	PixelGetColor, c, x, (y - 2), RGB
	PixelGetColor, d, (x + 2), y, RGB
	PixelGetColor, e, (x - 2), y, RGB
	CDA := Distance(col, b)
	CDB := Distance(col, c)
	CDC := Distance(col, d)
	CDD := Distance(col, e)
	
	if (CDA < v and CDB < v and CDC < v and CDD < v)
		return True
	Else
		return False
}

Distance(c1, c2)
{ ; function by [VxE], return value range = [0, 441.67295593006372]
   return Sqrt((((c1>>16)-(c2>>16))**2)+(((c1>>8&255)-(c2>>8&255))**2)+(((c1&255)-(c1&255))**2))
}

Obf(x,y,Seed=12345)
{
	String=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890 -=.,?':;/\!@#$`%^&*()_+|
	Random, ,Seed
	Loop, Parse, x
	{
		Pos:=InStr(String,A_LoopField,1)
		Random, Offset , 1, 86
		Coded.=SubStr(String, y ? (Pos+Offset)>86 ? Pos+Offset-86 : Pos+Offset : (Pos-Offset)<1 ? Pos-Offset+86 : Pos-Offset,1)
	}
	Return Coded
}

ClipCursor(Confine=True, x1=0 , y1=0, x2=1920, y2=1080) 
{
	VarSetCapacity(R,16,0), NumPut(x1,&R+0),NumPut(y1,&R+4),NumPut(x2,&R+8),NumPut(y2,&R+12)
	Return Confine ? DllCall( "ClipCursor", UInt,&R ) : DllCall( "ClipCursor" )
}

class JSON
{
	class Load extends JSON.Functor
	{
		Call(self, ByRef text, reviver:="")
		{
			this.rev := IsObject(reviver) ? reviver : false
			this.keys := this.rev ? {} : false

			static quot := Chr(34), bashq := "\" . quot
			     , json_value := quot . "{[01234567890-tfn"
			     , json_value_or_array_closing := quot . "{[]01234567890-tfn"
			     , object_key_or_object_closing := quot . "}"

			key := ""
			is_key := false
			root := {}
			stack := [root]
			next := json_value
			pos := 0

			while ((ch := SubStr(text, ++pos, 1)) != "") {
				if InStr(" `t`r`n", ch)
					continue
				if !InStr(next, ch, 1)
					this.ParseError(next, text, pos)

				holder := stack[1]
				is_array := holder.IsArray

				if InStr(",:", ch) {
					next := (is_key := !is_array && ch == ",") ? quot : json_value

				} else if InStr("}]", ch) {
					ObjRemoveAt(stack, 1)
					next := stack[1]==root ? "" : stack[1].IsArray ? ",]" : ",}"

				} else {
					if InStr("{[", ch) {
						static json_array := Func("Array").IsBuiltIn || ![].IsArray ? {IsArray: true} : 0
					
						(ch == "{")
							? ( is_key := true
							  , value := {}
							  , next := object_key_or_object_closing )
						; ch == "["
							: ( value := json_array ? new json_array : []
							  , next := json_value_or_array_closing )
						
						ObjInsertAt(stack, 1, value)

						if (this.keys)
							this.keys[value] := []
					
					} else {
						if (ch == quot) {
							i := pos
							while (i := InStr(text, quot,, i+1)) {
								value := StrReplace(SubStr(text, pos+1, i-pos-1), "\\", "\u005c")

								static tail := A_AhkVersion<"2" ? 0 : -1
								if (SubStr(value, tail) != "\")
									break
							}

							if (!i)
								this.ParseError("'", text, pos)

							  value := StrReplace(value,  "\/",  "/")
							, value := StrReplace(value, bashq, quot)
							, value := StrReplace(value,  "\b", "`b")
							, value := StrReplace(value,  "\f", "`f")
							, value := StrReplace(value,  "\n", "`n")
							, value := StrReplace(value,  "\r", "`r")
							, value := StrReplace(value,  "\t", "`t")

							pos := i ; update pos
							
							i := 0
							while (i := InStr(value, "\",, i+1)) {
								if !(SubStr(value, i+1, 1) == "u")
									this.ParseError("\", text, pos - StrLen(SubStr(value, i+1)))

								uffff := Abs("0x" . SubStr(value, i+2, 4))
								if (A_IsUnicode || uffff < 0x100)
									value := SubStr(value, 1, i-1) . Chr(uffff) . SubStr(value, i+6)
							}

							if (is_key) {
								key := value, next := ":"
								continue
							}
						
						} else {
							value := SubStr(text, pos, i := RegExMatch(text, "[\]\},\s]|$",, pos)-pos)

							static number := "number", integer :="integer"
							if value is %number%
							{
								if value is %integer%
									value += 0
							}
							else if (value == "true" || value == "false")
								value := %value% + 0
							else if (value == "null")
								value := ""
							else
								this.ParseError(next, text, pos, i)

							pos += i-1
						}

						next := holder==root ? "" : is_array ? ",]" : ",}"
					} ; If InStr("{[", ch) { ... } else

					is_array? key := ObjPush(holder, value) : holder[key] := value

					if (this.keys && this.keys.HasKey(holder))
						this.keys[holder].Push(key)
				}
			
			} ; while ( ... )

			return this.rev ? this.Walk(root, "") : root[""]
		}

		ParseError(expect, ByRef text, pos, len:=1)
		{
			static quot := Chr(34), qurly := quot . "}"
			
			line := StrSplit(SubStr(text, 1, pos), "`n", "`r").Length()
			col := pos - InStr(text, "`n",, -(StrLen(text)-pos+1))
			msg := Format("{1}`n`nLine:`t{2}`nCol:`t{3}`nChar:`t{4}"
			,     (expect == "")     ? "Extra data"
			    : (expect == "'")    ? "Unterminated string starting at"
			    : (expect == "\")    ? "Invalid \escape"
			    : (expect == ":")    ? "Expecting ':' delimiter"
			    : (expect == quot)   ? "Expecting object key enclosed in double quotes"
			    : (expect == qurly)  ? "Expecting object key enclosed in double quotes or object closing '}'"
			    : (expect == ",}")   ? "Expecting ',' delimiter or object closing '}'"
			    : (expect == ",]")   ? "Expecting ',' delimiter or array closing ']'"
			    : InStr(expect, "]") ? "Expecting JSON value or array closing ']'"
			    :                      "Expecting JSON value(string, number, true, false, null, object or array)"
			, line, col, pos)

			static offset := A_AhkVersion<"2" ? -3 : -4
			throw Exception(msg, offset, SubStr(text, pos, len))
		}

		Walk(holder, key)
		{
			value := holder[key]
			if IsObject(value) {
				for i, k in this.keys[value] {
					v := this.Walk(value, k)
					if (v != JSON.Undefined)
						value[k] := v
					else
						ObjDelete(value, k)
				}
			}
			
			return this.rev.Call(holder, key, value)
		}
	}

	class Dump extends JSON.Functor
	{
		Call(self, value, replacer:="", space:="")
		{
			this.rep := IsObject(replacer) ? replacer : ""

			this.gap := ""
			if (space) {
				static integer := "integer"
				if space is %integer%
					Loop, % ((n := Abs(space))>10 ? 10 : n)
						this.gap .= " "
				else
					this.gap := SubStr(space, 1, 10)

				this.indent := "`n"
			}

			return this.Str({"": value}, "")
		}

		Str(holder, key)
		{
			value := holder[key]

			if (this.rep)
				value := this.rep.Call(holder, key, ObjHasKey(holder, key) ? value : JSON.Undefined)

			if IsObject(value) {
				static type := A_AhkVersion<"2" ? "" : Func("Type")
				if (type ? type.Call(value) == "Object" : ObjGetCapacity(value) != "") {
					if (this.gap) {
						stepback := this.indent
						this.indent .= this.gap
					}

					is_array := value.IsArray
					if (!is_array) {
						for i in value
							is_array := i == A_Index
						until !is_array
					}

					str := ""
					if (is_array) {
						Loop, % value.Length() {
							if (this.gap)
								str .= this.indent
							
							v := this.Str(value, A_Index)
							str .= (v != "") ? v . "," : "null,"
						}
					} else {
						colon := this.gap ? ": " : ":"
						for k in value {
							v := this.Str(value, k)
							if (v != "") {
								if (this.gap)
									str .= this.indent

								str .= this.Quote(k) . colon . v . ","
							}
						}
					}

					if (str != "") {
						str := RTrim(str, ",")
						if (this.gap)
							str .= stepback
					}

					if (this.gap)
						this.indent := stepback

					return is_array ? "[" . str . "]" : "{" . str . "}"
				}
			
			} else ; is_number ? value : "value"
				return ObjGetCapacity([value], 1)=="" ? value : this.Quote(value)
		}

		Quote(string)
		{
			static quot := Chr(34), bashq := "\" . quot

			if (string != "") {
				  string := StrReplace(string,  "\",  "\\")
				, string := StrReplace(string, quot, bashq)
				, string := StrReplace(string, "`b",  "\b")
				, string := StrReplace(string, "`f",  "\f")
				, string := StrReplace(string, "`n",  "\n")
				, string := StrReplace(string, "`r",  "\r")
				, string := StrReplace(string, "`t",  "\t")

				static rx_escapable := A_AhkVersion<"2" ? "O)[^\x20-\x7e]" : "[^\x20-\x7e]"
				while RegExMatch(string, rx_escapable, m)
					string := StrReplace(string, m.Value, Format("\u{1:04x}", Ord(m.Value)))
			}

			return quot . string . quot
		}
	}

	Undefined[]
	{
		get {
			static empty := {}, vt_empty := ComObject(0, &empty, 1)
			return vt_empty
		}
	}

	class Functor
	{
		__Call(method, ByRef arg, args*)
		{
			if IsObject(method)
				return (new this).Call(method, arg, args*)
			else if (method == "")
				return (new this).Call(arg, args*)
		}
	}
}

F12::
	reload
