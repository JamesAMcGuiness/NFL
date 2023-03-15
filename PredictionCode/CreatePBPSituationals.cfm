


<cfquery datasource="psp_psp" name="GetTeams">
Select sum(jimct) as jimct2,week
from
(
SELECT team,week,count(id)/32 as jimct
from  PBPTendencies
where OffDef='O'
and PlayType <> 'Penalty'
group by week,team
order by week
)
group by week
order by week
</cfquery>

<cfoutput query="getteams">
#Getteams.week#....#Getteams.jimct2#<br>
</cfoutput>



<cfinclude template="createBetterThanAvgsNFL.cfm">
<cfinclude template="CreatePassPressure.cfm">



<cfquery datasource="psp_psp" name="GetTeams">
SELECT Distinct Team
from PBPTendencies
</cfquery>

<cfquery datasource="psp_psp" name="GetWeek">
Select week,startingweek 
from week
</cfquery>

<cfset week = GetWeek.week>

<p>
<p>
<p>


Defensively....<p>

<cfoutput query="GetTeams">


<!--- Get 1st down plays   --->
<cfquery datasource="psp_psp" name="GetData">
SELECT Team,PlayType,Yards,togo
from PBPTendencies
Where FieldPos in (1,2,3,4)
AND DOWN in(1,2)
AND TEAM = '#GetTeams.Team#'
AND PlayType <> 'Penalty'
AND OffDef = 'D'
AND WEEK <= #week#
</cfquery>

<cfquery dbtype="query" name="Passing" >
Select Team
from GetData
Where PlayType = 'Pass'
</cfquery>

<cfquery dbtype="query" name="Running" >
Select Team
from GetData
Where PlayType = 'Run'
</cfquery>

<cfquery dbtype="query" name="RunSuccess" >
Select Team
from GetData
Where PlayType = 'Run'
and Yards < 4
</cfquery>

<cfquery dbtype="query" name="PassSuccess" >
Select Team
from GetData
Where PlayType = 'Pass'
and Yards < 5
</cfquery>

<cfquery dbtype="query" name="OverallSuccess" >
Select Team
from GetData
Where Yards <= 3
</cfquery>



<cfset TotalPlays = GetData.Recordcount>
<cfset PassPct    = Passing.Recordcount / TotalPlays>
<cfset RunPct     = Running.Recordcount / TotalPlays>
<cfset RunSuccessRate = RunSuccess.Recordcount/Running.Recordcount >
<cfset PassSuccessRate = PassSuccess.Recordcount/Passing.Recordcount >
<cfset OverallSuccessRate = OverallSuccess.Recordcount/TotalPlays >
<cfset PassEff = 0>
<cfset RunEff  = 0>
<cfset OverallEff = 0>

<cfloop query="GetData">

	<cfset EffRat = Yards/ToGo>

		<cfif PlayType is 'Pass'>
			<cfif EffRat lt .5>
				<cfset PassEff = PassEff + 1>
			<cfelse>
				
			</cfif>
		<cfelse>
		
			<cfif EffRat lt .5>
				<cfset RunEff = RunEff + 1>
			<cfelse>
				
			</cfif>
			
			
		</cfif>
		
		
</cfloop>

<cfset PassEff = PassEff/Passing.Recordcount>
<cfset RunEff  = RunEff/Running.Recordcount>
<cfset OverallEff = PassEff + RunEff>

#Getteams.Team#<br>
Run Rate: #numberformat(RunPct,'999.99')#<br>
Pass Rate: #numberformat(PassPct,'999.99')#<br>
**************************************************************<br>
Run Success Rate: #numberformat(RunSuccessRate,'999.99')#<br>
Pass Success Rate: #numberformat(PassSuccessRate,'999.99')#<br>
Overall Success Rate: #numberformat(OverallSuccessRate,'999.99')#<br>
**************************************************************<br>
Run Efficiency: #numberformat(RunEff,'999.99')#<br>
Pass Efficiency: #numberformat(PassEff,'999.99')#<br>
Overall Defensive Efficiency: #Numberformat(100*OverallEff,'999.99')#<br>
<hr>

