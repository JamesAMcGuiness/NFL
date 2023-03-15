<cfif 1 is 2>

<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>

<cfset week = GetWeek.week + 1>



<cfquery datasource="psp_psp" name="Getgames">
Select *
from nflspds
where week = #week#
</cfquery>


<cfquery datasource="psp_psp" name="delGetPR">
Delete from PowerTbl where week = #week#
</cfquery>

<cfquery datasource="PowerRat2" name="GetPR">
Select * from PowerRat2
Where Week = #week#
</cfquery>

<cfoutput query="GetPr">

<cfquery datasource="psp_psp" name="AddPR">
Insert into PowerTbl
(
Week,
Team,
PowerRatFinal
)
Values
(
#week#,
'#GetPr.Team#',
#GetPr.Rating#
)
</cfquery>

</cfoutput>


<cfquery datasource="psp_psp" name="Addit">
Delete from PSPPicks where SYSTEM = 'POWERRAT2014'
and week = #week#
</cfquery>

<cfset FavHFA = 0>
<cfset UndHFA = 0>
<cfset FavRat = 0>
<cfset UndRat = 0>


<cfoutput query="GetGames">

	<cfset OurPick = 'PASS'>
	<cfset OurRat  = 0>
	<cfset FavHFA = 0>
	<cfset UndHFA = 0>

	<cfquery datasource="psp_psp" name="GetFavInfo">
	Select PowerRatFinal
	from PowerTbl
	where Team = '#GetGames.Fav#'
	and week = #week#
	</cfquery>

	<cfquery datasource="psp_psp" name="GetUndInfo">
	Select PowerRatFinal
	from PowerTbl
	where Team = '#GetGames.Und#'
	and week = #week#
	</cfquery>

	<cfquery datasource="psp_psp" name="GetFAVHFA">
		Select *
		from HomeFieldAdv
		where Team = '#GetGames.Fav#'
	</cfquery>


	<cfquery datasource="psp_psp" name="GetUNDHFA">
		Select *
		from HomeFieldAdv
		where Team = '#GetGames.Und#'
	</cfquery>
	
	<cfif GetFAVHFA.recordcount is 0>	
		<cfset FavHFA = 3>
	<cfelse>
		<cfset FavHFA = GetFavHFA.hfa>
	</cfif>
	

	<cfif GetUNDHFA.recordcount is 0>	
		<cfset UndHFA = 3>
	<cfelse>
		<cfset UndHFA = GetUndHFA.hfa>
	</cfif>
	
	
	<cfif GetGames.HA is 'H'>
		<cfset UNDHFA = 0>
	<cfelse>
		<cfset FAVHFA = 0>
	</cfif>
	
	
	FAV:#GetFavInfo.PowerRatFinal#<br> 
	UND:#GetUndInfo.PowerRatFinal#<br>
	FAVHFA:#FavHFA#<br>
	UNDHFA:#UndHFA#<br>
	
		
	<cfset FavRat = #GetFavInfo.PowerRatFinal# + #FavHFA#>
	<cfset UndRat = #GetUndInfo.PowerRatFinal# + #UndHFA#>
	
	
	<cfset FavPredMOV = FavRat - UndRat>
	
	
	<cfif FavPredMOV gt GetGames.spread>
		<cfset OurPick = GetGames.Fav>
		<cfset OurRat  = FavPredMOV - GetGames.spread>
	</cfif>
	

	<cfif FavPredMOV lt GetGames.spread>
		
		<cfif FavRat lt UndRat>
		
			<cfset OurPick = GetGames.Und>
			<cfset OurRat  = GetGames.spread - FavPredMOV>
		<cfelse>	
			<cfset OurPick = GetGames.Und>
			<cfset OurRat  = GetGames.spread - FavPredMOV>
			
		</cfif>	
			
	</cfif>

	<cfset BestBetFlag = 'N'>
	<cfif OurRat gte 3.0>
		<cfset BestBetFlag = 'Y'>
	</cfif>

	Our pick is #OurPick# for a rating of #OurRat#<br>
	<cfquery datasource="psp_psp" name="Addit">
	Insert into PSPPicks
	(Week,
	System,
	Pick,
	PickRat,
	BestBetFlag
	)
	values
	(
	#week#,
	'POWERRAT2014',
	'#ourpick#',
	#ourRat#,
	'#bestbetflag#'
	)
	</cfquery>
	

</cfoutput>

</cfif>