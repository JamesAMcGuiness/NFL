<cfset Application.dsn = 'sysstats3'>

<cfquery datasource="#Application.dsn#"  name="GetWeek">
	Select Week 
	from Week
</cfquery>

<cfquery datasource="#Application.dsn#"  name="GetGames">
	Select * 
	from nflspds where week = #Getweek.week#
</cfquery>

<cfquery datasource="#Application.dsn#"  name="addGames">
delete from DriveChartLoadData where week = #getweek.week#
</cfquery>

<cfoutput query="GetGames">
	<cfset ht = '#fav#'>
    <cfset awt = '#und#'>

<cfif ha is 'A'>
	<cfset ht = '#trim(und)#'>
    <cfset awt = '#TRIM(fav)#'>
</cfif>	
	

<cfif ht is 'JAX'>
	<cfset ht = 'JAC'>
</cfif>

<cfif ht is 'ARZ'>
	<cfset ht = 'ARI'>
</cfif>

<cfif awt is 'JAX'>
	<cfset awt = 'JAC'>
</cfif>

<cfif awt is 'ARZ'>
	<cfset awt = 'ARI'>
</cfif>


<cfset mystr = 'http://www.cbssports.com/nfl/gametracker/drivecharts/NFL_' & '#gametime#' & TRIM('_#awt#') & trim('@#ht#')>	
	
<cfquery datasource="#Application.dsn#"  name="addGames">
insert into DriveChartLoadData(Hometeam,AwayTeam,Week,URL) values('#ht#','#awt#',#getweek.week#,'#mystr#')
</cfquery>

</cfoutput>
<cfif 1 is 2>
<cfinclude template="LoadDriveChartDataCBSHome.cfm">
</cfif>