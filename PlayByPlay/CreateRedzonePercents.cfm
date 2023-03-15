
<cfquery datasource="psp_psp" name="GetTeams">
Delete from DcRedZone
</cfquery>


<!-- Update the team names with the correct names -->
<cfquery datasource="psp_psp" name="GetTeams">
Select Distinct(Team)
from DriveCharts
</cfquery>

<cfloop query="GetTeams">

	<cfset Team = '#GetTeams.Team#'>


	<cfquery datasource="psp_psp" name="GetRedTries">
	Select DriveCharts.*,80 - val( right(DriveBegan,2)) as longjim, val( right(DriveBegan,2)) - 20 as shortjim
	from DriveCharts
	Where team = '#team#'
	and drivetype = 'O'
	and 
		(
		 (Val(NetYds) >= (80 - val( right(DriveBegan,2)) ) and FP in (1,2)   )
		or
		 (Val(NetYds) >= (80 - val( right(DriveBegan,2)) ) and FP in (3) and Trim(Left(DriveBegan,3)) = Trim(Team))
		
		or
		 (Val(NetYds) >= ( val( right(DriveBegan,2)) - 20 ) and FP in (3) and Trim(Left(DriveBegan,3)) <> Trim(Team))		
		
		or
		(Val(NetYds) >= ( val( right(DriveBegan,2)) - 20 ) and FP in (4,5))
		)
	</cfquery>

<cfset tdct = 0>
<cfset fgct = 0>	
<cfset toct = 0>
<cfset dwnct = 0>
<cfset subtractct = 0>
	
<cfoutput query="GetRedTries">
<cfif #result# is 'Touchdown'>
	<cfset tdct = tdct + 1>
</cfif>
<cfif #result# is 'Field Goal'>
	<cfset fgct = fgct + 1>
</cfif>
<cfif #result# is 'Interception'>
	<cfset toct = toct + 1>
</cfif>
<cfif #result# is 'Fumble'>
	<cfset toct = toct + 1>
</cfif>
<cfif #result# is 'Downs'>
	<cfset dwnct = dwnct + 1>
</cfif>
<cfif #result# is 'End of Game'>
	<cfset subtractct = subtractct + 1>
</cfif>
<cfif #result# is 'End of Half'>
	<cfset subtractct = subtractct + 1>
</cfif>
<cfif #result# is 'Missed FG'>
	<cfset dwnct = dwnct + 1>
</cfif>
</cfoutput>

<cfset mytdpct = (tdct/(GetRedTries.recordcount - subtractct))*100> 
<cfset myfgpct = (fgct/(GetRedTries.recordcount - subtractct))*100> 
<cfset mytopct = ((toct + dwnct)/(GetRedTries.recordcount - subtractct))*100> 

<cfoutput>
#team#...TDPCT:#numberformat(mytdpct,99.9)# FGPCT:#Numberformat(myfgpct,99.9)# TOPCT:#Numberformat(mytopct,99.9)# 
<br>
</cfoutput>

<cfquery datasource="psp_psp" name="GetNumGames">
select distinct week as totgms from drivecharts where team = '#team#'
</cfquery>


<cfquery datasource="psp_psp" name="GetRed">
Insert Into DCRedZone
(Team,
TDPct,
FGPct,
TOPct,
OffDef,
trys)
Values
(
'#Team#',
#numberformat(mytdpct,99.9)#,
#numberformat(myfgpct,99.9)#,
#numberformat(mytopct,99.9)#,
'O',
#GetRedTries.recordcount/GetNumGames.recordcount#
)
</cfquery>


</cfloop>

<hr>



<cfloop query="GetTeams">

	<cfset Team = '#GetTeams.Team#'>

	
	<cfquery datasource="psp_psp" name="GetRedTries">
	Select DriveCharts.*,80 - val( right(DriveBegan,2)) as longjim, val( right(DriveBegan,2)) - 20 as shortjim
	from DriveCharts
	Where team = '#team#'
	and drivetype = 'D'
	and 
		(
		 (Val(NetYds) >= (80 - val( right(DriveBegan,2)) ) and FP in (1,2)   )
		or
		 (Val(NetYds) >= (80 - val( right(DriveBegan,2)) ) and FP in (3) and Trim(Left(DriveBegan,3)) = Trim(Team))
		
		or
		 (Val(NetYds) >= ( val( right(DriveBegan,2)) - 20 ) and FP in (3) and Trim(Left(DriveBegan,3)) <> Trim(Team))		
		
		or
		(Val(NetYds) >= ( val( right(DriveBegan,2)) - 20 ) and FP in (4,5))
		)
	</cfquery>

<cfset tdct = 0>
<cfset fgct = 0>	
<cfset toct = 0>
<cfset dwnct = 0>
<cfset subtractct = 0>
	
<cfoutput query="GetRedTries">
<cfif #result# is 'Touchdown'>
	<cfset tdct = tdct + 1>
</cfif>
<cfif #result# is 'Field Goal'>
	<cfset fgct = fgct + 1>
</cfif>
<cfif #result# is 'Interception'>
	<cfset toct = toct + 1>
</cfif>
<cfif #result# is 'Fumble'>
	<cfset toct = toct + 1>
</cfif>
<cfif #result# is 'Downs'>
	<cfset dwnct = dwnct + 1>
</cfif>
<cfif #result# is 'End of Game'>
	<cfset subtractct = subtractct + 1>
</cfif>
<cfif #result# is 'End of Half'>
	<cfset subtractct = subtractct + 1>
</cfif>
<cfif #result# is 'Missed FG'>
	<cfset dwnct = dwnct + 1>
</cfif>

<!--- id=#id#....Began=#DriveBegan#...Netyds=#NetYds#....Driveend=#DriveEnd#...Result=#Result#<br> --->

</cfoutput>

<cfset mytdpct = (tdct/(GetRedTries.recordcount - subtractct))*100> 
<cfset myfgpct = (fgct/(GetRedTries.recordcount - subtractct))*100> 
<cfset mytopct = ((toct + dwnct)/(GetRedTries.recordcount - subtractct))*100> 

<cfoutput>
#team#...TDPCT:#numberformat(mytdpct,99.9)# FGPCT:#Numberformat(myfgpct,99.9)# TOPCT:#Numberformat(mytopct,99.9)#
<br>
</cfoutput>

<cfquery datasource="psp_psp" name="GetNumGames">
select distinct week as totgms from drivecharts where team = '#team#'
</cfquery>


<cfquery datasource="psp_psp" name="GetRed">
Insert Into DCRedZone
(Team,
TDPct,
FGPct,
TOPct,
OffDef,
trys
)
Values
(
'#Team#',
#numberformat(mytdpct,99.9)#,
#numberformat(myfgpct,99.9)#,
#numberformat(mytopct,99.9)#,
'D',
#GetRedTries.recordcount/GetNumGames.recordcount#
)
</cfquery>


</cfloop>

