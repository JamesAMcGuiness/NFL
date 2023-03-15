


<cfquery datasource="sysstats3" name="GetGames">
Select n.* from NFLSPDS n, Week w
where n.week = w.week 
</cfquery>

<cfset theweek = GetGames.week>

<cfquery datasource="sysstats3" name="Addit">
	Delete from PBPGameProjections where week = #theweek#
</cfquery>

<cfquery datasource="sysstats3" name="Addit">
	Delete from ADJPBPGameProjections where week = #theweek#
</cfquery>

<cfquery datasource="sysstats3" name="addit">
	Delete from btaPBPSuccessRates
</cfquery>

<cfquery datasource="sysstats3" name="GetOAvgs">
Select AVG(SuccRt1and2down) as aSuccRt1and2down,
AVG(SuccRtRZ) as aSuccRtRZ,
AVG(BigPlay1And2Down) as aBigPlay1And2Down,
AVG(RZPtsPerPlay) as aRZPtsPerPlay,
AVG(RZPlaysPerGame) as aRZPlaysPerGame,
AVG(SuccRt3rdDown) as aSuccRt3rdDown,
AVG(AvgToGo3rdDown) as aAvgToGo3rdDown,
AVG(SACKRt3rdAndLong) as aSACKRt3rdAndLong,
AVG(IntRt3rdAndLong) as aIntRt3rdAndLong,
AVG(IntRt2ndAnd3rdDown) as aIntRt2ndAnd3rdDown,
AVG(BadResult3rdAndLongPass) as aBadResult3rdAndLongPass,
AVG(BigPlayRt) as aBigPlayRt,
AVG(BigPlayPassRt) as aBigPlayPassRt,
AVG(OverallSuccRt) as aOverallSuccRt,
AVG(RunSuccessRt) as aRunSuccessRt

from PbPSuccessRates
where OffDef='O'
</cfquery>

<cfif 1 is 2>
<cfdump var="#GetOAvgs#">
</cfif>

<cfquery datasource="sysstats3" name="GetDAvgs">
Select 
AVG(SuccRt1and2down) as aSuccRt1and2down,
AVG(SuccRtRZ) as aSuccRtRZ,
AVG(BigPlay1And2Down) as aBigPlay1And2Down,
AVG(RZPtsPerPlay) as aRZPtsPerPlay,
AVG(RZPlaysPerGame) as aRZPlaysPerGame,
AVG(SuccRt3rdDown) as aSuccRt3rdDown,
AVG(AvgToGo3rdDown) as aAvgToGo3rdDown,
AVG(SACKRt3rdAndLong) as aSACKRt3rdAndLong,
AVG(IntRt3rdAndLong) as aIntRt3rdAndLong,
AVG(IntRt2ndAnd3rdDown) as aIntRt2ndAnd3rdDown,
AVG(BadResult3rdAndLongPass) as aBadResult3rdAndLongPass,
AVG(BigPlayRt) as aBigPlayRt,
AVG(BigPlayPassRt) as aBigPlayPassRt,
AVG(OverallSuccRt) as aOverallSuccRt,
AVG(RunSuccessRt) as aRunSuccessRt
from PbPSuccessRates
where OffDef='D'
</cfquery>

<cfif 1 is 2>
<cfdump var="#GetDAvgs#">
</cfif>

<cfquery datasource="sysstats3" name="GetTeams">
Select Distinct Team 
from betterthanavg
</cfquery>

<cfloop query="GetTeams">

	<cfquery datasource="sysstats3" name="GetTeamStatsO">
	Select AVG(SuccRt1and2down) as aSuccRt1and2down,
AVG(SuccRtRZ) as aSuccRtRZ,
AVG(BigPlay1And2Down) as aBigPlay1And2Down,
AVG(RZPtsPerPlay) as aRZPtsPerPlay,
AVG(RZPlaysPerGame) as aRZPlaysPerGame,
AVG(SuccRt3rdDown) as aSuccRt3rdDown,
AVG(AvgToGo3rdDown) as aAvgToGo3rdDown,
AVG(SACKRt3rdAndLong) as aSACKRt3rdAndLong,
AVG(IntRt3rdAndLong) as aIntRt3rdAndLong,
AVG(IntRt2ndAnd3rdDown) as aIntRt2ndAnd3rdDown,
AVG(BadResult3rdAndLongPass) as aBadResult3rdAndLongPass,
AVG(BigPlayRt) as aBigPlayRt,
AVG(BigPlayPassRt) as aBigPlayPassRt,
AVG(OverallSuccRt) as aOverallSuccRt,
AVG(RunSuccessRt) as aRunSuccessRt
	from PBPSuccessRates
	where Team = '#GetTeams.Team#'
	and Offdef = 'O'
	</cfquery>

<cfif 1 is 2>
<cfdump var="#GetTeamStatsO#">
</cfif>


	<cfquery datasource="sysstats3" name="GetTeamStatsD">
	Select 	AVG(SuccRt1and2down) as aSuccRt1and2down,
