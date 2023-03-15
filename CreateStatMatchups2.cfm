<cfinclude template="CreateSOS.cfm">
<cfinclude template="NewPowerRatingSystem2.cfm">

<cfquery datasource="psp_psp" Name="AddFav">
Delete from AdjustedGameStatsAVG
</cfquery>	

<cfquery datasource="psp_psp" Name="GetWeek">
SELECT Week + 1 As SpdWeek
FROM Week
</cfquery>

<cfset fname = 'NFLStatAnalysis#GetWeek.SpdWeek#'>

<cfif 1 is 2>
<cfheader name="Content-Disposition" value="inline; filename=#fname#.xls">
<cfcontent type="application/msexcel">
</cfif>


<cfquery datasource="psp_psp" Name="GetGames">
SELECT *
FROM NFLSpds
WHERE Week = #GetWeek.SpdWeek#
</cfquery>

<cfoutput query="GetGames">

	<cfquery datasource="psp_psp" Name="GetFavBTA">
	SELECT Team, PowerPts, PowerPtsPass, NewPowerRat
	FROM BetterThanAvg
	WHERE Team = '#GetGames.Fav#'
	</cfquery>

	<cfquery datasource="psp_psp" Name="GetUndBTA">
	SELECT Team, PowerPts, PowerPtsPass, NewPowerRat
	FROM BetterThanAvg
	WHERE Team = '#GetGames.Und#'
	</cfquery>



	<cfquery datasource="psp_psp" Name="GetFav">
	SELECT Team, RunWinPct, PassWinPct, BigPlay, BigPlayRun, BigPlayPass, RzPtsPerPlay
	FROM LineRatingAVGS
	WHERE Team = '#GetGames.Fav#'
	AND OffDef='O'
	</cfquery>
	
	<cfquery datasource="psp_psp" Name="GetUnd">
	SELECT Team, RunWinPct, PassWinPct, BigPlay, BigPlayRun, BigPlayPass, RzPtsPerPlay
	FROM LineRatingAVGS
	WHERE Team = '#GetGames.Und#'
	AND OffDef='D'
	</cfquery>
	
	<cfquery datasource="psp_psp" Name="GetFav2">
	SELECT Team, Avg(PS) as adjPS, Avg(dps) AS adjDPS, Avg(SackPct) as adjSkPct, Avg(dSackPct) as adjdSkPct,  Avg(IntPct) as adjIntPct, Avg(dIntPct) as adjdIntPct,
				AVG(pavg) as adjPavg, Avg(dpavg) as adjdPavg, AVG(again) as adjagain, AVG(dagain) as adjdagain
	FROM AdjustedGameStats
	WHERE Team = '#GetGames.Fav#'
	group by team
	</cfquery>
	
	<cfquery datasource="psp_psp" Name="GetUnd2">
	SELECT Team, Avg(PS) as adjPS, Avg(dps) AS adjDPS, Avg(SackPct) as adjSkPct, Avg(dSackPct) as adjdSkPct,  Avg(IntPct) as adjIntPct, Avg(dIntPct) as adjdIntPct,
	AVG(pavg) as adjPavg, Avg(dpavg) as adjdPavg,AVG(again) as adjagain, AVG(dagain) as adjdagain	
	FROM AdjustedGameStats
	WHERE Team = '#GetGames.Und#'
	group by team
	</cfquery>
		
	<cfloop query="GetFav2">	
	<cfquery datasource="psp_psp" Name="AddFav">
	INSERT INTO AdjustedGameStatsAVG(Team,PS,dps,SackPct,dSackPct,IntPct,dIntPct,pavg,dpavg,again,dagain)
	VALUES('#Team#',#adjPS#,#adjDPS#,#adjSkPct#,#adjdSkPct#,#adjIntPct#,#adjdIntPct#,#adjPavg#,#adjdPavg#,#adjagain#,#adjdagain#)
	</cfquery>		
	</cfloop>	
	
	<cfloop query="GetUnd2">	
	<cfquery datasource="psp_psp" Name="AddUnd">
	INSERT INTO AdjustedGameStatsAVG(Team,PS,dps,SackPct,dSackPct,IntPct,dIntPct,pavg,dpavg,again,dagain)
	VALUES('#Team#',#adjPS#,#adjDPS#,#adjSkPct#,#adjdSkPct#,#adjIntPct#,#adjdIntPct#,#adjPavg#,#adjdPavg#,#adjagain#,#adjdagain#)
	</cfquery>		
	</cfloop>	
	
	<cfquery datasource="psp_psp" Name="AddFav">
	Update AdjustedGameStatsAVG
	set AdjYppDif = Again - dAgain,
	AdjPavgDif = Pavg - dPavg,
	AdjSackDif = dSackpct - Sackpct,
	AdjIntDif = Dintpct - Intpct,
	AdjPtsDiff = PS - DPS 
	Where Team IN ('#GetGames.Fav#','#GetGames.Und#')
	</cfquery>	
	
	<cfquery datasource="psp_psp" Name="GetFavAdj">
	SELECT AdjYppDif,AdjPavgDif,AdjSackDif,AdjIntDif,AdjPtsDiff
	from AdjustedGameStatsAVG
	Where Team IN ('#GetGames.Fav#')
	</cfquery>	

	<cfquery datasource="psp_psp" Name="GetUndAdj">
	SELECT AdjYppDif,AdjPavgDif,AdjSackDif,AdjIntDif,AdjPtsDiff
	from AdjustedGameStatsAVG
	Where Team IN ('#GetGames.Und#')
	</cfquery>	
	
	<!--- TWO Key Stats Below Adjusted Yards Per Play Difference and Adjusted Points For/ Points Against Difference --->
	<cfset FavAdjYPPAdv    = GetFavAdj.AdjYppDif - GetUndAdj.AdjYppDif>  
	<cfset FavAdjPtsDifAdv = GetFavAdj.AdjPtsDiff - GetUndAdj.AdjPtsDiff>  
	<cfset FavPavgDiffAdv  = GetFavAdj.AdjPavgDif - GetUndAdj.AdjPavgDif>  
	<cfset FavPavgDiffPred = 6*(FavAdjYPPAdv )>  
	<cfset KeyStat      = FavAdjYPPAdv + FavPavgDiffAdv>
	
	<cfset KeyStatValue =0>
	<cfif GetGames.spread gt 0>
	<cfset KeyStatValue = KeyStat / Val(GetGames.spread)>
	</cfif>
	
	<cfset FavPredRunWinPct     = (GetFav.RunWinPct + (100 - GetUnd.RunWinPct)) / 2>
	<cfset FavPredPassWinPct    = (GetFav.PassWinPct + (100 - GetUnd.PassWinPct)) / 2>
	<cfset FavPredBigPlay       = (GetFav.BigPlay + GetUnd.BigPlay) / 2>
	<cfset FavPredBigPlayRun    = (GetFav.BigPlayRun + GetUnd.BigPlayRun) / 2>
	<cfset FavPredBigPlayPass   = (GetFav.BigPlayPass + GetUnd.BigPlayPass) / 2>
	<cfset FavPredRzPtsPerPlay  = (GetFav.RzPtsPerPlay + GetUnd.RzPtsPerPlay) / 2>
		
	<cfquery datasource="psp_psp" Name="GetFav">
	SELECT Team, RunWinPct, PassWinPct, BigPlay, BigPlayRun, BigPlayPass, RzPtsPerPlay
	FROM LineRatingAVGS
	WHERE Team = '#GetGames.Fav#'
	AND OffDef='D'
	</cfquery>
	
	<cfquery datasource="psp_psp" Name="GetUnd">
	SELECT Team, RunWinPct, PassWinPct, BigPlay, BigPlayRun, BigPlayPass, RzPtsPerPlay
	FROM LineRatingAVGS
	WHERE Team = '#GetGames.Und#'
	AND OffDef='O'
	</cfquery>
	
	<cfset UndPredRunWinPct     = (GetUnd.RunWinPct + (100 - GetFav.RunWinPct)) / 2>
	<cfset UndPredPassWinPct    = (GetUnd.PassWinPct + (100 - GetFav.PassWinPct)) / 2>
	<cfset UndPredBigPlay       = (GetUnd.BigPlay + GetFav.BigPlay) / 2>
	<cfset UndPredBigPlayRun    = (GetUnd.BigPlayRun + GetFav.BigPlayRun) / 2>
	<cfset UndPredBigPlayPass   = (GetUnd.BigPlayPass + GetFav.BigPlayPass) / 2>
	<cfset UndPredRzPtsPerPlay  = (GetUnd.RzPtsPerPlay + GetFav.RzPtsPerPlay) / 2>
	
	<cfset FavPredPts   = (GetFav2.adjPS + GetUnd2.adjdps)/2>
	<cfset UndPredPts   = (GetUnd2.adjPS + GetFav2.adjdps)/2>
	<cfset FavPredSkRt  = (GetFav2.adjskpct + GetUnd2.adjdskpct)/2>
	<cfset FavPredIntRt = (GetFav2.adjIntPct + GetUnd2.adjdIntPct)/2>
	<cfset UndPredSkRt  = (GetUnd2.adjskpct + GetFav2.adjdskpct)/2>
	<cfset UndPredIntRt = (GetUnd2.adjIntPct + GetFav2.adjdIntPct)/2>
	
	<cfset totpts = (FavPredPts + UndPredPts) >
	
	<!--- Use for spread predictions not included in the Total prediction --->
	<cfif GetGames.ha is 'H'>
		<cfset FavPredPts = FavPredPts + 1.5>
		<cfset UndPredPts = UndPredPts - 1.5>
		<cfset FavPavgDiffPred = FavPavgDiffPred + 3>  
		<cfset FavAdjPtsDifAdv = FavAdjPtsDifAdv + 3>
		<cfset FavPowerPtsHF = GetFavBTA.PowerPts + 3>
		<cfset FavNewPowerPtsHF = GetFavBTA.NewPowerRat + 3>
		<cfset UNDNewPowerPtsHF = GetUNDBTA.NewPowerRat>
		<cfset UNDPowerPtsHF = GetUNDBTA.PowerPts>
		<cfset KeyStatPred = ((2.6)*KeyStat) + 3>
	
	<cfelse>
		<cfset FavPredPts = FavPredPts - 1.5>
		<cfset UndPredPts = UndPredPts + 1.5>
		<cfset FavPavgDiffPred = FavPavgDiffPred - 3>  
		<cfset FavAdjPtsDifAdv = FavAdjPtsDifAdv - 3>
		<cfset FavPowerPtsHF = GetFavBTA.PowerPts - 3>
		<cfset FavNewPowerPtsHF = GetFavBTA.NewPowerRat - 3>
		<cfset UNDPowerPtsHF = GetUNDBTA.PowerPts>
		<cfset UNDNewPowerPtsHF = GetUNDBTA.NewPowerRat>
		<cfset KeyStatPred = ((2.6)*KeyStat) - 3>
	</cfif>
	
	<cfset PowerPtsSpdVal = 0>
	<cfif GetGames.spread gt 0>
	<cfset PowerPtsSpdVal = (GetFavBTA.PowerPtsPass - GetUndBTA.PowerPtsPass)/GetGames.spread>
	</cfif>
	
	<table width="100%" Border="1">
	<tr>
	<td>Team</td>
	<td>Spread</td>
	<td> New PowerPts Pred</td>
	<td> PowerPts Pred</td>
	<td> PowerPtsPass</td>
	
	<td>Adj Pred Pts</td>
	<td><b>Adj Yds/Play Diff</b></td>
	<td><b>Fav Adj Yds/Play Pred</b></td>
	<td><b>Adj Pass Diff</b></td>
	<td><b>Adj Pts Diff</b></td>
	<td><b>Adj Key Stat Differential</b></td>
	<td><b>Adj Key Stat Rating</b></td>
	<td><b>Adj Key Stat Pred</b></td>
	<td>Adj Sack%</td>
	<td>Adj Int%</td>
	<td>Overall Win Pct</td>
	<td>Run Win Pct</td>
	<td>Pass Win Pct</td>
	<td>Big Play Pct</td>
	<td>Big Play Run Pct</td>
	<td>Big Play Pass Pct</td>
	<td>Rz Points Per Play</td>
	</tr>
	<tr>
	<td>#GetGames.Fav#</td>
	<td>#GetGames.spread#</td>
	<td>#NumberFormat(FavNewPowerPtsHF,"99.99")#</td>
	<td>#NumberFormat(FavPowerPtsHF,"99.99")#</td>
	<td>#NumberFormat(GetFavBTA.PowerPtsPass,"99.99")#</td>
	<td>#Numberformat(FavPredPts,"99.99")#</td>
	<td>#Numberformat(GetFavAdj.AdjYppDif,"99.99")#</td>
	<td>#Numberformat(FavPavgDiffPred,"99.99")#</td>
	<td>#Numberformat(GetFavAdj.AdjPavgDif,"99.99")#</td>
	<td>#Numberformat(GetFavAdj.AdjPtsDiff,"99.99")#</td>
	<td>#Numberformat(KeyStat,"99.99")#</td>
	<td>#Numberformat(KeyStatValue,"99.99")#</td>
	<td>#Numberformat(KeyStatPred,"99.99")#</td>
	<td>#Numberformat(FavPredSkRt,"99.99")#</td>
	<td>#Numberformat(FavPredIntRt,"99.99")#</td>
	<td>#Numberformat((FavPredRunWinPct + FavPredPassWinPct)/2 ,"99.99")#</td>
	<td>#Numberformat(FavPredRunWinPct,"99.99")#</td>
	<td>#Numberformat(FavPredPassWinPct,"99.99")#</td>
	<td>#Numberformat(FavPredBigPlay,"99.99")#</td>
	<td>#Numberformat(FavPredBigPlayRun,"99.99")#</td>
	<td>#Numberformat(FavPredBigPlayPass,"99.99")#</td>
	<td>#Numberformat(FavPredRzPtsPerPlay,"99.99")#</td>
	</tr>
	<tr>
	<td>#GetGames.Und#</td>
	<td>&nbsp;</td>
	<td>#NumberFormat(UndNewPowerPtsHF,"99.99")#</td>
	<td>#NumberFormat(UndPowerPtsHF,"99.99")#</td>
	<td>#NumberFormat(GetUndBTA.PowerPtsPass,"99.99")#</td>
	
	
	<td>#Numberformat(UndPredPts,"99.99")#</td>
		<td>#Numberformat(GetUndAdj.AdjYppDif,"99.99")#</td>
	<td>&nbsp;</td>
	<td>#Numberformat(GetUndAdj.AdjPavgDif,"99.99")#</td>
	<td>#Numberformat(GetUndAdj.AdjPtsDiff,"99.99")#</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>#Numberformat(UndPredSkRt,"99.99")#</td>
	<td>#Numberformat(UndPredIntRt,"99.99")#</td>
	<td>#Numberformat((UndPredRunWinPct + UndPredPassWinPct)/2 ,"99.99")#</td>
	<td>#Numberformat(UndPredRunWinPct,"99.99")#</td>
	<td>#Numberformat(UndPredPassWinPct,"99.99")#</td>
	<td>#Numberformat(UndPredBigPlay,"99.99")#</td>
	<td>#Numberformat(UndPredBigPlayRun,"99.99")#</td>
	<td>#Numberformat(UndPredBigPlayPass,"99.99")#</td>
	<td>#Numberformat(UndPredRzPtsPerPlay,"99.99")#</td>
	</tr>
	<tr>
	<cfif 1 is 2>
	<td>#GetGames.ou#</td>
	<td>#Numberformat(totpts,"99.99")#</td>
	<cfelse>
	<td></td>
	<td></td>
	
	</cfif>
	
	
	
	<cfset clr="">
	<cfif FavNewPowerPtsHF - UndNewPowerPtsHF lt 0>
		<cfset clr="Red">
	</cfif>
	<td bgcolor="#clr#">#NumberFormat(FavNewPowerPtsHF - UndNewPowerPtsHF,"99.99")#</td>
	
	<cfset clr="">
	<cfif FavPowerPtsHF - UndPowerPtsHF lt 0>
		<cfset clr="Red">
	</cfif>
	<td bgcolor="#clr#">#NumberFormat(FavPowerPtsHF - UndPowerPtsHF,"99.99")#</td>
	
	<cfset clr="">
	<cfif GetFavBTA.PowerPtsPass - GetUndBTA.PowerPtsPass lt 0>
		<cfset clr="Red">
	</cfif>
	
	<td bgcolor="#clr#">#NumberFormat(GetFavBTA.PowerPtsPass - GetUndBTA.PowerPtsPass,"99.99")#</td>
	
	
	<cfset clr="">
	<cfif FavPredpts - UndPredPts lt 0>
		<cfset clr="Red">
	</cfif>
	<td nowrap="true" bgcolor="#clr#"><cfif (FavPredpts - UndPredPts) gt 0>#GetGames.Fav#<cfelse><b>#GetGames.Und#</b></cfif> by #Numberformat(FavPredpts - UndPredPts,"99.99")#</td>
	
	<cfset clr="">
	<cfif FavAdjYPPAdv lt 0>
		<cfset clr="Red">
	</cfif>	
	<td bgcolor="#clr#"<b>#NumberFormat(FavAdjYPPAdv,"99.99")#</b></td>
	
	<td>&nbsp;</td>
	<cfset clr="">
	<cfif FavPavgDiffAdv lt 0>
		<cfset clr="Red">
	</cfif>
	<td bgcolor="#clr#"><b>#NumberFormat(FavPavgDiffAdv,"99.99")#</b></td>
	<td><b>#NumberFormat(FavAdjPtsDifAdv,"99.99")#</b></td>
	<td><cfif KeyStat lt 0 or (KeyStatValue lt .5)>#GetGames.Und#<cfelse> <cfif KeyStat gt .5>#GetGames.Fav#</cfif></cfif></TD>
	<td>&nbsp;</TD>
	<td>&nbsp;</TD>
	<td>&nbsp;</TD>
	<td>&nbsp;</TD>
	<td>&nbsp;</TD>
	<td><cfif UndPredRunWinPct gt FavPredRunWinPct>Upset Alert<cfelse>&nbsp;</cfif></td>
	<td><cfif UndPredPassWinPct gt FavPredPassWinPct>Upset Alert<cfelse>&nbsp;</cfif></td>
	<td><cfif UndPredBigPlay gt FavPredBigPlay>Upset Alert<cfelse>&nbsp;</cfif></td>
	<td><cfif UndPredBigPlayRun gt FavPredBigPlayRun>Upset Alert<cfelse>&nbsp;</cfif></td>
	<td><cfif UndPredBigPlayPass gt FavPredBigPlayPass>Upset Alert<cfelse>&nbsp;</cfif></td>
	<td><cfif UndPredRzPtsPerPlay gt FavPredRzPtsPerPlay>Upset Alert<cfelse>&nbsp;</cfif></td>
	</tr>
	<cfset FinalFavPred = ((FavNewPowerPtsHF - UndNewPowerPtsHF) + (FavPowerPtsHF - UndPowerPtsHF) + (FavPredpts - UndPredPts) + FavAdjPtsDifAdv)/5>
	
	<cfset clr="">
	<cfif FinalFavPred lt GetGames.spread>
		<cfset clr="Red">
	</cfif>
	
	<tr bgcolor="yellow">
	
	<td nowrap="true" bgcolor="#clr#" colspan="4"><b>Avg Prediction All Power Ratings: #GetGames.fav# by #Numberformat(FinalFavPred,"99.99")	#</b></td>
	<td></td>
	<td></td>
	<td></td>
	<cfset clr="">
	<cfif PowerPtsSpdVal lt 0>
		<cfset clr="Red">
	</cfif>
	<cfif 1 is 2>
	<td colspan="4" bgcolor="#clr#"><b>PowerPtsSpdVal: #NumberFormat(PowerPtsSpdVal,"99.99")#</b></td>
	<td colspan="4">Our Predicted Total: #NumberFormat(GetFavBTA.PowerPtsPass + GetUndBTA.PowerPtsPass,"99.99")#</td>
	</cfif>
		</tr>
	</table>
</cfoutput>	




	
	
	
	
	
	
	
	
	
	
	
	
	

<cfif 1 is 2>
<cfquery datasource="psp_psp" Name="AddFav">
	INSERT INTO NFLStatAnalysis(Week,Year,Fav,Spread,FavNewPowerPtsHF,FavPowerPtsPass,FavPredPts,FavAdjYppDif,FavPavgDiffPred,FavAdjPavgDif,FavAdjPtsDiff,
	FavKeyStat,FavKeyStatValue,FavKeyStatPred,FavPredSkRt,FavPredIntRt,FavOverallWinPct,FavRunWinPct,FavPassWinPct,FavOverallBig,FavBigRun,FavPBigPass,FavPredRzPtsPerPlay,
	Und,UndNewPowerPtsHF,UndPowerPtsPass,UndPredPts,UndAdjYppDif,UndPavgDiffPred,UndAdjPavgDif,UndAdjPtsDiff,
	UndKeyStat,UndKeyStatValue,UndKeyStatPred,UndPredSkRt,UndPredIntRt,UndOverallWinPct,UndRunWinPct,UndPassWinPct,UndOverallBig,UndBigRun,UndPBigPass,UndPredRzPtsPerPlay)
	
	
	VALUES(#GetWeek.SpdWeek#,#GetWeek.SpdYear#,'#GetGames.Fav#',#GetWeek.Spread#,#FavNewPowerPtsHF#,#FavPowerPtsPass#,#FavPredPts#,#FavAdjYppDif#,#FavPavgDiffPred#,#FavAdjPavgDif#,#FavAdjPtsDiff#,#FavKeyStat#,#FavKeyStatValue#,#FavKeyStatPred#,#FavPredSkRt#,#FavPredIntRt#,#FavOverallWinPct#,#FavRunWinPct#,#FavPassWinPct#,#FavOverallBig#,#FavBigRun#,#FavPBigPass#,#FavPredRzPtsPerPlay#,
	
	
	
	
	#adjPS#,#adjDPS#,#adjSkPct#,#adjdSkPct#,#adjIntPct#,#adjdIntPct#,#adjPavg#,#adjdPavg#,#adjagain#,#adjdagain#)
</cfquery>	
</cfif>

</table>	
	

	










