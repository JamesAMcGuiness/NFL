
<cfquery datasource="sysstats3" name="GetFirstDownPlays">
UPDATE pbpTendencies
SET ignoreplay = 'N'
WHERE ignoreplay is null
</cfquery>


<cfquery datasource="sysstats3" name="addit">
	Delete from btaPBPSuccessRates
</cfquery>	

<cfquery datasource="sysstats3" name="GetWeek">
Select week as theweek from Week
</cfquery>

<cfset theweek = #GetWeek.theweek# - 1>

<cfquery datasource="sysstats3" name="GetGames">
Select * from NFLSPDS
where week = #theweek#
</cfquery>


<cfquery datasource="sysstats3" name="Addit">
	Delete from PBPGameProjections where week = #theweek + 1#
</cfquery>

<cfquery datasource="sysstats3" name="Addit">
DELETE FROM PBPSuccessRates
Where week = #theweek#
</cfquery>


<cfloop query="GetGames">

<cfloop index="x" from="1" to="2">
<cfif x is 1>
	<cfset theteam = '#GetGames.Fav#'>
	<cfset theopp = '#GetGames.Und#'>
	<cfset theHa = '#GetGames.ha#'>
<cfelse>
	<cfset theteam = '#GetGames.Und#'>
	<cfset theopp = '#GetGames.Fav#'>
	<cfif GetGames.ha is 'H'>
		<cfset theha = 'A'>
	<cfelse>
		<cfset theha = 'H'>
	</cfif>

</cfif>	

<cfquery datasource="sysstats3" name="GetFirstDownPlays">
Select Team,Yards,PlayType,togo  
from pbpTendencies
Where OffDef = 'O'
AND Down     in (1,2)
and togo     <= 15
and fieldPos      <> 5
and Team = '#theteam#'
and PlayType <> 'FGA'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset PassCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset Explosive = 0>

<cfloop query = "GetFirstDownPlays">

	<cfif Yards gte 10>
		<cfset Explosive = Explosive + 1>
	</cfif>

	<cfif PlayType is 'Pass'>
		<cfset PassCt = PassCt + 1>
	</cfif>	

	<cfif PlayType is 'Run'>
		<cfset RunCt = RunCt + 1>
	</cfif>	

	<cfif Yards gte (.40* togo)>
		<cfset Success = Success + 1>
	<cfelse>
		<cfset Fail = Fail + 1>
	</cfif>


</cfloop>

<cfif GetFirstDownPlays.Recordcount is 0>
<cfoutput>
Can not find data for week = #theweek# for team #theopp#
</cfoutput>
<cfabort>
</cfif>