</cfoutput>






<hr>





Offensively.....<br>


<cfoutput query="GetTeams">

<cfset PassCt  = 0>
<cfset RunCt   = 0>
<cfset PassPct = 0>
<cfset RunPct  = 0>
<cfset RunSuccessRate  = 0>
<cfset PassSuccessRate = 0>



<!--- Get 1st down plays   --->
<cfquery datasource="psp_psp" name="GetData">
SELECT Team,PlayType,Yards,togo
from PBPTendencies
Where FieldPos in (1,2,3,4)
AND DOWN in(1,2)
AND TEAM = '#GetTeams.Team#'
AND PlayType <> 'Penalty'
AND OffDef = 'O'
AND WEEK <= #week#
</cfquery>

<cfquery dbtype="query" name="Passing" >
Select Team
from GetData
Where PlayType = 'Pass'
</cfquery>

<cfquery dbtype="query" name="Running" >
Select Team
from GetData
Where PlayType = 'Run'
</cfquery>

<cfquery dbtype="query" name="RunSuccess" >
Select Team
from GetData
Where PlayType = 'Run'
and Yards >= 4
</cfquery>

<cfquery dbtype="query" name="PassSuccess" >
Select Team
from GetData
Where PlayType = 'Pass'
and Yards >= 4
</cfquery>

<cfquery dbtype="query" name="OverallSuccess" >
Select Team
from GetData
Where Yards >= 4
</cfquery>


<cfset TotalPlays = GetData.Recordcount>
<cfset PassPct    = Passing.Recordcount / TotalPlays>
<cfset RunPct     = Running.Recordcount / TotalPlays>
<cfset RunSuccessRate = RunSuccess.Recordcount/Running.Recordcount >
<cfset PassSuccessRate = PassSuccess.Recordcount/Passing.Recordcount >
<cfset OverallSuccessRate = OverallSuccess.Recordcount/TotalPlays >
<cfset PassEff = 0>
<cfset RunEff  = 0>
<cfset OverallEff = 0>

<cfloop query="GetData">

	<cfset EffRat = Yards/ToGo>

		<cfif PlayType is 'Pass'>
			<cfif EffRat gt .5>
				<cfset PassEff = PassEff + 1>
			</cfif>
		<cfelse>
		
			<cfif EffRat gt .5>
				<cfset RunEff = RunEff + 1>
			
			</cfif>
			
			
		</cfif>
		
		
</cfloop>

<cfset PassEff = PassEff/Passing.Recordcount>
<cfset RunEff  = RunEff/Running.Recordcount>
<cfset OverallEff = PassEff + RunEff>

#Getteams.Team#<br>
Run Rate: #numberformat(RunPct,'999.99')#<br>
Pass Rate: #numberformat(PassPct,'999.99')#<br>
**************************************************************<br>
Run Success Rate: #numberformat(RunSuccessRate,'999.99')#<br>
Pass Success Rate: #numberformat(PassSuccessRate,'999.99')#<br>
Overall Success Rate: #numberformat(OverallSuccessRate,'999.99')#<br>
**************************************************************<br>
Run Efficiency: #numberformat(RunEff,'999.99')#<br>
Pass Efficiency: #numberformat(PassEff,'999.99')#<br>
Overall Defensive Efficiency: #Numberformat(100*OverallEff,'999.99')#<br>

<hr>

</cfoutput>



<hr>


Overall Defensively 3rd Down....<p>

<cfoutput query="GetTeams">


<!--- Get 1st down plays   --->
<cfquery datasource="psp_psp" name="GetData">
SELECT Team,PlayType,Yards,togo
from PBPTendencies
Where FieldPos in (1,2,3,4)
AND DOWN in(3)
AND TEAM = '#GetTeams.Team#'
AND PlayType <> 'Penalty'
AND OffDef = 'D'
AND WEEK <= #week#
</cfquery>