AVG(SuccRtRZ) as aSuccRtRZ,
AVG(BigPlay1And2Down) as aBigPlay1And2Down,
AVG(RZPtsPerPlay) as aRZPtsPerPlay,
AVG(RZPlaysPerGame) as aRZPlaysPerGame,
AVG(SuccRt3rdDown) as aSuccRt3rdDown,
AVG(AvgToGo3rdDown) as aAvgToGo3rdDown,
AVG(SACKRt3rdAndLong) as aSACKRt3rdAndLong,
AVG(IntRt3rdAndLong) as aIntRt3rdAndLong,
AVG(IntRt2ndAnd3rdDown) as aIntRt2ndAnd3rdDown,
AVG(BadResult3rdAndLongPass) as aBadResult3rdAndLongPass,
AVG(BigPlayRt) as aBigPlayRt,
AVG(BigPlayPassRt) as aBigPlayPassRt,
AVG(OverallSuccRt) as aOverallSuccRt,
AVG(RunSuccessRt) as aRunSuccessRt
	from PBPSuccessRates
	where Team = '#GetTeams.Team#'
	and Offdef = 'D'
	</cfquery>

	
		<cfset v1 = 100*((GetTeamStatsO.aSuccRt1and2down - GetOAvgs.aSuccRt1and2down) / GetOAvgs.aSuccRt1and2down)>
		<cfset v2 = 0> 
		
		<cfif 1 is 2>
		100*((GetTeamStatsO.aSuccRtRZ - GetOAvgs.aSuccRtRZ) / GetOAvgs.aSuccRtRZ)>
		</cfif>
		
		<cfset v3 = 100*((GetTeamStatsO.aBigPlay1And2Down - GetOAvgs.aBigPlay1And2Down) / GetOAvgs.aBigPlay1And2Down)>
		<cfset v4 = 0>
		
		<cfif 1 is 2>
		100*((GetTeamStatsO.aRZPtsPerPlay - GetOAvgs.aRZPtsPerPlay) / GetOAvgs.aRZPtsPerPlay)>
		</cfif>
		
		<cfset v5 = 0> 
		
		<cfif 1 is 2>
		100*((GetTeamStatsO.aRZPlaysPerGame - GetOAvgs.aRZPlaysPerGame) / GetOAvgs.aRZPlaysPerGame)>
		</cfif>
		
		<cfset v8 = 0>
		<cfset v10 = 0>
		
		<cfset v6 = 100*((GetTeamStatsO.aSuccRt3rdDown - GetOAvgs.aSuccRt3rdDown) / GetOAvgs.aSuccRt3rdDown)>
		<cfset v7 = 100*((GetTeamStatsO.aAvgToGo3rdDown - GetOAvgs.aAvgToGo3rdDown) / GetOAvgs.aAvgToGo3rdDown)>
		<cfset v8 = 100*((GetOAvgs.aSACKRt3rdAndLong - GetTeamStatsO.aSACKRt3rdAndLong) / GetOAvgs.aSACKRt3rdAndLong)>
		
		<cfset v9 = 0>
		<cfif GetOAvgs.aIntRt3rdAndLong gt 0>
			<cfset v9 = 100*((GetOAvgs.aIntRt3rdAndLong - GetTeamStatsO.aIntRt3rdAndLong) / GetOAvgs.aIntRt3rdAndLong)>
		</cfif>	
		
		<cfif GetOAvgs.aIntRt2ndAnd3rdDown gt 0>
			<cfset v10 = 100*((GetOAvgs.aIntRt2ndAnd3rdDown - GetTeamStatsO.aIntRt2ndAnd3rdDown) / GetOAvgs.aIntRt2ndAnd3rdDown)>
		</cfif>
		
		<cfset v11 = 100*((GetOAvgs.aBadResult3rdAndLongPass - GetTeamStatsO.aBadResult3rdAndLongPass) / GetOAvgs.aBadResult3rdAndLongPass)>
		<cfset v12 = 100*((GetTeamStatsO.aBigPlayRt - GetOAvgs.aBigPlayRt) / GetOAvgs.aBigPlayRt)>
		<cfset v13 = 100*((GetTeamStatsO.aBigPlayPassRt - GetOAvgs.aBigPlayPassRt) / GetOAvgs.aBigPlayPassRt)>
		<cfset v14 = 100*((GetTeamStatsO.aOverallSuccRt - GetOAvgs.aOverallSuccRt) / GetOAvgs.aOverallSuccRt)>
		<cfset v15 = 100*((GetTeamStatsO.aRunSuccessRt - GetOAvgs.aRunSuccessRt) / GetOAvgs.aRunSuccessRt)>
	
	
		<cfset dv1 = (GetdAvgs.aSuccRt1and2down - GetTeamStatsd.aSuccRt1and2down) / GetdAvgs.aSuccRt1and2down>
		<cfset dv2 = 0>
		
		<cfif 1 is 2>
		100*((GetdAvgs.aSuccRtRZ - GetTeamStatsd.aSuccRtRZ) / GetdAvgs.aSuccRtRZ)>
		</cfif>
		
		<cfset dv3 = 100*((GetdAvgs.aBigPlay1And2Down - GetTeamStatsd.aBigPlay1And2Down) / GetdAvgs.aBigPlay1And2Down)>
		<cfset dv4 = 0>
		
		<cfif 1 is 2>
		100*((GetdAvgs.aRZPtsPerPlay - GetTeamStatsd.aRZPtsPerPlay) / GetdAvgs.aRZPtsPerPlay)>
		</cfif>
		
		<cfset dv5 = 0> 
		
		<cfif 1 is 2>
		100*((GetdAvgs.aRZPlaysPerGame - GetTeamStatsd.aRZPlaysPerGame) / GetdAvgs.aRZPlaysPerGame)>
		</cfif>
		
		<cfset v8 = 0>
		<cfset v10 = 0>
		
		
		<cfset dv6 = 100*((GetdAvgs.aSuccRt3rdDown - GetTeamStatsd.aSuccRt3rdDown) / GetdAvgs.aSuccRt3rdDown)>
		<cfset dv7 = 100*((GetdAvgs.aAvgToGo3rdDown - GetTeamStatsd.aAvgToGo3rdDown) / GetdAvgs.aAvgToGo3rdDown)>
		
		<cfif GetdAvgs.aSACKRt3rdAndLong gt 0>
			<cfset dv8 = 100*((GetTeamStatsd.aSACKRt3rdAndLong - GetdAvgs.aSACKRt3rdAndLong) / GetdAvgs.aSACKRt3rdAndLong)>
		</cfif>
		
		<cfset dv9 = 100*((GetTeamStatsd.aIntRt3rdAndLong - GetdAvgs.aIntRt3rdAndLong) / GetdAvgs.aIntRt3rdAndLong)>
		
		<cfif GetdAvgs.aIntRt2ndAnd3rdDown gt 0>
			<cfset dv10 = 100*((GetTeamStatsd.aIntRt2ndAnd3rdDown - GetdAvgs.aIntRt2ndAnd3rdDown) / GetdAvgs.aIntRt2ndAnd3rdDown)>
		</cfif>
		
		<cfset dv11 = 100*((GetTeamStatsd.aBadResult3rdAndLongPass - GetdAvgs.aBadResult3rdAndLongPass) / GetdAvgs.aBadResult3rdAndLongPass)>
		<cfset dv12 = 100*((GetdAvgs.aBigPlayRt - GetTeamStatsd.aBigPlayRt) / GetdAvgs.aBigPlayRt)>
		<cfset dv13 = 100*((GetdAvgs.aBigPlayPassRt - GetTeamStatsd.aBigPlayPassRt) / GetdAvgs.aBigPlayPassRt)>
		<cfset dv14 = 100*((GetdAvgs.aOverallSuccRt - GetTeamStatsd.aOverallSuccRt) / GetdAvgs.aOverallSuccRt)>
		<cfset dv15 = 100*((GetdAvgs.aRunSuccessRt - GetTeamStatsd.aRunSuccessRt) / GetdAvgs.aRunSuccessRt)>
	
	
	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO btaPBPSuccessRates(Team,OffDef,SuccRt1and2down,SuccRtRZ,BigPlay1And2Down,RZPtsPerPlay,RZPlaysPerGame,SuccRt3rdDown,AvgToGo3rdDown,SACKRt3rdAndLong,
	IntRt3rdAndLong,IntRt2ndAnd3rdDown,BadResult3rdAndLongPass,BigPlayRt,BigPlayPassRt,OverallSuccRt,RunSuccessRt)
	Values('#GetTeams.Team#','O',#v1#,#v2#,#v3#,#v4#,#v5#,#v6#,#v7#,#v8#,#v9#,#v10#,#v11#,#v12#,#v13#,#v14#,#v15#)
	</cfquery>	
		
		
	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO btaPBPSuccessRates(Team,OffDef,SuccRt1and2down,SuccRtRZ,BigPlay1And2Down,RZPtsPerPlay,RZPlaysPerGame,SuccRt3rdDown,AvgToGo3rdDown,SACKRt3rdAndLong,
	IntRt3rdAndLong,IntRt2ndAnd3rdDown,BadResult3rdAndLongPass,BigPlayRt,BigPlayPassRt,OverallSuccRt,RunSuccessRt)
	Values('#GetTeams.Team#','D',#dv1#,#dv2#,#dv3#,#dv4#,#dv5#,#dv6#,#dv7#,#dv8#,#dv9#,#dv10#,#dv11#,#dv12#,#dv13#,#dv14#,#dv15#)
	</cfquery>
</cfloop>



<cfloop query="GetGames">




	<cfset theteam = '#GetGames.Fav#'>
	<cfset theopp = '#GetGames.Und#'>
	<cfset theHa = '#GetGames.ha#'>

	<cfoutput>
    ****************************************<br>
	Theteam = '#theteam#'<br>
	theopp = '#theopp#'<br>
    ****************************************<br>
	</cfoutput>

	<cfquery datasource="sysstats3" name="GetFavOff">
	Select AVG(OverallSuccRt) as overall, AVG(SackRt3rdAndLong) as sk3rdlong, AVG(SuccRt1and2down) as Suc1stAnd2nd, AVG(BigPlayRt) as BigPlay, AVG(SuccRt3rdDown) as Succ3rddown,
	AVG(RzPtsPerPlay) as RZPPP, AVG(RzPlaysPerGame) as RZPPG, AVG(SuccRtRz) as RZSuccRt, AVG(IntRt3rdAndLong) as Irt3rdLong, AVG(IntRt2ndAnd3rdDown) as IRt2nd3rd,
	AVG(BadResult3rdAndLongPass) as BadRes, AVG(BigPlay1And2Down) as BP1st2nd, AVG(AvgToGo3rdDown) as ATogo, AVG(BigPlayPassRt) as BPPass, AVG(RunSuccessRt) as RunSucRt	
	FROM PBPSuccessRates
	where Team = '#theteam#'
	and OffDef='O'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndOff">
	Select AVG(OverallSuccRt) as overall, AVG(SackRt3rdAndLong) as sk3rdlong, AVG(SuccRt1and2down) as Suc1stAnd2nd, AVG(BigPlayRt) as BigPlay, AVG(SuccRt3rdDown) as Succ3rddown,
	AVG(RzPtsPerPlay) as RZPPP, AVG(RzPlaysPerGame) as RZPPG, AVG(SuccRtRz) as RZSuccRt, AVG(IntRt3rdAndLong) as Irt3rdLong, AVG(IntRt2ndAnd3rdDown) as IRt2nd3rd,
	AVG(BadResult3rdAndLongPass) as BadRes, AVG(BigPlay1And2Down) as BP1st2nd, AVG(AvgToGo3rdDown) as ATogo, AVG(BigPlayPassRt) as BPPass, AVG(RunSuccessRt) as RunSucRt	
	FROM PBPSuccessRates
	where Team = '#theopp#'
	and OffDef='O'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetFavDef">
	Select AVG(OverallSuccRt) as overall, AVG(SackRt3rdAndLong) as sk3rdlong, AVG(SuccRt1and2down) as Suc1stAnd2nd, AVG(BigPlayRt) as BigPlay, AVG(SuccRt3rdDown) as Succ3rddown,
	AVG(RzPtsPerPlay) as RZPPP, AVG(RzPlaysPerGame) as RZPPG, AVG(SuccRtRz) as RZSuccRt, AVG(IntRt3rdAndLong) as Irt3rdLong, AVG(IntRt2ndAnd3rdDown) as IRt2nd3rd,
	AVG(BadResult3rdAndLongPass) as BadRes, AVG(BigPlay1And2Down) as BP1st2nd, AVG(AvgToGo3rdDown) as ATogo, AVG(BigPlayPassRt) as BPPass, AVG(RunSuccessRt) as RunSucRt	
	FROM PBPSuccessRates
	where Team = '#theteam#'
	and OffDef='D'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndDef">
	Select AVG(OverallSuccRt) as overall, AVG(SackRt3rdAndLong) as sk3rdlong, AVG(SuccRt1and2down) as Suc1stAnd2nd, AVG(BigPlayRt) as BigPlay, AVG(SuccRt3rdDown) as Succ3rddown,
	AVG(RzPtsPerPlay) as RZPPP, AVG(RzPlaysPerGame) as RZPPG, AVG(SuccRtRz) as RZSuccRt, AVG(IntRt3rdAndLong) as Irt3rdLong, AVG(IntRt2ndAnd3rdDown) as IRt2nd3rd,
	AVG(BadResult3rdAndLongPass) as BadRes, AVG(BigPlay1And2Down) as BP1st2nd, AVG(AvgToGo3rdDown) as ATogo, AVG(BigPlayPassRt) as BPPass, AVG(RunSuccessRt) as RunSucRt	
	FROM PBPSuccessRates
	where Team = '#theopp#'
	and OffDef='D'
	</cfquery>

	<cfif 1 is 2>
	<cfdump var=#GetFavOff#>
	<cfdump var=#GetUndOff#>
	<cfdump var=#GetFavDef#>
	<cfdump var=#GetFavDef#>
	</cfif>
	
	
	
	<p>
	<p>
	<p>
	

	<table width="75%" border="1" cellpadding="8" cellspacing="8">
	<th align="center" colspan="13"> Projected Stats</th>
	<tr>
	<td align="center">Team</td>
	<td align="center">Play<br>Success %</td>
	<td align="center">Run<br>Success %</td>
	<td align="center">Success<br>1st/2nd Down %</td>
	<td align="center">Big Play %</td>
	<td align="center">Big Play<br>1st/2nd Down %</td>
	<td align="center">Big Play<br>Pass %</td>
	<td align="center">Success<br>3rd Down %</td>
	<td align="center">Avg To Go<br>3rd Down</td>
	<td align="center">Sack Allow % <br>on 3rd Long</td>
	<td align="center">Bad Result %<br> 3rd & Long</td>
	<cfif 1 is 2>
	<td align="center">Int Thrown %<br> 3rd & Long</td>
	<td>Int Thrown %<br> 2nd/3rd & Long</td>
	<td>RedZone Success %</td>
	<td>RedZone Pts. Per/Play</td>
	<td>RedZone Plays Per/Game</td>
	</cfif>
	</tr>
	
	<cfset fbg1color = "">
	<cfset fbg2color = "">
	<cfset fbg3color = "">
	<cfset fbg4color = "">
	<cfset fbg5color = "">
	<cfset fbg6color = "">
	<cfset fbg7color = "">
	<cfset fbg8color = "">
	<cfset fbg9color = "">
	<cfset fbg10color = "">
	<cfset fbg11color = "">
	<cfset fbg12color = "">
	<cfset fbg13color = "">
	<cfset fbg14color = "">
	<cfset fbg15color = "">
	
	<cfset avgRunsucc        = 100*(((GetFavOff.RunSucRt + GetUndDef.RunSucRt) + (GetFavDef.RunSucRt + GetUndOff.RunSucRt)) / 4)>
	<cfset avgPlaysucc       = 100*(((GetFavOff.overall + GetUndDef.overall) + (GetFavDef.overall + GetUndOff.overall)) / 4)>
	<cfset avgBigPlay        = 100*(((GetFavOff.BigPlay + GetUndDef.BigPlay) + (GetFavDef.BigPlay + GetUndOff.BigPlay)) / 4)>
	<cfset avg3rddwnsucc     = 100*(((GetFavOff.Succ3rddown + GetUndDef.Succ3rddown) + (GetFavDef.Succ3rddown + GetUndOff.Succ3rddown)) / 4)>
	<cfset avgRZPtsPerPlay   = ((GetFavOff.RZPPP + GetUndDef.RZPPP) + (GetUndOff.RZPPP + GetFavDef.RZPPP))/2>
	<cfset avgRzPlaysPerGame = ((GetFavOff.RZPPG + GetUndDef.RZPPG) + (GetFavDef.RZPPG + GetUndOff.RZPPG))/2>
	<cfset PredictedRZPts    = (avgRZPtsPerPlay*avgRzPlaysPerGame)>
	
	<cfset fruncolor = "">
	<cfset uruncolor = "Red">
	<cfif (GetFavOff.RunSucRt + GetUndDef.RunSucRt) gt (GetFavDef.RunSucRt + GetUndOff.RunSucRt)>
		<cfset fruncolor = "Green">
		<cfset uruncolor = "">
		
	</cfif>	

	
	<cfset ubg1color = "Red">
	<cfif (GetFavOff.overall + GetUndDef.overall) gt (GetFavDef.overall + GetUndOff.overall)>
		<cfset fbg1color = "Green">
		<cfset ubg1color = "">
		
	</cfif>	
	
	<cfset uBG2color ="Red">
	<cfif (GetFavOff.Suc1stAnd2nd + GetUndDef.Suc1stAnd2nd) gt (GetFavDef.Suc1stAnd2nd + GetUndOff.Suc1stAnd2nd) >
		<cfset fBG2color ="Green">
		<cfset uBG2color ="">
		
	</cfif>
	
	<cfset uBG3color ="Red">
	<cfif (GetFavOff.BigPlay + GetUndDef.BigPlay) gt (GetFavDef.BigPlay + GetUndOff.BigPlay) >
		<cfset fBG3color ="Green">
		<cfset uBG3color ="">
	</cfif>

	<cfset uBG4color ="Red">
	<cfif (GetFavOff.BP1st2nd + GetUndDef.BP1st2nd) gt (GetUndOff.BP1st2nd + GetFavDef.BP1st2nd) >
		<cfset fBG4color ="Green">
		<cfset uBG4color ="">

	</cfif>

	<cfset uBG5color ="Red">
	<cfif (GetFavOff.BPPass + GetUndDef.BPPass) gt (GetFavDef.BPPass + GetUndOff.BPPass) >
		<cfset fBG5color ="Green">
		<cfset uBG5color ="">
	</cfif>

	<cfset uBG6color ="Red">	
	<cfif (GetFavOff.Succ3rddown + GetUndDef.Succ3rddown) gt (GetFavDef.Succ3rddown + GetUndOff.Succ3rddown) >
		<cfset fBG6color ="Green">
		<cfset uBG6color ="">

	</cfif>

	<cfset uBG7color ="Red">
	<cfif (GetFavOff.ATogo + GetUndDef.ATogo) lt (GetFavDef.ATogo + GetUndOff.ATogo) >
		<cfset fBG7color ="Green">
		<cfset uBG7color ="">

	</cfif>

	<cfset uBG8color ="Red">
	<cfif (GetFavOff.sk3rdlong + GetUndDef.sk3rdlong) lt (GetFavDef.sk3rdlong + GetUndOff.sk3rdlong) >
		<cfset fBG8color ="Green">
		<cfset uBG8color ="">

	</cfif>

	<cfset uBG9color ="Red">
	<cfif (GetFavOff.BadRes + GetUndDef.BadRes) lt (GetUndOff.BadRes + GetFavDef.BadRes) >
		<cfset fBG9color ="Green">
		<cfset uBG9color ="">

	</cfif>
	
	<cfset uBG10color ="Red">
	<cfif (GetFavOff.Irt3rdLong + GetUndDef.Irt3rdLong) lt (GetUndOff.Irt3rdLong + GetFavDef.Irt3rdLong) >
		<cfset fBG10color ="Green">
		<cfset uBG10color ="">

	</cfif>
	
	<cfset uBG11color ="Red">
	<cfif (GetFavOff.IRt2nd3rd + GetUndDef.IRt2nd3rd) lt (GetUndOff.IRt2nd3rd + GetFavDef.IRt2nd3rd) >
		<cfset fBG11color ="Green">
		<cfset uBG11color ="">

	</cfif>

	<cfset uBG12color ="Red">	
	<cfif (GetFavOff.RZSuccRt + GetUndDef.RZSuccRt) gt (GetUndOff.RZSuccRt + GetFavDef.RZSuccRt) >
		<cfset fBG12color ="Green">
		<cfset uBG12color ="">

	</cfif>
	
	<cfset uBG13color ="Red">
	<cfif (GetFavOff.RZPPP + GetUndDef.RZPPP) gt (GetUndOff.RZPPP + GetFavDef.RZPPP) >
		<cfset fBG13color ="Green">
		<cfset uBG13color ="">

	</cfif>

	<cfset uBG14color ="Red">
	<cfif (GetFavOff.RZPPG + GetUndDef.RZPPG) gt (GetFavDef.RZPPG + GetUndOff.RZPPG) >
		<cfset fBG14color ="Green">
		<cfset uBG14color ="">

	</cfif>
`	
	<cfoutput>
	<tr>
	<td align="center">#theTeam#</td>
	<td align="center" bgcolor="#fbg1color#">#Numberformat(((GetFavOff.overall + GetUndDef.overall)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fruncolor#">#Numberformat(((GetFavOff.RunSucRt + GetUndDef.RunSucRt)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg2color#">#Numberformat(((GetFavOff.Suc1stAnd2nd + GetUndDef.Suc1stAnd2nd)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg3color#">#Numberformat(((GetFavOff.BigPlay + GetUndDef.BigPlay)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg4color#">#Numberformat(((GetFavOff.BP1st2nd + GetUndDef.BP1st2nd)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg5color#">#Numberformat(((GetFavOff.BPPass + GetUndDef.BPPass)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg6color#">#Numberformat(((GetFavOff.Succ3rddown + GetUndDef.Succ3rddown)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg7color#">#Numberformat(((GetFavOff.ATogo + GetUndDef.ATogo)/2),'99.99')#</td>
	<td align="center" bgcolor="#fbg8color#">#Numberformat(((GetFavOff.sk3rdlong + GetUndDef.sk3rdlong)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg9color#">#Numberformat(((GetFavOff.BadRes + GetUndDef.BadRes)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg10color#">#Numberformat(((GetFavOff.Irt3rdLong + GetUndDef.Irt3rdLong)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg11color#">#Numberformat(((GetFavOff.IRt2nd3rd + GetUndDef.IRt2nd3rd)/2)*100,'99.99')#</td>
	<cfif 1 is 2>
	<td bgcolor="#fbg12color#">#Numberformat(((GetFavOff.RZSuccRt + GetUndDef.RZSuccRt)/2)*100,'99.99')#</td>
	<td bgcolor="#fbg13color#">#Numberformat(((GetFavOff.RZPPP + GetUndDef.RZPPP)/2),'99.99')#</td>
	<td bgcolor="#fbg14color#">#Numberformat(((GetFavOff.RZPPG + GetUndDef.RZPPG)/2),'99.99')#</td>
	</cfif>
	</tr>
	
	<cfset t1 = ((GetFavOff.RZPPP + GetUndDef.RZPPP)/2) * ((GetFavOff.RZPPG + GetUndDef.RZPPG)/2) >
	<cfset t2 = ((GetFavDef.RZPPP + GetUndOff.RZPPP)/2) * ((GetUndOff.RZPPG + GetFavDef.RZPPG)/2) >
	<cfset t3 = t1 + t2>
	
	<tr>
	<td align="center">#theopp#</td>
	<td align="center" bgcolor="#ubg1color#">#Numberformat(((GetFavDef.overall + GetUndOff.overall)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#uruncolor#">#Numberformat(((GetUndOff.RunSucRt + GetFavDef.RunSucRt)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg2color#">#Numberformat(((GetFavDef.Suc1stAnd2nd + GetUndOff.Suc1stAnd2nd)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg3color#">#Numberformat(((GetFavDef.BigPlay + GetUndOff.BigPlay)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg4color#">#Numberformat(((GetFavDef.BP1st2nd + GetUndOff.BP1st2nd)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg5color#">#Numberformat(((GetFavDef.BPPass + GetUndOff.BPPass)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg6color#">#Numberformat(((GetFavDef.Succ3rddown + GetUndOff.Succ3rddown)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg7color#">#Numberformat(((GetFavDef.ATogo + GetUndOff.ATogo)/2),'99.99')#</td>
	<td align="center" bgcolor="#ubg8color#">#Numberformat(((GetFavDef.sk3rdlong + GetUndOff.sk3rdlong)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg9color#">#Numberformat(((GetFavDef.BadRes + GetUndOff.BadRes)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg10color#">#Numberformat(((GetFavDef.Irt3rdLong + GetUndOff.Irt3rdLong)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg11color#">#Numberformat(((GetFavDef.IRt2nd3rd + GetUndOff.IRt2nd3rd)/2)*100,'99.99')#</td>	
	<cfif 1 is 2>
	<td bgcolor="#ubg12color#">#Numberformat(((GetFavDef.RZSuccRt + GetUndOff.RZSuccRt)/2)*100,'99.99')#</td>
	<td bgcolor="#ubg13color#">#Numberformat(((GetFavDef.RZPPP + GetUndOff.RZPPP)/2),'99.99')#</td>
	<td bgcolor="#ubg14color#">#Numberformat(((GetFavDef.RZPPG + GetUndOff.RZPPG)/2),'99.99')#</td>
	</cfif>
	</tr>

	<cfif 1 is 2>
	<tr>
	<td></td>
	<td>#avgPlaysucc#</td>
	<td></td>
	<td>#avgBigPlay#</td>
	<td></td>
	<td></td>
	<td>#avg3rddwnsucc#</td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td>#avgRZPtsPerPlay#</td>
	<td>#avgRzPlaysPerGame# - Pred Pts: #t3#</td>
	</tr>
	</cfif>
	
	</table>	
	
	
	<p>
	<p>
	<p>
	</cfoutput>
	
	<cfquery datasource="sysstats3" name="Addit">
	insert into PBPGameProjections(FAV,Week,HA,UND,
	PlaySuccessRt,
	BigPlayRt,
	BigPlay1st2ndRt,
	BigPlayPassRt,
	Success3rdDownRt,
	AvgToGo3rdDown,
	SackAllowedPct3rdDown,
	BadResult3rdDown,
	Int3rdAndLongRt,
	Int2nd3rdAndLong,
	RedzoneSuccessRt,
	RedZonePtsPerPlay,
	RedZonePlaysPerGame,
	RunSuccessRt
	) 
	VALUES('#theteam#',#theweek#,'#theha#','#theopp#',
	#Numberformat(((GetUndDef.overall + GetFavOff.overall)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.BigPlay + GetFavOff.BigPlay)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.BP1st2nd + GetFavOff.BP1st2nd)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.BPPass + GetFavOff.BPPass)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.Succ3rddown + GetFavOff.Succ3rddown)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.ATogo + GetFavOff.ATogo)/2),'99.99')#,
	#Numberformat(((GetUndDef.sk3rdlong + GetFavOff.sk3rdlong)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.BadRes + GetFavOff.BadRes)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.Irt3rdLong + GetFavOff.Irt3rdLong)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.IRt2nd3rd + GetFavOff.IRt2nd3rd)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.RZSuccRt + GetFavOff.RZSuccRt)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.RZPPP + GetFavOff.RZPPP)/2),'99.99')#,
	#Numberformat(((GetUndDef.RZPPG + GetFavOff.RZPPG)/2),'99.99')#,
	#Numberformat(((GetFavOff.RunSucRt + GetUndDef.RunSucRt)/2)*100,'99.99')#

	)
	</cfquery>
	
	
	<cfif theha is 'H'>
		<cfset theha = 'A'>
	<cfelse>	
		<cfset theha = 'H'>
	</cfif>
	
	

	<cfquery datasource="sysstats3" name="Addit">
	insert into PBPGameProjections(FAV,Week,HA,UND,
	PlaySuccessRt,
	BigPlayRt,
	BigPlay1st2ndRt,
	BigPlayPassRt,
	Success3rdDownRt,
	AvgToGo3rdDown,
	SackAllowedPct3rdDown,
	BadResult3rdDown,
	Int3rdAndLongRt,
	Int2nd3rdAndLong,
	RedzoneSuccessRt,
	RedZonePtsPerPlay,
	RedZonePlaysPerGame,
	RunSuccessRt
	) 
	VALUES('#theopp#',#theweek#,'#theha#','#theteam#',
	
	#Numberformat(((GetFavDef.overall + GetUndOff.overall)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.BigPlay + GetUndOff.BigPlay)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.BP1st2nd + GetUndOff.BP1st2nd)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.BPPass + GetUndOff.BPPass)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.Succ3rddown + GetUndOff.Succ3rddown)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.ATogo + GetUndOff.ATogo)/2),'99.99')#,
	#Numberformat(((GetFavDef.sk3rdlong + GetUndOff.sk3rdlong)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.BadRes + GetUndOff.BadRes)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.Irt3rdLong + GetUndOff.Irt3rdLong)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.IRt2nd3rd + GetUndOff.IRt2nd3rd)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.RZSuccRt + GetUndOff.RZSuccRt)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.RZPPP + GetUndOff.RZPPP)/2),'99.99')#,
	#Numberformat(((GetFavDef.RZPPG + GetUndOff.RZPPG)/2),'99.99')#,
	#Numberformat(((GetUndOff.RunSucRt + GetFavDef.RunSucRt)/2)*100,'99.99')#
	
	)
	</cfquery>

	


	
</cfloop>


<cfif 1 is 2>
<cfquery datasource="sysstats3" name="GetGames">
Select gi.* from GameInsights gi
where gi.week = #theweek# - 1
and (OverratedPerformance = 'Y' or UnderratedPerformance = 'Y')
order by OverratedPerformance desc 
</cfquery>

<p>
<cfloop query="GetGames">
	<cfif '#Team#' gt ''>
		<cfif OverratedPerformance is 'Y'>
			<cfoutput>
			Overrated Performance by #team#<br>
			
			</cfoutput>
		<cfelse>
			<cfoutput>
			Underrated Performance by #team#<br>
			
			</cfoutput>
		</cfif>
	</cfif>
</cfloop>	

</cfif>






Adjusted For Opp<br>
**********************************************************************************************************************************************************<br>
<p>
<p>
<p>

<cfquery datasource="sysstats3" name="GetGames">
Select n.* from NFLSPDS n, Week w
where n.week = w.week 
</cfquery>

<cfset theweek = GetGames.week>

<cfloop query="GetGames">


	<cfset theteam = '#GetGames.Fav#'>
	<cfset theopp = '#GetGames.Und#'>
	<cfset theHa = '#GetGames.ha#'>

	<cfquery datasource="sysstats3" name="GetFavOff">
	Select AVG(OverallSuccRt) as overall, AVG(SackRt3rdAndLong) as sk3rdlong, AVG(SuccRt1and2down) as Suc1stAnd2nd, AVG(BigPlayRt) as BigPlay, AVG(SuccRt3rdDown) as Succ3rddown,
	AVG(RzPtsPerPlay) as RZPPP, AVG(RzPlaysPerGame) as RZPPG, AVG(SuccRtRz) as RZSuccRt, AVG(IntRt3rdAndLong) as Irt3rdLong, AVG(IntRt2ndAnd3rdDown) as IRt2nd3rd,
	AVG(BadResult3rdAndLongPass) as BadRes, AVG(BigPlay1And2Down) as BP1st2nd, AVG(AvgToGo3rdDown) as ATogo, AVG(BigPlayPassRt) as BPPass, AVG(RunSuccessRt) as RunSucRt	
	FROM ADJPBPSuccessRates
	where Team = '#trim(theteam)#'
	and OffDef='O'
	</cfquery>

	

	<cfquery datasource="sysstats3" name="GetUndOff">
	Select AVG(OverallSuccRt) as overall, AVG(SackRt3rdAndLong) as sk3rdlong, AVG(SuccRt1and2down) as Suc1stAnd2nd, AVG(BigPlayRt) as BigPlay, AVG(SuccRt3rdDown) as Succ3rddown,
	AVG(RzPtsPerPlay) as RZPPP, AVG(RzPlaysPerGame) as RZPPG, AVG(SuccRtRz) as RZSuccRt, AVG(IntRt3rdAndLong) as Irt3rdLong, AVG(IntRt2ndAnd3rdDown) as IRt2nd3rd,
	AVG(BadResult3rdAndLongPass) as BadRes, AVG(BigPlay1And2Down) as BP1st2nd, AVG(AvgToGo3rdDown) as ATogo, AVG(BigPlayPassRt) as BPPass, AVG(RunSuccessRt) as RunSucRt	
	FROM ADJPBPSuccessRates
	where Team = '#trim(theopp)#'
	and OffDef='O'
	</cfquery>

	

	<cfquery datasource="sysstats3" name="GetFavDef">
	Select AVG(OverallSuccRt) as overall, AVG(SackRt3rdAndLong) as sk3rdlong, AVG(SuccRt1and2down) as Suc1stAnd2nd, AVG(BigPlayRt) as BigPlay, AVG(SuccRt3rdDown) as Succ3rddown,
	AVG(RzPtsPerPlay) as RZPPP, AVG(RzPlaysPerGame) as RZPPG, AVG(SuccRtRz) as RZSuccRt, AVG(IntRt3rdAndLong) as Irt3rdLong, AVG(IntRt2ndAnd3rdDown) as IRt2nd3rd,
	AVG(BadResult3rdAndLongPass) as BadRes, AVG(BigPlay1And2Down) as BP1st2nd, AVG(AvgToGo3rdDown) as ATogo, AVG(BigPlayPassRt) as BPPass, AVG(RunSuccessRt) as RunSucRt	
	FROM ADJPBPSuccessRates
	where Team = '#trim(theteam)#'
	and OffDef='D'
	</cfquery>

	


	<cfquery datasource="sysstats3" name="GetUndDef">
	Select AVG(OverallSuccRt) as overall, AVG(SackRt3rdAndLong) as sk3rdlong, AVG(SuccRt1and2down) as Suc1stAnd2nd, AVG(BigPlayRt) as BigPlay, AVG(SuccRt3rdDown) as Succ3rddown,
	AVG(RzPtsPerPlay) as RZPPP, AVG(RzPlaysPerGame) as RZPPG, AVG(SuccRtRz) as RZSuccRt, AVG(IntRt3rdAndLong) as Irt3rdLong, AVG(IntRt2ndAnd3rdDown) as IRt2nd3rd,
	AVG(BadResult3rdAndLongPass) as BadRes, AVG(BigPlay1And2Down) as BP1st2nd, AVG(AvgToGo3rdDown) as ATogo, AVG(BigPlayPassRt) as BPPass, AVG(RunSuccessRt) as RunSucRt	
	FROM ADJPBPSuccessRates
	where Team = '#trim(theopp)#'
	and OffDef='D'
	</cfquery>
	
	<cfif 1 is 2>
	Jim*************************************<p>
	<cfdump var="#GetFavOff#">
	<cfdump var="#GetFavDef#">
	<cfdump var="#GetUndOff#">
	<cfdump var="#GetUndDef#">
	*************************************<p>
	</cfif>

	
	<p>
	<p>
	<p>
	

	<table width="75%" border="1" cellpadding="8" cellspacing="8">
	<th align="center" colspan="13"> Projected Stats Adjusted For Opponent And Garbage Time</th>
	<tr>
	<td align="center">Team</td>
	<td align="center">Play<br>Success %</td>
	<td align="center">Run<br>Success %</td>
	<td align="center">Success<br>1st/2nd Down %</td>
	<td align="center">Big Play %</td>
	<cfif 1 is 2>
	<td align="center">Big Play<br>1st/2nd Down %</td>
	</cfif>
	<td align="center">Big Play<br>Pass %</td>
	<td align="center">Success<br>3rd Down %</td>
	<td align="center">Avg To Go<br>3rd Down</td>
	<td align="center">Sack Allow % <br>on 3rd Long</td>
	<td align="center">Bad Result %<br> 3rd & Long</td>
	<cfif 1 is 2>
	<td align="center">Int Thrown %<br> 3rd & Long</td>
	<td>Int Thrown %<br> 2nd/3rd & Long</td>
	
	<td>RedZone Success %</td>
	<td>RedZone Pts. Per/Play</td>
	<td>RedZone Plays Per/Game</td>
	</cfif>
	</tr>
	
	<cfset fbg1color = "">
	<cfset fbg2color = "">
	<cfset fbg3color = "">
	<cfset fbg4color = "">
	<cfset fbg5color = "">
	<cfset fbg6color = "">
	<cfset fbg7color = "">
	<cfset fbg8color = "">
	<cfset fbg9color = "">
	<cfset fbg10color = "">
	<cfset fbg11color = "">
	<cfset fbg12color = "">
	<cfset fbg13color = "">
	<cfset fbg14color = "">
	<cfset fbg15color = "">
	
	<cfset avgRunsucc        = 100*(((GetFavOff.RunSucRt + GetUndDef.RunSucRt) + (GetFavDef.RunSucRt + GetUndOff.RunSucRt)) / 4)>
	<cfset avgPlaysucc       = 100*(((GetFavOff.overall + GetUndDef.overall) + (GetFavDef.overall + GetUndOff.overall)) / 4)>
	<cfset avgBigPlay        = 100*(((GetFavOff.BigPlay + GetUndDef.BigPlay) + (GetFavDef.BigPlay + GetUndOff.BigPlay)) / 4)>
	<cfset avg3rddwnsucc     = 100*(((GetFavOff.Succ3rddown + GetUndDef.Succ3rddown) + (GetFavDef.Succ3rddown + GetUndOff.Succ3rddown)) / 4)>
	<cfset avgRZPtsPerPlay   = ((GetFavOff.RZPPP + GetUndDef.RZPPP) + (GetUndOff.RZPPP + GetFavDef.RZPPP))/2>
	<cfset avgRzPlaysPerGame = ((GetFavOff.RZPPG + GetUndDef.RZPPG) + (GetFavDef.RZPPG + GetUndOff.RZPPG))/2>
	<cfset PredictedRZPts    = (avgRZPtsPerPlay*avgRzPlaysPerGame)>
	
	<cfset fruncolor = "">
	<cfset uruncolor = "Red">
	<cfif (GetFavOff.RunSucRt + GetUndDef.RunSucRt) gt (GetFavDef.RunSucRt + GetUndOff.RunSucRt)>
		<cfset fruncolor = "Green">
		<cfset uruncolor = "">
		
	</cfif>	

	
	<cfset ubg1color = "Red">
	<cfif (GetFavOff.overall + GetUndDef.overall) gt (GetFavDef.overall + GetUndOff.overall)>
		<cfset fbg1color = "Green">
		<cfset ubg1color = "">
		
	</cfif>	
	
	<cfset uBG2color ="Red">
	<cfif (GetFavOff.Suc1stAnd2nd + GetUndDef.Suc1stAnd2nd) gt (GetFavDef.Suc1stAnd2nd + GetUndOff.Suc1stAnd2nd) >
		<cfset fBG2color ="Green">
		<cfset uBG2color ="">
		
	</cfif>
	
	<cfset uBG3color ="Red">
	<cfif (GetFavOff.BigPlay + GetUndDef.BigPlay) gt (GetFavDef.BigPlay + GetUndOff.BigPlay) >
		<cfset fBG3color ="Green">
		<cfset uBG3color ="">
	</cfif>

	<cfset uBG4color ="Red">
	<cfif (GetFavOff.BP1st2nd + GetUndDef.BP1st2nd) gt (GetUndOff.BP1st2nd + GetFavDef.BP1st2nd) >
		<cfset fBG4color ="Green">
		<cfset uBG4color ="">

	</cfif>

	<cfset uBG5color ="Red">
	<cfif (GetFavOff.BPPass + GetUndDef.BPPass) gt (GetFavDef.BPPass + GetUndOff.BPPass) >
		<cfset fBG5color ="Green">
		<cfset uBG5color ="">
	</cfif>

	<cfset uBG6color ="Red">	
	<cfif (GetFavOff.Succ3rddown + GetUndDef.Succ3rddown) gt (GetFavDef.Succ3rddown + GetUndOff.Succ3rddown) >
		<cfset fBG6color ="Green">
		<cfset uBG6color ="">

	</cfif>

	<cfset uBG7color ="Red">
	<cfif (GetFavOff.ATogo + GetUndDef.ATogo) lt (GetFavDef.ATogo + GetUndOff.ATogo) >
		<cfset fBG7color ="Green">
		<cfset uBG7color ="">

	</cfif>

	<cfset uBG8color ="Red">
	<cfif (GetFavOff.sk3rdlong + GetUndDef.sk3rdlong) lt (GetFavDef.sk3rdlong + GetUndOff.sk3rdlong) >
		<cfset fBG8color ="Green">
		<cfset uBG8color ="">

	</cfif>

	<cfset uBG9color ="Red">
	<cfif (GetFavOff.BadRes + GetUndDef.BadRes) lt (GetUndOff.BadRes + GetFavDef.BadRes) >
		<cfset fBG9color ="Green">
		<cfset uBG9color ="">

	</cfif>
	
	<cfset uBG10color ="Red">
	<cfif (GetFavOff.Irt3rdLong + GetUndDef.Irt3rdLong) lt (GetUndOff.Irt3rdLong + GetFavDef.Irt3rdLong) >
		<cfset fBG10color ="Green">
		<cfset uBG10color ="">

	</cfif>
	
	<cfset uBG11color ="Red">
	<cfif (GetFavOff.IRt2nd3rd + GetUndDef.IRt2nd3rd) lt (GetUndOff.IRt2nd3rd + GetFavDef.IRt2nd3rd) >
		<cfset fBG11color ="Green">
		<cfset uBG11color ="">

	</cfif>

	<cfset uBG12color ="Red">	
	<cfif (GetFavOff.RZSuccRt + GetUndDef.RZSuccRt) gt (GetUndOff.RZSuccRt + GetFavDef.RZSuccRt) >
		<cfset fBG12color ="Green">
		<cfset uBG12color ="">

	</cfif>
	
	<cfset uBG13color ="Red">
	<cfif (GetFavOff.RZPPP + GetUndDef.RZPPP) gt (GetUndOff.RZPPP + GetFavDef.RZPPP) >
		<cfset fBG13color ="Green">
		<cfset uBG13color ="">

	</cfif>

	<cfset uBG14color ="Red">
	<cfif (GetFavOff.RZPPG + GetUndDef.RZPPG) gt (GetFavDef.RZPPG + GetUndOff.RZPPG) >
		<cfset fBG14color ="Green">
		<cfset uBG14color ="">

	</cfif>
`	
	<cfoutput>
	<tr>
	<td align="center">#theTeam#</td>
	<td align="center" bgcolor="#fbg1color#">#Numberformat(((GetFavOff.overall + GetUndDef.overall)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fruncolor#">#Numberformat(((GetFavOff.RunSucRt + GetUndDef.RunSucRt)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg2color#">#Numberformat(((GetFavOff.Suc1stAnd2nd + GetUndDef.Suc1stAnd2nd)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg3color#">#Numberformat(((GetFavOff.BigPlay + GetUndDef.BigPlay)/2)*100,'99.99')#</td>
	<cfif 1 is 2>
	<td align="center" bgcolor="#fbg4color#">#Numberformat(((GetFavOff.BP1st2nd + GetUndDef.BP1st2nd)/2)*100,'99.99')#</td>
	</cfif>
	<td align="center" bgcolor="#fbg5color#">#Numberformat(((GetFavOff.BPPass + GetUndDef.BPPass)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg6color#">#Numberformat(((GetFavOff.Succ3rddown + GetUndDef.Succ3rddown)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg7color#">#Numberformat(((GetFavOff.ATogo + GetUndDef.ATogo)/2),'99.99')#</td>
	<td align="center" bgcolor="#fbg8color#">#Numberformat(((GetFavOff.sk3rdlong + GetUndDef.sk3rdlong)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg9color#">#Numberformat(((GetFavOff.BadRes + GetUndDef.BadRes)/2)*100,'99.99')#</td>
	<cfif 1 is 2>
	<td align="center" bgcolor="#fbg10color#">#Numberformat(((GetFavOff.Irt3rdLong + GetUndDef.Irt3rdLong)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#fbg11color#">#Numberformat(((GetFavOff.IRt2nd3rd + GetUndDef.IRt2nd3rd)/2)*100,'99.99')#</td>
	
	<td bgcolor="#fbg12color#">#Numberformat(((GetFavOff.RZSuccRt + GetUndDef.RZSuccRt)/2)*100,'99.99')#</td>
	<td bgcolor="#fbg13color#">#Numberformat(((GetFavOff.RZPPP + GetUndDef.RZPPP)/2),'99.99')#</td>
	<td bgcolor="#fbg14color#">#Numberformat(((GetFavOff.RZPPG + GetUndDef.RZPPG)/2),'99.99')#</td>
	</cfif>
	</tr>
	
	<cfset t1 = ((GetFavOff.RZPPP + GetUndDef.RZPPP)/2) * ((GetFavOff.RZPPG + GetUndDef.RZPPG)/2) >
	<cfset t2 = ((GetFavDef.RZPPP + GetUndOff.RZPPP)/2) * ((GetUndOff.RZPPG + GetFavDef.RZPPG)/2) >
	<cfset t3 = t1 + t2>
	
	<tr>
	<td align="center">#theopp#</td>
	<td align="center" bgcolor="#ubg1color#">#Numberformat(((GetFavDef.overall + GetUndOff.overall)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#uruncolor#">#Numberformat(((GetUndOff.RunSucRt + GetFavDef.RunSucRt)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg2color#">#Numberformat(((GetFavDef.Suc1stAnd2nd + GetUndOff.Suc1stAnd2nd)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg3color#">#Numberformat(((GetFavDef.BigPlay + GetUndOff.BigPlay)/2)*100,'99.99')#</td>
	<cfif 1 is 2>
	<td align="center" bgcolor="#ubg4color#">#Numberformat(((GetFavDef.BP1st2nd + GetUndOff.BP1st2nd)/2)*100,'99.99')#</td>
	</cfif>
	<td align="center" bgcolor="#ubg5color#">#Numberformat(((GetFavDef.BPPass + GetUndOff.BPPass)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg6color#">#Numberformat(((GetFavDef.Succ3rddown + GetUndOff.Succ3rddown)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg7color#">#Numberformat(((GetFavDef.ATogo + GetUndOff.ATogo)/2),'99.99')#</td>
	<td align="center" bgcolor="#ubg8color#">#Numberformat(((GetFavDef.sk3rdlong + GetUndOff.sk3rdlong)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg9color#">#Numberformat(((GetFavDef.BadRes + GetUndOff.BadRes)/2)*100,'99.99')#</td>
	<cfif 1 is 2>
	<td align="center" bgcolor="#ubg10color#">#Numberformat(((GetFavDef.Irt3rdLong + GetUndOff.Irt3rdLong)/2)*100,'99.99')#</td>
	<td align="center" bgcolor="#ubg11color#">#Numberformat(((GetFavDef.IRt2nd3rd + GetUndOff.IRt2nd3rd)/2)*100,'99.99')#</td>	
	
	<td bgcolor="#ubg12color#">#Numberformat(((GetFavDef.RZSuccRt + GetUndOff.RZSuccRt)/2)*100,'99.99')#</td>
	<td bgcolor="#ubg13color#">#Numberformat(((GetFavDef.RZPPP + GetUndOff.RZPPP)/2),'99.99')#</td>
	<td bgcolor="#ubg14color#">#Numberformat(((GetFavDef.RZPPG + GetUndOff.RZPPG)/2),'99.99')#</td>
	</cfif>
	</tr>

	<cfif 1 is 2>
	<tr>
	<td></td>
	<td>#avgPlaysucc#</td>
	<td></td>
	<td>#avgBigPlay#</td>
	<td></td>
	<td></td>
	<td>#avg3rddwnsucc#</td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td></td>
	<td>#avgRZPtsPerPlay#</td>
	<td>#avgRzPlaysPerGame# - Pred Pts: #t3#</td>
	</tr>
	</cfif>
	
	</table>	
	
	
	<p>
	<p>
	<p>
	</cfoutput>
	
	<cfquery datasource="sysstats3" name="Addit">
	insert into ADJPBPGameProjections(FAV,Week,HA,UND,
	PlaySuccessRt,
	BigPlayRt,
	BigPlay1st2ndRt,
	BigPlayPassRt,
	Success3rdDownRt,
	AvgToGo3rdDown,
	SackAllowedPct3rdDown,
	BadResult3rdDown,
	Int3rdAndLongRt,
	Int2nd3rdAndLong,
	RedzoneSuccessRt,
	RedZonePtsPerPlay,
	RedZonePlaysPerGame,
	RunSuccessRt
	) 
	VALUES('#theteam#',#theweek#,'#theha#','#theopp#',
	#Numberformat(((GetUndDef.overall + GetFavOff.overall)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.BigPlay + GetFavOff.BigPlay)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.BP1st2nd + GetFavOff.BP1st2nd)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.BPPass + GetFavOff.BPPass)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.Succ3rddown + GetFavOff.Succ3rddown)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.ATogo + GetFavOff.ATogo)/2),'99.99')#,
	#Numberformat(((GetUndDef.sk3rdlong + GetFavOff.sk3rdlong)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.BadRes + GetFavOff.BadRes)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.Irt3rdLong + GetFavOff.Irt3rdLong)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.IRt2nd3rd + GetFavOff.IRt2nd3rd)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.RZSuccRt + GetFavOff.RZSuccRt)/2)*100,'99.99')#,
	#Numberformat(((GetUndDef.RZPPP + GetFavOff.RZPPP)/2),'99.99')#,
	#Numberformat(((GetUndDef.RZPPG + GetFavOff.RZPPG)/2),'99.99')#,
	#Numberformat(((GetUndDef.RunSucRt + GetFavOff.RunSucRt)/2)*100,'99.99')#

	)
	</cfquery>
	
	
	<cfif theha is 'H'>
		<cfset theha = 'A'>
	<cfelse>	
		<cfset theha = 'H'>
	</cfif>
	
	

	<cfquery datasource="sysstats3" name="Addit">
	insert into ADJPBPGameProjections(FAV,Week,HA,UND,
	PlaySuccessRt,
	BigPlayRt,
	BigPlay1st2ndRt,
	BigPlayPassRt,
	Success3rdDownRt,
	AvgToGo3rdDown,
	SackAllowedPct3rdDown,
	BadResult3rdDown,
	Int3rdAndLongRt,
	Int2nd3rdAndLong,
	RedzoneSuccessRt,
	RedZonePtsPerPlay,
	RedZonePlaysPerGame,
	RunSuccessRt
	) 
	VALUES('#theopp#',#theweek#,'#theha#','#theteam#',
	
	#Numberformat(((GetFavDef.overall + GetUndOff.overall)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.BigPlay + GetUndOff.BigPlay)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.BP1st2nd + GetUndOff.BP1st2nd)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.BPPass + GetUndOff.BPPass)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.Succ3rddown + GetUndOff.Succ3rddown)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.ATogo + GetUndOff.ATogo)/2),'99.99')#,
	#Numberformat(((GetFavDef.sk3rdlong + GetUndOff.sk3rdlong)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.BadRes + GetUndOff.BadRes)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.Irt3rdLong + GetUndOff.Irt3rdLong)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.IRt2nd3rd + GetUndOff.IRt2nd3rd)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.RZSuccRt + GetUndOff.RZSuccRt)/2)*100,'99.99')#,
	#Numberformat(((GetFavDef.RZPPP + GetUndOff.RZPPP)/2),'99.99')#,
	#Numberformat(((GetFavDef.RZPPG + GetUndOff.RZPPG)/2),'99.99')#,
	#Numberformat(((GetFavDef.RunSucRt + GetUndOff.RunSucRt)/2)*100,'99.99')#
	
	
	)
	</cfquery>



	
</cfloop>


