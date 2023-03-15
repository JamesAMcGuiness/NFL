
	<cfset Session.avGameRating = 0>
	<cfset Session.avLuckFactor = 0>
	<cfset Session.avMOVPlusGameRat = 0>
	<cfset Session.avMOV = 0>
	<cfset Session.avYPPDif = 0>
	<cfset Session.avPavgDif = 0>
	<cfset Session.avRavgDif = 0>
	<cfset Session.avTOPDif = 0> 	
	
	
<cfquery name="GetSpds" datasource="sysstats3" >
SELECT n.*
FROM NFLSPDS n, Week w
where n.week = w.week
</cfquery>
 
<cfset theweek = GetSpds.week>


<cfquery datasource="SYSSTATS3" name="delit">
	DELETE FROM AVGGameInsights where week = #theweek#
</cfquery>

<cfquery datasource="SYSSTATS3" name="delit">
	DELETE FROM TotalsStats where week = #theweek# + 1
</cfquery>


<cfset thepriorweek = theweek -1>

<cfset theyr   = GetSpds.yr>
 
<cfloop query="Getspds">
	<cfset theGameTime = "#GetSpds.GameTime#">
	<cfset myfav       = "#Getspds.fav#">
	<cfset myund       = "#GetSpds.und#">
	<cfset ha          = "#GetSpds.ha#">
	<cfset spd         = "#GetSpds.spread#">
	<cfset mydate      = "#GetSpds.Gametime#">

	<cfif ha is 'H'>
		<cfset HomeTeamForLoad = '#FAV#'>
	<cfelse>
		<cfset HomeTeamForLoad = '#UND#'>
	</cfif>

	<cfset temp = createHomeFieldADV(#theweek# - 1,'#myfav#')>
	<cfset temp = createHomeFieldADV(#theweek# - 1,'#myund#')>
	<cfset temp = checkTravel(#theweek#,'#myfav#','#myund#')>

	<cfquery datasource="sysstats3" name="delit">
	DELETE FROM SYSSTATS
	WHERE WEEK = #theweek#
	and yr = #theyr#
	and Team in ('#myfav#','#myund#')
	</cfquery>
	
	<cfquery datasource="sysstats3" name="delit">
	DELETE FROM GameInsights
	WHERE WEEK = #theweek#
	and yr = #theyr#
	and Team in ('#myfav#','#myund#')
	</cfquery>
	
	<cfset uha = 'A'>
	<cfif ha is 'A'>
		<cfset uha = 'H'>
	</cfif>

	<cfset tmp = SetTeamNames('#myfav#','#ha#','F')>
	<cfset tmp = SetTeamNames('#myund#','#uha#','U')>

	<cfset HomeConseqAboveExpCt = 0>
	<cfset HomeConseqBelowExpCt = 0>
	
	<cfset AwayConseqAboveExpCt = 0>
	<cfset AwayConseqBelowExpCt = 0>
 	
	<cfoutput>
	#myfav#.....#myund#<br>	
	</cfoutput>		
	
	<cfif theweek gt 1>
		
		<cfquery name="GetPriorHome" datasource="sysstats3" >
			SELECT ConseqAboveExpCt, ConseqBelowExpCt
			FROM GameInsights
			where week = #thepriorweek#
			and Team = '#Session.SpdHomeTeam#'
		</cfquery>

		<cfquery name="GetPriorAway" datasource="sysstats3" >
			SELECT ConseqAboveExpCt, ConseqBelowExpCt
			FROM GameInsights
			where week = #thepriorweek#
			and Team = '#Session.SpdAwayTeam#'
		</cfquery>
		
		<cfif GetPriorHome.recordcount gt 0>
			<cfset HomeConseqAboveExpCt = GetPriorHome.ConseqAboveExpCt>
			<cfset HomeConseqBelowExpCt = GetPriorHome.ConseqBelowExpCt>
		</cfif>
		
		<cfif GetPriorAway.recordcount gt 0>
			<cfset AwayConseqAboveExpCt = GetPriorAway.ConseqAboveExpCt>
			<cfset AwayConseqBelowExpCt = GetPriorAway.ConseqBelowExpCt>
		</cfif>
		
	</cfif>	

	<cfset changeitto = lcase(HomeTeamForLoad)>
	<cfswitch expression="#HomeTeamForLoad#">
		<CfcASE VALUE="TEN">
			<cfset changeitto = 'oti'>
		</cfcase>
		<CfcASE VALUE="LAC">
			<cfset changeitto = 'sdg'>
		</cfcase>
		<CfcASE VALUE="NE">
			<cfset changeitto = 'nwe'>
		</cfcase>
		<CfcASE VALUE="IND">
			<cfset changeitto = 'clt'>
		</cfcase>
		<CfcASE VALUE="NO">
			<cfset changeitto = 'nor'>
		</cfcase>
		<CfcASE VALUE="KC">
			<cfset changeitto = 'kan'>
		</cfcase>
		<CfcASE VALUE="SF">
			<cfset changeitto = 'sfo'>
		</cfcase>
		<CfcASE VALUE="LAR">
			<cfset changeitto = 'ram'>
		</cfcase>
		<CfcASE VALUE="HOU">
			<cfset changeitto = 'htx'>
		</cfcase>
		<CfcASE VALUE="OAK">
			<cfset changeitto = 'rai'>
		</cfcase>
		<CfcASE VALUE="BAL">
			<cfset changeitto = 'rav'>
		</cfcase>
		<CfcASE VALUE="ARZ">
			<cfset changeitto = 'crd'>
		</cfcase>
		<CfcASE VALUE="TB">
			<cfset changeitto = 'tam'>
		</cfcase>
		<CfcASE VALUE="GB">
			<cfset changeitto = 'gnb'>
		</cfcase>



	</cfswitch>


<cfset myurl       = 'https://www.pro-football-reference.com/boxscores/#mydate#0#changeitto#.htm'>

<cfoutput>
#myurl#
</cfoutput>



	
	<cfhttp url="#myurl#" method="GET" resolveurl="false">
	</cfhttp>

<cfset thepage = '#cfhttp.filecontent#'>



************************************************************ Score *********************************************************************************************************
<cfset LookFor  = '#Session.ScoreAwayTeam#</a>'> 

<cfoutput>
Looking for awayteam: #Lookfor#<br>
</cfoutput>

<cfset startpos = 1>
<cfset TeamStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>
<cfset StartPos = TeamStartPos>


<cfoutput>
Team Total Start found at pos #TeamStartPos#
</cfoutput>


<cfset LeftSideString   = '<td class="right">'>
<cfset RightSideString  = '</td>'>
<cfset aScore = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LookFor  = '#Session.ScoreHomeTeam#</a>'> 
<cfoutput>
Looking for hometeam: #Lookfor#<br>
</cfoutput>

<cfset TeamStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
Team Total Start found at pos #TeamStartPos#
</cfoutput>

<cfset startpos = TeamStartPos>
<cfset LeftSideString   = '<td class="right">'>
<cfset RightSideString  = '</td>'>
<cfset hScore = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfoutput>
#Session.SpdAwayTeam# - #aScore#<br>
#Session.SpdHomeTeam# - #hScore#<br>
</cfoutput>


************************************************************ First Downs *********************************************************************************************************
<cfset LookFor  = 'First Downs'> 
<cfset startpos = 1>
<cfset TeamStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
Team Total Start found at pos #TeamStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = TeamStartPos>

<cfset aFDs = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hFDs = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>

<cfoutput>
#afds#<br>
#hfds#<br>
</cfoutput>

************************************************************ Rush-Yds-TDs *********************************************************************************************************
<cfset LookFor  = 'Rush-Yds-TDs'> 
<cfset TeamStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #TeamStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = TeamStartPos>

<cfset aRYTD = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hRYTD = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>

<cfoutput>
#arytd#<br>
#hrytd#<br>
</cfoutput>



**** Parse out Rush-Yds-TDs **** 5-56-1  or 5-100-1  or 10-56-1 or 10-100-1
<cfset xStartPos = 1>
<cfset LookFor  = '#aRYTD#'> 
<cfset DashFoundPos1 = Find('-','#aRYTD#',xStartPos)>

<cfoutput>
#arytd#<br>
</cfoutput>



<cfset aRushes = mid(LookFor,xStartPos,DashFoundPos1 - 1)>

<cfset xStartPos = DashFoundPos1 + 1>

<cfset DashFoundPos2 = Find('-','#aRYTD#',xStartPos)>
<cfset aRYds = mid(LookFor,xStartPos,(DashFoundPos2 - DashFoundPos1)-1)>

<cfoutput>
#arushes#<br>
#aryds#<br>
</cfoutput>



<cfset aRavg = Val(aRyds) / Val(aRushes)>


<cfset xStartPos = 1>
<cfset LookFor  = '#hRYTD#'> 
<cfset DashFoundPos1 = Find('-','#hRYTD#',xStartPos)>
<cfset hRushes = mid(LookFor,xStartPos,DashFoundPos1 - 1)>

<cfset xStartPos = DashFoundPos1 + 1>

<cfset DashFoundPos2 = Find('-','#hRYTD#',xStartPos)>
<cfset hRYds = mid(LookFor,xStartPos,(DashFoundPos2 - DashFoundPos1)-1)>

<cfset hRavg = Val(hRyds) / Val(hRushes)>

<cfoutput>
#hrushes#<br>
#hryds#<br>
#hravg#<br>
#aravg#<br>
</cfoutput>



************************************************************ Cmp-Att-Yd-TD-INT *********************************************************************************************************
<cfset LookFor  = 'Cmp-Att-Yd-TD-INT'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfset aCmpAttYdTDINT = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hCmpAttYdTDINT = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>


**** Parse out Cmp-Att-Yd-TD-INT
<cfset xStartPos = 1>
<cfset LookFor  = '#aCmpAttYdTDINT#'> 
<cfset DashFoundPos1 = Find('-','#aCmpAttYdTDINT#',xStartPos)>
<cfset aCmp = mid(LookFor,xStartPos,DashFoundPos1 - 1)>

<cfset xStartPos = DashFoundPos1 + 1>

<cfset DashFoundPos2 = Find('-','#aCmpAttYdTDINT#',xStartPos)>
<cfset aAtt = mid(LookFor,xStartPos,(DashFoundPos2 - DashFoundPos1)-1)>

<cfset xStartPos = DashFoundPos2 + 1>
<cfset DashFoundPos3 = Find('-','#aCmpAttYdTDINT#',xStartPos)>

<cfset aPassYds = mid(LookFor,xStartPos,(DashFoundPos3 - DashFoundPos2)-1)>

<cfset xStartPos = DashFoundPos3 + 1>
<cfset DashFoundPos4 = Find('-','#aCmpAttYdTDINT#',xStartPos)>

<cfset aPassTDs = mid(LookFor,xStartPos,(DashFoundPos4 - DashFoundPos3)-1)>
<cfset aPassINT = mid(LookFor,DashFoundPos4+1,2)>
       

**** Parse out Cmp-Att-Yd-TD-INT
<cfset xStartPos = 1>
<cfset LookFor  = '#hCmpAttYdTDINT#'> 
<cfset DashFoundPos1 = Find('-','#hCmpAttYdTDINT#',xStartPos)>
<cfset hCmp = mid(LookFor,xStartPos,DashFoundPos1 - 1)>

<cfset xStartPos = DashFoundPos1 + 1>

<cfset DashFoundPos2 = Find('-','#hCmpAttYdTDINT#',xStartPos)>
<cfset hAtt = mid(LookFor,xStartPos,(DashFoundPos2 - DashFoundPos1)-1)>

<cfset xStartPos = DashFoundPos2 + 1>
<cfset DashFoundPos3 = Find('-','#hCmpAttYdTDINT#',xStartPos)>

<cfset hPassYds = mid(LookFor,xStartPos,(DashFoundPos3 - DashFoundPos2)-1)>

<cfset xStartPos = DashFoundPos3 + 1>
<cfset DashFoundPos4 = Find('-','#hCmpAttYdTDINT#',xStartPos)>

<cfset hPassTDs = mid(LookFor,xStartPos,(DashFoundPos4 - DashFoundPos3)-1)>
<cfset hPassINT = mid(LookFor,DashFoundPos4+1,2)>


<cfoutput>
#aCmp#,#aAtt#,#aPassYds#,#aPassInt#,#aPassTds#<br>
#hCmp#,#hAtt#,#hPassYds#,#hPassInt#,#hPassTds#<br>
</cfoutput>



************************************************************ Sacked-Yards *********************************************************************************************************
<cfset LookFor  = 'Sacked-Yards'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfset aSackedYards = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hSackedYards = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>


**** Parse out Sacked-Yards
<cfset xStartPos     = 1>
<cfset LookFor       = '#aSackedYards#'> 
<cfset DashFoundPos1 = Find('-','#aSackedYards#',xStartPos)>
<cfset aSacked       = mid(LookFor,xStartPos,DashFoundPos1 - 1)>
<cfset aSackedYds    = mid(LookFor,DashFoundPos1+1,3)>

**** Parse out Sacked-Yards
<cfset xStartPos     = 1>
<cfset LookFor       = '#hSackedYards#'> 
<cfset DashFoundPos1 = Find('-','#hSackedYards#',xStartPos)>
<cfset hSacked       = mid(LookFor,xStartPos,DashFoundPos1 - 1)>
<cfset hSackedYds    = mid(LookFor,DashFoundPos1+1,3)>


<cfoutput>
#aSacked#, #aSackedYds#<br>
#hSacked#, #hSackedYds#<br>
</cfoutput>


******************************************************** Net Pass Yards ************************************************************************************************************
<cfset LookFor  = 'Net Pass Yards'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfset aNetPassYards = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hNetPassYards    = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>

<cfoutput>
#aNetPassYards#<br>
#hNetPassYards#<br>
</cfoutput>




********************************************************* Total Yards ****************************************************************************************************************
<cfset LookFor  = 'Total Yards'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfset aTotYds          = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hTotYds          = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>


<cfoutput>
#aTotYds#<br>
#hTotYds#<br>
</cfoutput>



*********************************************************** Fumbles-Lost **************************************************************************************************************
<cfset LookFor  = 'Fumbles-Lost'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfset aFumLoststr = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hFumLoststr      = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>


**** Parse out Fumbles-Lost
<cfset xStartPos     = 1>
<cfset LookFor       = '#aFumLoststr#'> 
<cfset DashFoundPos1 = Find('-','#lookfor#',xStartPos)>
<cfset aFum          = mid(LookFor,xStartPos,DashFoundPos1 - 1)>
<cfset aFumLost      = mid(LookFor,DashFoundPos1+1,3)>

**** Parse out Fumbles-Lost
<cfset xStartPos     = 1>
<cfset LookFor       = '#hFumLoststr#'> 
<cfset DashFoundPos1 = Find('-','#lookfor#',xStartPos)>
<cfset hFum          = mid(LookFor,xStartPos,DashFoundPos1 - 1)>
<cfset hFumLost      = mid(LookFor,DashFoundPos1+1,3)>


<cfoutput>
#afum#,#afumLost#<br>
#hfum#,#hfumLost#<br>
</cfoutput>


*************************************************************** Turnovers *******************************************************************************************
<cfset startpos         = 1>
<cfset LookFor  = 'Turnovers'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found '#Lookfor#' at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfoutput>
startpos at pos #StartPos#
</cfoutput>

<cfset aTurnovers       = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hTurnovers       = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>

<cfoutput>
#aTurnovers#<br>
#hTurnovers#<br>
</cfoutput>



************************************************************* Penalties-Yards ********************************************************************************************
<cfset LookFor  = 'Penalties-Yards'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfset aPenYdstr = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hPenYdstr      = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>


**** Parse out Penalty-Yds
<cfset xStartPos     = 1>
<cfset LookFor       = '#aPenYdStr#'> 
<cfset DashFoundPos1 = Find('-','#lookfor#',xStartPos)>
<cfset aPen          = mid(LookFor,xStartPos,DashFoundPos1 - 1)>
<cfset aPenYds       = mid(LookFor,DashFoundPos1+1,3)>

**** Parse out Penalty-Yds
<cfset xStartPos     = 1>
<cfset LookFor       = '#hPenYdStr#'> 
<cfset DashFoundPos1 = Find('-','#lookfor#',xStartPos)>
<cfset hPen          = mid(LookFor,xStartPos,DashFoundPos1 - 1)>
<cfset hPenYds       = mid(LookFor,DashFoundPos1+1,3)>


<cfoutput>
#aPen#,#apenyds#<br>
#hPen#,#hpenyds#<br>
</cfoutput>



******************************************************* Third Down Conv. **********************************************************************************************
<cfset LookFor  = 'Third Down Conv.'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfset a3rdDwnConv       = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset h3rdDwnConv       = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>


<cfoutput>
#a3rdDwnConv#<br>
#h3rdDwnConv#<br>
</cfoutput>



******************************************************* Fourth Down Conv. **********************************************************************************************
<cfset LookFor  = 'Fourth Down Conv.'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfset a4thDwnConv       = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset h4thDwnConv       = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>


<cfoutput>
#a4thDwnConv#<br>
#h4thDwnConv#<br>
</cfoutput>


****************************************************** Time of Possession **************************************************************************************************

<cfset LookFor  = 'Time of Possession'> 
<cfset StatStartPos = FindStringInPage('#thepage#','#LookFor#',#startpos#)>

<cfoutput>
found at pos #StatStartPos#
</cfoutput>

<cfset LeftSideString   = '<td class="center " data-stat="vis_stat" >'>
<cfset RightSideString  = '</td>'>
<cfset startpos         = StatStartPos>

<cfset aTOP             = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset LeftSideString   = 'data-stat="home_stat" >'>
<cfset hTOP             = ParseIt('#thepage#',#StartPos#,'#LeftSideString#','#RightSideString#')>

<cfset StartPos = StartPos + Len(LeftSideString)>

<cfoutput>
#aTOP#<br>
#hTOP#<br>
</cfoutput>

<cfset aSkpct = aSacked / aAtt>
<cfset aIntpct = aPassInt / aAtt>

<cfset hSkpct = hSacked / hAtt>
<cfset hIntpct = hPassInt / hAtt>

<cfset SackDif = aSkpct - hSkpct>


<cfset aPavg = (aNetPassYards + aSackedYds) / aAtt + aSacked>
<cfset hPavg = (hNetPassYards + hSackedYds) / hAtt + hSacked>

<cfset aPlays = aAtt + aRushes + aSacked>
<cfset hPlays = hAtt + hRushes + hSacked>

<cfset aGain = (aTotYds) / (aPlays)>
<cfset hGain = (hTotYds) / (hPlays)>

<cfset awayMOV = aScore - hscore>
<cfset homeMOV = hScore - ascore>

<cfset HomeBetterYPP = ''>	
<cfset HomeWonTurnoverBattle = ''>
<cfset HomeWonTOP = ''>
<cfset HomeBetterPavg = ''>
<cfset HomeBetterRavg = ''>
<cfset HomeTeamWasBigFav=''>
<cfset HomeTeamCovered='PUSH'>
<cfset HomePlusMinus = 'EVEN'>

<cfset AwayBetterYPP = ''>	
<cfset AwayWonTurnoverBattle = ''>
<cfset AwayWonTOP = ''>
<cfset AwayBetterPavg = ''>
<cfset AwayBetterRavg = ''>
<cfset AwayTeamWasBigFav=''>
<cfset AwayTeamCovered='PUSH'>
<cfset HomeTeamWon = 'TIE'>
<cfset AwayTeamWon = 'TIE'>
<cfset AwayPlusMinus = 'EVEN'>

<cfset AwayExpectation = 'MET'>
<cfset HomeExpectation = 'MET'>

<cfset AwayExpectationPct = 0>
<cfset HomeExpectationPct = 0>

<cfset aTurnovers = afumLost + aPassInt>
<cfset hTurnovers = hfumLost + hPassInt>


<cfset AwayPlusMinus = hTurnovers - aTurnovers>
<cfset HomePlusMinus = aTurnovers - hTurnovers>


<cfif hScore gt aScore>
	<cfset HomeTeamWon = 'Y'>
	<cfset AwayTeamWon = ''>
</cfif>

<cfif aScore gt hScore>
	<cfset HomeTeamWon = ''>
	<cfset AwayTeamWon = 'Y'>
</cfif>
	

<cfif aGain gt hGain>
	<cfset AwayBetterYPP = 'Y'>
</cfif>	

<cfif aTurnovers lt hTurnovers>
	<cfset AwayWonTurnoverBattle = 'Y'>
</cfif>	

<cfif val(aTOP) gt val(hTOP)>
	<cfset AwayWonTOP = 'Y'>
</cfif>	

<cfif aPavg gt hPavg>
	<cfset AwayBetterPavg = 'Y'>
</cfif>	

<cfif aRavg gt hravg>
	<cfset AwayBetterRavg = 'Y'>
</cfif>	



<cfif hGain gt aGain>
	<cfset HomeBetterYPP = 'Y'>
</cfif>	

<cfif hTurnovers lt aTurnovers>
	<cfset HomeWonTurnoverBattle = 'Y'>
</cfif>	

<cfif val(hTOP) gt val(aTOP)>
	<cfset HomeWonTOP = 'Y'>
</cfif>	


<cfif hRavg gt aravg>
	<cfset HomeBetterRavg = 'Y'>
</cfif>	

<cfset AwayTeamWasFavored = ''>
<cfset HomeTeamWasFavored = 'Y'>
<cfset TeamWasBigFav='N'>

<cfset Done = 'N'>

If FAV was on the road and covered...
<cfif ha is 'A'>
	<cfset AwayTeamWasFavored = 'Y'>
	<cfset HomeTeamWasFavored = ''>
	<cfif val(spread) gt 6>
		<cfset AwayTeamWasBigFav='Y'>
	</cfif>
	
	<cfif val(spread) lt awayMOV>
		<cfset AwayExpectation = 'ABOVE'>
		<cfset HomeExpectation = 'BELOW'>
		<cfif val(spread) gt 0>
			<cfset AwayExpectationPct = (awayMOV - val(spread))/val(spread)>
			<cfset HomeExpectationPct = -1*AwayExpectationPct>
		</cfif>
		<cfset AwayTeamCovered='Y'>
		<cfset HomeTeamCovered=''>
		<cfset AwayConseqAboveExpCt = AwayConseqAboveExpCt + 1>
		<cfset HomeConseqBelowExpCt = HomeConseqBelowExpCt + 1>

		<cfset AwayConseqBelowExpCt = 0>
		<cfset HomeConseqAboveExpCt = 0>
		
	</cfif>
</cfif>	


If FAV was HOME and covered...
<cfif ha is 'H' and Done is 'N'>
	<cfset HomeTeamWasFavored = 'Y'>
	<cfset AwayTeamWasFavored = ''>
	<cfif val(spread) gt 6>
		<cfset HomeTeamWasBigFav='Y'>
	</cfif>

	<cfif val(spread) lt homeMOV>
		<cfset HomeTeamCovered='Y'>
		<cfset AwayTeamCovered=''>
		<cfset HomeExpectation = 'ABOVE'>
		<cfset AwayExpectation = 'BELOW'>
		<cfif val(spread) gt 0>
			<cfset HomeExpectationPct = (homeMOV - val(spread))/val(spread)>
			<cfset AwayExpectationPct = -1*HomeExpectationPct>
		</cfif>
		<cfset HomeConseqAboveExpCt = HomeConseqAboveExpCt + 1>
		<cfset AwayConseqBelowExpCt = AwayConseqBelowExpCt + 1>

		<cfset AwayConseqAboveExpCt = 0>
		<cfset HomeConseqBeloExpCt = 0>
		
		<cfset Done = 'Y'>
		
	</cfif>
</cfif>	

If Underdog is on the road...
<cfif uha is 'A' and Done is 'N'>
	<cfif (-1*val(spread)) lt awayMOV>
		<cfset AwayTeamCovered='Y'>
		<cfset HomeTeamCovered=''>
		<cfset HomeExpectation = 'BELOW'>
		<cfset AwayExpectation = 'ABOVE'>
		<cfif val(spread) gt 0>
			<cfset AwayExpectationPct = (awayMOV + val(spread))/val(spread)>
			<cfset HomeExpectationPct = -1*AwayExpectationPct>
		</cfif>
		
		<cfset AwayConseqAboveExpCt = AwayConseqAboveExpCt + 1>
		<cfset HomeConseqBelowExpCt = HomeConseqBelowExpCt + 1>
		<cfset AwayConseqBelowExpCt = 0>
		<cfset HomeConseqAboveExpCt = 0>
		<cfset Done = 'Y'>
		
	</cfif>

	<cfif awayMOV gt 0 and Done is 'N'>
		<cfset AwayTeamCovered='Y'>
		<cfset HomeTeamCovered=''>
		<cfset HomeExpectation = 'BELOW'>
		<cfset AwayExpectation = 'ABOVE'>
		<cfif val(spread) gt 0>
			<cfset AwayExpectationPct = (awayMOV + val(spread))/val(spread)>
			<cfset HomeExpectationPct = -1*AwayExpectationPct>
		</cfif>
		<cfset AwayConseqAboveExpCt = AwayConseqAboveExpCt + 1>
		<cfset HomeConseqBelowExpCt = HomeConseqBelowExpCt + 1>
		<cfset AwayConseqBelowExpCt = 0>
		<cfset HomeConseqAboveExpCt = 0>
		<cfset Done = 'Y'>


	</cfif>
	
</cfif>	


<cfif uha is 'H' and Done is 'N'>
	<cfif (-1*val(spread)) lt homeMOV>
		<cfset HomeTeamCovered='Y'>
		<cfset AwayTeamCovered=''>
		<cfset AwayExpectation = 'BELOW'>
		<cfset HomeExpectation = 'ABOVE'>
		<cfif val(spread) gt 0>
			<cfset HomeExpectationPct = (homeMOV + val(spread))/val(spread)>
			<cfset AwayExpectationPct = -1*HomeExpectationPct>
		</cfif>
		<cfset HomeConseqAboveExpCt = HomeConseqAboveExpCt + 1>
		<cfset AwayConseqBelowExpCt = AwayConseqBelowExpCt + 1>
		<cfset AwayConseqAboveExpCt = 0>
		<cfset HomeConseqBelowExpCt = 0>
		<cfset Done = 'Y'>
		
	</cfif>

	<cfif homeMOV gt 0 and Done is 'N'>
		<cfset homeTeamCovered='Y'>
		<cfset AwayTeamCovered=''>
		<cfset AwayExpectation = 'BELOW'>
		<cfset HomeExpectation = 'ABOVE'>
		<cfif val(spread) gt 0>
			<cfset HomeExpectationPct = (homeMOV + val(spread))/val(spread)>
			<cfset AwayExpectationPct = -1*HomeExpectationPct>
		</cfif>
		<cfset HomeConseqAboveExpCt = HomeConseqAboveExpCt + 1>
		<cfset AwayConseqBelowExpCt = AwayConseqBelowExpCt + 1>
		<cfset AwayConseqAboveExpCt = 0>
		<cfset HomeConseqBelowExpCt = 0>

		<cfset done = 'Y'>

	</cfif>
	
</cfif>	


<cfset aPavg = aNetPassYards / (aatt + aSacked)>
<cfset hPavg = hNetPassYards / (hatt + hSacked)>


<cfset aPavgDif    = APavg - HPavg>
<cfset aYPPDif     = AGain - HGain>
<cfset aRavgDif    = ARavg - HRavg>
<cfset aTOPDif     = Val(ATOP)  - val(HTop)>
<cfset aLuckFactor = hFumLost>
<cfset aGameRat    = (5*aPavgDif) + (2.5*aYPPDif) + (1.5* aRavgDif) + (1.0 * aTOPDif) - (3*aLuckFactor) >
<cfset aMOVPlusGameRat = aGameRat + (3*awayMOV)> 

<cfset aLuckFactorPct = 0>
<cfif hFumLost + hPassInt gt 0>
	<cfset aLuckFactorPct = 100*(aLuckFactor / (hFumLost + hPassInt)) >
</cfif>

<cfset hPavgDif  = -1* aPavgDif>
<cfset hYPPDif   = -1* aYppDif>
<cfset hRavgDif  = -1* aRavgDif>
<cfset hTOPDif   = -1* aTOPDif>
<cfset hLuckFactor = aFumLost>
<cfset hGameRat  = -1* aGameRat>
<cfset hMOVPlusGameRat = hGameRat + (2.5*homeMOV)> 

<cfset hLuckFactorPct = 0>
<cfif aFumLost + aPassInt gt 0>
	<cfset hLuckFactorPct = 100*(hLuckFactor / (aFumLost + aPassInt))>
</cfif>

<cfset awayUnderrated = ''>
<cfif awayTeamWon is '' and aGameRat gt 0>
	<cfset awayUnderrated = 'Y'>
</cfif>

<cfset homeUnderrated = ''>
<cfif homeTeamWon is '' and hGameRat gt 0>
	<cfset homeUnderrated = 'Y'>
</cfif>

<cfset awayOverrated = ''>
<cfif awayTeamWon is 'Y' and aGameRat lt 0>
	<cfset awayOverrated = 'Y'>
</cfif>

<cfset homeOverrated = ''>
<cfif homeTeamWon is 'Y' and hGameRat lt 0>
	<cfset homeOverrated = 'Y'>
</cfif>

<cfset HomeBetterPavg = ''>
<cfif hPavg gt aPavg>
	<cfset HomeBetterPavg = 'Y'>
</cfif>	

<cfset AwayBetterPavg = ''>
<cfif aPavg gt hPavg>
	<cfset AwayBetterPavg = 'Y'>
</cfif>	



	
	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO SYSSTATS(Week,SackAllowPct,SackMadePct,yr,Team,Opp,ha,turnovers,dturnovers,fumbles,fumbleslost,dfumbles,dfumbleslost,plays,dplays,ps,dps,rushes,ravg,ryds,yards,aGain,att,cmp,pyds,pAvg,interception,timeposs,Penalties,PenYds,Fds,sacked,skpct,intpct,drushes,dravg,dryds,dyards,daGain,datt,dcmp,dpyds,dpAvg,dinterception,dtimeposs,dPenalties,dPenYds,dFds,dsacked,dskpct,dintpct)
	Values(#theweek#,#asacked/aAtt#,#hsacked/hAtt#,#theyr#,'#Session.SpdAwayTeam#','#Session.SpdHomeTeam#','A',#afumLost + aPassInt#,#hfumLost + hPassInt#,#afum#,#afumLost#,#hfum#,#hfumLost#,#aPlays#,#hplays#,#aScore#,#hScore#,#aRushes#,#aRavg#,#aRYds#,#aTotYds#,#aGain#,#aAtt#,#aCmp#,#aNetPassYards#,#aPavg#,#aPassInt#,'#aTOP#',#aPen#,#aPenYds#,#aFds#,#asacked#,#aSkpct#,#aintpct#,#hRushes#,#hRavg#,#hRYds#,#hTotYds#,#hGain#,#hAtt#,#hCmp#,#hNetPassYards#,#hPavg#,#hPassInt#,'#hTOP#',#hPen#,#hPenYds#,#hFds#,#hsacked#,#hSkpct#,#hintpct#)
	</cfquery>
	
	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO SYSSTATS(Week,SackAllowPct,SackMadePct,yr,Team,Opp,ha,turnovers,dturnovers,fumbles,fumbleslost,dfumbles,dfumbleslost,plays,dplays,ps,dps,rushes,ravg,ryds,yards,aGain,att,cmp,pyds,pAvg,interception,timeposs,Penalties,PenYds,Fds,sacked,skpct,intpct,drushes,dravg,dryds,dyards,daGain,datt,dcmp,dpyds,dpAvg,dinterception,dtimeposs,dPenalties,dPenYds,dFds,dsacked,dskpct,dintpct)
	Values(#theweek#,#hsacked/hAtt#,#asacked/aAtt#,#theyr#,'#Session.SpdHomeTeam#','#Session.SpdAwayTeam#','H',#hfumLost + hPassInt#,#afumLost + aPassInt#,#hfum#,#hfumLost#,#afum#,#afumLost#,#hPlays#,#aplays#,#hScore#,#aScore#,#hRushes#,#hRavg#,#hRYds#,#hTotYds#,#hGain#,#hAtt#,#hCmp#,#hNetPassYards#,#hPavg#,#hPassInt#,'#hTOP#',#hPen#,#hPenYds#,#hFds#,#hsacked#,#hSkpct#,#hintpct#,#aRushes#,#aRavg#,#aRYds#,#aTotYds#,#aGain#,#aAtt#,#aCmp#,#aNetPassYards#,#aPavg#,#aPassInt#,'#aTOP#',#aPen#,#aPenYds#,#aFds#,#asacked#,#aSkpct#,#aintpct#)
	</cfquery>

	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO GameInsights(SackRateDif,OverratedPerformance,UnderratedPerformance,LuckFactor,MOVPlusGameRat,PavgDif,YppDif,RavgDif,TOPDif,GameRating,OppGameRating,ConseqAboveExpCt,ConseqBelowExpCt,Expectation,ExpectationPct,PlusMinusTurnovers,WonGame,TeamCovered,spd,Week,yr,Team,Opp,ha,BetterYPP,WonTurnoverBattle,WonTOP,BetterPavg,BetterRAvg,TeamWasFavored,TeamWasBigFav,MOV)
	Values(#100*SackDif#,'#awayOverrated#','#awayUnderrated#',#aLuckFactorPct#,#aMOVPlusGameRat#,#aPavgDif#,#aYppDif#,#aRavgDif#,#aTOPDif#,#aGameRat#,#hGameRat#,#AwayConseqAboveExpCt#,#AwayConseqBelowExpCt#,'#AwayExpectation#',#AwayExpectationPct#,(#hfumLost + hPassInt#) - (#afumLost + aPassInt#),'#AwayTeamWon#','#AwayTeamCovered#',#val(spread)#,#theweek#,#theyr#,'#Session.SpdAwayTeam#','#Session.SpdHomeTeam#','A','#AwayBetterYPP#','#AwayWonTurnoverBattle#','#AwayWonTOP#','#AwayBetterPavg#','#AwayBetterRAvg#','#AwayTeamWasFavored#','#AwayTeamWasBigFav#',#AwayMOV#)
	</cfquery>


	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO GameInsights(SackRateDif,OverratedPerformance,UnderratedPerformance,LuckFactor,MOVPlusGameRat,PavgDif,YppDif,RavgDif,TOPDif,GameRating,OppGameRating,ConseqAboveExpCt,ConseqBelowExpCt,Expectation,ExpectationPct,PlusMinusTurnovers,WonGame,TeamCovered,spd,Week,yr,Team,Opp,ha,BetterYPP,WonTurnoverBattle,WonTOP,BetterPavg,BetterRAvg,TeamWasFavored,TeamWasBigFav,MOV)
	Values(#-100*SackDif#,'#homeOverrated#','#homeUnderrated#',#hLuckFactorPct#,#hMOVPlusGameRat#,#hPavgDif#,#hYppDif#,#hRavgDif#,#hTOPDif#,#hGameRat#,#aGameRat#,#HomeConseqAboveExpCt#,#HomeConseqBelowExpCt#,'#HomeExpectation#',#HomeExpectationPct#,(#afumLost + aPassInt#) - (#hfumLost + hPassInt#),'#HomeTeamWon#','#HomeTeamCovered#',#val(spread)#,#theweek#,#theyr#,'#Session.SpdHomeTeam#','#Session.SpdAwayTeam#','H','#HomeBetterYPP#','#HomeWonTurnoverBattle#','#HomeWonTOP#','#HomeBetterPavg#','#HomeBetterRAvg#','#HomeTeamWasFavored#','#HomeTeamWasBigFav#',#HomeMOV#)
	</cfquery>



	<cfoutput>
	       Week=#theweek#
			yr=#theyr#
			Team='#Session.SpdAwayTeam#'
			Opp='#Session.SpdHomeTeam#'
			ha='A'
			turnovers=#aturnovers#
			dturnovers=#hturnovers#
			fumbles=#afum#
			fumbleslost=#afumLost#
			dfumbles=#hfum#
			dfumbleslost=#hfumLost#
			plays=#aPlays#
			dplays=#hplays#
			ps=#aScore#
			dps=#hScore#
			rushes=#aRushes#
			ravg=#aRavg#
			ryds=#aRYds#
			yards=#aTotYds#
			aGain=#aGain#
			att=#aAtt#
			cmp=#aCmp#
			pyds=#aNetPassYards#
			pAvg=#aPavg#
			interception=#aPassInt#
			timeposs='#aTOP#'
			Penalties=#aPen#
			PenYds=#aPenYds#
			Fds=#aFds#
			sacked=#asacked#
			skpct=#aSkpct#
			intpct=#aintpct#
			drushes=#hRushes#
			dravg=#hRavg#
			dryds=#hRYds#
			dyards=#hTotYds#
			daGain=#hGain#
			datt=#hAtt#
			dcmp=#hCmp#
			dpyds=#hNetPassYards#
			dpAvg=#hPavg#,
			dinterception=#hPassInt#
			dtimeposs='#hTOP#'
			dPenalties=#hPen#
			dPenYds=#hPenYds#
			dFds=#hFds#
			dsacked=#hsacked#
			dskpct=#hSkpct#
			dintpct=#hintpct#
			
			<p>
			<p>
			
			ConseqAboveExpCt=#HomeConseqAboveExpCt#<br>
			ConseqBelowExpCt=#HomeConseqBelowExpCt#<br>
			Expectation='#HomeExpectation#'<br>
			ExpectationPct=#HomeExpectationPct#<br>
			PlusMinusTurnovers=#HomePlusMinus#<br>
			WonGame='#HomeTeamWon#'<br>
			TeamCovered='#HomeTeamCovered#'<br>
			spd=#val(spread)#<br>
			Week=#theweek#<br>
			yr=#theyr#<br>
			Team='#Session.SpdHomeTeam#'<br>
			Opp='#Session.SpdAwayTeam#'<br>
			ha='H'<br>
			BetterYPP='#HomeBetterYPP#'<br>
			WonTurnoverBattle='#HomeWonTurnoverBattle#'<br>
			WonTOP='#HomeWonTOP#'<br>
			BetterPavg='#HomeBetterPavg#'<br>
			BetterRAvg='#HomeBetterRAvg#'<br>
			TeamWasFavored='#HomeTeamWasFavored#'<br>
			TeamWasBigFav='#HomeTeamWasBigFav#'<br>
			MOV=#HomeMOV#

			<p>
			
	</cfoutput>





</cfloop>	
<p>


<cfquery datasource="sysstats3" name="GetPossUnderrated">
Select Team,GameRating
from GameInsights
where WonGame = '' AND GameRating > 0	
and week = #theweek#
order by GameRating desc
</cfquery>

<p>

Underrated!...<p><br>
<cfquery datasource="sysstats3" name="GetPossOverrated">
Select Team,GameRating
from GameInsights
where WonGame = 'Y' AND GameRating < 0	
and week = #theweek#
order by GameRating 
</cfquery>

<p>
<cfoutput query="GetPossUnderrated">
#Team# - #GameRating#<br>
</cfoutput>

Overrated!...<p>
<cfoutput query="GetPossOverrated">
#Team# - #GameRating#<br>
</cfoutput>


	<cfset avGameRating = 0>
	<cfset avLuckFactor = 0>
	<cfset avMOVPlusGameRat = 0>
	<cfset avMOV = 0>
	<cfset avYPPDif = 0>
	<cfset avPavgDif = 0>
	<cfset avRavgDif = 0>
	<cfset avTOPDif = 0> 	








<cfquery datasource="sysstats3" name="GetAvgData">
Select Team,AVG(GameRating) as aGameRating, Avg(LuckFactor) as aLuckFactor, Avg(MOVPlusGameRat) as aMOVPlusGameRat, AVG(MOV) as aMOV, AVG(YPPDif) as aYPPDif, AVG(PavgDif) as aPavgDif,
AVG(RavgDif) as aRavgDif, AVG(TOPDif) as aTOPDif, AVG(SackRateDif) as aSackRateDif
from GameInsights
where Week <= #theweek#
group by team
</cfquery>



<cfloop query = "GetAvgData">
	<cfquery datasource="sysstats3" name="AddAvg">
	INSERT INTO AVGGameInsights(Week,Team,GameRating,LuckFactor,MOVPlusGameRat, MOV,YPPDif, PavgDif,RavgDif,TOPDif,SackRateDif)
	VALUES(#theweek#,'#Team#',#aGameRating#,#aLuckFactor#,#aMOVPlusGameRat#,#aMOV#,#aYPPDif#,#aPavgDif#,#aRavgDif#,#aTOPDif#,#aSackRateDif#) 
	</cfquery>
	
	<cfset avGameRating = avGameRating + aGameRating>
	<cfset avLuckFactor = avLuckFactor + aLuckFactor>
	<cfset avMOVPlusGameRat = avMOVPlusGameRat + aMOVPlusGameRat>
	<cfset avMOV = avMOV + aMOV>
	<cfset avYPPDif = avYPPDif + aYPPDif>
	<cfset avPavgDif = avPavgDif + aPavgDif>
	<cfset avRavgDif = avRavgDif + aRavgDif>
	<cfset avTOPDif = avTOPDif + aTOPDif> 	
	
	<cfoutput>
	 jimdebug<br>
	 #team#<br>
	 #avGameRating# <br>
	 #avLuckFactor# <br>
	 #avMOVPlusGameRat# <br> 
	 #avMOV# <br>
	 #avYPPDif# <br>
	 #avPavgDif# <br>
	 #avRavgDif# <br>
	 #avTOPDif# <br>
	</cfoutput>
	***************************************************************************************<br>
	
	
</cfloop>


	<cfset totteams = 31>
	<cfset avGameRating = avGameRating / totteams>
	<cfset avLuckFactor = avLuckFactor / totteams>
	<cfset avMOVPlusGameRat = avMOVPlusGameRat / totteams>
	<cfset avMOV = avMOV / totteams >
	<cfset avYPPDif = avYPPDif / totteams>
	<cfset avPavgDif = avPavgDif / totteams>
	<cfset avRavgDif = avRavgDif / totteams>
	<cfset avTOPDif = avTOPDif / totteams> 	




	<cfquery datasource="sysstats3" name="AddAvg">
	INSERT INTO AVGGameInsights(Week,Team,GameRating,LuckFactor,MOVPlusGameRat, MOV,YPPDif, PavgDif,RavgDif,TOPDif)
	VALUES(#theweek#,'AVGTeam',#avGameRating#,#avLuckFactor#,#avMOVPlusGameRat#,#avMOV#,#avYPPDif#,#avPavgDif#,#avRavgDif#,#avTOPDif#) 
	</cfquery>

	<cfquery datasource="sysstats3" name="GetNFLAvg">
	SELECT * from  AVGGameInsights where team = 'AVGTeam'
	AND week = #theweek#
	</cfquery>

<cfloop query="GetAvgData">
	<cfset doit = createBTAPct('AVGGameInsights','AVGGameInsights','#GetAvgData.Team#',#theweek#)>
</cfloop>
 
 	<cfquery datasource="sysstats3" name="GetAGI">
		SELECT Team,AVG(MOVPlusGameRat) as AvgMOVPLUS, AVG(GameRating) as AVGGameRating	
		FROM AVGGameInsights
		where team <> 'AVGTeam'
		Group By Team	
		order by 2 desc
	</cfquery>

	<cfoutput query = "GetAGI">
		<cfquery datasource="sysstats3" name="UpdsGetAGI">
		UPDATE AVGGameInsights
		SET AvgOfAllMOVPlusGameRat = #GetAGI.AvgMOVPlus#
		Where Team = '#GetAGI.Team#'
		and week = #theweek#
		</cfquery>
	</cfoutput>
 
 
	<cfoutput query = "GetAGI">
		<cfquery datasource="sysstats3" name="UpdsGetAGI2">
		UPDATE AVGGameInsights
		SET PowerRating = (AvgOfAllMOVPlusGameRat/100)*12 
		Where Team = '#GetAGI.Team#'
		and week = #theweek#
		</cfquery>
	</cfoutput>
 
 
 <cfoutput query = "GetAGI">
		<cfquery datasource="sysstats3" name="UpdsGetAGI3">
		UPDATE AVGGameInsights
		SET AvgOfAllGameRat = #GetAGI.AvgGameRating#
		Where Team = '#GetAGI.Team#'
		and week = #theweek#
		</cfquery>
	</cfoutput>
 
 
 <cfoutput query = "GetAGI">
		<cfquery datasource="sysstats3" name="UpdsGetAGI3">
		UPDATE AVGGameInsights
		SET BtaPowerRating = 100*((((PowerRating + 20) -20) /20))
		Where Team = '#GetAGI.Team#'
		and week = #theweek#
		</cfquery>
 </cfoutput>
 

 	<cfquery datasource="sysstats3" name="GetAGI">
		SELECT Distinct Team	
		FROM Sysstats
	</cfquery>

	<cfloop query="GetAGI">
	
		
	
		<cfquery datasource="sysstats3" name="Getopp">
		SELECT gi.opp	
		FROM GameInsights gi
		where gi.Team = '#GetAGI.Team#'
		</cfquery>

		<cfset gamect = 0>
		<cfset stat = 0>

		righthere<br>
		<cfdump var="#Getopp#">

		<cfloop query="GetOpp">
		
			<cfquery datasource="sysstats3" name="Getoppstats">
			SELECT 	AVG(PowerRating) as avPowerRating
			FROM AvgGameInsights 
			where Team = '#GetOpp.opp#'
			</cfquery>

		
			
			<cfoutput query="GetOppStats">

				
				Opp is #GetOpp.Opp#.... Powerrating is #GetOppStats.avPowerRating#<br>
								
				<cfset gamect = gamect + 1>
				<cfset stat = stat + #GetOppStats.avPowerRating#>

			</cfoutput>

		</cfloop>

				<cfoutput>
				final stat .... #stat#<br>
				</cfoutput>


		<cfquery datasource="sysstats3" name="Updit">
		UPDATE AVGGameInsights
		SET oppPowerRatings = #Stat#
		where Team = '#GetAGI.Team#'
		and week = #theweek#
		</cfquery>
		
	</cfloop>
 
 
 		<cfquery datasource="sysstats3" name="getAvgOPPPr">
		Select AVG(oppPowerRatings) as AvgOppPR
		FROM AVGGameInsights
		where Team <> 'AVGTeam'
		and week = #theweek#
		</cfquery>


		

				<cfquery datasource="sysstats3" name="Updit">
				UPDATE AVGGameInsights
				SET AdjPowerRating = PowerRating + (oppPowerRatings/10)
				where week = #theweek#
				</cfquery> 
 
 
 
 				<cfquery datasource="sysstats3" name="Getexpec">
				Select gi1.Team, AVG(gi1.ExpectationPct) as expech, AVG(gi2.ExpectationPct) as expeca, AVG(gi1.ExpectationPct) - AVG(gi2.ExpectationPct) as hadiff
				FROM GameInsights gi1,GameInsights gi2
				WHERE gi1.Team = gi2.Team
				and gi1.HA = 'H'
				and gi2.HA = 'A'
				group by gi1.Team
				</cfquery> 
 
				<cfdump var="#Getexpec#">
 
				<cfloop query="GetExpec">
				
				<cfquery datasource="sysstats3" name="Updit">
				UPDATE AVGGameInsights
				SET HomePerfRat = #expech#,
				AwayPerfRat = #expeca#,
				HomeAwayPerfDiff = #expech - expeca#
				where week = #theweek#
				and team = '#team#'
				</cfquery> 

				</cfloop>
 
 
				<cfloop query="GetExpec">
				
				<cfquery datasource="sysstats3" name="Updit">
				UPDATE AVGGameInsights
				SET HFANum = 3 + 3*(HomeAwayPerfDiff/100),
				AFANum = 3 + 3*(HomeAwayPerfDiff/100),
				HomePowerRat = adjPowerRating + (3 + 3*(HomeAwayPerfDiff/100)),
				AwayPowerRat = adjPowerRating - (3 + 3*(HomeAwayPerfDiff/100)),
				TrendingUpDown = MOVPlusGameRat - AvgOfAllMOVPlusGameRat 
				where week = #theweek#
				and team = '#team#'
				</cfquery> 

				</cfloop>
 
  
 				<cfquery datasource="sysstats3" name="Updit">
				UPDATE AVGGameInsights
				SET AdjPowerRatingTrendUpDown = (AdjPowerRating * (TrendingUpDown/100)) + AdjPowerRating 
				where week = #theweek#
				And AdjPowerRating > 0
				</cfquery> 

				<cfquery datasource="sysstats3" name="Updit">
				UPDATE AVGGameInsights
				SET AdjPowerRatingTrendUpDown = AdjPowerRating + ((-1*AdjPowerRating) * (TrendingUpDown/100))   
				where week = #theweek#
				And AdjPowerRating < 0
				</cfquery> 

 
 
	Main Driver...
 	<cfset temp=createStats(#theweek#)>
	<cfset temp=createOppPavgDif(#theweek#)>
	<cfset temp=createFortunateRating(#theweek#)>
	<cfset temp=createPower(#theweek#)>
	<cfset temp=createExpectationNum()>
	<cfset temp=updateNFLSPDSFlags(#theweek#)>
	<cfset temp=calculateHFA(#theweek#)>
	<cfset temp=createPreGameStats(#theweek#)>
	<cfset temp=updateExpectedPts()>
	<cfset temp=CreateTotals(#theweek# + 1)>
	
	<cfinclude template="./PlayByPlay/LoadDriveChartLoadData.cfm">

	
	
	
	
<cffunction name="getGames" access="remote" output="yes" returntype="Query">
<cfargument name="theWeek" type="Numeric"  required="yes" />
<cfargument name="team" type="String"  required="no" />

	<cfif isdefined("arguments.team")>
		<cfquery datasource="sysstats3" name="GetInfo">
			SELECT * FROM NFLSPDS where week = #arguments.theweek# and (Fav = '#arguments.team#' or Und = '#arguments.team#')
		</cfquery>
	<cfelse>
		<cfquery datasource="sysstats3" name="GetInfo">
		SELECT * FROM NFLSPDS where week = #arguments.theweek#
		</cfquery>

	</cfif>

	<cfreturn #GetInfo#>

</cffunction>	

	
	
	
<cffunction name="SetTeamNames" access="remote" output="yes" returntype="Void">
	<cfargument name="Team"            type="String"  required="yes" />
	<cfargument name="HomeAwayFlag"    type="String"  required="yes" />
	<cfargument name="FavUndFlag"      type="String"  required="yes" />
	
	 
	<cfswitch expression='#Arguments.Team#'>
			<cfcase value="OAK">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'rai'> 
					<cfset Session.ScoreHomeTeam = 'LVR'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'rai'> 
					<cfset Session.ScoreAwayTeam = 'LVR'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="LAR">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'ram'> 
					<cfset Session.ScoreHomeTeam = 'LAR'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'ram'> 
					<cfset Session.ScoreAwayTeam = 'LAR'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="DET">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'det'> 
					<cfset Session.ScoreHomeTeam = 'DET'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'det'> 
					<cfset Session.ScoreAwayTeam = 'DET'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>


			<cfcase value="NYJ">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'nyj'> 
					<cfset Session.ScoreHomeTeam = 'NYJ'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'nyj'> 
					<cfset Session.ScoreAwayTeam = 'NYJ'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>


			<cfcase value="KC">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'kan'> 
					<cfset Session.ScoreHomeTeam = 'KAN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'kan'> 
					<cfset Session.ScoreAwayTeam = 'KAN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="LAC">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'sdg'> 
					<cfset Session.ScoreHomeTeam = 'LAC'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'sdg'> 
					<cfset Session.ScoreAwayTeam = 'LAC'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="BUF">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'buf'> 
					<cfset Session.ScoreHomeTeam = 'BUF'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'buf'> 
					<cfset Session.ScoreAwayTeam = 'BUF'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="BAL">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'rav'> 
					<cfset Session.ScoreHomeTeam = 'BAL'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'rav'> 
					<cfset Session.ScoreAwayTeam = 'BAL'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="JAX">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'jax'> 
					<cfset Session.ScoreHomeTeam = 'JAX'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'jax'> 
					<cfset Session.ScoreAwayTeam = 'JAX'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="NYG">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'nyg'> 
					<cfset Session.ScoreHomeTeam = 'NYG'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'nyg'> 
					<cfset Session.ScoreAwayTeam = 'NYG'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="HOU">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'htx'> 
					<cfset Session.ScoreHomeTeam = 'HOU'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'htx'> 
					<cfset Session.ScoreAwayTeam = 'HOU'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="NE">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'nwe'> 
					<cfset Session.ScoreHomeTeam = 'NWE'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'nwe'> 
					<cfset Session.ScoreAwayTeam = 'NWE'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="TB">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'tam'> 
					<cfset Session.ScoreHomeTeam = 'TAM'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'tam'> 
					<cfset Session.ScoreAwayTeam = 'TAM'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="NO">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'nor'> 
					<cfset Session.ScoreHomeTeam = 'NOR'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'nor'> 
					<cfset Session.ScoreAwayTeam = 'NOR'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="SF">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'sfo'> 
					<cfset Session.ScoreHomeTeam = 'SFO'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'sfo'> 
					<cfset Session.ScoreAwayTeam = 'SFO'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="MIN">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'min'> 
					<cfset Session.ScoreHomeTeam = 'MIN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'min'> 
					<cfset Session.ScoreAwayTeam = 'MIN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="TEN">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'oti'> 
					<cfset Session.ScoreHomeTeam = 'TEN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'oti'> 
					<cfset Session.ScoreAwayTeam = 'TEN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="MIA">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'mia'> 
					<cfset Session.ScoreHomeTeam = 'MIA'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'mia'> 
					<cfset Session.ScoreAwayTeam = 'MIA'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="CHI">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'chi'> 
					<cfset Session.ScoreHomeTeam = 'CHI'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'chi'> 
					<cfset Session.ScoreAwayTeam = 'CHI'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="GB">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'gnb'> 
					<cfset Session.ScoreHomeTeam = 'GNB'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'gnb'> 
					<cfset Session.ScoreAwayTeam = 'GNB'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="SEA">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'sea'> 
					<cfset Session.ScoreHomeTeam = 'SEA'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'sea'> 
					<cfset Session.ScoreAwayTeam = 'SEA'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="DEN">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'den'> 
					<cfset Session.ScoreHomeTeam = 'DEN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'den'> 
					<cfset Session.ScoreAwayTeam = 'DEN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="WAS">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'was'> 
					<cfset Session.ScoreHomeTeam = 'WAS'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'was'> 
					<cfset Session.ScoreAwayTeam = 'WAS'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="ARZ">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'crd'> 
					<cfset Session.ScoreHomeTeam = 'ARI'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'crd'> 
					<cfset Session.ScoreAwayTeam = 'ARI'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="CIN">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'cin'> 
					<cfset Session.ScoreHomeTeam = 'CIN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'cin'> 
					<cfset Session.ScoreAwayTeam = 'CIN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="IND">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'clt'> 
					<cfset Session.ScoreHomeTeam = 'IND'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'clt'> 
					<cfset Session.ScoreAwayTeam = 'IND'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="PIT">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'pit'> 
					<cfset Session.ScoreHomeTeam = 'PIT'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'pit'> 
					<cfset Session.ScoreAwayTeam = 'PIT'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="CLE">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'cle'> 
					<cfset Session.ScoreHomeTeam = 'CLE'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'cle'> 
					<cfset Session.ScoreAwayTeam = 'CLE'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>


			<cfcase value="CAR">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'car'> 
					<cfset Session.ScoreHomeTeam = 'CAR'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'car'> 
					<cfset Session.ScoreAwayTeam = 'CAR'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="DAL">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'dal'> 
					<cfset Session.ScoreHomeTeam = 'DAL'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'dal'> 
					<cfset Session.ScoreAwayTeam = 'DAL'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="ATL">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'atl'> 
					<cfset Session.ScoreHomeTeam = 'ATL'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'atl'> 
					<cfset Session.ScoreAwayTeam = 'ATL'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="PHI">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'phi'> 
					<cfset Session.ScoreHomeTeam = 'PHI'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'phi'> 
					<cfset Session.ScoreAwayTeam = 'PHI'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

		</cfswitch>		
	
</cffunction>


<cffunction name="ParseIt" access="remote" output="yes" returntype="String">

	<cfargument name="theViewSourcePage"    type="String"  required="yes" />
	<cfargument name="startLookingPosition" type="Numeric" required="yes" />

	<cfargument name="LeftSideString"       type="String"  required="yes" />
	<cfargument name="RightSideString"      type="String"  required="yes" />

	
 
	<cfset posOfLeftsidestring = FINDNOCASE('#arguments.LeftSideString#','#arguments.theViewSourcePage#',#arguments.startLookingPosition#)>  
		
	<cfset LengthOfLeftSideString = LEN('#arguments.LeftSideString#')>

	<cfset posOfRightsidestring    = FINDNOCASE('#arguments.RightSideString#','#arguments.theViewSourcePage#',#posOfLeftsidestring#)>  	
	<cfset LengthOfRightSideString = LEN('#arguments.RightSideString#')>

	<p>
	
	
	<cfset StartParsePos = posOfLeftsidestring  + LengthOfLeftSideString>
	<cfset EndParsePos   = posOfRightsidestring>
 	<cfset LenOfParseVal = (#EndParsePos# - #StartParsePos#)>

	
	<cfset parseVal = Mid('#arguments.theViewSourcePage#',#StartParsePos#,#LenOfParseVal#)>
	
	
	<cfreturn parseVal>

</cffunction>



<cffunction name="FindStringInPage" access="remote" output="yes" returntype="Numeric">

	<cfargument name="theViewSourcePage"    type="String"  required="yes" />
	<cfargument name="LookFor"              type="String"  required="yes" />
	<cfargument name="startLookingPosition" type="Numeric" required="yes" />

	<cfset FoundStringPos = FINDNOCASE('#arguments.LookFor#','#arguments.theViewSourcePage#',#arguments.startLookingPosition#)>  	

	<cfreturn #FoundStringPos# >

</cffunction>


<cffunction name="createBTAPct" access="remote" output="yes" returntype="void">

	<cfargument name="theRows"    type="String"  required="yes" />
	<cfargument name="theAvg"     type="String"  required="yes" />
	<cfargument name="theTeam"    type="String"  required="yes" />
	<cfargument name="theWeek"    type="String"  required="yes" />
	
	
	<Cfquery datasource="sysstats3" Name="GetTeamAvg">
	SELECT * From AVGGameInsights where Team = '#arguments.theTeam#'
	AND WEEK = #arguments.theweek#
	</cfquery>
	
	<Cfquery datasource="sysstats3" Name="GetNFLAvg">
	SELECT GameRating as aGameRating,
           LuckFactor as aLuckFactor,
		   MOVPlusGameRat as aMOVPlusGameRat,
		   MOV as aMOV,
		   YPPDif as aYPPDif,
		   PavgDif as aPavgDif,
		   RavgDif as aRavgDif,
		   TOPDif as aTOPDif
	From AvgGameInsights 
	where week = #arguments.theweek#
	and team <> 'AVGTeam'
	</cfquery>


	<cfset divby = 32*arguments.theweek>
	<cfloop query = "GetNFLAvg">
	
	<cfset Session.avGameRating = Session.avGameRating + aGameRating>
	<cfset Session.avLuckFactor = Session.avLuckFactor + aLuckFactor>
	<cfset Session.avMOVPlusGameRat = Session.avMOVPlusGameRat + aMOVPlusGameRat>
	<cfset Session.avMOV = Session.avMOV + aMOV>
	<cfset Session.avYPPDif = Session.avYPPDif + aYPPDif>
	<cfset Session.avPavgDif = Session.avPavgDif + aPavgDif>
	<cfset Session.avRavgDif = Session.avRavgDif + aRavgDif>
	<cfset Session.avTOPDif = Session.avTOPDif + aTOPDif> 	

	<cfoutput>
	******#Session.avGameRating#<br>
	</cfoutput>




	</cfloop>

	<cfoutput>
	*********#Session.avGameRating#<br>
	</cfoutput>



	<cfset Session.avGameRating = Session.avGameRating / divby>
	<cfset Session.avLuckFactor = Session.avLuckFactor / divby>
	<cfset Session.avMOVPlusGameRat = Session.avMOVPlusGameRat / divby>
	<cfset Session.avMOV = Session.avMOV / divby>
	<cfset Session.avYPPDif = Session.avYPPDif / divby>
	<cfset Session.avPavgDif = Session.avPavgDif / divby>
	<cfset Session.avRavgDif = Session.avRavgDif / divby>
	<cfset Session.avTOPDif = Session.avTOPDif / divby> 	
	
	
	
	
	
	<cfset multiplier = 1>
	<cfif GetNFLAvg.aGameRating lt 0>
		<cfset multiplier = -1>
	</cfif>	
	
	<cfset btaGameRating         = GetTeamAvg.GameRating - Session.avGameRating>
	<cfset btaGameRatingPct      = btaGameRating / Session.avGameRating>
	<cfset finalbtaGameRatingPct = (multiplier*btaGameRatingPct)/100>
	
	
	
	<cfset multiplier = 1>
	<cfif GetNFLAvg.aLuckFactor lt 0>
		<cfset multiplier = -1>
	</cfif>	
	
	<cfset btaLuckFactor         = GetTeamAvg.LuckFactor - Session.avLuckFactor>
	<cfset btaLuckFactorPct      = btaLuckFactor / Session.avLuckFactor>
	<cfset finalbtaLuckFactorPct = (multiplier*btaLuckFactorPct)/100>
	



	<cfset multiplier = 1>
	<cfif GetNFLAvg.aMOVPlusGameRat lt 0>
		<cfset multiplier = -1>
	</cfif>	
	
	<cfset btaMOVPlusGameRat         = GetTeamAvg.MOVPlusGameRat - Session.avMOVPlusGameRat>
	<cfset btaMOVPlusGameRatPct      = btaMOVPlusGameRat / Session.avMOVPlusGameRat>
	<cfset finalbtaMOVPlusGameRatPct = (multiplier*btaMOVPlusGameRatPct)/100>
	


	
	<cfoutput>
	DebugIt:#theteam#...finalbtaGameRatingPct = #finalbtaGameRatingPct#<br>
	</cfoutput>


	<cfif 1 is 2>	
	
	<cfloop query = "GetTeamAvg">
				
		<cfset btaLuckFactor     = ABS((   ABS(GetTeamAvg.LuckFactor)     - 10* (ABS(GetNFLAvg.LuckFactor)     )) / GetNFLAvg.LuckFactor) >
		<cfif GetTeamAvg.LuckFactor lt 0>
			<cfset btaLuckFactor = -1*ABS((   ABS(GetTeamAvg.LuckFactor)     - 10* (ABS(GetNFLAvg.LuckFactor)     )) / GetNFLAvg.LuckFactor)>
		</cfif>
		
		<cfset btaMOVPlusGameRat = ABS((   ABS(GetTeamAVG.MOVPlusGameRat) - 10* (ABS(GetNFLAVG.MOVPlusGameRat) )) / GetNFLAVG.MOVPlusGameRat) >
		<cfif GetTeamAvg.MOVPlusGameRat lt 0>
			<cfset btaMOVPlusGameRat = -1*ABS((   ABS(GetTeamAVG.MOVPlusGameRat) - 10* (ABS(GetNFLAVG.MOVPlusGameRat) )) / GetNFLAVG.MOVPlusGameRat)>
		</cfif>
				
		<cfset btaMOV            = ABS((   ABS(GetTeamAvg.MOV)            - 10* (ABS(GetNFLAvg.MOV)            )) / GetNFLAvg.MOV) >
		<cfif GetTeamAvg.MOV lt 0>
			<cfset btaMOV = -1*ABS((   ABS(GetTeamAvg.MOV)            - 10* (ABS(GetNFLAvg.MOV)            )) / GetNFLAvg.MOV)>
		</cfif>
			
		<cfset btaYPPDif         = ABS((   ABS(GetTeamAvg.YPPDif)         - 10* (ABS(GetNFLAvg.YPPDif)         )) / GetNFLAvg.YPPDif)>
		<cfif GetTeamAvg.YPPDif lt 0>
			<cfset btaYPPDif = -1*ABS((   ABS(GetTeamAvg.YPPDif)         - 10* (ABS(GetNFLAvg.YPPDif)         )) / GetNFLAvg.YPPDif)>
		</cfif>
	
		<cfset btaPavgDif        = ABS((   ABS(GetTeamAvg.PavgDif)        - 10* (ABS(GetNFLAvg.PavgDif)        )) / GetNFLAvg.PavgDif)>
		<cfif GetTeamAvg.PavgDif lt 0>
			<cfset btaPavgDif = -1*ABS((   ABS(GetTeamAvg.PavgDif)        - 10* (ABS(GetNFLAvg.PavgDif)        )) / GetNFLAvg.PavgDif)>
		</cfif>
	
	
		<cfset btaRavgDif        = ABS((   ABS(GetTeamAvg.RavgDif)        - 10* (ABS(GetNFLAvg.RavgDif)        )) / GetNFLAvg.RavgDif)>
		<cfif GetTeamAvg.RavgDif lt 0>
			<cfset btaRavgDif = -1*ABS((   ABS(GetTeamAvg.RavgDif)        - 10* (ABS(GetNFLAvg.RavgDif)        )) / GetNFLAvg.RavgDif)>
		</cfif>
	

		<cfset btaTOPDif         = ABS((   ABS(GetTeamAvg.TOPDif)         - 10* (ABS(GetNFLAvg.TOPDif)         )) / GetNFLAvg.TOPDif)> 
		<cfif GetTeamAvg.TOPDif lt 0>
			<cfset btaTOPDif = -1*ABS((   ABS(GetTeamAvg.TOPDif)         - 10* (ABS(GetNFLAvg.TOPDif)         )) / GetNFLAvg.TOPDif)>
		</cfif>
	
	</cfloop>
	</cfif>
	
	<cfquery datasource="sysstats3" name="updit">
	UPDATE AvgGameInsights 
		SET btaGameRating     = #finalbtaGameRatingPct#,
		    btaLuckFactor     = #finalbtaLuckFactorPct#,
			btaMOVPlusGameRat =	#finalbtaMOVPlusGameRatPct#
			
	WHERE TEAM = '#arguments.theTeam#'
	AND WEEK = #theweek#
	</cfquery>
	
	<cfquery datasource="sysstats3" name="updit">
	UPDATE AvgGameInsights 
		SET PowerRating = (10*btaMOVPlusGameRat)  
	WHERE WEEK = #theweek#	
	</cfquery>
		
	<cfset Session.avGameRating     = 0>
	<cfset Session.avLuckFactor     = 0>
	<cfset Session.avMOVPlusGameRat = 0>
	<cfset Session.avMOV            = 0>
	<cfset Session.avYPPDif         = 0>
	<cfset Session.avPavgDif        = 0>
	<cfset Session.avRavgDif        = 0>
	<cfset Session.avTOPDif         = 0> 	

	
	<cfif 1 is 2>
	<cfquery datasource="sysstats3" name="updit">
	UPDATE AvgGameInsights 
		SET btaGameRating = #btaGameRating/10#,
			btaLuckFactor = #btaLuckFactor/10#,
			btaMOVPlusGameRat = #btaMOVPlusGameRat/10#,
			btaMOV = #btaMOV/10#,
			btaYPPDif = #btaYPPDif/10#,
			btaPavgDif = #btaPavgDif/10#,
			btaRavgDif = #btaRavgDif/10#,
			btaTOPDif = #btaTOPDif/10#
	WHERE TEAM = '#arguments.theTeam#'
	AND WEEK = #theweek#
	</cfquery>
	
	<cfquery datasource="sysstats3" name="updit">
	UPDATE AvgGameInsights 
		SET PowerRating = 10 + ((btaMOVPlusGameRat/100) * 10) 
	WHERE WEEK = #theweek#	
	</cfquery>
	</cfif>
	
	
	

</cffunction>


<cffunction name="createStats" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />

<cfset theweek = #arguments.theweek#>

<cfquery datasource="sysstats3" name="GetIt">
	SELECT AVG(s2.ps) as NFLAVGPS, AVG(s2.dps) as NFLAVGDPS, 100*(Avg(dfumbleslost) /Avg(dTurnovers)) as NFLLuckFactor 
	FROM Sysstats s2
	Where week <= #theweek#
</cfquery>

<cfset aPS  = GetIt.NFLAVGPS>
<cfset aDPS = GetIt.NFLAVGDPS>
<cfset aLuckFactor = GetIt.NFLLuckFactor>

<cfquery datasource="sysstats3" name="GetItTm">
	SELECT TEAM, AVG(ps) as avPS, AVG(dps) as avDPS, Avg(dfumbleslost) as avdFumLost, Avg(dTurnovers) as avDto 
	FROM Sysstats 
	WHERE Week <= #theweek#
	Group by Team
</cfquery>

<cfdump var="#Getit#">
<cfdump var="#GetitTm#">

<cfloop query="GetItTm">
	<cfset psBTA = ((avPs - aPs)/aPs)*100>
	<cfset dpsBTA = ((adPs - avdPs)/adPs)*100>
	
	<cfset LF = 0>
	<cfif avDto neq 0>
		<cfset LF = (avdFumLost / avDto)*100>
	</cfif>
	
	<cfset btaLuckFactor = 0>
	<cfif LF neq 0>
		<cfset btaLuckFactor = ((LF - aLuckFactor) / LF)>   
	</cfif>
	
	<cfquery datasource="sysstats3" name="GetItTm">
	UPDATE AvgGameInsights
	SET BTAPS = #psBTA#,
		BTAdps = #dpsBTA#,
		BTAPtDif = #psBTA + dpsBTA#,
		btaLuckFactor = #100*btaLuckFactor#,
		LuckFactor = #lf#
	WHERE Team = '#team#' 
	and week = #theweek#
	</cfquery>

	<cfquery datasource="sysstats3" name="GetItTm">
	UPDATE AvgGameInsights
	SET PowerRatingAdjForOpp = ((((btaOppPtDif/100) * (ABS(btaPtDif))) + btaPtDif)/100)*15
	WHERE Team = '#team#' 
	and week = #theweek#
	</cfquery>

	<cfquery datasource="sysstats3" name="GetItTm">
	UPDATE AvgGameInsights
	SET PowerRatingAdjForOppWithTrending = PowerRatingAdjForOpp + ((TrendingUpDown/100) * ABS(PowerRatingAdjForOpp))
	WHERE Team = '#team#' 
	and week = #theweek#
	</cfquery>


</cfloop>

 	<cfquery datasource="sysstats3" name="GetAGI">
		SELECT Distinct Team	
		FROM Sysstats
	</cfquery>

	<cfquery datasource="sysstats3" name="GetAvgNFL">
			SELECT 	AVG(btaPtDif) as NFLAvg
			FROM AvgGameInsights 
			
	</cfquery>
			
	<cfloop query="GetAGI">
		
		<cfquery datasource="sysstats3" name="Getopp">
		SELECT gi.opp, gi.week	
		FROM GameInsights gi
		where gi.Team = '#GetAGI.Team#'
		AND Week <= #theweek#
		</cfquery>

		<cfset gamect = 0>
		<cfset stat = 0>

		<cfloop query="GetOpp">
		
			<cfquery datasource="sysstats3" name="Getoppstats">
			SELECT 	AVG(btaPtDif) as avPowerRating
			FROM AvgGameInsights 
			where Team = '#GetOpp.opp#'
			and week = #Getopp.week#
			</cfquery>

			<cfoutput query="GetOppStats">
								
				<cfset gamect = gamect + 1>
				<cfset stat = stat + GetOppStats.avPowerRating - GetAvgNFL.NFLAvg>

			</cfoutput>

		</cfloop>

				<cfoutput>
				final stat .... #stat#<br>
				</cfoutput>


		<cfquery datasource="sysstats3" name="Updit">
		UPDATE AVGGameInsights
		SET btaoppPtDif = #Stat/gamect#
		where Team = '#GetAGI.Team#'
		and week = #theweek#
		</cfquery>

		<cfquery datasource="sysstats3" name="Updit">
		UPDATE AVGGameInsights
		SET AvgAllPowerRatings = (PowerRatingAdjForOpp + PowerRatingAdjForOppWithTrending) / 2
		where Team = '#GetAGI.Team#'
		and week = #theweek#
		</cfquery>

		<cfquery datasource="sysstats3" name="Updit">
				UPDATE AVGGameInsights
				SET HomePowerRat = PowerRatingAdjForOppWithTrending + (PowerRatingAdjForOppWithTrending*(HomePerfRat/100)),
					AwayPowerRat = PowerRatingAdjForOppWithTrending + (PowerRatingAdjForOppWithTrending*(AwayPerfRat/100))
				 
				where week = #theweek#
				and team = '#GetAGI.Team#'
		</cfquery> 

		
	</cfloop>
 
	--How lucky has a team been? Check Turnovers vs dTurnovers 
	-- If PLUS in turnovers, what pct of the turnovers
	
</cffunction>



<cffunction name="createOppPavgDif" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />

	<cfquery datasource="sysstats3" name="GetAGI">
		SELECT Distinct Team	
		FROM Sysstats
	</cfquery>

	<cfloop query="GetAGI">
	
		<cfquery datasource="sysstats3" name="Getopp">
		SELECT gi.opp	
		FROM GameInsights gi
		where gi.Team = '#GetAGI.Team#'
		</cfquery>

		<cfset gamect = 0>
		<cfset stat = 0>


		<cfloop query="GetOpp">

			<cfquery datasource="sysstats3" name="Getoppstats">
			SELECT 	AVG(PavgDif) as avPowerRating
			FROM AvgGameInsights 
			where Team = '#GetOpp.opp#'
			
			
			</cfquery>

			<cfoutput query="GetOppStats">
				<cfset gamect = gamect + 1>
				<cfif GetOppStats.avPowerRating neq ''>
					<cfset stat = stat + #GetOppStats.avPowerRating#>
				</cfif>
			</cfoutput>

		</cfloop>

				<cfoutput>
				final stat .... #stat#<br>
				</cfoutput>


		<cfquery datasource="sysstats3" name="Updit">
		UPDATE AVGGameInsights
		SET oppPavgDif = #Stat/gamect#
		where Team = '#GetAGI.Team#'
		and week = #arguments.theweek#
		</cfquery>
		
	</cfloop>


		<cfquery datasource="sysstats3" name="Updit">
		UPDATE AVGGameInsights
		SET adjPavgDif = pAvgDif + (((100*(( (10 + oppPavgDif) -10)/10))/100)*PavgDif)  
		where week = #arguments.theweek#
		and Team <> 'AVGTeam'
		</cfquery>

</cffunction>


<cffunction name="updateNFLSPDSFlags" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />

		

		<cfquery datasource="sysstats3" name="GetGames2">
		SELECT MAX(Gametime) as MNF, MIN(Gametime) as TNF 
		FROM NFLSPDS
		where week = #arguments.theweek#
		</cfquery>

		<cfquery datasource="sysstats3" name="GetUpd">
		UPDATE NFLSPDS
		SET MNF_FLAG   = 'Y'
		WHERE Gametime = '#GetGames2.MNF#'
		AND week       = #arguments.theweek#
		</cfquery>
		
		<cfquery datasource="sysstats3" name="GetUpd">
		UPDATE NFLSPDS
		SET TNF_FLAG   = 'Y'
		WHERE Gametime = '#GetGames2.TNF#'
		AND week       = #arguments.theweek#
		</cfquery>


		gethere1
		<cfset thegames = getGames(#arguments.theweek#)>
		gethere2
		<cfloop query="#thegames#">
			gethere3
			checking #arguments.theweek#, #fav#, #und#<br>
		
			<cfset temp = checkDivisional(#arguments.theweek#,'#fav#','#und#') >
		
		</cfloop>

</cffunction>



<cffunction name="checkDivisional" access="remote" output="yes" returntype="Void">
	<cfargument name="theWeek"    type="Numeric"  required="yes" />
	<cfargument name="fav"        type="String"  required="yes" />
	<cfargument name="und"        type="String"  required="yes" />

	<cfquery datasource="sysstats3" name="GetAFCEast">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'AFCEAST'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetAFCNorth">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'AFCNORTH'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetAFCWest">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'AFCWEST'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetAFCSouth">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'AFCSOUTH'
	</cfquery>



	<cfquery datasource="sysstats3" name="GetNFCEast">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'NFCEAST'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetNFCCentral">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'NFCCENTRAL'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetNFCWest">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'NFCWEST'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetNFCSouth">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'NFCSOUTH'
	</cfquery>


	<cfif GetAfcEast.Recordcount is 2 or GetAfcWest.Recordcount is 2 or GetAfcNorth.Recordcount is 2 or GetAfcSouth.Recordcount is 2 or	
		  GetNfcEast.Recordcount is 2 or GetNfcWest.Recordcount is 2 or GetNfcCentral.Recordcount is 2 or GetNfcSouth.Recordcount is 2>
		
		<cfquery datasource="sysstats3" name="GetUpd">
		UPDATE NFLSPDS
		SET DIV_GAME_FLAG = 'Y'
		WHERE Fav         = '#arguments.fav#'
		AND week          = #arguments.theweek#
		</cfquery>
		
	</cfif>		


</cffunction>



<cffunction name="checkTravel" access="remote" output="yes" returntype="Void">
	<cfargument name="theWeek"    type="Numeric"  required="yes" />
	<cfargument name="fav"        type="String"  required="yes" />
	<cfargument name="und"        type="String"  required="yes" />
	
	<cfquery datasource="sysstats3" name="GetMatch2">
		SELECT u.Team as UTeam, f.Team as FTeam 
		FROM Teams u, Teams f
		where u.Team ='#arguments.UND#'
		and   f.Team ='#arguments.FAV#'
		AND 
		(
			(u.Location = 'EAST' and f.Location = 'WEST') OR
			(u.Location = 'WEST' and f.Location = 'EAST') 
		)	
			
	</cfquery>

	<cfif GetMatch2.recordcount gt 0>
		<cfquery datasource="sysstats3" name="UpdMatch2">
		Update NFLSPDS 
		SET Extra_Travel_Flag = 'Y'
		WHERE (Fav = '#GetMatch2.FTeam#')
		and week = #arguments.theweek#
		</cfquery>
	</cfif>

</cffunction>

<cffunction name="createFortunateRating" access="remote" output="yes" returntype="Void">
	<cfargument name="theWeek"    type="Numeric"  required="yes" />

	<cfquery datasource="sysstats3" name="GetMatch">
		Update SysStats  
		SET  FortunateRating = 0 
		
	</cfquery>
	
	<cfquery datasource="sysstats3" name="GetMatch">
		Update SysStats  
		SET  FortunateRating = 10* ((((dFumblesLost/dTurnovers)*100)/100) * (dturnovers - turnovers))
		Where dTurnovers <> 0
	</cfquery>
	
	<cfquery datasource="sysstats3" name="GetMatch">
		Select Team, AVG(FortunateRating) as rat  
		from Sysstats
		group by team
		order by 2 desc	
	</cfquery>
	
	<cfloop query="GetMatch">
		<cfquery datasource="sysstats3" name="UpdGetMatch">
		Update AvgGameInsights  
		SET  FortunateRating = #GetMatch.rat#
		Where Team = '#GetMatch.Team#'
		and week = #arguments.theweek#
		</cfquery>
	</cfloop>
	<cfdump var="#GetMatch#">
	

</cffunction>


<cffunction name="createPower" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />

	<cfquery datasource="sysstats3" name="GetAGI">
		SELECT Distinct Team	
		FROM Sysstats
	</cfquery>

	<cfloop query="GetAGI">

		<cfset gamect = 0>
		<cfset stat = 0>

			<cfquery datasource="sysstats3" name="GetTeamStats">
			SELECT Team, opp, week, Pavg, dPavg, SackMadePct, SackAllowPct
			FROM Sysstats 
			where Team = '#GetAGI.Team#'
			</cfquery>

			<cfloop query="GetTeamStats">
				
				<cfquery datasource="sysstats3" name="GetoppAvg">
				SELECT AVG(pavg) as aPavg, AVG(dpavg) as aDpavg, AVG(SackMadePct) as aSackMadePct, AVG(SackAllowPct) as aSackAllowPct 	
				FROM Sysstats 
				where Team = '#GetTeamstats.opp#'
				</cfquery>

				Compare Game Stats to oppAvgs...
				<cfset PavgPow  = GetTeamstats.pavg - GetOppAvg.adpavg>
				<cfset dPavgPow = GetOppAvg.apavg - GetTeamstats.dpavg>

				<cfset SackForPow     = GetTeamstats.SackMadePct - GetoppAvg.aSackAllowPct>
				<cfset SackAgainstPow = GetoppAvg.aSackMadePct - GetTeamstats.SackAllowPct>
				


				<cfquery datasource="sysstats3" name="Updit">
				UPDATE Sysstats
					Set POWPavg  = #PavgPow#,
                        POWdPavg = #dPavgPow#,		
						PowPassOverall = #PavgPow + dPavgPow#,
						PowSackForPct = #SackForPow#,
						PowSackAgainstPct = #SackAgainstPow#
						
				where Team = '#GetTeamStats.team#'
				and week = #GetTeamStats.week#
				</cfquery>
				
			</cfloop>

	</cfloop>
</cffunction>	





<cffunction name="getAvgGameInsights" access="remote" output="yes" returntype="Query">
<cfargument name="theWeek" type="Numeric"  required="yes" />
<cfargument name="team" type="String"  required="no" />

	<cfif arguments.Team gt ''>
	
		<cfquery datasource="sysstats3" name="GetData">
		SELECT * FROM AvgGameInsights where week = #arguments.theweek# and team='#arguments.Team#'
		</cfquery>
	<cfelse>

		<cfquery datasource="sysstats3" name="GetData">
		SELECT * FROM AvgGameInsights where week = #arguments.theweek#
		</cfquery>
	</cfif>
	<cfreturn #GetData#>

</cffunction>	








<cffunction name="createPreGameStats" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />


	
	
	<Table width="50%" border="0" align="center">
	<tr>
	<td align="left">
	<h3>
	Advantage Line Explained
	</h3>
	</td>
	</tr>
	<tr>
	<td bgcolor="Green">Favorite Has The Advantage</td>
	</tr>
	<tr>
	<td bgcolor="Red"> Underdog Has The Advantage</td>
	</tr>
	
	<tr>
	<td>PowerRat - This is the preditced point differential with home field factored in.</td>
	</tr>
	<tr>
	<td>PredictedPassAvg - What my projected Yards/Pass Attempt differential is</td>
	</tr>
	<tr>
	<td>Trending - The difference in the teams Trending direction.</td>
	</tr>
	<tr>
	<td>FortunateRat - The difference in how "lucky" the teams are in comparison</td>
	</tr>
	<tr>
	<td>PassPower - The difference in a teams ability to pass and defend the pass</td>
	</tr>
	<tr>
	<td>OppPowerRat - The difference in teams opponents strength</td>
	</tr>
	<tr>
	<td>OffBye? - Is there an advantage because a team is off a bye?</td>
	</tr>
	<tr>
	<td>OffMNF? - Is there an advantage because a team is off a Monday Night game?</td>
	</tr>
	<tr>
	<td>OffTNF? - Is there an advantage because a team is off a Thursday Night game?</td>
	</tr>
	<tr>
	<td>OffDivGame? - Is there an advantage because a team is off a Divisional game?</td>
	</tr>
	<tr>
	<td>ExtraTravel? - Is there an advantage because a team is off extra travel?</td>
	</tr>
	<tr>
	<td>ConseqRdCt - Is there an advantage because a team is off consequtive Away game(s)?</td>
	</tr>
	<tr>
	<td>Spot Level - New Factor I am Testing, tested strong for 2018</td>
	</tr>
	</table>

	<cfset spdweek = arguments.theweek+1>
	<cfset theGames = getGames(#spdweek#)>
	<cfloop query="#theGames#">


	<cfset vWeek = 0>
	<cfset vGametime = "" >	
	<cfset vFav ="">	
	<cfset vHA	= "" >
	<cfset vSpread = 0 >	
	<cfset vUnd	= "" >

	<cfset vFavPowerRating = 0 >	
	<cfset vFavTrending	= 0 >
	<cfset vFavFortunateRating = 0 >	
	<cfset vFavPassRating = 0 >
	
	<cfset vFavProjPavg	= 0 >
	
	<cfset vUndPowerRating	= 0 >
	<cfset vUndTrending	= 0 >
	<cfset vUndFortunateRating = 0 >	
	<cfset vUndPassRating = 0 >	
	
	<cfset vUndProjPavg	= 0 >
	<cfset vFavProjPavgConfidence = 0 >
	<cfset vUndProjPavgConfidence = 0 >
	
	<cfset vFavHomePerfRat = 0 >
	<cfset vFavAwayPerfRat = 0 >
	<cfset vUndHomePerfRat = 0 >	
	<cfset vUndAwayPerfRat = 0 >
	
	<cfset vFavConseqRdCt = 0 >
	<cfset vUndConseqRdCt = 0 >
	
	<cfset vFavOffMNF_Flag = "" >
	<cfset vUndOffMNF_Flag = "" >
	<cfset vFavOffTNF_Flag	= "" >
	<cfset vUndOffTNF_Flag = "" >

	<cfset vFavAFANum = 0> 
	<cfset vUndAFANum = 0>

	<cfset vFavHFANum = 0> 
	<cfset vUndHFANum = 0>

		<cfset vweek = #week#>
		<cfset vGametime = #gametime#>
		<cfset vFav = '#fav#'>
		<cfset vUnd = '#und#'>
		<cfset vHA = '#ha#'>
		<cfset vSpread = #spread#>
		<cfset spdweek = vweek + 1>

		<cfif vHA is 'H'>
			<cfset useForHFA = getHFA('#vFav#','#vUnd#')>
		<cfelse>
			<cfset useForHFA = getHFA('#vUnd#','#vFav#')>
		</cfif>

		<cfset FavCheckExpectationNum=getGameInsights(#vweek# - 1, '#vfav#')>
		<cfset UndCheckExpectationNum=getGameInsights(#vweek# - 1, '#vund#')>

		<cfset FavLevel1 = ''>
		<cfset FavLevel2 = ''>
		<cfset UndLevel1 = ''>
		<cfset UndLevel2 = ''>
		
		<cfif FavCheckExpectationNum.ExpectationNum is -2>
			<cfset FavLevel1 = 'Y'>
		</cfif>	

		<cfif FavCheckExpectationNum.ExpectationNum lt -2>
			<cfset FavLevel2 = 'Y'>
		</cfif>	

		<cfif UndCheckExpectationNum.ExpectationNum is -2>
			<cfset UndLevel1 = 'Y'>
		</cfif>	

		<cfif UndCheckExpectationNum.ExpectationNum lt -2>
			<cfset UndLevel2 = 'Y'>
		</cfif>	

		<cfif 1 is 2>
		#vFav#<br>
		#vweek#<br> 
		#vGametime#<br>
		#vUnd#<br>
		#vHA#<br>
		#vSpread#<br>
		<p>
		</cfif>
	
		<!--- Get the stats for the weeks before the spread week --->
		<cfset agi = getAvgGameInsights(vweek - 1,'#vfav#')>
		
		<cfset vFavPowerRating     = #agi.PowerRatingAdjForOpp#>	
		<cfset vFavTrending	       = #agi.TrendingUpDown#>
		<cfset vFavFortunateRating = #agi.FortunateRating# >	
		<cfset vFavPassRating      = #agi.AdjPavgDif#>
		<cfset vFavOppPR           = #agi.oppPowerRatings#>
		<cfif vha is 'H'>
			<cfset vFavHomePerfRat     = #agi.homeperfrat#>
			<cfset vFavHFANum          = #agi.hFANum#>
			
		<cfelse>
			<cfset vFavAwayPerfRat     = #agi.awayperfrat#>
			<cfset vFavAFANum          = #agi.aFANum#>
			
		</cfif>
		
		<cfset agi = getAvgGameInsights(vweek - 1,'#vund#')>
		
		<cfset vUndPowerRating     = #agi.PowerRatingAdjForOpp#>	
		<cfset vUndTrending	       = #agi.TrendingUpDown#>
		<cfset vUndFortunateRating = #agi.FortunateRating# >	
		<cfset vUndPassRating      = #agi.AdjPavgDif#>
		<cfset vUndOppPR           = #agi.oppPowerRatings#>
		<cfif vha is 'A'>
			<cfset vUndHomePerfRat     = #agi.homeperfrat#>
			<cfset vUndHFANum          = #agi.hFANum#>
		<cfelse>
			<cfset vUndAwayPerfRat     = #agi.awayperfrat#>
			<cfset vUndAFANum          = #agi.aFANum#>
		</cfif>

		<cfif 1 is 2>

		vFavPowerRating=#vFavPowerRating#<br>	
		vFavTrending=#vFavTrending#<br>	       
		vFavFortunateRating=#vFavFortunateRating#<br> 	
		vFavPassRating=#vFavPassRating#<br>      
		vFavOppPR=#vFavOppPR#<br> 
		vFavHomePerfRat= #vFavHomePerfRat#<br>
		vFavAwayPerfRat= #vFavAwayPerfRat#<br>
		vFavHFanum= #vFavHFanum#<br>
		vFavAFanum= #vFavAFanum#<br>
		
		<p>
		
		vUndPowerRating=#vUndPowerRating#<br>	
		vUndTrending=#vUndTrending#<br>	       
		vUndFortunateRating=#vUndFortunateRating#<br> 	
		vUndPassRating=#vUndPassRating#<br>      
		vundOppPR=#vUndOppPR#<br>  
		vUndHomePerfRat= #vUndHomePerfRat#<br>
		vUndAwayPerfRat= #vUndAwayPerfRat#<br>
		vUndHFanum= #vUndHFanum#<br>
		vUndAFanum= #vUndAFanum#<br>
		
		<p>

		</cfif>


		<cfset FavOffBye = ''>
		<cfset UndOffBye = ''>
		


		<cfset FavLastGame = getGames(#arguments.theweek#,'#fav#')>
		<cfset UndLastGame = getGames(#arguments.theweek#,'#und#')>

		<cfset vFavOffMNF_Flag = ''>
		<cfset vFavOffTNF_Flag = ''>
		<cfset vFavOffDIV_Flag = ''>
		<cfset vFavOffTravel_Flag = ''>


		<cfif FavLastGame.recordcount is 0>
			<cfset FavOffBye = 'Y'>
		<cfelse>
			<cfset vFavOffMNF_Flag     = '#FavLastGame.MNF_FLAG#'>
			<cfset vFavOffTNF_Flag     = '#FavLastGame.TNF_FLAG#'>
			<cfset vFavOffDIV_Flag     = '#FavLastGame.DIV_Game_Flag#'>
			<cfset vFavOffTravel_Flag  = '#FavLastGame.Extra_Travel_Flag#'>
						
		</cfif>	

		<cfset vUndOffMNF_Flag = ''>
		<cfset vFavOffTNF_Flag = ''>
		<cfset vFavOffDIV_Flag = ''>
		<cfset vFavOffTravel_Flag = ''>

		<cfset vUndOffTNF_Flag = ''>
		<cfset vUndOffDIV_Flag = ''>
		<cfset vUndOffTravel_Flag = ''>


		
		<cfif FavLastGame.recordcount is 0>
			<cfset FavOffBye = 'Y'>
		<cfelse>
			<cfset vFavOffMNF_Flag     = '#FavLastGame.MNF_FLAG#'>
			<cfset vFavOffTNF_Flag     = '#FavLastGame.TNF_FLAG#'>
			<cfset vFavOffDIV_Flag     = '#FavLastGame.DIV_Game_Flag#'>
			<cfset vFavOffTravel_Flag  = '#FavLastGame.Extra_Travel_Flag#'>
						
		</cfif>	

		<cfif 1 is 2>
		<cfoutput>
			FavOffBye           = '#FavOffBye#'<br>
			vFavOffMNF_Flag     = '#vFavOffMNF_Flag#'<br>
			vFavOffTNF_Flag     = '#vFavOffTNF_Flag#'<br>
			vFavOffDIV_Flag     = '#vFavOffDIV_Flag#'<br>
			vFavOffTravel_Flag  = '#vFavOffTravel_Flag#'
			
			<p>
		
			UndOffBye           = '#UndOffBye#'<br>
			vUndOffMNF_Flag     = '#vUndOffMNF_Flag#'<br>
			vUndOffTNF_Flag     = '#vUndOffTNF_Flag#'<br>
			vUndOffDIV_Flag     = '#vUndOffDIV_Flag#'<br>
			vUndOffTravel_Flag  = '#vUndOffTravel_Flag#'
			<p>
		
		</cfoutput>
		</cfif>
		
		<cfif vweek gt 2>
			<cfset FavConseqRdCt = conseqAwayGamect(#vweek#,'#vfav#')>
			<cfset UndConseqRdCt = conseqAwayGamect(#vweek#,'#vund#')>
		</cfif>
		
		<cfif 1 is 2>
		<cfoutput>
		<p>
		FavConseqRdCt - #FavConseqRdCt#<br>
		UndConseqRdCt - #UndConseqRdCt#<br>
		<p>
		<p>
		</cfoutput>
		</cfif>
		
		<cfset vFavPavgProj = createPavgProjections(vWeek + 1,'#vFav#','#vUnd#')>
		<cfset vUndPavgProj = createPavgProjections(vWeek + 1,'#vUnd#','#vFav#')>

		<cfif 1 is 2>
		<p>
		<cfoutput>
		vFavPavgProj = #vFavPavgProj#<br>
		vUndPavgProj = #vUndPavgProj#<br>
		</cfoutput>
		<p>
		******************************************************************************************************************************
		<p>
		<p>
		</cfif>
	
	
	<cfif vha is 'H'>
		<cfset HFA = (vFavHFanum + ABS(vUndAFanum)) / 2>
	<cfelse>
		<cfset HFA = (vFavAFanum + ABS(vUndHFanum)) / 2>
	</cfif>	
	
	<cfset HFA = useForHFA>
	
	 
	<p>
	<p>
	<p>
	
	<cfif vweek lte 19> 
		<cfset FavConseqRdCt = 0>
		<cfset UndConseqRdCt = 0>
	</cfif>	
	
	<br>
	<Table width="80%" border="1" cellpadding="4" cellspacing="4">
	<tr>
	<td>Team</td>
	<td>PowerRat</td>
	<td>PredictedPassAvg</td>
	<td>Trending</td>
	<td>FortunateRat</td>
	<td>PassPower</td>
	<td>OppPowerRat</td>
	<td>OffBye?</td>
	<td>OffMNF?</td>
	<td>OffTNF?</td>
	<td>OffDivGame?</td>
	<td>ExtraTravel?</td>
	<td>ConseqRdCt</td>
	<td nowrap>Spot Level</td>
	</tr>

	<td nowrap>#vFav# -#vspread#</td>
	<td>#vFavPowerRating#</td>
	<td>#Numberformat(vFavPavgProj,'99.99')#</td>
	<td>#Numberformat(vFavTrending,'99.99')#</td>
	<td>#Numberformat(vFavFortunateRating,'999.99')#</td>
	<td>#Numberformat(vFavPassRating,'99.99')#</td>
	<td>#Numberformat(vFavOppPR,'99.99')#</td>
	<td>#FavOffBye#</td>
	<td>#vFavOffMNF_Flag#</td>
	<td>#vFavOffTNF_Flag#</td>
	<td>#vFavOffDIV_Flag#</td>
	<td>#vFavOffTravel_Flag#</td>
	<td>#FavConseqRdCt#</td>
	<cfif FavLevel1 is 'Y'>
		<td nowrap>Level 1</td>
	<cfelseif FavLevel2 is 'Y'>
		<td nowrap>Level 2</td>
	</cfif>	
	</tr>

	<tr>
	<td nowrap>#vUnd# +#vspread#</td>
	<td>#vUndPowerRating#</td>
	<td>#Numberformat(vUndPavgProj,'99.99')#</td>
	<td>#Numberformat(vUndTrending,'99.99')#</td>
	<td>#Numberformat(vUndFortunateRating,'999.99')#</td>
	<td>#Numberformat(vUndPassRating,'99.99')#</td>
	<td>#Numberformat(vUndOppPR,'99.99')#</td>
	<td>#UndOffBye#</td>
	<td>#vUndOffMNF_Flag#</td>
	<td>#vUndOffTNF_Flag#</td>
	<td>#vUndOffDIV_Flag#</td>
	<td>#vUndOffTravel_Flag#</td>
	<td>#UndConseqRdCt#</td>
	<cfif UndLevel1 is 'Y'>
		<td nowrap>Level 1</td>
	<cfelseif UndLevel2 is 'Y'>
		<td nowrap>Level 2</td>
	</cfif>
	</tr>
	
	<cfset ourspd = (vFavPowerRating - vUndPowerRating) + hfa>
	<cfset ourspd = #Numberformat(ourspd,'99.99')#>
	
	<cfset ourspdcolor = "">
	<cfif ourspd gt vspread>
		<cfset ourspdcolor = "Green">
	</cfif>	

	<cfif ourspd lt vspread>
		<cfset ourspdcolor = "Red">
	</cfif>	

	
	<cfset diff1 = vFavPavgProj - vUndPavgProj>
	<cfset diff1 = #Numberformat(diff1,'99.99')#>

		
	<cfset diff2 = vFavTrending - vUndTrending>
	<cfset diff2 = #Numberformat(diff2,'99.99')#>
		
	<cfset diff3 = vUndFortunateRating - vFavFortunateRating>
	<cfset diff3 = #Numberformat(diff3,'99.99')#>
		
	<cfset diff4 = vFavPassRating - vUndPassRating>
	<cfset diff4 = #Numberformat(diff4,'99.99')#>
		
	<cfset diff5 = vFavOppPR - vUndOppPR>
	<cfset diff5 = #Numberformat(diff5,'99.99')#>
	
	<cfSet MNFAdv = "">
	<cfSet TNFAdv = "">
	<cfSet DivAdv = "">

	<cfif diff1 gt 0>
		<cfset diff1color = "Green">
	<cfelse>
		<cfset diff1color = "Red">
	</cfif>	

	<cfif diff2 gt 0>
		<cfset diff2color = "Green">
	<cfelse>
		<cfset diff2color = "Red">
	</cfif>	

	<cfif diff3 gt 0>
		<cfset diff3color = "Green">
	<cfelse>
		<cfset diff3color = "Red">
	</cfif>	
	
	<cfif diff4 gt 0>
		<cfset diff4color = "Green">
	<cfelse>
		<cfset diff4color = "Red">
	</cfif>	

	<cfif diff5 gt 0>
		<cfset diff5color = "Green">
	<cfelse>
		<cfset diff5color = "Red">
	</cfif>	
	
	<cfSet MNFAdvcolor = "">
	<cfif vFavOffMNF_Flag is 'Y'>
		<cfSet MNFAdv = '#vund#'>
		<cfSet MNFAdvcolor = "Red">
	</cfif>

	<cfSet TNFAdvcolor = "">
	<cfif vFavOffTNF_Flag is 'Y'>
		<cfSet TNFAdv = '#vfav#'>
		<cfSet TNFAdvcolor = "Green">
	</cfif>
	
	<cfSet DivAdvColor = "">
	<cfif vFavOffDIV_Flag is 'Y'>
		<cfif vUndOffDIV_Flag is ''>
			<cfSet DivAdv = '#vund#'>
			<cfSet DivAdvColor = "Red">
		</cfif>
	</cfif>

	<cfif vUndOffMNF_Flag is 'Y'>
		<cfSet MNFAdv = '#vfav#'>
		<cfSet MNFAdvcolor = "Green">
	</cfif>

	<cfif vUndOffTNF_Flag is 'Y'>
		<cfSet TNFAdv = '#vund#'>
		<cfSet TNFAdvcolor = "Red">
	</cfif>
	
	<cfif vUndOffDIV_Flag is 'Y'>
		<cfif vFavOffDIV_Flag is ''>
			<cfSet DivAdv = '#vfav#'>
			<cfSet DivAdvColor = "Green">
		</cfif>
	</cfif>
	
	<cfset ConseqRdCtColor="">
	<cfif UndConseqRdCt - FavConseqRdCt gt 0>
		<cfset ConseqRdCtColor="Green">
	</cfif>
	
	<cfif UndConseqRdCt - FavConseqRdCt lt 0>
		<cfset ConseqRdCtColor="Red">
	</cfif>

	<cfif ourspd gt 0>
		<cfset Line = '#vfav# by #ourspd#'>
	<cfelse>
		<cfset Line = '#vund# by #abs(ourspd)# '>
	</cfif>
	
	<tr>
	<td>Advantage</td>
	<td nowrap bgcolor="#ourspdcolor#">My Line:#line# <cfif ourspd lt 0 and vspread neq 0>Wrong Team Favored!</cfif></td>
	<td bgcolor="#diff1Color#">#diff1#</td>
	<td bgcolor="#diff2Color#">#diff2#</td>
	<td bgcolor="#diff3Color#">#diff3#</td>
	<td bgcolor="#diff4Color#">#diff4#</td>
	<td bgcolor="#diff5Color#">#diff5#</td>
	<td>#UndOffBye#</td>
	<td bgcolor="#MNFAdvColor#">#MNFAdv#</td>
	<td bgcolor="#TNFAdvColor#">#TNFAdv#</td>
	<td bgcolor="#DIVAdvColor#">#DIVAdv#</td>
	<td>N/A</td>
	<td bgcolor="#ConseqRdCtColor#">#UndConseqRdCt - FavConseqRdCt#</td>
	</tr>

</table>
<p></p>
<p></p>
<p></p>
		
	<cfquery datasource="sysstats3" name="GetStats">
	Select (Avg(f.ExpectedPS) + Avg(u.ExpectedDPS) + Avg(u.ExpectedPS) + Avg(f.ExpectedDPS)) / 2  as PredPts
        from Sysstats f, Sysstats u
	where f.Team = '#vfav#'
        and u.Team = '#vund#'
		and f.week > 16
		and u.week > 16
	</cfquery>


	<cfoutput>
	Predicted Pts for #myfav#/#myund# #GetStats.PredPts#<br>
	</cfoutput>
	
		
	</cfloop>

</cffunction>	

<cffunction name="conseqAwayGamect" access="remote" output="yes" returntype="Numeric">
<cfargument name="Week"    type="Numeric"  required="yes" />
<cfargument name="Team"    type="String"  required="yes" />

<cfquery datasource="sysstats3" name="GetData">
Select * from Sysstats 
where ha   = 'A' 
and Team   = '#arguments.Team#' 
and (week >= #arguments.Week# - 4 and week < #arguments.week#)
order by week desc
</cfquery>

<cfset AwayCt1 = 0>
<cfset AwayCt2 = 0>
<cfset AwayCt3 = 0>
<cfset AwayCt4 = 0>
<cfset AwayCt = 0>

<cfset LastTwoAway   = ''>
<cfset LastThreeAway = ''>
<cfset LastFourAway  = ''>

<cfloop query="GetData">
	
	<cfif arguments.Week - GetData.week is 1>
		<cfset AwayCt1 = 1>
	</cfif>
	
	<cfif arguments.Week - GetData.week is 2>
		<cfset AwayCt2 = 1>
	</cfif>
	
	<cfif arguments.Week - GetData.week is 3>
		<cfset AwayCt3 = 1>
	</cfif>
	
	<cfif arguments.Week - GetData.week is 4>
		<cfset AwayCt4 = 1>
	</cfif>
</cfloop>


	<cfif AwayCt1 is 1>
		<Cfset AwayCt = AwayCt + 1>
		<cfif AwayCt2 is 1>
			<Cfset AwayCt = AwayCt + 1>
			<cfset LastTwoAway = 'Y'>
			<cfif AwayCt3 is 1>
				<Cfset AwayCt = AwayCt + 1>
				<cfset LastTHreeAway = 'Y'>
				<cfif AwayCt4 is 1>
					<Cfset AwayCt = AwayCt + 1>
					<cfset LastFourAway = 'Y'>
				</cfif>
			</cfif>
		</cfif>	
	</cfif>	
	
	<cfreturn #AwayCt#>
	
</cffunction>




<cffunction name="createPavgProjections" access="remote" output="yes" returntype="Numeric">
<cfargument name="Week"    type="Numeric"  required="yes" />
<cfargument name="Team"    type="String"  required="yes" />
<cfargument name="Opp"     type="String"  required="yes" />

<cfquery datasource="sysstats3" name="GetTeamData">
Select AVG(pavg) as avPavg, AVG(dPavg) as avdPavg, AVG(PowPavg) as avPowPavg, AVG(PowdPavg) as avPowdPavg, AVG(SackMadePct) as avSackMadePct, AVG(SackAllowPct) as avSackAllowPct 
from Sysstats 
where Team   = '#arguments.Team#' 
and week < #arguments.week#
</cfquery>

<cfquery datasource="sysstats3" name="GetOppData">
Select AVG(pavg) as avPavg, AVG(dPavg) as avdPavg, AVG(PowPavg) as avPowPavg, AVG(PowdPavg) as avPowdPavg, AVG(SackMadePct) as avSackMadePct, AVG(SackAllowPct) as avSackAllowPct 
from Sysstats 
where Team   = '#arguments.opp#' 
and week < #arguments.week#
</cfquery>

<cfif 1 is 2>
*** JIM *** <br>
Team = '#arguments.Team#'<br>
opp = '#arguments.opp#'<br>
GetTeamData.avPavg = #GetTeamData.avPavg#<br>  
GetOppData.avPowdPavg = #GetOppData.avPowdPavg#<br> 
</cfif>

<cfset TeamProj1 = GetTeamData.avPavg - GetOppData.avPowdPavg>

<cfif 1 is 2>
<p>
GetTeamData.avPowPavg = #GetTeamData.avPowPavg#<br>  
GetOppData.avdPavg = #GetOppData.avdPavg#<br> 
</cfif>

<cfset TeamProj2 = GetTeamData.avPowPavg + GetOppData.avdPavg>


<cfreturn ((#TeamProj1# + #TeamProj2#))/2> 

</cffunction>

<cffunction name="analyzeStats" access="remote" output="yes" returntype="Numeric">
<cfargument name="Week"    type="Numeric"  required="yes" />
<cfargument name="Team"    type="String"  required="yes" />
<cfargument name="Opp"     type="String"  required="yes" />


</cffunction>





<cffunction name="createExpectationNum" access="remote" output="yes" returntype="void">

<cfquery name="GetTeams" datasource="sysstats3">
Select Distinct Team
from GameInsights
</cfquery>

<cfloop query="GetTeams">

<cfquery name="GetStats" datasource="sysstats3">
Select Week, Team, Expectation, TeamCovered
from GameInsights
Where Team = '#GetTeams.Team#'
order by Week
</cfquery>

<cfset ct = 0>
<cfloop query="GetStats">
	<cfif GetStats.Expectation is 'ABOVE'>
		<cfset ct = ct + 1>
	<cfelseif GetStats.Expectation is 'BELOW'> 	
		<cfset ct = ct - 1>
	</cfif>
	
	<cfif GetStats.TeamCovered is 'Y'>
		<cfset ct = 0>
	</cfif>
	
	<cfquery name="UpdStats" datasource="sysstats3">
	UPDATE GameInsights
	SET ExpectationNum = #ct#
	WHERE Week = #GetStats.Week#
	AND TEAM = '#GetTeams.Team#'
	</cfquery>

	


</cfloop>

</cfloop>

When ExpectationNum gets to -3 strong play
Even -2 shows promise...


</cffunction>



<cffunction name="getGameInsights" access="remote" output="yes" returntype="Query">
<cfargument name="Week"    type="Numeric"  required="yes" />
<cfargument name="Team"    type="String"  required="yes" />

<cfquery name="GetStats" datasource="sysstats3">
Select *
from GameInsights
where Team = '#Arguments.Team#'
and week   = #Arguments.Week#
</cfquery>

<cfreturn #GetStats#>

</cffunction>







<cffunction name="createHomeFieldADV" access="remote" output="yes" returntype="Void">
<cfargument name="Week" type="Numeric" required="yes" />
<cfargument name="Team" type="String"  required="yes" />

<cfquery name="GetStats" datasource="sysstats3">
Select (2.2 + h.homeperfrat) as HomeAdv, (-2.2 + a.AwayPerfRat) as AwayAdv, ((2.2 + h.homeperfrat) - (-2.2 + a.AwayPerfRat))/2 as HFACalc
from AVGGameInsights h, AVGGameInsights a 
where h.Team = '#Arguments.Team#'
and a.Team   = '#Arguments.Team#'
and a.week   = #Arguments.Week#
and h.week   = #Arguments.Week#
</cfquery>




<cfquery name="updateit" datasource="sysstats3">
Update Teams
set HomeADV = #GetStats.HomeADV#,
    AwayADV = #GetStats.AwayADV#
where Team = '#Arguments.Team#'
</cfquery>


</cffunction>


<cffunction name="getHFA" access="remote" output="yes" returntype="Numeric">
<cfargument name="HomeTeam" type="String" required="yes" />
<cfargument name="AwayTeam" type="String" required="yes" />


<cfquery name="GetStats" datasource="sysstats3">
Select (h.HomeAdv - a.AwayADV) / 2 as HFACalc
from Teams h, Teams a 
where h.Team = '#Arguments.HomeTeam#'
and a.Team   = '#Arguments.AwayTeam#'
</cfquery>

<cfreturn #GetStats.HFACalc#>

</cffunction>


<cffunction name="calculateHFA" access="remote" output="yes" returntype="Void">
<cfargument name="Week" type="Numeric" required="yes" />

<cfquery name="GetStats" datasource="sysstats3">
Select Team,h.homeperfrat as HomeAdv, h.AwayPerfRat as AwayAdv
from AVGGameInsights h 
where h.week   = #arguments.Week#
</cfquery>

<cfloop query="GetStats">

<cfset useHFA = 2.75>
<cfset useAFA = 2.75>

<cfif homeADV gte 1 and homeadv lte 2>
	<cfset useHFA = 3.5>
</cfif>
	
<cfif homeADV gt 2>
	<cfset useHFA = 4>
</cfif>

<cfif homeADV lte -1 and homeadv gte -2>
	<cfset useHFA = 2.0>
</cfif>

<cfif homeADV lt -2>
	<cfset useHFA = 1.75>
</cfif>


<cfif awayADV lte -1 and awayadv gte -2>
	<cfset useAFA = 3.5>
</cfif>
	
<cfif awayADV lt -2>
	<cfset useAFA = 4>
</cfif>

<cfif awayADV gte 1 and awayadv lte 2>
	<cfset useAFA = 3.5>
</cfif>
	
<cfif awayADV gt 2>
	<cfset useAFA = 4>
</cfif>


<cfquery name="updateit" datasource="sysstats3">
Update Teams
set useHFA = #useHFA#,
    useAFA = #useAFA#
where Team = '#GetSTats.Team#'	
</cfquery>

</cfloop>



<cfquery name="GetStats" datasource="sysstats3">
Select * from Teams
</cfquery>

<cfloop query="GetStats">

<cfset xuseHFA = 2.75>
<cfset xuseAFA = 2.75>

<cfif homeADV gte 1 and homeadv lte 2>
	
	<cfset xuseHFA = 3.5>
	
</cfif>
	
<cfif homeADV gt 2>

	<cfset xuseHFA = 4>
</cfif>

<cfif homeADV lte -1 and homeadv gte -2>

	<cfset xuseHFA = 2.0>
</cfif>

<cfif homeADV lt -2>

	<cfset xuseHFA = 1.75>
</cfif>


<cfif awayADV lte -1 and awayadv gte -2>

	<cfset xuseAFA = 3.5>
</cfif>
	
<cfif awayADV lt -2>

	<cfset xuseAFA = 4>
</cfif>

<cfif awayADV gte 1 and awayadv lte 2>

	<cfset xuseAFA = 3.5>
</cfif>
	
<cfif awayADV gt 2>

	<cfset xuseAFA = 4>
</cfif>
<p>

<cfquery name="updateit" datasource="sysstats3">
Update Teams
set useHFA = #xuseHFA#,
    useAFA = #xuseAFA#
where Team = '#GetSTats.Team#'	
</cfquery>

</cfloop>



</cffunction>


<cffunction name="updateExpectedPts" access="remote" output="yes" returntype="Void">


<cfquery datasource="sysstats3" name="Getit">
Update Sysstats
set ExpectedPS = ((3.2 * again) + 3) + (1.7 * (dTurnovers - Turnovers)),
ExpectedDPS = ((3.2 * dagain) + 3) - (1.7 * (dTurnovers - Turnovers))
</cfquery>

<cfquery datasource="sysstats3" name="Getit2">
Select Team, count(*) as gms, AVG(PS) - AVG(ExpectedPS) as OffOverrated, AVG(ExpectedDPS) - AVG(DPS) as DefOverrated, 
((AVG(PS) - AVG(ExpectedPS) + AVG(ExpectedDPS) - AVG(DPS))/count(*)) as AdjPts , (AVG(PS) - AVG(ExpectedPS)) - (AVG(ExpectedDPS) - AVG(DPS)) as OverRating
from Sysstats
where week >= 17
Group by Team
order by 5 desc
</cfquery>

<cfloop query="Getit2">

<cfquery datasource="Sysstats3" name="Updit">
UPDATE Teams
Set TotalOverRating = #OverRating#
where Team = '#Getit2.Team#'
</cfquery>

</cfloop>


</cffunction>



<cffunction name="createTotals" access="remote" output="yes" returntype="Void">
<cfargument name="Week" type="Numeric" required="yes" />

<cfset thegames = getGames(#arguments.week#)>

<cfloop query="#thegames#">
	
	<cfquery datasource="sysstats3" name="GetitFav">
	Select TotalOverRating
	from Teams
	where Team = '#fav#'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetitUnd">
	Select TotalOverRating
	from Teams
	where Team = '#und#'
	</cfquery>

	<cfset myGameOverRat = GetitFav.TotalOverRating + GetItUnd.TotalOverRating>
	<cfset myPctGameOverRatPerOU = 100*(myGameOverRat / #OverUnder#)> 
	<cfset myOverUnder = #overunder#>
	<cfset myTeam = '#fav#'>
	<cfset myopp = '#und#'>
	<cfset myweek = #arguments.week#>
	
	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO TotalsStats(Team,opp,week,TeamOverRat,oppOverRat,OverUnder,GameOverRat,PctGameOverRatPerOu)
	VALUES('#myteam#','#myopp#',#arguments.week#,#GetitFav.TotalOverRating#,#GetitFav.TotalOverRating#,#myOverUnder#,#myGameOverRat#,#myPctGameOverRatPerOU#)
	</cfquery>

</cfloop>
</cffunction>


