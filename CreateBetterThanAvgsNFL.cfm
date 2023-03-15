<cfquery datasource="sysstats3" name="GetWeek">
Select week,startingweek 
from week
</cfquery>

<cfset week = GetWeek.week>
<cfset myweek = week>

<cfset Session.week= week + 1>
<cfset AdjWeek = (Session.week - GetWeek.Startingweek) + 1>

<cfset mypickfilename = 'PSPPicks#AdjWeek#.xls'>


<cfquery datasource="sysstats3" name="addit">
Delete from BetterThanAvg
</cfquery>

<cfquery datasource="sysstats3" name="addit">
Delete from AdjustedGameStats
</cfquery>


<cfquery name="UpdSysstats" datasource="sysstats3">
Update Sysstats
SET PSWOGarbage = ps
</cfquery>

<cfquery name="UpdSysstats" datasource="sysstats3">
Update Sysstats
SET DPSWOGarbage = dps
</cfquery>



<cfquery name="GetGarbageOff" datasource="sysstats3">
			Select pbp.week as pweek, pbp.Team as pTeam,pbp.opponent as popp,SUM(pbp.PTS) as GP, s.ps as sPS, s.dps as sdPS, s.ps - SUM(pbp.PTS) as WithGB  
			from PlayByPlayData pbp, Sysstats s
			where pbp.GarbageTime_Flag = 'Y'
			and pbp.offdef='O'
			and pbp.ptsscored < pbp.oppPtsScored
			
			and s.Team = pbp.Team
			and s.week = pbp.Week
			
			
			group by pbp.Team,pbp.opponent,pbp.week,s.Team,s.ps,s.dps,s.Week
			order by pbp.Team,pbp.week
</cfquery>

<cfloop query="GetGarbageOff">

	<cfquery name="UpdOff" datasource="sysstats3">
	Update Sysstats
		SET PSWOGarbage = #GetGarbageOff.WithGB#
	Where Team = '#GetGarbageOff.pTeam#'
	and Week = #GetGarbageOff.pWeek#	
	</cfquery>

</cfloop>


<cfquery name="GetGarbageDef" datasource="sysstats3">
			Select pbp.week as pweek, pbp.Team as pTeam,pbp.opponent as popp,SUM(pbp.PTS) as GP, s.ps as sPS, s.dps as sdPS, s.dps - SUM(pbp.PTS) as WithGB 
			from PlayByPlayData pbp, Sysstats s
			where pbp.GarbageTime_Flag = 'Y'
			and pbp.offdef='D'
			and pbp.ptsscored < pbp.oppPtsScored
			
			and s.Team = pbp.Team
			and s.week = pbp.Week
			
			
			group by pbp.Team,pbp.opponent,pbp.week,s.Team,s.ps,s.dps,s.Week
			order by pbp.Team,pbp.week
</cfquery>


<cfloop query="GetGarbageDef">

	<cfquery name="UpdDef" datasource="sysstats3">
	Update Sysstats
		SET DPSWOGarbage = #GetGarbageDef.WithGB#
	Where Team = '#GetGarbageDef.pTeam#'
	and Week = #GetGarbageDef.pWeek#	
	</cfquery>

</cfloop>


<cfquery datasource="SYSSTATS3" name="AvgTeam">
Select 
	   Avg(ps) as aps, 
	   Avg(pswogarbage) as apswg, 
	   Avg(dpswogarbage) as adpswg,
	   avg(Yards) as ayards,
	   Avg(Plays) as aplays,
	   avg(AGain) as aagain,
	   avg(ryds) as aryds,
	   avg(rushes) as arushes,
	   avg(ravg) as aravg,
	   avg(pyds) as apyds,
	   avg(cmp) as acmp,
	   avg(att) as aatt,
	   avg(pavg) as apavg, 	
	   Avg(sacked)/Avg(att) as asackpct, 
	   avg(interception)/avg(att) as aintpct,
	   Avg(dps) as adps, 
	   avg(dYards) as adyards,
	   Avg(dPlays) as adplays,
	   avg(dAGain) as adagain,
	   avg(dryds) as adryds,
	   avg(drushes) as adrushes,
	   avg(dravg) as adravg,
	   avg(dpyds) as adpyds,
	   avg(dcmp) as adcmp,
	   avg(datt) as adatt,
	   avg(dpavg) as adpavg, 	
	   Avg(dsacked)/Avg(datt) as adsackpct, 
	   avg(dinterception)/avg(datt) as adintpct

from sysstats		
where week >= #GetWeek.Startingweek#
</cfquery>




<cfquery datasource="SYSSTATS3"  name="GetTeams">
Select Distinct team from sysstats
</cfquery>

<!-- See how much better/wrose each team is versus the AVG team -->
<cfloop query="GetTeams">

<cfquery datasource="SYSSTATS3" name="TeamAvg">
Select 
		Avg(pswogarbage) as apswg,
	   Avg(ps) as aps, 
	   avg(Yards) as ayards,
	   Avg(Plays) as aplays,
	   avg(AGain) as aagain,
	   avg(ryds) as aryds,
	   avg(rushes) as arushes,
	   avg(ravg) as aravg,
	   avg(pyds) as apyds,
	   avg(cmp) as acmp,
	   avg(att) as aatt,
	   avg(pavg) as apavg, 	
	   Avg(sacked)/Avg(att) as asackpct, 
	   avg(interception)/avg(att) as aintpct	 ,
	   
		Avg(dps) as adps, 
		Avg(dpswogarbage) as adpswg,
	   avg(dYards) as adyards,
	   Avg(dPlays) as adplays,
	   avg(dAGain) as adagain,
	   avg(dryds) as adryds,
	   avg(drushes) as adrushes,
	   avg(dravg) as adravg,
	   avg(dpyds) as adpyds,
	   avg(dcmp) as adcmp,
	   avg(datt) as adatt,
	   avg(dpavg) as adpavg, 	
	   Avg(dsacked)/Avg(datt) as adsackpct, 
	   avg(dinterception)/avg(datt) as adintpct	 
	   
	     
from SYSSTATS		
Where Team = '#GetTeams.Team#'
and week >= #GetWeek.Startingweek#
</cfquery>
	