<cfquery dbtype="query" name="Passing" >
Select Team
from GetData
Where PlayType = 'Pass'
</cfquery>

<cfquery dbtype="query" name="Running" >
Select Team
from GetData
Where PlayType = 'Run'
</cfquery>

<cfquery dbtype="query" name="RunSuccess" >
Select Team
from GetData
Where PlayType = 'Run'
and Yards < togo
</cfquery>

<cfquery dbtype="query" name="PassSuccess" >
Select Team
from GetData
Where PlayType = 'Pass'
and Yards < togo
</cfquery>

<cfquery dbtype="query" name="OverallSuccess" >
Select Team
from GetData
Where Yards < togo
</cfquery>



<cfset TotalPlays = GetData.Recordcount>
<cfset PassPct    = Passing.Recordcount / TotalPlays>
<cfset RunPct     = Running.Recordcount / TotalPlays>
<cfset RunSuccessRate = RunSuccess.Recordcount/Running.Recordcount >
<cfset PassSuccessRate = PassSuccess.Recordcount/Passing.Recordcount >
<cfset OverallSuccessRate = OverallSuccess.Recordcount/TotalPlays >
<cfset PassEff = 0>
<cfset RunEff  = 0>
<cfset OverallEff = 0>

<cfloop query="GetData">

	<cfset EffRat = Yards/ToGo>

		<cfif PlayType is 'Pass'>
			<cfif Yards lt togo>
				<cfset PassEff = PassEff + 1>
			<cfelse>
				
			</cfif>
		<cfelse>
		<cfif PlayType is 'Run'>
			<cfif Yards lt togo>
				<cfset RunEff = RunEff + 1>
			<cfelse>
				
			</cfif>
			
		</cfif>	
		</cfif>
		
		
</cfloop>

<cfset PassEff = PassEff/Passing.Recordcount>
<cfset RunEff  = RunEff/Running.Recordcount>
<cfset OverallEff = PassEff + RunEff>

#Getteams.Team#<br>
Run Rate: #numberformat(RunPct,'999.99')#<br>
Pass Rate: #numberformat(PassPct,'999.99')#<br>
**************************************************************<br>
Run Success Rate: #numberformat(RunSuccessRate,'999.99')#<br>
Pass Success Rate: #numberformat(PassSuccessRate,'999.99')#<br>
Overall Success Rate: #numberformat(OverallSuccessRate,'999.99')#<br>
**************************************************************<br>
Run Efficiency: #numberformat(RunEff,'999.99')#<br>
Pass Efficiency: #numberformat(PassEff,'999.99')#<br>
Overall Defensive Efficiency: #Numberformat(100*OverallEff,'999.99')#<br>
<hr>

</cfoutput>












<hr>


Overall Defensively 3rd Down and LONG....<p>

<cfoutput query="GetTeams">


<!--- Get 1st down plays   --->
<cfquery datasource="psp_psp" name="GetData">
SELECT Team,PlayType,Yards,togo
from PBPTendencies
Where FieldPos in (1,2,3,4)
AND DOWN in(3)
and togo >= 7
AND TEAM = '#GetTeams.Team#'
AND PlayType <> 'Penalty'
AND OffDef = 'D'
AND WEEK <= #week#
</cfquery>

<cfquery dbtype="query" name="Passing" >
Select Team
from GetData
Where PlayType = 'Pass'
</cfquery>

<cfquery dbtype="query" name="Running" >
Select Team
from GetData
Where PlayType = 'Run'
</cfquery>

<cfquery dbtype="query" name="RunSuccess" >
Select Team
from GetData
Where PlayType = 'Run'
and Yards < togo
</cfquery>

<cfquery dbtype="query" name="PassSuccess" >
Select Team
from GetData
Where PlayType = 'Pass'
and Yards < togo
</cfquery>