<cfquery datasource="sysstats3" name="Addit">
INSERT INTO PBPSuccessRates(Ha,Opp,Team,Week,SuccRt1and2down,BigPlay1And2Down,OffDef) values('#theha#','#theopp#','#theteam#',#theweek#,#Success/GetFirstDownPlays.recordcount#,#Explosive/GetFirstDownPlays.recordcount#,'O')
</cfquery>

<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'O'
AND Down     in (1,2,3,4)
and fieldPos      = 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset PassCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 

<cfloop query = "GetPlays">
<cfif PlayType neq 'FGA'>
	<cfif PlayType is 'Pass'>
		<cfset PassCt = PassCt + 1>
	</cfif>	

	<cfif PlayType is 'Run'>
		<cfset RunCt = RunCt + 1>
	</cfif>	

	<cfif Yards gte (.40* togo)>
		<cfset Success = Success + 1>
	<cfelse>
		<cfset Fail = Fail + 1>
	</cfif>
</cfif>
	<cfset totpts     = totpts + #pts# >

</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET SuccRtRZ = 0,
RZPtsPerPlay = 0,
RZPlaysPerGame = 0,
SackRt3rdAndLong = 0
where Team = '#theteam#'
and Week = #theweek#
</cfquery>


<cfif GetPlays.recordcount gt 0>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET SuccRtRZ = #Success/GetPlays.recordcount#,
RZPtsPerPlay = #totpts/GetPlays.recordcount#,
RZPlaysPerGame = #GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
and week = #theweek#
</cfquery>
</cfif>


<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'O'
AND Down     in (3)
and togo     <= 15
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset PassCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">

	<cfset totToGo = totToGo + #togo#>

	<cfif PlayType is 'Pass'>
		<cfset PassCt = PassCt + 1>
	</cfif>	

	<cfif PlayType is 'Run'>
		<cfset RunCt = RunCt + 1>
	</cfif>	

	<cfif Yards gte togo>
		<cfset Success = Success + 1>
	<cfelse>
		<cfset Fail = Fail + 1>
	</cfif>

	<cfset totpts     = totpts + #pts# >

</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET SuccRt3rdDown = #Success/GetPlays.recordcount#,
AvgToGo3rdDown = #totToGo/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
and week = #theweek#
</cfquery>



<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'O'
AND Down     in (3)
and togo     >= 6
and fieldPos <> 5
and Team = '#theteam#'
and OffDef = 'O'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset SackCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif PlayType is 'Sack'>
		<cfset SackCt = SackCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET SackRt3rdAndLong = #SackCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
</cfquery>


<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'O'
AND Down     in (3)
and togo     >= 6
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset IntCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif PlayType is 'Interception'>
		<cfset IntCt = IntCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET IntRt3rdAndLong = #IntCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
</cfquery>



<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'O'
AND Down     in (2,3)
and togo     >= 6
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset IntCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif PlayType is 'Interception'>
		<cfset IntCt = IntCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET IntRt2ndAnd3rdDown = (#IntCt#/#GetPlays.recordcount#)
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
</cfquery>


<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'O'
AND Down     in (3)
and togo     >= 6
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset BadCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif PlayType is 'Interception' or PlayType is 'Sack' or Yards is 0>
		<cfset BadCt = BadCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BadResult3rdAndLongPass = #BadCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
</cfquery>


<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'O'
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif Yards gte 10>
		<cfset BigCt = BigCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BigPlayRt = #BigCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
</cfquery>



<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'O'
and fieldPos <> 5
and Team = '#theteam#'
and playtype = 'Pass'
and Togo > 3
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif Yards gte 10>
		<cfset BigCt = BigCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BigPlayPassRt = #BigCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
</cfquery>






















<cfquery datasource="sysstats3" name="GetTeams">
Select Distinct Team 
from pbpTendencies
</cfquery>


<cfquery datasource="sysstats3" name="GetFirstDownPlays">
Select Team,Yards,PlayType,togo  
from pbpTendencies
Where OffDef = 'O'
AND Down     in (1,2)
and togo     <= 15
and fieldPos      <> 5
and Team = '#theteam#'
and PlayType <> 'FGA'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset PassCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset Explosive = 0>

<cfloop query = "GetFirstDownPlays">

	<cfif Yards gte 10>
		<cfset Explosive = Explosive + 1>
	</cfif>

	<cfif PlayType is 'Pass'>
		<cfset PassCt = PassCt + 1>
	</cfif>	

	<cfif PlayType is 'Run'>
		<cfset RunCt = RunCt + 1>
	</cfif>	

	<cfif Yards gte (.40* togo)>
		<cfset Success = Success + 1>
	<cfelse>
		<cfset Fail = Fail + 1>
	</cfif>


</cfloop>


<cfquery datasource="sysstats3" name="GetFirstDownPlays">
Select Team,Yards,PlayType,togo  
from pbpTendencies
Where OffDef = 'D'
AND Down     in (1,2)
and togo     <= 15
and fieldPos      <> 5
and Team = '#theteam#'
and PlayType <> 'FGA'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset PassCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset Explosive = 0>

<cfloop query = "GetFirstDownPlays">

	<cfif Yards gte 10>
		<cfset Explosive = Explosive + 1>
	</cfif>

	<cfif PlayType is 'Pass'>
		<cfset PassCt = PassCt + 1>
	</cfif>	

	<cfif PlayType is 'Run'>
		<cfset RunCt = RunCt + 1>
	</cfif>	

	<cfif Yards gte (.40* togo)>
		<cfset Success = Success + 1>
	<cfelse>
		<cfset Fail = Fail + 1>
	</cfif>


</cfloop>

<cfquery datasource="sysstats3" name="Addit">
INSERT INTO PBPSuccessRates(Ha,Opp,Team,Week,SuccRt1and2down,BigPlay1And2Down,OffDef) values('#theha#','#theopp#','#theteam#',#theweek#,#Success/GetFirstDownPlays.recordcount#,#Explosive/GetFirstDownPlays.recordcount#,'D')
</cfquery>




<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
AND Down     in (1,2,3,4)
and fieldPos      = 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset PassCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 

<cfloop query = "GetPlays">
<cfif PlayType neq 'FGA'>
	<cfif PlayType is 'Pass'>
		<cfset PassCt = PassCt + 1>
	</cfif>	

	<cfif PlayType is 'Run'>
		<cfset RunCt = RunCt + 1>
	</cfif>	

	<cfif Yards gte (.40* togo)>
		<cfset Success = Success + 1>
	<cfelse>
		<cfset Fail = Fail + 1>
	</cfif>
</cfif>
	<cfset totpts     = totpts + #pts# >

</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET SuccRtRZ = 0,
RZPtsPerPlay = 0,
RZPlaysPerGame = 0
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
and week = #theweek#
</cfquery>



<cfif GetPlays.recordcount gt 0>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET SuccRtRZ = #Success/GetPlays.recordcount#,
RZPtsPerPlay = #totpts/GetPlays.recordcount#,
RZPlaysPerGame = #GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>

</cfif>


<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
AND Down     in (3)
and togo     <= 15
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset PassCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">

	<cfset totToGo = totToGo + #togo#>

	<cfif PlayType is 'Pass'>
		<cfset PassCt = PassCt + 1>
	</cfif>	

	<cfif PlayType is 'Run'>
		<cfset RunCt = RunCt + 1>
	</cfif>	

	<cfif Yards gte togo>
		<cfset Success = Success + 1>
	<cfelse>
		<cfset Fail = Fail + 1>
	</cfif>

	<cfset totpts     = totpts + #pts# >

</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET SuccRt3rdDown = #Success/GetPlays.recordcount#,
AvgToGo3rdDown = #totToGo/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>













<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
AND Down     in (3)
and togo     >= 6
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset SackCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif PlayType is 'Sack'>
		<cfset SackCt = SackCt + 1>
	</cfif>	
</cfloop>


<cfif GetPlays.recordcount gt 0>



<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET SackRt3rdAndLong = #SackCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>
</cfif>


<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
AND Down     in (3)
and togo     >= 6
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset IntCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif PlayType is 'Interception'>
		<cfset IntCt = IntCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET IntRt3rdAndLong = #IntCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>




<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
AND Down     in (2,3)
and togo     >= 6
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset IntCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif PlayType is 'Interception'>
		<cfset IntCt = IntCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET IntRt2ndAnd3rdDown = (#IntCt#/#GetPlays.recordcount#)
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>











<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
AND Down     in (3)
and togo     >= 6
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset BadCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif PlayType is 'Interception' or PlayType is 'Sack' or Yards is 0>
		<cfset BadCt = BadCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BadResult3rdAndLongPass = #BadCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>


<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
and fieldPos <> 5
and Team = '#theteam#'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif Yards gte 10>
		<cfset BigCt = BigCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BigPlayRt = #BigCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
and week = #theweek#
</cfquery>









<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
and fieldPos <> 5
and Team = '#theteam#'
and playtype = 'Pass'
and Togo > 3
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif Yards gte 10>
		<cfset BigCt = BigCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BigPlayPassRt = #BigCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>

















<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
and fieldPos <> 5
and Team = '#theteam#'
and playtype = 'Pass'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif Yards gte 10>
		<cfset BigCt = BigCt + 1>
	</cfif>	
</cfloop>


<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BigPlayRt = #BigCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>




<cfquery datasource="sysstats3" name="GetPlays">
Select Team,Yards,PlayType,togo,pts  
from pbpTendencies
Where OffDef = 'D'
and fieldPos <> 5
and Team = '#theteam#'
and playtype = 'Pass'
and week = #theweek#
and ignoreplay <> 'Y'
</cfquery>

<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetPlays">
	<cfif Yards gte 10>
		<cfset BigCt = BigCt + 1>
	</cfif>	
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BigPlayPassRt = #BigCt/GetPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>







<cfquery datasource="sysstats3" name="GetRunPlays">
Select Team,Yards,togo,PlayType  
from pbpTendencies
Where OffDef = 'O'
and Team = '#theteam#'
and playtype = 'Run'
and week = #theweek#
and ignoreplay <> 'Y'
and Down in (1,2)
</cfquery>


<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetRunPlays">
	<cfif Yards gte 10>
		<cfset BigCt = BigCt + 1>
	</cfif>	


<cfif Yards gte (.40* togo)>
		<cfset Success = Success + 1>
<cfelse>
		<cfset Fail = Fail + 1>
</cfif>

</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BigPlayRunRt = #BigCt/GetRunPlays.recordcount#,
RunSuccessRt = #Success/GetRunPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
</cfquery>


<cfquery datasource="sysstats3" name="GetRunPlays">
Select Team,Yards,togo,PlayType  
from pbpTendencies
Where OffDef = 'O'
and Team = '#theteam#'
and playtype = 'Run'
and week = #theweek#
and ignoreplay <> 'Y'
and Down in (3,4)
</cfquery>


<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetRunPlays">

	<cfif Yards gte togo>
		<cfset Success = Success + 1>
	<cfelse>
		<cfset Fail = Fail + 1>
	</cfif>
</cfloop>

<cfif GetRunPlays.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET ShortRunSuccessRt = #Success/GetRunPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'O'
</cfquery>
</cfif>













<cfquery datasource="sysstats3" name="GetRunPlays">
Select Team,Yards,togo,PlayType  
from pbpTendencies
Where OffDef = 'D'
and Team = '#theteam#'
and playtype = 'Run'
and week = #theweek#
and ignoreplay <> 'Y'
and Down in (1,2)
</cfquery>


<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetRunPlays">
	<cfif Yards gte 10>
		<cfset BigCt = BigCt + 1>
	</cfif>	

	<cfif Yards gte (.40* togo)>
		<cfset Success = Success + 1>
	<cfelse>
		<cfset Fail = Fail + 1>
	</cfif>
</cfloop>

<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET BigPlayRunRt = #BigCt/GetRunPlays.recordcount#,
RunSuccessRt = #Success/GetRunPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>


<cfquery datasource="sysstats3" name="GetRunPlays">
Select Team,Yards,togo,PlayType  
from pbpTendencies
Where OffDef = 'D'
and Team = '#theteam#'
and playtype = 'Run'
and week = #theweek#
and ignoreplay <> 'Y'
and Down in (3,4)
</cfquery>


<cfset BigCt  = 0>
<cfset RunCt   = 0>
<cfset Success = 0>
<cfset Fail    = 0>
<cfset totpts     = 0> 
<cfset totToGo    = 0>

<cfloop query = "GetRunPlays">
<cfif Yards gte togo>
		<cfset Success = Success + 1>
<cfelse>
		<cfset Fail = Fail + 1>
</cfif>

</cfloop>

<cfif GetRunPlays.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET ShortRunSuccessRt = #Success/GetRunPlays.recordcount#
where Team = '#theteam#'
and Week = #theweek#
and OffDef = 'D'
</cfquery>
</cfif>


</cfloop>

</cfloop>


<cfquery datasource="sysstats3" name="Addit">
UPDATE PBPSuccessRates
SET OverallSuccRt = (SuccRt1and2down + SuccRt3rdDown)/2
where Week = #theweek#
</cfquery>




<cfset theweek = theweek + 1>


<cfquery datasource="sysstats3" name="GetGames">
Select * from NFLSPDS
where week = #theweek# - 1
</cfquery>

<cfloop query="GetGames">


	<cfset theteam = '#GetGames.Fav#'>
	<cfset theopp = '#GetGames.Und#'>
	<cfset theHa = '#GetGames.ha#'>

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
	
	<cfoutput>
	OFFENSE...<br>
	<table width="70%" border="1">
	<tr>
	<td>Team</td>
	<td>Success Rt</td>
	<td>SkRt3rdLong</td>
	<td>Success Rt 1st and 2nd</td>
	<td>Big Play Rt</td>
	<td>Success Rt 3rd Down</td>
	<td>RZ Pts Per Play</td>
	<td>Rz Plays Per Game</td>
	<td>RZ Success Rt</td>
	<td>Int Rt 3rd and Long</td>
	<td>Int Rt 2nd/3rd and Long</td>	
	<td>Bad Result Rt 3rd and Long</td>
	<td>Big Play 1st/2nd Down</td>
	<td>Avg To Go</td>
	<td>Big Play Pass Rt</td>
	</tr>
	
	
	<tr>
	<td>#theTeam#</td>
	<td>#GetFavOff.overall#</td>
	<td>#GetFavOff.sk3rdlong#</td>
	<td>#GetFavOff.Suc1stAnd2nd#</td>
	<td>#GetFavOff.BigPlay#</td>
	<td>#GetFavOff.Succ3rddown#</td>
	<td>#GetFavOff.RZPPP#</td>
	<td>#GetFavOff.RZPPG#</td>
	<td>#GetFavOff.RZSuccRt#</td>
	<td>#GetFavOff.Irt3rdLong#</td>
	<td>#GetFavOff.IRt2nd3rd#</td>	
	<td>#GetFavOff.BadRes#</td>
	<td>#GetFavOff.BP1st2nd#</td>
	<td>#GetFavOff.ATogo#</td>
	<td>#GetFavOff.BPPass#</td>
	</tr>
	
	
	<tr>
	<td>#theopp#</td>
	<td>#GetUndOff.overall#</td>
	<td>#GetUndOff.sk3rdlong#</td>
	<td>#GetUndOff.Suc1stAnd2nd#</td>
	<td>#GetUndOff.BigPlay#</td>
	<td>#GetUndOff.Succ3rddown#</td>
	<td>#GetUndOff.RZPPP#</td>
	<td>#GetUndOff.RZPPG#</td>
	<td>#GetUndOff.RZSuccRt#</td>
	<td>#GetUndOff.Irt3rdLong#</td>
	<td>#GetUndOff.IRt2nd3rd#</td>	
	<td>#GetUndOff.BadRes#</td>
	<td>#GetUndOff.BP1st2nd#</td>
	<td>#GetUndOff.ATogo#</td>
	<td>#GetUndOff.BPPass#</td>
	</tr>	
	</cfoutput>

<p>
<cfoutput>
************************************************************************************************************************<br>
Defense....
<p>
	<table width="70%" border="1">
	<tr>
	<td>Team</td>
	<td>Success Rt</td>
	<td>SkRt3rdLong</td>
	<td>Success Rt 1st and 2nd</td>
	<td>Big Play Rt</td>
	<td>Success Rt 3rd Down</td>
	<td>RZ Pts Per Play</td>
	<td>Rz Plays Per Game</td>
	<td>RZ Success Rt</td>
	<td>Int Rt 3rd and Long</td>
	<td>Int Rt 2nd/3rd and Long</td>	
	<td>Bad Result Rt 3rd and Long</td>
	<td>Big Play 1st/2nd Down</td>
	<td>Avg To Go</td>
	<td>Big Play Pass Rt</td>
	</tr>
	
	
	<tr>
	<td>#theTeam#</td>
	<td>#GetFavDef.overall#</td>
	<td>#GetFavDef.sk3rdlong#</td>
	<td>#GetFavDef.Suc1stAnd2nd#</td>
	<td>#GetFavDef.BigPlay#</td>
	<td>#GetFavDef.Succ3rddown#</td>
	<td>#GetFavDef.RZPPP#</td>
	<td>#GetFavDef.RZPPG#</td>
	<td>#GetFavDef.RZSuccRt#</td>
	<td>#GetFavDef.Irt3rdLong#</td>
	<td>#GetFavDef.IRt2nd3rd#</td>	
	<td>#GetFavDef.BadRes#</td>
	<td>#GetFavDef.BP1st2nd#</td>
	<td>#GetFavDef.ATogo#</td>
	<td>#GetFavDef.BPPass#</td>
	</tr>
	
	
	<tr>
	<td>#theopp#</td>
	<td>#GetUndDef.overall#</td>
	<td>#GetUndDef.sk3rdlong#</td>
	<td>#GetUndDef.Suc1stAnd2nd#</td>
	<td>#GetUndDef.BigPlay#</td>
	<td>#GetUndDef.Succ3rddown#</td>
	<td>#GetUndDef.RZPPP#</td>
	<td>#GetUndDef.RZPPG#</td>
	<td>#GetUndDef.RZSuccRt#</td>
	<td>#GetUndDef.Irt3rdLong#</td>
	<td>#GetUndDef.IRt2nd3rd#</td>	
	<td>#GetUndDef.BadRes#</td>
	<td>#GetUndDef.BP1st2nd#</td>
	<td>#GetUndDef.ATogo#</td>
	<td>#GetUndDef.BPPass#</td>
	</tr>	
	</cfoutput>
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
	<td align="center">Int Thrown %<br> 3rd & Long</td>
	<td>Int Thrown %<br> 2nd/3rd & Long</td>
	<cfif 1 is 2>
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
	RedZonePlaysPerGame
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
	#Numberformat(((GetUndDef.RZPPG + GetFavOff.RZPPG)/2),'99.99')#

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
	RedZonePlaysPerGame
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
	#Numberformat(((GetFavDef.RZPPG + GetUndOff.RZPPG)/2),'99.99')#
	
	
	)
	</cfquery>



	
</cfloop>






<cfquery datasource="sysstats3" name="GetOAvgs">
Select AVG(SuccRt1and2down) as aSuccRt1and2down,
AVG(SuccRtRZ) as aSuccRtRZ,
AVG(BigPlay1And2Down) as aBigPlay1And2Down,
AVG(RZPtsPerPlay) as aRZPtsPerPlay,
AVG(RZPlaysPerGame) as aRZPlaysPerGame,
AVG(SuccRt3rdDown) as aSuccRt3rdDown,
AVG(AvgToGo3rdDown) as aAvgToGo3rdDown,
AVG(SackRt3rdAndLong) as aSackRt3rdAndLong,
AVG(IntRt3rdAndLong) as aIntRt3rdAndLong,
AVG(IntRt2ndAnd3rdDown) as aIntRt2ndAnd3rdDown,
AVG(BadResult3rdAndLongPass) as aBadResult3rdAndLongPass,
AVG(BigPlayRt) as aBigPlayRt,
AVG(BigPlayPassRt) as aBigPlayPassRt,
AVG(OverallSuccRt) as aOverallSuccRt
from PbPSuccessRates
where OffDef='O'
</cfquery>

<cfquery datasource="sysstats3" name="GetDAvgs">
Select 
AVG(SuccRt1and2down) as aSuccRt1and2down,
AVG(SuccRtRZ) as aSuccRtRZ,
AVG(BigPlay1And2Down) as aBigPlay1And2Down,
AVG(RZPtsPerPlay) as aRZPtsPerPlay,
AVG(RZPlaysPerGame) as aRZPlaysPerGame,
AVG(SuccRt3rdDown) as aSuccRt3rdDown,
AVG(AvgToGo3rdDown) as aAvgToGo3rdDown,
AVG(SackRt3rdAndLong) as aSackRt3rdAndLong,
AVG(IntRt3rdAndLong) as aIntRt3rdAndLong,
AVG(IntRt2ndAnd3rdDown) as aIntRt2ndAnd3rdDown,
AVG(BadResult3rdAndLongPass) as aBadResult3rdAndLongPass,
AVG(BigPlayRt) as aBigPlayRt,
AVG(BigPlayPassRt) as aBigPlayPassRt,
AVG(OverallSuccRt) as aOverallSuccRt
from PbPSuccessRates
where OffDef='D'
</cfquery>


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
AVG(SackRt3rdAndLong) as aSackRt3rdAndLong,
AVG(IntRt3rdAndLong) as aIntRt3rdAndLong,
AVG(IntRt2ndAnd3rdDown) as aIntRt2ndAnd3rdDown,
AVG(BadResult3rdAndLongPass) as aBadResult3rdAndLongPass,
AVG(BigPlayRt) as aBigPlayRt,
AVG(BigPlayPassRt) as aBigPlayPassRt,
AVG(OverallSuccRt) as aOverallSuccRt
	from PBPSuccessRates
	where Team = '#GetTeams.Team#'
	and Offdef = 'O'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetTeamStatsD">
	Select 	AVG(SuccRt1and2down) as aSuccRt1and2down,
AVG(SuccRtRZ) as aSuccRtRZ,
AVG(BigPlay1And2Down) as aBigPlay1And2Down,
AVG(RZPtsPerPlay) as aRZPtsPerPlay,
AVG(RZPlaysPerGame) as aRZPlaysPerGame,
AVG(SuccRt3rdDown) as aSuccRt3rdDown,
AVG(AvgToGo3rdDown) as aAvgToGo3rdDown,
AVG(SackRt3rdAndLong) as aSackRt3rdAndLong,
AVG(IntRt3rdAndLong) as aIntRt3rdAndLong,
AVG(IntRt2ndAnd3rdDown) as aIntRt2ndAnd3rdDown,
AVG(BadResult3rdAndLongPass) as aBadResult3rdAndLongPass,
AVG(BigPlayRt) as aBigPlayRt,
AVG(BigPlayPassRt) as aBigPlayPassRt,
AVG(OverallSuccRt) as aOverallSuccRt
	from PBPSuccessRates
	where Team = '#GetTeams.Team#'
	and Offdef = 'D'
	</cfquery>

	
		<cfset v1 = (GetTeamStatsO.aSuccRt1and2down - GetOAvgs.aSuccRt1and2down) / GetOAvgs.aSuccRt1and2down>
		<cfset v2 = 0> 
		
		<cfif 1 is 2>
		(GetTeamStatsO.aSuccRtRZ - GetOAvgs.aSuccRtRZ) / GetOAvgs.aSuccRtRZ>
		</cfif>
		
		<cfset v3 = (GetTeamStatsO.aBigPlay1And2Down - GetOAvgs.aBigPlay1And2Down) / GetOAvgs.aBigPlay1And2Down>
		<cfset v4 = 0>
		
		<cfif 1 is 2>
		(GetTeamStatsO.aRZPtsPerPlay - GetOAvgs.aRZPtsPerPlay) / GetOAvgs.aRZPtsPerPlay>
		</cfif>
		
		<cfset v5 = 0> 
		
		<cfif 1 is 2>
		(GetTeamStatsO.aRZPlaysPerGame - GetOAvgs.aRZPlaysPerGame) / GetOAvgs.aRZPlaysPerGame>
		</cfif>
		
		<cfset v6 = (GetTeamStatsO.aSuccRt3rdDown - GetOAvgs.aSuccRt3rdDown) / GetOAvgs.aSuccRt3rdDown>
		<cfset v7 = (GetTeamStatsO.aAvgToGo3rdDown - GetOAvgs.aAvgToGo3rdDown) / GetOAvgs.aAvgToGo3rdDown>
		<cfset v8 = (GetOAvgs.aSackRt3rdAndLong - GetTeamStatsO.aSackRt3rdAndLong) / GetOAvgs.aSackRt3rdAndLong>
		<cfset v9 = (GetOAvgs.aIntRt3rdAndLong - GetTeamStatsO.aIntRt3rdAndLong) / GetOAvgs.aIntRt3rdAndLong>
		<cfset v10 = (GetOAvgs.aIntRt2ndAnd3rdDown - GetTeamStatsO.aIntRt2ndAnd3rdDown) / GetOAvgs.aIntRt2ndAnd3rdDown>
		<cfset v11 = (GetOAvgs.aBadResult3rdAndLongPass - GetTeamStatsO.aBadResult3rdAndLongPass) / GetOAvgs.aBadResult3rdAndLongPass>
		<cfset v12 = (GetTeamStatsO.aBigPlayRt - GetOAvgs.aBigPlayRt) / GetOAvgs.aBigPlayRt>
		<cfset v13 = (GetTeamStatsO.aBigPlayPassRt - GetOAvgs.aBigPlayPassRt) / GetOAvgs.aBigPlayPassRt>
		<cfset v14 = (GetTeamStatsO.aOverallSuccRt - GetOAvgs.aOverallSuccRt) / GetOAvgs.aOverallSuccRt>
	
		<cfset dv1 = (GetdAvgs.aSuccRt1and2down - GetTeamStatsd.aSuccRt1and2down) / GetdAvgs.aSuccRt1and2down>
		<cfset dv2 = 0>
		
		<cfif 1 is 2>
		(GetdAvgs.aSuccRtRZ - GetTeamStatsd.aSuccRtRZ) / GetdAvgs.aSuccRtRZ>
		</cfif>
		
		<cfset dv3 = (GetdAvgs.aBigPlay1And2Down - GetTeamStatsd.aBigPlay1And2Down) / GetdAvgs.aBigPlay1And2Down>
		<cfset dv4 = 0>
		
		<cfif 1 is 2>
		(GetdAvgs.aRZPtsPerPlay - GetTeamStatsd.aRZPtsPerPlay) / GetdAvgs.aRZPtsPerPlay>
		</cfif>
		
		<cfset dv5 = 0> 
		
		<cfif 1 is 2>
		(GetdAvgs.aRZPlaysPerGame - GetTeamStatsd.aRZPlaysPerGame) / GetdAvgs.aRZPlaysPerGame>
		</cfif>
		
		<cfset dv6 = (GetdAvgs.aSuccRt3rdDown - GetTeamStatsd.aSuccRt3rdDown) / GetdAvgs.aSuccRt3rdDown>
		<cfset dv7 = (GetdAvgs.aAvgToGo3rdDown - GetTeamStatsd.aAvgToGo3rdDown) / GetdAvgs.aAvgToGo3rdDown>
	 	<cfset dv8 = (GetTeamStatsd.aSackRt3rdAndLong - GetdAvgs.aSackRt3rdAndLong) / GetdAvgs.aSackRt3rdAndLong>
		<cfset dv9 = (GetTeamStatsd.aIntRt3rdAndLong - GetdAvgs.aIntRt3rdAndLong) / GetdAvgs.aIntRt3rdAndLong>
		<cfset dv10 = (GetTeamStatsd.aIntRt2ndAnd3rdDown - GetdAvgs.aIntRt2ndAnd3rdDown) / GetdAvgs.aIntRt2ndAnd3rdDown>
		<cfset dv11 = (GetTeamStatsd.aBadResult3rdAndLongPass - GetdAvgs.aBadResult3rdAndLongPass) / GetdAvgs.aBadResult3rdAndLongPass>
		<cfset dv12 = (GetdAvgs.aBigPlayRt - GetTeamStatsd.aBigPlayRt) / GetdAvgs.aBigPlayRt>
		<cfset dv13 = (GetdAvgs.aBigPlayPassRt - GetTeamStatsd.aBigPlayPassRt) / GetdAvgs.aBigPlayPassRt>
		<cfset dv14 = (GetdAvgs.aOverallSuccRt - GetTeamStatsd.aOverallSuccRt) / GetdAvgs.aOverallSuccRt>

	
	
	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO btaPBPSuccessRates(Team,OffDef,SuccRt1and2down,SuccRtRZ,BigPlay1And2Down,RZPtsPerPlay,RZPlaysPerGame,SuccRt3rdDown,AvgToGo3rdDown,SackRt3rdAndLong,
	IntRt3rdAndLong,IntRt2ndAnd3rdDown,BadResult3rdAndLongPass,BigPlayRt,BigPlayPassRt,OverallSuccRt)
	Values('#GetTeams.Team#','O',#v1#,#v2#,#v3#,#v4#,#v5#,#v6#,#v7#,#v8#,#v9#,#v10#,#v11#,#v12#,#v13#,#v14#)
	</cfquery>	
		
		
	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO btaPBPSuccessRates(Team,OffDef,SuccRt1and2down,SuccRtRZ,BigPlay1And2Down,RZPtsPerPlay,RZPlaysPerGame,SuccRt3rdDown,AvgToGo3rdDown,SackRt3rdAndLong,
	IntRt3rdAndLong,IntRt2ndAnd3rdDown,BadResult3rdAndLongPass,BigPlayRt,BigPlayPassRt,OverallSuccRt)
	Values('#GetTeams.Team#','D',#dv1#,#dv2#,#dv3#,#dv4#,#dv5#,#dv6#,#dv7#,#dv8#,#dv9#,#dv10#,#dv11#,#dv12#,#dv13#,#dv14#)
	</cfquery>

	
	
</cfloop>
<cfinclude template="UpdatePBPAdj.cfm">
<cfinclude template="ShowPBPSuccessRate.cfm">