<cfloop query="TeamAvg">
	   <cfset stgb1 = ((TeamAvg.apswg - AvgTeam.aps)/AvgTeam.aps)*100>
	   <cfset st1 = ((TeamAvg.aps - AvgTeam.aps)/AvgTeam.aps)*100>
	   <cfset st2 = ((TeamAvg.aYards - AvgTeam.ayards)/AvgTeam.ayards)*100>
	   <cfset st3 = ((TeamAvg.aPlays - AvgTeam.aplays)/AvgTeam.aplays)*100>
	   <cfset st4 = ((TeamAvg.aAgain - AvgTeam.aAgain)/AvgTeam.aAgain)*100>
	   <cfset st5 = ((TeamAvg.aryds - AvgTeam.aryds)/AvgTeam.aryds)*100>
	   <cfset st6 = ((TeamAvg.arushes - AvgTeam.arushes)/AvgTeam.arushes)*100>
	   <cfset st7 = ((TeamAvg.aravg - AvgTeam.aravg)/AvgTeam.aravg)*100>
	   <cfset st8 = ((TeamAvg.apyds - AvgTeam.apyds)/AvgTeam.apyds)*100>
	   <cfset st9 = ((TeamAvg.acmp - AvgTeam.acmp)/AvgTeam.acmp)*100>
	   <cfset st10 = ((TeamAvg.aatt - AvgTeam.aatt)/AvgTeam.aatt)*100>
	   <cfset st11 = ((TeamAvg.apavg - AvgTeam.apavg)/AvgTeam.apavg)*100 >	
	  
	   <cfif TeamAvg.asackpct neq 0>
	   <cfset st12 = ((AvgTeam.asackpct - TeamAvg.asackpct)/TeamAvg.asackpct)*100 >	
	   <cfelse>
	   <cfset st12 = 0>
	   </cfif>
	   
	   <cfif TeamAvg.aintpct neq 0>
	   <cfset st13 = ((AvgTeam.aintpct - TeamAvg.aintpct)/TeamAvg.aintpct)*100 >	
		<cfelse>
		<cfset st13 = 0>
		</cfif>
	   <cfset st14 = ((TeamAvg.adps - AvgTeam.adps)/AvgTeam.adps)*100>
	   <cfset stgb2 = ((TeamAvg.adpswg - AvgTeam.adps)/AvgTeam.adps)*100>
	   <cfset st15 = ((TeamAvg.adYards - AvgTeam.adyards)/TeamAvg.adyards)*100>
	   <cfset st16 = ((TeamAvg.adPlays - AvgTeam.adplays)/TeamAvg.adplays)*100>
	   <cfset st17 = ((TeamAvg.adAgain - AvgTeam.adAgain)/TeamAvg.adAgain)*100>
	   <cfset st18 = ((TeamAvg.adryds - AvgTeam.adryds)/TeamAvg.adryds)*100>
	   <cfset st19 = ((TeamAvg.adrushes - AvgTeam.adrushes)/TeamAvg.adrushes)*100>
	   <cfset st20 = ((TeamAvg.adravg - AvgTeam.adravg)/TeamAvg.adravg)*100>
	   <cfset st21 = ((TeamAvg.adpyds - AvgTeam.adpyds)/TeamAvg.adpyds)*100>
	   <cfset st22 = ((TeamAvg.adcmp - AvgTeam.adcmp)/TeamAvg.adcmp)*100>
	   <cfset st23 = ((TeamAvg.adatt - AvgTeam.adatt)/TeamAvg.adatt)*100>
	   <cfset st24 = ((TeamAvg.adpavg - AvgTeam.adpavg)/TeamAvg.adpavg)*100 >	
	   
	   <cfif TeamAvg.adsackpct neq 0>
	   <cfset st25 = ((AvgTeam.adsackpct - TeamAvg.adsackpct)/AvgTeam.adsackpct)*100 >	
	   <cfelse>
	   <cfset st25 = 0>
	   </cfif>
	   <cfif TeamAvg.adintpct neq 0>
	   <cfset st26 = ((AvgTeam.adintpct - TeamAvg.adintpct)/AvgTeam.adintpct)*100 >	
	   <cfelse>	
		<cfset st26 = 0>
		</cfif>

</cfloop>	
	
<cfquery datasource="sysstats3" name="addit">
insert into BetterThanAvg
(Team,
ps,
yards,
plays,
Again,
Ryds,
Rushes,
Ravg,
pyds,
cmp,
att,
pavg,
sackpct,
intpct,
dps,
dyards,
dplays,
dAgain,
dRyds,
dRushes,
dRavg,
dpyds,
dcmp,
datt,
dpavg,
dsackpct,
dintpct,
psGB,
dpsGB

)
Values
(
'#GetTeams.Team#',
#st1#,
#st2#,
#st3#,
#st4#,
#st5#,
#st6#,
#st7#,
#st8#,
#st9#,
#st10#,
#st11#,
#st12#,
#st13#,
#st14#,
#st15#,
#st16#,
#st17#,
#st18#,
#st19#,
#st20#,
#st21#,
#st22#,
#st23#,
#st24#,
#st25#,
#st26#,
#stgb1#,
#stgb2#
)


</cfquery>	
</cfloop>



<cfquery datasource="sysstats3" name="GetWeek">
Select week,Startingweek 
from week
</cfquery>

<cfset week = GetWeek.week>

<cfquery datasource="sysstats3" name="addit">
Delete from PSPPicks where week = #week#
and system in ('QBR','LINEOFSCRIMMAGE','PassAvgPredBestBet','PassAvgPred','ScoringPred','ScoringPredBestBet','ComboPassAvgScore','PotentialBlowout','UNDERDOGBETTERREDZONE')
</cfquery>

<cfquery datasource="sysstats3" name="New2022">
  Select Team,  ((MIN(pavg)*2) - (MIN(dpavg)*2))  +  MIN(ravg) - MIN(dravg) as AdjForPass
  from betterThanAVG
  Group by Team
</cfquery>

  <cfset ct = 0>
  <cfset sumit=0>
  <cfoutput query="New2022">
    #Team#...#AdjForPass#<br>
    <cfset sumit = sumit + #AdjForPass#>
      <cfset ct = ct + 1>
  </cfoutput>

    <cfset NFLAvg = sumit/ct>
    <cfoutput>
	AvgNFL = #NFLAvg#
	</cfoutput>
	<p>
	<p>
	
<cfoutput query="New2022">

  <cfset temp1 = AdjForPass - NFLAvg>
  <cfset temp2 = temp1 / NFLAVG>

  <cfquery datasource="sysstats3" name="UpdNew2022">
  Update betterThanAVG
  Set RushPassBTA = #temp2#
  where team = '#team#'
  </cfquery>
</cfoutput>


