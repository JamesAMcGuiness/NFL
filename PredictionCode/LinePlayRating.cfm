<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<cfquery name="bye" datasource="psp_psp" >
UPDATE LineRating
SET SuccessRate = (RunWinPct + PassWinPct)/2
</cfquery>

<html>
<head>
	<title>Untitled</title>
</head>

<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>


<cfset week = GetWeek.week >
<cfset Session.week = week>

<cfquery name="GetFirstGame" datasource="psp_psp">
	SELECT Min(HomeTeam) as useHomeTeam
	FROM DriveChartLoadData
	WHERE week = #Session.week#
	and PBPLoaded = 'C'
</cfquery>

<cfif GetFirstGame.recordcount is 0>
 <cfabort>

<cfelse>
	<cfset usethis = GetFirstGame.useHomeTeam>
	<cfif GetFirstGame.useHomeTeam is 'JAC'>
		<cfset usethis = 'JAX'>
	</cfif>

	<cfif GetFirstGame.useHomeTeam is 'ARI'>
		<cfset usethis = 'ARZ'>
	</cfif>

</cfif>


<cfquery name="GetTeams" datasource="psp_psp" >
Select Distinct StatsFor
from PBPData1
</cfquery>


<cfloop index="ii" from="#session.week#" to="#session.week#"> 
<!--- <cfloop index="ii" from="23" to="23"> --->
<cfset myweek = ii>

<cfquery name="GetSpds" datasource="nflspds" >
SELECT *
FROM nflspds
WHERE week = #myweek#
AND (FAV = '#usethis#' or UND = '#usethis#')  
</cfquery>


<cfquery name="bye" datasource="psp_psp" >
Delete from LineRating WHERE week = #myweek# and Team in ('#GetSpds.fav#','#GetSpds.Und#')
</cfquery>

<cfquery name="bye" datasource="psp_psp" >
Delete from LineDominationStats WHERE week = #myweek#
</cfquery>


<body>



<cfloop query="Getspds">
	
<cfset fav = "#Getspds.fav#">
<cfset und = "#GetSpds.und#">


<cfset uRZPlays = 0>
<cfset fRZPlays = 0>
<cfset uRZRunWinPct  = 0>
<cfset uRZPassWinPct = 0>
<cfset uRZRunRating = 0>
<cfset uRZPassRating = 0>

<cfset fRZRunWinPct  = 0>
<cfset fRZPassWinPct = 0>
<cfset fRZRunRating = 0>
<cfset fRZPassRating = 0>


<cfset uPassWin12 = 0>
<cfset uRunWin12  = 0>
<cfset fPassWin12 = 0>
<cfset fRunWin12  = 0>
<cfset uPassLoss12 = 0>
<cfset uRunLoss12  = 0>
<cfset fPassLoss12 = 0>
<cfset fRunLoss12  = 0>
<CFSET favruntrys12 = 0>
<CFSET undruntrys12 = 0>	
<CFSET favpasstrys12 = 0>
<CFSET undpasstrys12 = 0>	
<cfset frunpts12  = 0>
<cfset urunpts12  = 0>
<cfset frunpts3  = 0>
<cfset urunpts3  = 0>

<cfset fpasspts12  = 0>
<cfset upasspts12  = 0>
<cfset fpasspts3  = 0>
<cfset upasspts3  = 0>


<cfset uPassWin3 = 0>
<cfset uRunWin3  = 0>
<cfset fPassWin3 = 0>
<cfset fRunWin3  = 0>
<cfset uPassLoss3 = 0>
<cfset uRunLoss3  = 0>
<cfset fPassLoss3 = 0>
<cfset fRunLoss3  = 0>
<CFSET favruntrys3 = 0>
<CFSET undruntrys3 = 0>	
<CFSET favpasstrys3 = 0>
<CFSET undpasstrys3 = 0>	

<cfset fBigPlayct = 0>
<cfset uBigPlayct = 0>

<cfset fBigPlayRunct = 0>
<cfset uBigPlayRunct = 0>

<cfset fBigPlayPassct = 0>
<cfset uBigPlayPassct = 0>