<cfquery dbtype="query" name="OverallSuccess" >
Select Team
from GetData
Where Yards < togo
</cfquery>



<cfset TotalPlays = GetData.Recordcount>
<cfset PassPct    = Passing.Recordcount / TotalPlays>
<cfset RunPct     = Running.Recordcount / TotalPlays>
<cfset RunSuccessRate =0>
<cfset PassSuccessRate =0>
<cfif Running.Recordcount gt 0>
	<cfset RunSuccessRate = RunSuccess.Recordcount/Running.Recordcount >
</cfif>

<cfif Passing.Recordcount gt 0>
	<cfset PassSuccessRate = PassSuccess.Recordcount/Passing.Recordcount >
</cfif>
<cfset OverallSuccessRate = OverallSuccess.Recordcount/TotalPlays >
<cfset PassEff = 0>
<cfset RunEff  = 0>
<cfset OverallEff = 0>

<cfloop query="GetData">

	<cfset EffRat = Yards/ToGo>

		<cfif PlayType is 'Pass'>
			<cfif Yards lt togo>
				<cfset PassEff = PassEff + 1>
			<cfelse>
				
			</cfif>
		<cfelse>
		<cfif PlayType is 'Run'>
			<cfif Yards lt togo>
				<cfset RunEff = RunEff + 1>
			<cfelse>
				
			</cfif>
			
		</cfif>	
		</cfif>
		
		
</cfloop>

<cfset PassEff = 0>
<cfset RunEff  = 0>
<cfif Passing.Recordcount neq 0>
	<cfset PassEff = PassEff/Passing.Recordcount>
</cfif>

<cfif Running.Recordcount neq 0>
	<cfset RunEff  = RunEff/Running.Recordcount>
</cfif>
<cfset OverallEff = PassEff + RunEff>

#Getteams.Team#<br>
Run Rate: #numberformat(RunPct,'999.99')#<br>
Pass Rate: #numberformat(PassPct,'999.99')#<br>
**************************************************************<br>
Run Success Rate: #numberformat(RunSuccessRate,'999.99')#<br>
Pass Success Rate: #numberformat(PassSuccessRate,'999.99')#<br>
<strong>Overall Success Rate: #numberformat(OverallSuccessRate,'999.99')#</strong><br>
**************************************************************<br>
Run Efficiency: #numberformat(RunEff,'999.99')#<br>
Pass Efficiency: #numberformat(PassEff,'999.99')#<br>
Overall Defensive Efficiency: #Numberformat(100*OverallEff,'999.99')#<br>
<hr>

</cfoutput>












<hr>


Overall Offensively 3rd Down and LONG....<p>

<cfoutput query="GetTeams">


<!--- Get 1st down plays   --->
<cfquery datasource="psp_psp" name="GetData">
SELECT Team,PlayType,Yards,togo
from PBPTendencies
Where FieldPos in (1,2,3,4)
AND DOWN in(3)
and togo >= 7
AND TEAM = '#GetTeams.Team#'
AND PlayType <> 'Penalty'
AND OffDef = 'O'
AND WEEK <= #week#
</cfquery>

<cfquery dbtype="query" name="Passing" >
Select Team
from GetData
Where PlayType = 'Pass'
</cfquery>

<cfquery dbtype="query" name="Running" >
Select Team
from GetData
Where PlayType = 'Run'
</cfquery>

<cfquery dbtype="query" name="RunSuccess" >
Select Team
from GetData
Where PlayType = 'Run'
and Yards >= togo
</cfquery>

<cfquery dbtype="query" name="PassSuccess" >
Select Team
from GetData
Where PlayType = 'Pass'
and Yards >= togo
</cfquery>

<cfquery dbtype="query" name="OverallSuccess" >
Select Team
from GetData
Where Yards >= togo
</cfquery>



<cfset TotalPlays = GetData.Recordcount>
<cfset PassPct    = Passing.Recordcount / TotalPlays>
<cfset RunPct     = Running.Recordcount / TotalPlays>
<cfif Running.Recordcount gt 0>
	<cfset RunSuccessRate = RunSuccess.Recordcount/Running.Recordcount >