-- Evaluate each game versus the opponents BTA rating
<cfoutput query="New2022">

	-- Get opponents for Team
	<cfquery datasource="sysstats3" name="opps">
	Select opp, week
	from Sysstats
	where team = '#team#'
	</cfquery>

	-- For each game/opponent played
	<cfloop query="opps">
	
		-- Get the BTA ratings for opponents 
		<cfquery datasource="sysstats3" name="oppBTA">
		Select pavg, dpavg, ravg, dravg
		from betterThanAVG
		where Team = '#opps.opp#' 
		</cfquery>

		-- Get the game stats
		<cfquery datasource="sysstats3" name="gameStats">
		Select pavg, dpavg, ravg, dravg
		from Sysstats
		where Team = '#New2022.Team#' 
		and week = #week#
		</cfquery>


		-- Create the adjusted game stats
		<cfset pavgAdj = ((((oppBTA.dpavg)*-1)/100)*gameStats.pavg) + gameStats.pavg>
		<cfset ravgAdj = ((((oppBTA.dravg)*-1)/100)*gameStats.ravg) + gameStats.ravg>
		
		<cfset dpavgAdj = gameStats.dpavg - ((((oppBTA.pavg)*1)/100)*gameStats.dpavg)>  
		<cfset dravgAdj = gameStats.dravg - ((((oppBTA.ravg)*1)/100)*gameStats.dravg)>  
		
		<cfquery datasource="sysstats3" name="updateit">
		UPDATE Sysstats
		SET pavgadj = #pavgAdj#, 
		    dpavgadj =#dpavgAdj#, 
			ravgadj = #ravgAdj#, 
			dravgadj = #dravgAdj#
		where Team = '#New2022.Team#' 
		and week = #opps.week#
		</cfquery>
		
		

	</cfloop>

</cfoutput>

-- Get the game grade based on how tough the opponent was
<cfquery datasource="sysstats3" name="gameGrades">
		Select Team, ((AVG(pavgadj) - AVG(dpavgadj)) * 2) + (AVG(ravgadj) - AVG(dravgadj)) as Grade
		from Sysstats
		group by Team
		order by 2 desc
</cfquery>
<p>
<h>Game Grades</h>
<cfoutput query="gameGrades">
<br>
#Team#: #Grade#<br>
</cfoutput>

<p>
<p>


<!---<cfinclude template="createPassPressure.cfm">--->
<cfinclude template="PowerPts.cfm">

<cfif 1 is 2>





<cfinclude template="PowerRat2014.cfm">
<cfinclude template="gap.cfm">
<cfinclude template="YdsPerPassRank.cfm">
<cfinclude template="PowerStats.cfm">

<!---
<cfinclude template="createbetterthanavgPBP.cfm">

<cfinclude template="QBR.cfm">
--->


<cfquery datasource="sysstats3" name="GetWeek">
Select week,Startingweek 
from week
</cfquery>

<cfset week = GetWeek.week>


<cfloop index="ii" from="#GetWeek.Startingweek#" to="#week#">

<!--- Next create the adjusted games stats based on the  --->
<cfquery datasource="SYSSTATS3" name="GetGames">
Select * from sysstats where week = #ii#
</cfquery>

<cfloop query="GetGames">

	<!--- Get Opponents BetterThanAvg Stats --->
	<cfquery datasource="sysstats3" name="GetOppInfo">
	Select * from BetterThanAvg where Team = '#GetGames.opp#'
	</cfquery>

	<!--- <cfoutput>
	'#GetGames.Team#' scored #GetGames.PS# against '#GetGames.opp#' whose defense rank was #GetOppInfo.dps/100#<br>
	</cfoutput> --->
	
	<cfif GetOppInfo.dps gte 35>
		<cfset newps = (-1*(.35)*GetGames.PS) + GetGames.Ps>		
	<cfelse>

		<cfset newps = (-1*(GetOppInfo.dps/100)*GetGames.PS) + GetGames.Ps>
	</cfif>	
		
	<cfif GetOppInfo.ps/100 lte -35>	
		<cfset newdps = GetGames.dPs - (1*(-.35)*GetGames.dPS)>

	<cfelse>
		<cfset newdps = GetGames.dPs - (1*(GetOppInfo.ps/100)*GetGames.dPS)>
	</cfif>




	<cfif GetOppInfo.dpavg gte 35>
		<cfset newpavg = (-1*(.35)*GetGames.Pavg) + GetGames.Pavg>		
	<cfelse>

		<cfset newpavg = (-1*(GetOppInfo.dpavg/100)*GetGames.Pavg) + GetGames.Pavg>
	</cfif>	
		
	<cfif GetOppInfo.pavg/100 lte -35>	
		<cfset newdpavg = GetGames.dPavg - (1*(-.35)*GetGames.dPavg)>

	<cfelse>
		<cfset newdpavg = GetGames.dPavg - (1*(GetOppInfo.pavg/100)*GetGames.dPavg)>
	</cfif>



	<cfif GetOppInfo.sackpct gte 35>
		<cfset newsk = (-1*(.35)*(GetGames.sacked/GetGames.att)) + (GetGames.sacked/GetGames.att)>		
	<cfelse>

		<cfset newsk = (-1*(GetOppInfo.dsackpct/100)* (GetGames.sacked/GetGames.att)) + (GetGames.sacked/GetGames.att)>
	</cfif>	
		
	<cfif GetOppInfo.sackpct/100 lte -35>	
		<cfset newdsk = (GetGames.dsacked/GetGames.datt) - (1*(-.35)*   GetGames.adsackpct)>

	<cfelse>
		<cfset newdsk = (GetGames.dsacked/GetGames.datt) - (1*(GetOppInfo.sackpct/100)* GetGames.dsacked/GetGames.datt)>
	</cfif>


	<cfif GetOppInfo.intpct gte 35>
		<cfset newint = (-1*(.35)*(GetGames.interception/GetGames.att)) + (GetGames.interception/GetGames.att)>		
	<cfelse>

		<cfset newint = (-1*(GetOppInfo.dintpct/100)* (GetGames.interception/GetGames.att)) + (GetGames.interception/GetGames.att)>
	</cfif>	
		
	<cfif GetOppInfo.intpct/100 lte -35>	
		<cfset newdint = (GetGames.dint/GetGames.datt) - (1*(-.35)*   GetGames.adintpct)>

	<cfelse>
		<cfset newdint = (GetGames.dint/GetGames.datt) - (1*(GetOppInfo.dintpct/100)* GetGames.dinterception/GetGames.datt)>
	</cfif>


