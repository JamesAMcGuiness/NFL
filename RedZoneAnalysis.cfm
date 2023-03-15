
<cfquery datasource="sysstats3" name="Gametime">
	Select w.week as week
	from week w
</cfquery>		

<cfset theweek=#Gametime.week#>


<cfquery datasource="sysstats3" name="MatchupRat">
	Delete from MatchUps where week = #theweek# and StatType in('RedzoneRat','RedzoneRatOff','RedzoneDef')
</cfquery>

<cfif 1 is 2>

<cfquery datasource="sysstats3" name="GetIt">
Select Id, id - 1 as priorplayid, fieldposition, Team, yards, playdesc, playtype
from PlayByPlayData
Where Team = '#theteam#'
and week = #theweek#
and RedZone_Flag = 'Y'
and OffDef='O'
and PlayType <> ''
and playtype not in ('KICKOFF','EXTRAPOINTGOOD','FGAMISS','NOPLAY','FGAMAKE','EXTRAPOINTNOGOOD','')
order by Id desc
</cfquery>

<cfset myids = Valuelist(Getit.priorplayid)>


<cfdump var="#getit#">
<cfdump var="#myids#">



Ids of
<cfquery datasource="sysstats3" name="GetIt2">
Select Id, Team, fieldposition, yards, playdesc, playtype
from PlayByPlayData
Where Id IN (#myids#)
and RedZone_Flag = 'N'
</cfquery>

<cfdump var="#getit2#">


Start of each Redzone Drive
<cfquery datasource="sysstats3" name="GetIt3">
Select Id + 1 as theId, Team, fieldposition, yards, playdesc, playtype
from PlayByPlayData
Where Id IN (#myids#)
and RedZone_Flag = 'N'
order by 1
</cfquery>

<cfdump var="#getit3#">



Now loop thru and get all records starting with Id in GetIt3, and ending with first row where Redzone_flag = 'N'
Check for results of all these rows to see what happened in the drive.
<cfoutput query="GetIt3">

	<p>	
	For Redzone PlayId of #GetIt3.theId#<br>



	<cfquery datasource="sysstats3" name="GetIt4">
	Select MIN(Id) - 1 as FirstId
	from PlayByPlayData
	Where Id > #GetIt3.theId#
	and RedZone_Flag = 'N'
	and Team = '#theteam#'
	and week = #theweek#
	and OffDef='O'
	</cfquery>


	
	<cfdump var="#getit4#">


	<cfquery datasource="sysstats3" name="GetIt5">
	Select PlayType
	from PlayByPlayData
	Where Id >= #GetIt3.theId# and Id <= #GetIt4.FirstId# 
	
	and Team = '#theteam#'
	and week = #theweek#
	and OffDef='O'
	</cfquery>
	
	
	<cfdump var="#getit5#">

	

</cfoutput>





</cfif>













<cfquery datasource="sysstats3" name="GetTeams">
Select Team from teams
</cfquery>

<cfloop query="GetTeams">

<cfset theTeam = '#getteams.TEAM#'>


<cfquery datasource="sysstats3" name="GetIt">
Select Id, Team, yards, playdesc, playtype
from PlayByPlayData
Where Team = '#theteam#'
and RedZone_Flag = 'Y'
and OffDef='O'
and PlayType <> ''
and PlayType in ('RUN','PASS','INTERCEPTION','SACK')
order by Id 
</cfquery>


<cfquery dbtype="Query" name="totyds">
Select SUM(Yards) as totyds
from GetIt
Where PlayType in ('RUN','PASS','INTERCEPTION','SACK')
</cfquery>


<cfquery dbtype="Query" name="CountPlays">
Select Count(*) as totplays
from GetIt
Where PlayType in ('RUN','PASS','INTERCEPTION','SACK')
</cfquery>

<cfquery dbtype="Query" name="CountTDs">
Select Count(*) 
from GetIt
Where PlayDesc like '%touchdown%'
</cfquery>

<cfquery dbtype="Query" name="CountFGAMake">
Select Count(*) 
from GetIt
Where PlayType = 'FGAMAKE'
</cfquery>


<cfquery dbtype="Query" name="INTS">
Select Count(*) 
from GetIt
Where PlayType = 'INTERCEPTION'
</cfquery>

<cfset TDPts  = 6*CountTDs.recordcount>
<cfset FGPts  = 3*CountFGAMake.recordcount>
<cfset INTPts = -3*INTS.recordcount>
<cfset TotPts = TDPTS + FGPts + INTPts>

<cfset TotPts = TDPTS>



<cfset RZEffic = 100*(CountTDs.recordcount/CountPlays.totplays)>


<cfset Ydsperplay = TotYds.totyds / CountPlays.totplays>

<cfif 1 is 2>
<cfdump var='#Getit#'>
<cfdump var='#CountPlays#'>
<cfdump var='#CountTDs#'>
<cfdump var='#CountFGAMake#'>
<cfdump var='#INTS#'>
</cfif>


<cfquery datasource="sysstats3" name="GetRz">
Select AVG(SuccRtRz) as stat
from PBPSuccessRates
Where Team = '#theteam#'
and OffDef='O'
</cfquery>


<cfquery datasource="sysstats3" name="GetRzD">
Select AVG(SuccRtRz) as stat
from PBPSuccessRates
Where Team = '#theteam#'
and OffDef='D'
</cfquery>



<cfoutput>Redzone Efficieny fro #theteam#: #GetRz.Stat#</cfoutput>


<p>


<cfquery datasource="sysstats3" name="MatchupRat">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('RedzoneRatOff','RedzoneRatOff','#theTeam#',#theweek#,#GetRz.Stat#)
</cfquery>


<cfquery datasource="sysstats3" name="MatchupRat">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('RedzoneRatDef','RedzoneRatDef','#theTeam#',#theweek#,#GetRzD.Stat#)
</cfquery>



</cfloop>