</cfif>

<cfif Passing.Recordcount gt 0>
<cfset PassSuccessRate = PassSuccess.Recordcount/Passing.Recordcount >
</cfif>

<cfset OverallSuccessRate = OverallSuccess.Recordcount/TotalPlays >
<cfset PassEff = 0>
<cfset RunEff  = 0>
<cfset OverallEff = 0>

<cfloop query="GetData">

	<cfset EffRat = Yards/ToGo>

		<cfif PlayType is 'Pass'>
			<cfif Yards gte togo>
				<cfset PassEff = PassEff + 1>
			<cfelse>
				
			</cfif>
		<cfelse>
		<cfif PlayType is 'Run'>
			<cfif Yards gte togo>
				<cfset RunEff = RunEff + 1>
			<cfelse>
				
			</cfif>
			
		</cfif>	
		</cfif>
		
		
</cfloop>

<cfif Passing.Recordcount gt 0>
<cfset PassEff = PassEff/Passing.Recordcount>
</cfif>

<cfif Running.Recordcount gt 0>
<cfset RunEff  = RunEff/Running.Recordcount>
</cfif>

<cfset OverallEff = PassEff + RunEff>

#Getteams.Team#<br>
Run Rate: #numberformat(RunPct,'999.99')#<br>
Pass Rate: #numberformat(PassPct,'999.99')#<br>
**************************************************************<br>
Run Success Rate: #numberformat(RunSuccessRate,'999.99')#<br>
Pass Success Rate: #numberformat(PassSuccessRate,'999.99')#<br>
<strong>Overall Success Rate: #numberformat(PassEff,'999.99')#</strong><br>
**************************************************************<br>
Run Efficiency: #numberformat(RunEff,'999.99')#<br>
Pass Efficiency: #numberformat(PassEff,'999.99')#<br>
Overall Offensive Efficiency: #Numberformat(100*OverallEff,'999.99')#<br>
<hr>

</cfoutput>



























<cfquery datasource="NFLSPDS" name="GetTeams">
SELECT Fav, Und
from NFLSPDS
Where week = #week + 1#
</cfquery>

<hr>

Overall Offensively 3rd Down and LONG....<p>

<cfoutput query="GetTeams">


<!--- Get 1st down plays   --->
<cfquery datasource="psp_psp" name="GetData">
SELECT Team,PlayType,Yards,togo
from PBPTendencies
Where FieldPos in (1,2,3,4)
AND (DOWN in(3)
and togo >= 7
or(Down = 2 and togo >= 10)
)
AND TEAM = '#GetTeams.Fav#'
AND OffDef = 'O'

AND WEEK <= #week#
</cfquery>