<cfset newGain  = GetGames.aGain - (GetGames.aGain * (GetOppInfo.dagain/100))>
<cfset newdGain = GetGames.daGain - (GetGames.daGain * (GetOppInfo.again/100))>





	<cfquery datasource="sysstats3" name="GetOppInfo">
	Insert into AdjustedGameStats(week,Team,Opp,PS,DPS,pavg,dpavg,sackpct,dsackpct,intpct,dintpct,again,dagain) values(#ii#,'#GetGames.Team#','#GetGames.opp#',#newps#,#newdps#,#newpavg#,#newdpavg#,#newsk#,#newdsk#,#newint#,#newdint#,#newgain#,#newdgain#)
	</cfquery>

</cfloop>

</cfloop>



<cfquery datasource="sysstats3" name="GetWeek">
Select week,startingweek 
from week
</cfquery>

<cfset week = GetWeek.week>
<cfset myweek = week + 1>



<cfquery datasource="sysstats3" name="Getspds">
Select *
from nflspds
where Week = #myweek#
</cfquery>

<cfoutput query="Getspds">

<cfquery datasource="sysstats3" name="GetFavs">
Select Avg(ps) as aps, Avg(dps) as adps, Avg(pavg) as apavg, Avg(dpavg) as adpavg, Avg(sackpct) as askpct, Avg(dsackpct) as adskpct,
Avg(intpct) as aintpct, Avg(dintpct) as adintpct
from AdjustedGameStats
where Team = '#fav#'
</cfquery>

<cfquery datasource="sysstats3" name="GetUnd">
Select Avg(ps) as aps, Avg(dps) as adps, Avg(pavg) as apavg, Avg(dpavg) as adpavg, Avg(sackpct) as askpct, Avg(dsackpct) as adskpct,
Avg(intpct) as aintpct, Avg(dintpct) as adintpct
from AdjustedGameStats
where Team = '#und#'
</cfquery>

<cfset favpred = (GetFavs.aps + GetUnd.adps)/2>
<cfset undpred = (Getund.aps + GetFavs.adps)/2>

<cfset favpredpass = (GetFavs.apavg + GetUnd.adpavg)/2>
<cfset undpredpass = (Getund.apavg + GetFavs.adpavg)/2>

<cfset favpredskpct = ((GetFavs.askpct + GetUnd.adskpct)/2)*100>
<cfset undpredskpct = ((Getund.askpct + GetFavs.adskpct)/2)*100>

<cfset favpredintpct = ((GetFavs.aintpct + GetUnd.adintpct)/2)*100>
<cfset undpredintpct = ((Getund.aintpct + GetFavs.adintpct)/2)*100>



<cfif ha is 'H'>
	<cfset favpred = favpred + 3>
<cfelse>
	<cfset favpred = favpred - 3>
</cfif>	
<p>
<table border="1" bgcolor="yellow">
<tr>
<td>Team</td>
<td>Ps</td>
<td>Dps</td>
<td>Predicted Score</td>
<td>Predicted Margin</td>
<td>Predicted Pavg</td>
<td>Predicted Sack Pct</td>
<td>Predicted Int Pct</td>
</tr>

<tr>
<td>#fav#</td>
<td>#GetFavs.aPs#</td>
<td>#GetFavs.adPs#</td>
<td>#Favpred#</td>
<td>#Favpred - Undpred#</td>
<td>#Favpredpass - Undpredpass#</td>
<td>#Undpredskpct - Favpredskpct#</td>
<td>#Undpredintpct - Favpredintpct#</td>
</tr>

<tr>
<td>#und#</td>
<td>#GetUnd.aPs#</td>
<td>#GetUnd.adPs#</td>
<td>#Undpred#</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>

</table>

<cfset ct = 0>
<cfset UndWithOnePick = ''>
<cfset UndWithTwoPick = ''>
<cfset UndPassInFavPick = ''>
<cfset rat = 0>
<cfset UPIFBestBet = false>
<cfif Favpredpass - Undpredpass lt 0>
	<cfset ct = ct + 1>
	<cfset rat = abs(2 * (Favpredpass - Undpredpass))>
	<cfset UndPassInFavPick = '#und#'>
	<cfif rat ge 1>
		<cfset UPIFBestBet = true>
	</cfif>
</cfif>

<cfif  Undpredskpct - Favpredskpct lt 0>
	<cfset ct = ct + 1>
	<cfset rat = rat + abs(Undpredskpct - Favpredskpct)>
</cfif>

<cfif Undpredintpct - Favpredintpct lt 0 >
	<cfset ct = ct + 1>
	<cfset rat = rat + abs(Undpredintpct - Favpredintpct)>
</cfif>

<cfset UNDONEBestBet = false>
<cfif ct ge 1>
	<cfset UndWithOnePick = '#und#'>
	<cfif rat ge 1>
		<cfset UNDONEBestBet = true>
	</cfif>	
</cfif>		
		
<cfset UNDTWOBestBet = false>
<cfif ct gt 1>
	<cfset UndWithTwoPick = '#und#'>
	<cfif rat ge 1>
		<cfset UNDTWOBestBet = true>
	</cfif>	
</cfif>		
		




<cfif UndWithOnePick neq ''>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'UndOneInFav','#und#')
</cfquery>
<cfif UNDONEBestBet is true>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'UndOneInFavBestBet','#und#')
</cfquery>
</cfif>		
</cfif>

<cfif UndWithTwoPick neq ''>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'UndWithTwoPick','#und#')
</cfquery>

<cfif UNDTWOBestBet neq ''>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'UndWithTwoPickBestBet','#und#')
</cfquery>
	
</cfif>	
</cfif>		

<cfif UndPassInFavPick neq ''>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'UndPassInFav','#und#')
</cfquery>
<cfif UPIFBestBet is true>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'UndPassInFavBestBet','#und#')
</cfquery>
</cfif>
</cfif>		



<cfset StatDomination = false >		
<cfset PotentialPick = ''>
<cfif Favpredpass - Undpredpass gt 0 and Undpredskpct - Favpredskpct gt 0 and Undpredintpct - Favpredintpct gt 0 >
	<cfset PotentialPick = '#fav#'>
	<cfif (Favpredpass - Undpredpass)*2 + (Undpredskpct - Favpredskpct) + (Undpredintpct - Favpredintpct) ge 6>
		<cfset StatDomination = true >
	</cfif>
	
</cfif>

<cfif Favpredpass - Undpredpass lt 0 and Undpredskpct - Favpredskpct lt 0 and Undpredintpct - Favpredintpct lt 0 >
	<cfset PotentialPick = '#und#'>
	<cfif (Favpredpass - Undpredpass)*-2 + (Undpredskpct - Favpredskpct) + (Undpredintpct - Favpredintpct) le -6>
		<cfset StatDomination = true >
	</cfif>

</cfif>

<cfif PotentialPick neq ''>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'PotentialBlowout','#PotentialPick#')
</cfquery>
</cfif>



<cfif StatDomination is true>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'StatDomination','#PotentialPick#')
</cfquery>
</cfif>


