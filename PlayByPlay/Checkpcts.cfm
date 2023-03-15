<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<cfquery datasource="psp_psp" name="GetWeek">
Update DriveCharts o
Set Team = 'LAR' 
where Team='STL'
</cfquery>

<cfquery datasource="psp_psp" name="GetWeek">
Update DriveCharts o
Set opp = 'LAR' 
where opp='STL'
</cfquery>


<cfquery datasource="psp_psp" name="GetWeek">
Update DriveCharts o
Set Team = 'LAC' 
where Team='SD'
</cfquery>

<cfquery datasource="psp_psp" name="GetWeek">
Update DriveCharts o
Set opp = 'LAC' 
where opp='SD'
</cfquery>





<cfquery datasource="psp_psp" name="GetWeek">
Select Max(O.DriveNumber) as oadnum, o.Team, o.week 
from DriveCharts o
where o.DriveType='O'
group by o.week,o.team
</cfquery>

<cfquery dbtype='query' name="GetOff">
Select  Avg(oadnum) as adnum, Team
from Getweek
group by team
</cfquery>

<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>

<cfset Session.week = Getweek.week + 1>

<cfquery datasource="psp_psp" name="GetTeams">
	Delete from Dcstats
</cfquery>

<cfquery datasource="sysstats" name="GetTeams">
	Select Distinct Team
	from sysstats s
</cfquery>

<cfloop query="GetTeams">

<cfset team = '#GetTeams.Team#'>

<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and week < #Session.week#	
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result='Touchdown'
	and week < #Session.week#	
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result in('End of Half','End of Game')
	and week < #Session.week#	
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffTDPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>



--------------------------------------------------------------------------------
FG



<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and week < #Session.week#		
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result='Field Goal'
	and week < #Session.week#	
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result in('End of Half','End of Game')
	and week < #Session.week#	
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffFGPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>

----------------------------------------------------------------------------------------------
INTS
<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and week < #Session.week#		
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result='Interception'
	and week < #Session.week#		
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result in('End of Half','End of Game')
	and week < #Session.week#		
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffIntsPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>

------------------------------------------------------------------------------------------------------------
Punt
<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and week < #Session.week#		
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result='Punt'
	and week < #Session.week#		
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result in('End of Half','End of Game')
	and week < #Session.week#		
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffPuntPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>

------------------------------------------------------------------------------------------------------------
Fumbles
<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and week < #Session.week#		
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result='Fumble'
	and week < #Session.week#		
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'O'
	and Result in('End of Half','End of Game')
	and week < #Session.week#		
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffFumPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>

<cfset td   = #OffTDPct#*100>
<cfset fg   = #offFGPct#*100>
<cfset intc = #OffIntsPct#*100>
<cfset fum  = #OffFumPct#*100>
<cfset punt = #OffPuntPct#*100>

<cfquery name="addem" datasource="psp_psp" >
Insert into DCStats
( 
Team,
OffDef,
TDpct,
FGpct,
INTpct,
FUMpct,
TDPOW,
FGPow,
PuntPct)
Values
(
'#Team#',
'O',
#td#,
#fg#,
#intc#,
#fum#,
0,
0,
#punt#
)
</cfquery>



------------------------------ Defense ---------------------------------------------------



<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and week < #Session.week#		
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result='Touchdown'
	and week < #Session.week#		
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result in('End of Half','End of Game')
	and week < #Session.week#		
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffTDPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>



--------------------------------------------------------------------------------
FG



<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and week < #Session.week#		
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result='Field Goal'
	and week < #Session.week#		
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result in('End of Half','End of Game')
	and week < #Session.week#		
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffFGPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>

----------------------------------------------------------------------------------------------
INTS
<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and week < #Session.week#		
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result='Interception'
	and week < #Session.week#		
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result in('End of Half','End of Game')
	and week < #Session.week#		
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffIntsPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>

------------------------------------------------------------------------------------------------------------
Punt
<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and week < #Session.week#		
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result='Punt'
	and week < #Session.week#		
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result in('End of Half','End of Game')
	and week < #Session.week#		
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffPuntPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>

------------------------------------------------------------------------------------------------------------
Fumbles
<cfquery datasource="psp_psp" name="GetOffDrives">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and week < #Session.week#		
</cfquery>
<cfset totDrives = GetOffDrives.Recordcount>

<!-- See how many TD's -->
<cfquery datasource="psp_psp" name="GetTDs">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result='Fumble'
	and week < #Session.week#		
</cfquery>


<cfquery datasource="psp_psp" name="GetSubtract">
	Select *
	from DriveCharts dc
	where Team = '#team#'
	and DriveType = 'D'
	and Result in('End of Half','End of Game')
	and week < #Session.week#		
</cfquery>

<cfset totDrives = totDrives - GetSubtract.Recordcount>

<cfoutput>
<cfset OffFumPct = GetTDs.recordcount/totDrives>
</cfoutput>
<br>


<cfset td   = #OffTDPct#*100>
<cfset fg   = #offFGPct#*100>
<cfset intc = #OffIntsPct#*100>
<cfset fum  = #OffFumPct#*100>
<cfset punt = #OffPuntPct#*100>

<cfquery name="addem" datasource="psp_psp" >
Insert into DCStats
( 
Team,
OffDef,
TDpct,
FGpct,
INTpct,
FUMpct,
TDPOW,
FGPow,
PuntPct)
Values
(
'#Team#',
'D',
#td#,
#fg#,
#intc#,
#fum#,
0,
0,
#Punt#
)
</cfquery>
</cfloop>


<!--- <cfinclude template="UpdateDriveChart.cfm"> --->
<cfinclude template="GAP.cfm">
<!--- <cfinclude template="2004GAPSYS2.cfm">  --->
<!--- <cfinclude template="pbpweighted.cfm"> --->
<!--- <cfinclude template="RatePlays.cfm">
<cfinclude template="ShowDcpicks.cfm"> --->
<cfinclude template="CreateDriveBegEndPcts.cfm">

<!---  <cfinclude template="CreatePuntRetPcts.cfm"> --->

 <!--- <cfinclude template="CreateKickOffPcts.cfm"> --->
 <cfinclude template="CreateRedzonePercents.cfm">
 <!--- <cfinclude template="UpdateHADC.cfm">  --->
<cfquery datasource="psp_psp" name="GetWeek">
Update DataLoadStatus
set step = 'DRIVECHARTLOADDATALOADED'
</cfquery>

</body>
</html>