<cfquery name="bye" datasource="psp_psp" >
Insert into LineDominationStats(Team,Opp,ha,week) values ('#fav#','#und#','#ha#',#myweek#)
</cfquery>

<cfset myha = 'H'>
<cfif ha is 'H'>
	<cfset myha = 'A'>
</cfif>

<cfquery name="bye" datasource="psp_psp" >
Insert into LineDominationStats(Team,Opp,ha,week) values ('#und#','#fav#','#myha#',#myweek#)
</cfquery>

	
<!-- Get the first down stats for Fav -->
<cfquery datasource="psp_psp" name="GetFav1stdown">
Select *
from pbptendencies 
where Down in (1,2)
and Team = '#trim(fav)#'
and week = #myweek#
and OffDef='O'
and PlayType not in ('Point After','FGA','Penalty')
</cfquery>

<!-- Get the first down stats for Und -->
<cfquery datasource="psp_psp" name="GetUnd1stdown">
Select *
from pbptendencies 
where Down in (1,2)
and Team = '#trim(und)#'
and week = #myweek#
and OffDef = 'O'
and PlayType not in ('Point After','FGA','Penalty')
</cfquery>

<cfset RunPts   = 0>
<cfset PassPts  = 0>
<cfset Favruntrys  = 0>
<cfset FavPasstrys = 0>

<cfloop query="GetFav1stDown">
	<cfoutput>
	***********************************************<br>
	************Playtype is #playtype# for: #fav#<br>
	***********************************************<br>
	</cfoutput>
	<cfif PlayType is 'Run'>


		<cfset Favruntrys12  = Favruntrys12 + 1>
	first down run...<br>
	
		<cfif Yards lt 0 >
			<cfset fRunPts12 = fRunPts12 - 2>
			less than 0!<br>
			<cfset frunloss12 = frunloss12 + 1>
			
		</cfif>
	
		<cfif Yards ge 0 and yards le 2 >
			<cfset fRunPts12 = fRunPts12 - 1>
			<cfset frunloss12 = frunloss12 + 1>
			between 1 and 2<br>
		</cfif>
		
		<cfif Yards is 3 >
			<cfset fRunPts12 = fRunPts12 + 0>
			3 yard gain<br>
			
		</cfif>
	
		<cfif Yards ge 4 and yards le 6 >
			<cfset fRunPts12 = fRunPts12 + 2>
			between 4 and 6<br>
			<cfset frunwin12 = frunwin12 + 1>
		</cfif>

		<cfif Yards ge 7 and yards le 9 >
			<cfset fRunPts12 = fRunPts12 + 4>
			<cfset frunwin12 = frunwin12 + 1>
			between 7 and 9 <br>
		</cfif>
		
		<cfif Yards gt 10>
			<cfset fRunPts12 = fRunPts12 + 6>
			<cfset frunwin12 = frunwin12 + 1>
			<cfset fBigPlayCt = fBigPlayCt + 1>
			<cfset fBigPlayRunCt = fBigPlayRunCt + 1>
			
			grater than 10<br>
		</cfif>

	</cfif>
	
	

	
	<cfif PlayType is 'Pass' or Playtype is 'Sack' or Playtype is 'Interception'>
		first down Pass...<br>
		
		<cfset FavPasstrys12  = FavPasstrys12 + 1>
		
		<cfif Yards lte 0>
		
			<cfif Playtype is 'Sack' or Playtype is 'Interception'>
				<cfset fPassPts12 = fPassPts12 - 8>
				sack or int <br>
			<cfelse>
				<cfset fPassPts12 = fPassPts12 - 3.5>
				incomplete<br>
			</cfif>
				
			<cfset fPassLoss12 = fPassLoss12 + 1>
			
		</cfif>

		<cfif Yards ge 1 and yards le 3>
			between 1 and 3<br>
			<cfset fPassLoss12 = fPassLoss12 + 1>
			<cfset fPassPts12 = fPassPts12 + 0>
		</cfif>

		<cfif Yards ge 4 and yards le 6>
			between 4 and 6<br>
			<cfset fPassWin12 = fPassWin12 + 1>
			<cfset fPassPts12 = fPassPts12 + 2.5>
		</cfif>

		<cfif Yards ge 7 and yards le 10>
			between 7 and 10<br>
			<cfset fPassWin12 = fPassWin12 + 1>			
			<cfset fPassPts12 = fPassPts12 + 4.5>
		</cfif>

		<cfif Yards ge 11 and yards lt 20>
			between 11 and 19<br>
			<cfset fPassWin12 = fPassWin12 + 1>			
			<cfset fPassPts12 = fPassPts12 + 7.5>
		</cfif>
	
		<cfif Yards ge 20 and yards le 30>
			between 20 and 30<br>
			<cfset fPassWin12 = fPassWin12 + 1>			
			<cfset fPassPts12 = fPassPts12 + 12.5>
			<cfset fBigPlayCt = fBigPlayCt + 1>
			<cfset fBigPlayPassCt = fBigPlayPassCt + 1>

		</cfif>

		<cfif Yards ge 31 and yards le 40>
			between 31 and 40<br>
			<cfset fPassWin12 = fPassWin12 + 1>					
			<cfset fPassPts12 = fPassPts12 + 17.5>
			<cfset fBigPlayCt = fBigPlayCt + 1>
			<cfset fBigPlayPassCt = fBigPlayPassCt + 1>

		</cfif>
	
		<cfif Yards gt 40>
			<cfset fPassWin12 = fPassWin12 + 1>		
			greater than 40!<br>
			<cfset fPassPts12 = fPassPts12 + 20>
			<cfset fBigPlayCt = fBigPlayCt + 1>
			<cfset fBigPlayPassCt = fBigPlayPassCt + 1>

		</cfif>

	
	</cfif>
	<br>
</cfloop>	


<cfoutput>
<p>		
<!--- ***************************************************<br>
Offensive RunPts for  #fav# was: #RunPts#<br>
Offensive PassPts for #fav# was: #PassPts#<br>
Run Wins for #fav#: #(Frunwin/Favruntrys)*100#<br>
Pass Wins for #fav# #(FPasswin/Favpasstrys)*100#<br>	
Overall Offense Total: #ftot#<br>	
***************************************************<br>
 --->
</cfoutput>	
<br>
------------------------------------------------------------------------------------------------------------------------------------------------------------------<br>
<p>
<p>


<cfloop query="GetUnd1stDown">
	<cfoutput>
	***********************************************<br>
	************Playtype is #playtype# for: #und#<br>
	***********************************************<br>
	</cfoutput>

	<cfif PlayType is 'Run'>
		Run play...<br>
		<cfset Undruntrys12 = Undruntrys12 + 1>
	
		<cfif Yards lt 0 >
			lt 0 <br>
			<cfset uRunPts12 = uRunPts12 - 2>
			<cfset uRunLoss12 = URunLoss12 + 1>
		</cfif>
	
		<cfif Yards ge 0 and yards le 2 >
			between 1 and 2<br>
			<cfset uRunPts12 = uRunPts12 - 1>
			<cfset uRunLoss12 = URunLoss12 + 1>
		</cfif>
		
		<cfif Yards is 3 >
			3 yrd <br>
			<cfset uRunPts12 = uRunPts12 + 0>
			
		</cfif>
	
		<cfif Yards ge 4 and yards le 6 >
			4 to 6 <br>
			<cfset uRunPts12 = uRunPts12 + 2>
			<cfset uRunWin12 = URunWin12 + 1>
		</cfif>

		<cfif Yards ge 7 and yards le 9 >
			
			7 to 9<br>
			<cfset uRunPts12 = uRunPts12 + 4>
			<cfset uRunWin12 = URunWin12 + 1>
		</cfif>
		
		<cfif Yards ge 10>
			gt 10<br>
			<cfset uRunPts12 = uRunPts12 + 6>
			<cfset uRunWin12 = URunWin12 + 1>
			<cfset uBigPlayCt    = uBigPlayCt + 1>
			<cfset uBigPlayRunCt = uBigPlayRunCt + 1>
		</cfif>

		<cfoutput>
		RUN1-2 so far is: #uRunPts12#<br>
		</cfoutput>


	</cfif>


	<cfoutput>
	<cfif PlayType is 'Pass' or PlayType is 'Interception' or PlayType is 'Sack'>

		pass play....<br>

	
		<cfset UndPasstrys12  = UndPasstrys12 + 1>
	
		<cfif Yards lte 0>
		
			<cfif Playtype is 'Sack' or Playtype is 'Interception'>
				
				sack or int <br>
				<cfset uPassPts12 = uPassPts12 - 8>
			<cfelse>
				incomplete <br>
				<cfset uPassPts12 = uPassPts12 - 3.5>
			</cfif>
			<cfset uPassLoss12 = UPassLoss12 + 1>
		</cfif>

		<cfif Yards ge 1 and yards le 3>
			1 to 3 <br>
			<cfset uPassPts12 = uPassPts12 + 0>
			<cfset uPassLoss12 = UPassLoss12 + 1>
		</cfif>

		<cfif Yards ge 4 and yards le 6>
			4 to 6 <br>
			<cfset uPassPts12 = uPassPts12 + 2.5>
			<cfset uPassWin12 = UPassWin12 + 1>
		</cfif>

		<cfif Yards ge 7 and yards le 10>
			7 to 10 <br>
			<cfset uPassPts12 = uPassPts12 + 4.5>
			<cfset uPassWin12 = UPassWin12 + 1>
		</cfif>

		<cfif Yards ge 11 and yards lt 20>
			11 to 20 <br>
			<cfset uPassPts12 = uPassPts12 + 7.5>
			<cfset uPassWin12 = UPassWin12 + 1>
		</cfif>
	
		<cfif Yards ge 20 and yards le 30>
			21 to 30 <br>
			<cfset uPassPts12 = uPassPts12 + 12.5>
			<cfset uPassWin12 = UPassWin12 + 1>
			<cfset uBigPlayCt    = uBigPlayCt + 1>
			<cfset uBigPlayPassCt = uBigPlayPassCt + 1>

		</cfif>

		<cfif Yards ge 31 and yards le 40>
		31 to 40 <br>
			<cfset uPassPts12 = uPassPts12 + 17.5>
			<cfset uPassWin12 = UPassWin12 + 1>
			<cfset uBigPlayCt    = uBigPlayCt + 1>
			<cfset uBigPlayPassCt = uBigPlayPassCt + 1>

		</cfif>
	
		<cfif Yards gt 40>
			gt 40! <br>
			<cfset uPassPts12 = uPassPts12 + 20>
			<cfset uPassWin12 = UPassWin12 + 1>
			<cfset uBigPlayCt    = uBigPlayCt + 1>
			<cfset uBigPlayPassCt = uBigPlayPassCt + 1>

		</cfif>
	</cfif>
	</cfoutput>
	
	
	
</cfloop>	


<p>	
<cfif FAVruntrys12 gt 0 and FAVpasstrys12 gt 0 and undruntrys12 gt 0 and undpasstrys12 gt 0>
<cfoutput>
**********************************************<br>
Offensive RunPts for  #FAV# was: #FRunPts12#<br>
Offensive PassPts for #FAV# was: #FPassPts12#<br>	
Offensive Total: #FRunPts12 + FPassPts12#<br>	
Run Wins for #FAV#: #(Frunwin12/FAVruntrys12)*100#<br>
Pass Wins for #FAV# #(FPasswin12/FAVpasstrys12)*100#<br>	
Big Pass Plays: #fBigPlayPassCt/FAVpasstrys12#<br>
Big Run Plays: #fBigPlayRunCt/FAVruntrys12#<br>
**********************************************<br>
</cfoutput>	

<cfoutput>
**********************************************<br>
Run Trys: #Undruntrys12#<br>
Offensive RunPts for  #und# was: #uRunPts12#<br>
Offensive PassPts for #und# was: #uPassPts12#<br>	
Offensive Total: #uRunPts12 + uPassPts12#<br>	
Run Wins for #und#: #(urunwin12/Undruntrys12)*100#<br>
Pass Wins for #und# #(uPasswin12/Undpasstrys12)*100#<br>	
Big Pass Plays: #uBigPlayPassCt/UNDpasstrys12#<br>
Big Run Plays: #uBigPlayRunCt/UNDruntrys12#<br>
**********************************************<br>
</cfoutput>	
</cfif>




































	
<!-- Get the first down stats for Fav -->
<cfquery datasource="psp_psp" name="GetFav1stdown">
Select *
from pbptendencies 
where Down in (3)
and Team = '#trim(fav)#'
and week = #myweek#
and OffDef='O'
and PlayType not in ('Point After','FGA','Penalty')
</cfquery>

<!-- Get the first down stats for Und -->
<cfquery datasource="psp_psp" name="GetUnd1stdown">
Select *
from pbptendencies 
where Down in (3)
and Team = '#trim(und)#'
and week = #myweek#
and OffDef = 'O'
and PlayType not in ('Point After','FGA','Penalty')
</cfquery>

<cfloop query="GetFav1stDown">
	<cfoutput>
	***********************************************<br>
	************Playtype is #playtype# for: #fav#<br>
	***********************************************<br>
	</cfoutput>
	<cfif PlayType is 'Run'>

		<cfset Favruntrys3  = Favruntrys3 + 1>
	3rd down run...<br>
	
		<cfif Yards lt 0 >
			<cfset fRunPts3 = fRunPts3 - 2>
			less than 0!<br>
			<cfset frunloss3 = frunloss3 + 1>
			
		</cfif>
	
		<cfif Yards ge 0 and yards le 2 >
			
			<cfif yards gte togo>
			
				<cfset frunwin3 = frunwin3 + 1>
				<cfset fRunPts3 = fRunPts3 + 1>
			<cfelse>
				<cfset fRunPts3 = fRunPts3 - 1>
				<cfset frunloss3 = frunloss3 + 1>
				
			</cfif>	
				
			between 1 and 2<br>
		</cfif>
		
		<cfif Yards is 3 >
			
			<cfif yards gte togo>
			
				<cfset frunwin3 = frunwin3 + 1>
				<cfset fRunPts3 = fRunPts3 + 1.5>
			<cfelse>
				
			</cfif>
			3 yard gain<br>
			
			
		</cfif>
	
		<cfif Yards ge 4 and yards le 6 >
			<cfset fRunPts3 = fRunPts3 + 2>
			between 4 and 6<br>
			<cfset frunwin3 = frunwin3 + 1>
		</cfif>

		<cfif Yards ge 7 and yards le 9 >
			<cfset fRunPts3 = fRunPts3 + 4>
			<cfset frunwin3 = frunwin3 + 1>
			between 7 and 9<br>
		</cfif>
		
		<cfif Yards gt 10>
			<cfset fRunPts3 = fRunPts3 + 6>
			<cfset frunwin3 = frunwin3 + 1>
			grater than 10 <br>
			<cfset fBigPlayCt    = fBigPlayCt + 1>
			<cfset fBigPlayRunCt = fBigPlayRunCt + 1>

		</cfif>

	</cfif>
	
	

	
	<cfif PlayType is 'Pass' or Playtype is 'Sack' or Playtype is 'Interception'>
		3rd down Pass...<br>
		
		<cfset FavPasstrys3  = FavPasstrys3 + 1>
		
		<cfif Yards lte 0>
		
			<cfif Playtype is 'Sack' or Playtype is 'Interception'>
			Sack or INT <br>
				<cfset fPassPts3 = fPassPts3 - 10>
			<cfelse>
				<cfset fPassPts3 = fPassPts3 - 6>
				incomplete <br>
			</cfif>
				
			<cfset fPassLoss3 = fPassLoss3 + 1>
			
		</cfif>

		<cfif Yards ge 1 and yards le 3>
			
			<cfif yards gte togo>
			
				between 1 and 3 <br>
				<cfset fPassWin3 = fPassWin3 + 1>
				<cfset fPassPts3 = fPassPts3 + 1>
			<cfelse>
			
			</cfif>
			
		</cfif>

		<cfif Yards ge 4 and yards le 6>
			between 4 and 6 <br>
			<cfset fPassWin3 = fPassWin3 + 1>
			<cfset fPassPts3 = fPassPts3 + 2.5>
		</cfif>

		<cfif Yards ge 7 and yards le 10>
			between 7 and 10 <br>
			<cfset fPassWin3 = fPassWin3 + 1>			
			<cfset fPassPts3 = fPassPts3 + 4.5>
		</cfif>

		<cfif Yards ge 11 and yards lt 20>
			between 11 and 20 <br>
			<cfset fPassWin3 = fPassWin3 + 1>			
			<cfset fPassPts3 = fPassPts3 + 7.5>
		</cfif>
	
		<cfif Yards ge 20 and yards le 30>
			between 21 and 30 <br>
			<cfset fPassWin3 = fPassWin3 + 1>			
			<cfset fPassPts3 = fPassPts3 + 12.5>
			<cfset fBigPlayCt    = fBigPlayCt + 1>
			<cfset fBigPlayPassCt = fBigPlayPassCt + 1>

		</cfif>

		<cfif Yards ge 31 and yards le 40>
			between 31 and 40 <br>
			<cfset fPassWin3 = fPassWin3 + 1>					
			<cfset fPassPts3 = fPassPts3 + 17.5>
			<cfset fBigPlayCt    = fBigPlayCt + 1>
			<cfset fBigPlayPassCt = fBigPlayPassCt + 1>

		</cfif>
	
		<cfif Yards gt 40>
			<cfset fPassWin3 = fPassWin3 + 1>		
			greater than 40! <br>
			<cfset fPassPts3 = fPassPts3 + 20>
			<cfset fBigPlayCt    = fBigPlayCt + 1>
			<cfset fBigPlayPassCt = fBigPlayPassCt + 1>

		</cfif>

	
	</cfif>
	<br>
</cfloop>	


<!--- <cfoutput>
<p>		
***************************************************<br>
Offensive RunPts for  #fav# was: #RunPts#<br>
Offensive PassPts for #fav# was: #PassPts#<br>
Run Wins for #fav#: #(Frunwin3/Favruntrys)*100#<br>
Pass Wins for #fav# #(FPasswin3/Favpasstrys)*100#<br>	
Overall Offense Total: #ftot#<br>	
***************************************************<br>
</cfoutput> --->	
<br>
------------------------------------------------------------------------------------------------------------------------------------------------------------------<br>
<p>
<p>


<cfloop query="GetUnd1stDown">

	<cfif PlayType is 'Run'>

		3rd down run... <br>
		<cfset Undruntrys3 = Undruntrys3 + 1>
	
		<cfif Yards lt 0 >
		lt 0 <br>
			<cfset uRunPts3 = uRunPts3 - 2>
			<cfset uRunLoss3 = URunLoss3 + 1>
		</cfif>
	
		<cfif Yards ge 0 and yards le 2 >
		1 to 2 <br>
		
			<cfif yards gte togo>
				<cfset uRunWin3 = URunWin3 + 1>
				<cfset uRunPts3 = uRunPts3 + 1>
			<cfelse>
				<cfset uRunPts3 = uRunPts3 - 1>
				<cfset uRunLoss3 = URunLoss3 + 1>
			</cfif>	
		</cfif>
		
		<cfif Yards is 3 >
		3 yrd run <br>
		
			<cfif yards gte togo>
				<cfset uRunWin3 = URunWin3 + 1>
				<cfset uRunPts3 = uRunPts3 + 1.5>
			<cfelse>
				
			</cfif>	
		</cfif>
	
		<cfif Yards ge 4 and yards le 6 >
		4 to 6 <br>
			<cfset uRunPts3 = uRunPts3 + 2>
			<cfset uRunWin3 = URunWin3 + 1>
		</cfif>

		<cfif Yards ge 7 and yards le 9 >
		7 to 9 <br>
			<cfset uRunPts3 = uRunPts3 + 4>
			<cfset uRunWin3 = URunWin3 + 1>
		</cfif>
		
		<cfif Yards ge 10>
			ge 10 <br>
			<cfset uRunPts3 = uRunPts3 + 6>
			<cfset uRunWin3 = URunWin3 + 1>
			<cfset uBigPlayCt    = uBigPlayCt + 1>
			<cfset uBigPlayRunCt = uBigPlayRunCt + 1>
		</cfif>

	</cfif>

	
	<cfif PlayType is 'Pass' or PlayType is 'Interception' or PlayType is 'Sack'>
	<cfoutput>
		***********************************************<br>
		************Playtype is #playtype# for: #und#<br>
		***********************************************<br>
	
		<cfset UndPasstrys3  = UndPasstrys3 + 1>
	
		<cfif Yards lte 0>
		
			<cfif Playtype is 'Sack' or Playtype is 'Interception'>
				sack or int <br>
				<cfset uPassPts3 = uPassPts3 - 10>
			<cfelse>
				incomplete <br>
				<cfset uPassPts3 = uPassPts3 - 6>
			</cfif>
			<cfset uPassLoss3 = UPassLoss3 + 1>
		</cfif>

		<cfif Yards ge 1 and yards le 3>
			1 to 3 <br>
			<cfif yards gte togo>
				<cfset uPassWin3 = UPassWin3 + 1>
				<cfset uPassPts3 = uPassPts3 + 1>
			<cfelse>	
				<cfset uPassPts3 = uPassPts3 + 0>
				<cfset uPassLoss3 = UPassLoss3 + 1>
			</cfif>
				
		</cfif>

		<cfif Yards ge 4 and yards le 6>
		4 to 6 <br>
			<cfset uPassPts3 = uPassPts3 + 2.5>
			<cfset uPassWin3 = UPassWin3 + 1>
		</cfif>

		<cfif Yards ge 7 and yards le 10>
		7 to 10 <br>
			<cfset uPassPts3 = uPassPts3 + 4.5>
			<cfset uPassWin3 = UPassWin3 + 1>
		</cfif>

		<cfif Yards ge 11 and yards lt 20>
		11 to 20 <br>
			<cfset uPassPts3 = uPassPts3 + 7.5>
			<cfset uPassWin3 = UPassWin3 + 1>
		</cfif>
	
		<cfif Yards ge 20 and yards le 30>
		21 to 30 <br>
			<cfset uPassPts3 = uPassPts3 + 12.5>
			<cfset uPassWin3 = UPassWin3 + 1>
			<cfset uBigPlayCt    = uBigPlayCt + 1>
			<cfset uBigPlayPassCt = uBigPlayPassCt + 1>

		</cfif>

		<cfif Yards ge 31 and yards le 40>
		31 to 40 <br>
			<cfset uPassPts3 = uPassPts3 + 17.5>
			<cfset uPassWin3 = UPassWin3 + 1>
			<cfset uBigPlayCt    = uBigPlayCt + 1>
			<cfset uBigPlayPassCt = uBigPlayPassCt + 1>

		</cfif>
	
		<cfif Yards gt 40>
		gt 40<br>
			<cfset uPassPts3 = uPassPts3 + 20>
			<cfset uPassWin3 = UPassWin3 + 1>
			<cfset uBigPlayCt    = uBigPlayCt + 1>
			<cfset uBigPlayPassCt = uBigPlayPassCt + 1>

		</cfif>
		</cfoutput>
	
	</cfif>
	
</cfloop>	


<cfset mybpppct = 0>
<cfset mybprpct = 0>

<cfset myrunwinpct = 0>
<cfif (favruntrys12 + favruntrys3 neq 0)>
<cfset mybprpct = 100*(fBigPlayRunCt/(FAVruntrys3 + FAVruntrys12))>

<cfset myrunwinpct = ((frunwin12 + frunwin3)/(favruntrys12 + favruntrys3))*100>
</cfif>

<cfset mypasswinpct = 0>
<cfif favpasstrys12 + favpasstrys3 neq 0>
	<cfset mybpppct = 100*(fBigPlayPassCt/(FAVpasstrys3 + FAVpasstrys12))>
	<cfset mypasswinpct = ((fpasswin12 + fpasswin3)/(favpasstrys12 + favpasstrys3))*100>
</cfif>

<cfset myfinal =  (fRunPts12 + fPassPts12 + fRunPts3 + fPassPts3)>

<!--- <cfif (fRunPts12 + fPassPts12 + fRunPts3 + fPassPts3) le 0>
		<cfset myfinal = -100 + (fRunPts12 + fPassPts12 + fRunPts3 + fPassPts3)>
</cfif> --->

<!--- <cfoutput>
***********************************************************************************************<br>	
#uBigPlayPassCt/(Undpasstrys3 + Undpasstrys12)# + #uBigPlayRunCt/(Undruntrys3 + Undruntrys12)# <br>
#uBigPlayPassCt/(Undpasstrys3 + Undpasstrys12)# <br>
#uBigPlayRunCt/(Undruntrys3 + Undruntrys12)# <br>
***********************************************************************************************<br>
</cfoutput> --->



<cfquery datasource="psp_psp" name="Addit">
Insert into LineRating
(
<!--- PassAttempts,
PassPtsPerAtt, --->
Team,
OffDef,
Opp,
Rating,
week,
RunWinPct,
PassWinPct,
RunRating,
PassRating,
BigPlayPass,
BigPlayRun
)
values
(
<!--- #FavPassTrys12 + FavPassTrys3#,
(#fPassPts3 + fPassPts12#)/(#FavPassTrys12 + FavPassTrys3#), --->
'#fav#',
'O',
'#und#',
#myfinal#,
#myweek#,
#myRunWinPct#,
#myPassWinPct#,
#fRunPts3 + fRunPts12#,
#fPassPts3 + fPassPts12#,
#mybpppct#,
#mybprpct#
)
</cfquery>



<cfquery datasource="psp_psp" name="Addit">
Insert into LineRating
(
<!--- PassAttempts,
PassPtsPerAtt, --->
Team,
OffDef,
Opp,
Rating,
week,
RunWinPct,
PassWinPct,
RunRating,
PassRating,
BigPlayPass,
BigPlayRun
)
values
(
<!--- #FavPassTrys12 + FavPassTrys3#,
(#fPassPts3 + fPassPts12#)/(#FavPassTrys12 + FavPassTrys3#), --->
'#und#',
'D',
'#fav#',
#myfinal#,
#myweek#,
#100 - myRunWinPct#,
#100 - myPassWinPct#,
#fRunPts3 + fRunPts12#,
#fPassPts3 + fPassPts12#,
#mybpppct#,
#mybprpct#
)
</cfquery>

<cfset mybprpct =0>
<cfset mybpppct =0>

<cfset myrunwinpct = 0>
<cfif (undruntrys12 + undruntrys3 neq 0)>
	<cfset mybprpct = 100*(uBigPlayRunCt/(Undruntrys3 + Undruntrys12))>
<cfset myrunwinpct = ((urunwin12 + urunwin3)/(undruntrys12 + undruntrys3))*100>
</cfif>

<cfset mypasswinpct = 0>
<cfif undpasstrys12 + undpasstrys3 neq 0>
<cfset mybpppct = 100*(uBigPlayPassCt/(UNDpasstrys3 + UNDruntrys12))>
<cfset mypasswinpct = ((upasswin12 + upasswin3)/(undpasstrys12 + undpasstrys3))*100>
</cfif>

<cfset myfinal =  (uRunPts12 + uPassPts12 + uRunPts3 + uPassPts3) >

<!--- <cfif (uRunPts12 + uPassPts12 + uRunPts3 + uPassPts3) le 0>
		<cfset myfinal = -100 + (uRunPts12 + uPassPts12 + uRunPts3 + uPassPts3)>
</cfif> --->



<cfquery name="bye" datasource="psp_psp" >
Update LineDominationStats
Set RushAttFor = #favruntrys3 + favruntrys12#,
  RushAttAgst = #undruntrys3 + undruntrys12#,
  PassAttFor = #favpasstrys3 + favpasstrys12#,
  PassAttAgst = #undpasstrys3 + undpasstrys12#,
  TOPFor = #favruntrys3 + favruntrys12 + favpasstrys3 + favpasstrys12#,
  TOPAgst = #undruntrys3 + undruntrys12 + undpasstrys3 + undpasstrys12#
 where week = #myweek#
 and Team = '#fav#' 
</cfquery>

<cfquery name="bye" datasource="psp_psp" >
Update LineDominationStats
Set RushAttAgst = #favruntrys3 + favruntrys12#,
  RushAttFor = #undruntrys3 + undruntrys12#,
  PassAttAgst = #favpasstrys3 + favpasstrys12#,
  PassAttFor = #undpasstrys3 + undpasstrys12#,
  TOPAgst = #favruntrys3 + favruntrys12 + favpasstrys3 + favpasstrys12#,
  TOPFor = #undruntrys3 + undruntrys12 + undpasstrys3 + undpasstrys12#
   where week = #myweek#
 and Team = '#und#' 
</cfquery>




<cfquery datasource="psp_psp" name="Addit">
Insert into LineRating
(
<!--- PassAttempts,
PassPtsPerAtt, --->
Team,
OffDef,
Opp,
Rating,
week,
RunWinPct,
PassWinPct,
RunRating,
PassRating,
BigPlayPass,
BigPlayRun
)
values
(
<!--- #UndPassTrys12 + UndPassTrys3#,
(#uPassPts3 + uPassPts12#)/(#UndPassTrys12 + UndPassTrys3#), --->
'#und#',
'O',
'#fav#',
#myfinal#,
#myweek#,
#myRunWinPct#,
#myPassWinPct#,
#uRunPts3 + uRunPts12#,
#uPassPts3 + uPassPts12#,
#mybpppct#,
#mybprpct#
)
</cfquery>



<cfquery datasource="psp_psp" name="Addit">
Insert into LineRating
(
<!--- PassAttempts,
PassPtsPerAtt, --->
Team,
OffDef,
Opp,
Rating,
week,
RunWinPct,
PassWinPct,
RunRating,
PassRating,
BigPlayPass,
BigPlayRun
)
values
(
<!--- #UndPassTrys12 + UndPassTrys3#,
(#uPassPts3 + uPassPts12#)/(#UndPassTrys12 + UndPassTrys3#), --->
'#fav#',
'D',
'#und#',
#myfinal#,
#myweek#,
#100 - myRunWinPct#,
#100 - myPassWinPct#,
#uRunPts3 + uRunPts12#,
#uPassPts3 + uPassPts12#,
#mybpppct#,
#mybprpct#
)
</cfquery>




</cfloop>

<cfquery datasource="psp_psp" name="Addit">
UPDATE LineRating
SET BigPlay = BigPlayPass + BigPlayRun
</cfquery>

<p>
<p>
************************<br>
OVER ALL<br>
************************<br>
<p>	




<!--- 
Redzone Stats
 --->


<!-- Get the first down stats for Fav -->
<cfquery datasource="psp_psp" name="GetFav1stdown">
Select *
from pbptendencies 
where Team = '#trim(fav)#'
and week = #myweek#
and OffDef='O'
and PlayType not in ('Point After','FGA','Penalty')
and FieldPos = 5
</cfquery>

<cfquery datasource="psp_psp" name="GetFavRZPts">
Select Sum(pts) as RZPts
from pbptendencies 
where Team = '#trim(fav)#'
and week = #myweek#
and OffDef='O'
and FieldPos = 5
</cfquery>

<cfquery datasource="psp_psp" name="GetUndRZPts">
Select Sum(pts) as RZPts
from pbptendencies 
where Team = '#trim(und)#'
and week = #myweek#
and OffDef='O'
and FieldPos = 5
</cfquery>

<!-- Get the first down stats for Und -->
<cfquery datasource="psp_psp" name="GetUnd1stdown">
Select *
from pbptendencies 
where Team = '#trim(und)#'
and week = #myweek#
and OffDef = 'O'
and FieldPos = 5
and PlayType not in ('Point After','FGA','Penalty')
</cfquery>


<cfset FavRZPlays = GetFav1stDown.recordcount>
<cfset UndRZPlays = GetUnd1stDown.recordcount>

<cfif FavRZPlays neq 0>
<cfquery name="rzf" datasource="psp_psp" >
Update LineRating
Set RZPlays = #FavRZPlays#,
  RZPtsPerPlay = #GetFavRZPts.RZPts/FavRZPlays#
 where week = #myweek#
 and Team = '#fav#'
 and OffDef = 'O' 
</cfquery>


<cfquery name="rzf" datasource="psp_psp" >
Update LineRating
Set RZPlays = #FavRZPlays#,
  RZPtsPerPlay = #GetFavRZPts.RZPts/FavRZPlays#
 where week = #myweek#
 and Team = '#und#'
 and OffDef = 'D' 
</cfquery>

<cfelse>
<cfquery name="rzf" datasource="psp_psp" >
Update LineRating
Set RZPlays = 0,
  RZPtsPerPlay = 0
 where week = #myweek#
 and Team = '#fav#'
 and OffDef = 'O' 
</cfquery>

<cfquery name="rzf" datasource="psp_psp" >
Update LineRating
Set RZPlays = 0,
  RZPtsPerPlay = 0
 where week = #myweek#
 and Team = '#und#'
 and OffDef = 'D' 
</cfquery>

</cfif>

<cfif UndRZPlays neq 0>
<cfquery name="rzu" datasource="psp_psp" >
Update LineRating
Set RZPlays = #UndRZPlays#,
  RZPtsPerPlay = #GetUndRZPts.RZPts/UndRZPlays#
 where week = #myweek#
 and Team = '#Und#' 
 and OffDef = 'O'
</cfquery>

<cfquery name="rzu" datasource="psp_psp" >
Update LineRating
Set RZPlays = #UndRZPlays#,
  RZPtsPerPlay = #GetUndRZPts.RZPts/UndRZPlays#
 where week = #myweek#
 and Team = '#Fav#' 
 and OffDef = 'D'
</cfquery>

<cfelse>

<cfquery name="rzu" datasource="psp_psp" >
Update LineRating
Set RZPlays = 0,
  RZPtsPerPlay = 0
 where week = #myweek#
 and Team = '#Und#'
 and OffDef = 'O' 
</cfquery>

<cfquery name="rzu" datasource="psp_psp" >
Update LineRating
Set RZPlays = 0,
  RZPtsPerPlay = 0
 where week = #myweek#
 and Team = '#fav#'
 and OffDef = 'D' 
</cfquery>


</cfif>




<cfset RZFavRunPts     = 0>
<cfset RZFavPassPts    = 0>
<cfset RZFavruntrys    = 0>
<cfset RZFavPasstrys   = 0>
<cfset RZFavRunWinCt   = 0>
<cfset RZFavPassWinCt  = 0>

<p>
<p>
<p>
<p>
<p>
<p>
<p>
<p>
R-E-D----Z-O-N-E<br>



<cfloop query="GetFav1stDown">
	<cfoutput>
	***********************************************<br>
	************Playtype is #playtype# for: #fav#<br>
	***********************************************<br>
	</cfoutput>
	<cfif PlayType is 'Run'>

		<cfset RZFavruntrys = RZFavruntrys + 1>

		<cfset Favruntrys12  = Favruntrys12 + 1>
		first down run...<br>
	
		<cfif Yards lt 0 >
			<cfset RZFavRunPts = RZFavRunPts - 2>
			less than 0!<br>
			 		
		</cfif>
	
		<cfif Yards ge 0 and yards le 2 >
			
			<cfif yards gte togo>
				<cfset RZFavRunPts = RZFavRunPts + 1>
				<cfset RZFavRunWinCt = RZFavRunWinCt + 1>
			<cfelse>
				<cfset RZFavRunPts = RZFavRunPts - 1>
			
			</cfif>
			between 1 and 2<br>
		</cfif>
		
		<cfif Yards is 3 >
			
			<cfif yards gte togo>
				<cfset RZFavRunPts = RZFavRunPts + 1.5>
				<cfset RZFavRunWinCt = RZFavRunWinCt + 1>
			<cfelse>
				
			</cfif>
			
			
			3 yard gain<br>
			
		</cfif>
	
	
	
	
		<cfif Yards ge 4 and yards le 6 >
			<cfset RZFavRunPts = RZFavRunPts + 2>
			between 4 and 6<br>
			<cfset RZFavRunWinCt = RZFavRunWinCt + 1>
		</cfif>

		<cfif Yards ge 7 and yards le 9 >
			<cfset RZFavRunPts = RZFavRunPts + 4>
			<cfset RZFavRunWinCt = RZFavRunWinCt + 1>
			between 7 and 9 <br>
		</cfif>
		
		<cfif Yards gt 10>
			<cfset RZFavRunPts = RZFavRunPts + 6>
			<cfset RZFavRunWinCt = RZFavRunWinCt + 1>
			grater than 10<br>
		</cfif>

	</cfif>
	
	
	
	<cfif PlayType is 'Pass' or Playtype is 'Sack' or Playtype is 'Interception'>
		first down Pass...<br>
		
		<cfset RZFavPasstrys = RZFavPasstrys + 1>
		
		<cfif Yards lte 0>
		
			<cfif Playtype is 'Sack' or Playtype is 'Interception'>
				<cfset RZFavPassPts = RZFavPassPts - 3>
				sack or int <br>
			<cfelse>
				<cfset RZFavPassPts = RZFavPassPts - 1>
				incomplete<br>
			</cfif>
				
			
			
		</cfif>

		<cfif Yards ge 1 and yards le 3>
			between 1 and 3<br>
			
			<cfif yards gte togo>
				<cfset RZFavPassWinCt = RZFavPassWinCt + 1>
				<cfset RZFavPassPts = RZFavPassPts + 1>
			<cfelse>
				
			
			</cfif>
			
		</cfif>

		<cfif Yards ge 4 and yards le 6>
			between 4 and 6<br>
			<cfset RZFavPassWinCt = RZFavPassWinCt + 1>
			<cfset RZFavPassPts = RZFavPassPts + 2.5>
		</cfif>

		<cfif Yards ge 7 and yards le 10>
			between 7 and 10<br>
			<cfset RZFavPassWinCt = RZFavPassWinCt + 1>			
			<cfset RZFavPassPts = RZFavPassPts + 4.5>
		</cfif>

		<cfif Yards ge 11 and yards le 20>
			between 11 and 20<br>
			<cfset RZFavPassWinCt = RZFavPassWinCt + 1>			
			<cfset RZFavPassPts = RZFavPassPts + 7.5>
		</cfif>
		
	
	</cfif>
	<br>
</cfloop>	

<cfif RZFavruntrys neq 0 and RZFavPasstrys>
<cfoutput>
<p>		
***************************************************<br>
RZ Plays: #RZFavruntrys + RZFavPasstrys#<br>
RZ Offensive RunPts for  #fav# was: #RZFavRunPts#<br>
RZ Offensive PassPts for #fav# was: #RZFavPassPts#<br>
RZ Run Wins for #fav#: #(RZFavRunWinCt/RZFavruntrys)*100#<br>
RZ Pass Wins for #fav# #(RZFavPasswinct/RZFavpasstrys)*100#<br>	
RZ Overall Offense Total: #RZFavRunPts + RZFavPassPts#<br>	
***************************************************<br>
</cfoutput>	
<br>
</cfif>








<cfset RZUNDRunPts     = 0>
<cfset RZUNDPassPts    = 0>
<cfset RZUNDruntrys    = 0>
<cfset RZUNDPasstrys   = 0>
<cfset RZUNDRunWinCt   = 0>
<cfset RZUNDPassWinCt  = 0>



<cfloop query="GetUND1stDown">
	<cfoutput>
	***********************************************<br>
	************Playtype is #playtype# for: #UND#<br>
	***********************************************<br>
	</cfoutput>
	<cfif PlayType is 'Run'>

		<cfset RZUNDruntrys = RZUNDruntrys + 1>

		<cfset UNDruntrys12  = UNDruntrys12 + 1>
		first down run...<br>
	
		<cfif Yards lt 0 >
			<cfset RZUNDRunPts = RZUNDRunPts - 2>
			less than 0!<br>
					
		</cfif>
	
		<cfif Yards ge 0 and yards le 2 >
			
			<cfif yards gte togo>
				<cfset RZUNDRunPts = RZUNDRunPts + 1>
				<cfset RZUNDRunWinCt = RZUNDRunWinCt + 1>
			<cfelse>	
				<cfset RZUNDRunPts = RZUNDRunPts - 1>
			</cfif>
			between 1 and 2<br>
		</cfif>
		
		<cfif Yards is 3 >
			<cfif yards gte togo>
				<cfset RZUNDRunPts = RZUNDRunPts + 1.5>
				<cfset RZUNDRunWinCt = RZUNDRunWinCt + 1>
			<cfelse>	
				
			</cfif>
			3 yard gain<br>
			
		</cfif>
	
		<cfif Yards ge 4 and yards le 6 >
			<cfset RZUNDRunPts = RZUNDRunPts + 2>
			between 4 and 6<br>
			<cfset RZUNDRunWinCt = RZUNDRunWinCt + 1>
		</cfif>

		<cfif Yards ge 7 and yards le 9 >
			<cfset RZUNDRunPts = RZUNDRunPts + 4>
			<cfset RZUNDRunWinCt = RZUNDRunWinCt + 1>
			between 7 and 9 <br>
		</cfif>
		
		<cfif Yards gt 10>
			<cfset RZUNDRunPts = RZUNDRunPts + 6>
			<cfset RZUNDRunWinCt = RZUNDRunWinCt + 1>
			grater than 10<br>
		</cfif>

	</cfif>
	
	
	
	<cfif PlayType is 'Pass' or Playtype is 'Sack' or Playtype is 'Interception'>
		first down Pass...<br>
		
		<cfset RZUNDPasstrys = RZUNDPasstrys + 1>
		
		<cfif Yards lte 0>
		
			<cfif Playtype is 'Sack' or Playtype is 'Interception'>
				<cfset RZUNDPassPts = RZUNDPassPts - 8>
				sack or int <br>
			<cfelse>
				<cfset RZUNDPassPts = RZUNDPassPts - 3.5>
				incomplete<br>
			</cfif>
				
			<cfset fPassLoss12 = fPassLoss12 + 1>
			
		</cfif>

		<cfif Yards ge 1 and yards le 3>
			<cfset RZUNDPassWinCt = RZUNDPassWinCt + 1>
			<cfset RZUNDPassPts = RZUNDPassPts + 1>
			between 1 and 3<br>
			<cfif yards gte togo>
			
			<cfelse>
				
			</cfif>
			
		</cfif>



		<cfif Yards ge 4 and yards le 6>
			between 4 and 6<br>
			<cfset RZUNDPassWinCt = RZUNDPassWinCt + 1>
			<cfset RZUNDPassPts = RZUNDPassPts + 2.5>
		</cfif>

		<cfif Yards ge 7 and yards le 10>
			between 7 and 10<br>
			<cfset RZUNDPassWinCt = RZUNDPassWinCt + 1>			
			<cfset RZUNDPassPts = RZUNDPassPts + 4.5>
		</cfif>

		<cfif Yards ge 11 and yards le 20>
			between 11 and 20<br>
			<cfset RZUNDPassWinCt = RZUNDPassWinCt + 1>			
			<cfset RZUNDPassPts = RZUNDPassPts + 7.5>
		</cfif>
		
	
	</cfif>
	<br>
</cfloop>	

<cfif RZUndruntrys neq 0 and RZUndPasstrys>
<cfoutput>
<p>		
***************************************************<br>
RZ Plays: #RZUndruntrys + RZUndPasstrys#<br>
RZ Offensive RunPts for  #UND# was: #RZUNDRunPts#<br>
RZ Offensive PassPts for #UND# was: #RZUNDPassPts#<br>
RZ Run Wins for #UND#: #(RZUNDRunWinCt/RZUNDruntrys)*100#<br>
RZ Pass Wins for #UND# #(RZUNDPasswinct/RZUNDpasstrys)*100#<br>	
RZ Overall Offense Total: #RZUNDRunPts + RZUNDPassPts#<br>	
***************************************************<br>
</cfoutput>	
<br>
------------------------------------------------------------------------------------------------------------------------------------------------------------------<br>
<p>
<p>
</cfif>



















<p>
<p>
<p>
************************************* finished for #myweek#, session.week = #session.week#<br>
<cfquery name="bye" datasource="psp_psp" >
UPDATE LineRating
SET SuccessRate = (RunWinPct + PassWinPct)/2
</cfquery>

</cfloop>

<cfquery name="updGetGameURL" datasource="psp_psp">
	Update DriveChartLoadData
	Set PbPLoaded = 'Y' 
	WHERE week = #Session.week#
	and PbPLoaded = 'C'
</cfquery>






	
</body>
</html>