<cfset SPPBestBet = false>
<cfset ScorePredPick = '#und#'>
<cfif (Favpred - Undpred) gt GetSpds.spread>
	<cfset ScorePredPick = '#fav#'>
	<cfif (Favpred - Undpred) ge (GetSpds.spread + 4)>
		<cfset SPPBestBet = true>
	</cfif>
	
<cfelse>
	<cfif GetSpds.spread - (Favpred - Undpred) ge 4>
		<cfset SPPBestBet = true>
	</cfif>
</cfif>

<cfset PPAPBestBet = false>
<cfset PredPassAvgPick = '#und#'>
<cfif (Favpredpass - Undpredpass) gt 0>
	<cfset PredPassAvgPick = '#fav#'>
	<cfif (Favpredpass - Undpredpass) ge 1>
		<cfset PPAPBestBet = true>
	</cfif>
	
<cfelse>
	<cfif (Favpredpass - Undpredpass) le -1>
		<cfset PPAPBestBet = true>
	</cfif>

</cfif>

<cfset Match = false>
<cfif '#trim(ScorePredPick)#' is '#trim(PredPassAvgPick)#'>
	<cfset Match = true>
</cfif>

<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'ScoringPred','#ScorePredPick#')
</cfquery>

<cfif SPPBestBet is true>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'ScoringPredBestBet','#ScorePredPick#')
</cfquery>
</cfif>


<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'PassAvgPred','#PredPassAvgPick#')
</cfquery>

<cfif PPAPBestBet is true>
	<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'PassAvgPredBestBet','#PredPassAvgPick#')
	</cfquery>
</cfif>

<cfif match is true>
<cfquery datasource="sysstats3" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#myweek#,'ComboPassAvgScore','#PredPassAvgPick#')
</cfquery>
</cfif>


