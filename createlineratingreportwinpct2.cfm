<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<p>
Efficiency
<p>
<cfquery datasource="sysstats3" name="getavg15">
Select o.team, 100*(avg(o.ps)/avg(o.yards)) as OffEff, 100*(avg(o.dps)/avg(o.dyards)) as DefEff, 100*((avg(o.ps)/avg(o.yards)) - (avg(o.dps)/avg(o.dyards))) as Rating   
from sysstats o
group by o.Team
order by 100*((avg(o.ps)/avg(o.yards)) - (avg(o.dps)/avg(o.dyards))) desc 
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	'#Getavg15.Team#'...#loopct#....#offeff#...#defeff#...#Rating#<br>
	
	<cfif 1 is 2>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Ranking,Cat_Value) VALUES ('#Getavg15.Team#','AvgOfAllRankings',#loopct#,#Getavg15.rating#)
	</cfquery>
	</cfif>
</cfoutput>	


<cfquery datasource="psp_psp" name="getrz">
Select o.Team, (SUM(o.PTS)/count(o.PlayType)) - (SUM(d.PTS)/count(d.PlayType))  as Rating
from PBPTendencies o, PBPTendencies d 
where 1 = 1
and (o.FieldPos = 5 and o.playtype in ('Run','Pass') )
and (d.FieldPos = 5 and d.playtype in ('Run','Pass') )
and d.offdef='D'
and o.team = d.team
and o.week = d.week
group by o.team
order by (SUM(o.PTS)/count(o.PlayType)) - (SUM(d.PTS)/count(d.PlayType)) desc
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getrz">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>


<cfabort>


<html>
<head>
	<title>Untitled</title>
</head>

<body>
<cfquery datasource="psp_psp" name="getdata1">
delete from PBPRating 
where (category <> 'RedzoneOverall'
and team <> 'ARZ')
</cfquery>
<cfset ct = 0>

Offensive Run...

<cfquery datasource="psp_psp" name="getdata1">
Select Team, avg(runwinpct) + avg(RunRating) as rating
from linerating
where offdef = 'O'
group by team
order by avg(runwinpct) + avg(RunRating) desc
</cfquery>

<cfquery datasource="psp_psp" name="getavg1">
Select avg(runwinpct) + avg(RunRating) as rating
from linerating
where offdef = 'O'
</cfquery>




<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata1">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>

<p>
Defensive Run...
<p>
<hr>

<cfquery datasource="psp_psp" name="getdata2">
Select Team, avg(runwinpct) - avg(RunRating) as rating
from linerating
where offdef = 'D'
group by team
order by avg(runwinpct) - avg(RunRating) desc 
</cfquery>

<cfquery datasource="psp_psp" name="getavg2">
Select avg(runwinpct) - avg(RunRating) as rating
from linerating
where offdef = 'D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata2">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>


<p>
Overall Run Win Rate Differential
<hr>


<cfquery datasource="psp_psp" name="getdata3">
Select o.Team, (  avg(o.runwinpct) + avg(d.runwinpct) + (avg(o.RunRating) - avg(d.RunRating))) / 3 as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
group by o.team
order by (avg(o.runwinpct) + avg(d.runwinpct) + (avg(o.RunRating) - avg(d.RunRating))) / 3 desc
</cfquery>

<cfquery datasource="psp_psp" name="getavg3">
Select (  avg(o.runwinpct) + avg(d.runwinpct) + (avg(o.RunRating) - avg(d.RunRating))) / 3 as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
</cfquery>




<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata3">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>






<p>
Offensive Passing....<br>

<cfset ct = 0>

<cfquery datasource="psp_psp" name="getdata4">
Select Team, avg(passwinpct) + avg(PassRating) as rating
from linerating
where offdef = 'O'
group by team
order by avg(passwinpct) + avg(PassRating) desc
</cfquery>

<cfquery datasource="psp_psp" name="getavg4">
Select avg(passwinpct) + avg(PassRating) as rating
from linerating
where offdef = 'O'
</cfquery>



<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata4">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>

<p>
Defensive Passing...
<hr>

<cfquery datasource="psp_psp" name="getdata5">
Select Team, avg(passwinpct) - avg(PassRating) as Rating
from linerating
where offdef = 'D'
group by team
order by avg(passwinpct) - avg(PassRating) desc 
</cfquery>

<cfquery datasource="psp_psp" name="getavg5">
Select avg(passwinpct) - avg(PassRating) as Rating
from linerating
where offdef = 'D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata5">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>

<p>
Overall Passing Differential
<hr>

<cfquery datasource="psp_psp" name="getdata6">
Select o.Team, (avg(o.passwinpct) + avg(d.passwinpct) + (avg(o.PassRating) - avg(d.PassRating)) / 3) as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
group by o.team
order by (avg(o.passwinpct) + avg(d.passwinpct) + (avg(o.PassRating) - avg(d.PassRating)) / 3) desc
</cfquery>


<cfquery datasource="psp_psp" name="getavg6">
Select (avg(o.passwinpct) + avg(d.passwinpct) + (avg(o.PassRating) - avg(d.PassRating)) / 3) as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata6">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>




<p>
<hr>
Overall Combined Line Rating...<p>
<cfquery datasource="psp_psp" name="getdata7">
Select o.Team, ((avg(o.passwinpct) + avg(d.passwinpct) + (avg(o.PassRating) - avg(d.PassRating)) / 3) + (avg(o.runwinpct) + avg(d.runwinpct) + (avg(o.RunRating) - avg(d.RunRating)) / 3) / 2)  as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
group by o.team
order by ((avg(o.passwinpct) + avg(d.passwinpct) + (avg(o.PassRating) - avg(d.PassRating)) / 3) + (avg(o.runwinpct) + avg(d.runwinpct) + (avg(o.RunRating) - avg(d.RunRating)) / 3) / 2) desc
</cfquery>


<cfquery datasource="psp_psp" name="getavg7">
Select ((avg(o.passwinpct) + avg(d.passwinpct) + (avg(o.PassRating) - avg(d.PassRating)) / 3) + (avg(o.runwinpct) + avg(d.runwinpct) + (avg(o.RunRating) - avg(d.RunRating)) / 3) / 2)  as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata7">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>


<p>

<hr>
Big Play Pass Offense...<p>
<cfquery datasource="psp_psp" name="getdata8">
Select o.Team, AVG(o.BigplayPass) as rating
from linerating o
where o.offdef='O'
group by o.team
order by AVG(o.BigplayPass) desc
</cfquery>


<cfquery datasource="psp_psp" name="getavg8">
Select AVG(o.BigplayPass) as rating
from linerating o
where o.offdef='O'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata8">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>



<p>

<hr>
Big Play Pass Defense...<p>
<cfquery datasource="psp_psp" name="getdata9">
Select o.Team, AVG(o.BigplayPass) as rating
from linerating o
where o.offdef='D'
group by o.team
order by AVG(o.BigplayPass) 
</cfquery>

<cfquery datasource="psp_psp" name="getavg9">
Select AVG(o.BigplayPass) as rating
from linerating o
where o.offdef='D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata9">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>



<p>

<hr>
Overall Big Play Pass Differential...<p>
<cfquery datasource="psp_psp" name="getdata10">
Select o.Team, (avg(o.BigplayPass) - avg(d.BigPlayPass))/2 as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
group by o.team
order by (avg(o.BigplayPass) - avg(d.BigPlayPass))/2 desc
</cfquery>


<cfquery datasource="psp_psp" name="getavg10">
Select (avg(o.BigplayPass) - avg(d.BigPlayPass))/2 as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata10">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>



<p>
<hr>
Big Play Run Offense...<p>
<cfquery datasource="psp_psp" name="getdata11">
Select o.Team, AVG(o.BigplayRun) as rating
from linerating o
where o.offdef='O'
group by o.team
order by AVG(o.BigplayRun) desc
</cfquery>

<cfquery datasource="psp_psp" name="getavg11">
Select AVG(o.BigplayRun) as rating
from linerating o
where o.offdef='O'
</cfquery>


<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata11">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>


<p>
<hr>
Big Play Run Defense...<p>
<cfquery datasource="psp_psp" name="getdata12">
Select o.Team, AVG(o.BigplayRun) as rating
from linerating o
where o.offdef='D'
group by o.team
order by AVG(o.BigplayRun) 
</cfquery>

<cfquery datasource="psp_psp" name="getavg12">
Select AVG(o.BigplayRun) as rating
from linerating o
where o.offdef='D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata12">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>



<p>

<hr>
Big Play Run Differential...<p>
<cfquery datasource="psp_psp" name="getdata13">
Select o.Team, (avg(o.BigplayRun) - avg(d.BigPlayRun))/2 as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
group by o.team
order by (avg(o.BigplayRun) - avg(d.BigPlayRun))/2 desc
</cfquery>


<cfquery datasource="psp_psp" name="getavg13">
Select (avg(o.BigplayRun) - avg(d.BigPlayRun))/2 as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata13">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>



<p>

<hr>
Overall Big Play Differential Rating...<p>
<cfquery datasource="psp_psp" name="getdata14">
Select o.Team, (avg(o.Bigplay) - avg(d.BigPlay))/2 as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
group by o.team
order by (avg(o.Bigplay) - avg(d.BigPlay))/2 desc
</cfquery>

<cfquery datasource="psp_psp" name="getavg14">
Select (avg(o.Bigplay) - avg(d.BigPlay))/2 as rating
from linerating d, linerating o
where o.team = d.team
and o.offdef='O'
and d.offdef='D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata14">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>




<p>

<hr>
Redzone Offense Rating...<p>


<cfquery datasource="psp_psp" name="getDefrz">
Select o.Team, count(o.PlayType) as TotPlays
from PBPTendencies o
where o.offdef='D'
and FieldPos = 5
group by o.team
</cfquery>



<cfquery datasource="psp_psp" name="getdata15">
Select o.Team, avg(o.RZPtsPerPlay) as rating
from linerating o
where o.offdef='O'
group by o.team
order by avg(o.RZPtsPerPlay) desc
</cfquery>


<cfquery datasource="psp_psp" name="getavg15">
Select avg(o.RZPtsPerPlay) as rating
from linerating o
where o.offdef='O'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata15">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>


<p>

<hr>
Redzone Defense Rating...<p>
<cfquery datasource="psp_psp" name="getdata16">
Select o.Team, avg(o.RZPtsPerPlay) as rating
from linerating o
where o.offdef='D'
group by o.team
order by avg(o.RZPtsPerPlay) 
</cfquery>

<cfquery datasource="psp_psp" name="getavg16">
Select avg(o.RZPtsPerPlay) as rating
from linerating o
where o.offdef='D'
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata16">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>


<p>

Fix ARZ defense redzone..
<cfquery datasource="psp_psp" name="getavg17">
SELECT Team,RzPtsPerPlay FROM LineRating 
WHERE Team in (SELECT opp from LineRating where team = 'ARZ')
AND OffDef = 'O'
</cfquery>

<cfloop query = "getavg17">

<cfquery datasource="psp_psp" name="upd">
UPDATE LineRating
SET RZPtsPerPlay = #GetAvg17.RzPtsPerPlay#
WHERE opp = '#GetAvg17.Team#'
AND OffDef = 'D'
</cfquery>

</cfloop>

<hr>
Redzone Overall Rating...<p>

<cfquery datasource="psp_psp" name="getdata17">
Select o.Team, (SUM(o.PTS)/count(o.PlayType)) - (SUM(d.PTS)/count(d.PlayType))  as Rating
from PBPTendencies o, PBPTendencies d 
where 1 = 1
and (o.FieldPos = 5 and o.playtype in ('Run','Pass') )
and (d.FieldPos = 5 and d.playtype in ('Run','Pass') )
and d.offdef='D'
and o.team = d.team
and o.week = d.week
group by o.team
order by (SUM(o.PTS)/count(o.PlayType)) - (SUM(d.PTS)/count(d.PlayType)) desc
</cfquery>


<cfquery datasource="psp_psp" name="getavg17">
Select avg(o.RZPtsPerPlay) - avg(d.RZPtsPerPlay) as rating
from linerating o, linerating d 
where o.offdef='O'
and d.offdef='D'
and o.Team = d.Team
</cfquery>



<cfquery datasource="psp_psp" name="getit18">
Select o.Team, avg(o.Pavg) - avg(o.dPavg) as rating
from AdjustedGameStats o 
Group By o.Team
order by avg(o.Pavg) - avg(o.dPavg) desc
</cfquery>

<cfquery datasource="psp_psp" name="getit19">
Select o.Team, avg(o.Pavg)  as rating
from AdjustedGameStats o 
Group By o.Team
order by avg(o.Pavg) desc
</cfquery>

<cfquery datasource="psp_psp" name="getit20">
Select o.Team, avg(o.dPavg) as rating
from AdjustedGameStats o 
Group By o.Team
order by avg(o.dPavg) 
</cfquery>




<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getdata17">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>

<cfquery datasource="psp_psp" name="GetTeams">
SELECT Team 
FROM BetterThanAvg
</cfquery>


	<cfset loopct = 0>
	<cfoutput query="GetData1">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData1.Team#','OffRun',#GetData1.Rating#,#loopct#,#GetData1.Rating# - #GetAvg1.Rating#)
		</cfquery>
	</cfoutput>

	<cfset loopct = 0>
	<cfoutput query="GetData2">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData2.Team#','DefRun',#GetData2.Rating#,#loopct#,#GetData2.Rating# - #GetAvg2.Rating#)
		</cfquery>
	</cfoutput>
	
	
	<cfset loopct = 0>
	<cfoutput query="GetData3">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData3.Team#','OverallRun',#GetData3.Rating#,#loopct#,#GetData3.Rating# - #GetAvg3.Rating#)
		</cfquery>
	</cfoutput>
	

	<cfset loopct = 0>
	<cfoutput query="GetData4">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData4.team#','OffPass',#GetData4.Rating#,#loopct#,#GetData4.Rating# - #GetAvg4.Rating#)
		</cfquery>
	</cfoutput>

	<cfset loopct = 0>
	<cfoutput query="GetData5">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData5.Team#','DefPass',#GetData5.Rating#,#loopct#,#GetData5.Rating# - #GetAvg5.Rating#)
		</cfquery>
	</cfoutput>
	
		
	
	<cfquery datasource="psp_psp" name="GetIt1">
	SELECT orun.Team,'OverallOffense', orun.BTA + oPass.BTA AS myval
	FROM PBPRating orun, PBPRating opass
	WHERE orun.Team = opass.Team
	AND orun.Category = 'OffRun'
	AND opass.Category = 'OffPass'
	</cfquery>
	
	<cfloop query="Getit1">
	<cfquery datasource="psp_psp" name="Addit">
	INSERT INTO PBPRating(Team,Category,Cat_Value,BTA) 
	values('#GetIt1.Team#','OverallOffense',#GetIt1.myval#,#GetIt1.myval#)
	</cfquery>
	</cfloop>
	
	
	<cfquery datasource="psp_psp" name="GetIt1">
	SELECT drun.Team,'OverallDefense', drun.BTA + dPass.BTA as myval
	FROM PBPRating drun, PBPRating dpass
	WHERE drun.Team = dpass.Team
	AND drun.Category = 'DefRun'
	AND dpass.Category = 'DefPass'
	</cfquery>
	

	<cfloop query="Getit1">
	<cfquery datasource="psp_psp" name="Addit">
	INSERT INTO PBPRating(Team,Category,Cat_Value,BTA) 
	values('#GetIt1.Team#','OverallDefense',#GetIt1.myval#,#GetIt1.myval#)
	</cfquery>
	</cfloop>
	


	
	<cfset loopct = 0>
	<cfoutput query="GetData6">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData6.Team#','OverallPass',#GetData6.Rating#,#loopct#,#GetData6.Rating# - #GetAvg6.Rating#)
		</cfquery>
	</cfoutput>


	<cfset loopct = 0>
	<cfoutput query="GetData7">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData7.Team#','OverallCombinedRunPass',#GetData7.Rating#,#loopct#,#GetData7.Rating# - #GetAvg7.Rating#)
		</cfquery>
	</cfoutput>


	<cfset loopct = 0>
	<cfoutput query="GetData8">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData8.Team#','OffBigPlayPass',#GetData8.Rating#,#loopct#,#GetData8.Rating# - #GetAvg8.Rating#)
		</cfquery>
	</cfoutput>

	<cfset loopct = 0>
	<cfoutput query="GetData9">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData9.Team#','DefBigPlayPass',#GetData9.Rating#,#loopct#,#GetAvg9.Rating# - #GetData9.Rating#)
		</cfquery>
	</cfoutput>

	<cfset loopct = 0>
	<cfoutput query="GetData10">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData10.Team#','OverallBigPlayPass',#GetData10.Rating#,#loopct#,#GetData10.Rating# - #GetAvg10.Rating#)
		</cfquery>
	</cfoutput>
	
	
	
	
	<cfset loopct = 0>
	<cfoutput query="GetData11">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData11.Team#','OffBigPlayRun',#GetData11.Rating#,#loopct#,#GetData11.Rating# - #GetAvg11.Rating#)
		</cfquery>
	</cfoutput>

	<cfset loopct = 0>
	<cfoutput query="GetData12">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData12.Team#','DefBigPlayRun',#GetData12.Rating#,#loopct#,#GetAvg12.Rating# - #GetData12.Rating#)
		</cfquery>
	</cfoutput>

	<cfset loopct = 0>
	<cfoutput query="GetData13">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData13.Team#','OverallBigPlayRun',#GetData13.Rating#,#loopct#,#GetData13.Rating# - #GetAvg13.Rating#)
		</cfquery>
	</cfoutput>
	
	<cfset loopct = 0>
	<cfoutput query="GetData14">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData14.Team#','OverallCombinedBigPlayRunPass',#GetData14.Rating#,#loopct#,#GetData14.Rating# - #GetAvg14.Rating#)
		</cfquery>
	</cfoutput>

	<cfset loopct = 0>
	<cfoutput query="GetData15">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData15.Team#','RedzoneOffense',#GetData15.Rating#,#loopct#,#GetData15.Rating# - #GetAvg15.Rating#)
		</cfquery>
	</cfoutput>

	
	<cfset loopct = 0>
	<cfoutput query="GetData16">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData16.Team#','RedzoneDefense',#GetData16.Rating#,#loopct#,#GetData16.Rating# - #GetAvg16.Rating#)
		</cfquery>
	</cfoutput>
	
	<cfset loopct = 0>
	<cfoutput query="GetData17">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetData17.Team#','RedzoneOverall',#GetData17.Rating#,#loopct#,#GetData17.Rating# - #GetAvg17.Rating#)
		</cfquery>
	</cfoutput>
	
	<cfquery datasource="psp_psp" name="GetWeek">
		SELECT week from Week
	</cfquery>
	
	
	
	<cfquery datasource="psp_psp" name="GetTeams">
	SELECT Team 
	FROM BetterThanAvg
	</cfquery>



<cfloop query="GetTeams">

	<cfset gamect        = 0>
	<cfset AdjPAVGTotal  = 0> 
	<cfset AdjdPAVGTotal = 0>
	<cfset AdjAgainTotal = 0> 
	<cfset AdjAgain      = 0>
	<cfset AdjdAgain     = 0>
	<cfset TotOppRnk = 0>
		
	
	<cfset AdjdAgainTotal = 0>
		
	
	
	-- Get the opponents for the team
	<cfquery datasource="psp_psp" name="GetOpp">
	SELECT OPP,week
	FROM LineRating
	WHERE TEAM = '#GetTeams.Team#'
	</cfquery>	

	<cfloop query="GetOpp">
	
		<cfset gamect = gamect + 1>
	
		<cfquery datasource="psp_psp" name="GetOppBTA">
		SELECT dagain/100 as dagain2, again/100 as again2
		FROM BetterThanAvg
		WHERE TEAM = '#Getopp.opp#'
		</cfquery>	
	
	
		<cfquery datasource="sysstats3" name="GetTeamAgn">
		SELECT Again, dagain
		FROM Sysstats
			WHERE TEAM = '#GetTeams.Team#'
		and opp='#Getopp.opp#'
		and week = #Getopp.week#
		</cfquery>	
	
	
	<cfif 1 is 2>
	<cfquery datasource="psp_psp" name="GetOppRank">
	SELECT Ranking
	FROM LineRating
	WHERE TEAM = '#GetOpp.opp#'
	and Category='AvgOfAllRankings'
	</cfquery>	
	</cfif>
	
	
		<cfif GetTeamAgn.recordcount is 0>
		<cfabort showerror="No data found for #GetTeams.Team# for week = #Getopp.week#">
		</cfif>
		
		<cfset AdjAgain = GetTeamAgn.Again + ((-1*GetOppBTA.dagain2) * GetTeamAgn.Again)>
		<cfset AdjAgainTotal = AdjAgainTotal + AdjAgain> 
		
		<cfset AdjdAgain = GetTeamAgn.dAgain + ((GetOppBTA.dagain2) * GetTeamAgn.dAgain)>
		<cfset AdjdAgainTotal = AdjdAgainTotal + AdjdAgain>
	
		<cfif 1 is 2>
		<cfset TotOppRnk = TotOppRnk + GetOppRank>
		</cfif>
	
		<cfquery datasource="psp_psp" name="GetOppBTA">
		SELECT dpavg/100 as dpavg2, pavg/100 as pavg2
		FROM BetterThanAvg
		WHERE TEAM = '#Getopp.opp#'
		</cfquery>	
	
	
		<cfquery datasource="sysstats3" name="GetTeamPavg">
		SELECT pavg, dpavg
		FROM Sysstats
		WHERE TEAM = '#GetTeams.Team#'
		and opp='#Getopp.opp#'
		and week = #Getopp.week#
		</cfquery>	
	
		<cfset gamect = gamect + 1>
		<cfset AdjPAVG = GetTeamPavg.Pavg + ((-1*GetOppBTA.dPavg2) * GetTeamPavg.Pavg)>
		<cfset AdjPAVGTotal = AdjPAVGTotal + AdjPAVG> 
		
		<cfset AdjdPAVG = GetTeamPavg.dPavg + ((GetOppBTA.dPavg2) * GetTeamPavg.dPavg)>
		<cfset AdjdPAVGTotal = AdjdPAVGTotal + AdjdPAVG>
		
		

		<cfquery datasource="psp_psp" name="GetOppBTA">
		SELECT BTA
		FROM PBPRating
		WHERE TEAM = '#Getopp.opp#'
		AND Category='OverallDefense'
		</cfquery>	
		

		<cfquery datasource="psp_psp" name="GetTeamLineRating">
		SELECT Rating
		FROM LineRating
		WHERE opp = '#Getopp.opp#'
		AND team = '#GetTeams.Team#'
		AND offdef='O'
		</cfquery>	
		
		<cfif GetOppBTA.BTA gt 0>

			<cfset AdjRat = GetTeamLineRating.Rating + (GetTeamLineRating.Rating * (GetOppBTA.BTA/100))>

		<cfelse>
			
			<cfif GetTeamLineRating.Rating gte 0>
			
				<cfset AdjRat = GetTeamLineRating.Rating - ABS(( (GetOppBTA.BTA/100) * GetTeamLineRating.Rating))>
			<cfelse>
			
				<cfset AdjRat = GetTeamLineRating.Rating - ABS(( (GetOppBTA.BTA/100) * GetTeamLineRating.Rating))>
			</cfif>
		</cfif>
	
	
		<cfquery datasource="psp_psp" name="UpdLineRating">
		UPDATE  LineRating
		SET ADJRATING = #adjRat#
		WHERE opp = '#Getopp.opp#'
		AND Team = '#GetTeams.Team#'
		AND week = #GetOpp.week#
		AND OFFDEF='O'
		</cfquery>	
	
	</cfloop>
	
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,BTA) VALUES ('#GetTeams.Team#','AdjYPPBTAOFF',#AdjPAVGTotal/gamect#,#AdjPAVGTotal/gamect#)
	</cfquery>
	
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,BTA) VALUES ('#GetTeams.Team#','AdjYPPBTADEF',#AdjdPAVGTotal/gamect#,#AdjdPAVGTotal/gamect#)
	</cfquery>
	
	
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,BTA) VALUES ('#GetTeams.Team#','AdjGainOFF',#AdjaGainTotal/gamect#,#AdjaGainTotal/gamect#)
	</cfquery>
	
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,BTA) VALUES ('#GetTeams.Team#','AdjGainDEF',#AdjdaGainTotal/gamect#,#AdjdaGainTotal/gamect#)
	</cfquery>
	
	
	
		
</cfloop>	

	
	

<cfloop query="GetTeams">

	
	<cfquery datasource="psp_psp" name="GetOpp">
	SELECT OPP,week
	FROM LineRating
	WHERE TEAM = '#GetTeams.Team#'
	</cfquery>	

	<cfloop query="GetOpp">
	
		
		<cfquery datasource="psp_psp" name="GetOppBTA">
		SELECT BTA
		FROM PBPRating
		WHERE TEAM = '#Getopp.opp#'
		AND Category='OverallOffense'
		</cfquery>	
		
		
		<cfquery datasource="psp_psp" name="GetTeamLineRating">
		SELECT Rating
		FROM LineRating
		WHERE opp = '#Getopp.opp#'
		AND team = '#GetTeams.Team#'
		AND offdef='D'
		</cfquery>	
		
		<cfif GetOppBTA.BTA gt 0>
			
			
			<cfset AdjRat = GetTeamLineRating.Rating - (GetTeamLineRating.Rating * (GetOppBTA.BTA/100))>
			
		<cfelse>
			
			<cfif GetTeamLineRating.Rating gte 0>
			
			
			
				<cfset AdjRat = GetTeamLineRating.Rating + ABS(( (GetOppBTA.BTA/100) * GetTeamLineRating.Rating))>
			<cfelse>
			
				<cfset AdjRat = GetTeamLineRating.Rating + ABS(( (GetOppBTA.BTA/100) * GetTeamLineRating.Rating))>
			</cfif>
		</cfif>
	
		
		<cfquery datasource="psp_psp" name="UpdLineRating">
		UPDATE  LineRating
		SET ADJRATING = #adjRat#
		WHERE opp = '#Getopp.opp#'
		AND Team = '#GetTeams.Team#'
		AND week = #GetOpp.week#
		AND OFFDEF='D'
		</cfquery>	
	
	
	</cfloop>
	
	
</cfloop>	
	
	
	
	
	
	
	
	<cfquery datasource="psp_psp" name="GetGames">
		SELECT FAV,UND from nflspds where week = #GetWeek.Week + 1#
	</cfquery>
	
<cfloop query="GetGames">	
	
	
	<cfquery datasource="psp_psp" name="GetFAVOffRunRat">
		SELECT AVG(RunRating) as RunRat from LineRating
		where Team = '#GetGames.Fav#'
		and OffDef = 'O'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndOffRunRat">
		SELECT AVG(RunRating) as RunRat from LineRating
		where Team = '#GetGames.Und#'
		and OffDef = 'O'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetFAVDefRunRat">
		SELECT AVG(RunRating) as RunRat from LineRating
		where Team = '#GetGames.Fav#'
		and OffDef = 'D'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndDefRunRat">
		SELECT AVG(RunRating) as RunRat from LineRating
		where Team = '#GetGames.Und#'
		and OffDef = 'D'
	</cfquery>
	
	<cfset FavPredRunRat = (GetFAVOffRunRat.RunRat + GetUndDefRunRat.RunRat)/2>
	<cfset UndPredRunRat = (GetUndOffRunRat.RunRat + GetFavDefRunRat.RunRat)/2>
	
	
	
	
	
	
	<cfquery datasource="psp_psp" name="GetFAVOffPassRat">
		SELECT AVG(PassRating) as PassRat from LineRating
		where Team = '#GetGames.Fav#'
		and OffDef = 'O'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndOffPassRat">
		SELECT AVG(PassRating) as PassRat from LineRating
		where Team = '#GetGames.Und#'
		and OffDef = 'O'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetFAVDefPassRat">
		SELECT AVG(PassRating) as PassRat from LineRating
		where Team = '#GetGames.Fav#'
		and OffDef = 'D'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndDefPassRat">
		SELECT AVG(PassRating) as PassRat from LineRating
		where Team = '#GetGames.Und#'
		and OffDef = 'D'
	</cfquery>
	
	<cfset FavPredPassRat = (GetFAVOffPassRat.PassRat + GetUndDefPassRat.PassRat)/2>
	<cfset UndPredPassRat = (GetUndOffPassRat.PassRat + GetFavDefPassRat.PassRat)/2>
	
	<cfset FavPredTotal = FavPredRunRat + FavPredPassRat>
	<cfset UndPredTotal = UndPredRunRat + UndPredPassRat>
	
	
	
	<cfquery datasource="psp_psp" name="GetFAVOffBigRun">
		SELECT AVG(BigPlayRun) as RunRat from LineRating
		where Team = '#GetGames.Fav#'
		and OffDef = 'O'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndOffBigRun">
		SELECT AVG(BigPlayRun) as RunRat from LineRating
		where Team = '#GetGames.Und#'
		and OffDef = 'O'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetFAVDefBigRun">
		SELECT AVG(BigPlayRun) as RunRat from LineRating
		where Team = '#GetGames.Fav#'
		and OffDef = 'D'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndDefBigRun">
		SELECT AVG(BigPlayRun) as RunRat from LineRating
		where Team = '#GetGames.Und#'
		and OffDef = 'D'
	</cfquery>
	
	<cfset FavPredBigRunRat = (GetFAVOffBigRun.RunRat + GetUndDefBigRun.RunRat)/2>
	<cfset UndPredBigRunRat = (GetUndOffBigRun.RunRat + GetFavDefBigRun.RunRat)/2>
	
	
	<cfquery datasource="psp_psp" name="GetFAVOffBigPass">
		SELECT AVG(BigPlayPass) as PassRat from LineRating
		where Team = '#GetGames.Fav#'
		and OffDef = 'O'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndOffBigPass">
		SELECT AVG(BigPlayPass) as PassRat from LineRating
		where Team = '#GetGames.Und#'
		and OffDef = 'O'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetFAVDefBigPass">
		SELECT AVG(BigPlayPass) as PassRat from LineRating
		where Team = '#GetGames.Fav#'
		and OffDef = 'D'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndDefBigPass">
		SELECT AVG(BigPlayPass) as PassRat from LineRating
		where Team = '#GetGames.Und#'
		and OffDef = 'D'
	</cfquery>
	
	<cfset FavPredBigPassRat = (GetFAVOffBigPass.PassRat + GetUndDefBigPass.PassRat)/2>
	<cfset UndPredBigPassRat = (GetUndOffBigPass.PassRat + GetFavDefBigPass.PassRat)/2>
	
	<cfset FavPredBigTotal = (FavPredBigPassRat + FavPredBigRunRat)>
	<cfset UndPredBigTotal = (UndPredBigPassRat + UndPredBigRunRat)>
	
	
	<cfif 1 is 2>
	<cfquery datasource="psp_psp" name="GetFAVOff3rdLong">
		SELECT AVG(ThrdLngFor) as Rat from LineDominationStats
		where Team = '#GetGames.Fav#'
		
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndOff3rdLong">
		SELECT AVG(ThrdLngFor) as Rat from LineDominationStats
		where Team = '#GetGames.Und#'
		
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetFAVDef3rdLong">
		SELECT AVG(ThrdLngAgst) as Rat from LineDominationStats
		where Team = '#GetGames.Fav#'
		
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUNDDef3rdLong">
		SELECT AVG(ThrdLngAgst) as Rat from LineDominationStats
		where Team = '#GetGames.Und#'
		
	</cfquery>
	
	<cfset FavPredThrdLongRat = (GetFAVOff3rdLong.Rat + GetUNDDef3rdLong.Rat)/2>
	<cfset UndPredThrdLongRat = (GetUNDOff3rdLong.Rat + GetFAVDef3rdLong.Rat)/2>
	
	
	
	<cfquery datasource="psp_psp" name="GetFAVOff3rdLong">
		SELECT AVG(WinRate3LPFor) as Rat from LineDominationStats
		where Team = '#GetGames.Fav#'
		
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndOff3rdLong">
		SELECT AVG(WinRate3LPFor) as Rat from LineDominationStats
		where Team = '#GetGames.Und#'
		
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetFAVDef3rdLong">
		SELECT AVG(WinRate3LPAgst) as Rat from LineDominationStats
		where Team = '#GetGames.Fav#'
		
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUNDDef3rdLong">
		SELECT AVG(WinRate3LPAgst) as Rat from LineDominationStats
		where Team = '#GetGames.Und#'
		
	</cfquery>
	
	<cfset FavPredThrdLongWRat = (GetFAVOff3rdLong.Rat + (100 - GetUNDDef3rdLong.Rat)) / 2>
	<cfset UndPredThrdLongWRat = (GetUNDOff3rdLong.Rat + (100 - GetFAVDef3rdLong.Rat)) / 2>
	</cfif>
	
	<cfquery datasource="psp_psp" name="GetFavAdjLR">
		SELECT AVG(o.AdjRating) - AVG(d.AdjRating) as Rat 
		from LineRating o, LineRating d
		where o.Team = '#GetGames.Fav#'
		and o.Team = d.Team
		and o.OffDef='O'
		and d.OffDef='D'
	</cfquery>
	
	
	<cfquery datasource="psp_psp" name="GetUndAdjLR">
		SELECT AVG(o.AdjRating) - AVG(d.AdjRating) as Rat 
		from LineRating o, LineRating d
		where o.Team = '#GetGames.Und#'
		and o.Team = d.Team
		and o.OffDef='O'
		and d.OffDef='D'
	</cfquery>
	
	
	<cfquery datasource="psp_psp" name="GetFavRZ">
		SELECT BTA as Rat 
		from PBPRating
		where Team = '#GetGames.Fav#'
		and Category = 'RedzoneOverall'
	</cfquery>
	
	<cfquery datasource="psp_psp" name="GetUndRZ">
		SELECT BTA as Rat 
		from PBPRating
		where Team = '#GetGames.Und#'
		and Category = 'RedzoneOverall'
	</cfquery>
	
	
	
	
	<cfoutput>
	<table width="80%" border="1">
	<tr>
	<td>Team</td>
	<td>Adj Trenches</td>
	<td>Redzone</td>
	<td>Expected Run</td>
	<td>Expected Pass</td>
	<td>Expected Total</td>
	<td>Expected Big Run</td>
	<td>Expected Big Pass</td>
	<td>Expected Big Total</td>
	
	</tr>
	
	<tr>
	<td>#GetGames.Fav#</td>
	<td>#GetFavAdjLR.Rat#</td>
	<td>#GetFavRZ.Rat#</td>
	<td>#FavPredRunRat#</td>
	<td>#FavPredPassRat#</td>
	<td>#FavPredTotal#</td>
	<td>#FavPredBigRunRat#</td>
	<td>#FavPredBigPassRat#</td>
	<td>#FavPredBigTotal#</td>
	
	</tr>
	<tr>
	<td>#GetGames.Und#</td>
	<td>#GetUndAdjLR.Rat#</td>
	<td>#GetUndRZ.Rat#</td>
	<td>#UndPredRunRat#</td>
	<td>#UndPredPassRat#</td>
	<td>#UndPredTotal#</td>
	<td>#UndPredBigRunRat#</td>
	<td>#UndPredBigPassRat#</td>
	<td>#UndPredBigTotal#</td>
	
	</tr>
	</table>
	<p>
	</cfoutput>
</cfloop>	

	
	
<p>
Offensive Trenches Adjusted For Opponent<br>	
<cfquery datasource="psp_psp" name="getavg15">
Select team,avg(o.AdjRating) as rating
from linerating o
where o.offdef='O'
group by team
order by avg(o.AdjRating) desc
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getavg15">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>


	<cfset loopct = 0>
	<cfoutput query="GetAvg15">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','AdjOffense',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
		</cfquery>
	</cfoutput>





<p>
Defenses Trenches Adjusted For Opponent<br>	
<cfquery datasource="psp_psp" name="getavg15">
Select team,avg(o.AdjRating) as rating
from linerating o
where o.offdef='D'
group by team
order by avg(o.AdjRating) 
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getavg15">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>



<p>
Overall Trenches Adjusted For Opponent<br>	
<cfquery datasource="psp_psp" name="getavg15">
Select o.team,avg(o.AdjRating) - avg(d.AdjRating)  as rating
from linerating o, linerating d
where o.offdef='O'
and d.OffDef='D'
and o.Team = d.Team
group by o.team
order by avg(o.AdjRating) - avg(d.AdjRating) desc
</cfquery>



<cfset ct = 0>
<table align="center" bgcolor="yellow" border='1'>
<cfoutput query="getavg15">
<cfset ct = ct + 1>
<tr>
<td>#ct#</td>
<td>#team#</td>
<td>#rating#</td>
</tr>
</cfoutput>
</table>





	<cfset loopct = 0>
	<cfoutput query="GetAvg15">
		<cfset loopct = loopct + 1>
		<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','AdjDefense',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
		</cfquery>
	</cfoutput>


	
<cfquery datasource="psp_psp" name="getavg15">
Select o.team,o.BTA + d.BTA as rating
from PbPrating o, PbPrating d
where O.CATEGORY='AdjOffense'
AND d.CATEGORY='AdjDefense'
and o.Team = d.Team
order by o.BTA + d.BTA desc 
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','OverallTrenches',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	



<p>
Pass Pressure/Pass Protection

<cfquery datasource="psp_psp" name="getavg15">
Select o.team,o.SackPct - d.dSackPct as rating
from BetterThanAvg o, BetterThanAvg d
where o.Team = d.Team
order by o.SackPct - d.dSackPct desc 
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','OverallPressure',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	











<p>
Run Win Pct

<cfquery datasource="psp_psp" name="getavg15">
Select o.team,AVG(o.RunWinPct) as Rating   
from LineRating o
where o.OffDef = 'O'
group by o.Team
order by AVG(o.RunWinPct) desc

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','RunWinPct',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	





<p>
Pass Win Pct

<cfquery datasource="psp_psp" name="getavg15">
Select o.team, AVG(o.PassWinPct) as Rating  
from LineRating o
where o.OffDef = 'O'
group by o.Team
order by AVG(o.PassWinPct) desc

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','PassWinPct',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	






<p>
Def Run Win Pct

<cfquery datasource="psp_psp" name="getavg15">
Select d.team,AVG(d.RunWinPct) as Rating  
from LineRating d
where d.OffDef = 'D'
group by d.Team
order by AVG(d.RunWinPct) desc
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','DefRunWinPct',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	





<p>
Def Pass Win Pct

<cfquery datasource="psp_psp" name="getavg15">
Select d.team, AVG(d.PassWinPct) as Rating  
from LineRating d
where d.OffDef = 'D'
group by d.Team
order by AVG(d.PassWinPct) desc
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','DefPassWinPct',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	




<p>
Overall Offense Win Pct

<cfquery datasource="psp_psp" name="getavg15">
Select o.team,(AVG(o.RunWinPct) + AVG(o.PassWinPct))/2 as Rating   
from LineRating o
where o.OffDef = 'O'
group by o.Team
order by (AVG(o.RunWinPct) + AVG(o.PassWinPct))/2 desc

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','OverallOffenseWinPct',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	



<p>
Overall Defense Win Pct

<cfquery datasource="psp_psp" name="getavg15">
Select d.team,(AVG(d.RunWinPct) + AVG(d.PassWinPct))/2 as Rating   
from LineRating d
where d.OffDef = 'D'
group by d.Team
order by (AVG(d.RunWinPct) + AVG(d.PassWinPct))/2 desc

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','OverallDefenseWinPct',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	





<p>
Overall Line Win Rate Pct

<cfquery datasource="psp_psp" name="getavg15">
Select o.team,(AVG(d.RunWinPct) + AVG(d.PassWinPct) + AVG(o.RunWinPct) + AVG(o.PassWinPct)    )/4 as Rating   
from LineRating o, LineRating d
where o.Team = d.Team
group by o.Team
order by (AVG(d.RunWinPct) + AVG(d.PassWinPct) + AVG(o.RunWinPct) + AVG(o.PassWinPct)    )/4 desc

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','OverallLineWinPct',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	




<p>
Adjusted Points Scored

<cfquery datasource="psp_psp" name="getavg15">
Select o.team,AVG(o.ps) as Rating   
from AdjustedGameStats o
group by o.Team
order by AVG(o.PS) desc
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','AdjustedPS',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	

<p>
Adjusted Defense Points Scored

<cfquery datasource="psp_psp" name="getavg15">
Select o.team,AVG(o.dps) as Rating   
from AdjustedGameStats o
group by o.Team
order by AVG(o.dPS) 
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','AdjustedDPS',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	



<p>
Adjusted Overall Points Diff

<cfquery datasource="psp_psp" name="getavg15">
Select o.team, AVG(o.ps) - AVG(o.dps) as Rating   
from AdjustedGameStats o
group by o.Team
order by AVG(o.ps) - AVG(o.dps) desc
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#GetAvg15.Team#','AdjustedPtsDifferential',#GetAvg15.Rating#,#loopct#,#GetAvg15.Rating#)
	</cfquery>

</cfoutput>	





<cfset loopct = 0>	
<cfoutput query="getit18">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#Getit18.Team#','OverallYPPADJ',#Getit18.Rating#,#loopct#,#Getit18.Rating#)
	</cfquery>

</cfoutput>	


<cfset loopct = 0>	
<cfoutput query="getit19">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#Getit19.Team#','OffYPPADJ',#Getit19.Rating#,#loopct#,#Getit19.Rating#)
	</cfquery>

</cfoutput>	


<cfset loopct = 0>	
<cfoutput query="getit20">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#Getit20.Team#','DefYPPADJ',#Getit20.Rating#,#loopct#,#Getit20.Rating#)
	</cfquery>

</cfoutput>	


<p>
OverallDefense

<cfquery datasource="psp_psp" name="getavg15">
Select r.team, r.BTA as Rating  
from pbpRating r
where Category = 'OverallDefense'
order by r.BTA desc

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		UPDATE PBPRating
		SET Ranking = #loopct#
		WHERE Team = '#GetAvg15.Team#'
		AND Category='OverallDefense'
	</cfquery>
</cfoutput>	




<cfquery datasource="psp_psp" name="getavg15">
Select o.team, o.BTA as Rating  
from pbpRating o
where Category = 'AdjYPPBTADEF'
order by o.BTA 

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		UPDATE PBPRating
		SET Ranking = #loopct#
		WHERE Team = '#GetAvg15.Team#'
		AND Category='AdjYPPBTADEF'
	</cfquery>
</cfoutput>	



AdjYPPBTAOFF

<cfquery datasource="psp_psp" name="getavg15">
Select o.team, o.BTA as Rating  
from pbpRating o
where Category = 'AdjYPPBTAOFF'
order by o.BTA desc

</cfquery>






<cfquery datasource="psp_psp" name="getit20">
Select o.team, o.BTA - d.BTA as Rating
from pbpRating o, pbpRating d
where o.Category = 'AdjYPPBTAOFF'
and d.Category = 'AdjYPPBTADEF'
and o.Team = d.Team
order by o.BTA - d.BTA desc
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getit20">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Cat_Value,Ranking,BTA) VALUES ('#Getit20.Team#','AdjOverallYPP',#Getit20.Rating#,#loopct#,#Getit20.Rating#)
	</cfquery>
</cfoutput>	



<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		UPDATE PBPRating
		SET Ranking = #loopct#
		WHERE Team = '#GetAvg15.Team#'
		AND Category='AdjYPPBTAOFF'
	</cfquery>
</cfoutput>	



AdjGainOFF
<cfquery datasource="psp_psp" name="getavg15">
Select o.team, o.BTA as Rating  
from pbpRating o
where Category = 'AdjGainOFF'
order by o.BTA desc

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		UPDATE PBPRating
		SET Ranking = #loopct#
		WHERE Team = '#GetAvg15.Team#'
		AND Category='AdjGainOFF'
	</cfquery>
</cfoutput>	



AdjGainDEF
<cfquery datasource="psp_psp" name="getavg15">
Select o.team, o.BTA as Rating  
from pbpRating o
where Category = 'AdjGainDEF'
order by o.BTA desc

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		UPDATE PBPRating
		SET Ranking = #loopct#
		WHERE Team = '#GetAvg15.Team#'
		AND Category='AdjGainDEF'
	</cfquery>
</cfoutput>	



OverallOffense
<cfquery datasource="psp_psp" name="getavg15">
Select o.team, o.BTA as Rating  
from pbpRating o
where Category = 'OverallOffense'
order by o.BTA desc

</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	<cfquery datasource="psp_psp" name="AddIt">
		UPDATE PBPRating
		SET Ranking = #loopct#
		WHERE Team = '#GetAvg15.Team#'
		AND Category='OverallOffense'
	</cfquery>
</cfoutput>	




<p>
Efficiency
<p>
<cfquery datasource="psp_psp" name="getavg15">
Select o.team, 100*(avg(o.ps)/avg(o.yards)) as OffEff, 100*(avg(o.dps)/avg(o.dyards)) as DefEff, 100*((avg(o.ps)/avg(o.yards)) - (avg(o.dps)/avg(o.dyards))) as Rating   
from sysstats o
group by o.Team
order by 100*((avg(o.ps)/avg(o.yards)) - (avg(o.dps)/avg(o.dyards))) desc 
</cfquery>

<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	'#Getavg15.Team#'...#loopct#....#offeff#...#defeff#...#Rating#<br>
	
	<cfif 1 is 1>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Ranking,Cat_Value) VALUES ('#Getavg15.Team#','OverallEfficiency',#loopct#,#Getavg15.rating#)
	</cfquery>
	</cfif>
</cfoutput>	

<p>
OverallRating
<p>
<cfquery datasource="psp_psp" name="getavg15">
Select o.team, avg(o.Ranking) as Rating  
from pbpRating o
where o.category in ('AdjustedPtsDifferential','AdjOverallYPP','OverallCombinedBigPlayPassRun','OverallYPPAdj','OverallPressure','Redzone','OverallEfficiency')
group by o.Team
order by avg(o.Ranking) 
</cfquery>


<cfset loopct = 0>	
<cfoutput query="getAvg15">	
<cfset loopct = loopct + 1>
	'#Getavg15.Team#'...#loopct#....#rating#<br>
	<cfquery datasource="psp_psp" name="AddIt">
		INSERT INTO PBPRating(Team,Category,Ranking,Cat_Value) VALUES ('#Getavg15.Team#','AvgOfAllRankings',#loopct#,#Getavg15.rating#)
	</cfquery>
	
</cfoutput>	



	
</body>
</html>
