<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<cfquery datasource="psp_psp" name="GetWeek">
Select week, startingweek 
from Week
</cfquery>
<cfset Session.week = GetWeek.week>

<cfquery name="get" datasource="psp_psp" >
Delete from GAP
</cfquery>

<cfquery name="get" datasource="psp_psp" >
Delete from DCSOS
</cfquery>


<cfquery name="getoff" datasource="psp_psp" >
Select Team,SUM( (7*TDpct) + (3*FGpct) ) as opow
from DCSTATS
where OffDef = 'O'
Group by Team
Order by SUM( (7*TDpct) + (3*FGpct) ) desc

</cfquery>
<cfset loopct = 0>
<cfoutput query = "Getoff">
<cfset loopct = loopct + 1>
<cfif loopct le 10>
	<cfset gap = 'G'>
</cfif>
<cfif loopct gt 10 and loopct le 20>
	<cfset gap = 'A'>
</cfif>
<cfif loopct gt 20>
	<cfset gap = 'P'>
</cfif>

<cfquery name="getoff" datasource="psp_psp" >
Insert into GAP
(Team,GAP,offdef,rating)
Values
('#team#','#gap#','O',#opow#)
</cfquery>

</cfoutput>
<hr>

<cfquery name="getdef" datasource="psp_psp" >
Select Team,SUM((7*TDpct) + (3*FGpct)) as dpow
from DCSTATS
where OffDef = 'D'
Group by Team
Order by SUM((7*TDpct) + (3*FGpct))

</cfquery>
<cfset loopct = 0>
<cfoutput query = "Getdef">
<cfset loopct = loopct + 1>
<cfif loopct le 10>
	<cfset gap = 'G'>
</cfif>
<cfif loopct gt 10 and loopct le 20>
	<cfset gap = 'A'>
</cfif>
<cfif loopct gt 20>
	<cfset gap = 'P'>
</cfif>

<cfquery name="get" datasource="psp_psp" >
Insert into GAP
(Team,GAP,OffDef,rating)
Values
('#team#','#gap#','D',#dpow#)
</cfquery>

</cfoutput>


<cfquery name="getoto" datasource="psp_psp" >
Select Team,SUM(Intpct + Fumpct) as oto
from DCSTATS
where OffDef = 'O'
Group by Team
Order by SUM(Intpct + Fumpct) 

</cfquery>
<cfset loopct = 0>
<cfoutput query = "Getoto">
<cfset loopct = loopct + 1>
<cfif loopct le 10>
	<cfset gap = 'G'>
</cfif>
<cfif loopct gt 10 and loopct le 20>
	<cfset gap = 'A'>
</cfif>
<cfif loopct gt 20>
	<cfset gap = 'P'>
</cfif>

<cfquery name="get" datasource="psp_psp" >
Insert into GAP
(Team,GAP,OffDef,rating)
Values
('#team#','#gap#','OTO',#oto#)
</cfquery>
</cfoutput>

<cfquery name="getdto" datasource="psp_psp" >
Select Team,SUM(Intpct + Fumpct) as dto
from DCSTATS
where OffDef = 'D'
Group by Team
Order by SUM(Intpct + Fumpct) desc 

</cfquery>
<cfset loopct = 0>
<cfoutput query = "Getdto">
<cfset loopct = loopct + 1>
<cfif loopct le 10>
	<cfset gap = 'G'>
</cfif>
<cfif loopct gt 10 and loopct le 20>
	<cfset gap = 'A'>
</cfif>
<cfif loopct gt 20>
	<cfset gap = 'P'>
</cfif>

<cfquery name="get" datasource="psp_psp" >
Insert into GAP
(Team,GAP,OffDef,rating)
Values
('#team#','#gap#','DTO',#dto#)
</cfquery>
</cfoutput>


<cfset theweek = Session.week > 
<cfloop index="i" from="#Getweek.StartingWeek#" to="#theweek#">


<cfquery name="GetSpds" datasource="nflspds" >
SELECT *
FROM Nflspds
WHERE week = #i#
</cfquery>

<cfloop query="Getspds">
<hr>

<cfset fav = "#Getspds.fav#">
<cfset und = "#GetSpds.und#">
<cfset ha = "#GetSpds.ha#">
<cfset spd = "#GetSpds.spread#">


<cfquery name="getundDrat" datasource="psp_psp" >
Select GAP
From GAP
Where Team = '#und#'
and OffDef = 'D'
</cfquery>

<cfquery name="getFavDrat" datasource="psp_psp" >
Select GAP
From GAP
Where Team = '#fav#'
and OffDef = 'D'
</cfquery>

<cfquery name="getundOrat" datasource="psp_psp" >
Select GAP
From GAP
Where Team = '#und#'
and OffDef = 'O'
</cfquery>

<cfquery name="getFavOrat" datasource="psp_psp" >
Select GAP
From GAP
Where Team = '#fav#'
and OffDef = 'O'
</cfquery>

<cfset FavOSOS = 0>
<cfset FavDSOS = 0>
<cfset UndOSOS = 0>
<cfset UndDSOS = 0>

<cfif getundDrat.Gap is 'G'>
	<cfset FavOSOS = 1>
</cfif>


<cfif getundDrat.Gap is 'A'>
	<cfset FavOSOS = 0>
</cfif>

<cfif getundDrat.Gap is 'P'>
	<cfset FavOSOS = -1>
</cfif>


<cfif getfavDrat.Gap is 'G'>
	<cfset UndOSOS = 1>
</cfif>


<cfif getfavDrat.Gap is 'A'>
	<cfset UndOSOS = 0>
</cfif>

<cfif getfavDrat.Gap is 'P'>
	<cfset UndOSOS = -1>
</cfif>



<cfif getundOrat.Gap is 'G'>
	<cfset FavDSOS = 1>
</cfif>


<cfif getundOrat.Gap is 'A'>
	<cfset FavDSOS = 0>
</cfif>

<cfif getundOrat.Gap is 'P'>
	<cfset FavDSOS = -1>
</cfif>


<cfif getfavOrat.Gap is 'G'>
	<cfset UndDSOS = 1>
</cfif>


<cfif getfavOrat.Gap is 'A'>
	<cfset UndDSOS = 0>
</cfif>

<cfif getfavOrat.Gap is 'P'>
	<cfset UndDSOS = -1>
</cfif>




<cfquery name="Add" datasource="psp_psp" >
Insert into DCSOS
(Team,opp,OSOS,DSOS)
Values
('#fav#','#Und#',#FavOSOS#,#FavDSOS#)
</cfquery>


<cfquery name="Add" datasource="psp_psp" >
Insert into DCSOS
(Team,opp,OSOS,DSOS)
Values
('#und#','#fav#',#UndOSOS#,#UndDSOS#)
</cfquery>

</cfloop>

</cfloop>


<cfquery name="Getit" datasource="psp_psp" >
Select team, sum(oSOS) as otot, sum(dsos) as dtot
from DCSOS
Group by Team
</cfquery>

<cfoutput query="GetIt">
<cfquery name="updit" datasource="psp_psp" >
Update DCSOS
Set OffSOSRat = #Getit.otot#,
DefSOSRat     = #Getit.dtot#,
OverRatedRating = #Getit.otot + Getit.dtot#
Where Team = '#Getit.team#'
</cfquery>

</cfoutput>



<cfquery name="GetSpds" datasource="nflspds" >
SELECT *
FROM Nflspds
WHERE week = #Session.week + 1#
</cfquery>

<cfloop query="Getspds">
<hr>

<cfset fav = "#Getspds.fav#">
<cfset und = "#GetSpds.und#">
<cfset ha = "#GetSpds.ha#">
<cfset spd = "#GetSpds.spread#">



<cfquery name="fav" datasource="psp_psp" >
Select OverRatedRating 
from DCSOS
Where Team = '#fav#'
</cfquery>

<cfquery name="und" datasource="psp_psp" >
Select OverRatedRating 
from DCSOS
Where Team = '#und#'
</cfquery>

<cfoutput>
#Fav#: #fav.OverRatedRating#<br>
#Und#: #Und.OverRatedRating#<br>
<hr>

<cfquery name="Addit" datasource="psp_psp" >
Insert into PSPPicks 
(week,System,Pick,PickRat)
values
(
#session.week + 1#,'SOSRAT','#fav#',#fav.OverRatedRating#
)
</cfquery>


<cfquery name="Addit" datasource="psp_psp" >
Insert into PSPPicks 
(week,System,Pick,PickRat)
values
(
#session.week + 1#,'SOSRAT','#und#',#und.OverRatedRating#
)
</cfquery>



</cfoutput>





</cfloop>
</body>
</html>