<cfquery datasource="sysstats3" name="Addit"> 
	Insert into YdsPerPassPreds (Team,week,ProgramName,PredYdsPerPass) Values('#fav#',#myweek#,'CreateBetterThanAvgsNFL',#FavPredPass#)
</cfquery>

<cfquery datasource="sysstats3" name="Addit"> 
	Insert into YdsPerPassPreds (Team,week,ProgramName,PredYdsPerPass) Values('#und#',#myweek#,'CreateBetterThanAvgsNFL',#UndPredPass#)
</cfquery>

</cfoutput>

<cfinclude template="PASS2014.cfm">

	<cfquery datasource="FoxProPicks" name="GetRunDog"> 
	Select RunDog from Picks
	where Week = #week#
	and RunDogRat >= 1.0
	</cfquery>

	<cfloop query="GetRunDog">

		<cfquery datasource="sysstats3" name="Addit">
		Insert into PSPPicks
		(Week,
		System,
		Pick
		)
		values
		(
		#week#,
		'RUNDOG',
		'#GetRunDog.RunDog#'
		)
		</cfquery>

	</cfloop>


<cfquery datasource="sysstats3" name="GetAllPicks"> 
	Select * from PSPPicks
	where week = #myweek#
</cfquery>



<cfset aQBR             = arraynew(1)>
<cfset aLOS             = arraynew(1)>
<cfset aPBP             = arraynew(1)> 
<cfset aPBPPickRat      = arraynew(1)> 
<cfset aFav             = arraynew(1)>
<cfset aspd             = arraynew(1)>
<cfset aUnd             = arraynew(1)>
<cfset aPassPred        = arraynew(1)>
<cfset aPower           = arraynew(1)>
<cfset aPowerRat        = arraynew(1)>
<cfset aScoringPred     = arraynew(1)>
<cfset aOverUnder       = arraynew(1)>
<cfset aPassPredScoring = arraynew(1)>
<cfset aDriveChart      = arraynew(1)>
<cfset aAllAgree        = arraynew(1)>
<cfset aDriveChartPct   = arraynew(1)>
<cfset aRZ			    = arraynew(1)>
<cfset aFavOverallTeam  = arraynew(1)>
<cfset aUndOverallTeam  = arraynew(1)>
<cfset aFavOverallRat   = arraynew(1)>
<cfset aUndOverallRat   = arraynew(1)>

<cfset aFavSOSRat       = arraynew(1)>
<cfset aFavSOSRatTeam   = arraynew(1)>
<cfset aUndSOSRat       = arraynew(1)>
<cfset aUndSOSRatTeam   = arraynew(1)>

<cfset aRunDog          = arraynew(1)>
<cfset aPassDog         = arraynew(1)>
<cfset aPowerL5         = arraynew(1)>


<cfset bPowerPtsSpd     =arraynew(1)>
<cfset bPowerPtsPick    =arraynew(1)>
<cfset bPowerPtsPickRat =arraynew(1)>


<cfset bSOSPowerPtsSpd    =arraynew(1)>
<cfset bAvgSpread         =arraynew(1)>
<cfset bPowerPtsPick      =arraynew(1)>
<cfset bPowerPtsPickRat   =arraynew(1)>

<cfset bQBUnderPressure   =arraynew(1)>
<cfset bFavPassAdv        =arraynew(1)>
<cfset bFavBigPlayPassAdv =arraynew(1)>

<cfset bTrenchesAdj       =arraynew(1)>
<cfset bTurnover          =arraynew(1)>

<cfset bFavADJPtDifAdv    =arraynew(1)>
<cfset bFavLineWinDif     =arraynew(1)>
<cfset bRedzoneEff        =arraynew(1)>

<cfset aYPPDif            =arraynew(1)>
<cfset aYGainDif          =arraynew(1)>

<cfset xx = 0>
<cfset FavHFA = 3>
<cfset UndHFA = 3>

<cfinclude template="createLineRatingReportwinpct2.cfm">
<cfif 1 is 2>

<cfinclude template="createPassPressure.cfm">
</cfif>

<cfoutput query="Getspds">

	<cfset xx = xx + 1>
	<cfset myfav = trim(GetSpds.fav)>
	<cfset myund = trim(GetSpds.und)>
	<cfset myspd = GetSpds.spread>

	<cfset afav[xx] = '#myfav#'>
	<cfset aspd[xx] = '#myspd#'>
	<cfset aund[xx] = '#myund#'>

	
	
	<cfset FavHAPts = 0>
	<cfset UndHAPts = 0>
	
	<cfif Getspds.ha is 'H'>
		<cfset FavHAPts = FavHFA>
		<cfset UndHAPts = 0>
	<cfelse>
		<cfset FavHAPts = -1*UndHFA>
		<cfset UndHAPts = UndHFA>
	</cfif>	
	
	
	<cfquery datasource="sysstats3" name="FavGetPowerPts">
	SELECT PerformancePts
	FROM BetterThanAvg
	WHERE  Team = '#myfav#'
	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndGetPowerPts">
	SELECT PerformancePts
	FROM BetterThanAvg
	WHERE  Team = '#myund#'
	</cfquery>
	
	<cfset bPowerPtsSpd[xx]     = (FavGetPowerPts.PerformancePts - UndGetPowerPts.PerformancePts) + FavHAPts >
	
	
	<cfquery datasource="sysstats3" name="FavGetPowerPts">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myfav#'
	AND Category='AdjustedPtsDifferential'
	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndGetPowerPts">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myund#'
	AND Category='AdjustedPtsDifferential'
	</cfquery>
	
	<cfset bSOSPowerPtsSpd[xx]    = (FavGetPowerPts.CAT_VALUE - UndGetPowerPts.CAT_VALUE) + FavHAPts >
	
	
	
	<cfquery datasource="sysstats3" name="FavQBUP">
	SELECT d.SackRate - o.SackRate as Rating
	FROM PassPressure o, PassPressure d
	WHERE  o.Team = '#myfav#'
	AND    o.Team = d.Team
	AND    o.offdef='O'
	AND    d.offdef='D'
	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndQBUP">
	SELECT d.SackRate - o.SackRate as Rating
	FROM PassPressure o, PassPressure d
	WHERE  o.Team = '#myund#'
	AND    o.Team = d.Team
	AND    o.offdef='O'
	AND    d.offdef='D'

	</cfquery>
	
	
	<cfset bQBUnderPressure[xx]   = FavQBUP.Rating - UndQBUP.Rating>
	
	
	<cfquery datasource="sysstats3" name="FavGetPass">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myfav#'
	AND Category='OverallPass'
	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndGetPass">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myund#'
	AND Category='OverallPass'
	</cfquery>
	
	<cfset bFavPassAdv[xx]     = FavGetPass.CAT_VALUE - UndGetPass.CAT_VALUE>
	
	
	
	<cfquery datasource="sysstats3" name="FavGetTrench">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myfav#'
	AND Category='OverallTrenches'
	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndGetTrench">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myund#'
	AND Category='OverallTrenches'
	</cfquery>
	
	<cfset bTrenchesAdj[xx]       = FavGetTrench.CAT_VALUE - UndGetTrench.CAT_VALUE>
	
	
	
	
	<cfquery datasource="sysstats3" name="FavGetPass">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myfav#'
	AND Category='OverallBigPlayPass'
	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndGetPass">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myund#'
	AND Category='OverallBigPlayPass'
	</cfquery>
	
	<cfset bFavBigPlayPassAdv[xx] = FavGetPass.CAT_VALUE - UndGetPass.CAT_VALUE>
	
	
	<cfquery datasource="sysstats3" name="FavTO">
	SELECT d.IntRate - o.IntRate as Rating
	FROM PassPressure o, PassPressure d
	WHERE  o.Team = '#myfav#'
	AND    o.Team = d.Team
	AND    o.offdef='O'
	AND    d.offdef='D'

	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndTO">
	SELECT d.IntRate - o.IntRate as Rating
	FROM PassPressure o, PassPressure d
	WHERE  o.Team = '#myund#'
	AND    o.Team = d.Team
	AND    o.offdef='O'
	AND    d.offdef='D'

	</cfquery>
	
	<cfset bTurnover[xx] =  FavTO.Rating - UndTO.Rating>
	
	
	<cfquery datasource="sysstats3" name="FavGetWinPct">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myfav#'
	AND Category='AdjustedPtsDifferential'
	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndGetWinPct">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myund#'
	AND Category='AdjustedPtsDifferential'
	</cfquery>
	
	<cfset bFavADJPtDifAdv[xx] = FavGetWinPct.CAT_VALUE - UndGetWinPct.CAT_VALUE>
	
	
	<cfquery datasource="sysstats3" name="FavLW">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myfav#'
	AND Category='OverallLineWinPct'
	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndLW">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myund#'
	AND Category='OverallLineWinPct'
	</cfquery>
		
	<cfset bFavLineWinDif[xx] = FavLW.CAT_VALUE - UndLW.CAT_VALUE>
	
	
	<cfquery datasource="sysstats3" name="FavGetRZ">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myfav#'
	AND Category='RedzoneOverall'
	</cfquery>
	
	<cfquery datasource="sysstats3" name="UndGetRZ">
	SELECT CAT_VALUE
	FROM PBPRating
	WHERE  Team = '#myund#'
	AND Category='RedzoneOverall'
	</cfquery>
	
	<cfset bRedzoneEff[xx] = FavGetRZ.CAT_VALUE - UndGetRZ.CAT_VALUE>
		
	<cfquery dbtype="query" name="GetOverallRat"> 
	Select * from GetAllPicks
	where System='SOSRAT'
	and pick like ('#myfav#')
	</cfquery>

	<cfset aFavSOSRat[xx]     = GetOverallRat.PickRat>
	<cfset aFavSOSRatTeam[xx] = GetOverallRat.Pick>


	<cfquery dbtype="query" name="GetOverallRat"> 
	Select * from GetAllPicks
	where System='SOSRAT'
	and pick like ('#myund#')
	</cfquery>

	<cfset aUndSOSRat[xx]     = GetOverallRat.PickRat>
	<cfset aUndSOSRatTeam[xx] = GetOverallRat.Pick>


	<cfquery dbtype="query" name="GetPBP"> 
	Select * from GetAllPicks
	where System='PLAYBYPLAY2015'
	and Pick in('#myfav#','#myund#')
	and week = #myweek#
	</cfquery>

	<cfset aPBPPickRat[xx] = GetPBP.PickRat>
	<cfset PBPBestBet = ''>
	<cfif GetPBP.recordcount gt 0>
		<cfset aPBP[xx] = GetPBP.Pick>
		<cfif GetPBP.BestBetFlag is 'Y'>
			<cfset PBPBestBet = '**'>
		</cfif>	
			
	<cfelse>
		<cfset aPBP[xx] = 'PASS'>
	</cfif>

	<cfquery dbtype="query" name="GetOverallRat"> 
	Select * from GetAllPicks
	where System='FinalPicksRating'
	and pick like ('#myfav#')
	</cfquery>

	<cfset aFavOverallRat[xx] = GetOverallRat.PickRat>
	<cfset aFavOverallTeam[xx] = GetOverallRat.Pick>

	<cfquery dbtype="query" name="GetOverallRat"> 
	Select * from GetAllPicks
	where System='FinalPicksRating'
	and pick like ('#myund#')
	</cfquery>

	<cfset aUndOverallRat[xx] = GetOverallRat.PickRat>
	<cfset aUndOverallTeam[xx] = GetOverallRat.Pick>


	<cfquery dbtype="query" name="GetIt"> 
	Select * from GetAllPicks
	where System='OVERUNDER'
	and pick in ('#myfav#','#myund#')
	</cfquery>

	<cfif Getit.recordcount gt 0>
		<cfset aOverUnder[xx] = '#GetIt.OUPlay#'>
	<cfelse>	
		<cfset aOverUnder[xx] = ''>
	</cfif>

	<cfquery dbtype="query" name="GetPassPred"> 
	Select * from GetAllPicks
	where System='PassAvgPred'
	and pick in ('#myfav#','#myund#')
	</cfquery>
	
	<cfset aPassPred[xx] = GetPassPred.Pick>

	<cfquery dbtype="query" name="Getit"> 
	Select * from GetAllPicks
	where System='ScoringPred'
	and pick in ('#myfav#','#myund#')
	</cfquery>
	
	<cfset aScoringPred[xx] = GetIt.Pick>

	<cfquery dbtype="query" name="Getit"> 
	Select * from GetAllPicks
	where System='DRIVECHART'
	and pick in ('#myfav#','#myund#')
	</cfquery>
		
	<cfset aDriveChart[xx]    = GetIt.Pick>
	<cfset aDriveChartPct[xx] = GetIt.GameSimPct>

	<cfset TwoAgree = false>
	<cfif aPassPred[xx] is aScoringPred[xx]>
		<cfset TwoAgree = true>
		<cfset aPassPredScoring[xx] = aScoringPred[xx]>
	<cfelse>
		<cfset aPassPredScoring[xx] = ''>
	</cfif>

	<cfset AllAgree = false>
	<cfif TwoAgree and aDriveChart[xx] is aPassPredScoring[xx] >
		<cfset AllAgree = true>
		<cfset aAllAgree[xx] = aDriveChart[xx]>
	<cfelse>
		<cfset aAllAgree[xx] = ''>
	</cfif>	
		
	<cfquery dbtype="query" name="Getit"> 
	Select * from GetAllPicks
	where System='POWERRAT2014'
	and pick in ('#myfav#','#myund#')
	</cfquery>
	
	<cfif GetIt.recordcount gt 0>
		<cfset aPower[xx] = GetIt.Pick>	
		<cfset aPowerRat[xx] = GetIt.PickRat>
	<cfelse>
		<cfset aPower[xx] = ''>
		<cfset aPowerRat[xx] = 0>	
	</cfif>

	<cfquery dbtype="query" name="Getrz"> 
	Select * from GetAllPicks
	where System='UNDERDOGBETTERREDZONE'
	and pick in ('#myfav#','#myund#')
	</cfquery>

	<cfset aRZ[xx] = '#GetRz.Pick#' >


	<cfquery dbtype="query" name="Getrd"> 
	Select * from GetAllPicks
	where System='RUNDOG'
	and pick in ('#myfav#','#myund#')
	</cfquery>
	
	<cfset aRunDog[xx]    = GetRd.Pick>


	<cfquery dbtype="query" name="Getpd"> 
	Select * from GetAllPicks
	where System='PASSDOG'
	and pick in ('#myfav#','#myund#')
	</cfquery>

	<cfset aPassDog[xx]    = GetPd.Pick>


	<cfquery dbtype="query" name="Getl5p"> 
	Select * from GetAllPicks
	where System='L5POWER'
	and pick in ('#myfav#','#myund#')
	</cfquery>

	<cfset apowerl5[xx]    = GetL5P.Pick>


	<cfquery dbtype="query" name="GetQBR"> 
	Select * from GetAllPicks
	where System='QBR'
	and (pick like '#myfav#%' or pick like '**#myfav#%' or pick like '#myund#%' or pick like '**#myund#%')
	</cfquery>

	<cfset aQBR[xx]    = GetQBR.Pick>

	<cfquery dbtype="query" name="GetLOS"> 
	Select * from GetAllPicks
	where System='LINEOFSCRIMMAGE'
	and (pick like '#myfav#%' or pick like '**#myfav#%' or pick like '#myund#%' or pick like '**#myund#%')

	</cfquery>

	<cfset aLOS[xx]    = GetLos.Pick>
	<cfif aLOS[xx] is ''>
		<cfset aLOS[xx] = 'EVEN'>
	</cfif>

	<cfquery datasource="sysstats3" name="YPPFav"> 
	Select (fo.BTA - fd.BTA) as ff
	from PBPRating fo, PBPRating fd
	where fo.Category = 'AdjYPPBTAOFF'
	and   fd.Category = 'AdjYPPBTADEF'
	and   fo.Team = fd.Team
	and   fo.Team = '#myfav#'
	</cfquery>

	<cfquery datasource="sysstats3" name="YPPUnd"> 
	Select (fo.BTA - fd.BTA) as uu
	from PBPRating fo, PBPRating fd
	where fo.Category = 'AdjYPPBTAOFF'
	and   fd.Category = 'AdjYPPBTADEF'
	and   fo.Team = fd.Team
	and   fo.Team = '#myund#'
	</cfquery>
	
	
	<cfset aYPPDif[xx] = YPPFav.ff - YPPUnd.uu>
		
	
	<cfquery datasource="sysstats3" name="YGFav"> 
	Select (fo.BTA - fd.BTA) as ff
	from PBPRating fo, PBPRating fd
	where fo.Category = 'AdjGainOFF'
	and   fd.Category = 'AdjGainDEF'
	and   fo.Team = fd.Team
	and   fo.Team = '#myfav#'
	</cfquery>

	<cfquery datasource="sysstats3" name="YGUnd"> 
	Select (fo.BTA - fd.BTA) as uu
	from PBPRating fo, PBPRating fd
	where fo.Category = 'AdjGainOFF'
	and   fd.Category = 'AdjGainDEF'
	and   fo.Team = fd.Team
	and   fo.Team = '#myund#'
	</cfquery>
	
	
	<cfset aYGainDif[xx] = YGFav.ff - YGUnd.uu>
	
	

</cfoutput>
<p>
</p>


<cfsavecontent variable="pspPicks">
<table width="80%" align="center" border="1" cellpadding="2" cellspacing="4">
<tr bgcolor="yellow">

<td>Fav</td>	
<td>Spd</td>	
<td nowrap="">Power Pts Spread</td>
<td nowrap="">SOS Spread</td>
<td nowrap="">Avg Spread</td>
<td>Und</td>

<td nowrap="">Power Pts Pick</td>
<td nowrap="">Power Pts Rating</td>
<td nowrap="">SOS Pts Pick</td>
<td nowrap="">SOS Pts Rating</td>
<td nowrap="">ADJ Yds Per Play Dif</td>
<td nowrap="">QB Under Pressure</td>
<td nowrap="">Fav Pass ADV</td>
<td nowrap="">Big Play Pass Adv</td>
<td nowrap="">Better Overall YPP ADJ</td>
<td nowrap="">Trenches ADJ FAV Adv</td>
<td nowrap="">Turnover FAV ADV</td>
<td nowrap="">Pt Diff ADJ FAV Adv</td>
<td nowrap="">Line Win Diff ADJ FAV Adv</td>
<td nowrap="">Redzone FAV Adv</td>

<td nowrap="">LOS Prediction</td>
<td nowrap="">QBR Prediction</td>
<td nowrap="">PBP Prediction</td>
<td nowrap="">Power Rating</td>
<td nowrap="">Pass Prediction</td>
<td nowrap="">Scoring Prediction</td>
<td nowrap="">Game Sim</td>
<td nowrap="">Current Form</td>
<td nowrap="">Run Dog</td>
<td nowrap="">Pass Dog</td>
<td nowrap="">Over/Under</td>
<td nowrap="">Pass Pred & Scoring Agree</td>
<td nowrap="">Pass Pred/Scoring/GameSim Agree</td>
<td>RedZone Underdog</td>
<td nowrap="">FAV System Picks</td>
<td nowrap="">FAV System Rating</td>
<td nowrap="">UND System Picks</td>
<td nowrap="">UND System Rating</td>
<td nowrap="">FAV SOS Team</td>
<td nowrap="">FAV SOS Rating</td>
<td nowrap="">UND SOS Team</td>
<td nowrap="">UND SOS Rating</td>
<td>10*</td>
</tr>
<cfoutput>
<cfloop index="ii" from="1" to="#xx#">
	
	<cfquery datasource="sysstats3" name="GetBB"> 
	Select * from PSPPicks
	where System='ScoringPredBestBet'
	and pick in ('#afav[ii]#','#aund[ii]#')
	and week = #myweek#
	</cfquery>
	
	<cfset bestbetflag = ''>
	<cfif GetBB.Recordcount gt 0>
		<cfset bestbetflag = ' - Best Bet'>
	</cfif>
<tr>
<td align="center">#afav[ii]#</td>
<td align="center">#aspd[ii]#</td>
<td align="center">#bPowerPtsSpd[ii]#</td>
<td align="center">#bSOSPowerPtsSpd[ii]#</td>
<td align="center">#(bSOSPowerPtsSpd[ii] + bPowerPtsSpd[ii])/2#</td>
<td align="center">#aund[ii]#</td>

<cfset mypick = '#aund[ii]#'>

<cfif bPowerPtsSpd[ii] gt aspd[ii]>
	<cfset mypick = '#afav[ii]#'>
	<cfset myrat = bPowerPtsSpd[ii] - aspd[ii]>
<cfelse>

	<cfif bPowerPtsSpd[ii] gt 0>
		<cfset myrat = aspd[ii] - bPowerPtsSpd[ii]>
	<cfelse>
		<cfset myrat = aspd[ii] + bPowerPtsSpd[ii]>
	</cfif>

</cfif>	

<td>#mypick#</td>
<td>#myrat#</td>

<cfset mypick = '#aund[ii]#'>

<cfif bSOSPowerPtsSpd[ii] gt aspd[ii]>
	<cfset mypick = '#afav[ii]#'>
	<cfset myrat = bSOSPowerPtsSpd[ii] - aspd[ii]>
<cfelse>

	<cfif bSOSPowerPtsSpd[ii] gt 0>
		<cfset myrat = aspd[ii] - bSOSPowerPtsSpd[ii]>
	<cfelse>
		<cfset myrat = aspd[ii] - bSOSPowerPtsSpd[ii]>
	</cfif>
</cfif>

<td>#mypick#</td>
<td>#myrat#</td>
<td>#aYGainDif[ii]#</td>
<td>#bQBUnderPressure[ii]#</td>
<td>#bFavPassAdv[ii]#</td>
<td>#aYPPDif[ii]#</td>
<td>#bFavBigPlayPassAdv[ii]#</td>
<td>#bTrenchesAdj[ii]#</td>
<td>#bTurnover[ii]#</td>
<td>#bFavADJPtDifAdv[ii]#</td>
<td>#bFavLineWinDif[ii]#</td>
<td>#bRedzoneEff[ii]#</td>

<td align="center">#aLOS[ii]#</td>
<td align="center">#aQBR[ii]#</td>
<td align="center">#aPBP[ii]# #PBPBestBet# - #Numberformat(aPBPPickRat[ii],'99.9')# </td>
<td align="center">#aPower[ii]# - #aPowerRat[ii]#</td>
<td align="center">#aPassPred[ii]#</td>
<td align="center">#aScoringPred[ii]##BestBetFlag#</td>
<td align="center">#aDriveChart[ii]#-#aDriveChartPct[ii]#</td>
<td align="center">#apowerl5[ii]#</td>
<td align="center">#aRunDog[ii]#</td>
<td align="center">#aPassDog[ii]#</td>

<td align="center">#aOverUnder[ii]#</td>
<td align="center">#aPassPredScoring[ii]#</td>

<td align="center">#aAllAgree[ii]#</td>
<td align="center">#aRZ[ii]#</td>
<td align="center">#aFavOverallTeam[ii]#</td>
<td align="center">#aFavOverallRat[ii]#</td>
<td align="center">#aUndOverallTeam[ii]#</td>
<td align="center">#aUndOverallRat[ii]#</td>
<td align="center">#aFavSOSRatTeam[ii]#</td>
<td align="center">#aFavSOSRat[ii]#</td>
<td align="center">#aUndSOSRatTeam[ii]#</td>
<td align="center">#aUndSOSRat[ii]#</td>


<td align="center">&nbsp;</td>

</tr>
</cfloop>
</cfoutput>
</table>
</cfsavecontent>

<cffile action="WRITE" file="C:\ColdFusion9\wwwroot\psp2012\NFL\includes\#mypickfilename#" output=" 
<cfcontent type='application/vnd.ms-excel'> 
#pspPicks#" 
addnewline="Yes" nameconflict="overwrite"> 




<cfquery datasource="sysstats3" name="Getit">
	Update DataLoadStatus
	Set Step = 'PICKSAREREADY'
</cfquery>





<cfhttp url="http://www.pointspreadpros.com/EmailPicksHaveFinished.cfm?mylink=http://www.pointspreadpros.com/#mypickfilename#">

<cfset i = 0>
<cfloop index="ii" from="1" to="1000000">
<cfset i = i + 1>
</cfloop>
<cfquery datasource="sysstats3" name="GetWeek">
	Update DataLoadStatus
	set step = 'EMAILWASSENT'
</cfquery>
</body>
</html>
</cfif>