<!--- Get opponents Passing Strength --->
<cfquery datasource="psp_psp" name="GetOppOff">
SELECT AVG(Pavg)/100 as oppPassPow
from BetterThanAvg
Where Team in (Select Opponent from PBPTendencies where Team = '#GetTeams.Fav#' AND WEEK <= #week#)
</cfquery>

<!--- Get opponents Defensive Passing Strength --->
<cfquery datasource="psp_psp" name="GetOppDef">
SELECT AVG(dPavg)/100 as oppDefPassPow
from BetterThanAvg
Where Team in (Select Distinct Opponent from PBPTendencies where Team = '#GetTeams.Fav#' AND WEEK <= #week#)
</cfquery>

<cfset OppPavg  = GetOppOff.oppPassPow>
<cfset OppdPavg = GetOppDef.oppDefPassPow>


<cfquery dbtype="query" name="Running" >
Select Team
from GetData
Where PlayType IN('Run')
</cfquery>


<cfquery dbtype="query" name="Passing" >
Select Team
from GetData
Where PlayType IN('Pass','Interception','Sack')
</cfquery>

<cfquery dbtype="query" name="PassSuccess" >
Select Team
from GetData
Where (PlayType In('Sack','Interception')
or (PlayType = 'Pass' and Yards = 0))
</cfquery>

<cfset TotalPlays = GetData.Recordcount - Running.recordcount>
<cfset PassPct    = Passing.Recordcount / TotalPlays>
<cfset PassSuccessRate = (PassSuccess.Recordcount/Passing.Recordcount) - oppdPavg >

<cfset PassEff = 0>


#Getteams.Fav#<br>
**************************************************************<br>
Pass Failure Rate: #numberformat(PassSuccessRate,'999.99')#<br>
**************************************************************<br>
<cfquery datasource="psp_psp" name="Addit">
Update PassPressure
SET PressureRate = #numberformat(PassSuccessRate,'999.99')# 
WHERE Team = '#GetTeams.fav#'
and OffDef = 'O'
</cfquery>
<hr>


<!--- Get 1st down plays   --->
<cfquery datasource="psp_psp" name="GetData">
SELECT Team,PlayType,Yards,togo
from PBPTendencies
Where FieldPos in (1,2,3,4)
AND (DOWN in(3)
and togo >= 7
or(Down = 2 and togo >= 10)
)
AND TEAM = '#GetTeams.Und#'
AND OffDef = 'O'
AND WEEK <= #week#
</cfquery>


<cfquery dbtype="query" name="Running" >
Select Team
from GetData
Where PlayType IN('Run')
</cfquery>


<cfquery dbtype="query" name="Passing" >
Select Team
from GetData
Where PlayType IN('Pass','Interception','Sack')
</cfquery>

<cfquery dbtype="query" name="PassSuccess" >
Select Team
from GetData
Where (PlayType In('Sack','Interception')
or (PlayType = 'Pass' and Yards = 0))
</cfquery>


<!--- Get opponents Passing Strength --->
<cfquery datasource="psp_psp" name="GetOppOff">
SELECT AVG(Pavg)/100 as oppPassPow
from BetterThanAvg
Where Team in (Select Distinct Opponent from PBPTendencies where Team = '#GetTeams.und#' AND WEEK <= #week#)
</cfquery>

<!--- Get opponents Defensive Passing Strength --->
<cfquery datasource="psp_psp" name="GetOppDef">
SELECT AVG(dPavg)/100 as oppDefPassPow
from BetterThanAvg
Where Team in (Select Distinct Opponent from PBPTendencies where Team = '#GetTeams.und#' AND WEEK <= #week#)
</cfquery>

<cfset OppPavg  = GetOppOff.oppPassPow>
<cfset OppdPavg = GetOppDef.oppDefPassPow>




<cfset TotalPlays = GetData.Recordcount - Running.recordcount>

<cfset PassPct    = Passing.Recordcount / TotalPlays>
<cfset PassSuccessRate = (PassSuccess.Recordcount/Passing.Recordcount) - oppdPavg >

<cfset PassEff = 0>


#Getteams.Und#<br>
**************************************************************<br>
Pass Failure Rate: #numberformat(PassSuccessRate,'999.99')#<br>
**************************************************************<br>

<cfquery datasource="psp_psp" name="Addit">
Update PassPressure
SET PressureRate = #numberformat(PassSuccessRate,'999.99')# 
WHERE Team = '#GetTeams.Und#'
and OffDef = 'O'
</cfquery>


<hr>

</cfoutput>


















<hr>


Overall Defensively 3rd Down and LONG....<p>

<cfoutput query="GetTeams">


<!--- Get 1st down plays   --->
<cfquery datasource="psp_psp" name="GetData">
SELECT Team,PlayType,Yards,togo
from PBPTendencies
Where FieldPos in (1,2,3,4)
AND (DOWN in(3)
and togo >= 7
or(Down = 2 and togo >= 10)
)
AND TEAM = '#GetTeams.Fav#'
AND OffDef = 'D'
AND WEEK <= #week#
</cfquery>

<!--- Get opponents Passing Strength --->
<cfquery datasource="psp_psp" name="GetOppOff">
SELECT AVG(Pavg)/100 as oppPassPow
from BetterThanAvg
Where Team in (Select Distinct Opponent from PBPTendencies where Team = '#GetTeams.Fav#' AND WEEK <= #week#)
</cfquery>

<!--- Get opponents Defensive Passing Strength --->
<cfquery datasource="psp_psp" name="GetOppDef">
SELECT AVG(dPavg)/100 as oppDefPassPow
from BetterThanAvg
Where Team in (Select Distinct Opponent from PBPTendencies where Team = '#GetTeams.Fav#' AND WEEK <= #week#)
</cfquery>

<cfset OppPavg  = GetOppOff.oppPassPow>
<cfset OppdPavg = GetOppDef.oppDefPassPow>



<cfset TotalPlays = GetData.Recordcount>
<cfset PassPct    = Passing.Recordcount / TotalPlays>
<cfset PassSuccessRate = (PassSuccess.Recordcount/Passing.Recordcount) + oppPavg >

<cfset PassEff = 0>


#Getteams.Fav#<br>
**************************************************************<br>
Pass Pressure Success Rate: #numberformat(PassSuccessRate,'999.99')#<br>
**************************************************************<br>

<cfquery datasource="psp_psp" name="Addit">
Update PassPressure
SET PressureRate = #numberformat(PassSuccessRate,'999.99')# 
WHERE Team = '#GetTeams.fav#'
and OffDef = 'D'
</cfquery>


<!--- Get 1st down plays   --->
<cfquery datasource="psp_psp" name="GetData">
SELECT Team,PlayType,Yards,togo
from PBPTendencies
Where FieldPos in (1,2,3,4)
AND (DOWN in(3)
and togo >= 7
or(Down = 2 and togo >= 10)
)
AND TEAM = '#GetTeams.Und#'
AND OffDef = 'D'
AND WEEK <= #week#
</cfquery>

<cfquery dbtype="query" name="Passing" >
Select Team
from GetData
Where PlayType IN('Pass','Interception','Sack')
</cfquery>

<cfquery dbtype="query" name="PassSuccess" >
Select Team
from GetData
Where (PlayType In('Sack','Interception')
or (PlayType = 'Pass' and Yards = 0))
</cfquery>


<!--- Get opponents Passing Strength --->
<cfquery datasource="psp_psp" name="GetOppOff">
SELECT AVG(Pavg)/100 as oppPassPow
from BetterThanAvg
Where Team in (Select Distinct Opponent from PBPTendencies where Team = '#GetTeams.Und#' AND WEEK <= #week#)
</cfquery>

<!--- Get opponents Defensive Passing Strength --->
<cfquery datasource="psp_psp" name="GetOppDef">
SELECT AVG(dPavg)/100 as oppDefPassPow
from BetterThanAvg
Where Team in (Select Distinct Opponent from PBPTendencies where Team = '#GetTeams.Und#' AND WEEK <= #week#)
</cfquery>

<cfset OppPavg  = GetOppOff.oppPassPow>
<cfset OppdPavg = GetOppDef.oppDefPassPow>


<cfset TotalPlays = GetData.Recordcount>
<cfset PassPct    = Passing.Recordcount / TotalPlays>
<cfset PassSuccessRate = (PassSuccess.Recordcount/Passing.Recordcount) + oppPavg >

<cfset PassEff = 0>


#Getteams.Und#<br>
**************************************************************<br>
Pass Pressure Success Rate: #numberformat(PassSuccessRate,'999.99')#<br>
**************************************************************<br>

<cfquery datasource="psp_psp" name="Addit">
Update PassPressure
SET PressureRate = #numberformat(PassSuccessRate,'999.99')# 
WHERE Team = '#GetTeams.Und#'
and OffDef = 'D'
</cfquery>


<hr>

</cfoutput>

<cfinclude template="QBR.cfm">
