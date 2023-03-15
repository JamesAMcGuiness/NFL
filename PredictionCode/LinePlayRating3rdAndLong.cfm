<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>

<cfset myweek = GetWeek.week>

<!--- <cfset myweek = 21>  --->

<body>
<cfloop index="ii" from="#myweek#" to="#myweek#"> 
<!--- <cfloop index="ii" from="23" to="23"> --->
<cfset myweek = ii>

<cfquery name="GetSpds" datasource="nflspds" >
SELECT *
FROM nflspds
WHERE week = #myweek#
</cfquery>

<cfloop query="Getspds">
	
	<cfset fav = "#Getspds.fav#">
	<cfset und = "#GetSpds.und#">
	
<cfquery name="Del" datasource="psp_psp" >
Delete from LineDominationStats
WHERE week = #myweek#
and team in ('#fav#','#und#')
</cfquery>

<cfquery name="Del" datasource="psp_psp" >
Insert into LineDominationStats(team,week,opp)
values('#Fav#',#ii#,'#und#')
</cfquery>

<cfquery name="Del" datasource="psp_psp" >
Insert into LineDominationStats(team,week,opp)
values('#und#',#ii#,'#fav#')
</cfquery>

	
	
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

	
<!--- 
3rd and long situations......

 --->
	
<!-- Get the first down stats for Fav -->
<cfquery datasource="psp_psp" name="GetFav1stdown">
Select *
from pbptendencies 
where Down in (3)
and Team = '#trim(fav)#'
and week = #myweek#
and OffDef='O'
and PlayType not in ('Point After','FGA','Penalty')
and togo >= 5
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
and togo >= 5
</cfquery>

<cfset FavPasstrys3  = 0>
<cfset UndPasstrys3  = 0>

<cfloop query="GetFav1stDown">
	<cfoutput>
	***********************************************<br>
	************Playtype is #playtype# for: #fav#<br>
	***********************************************<br>
	</cfoutput>
	
	<cfif PlayType is 'Pass' or Playtype is 'Sack' or Playtype is 'Interception'>
		<cfoutput>
		3rd down and long Pass yards made #yards#, togo was #togo#...<br>
		</cfoutput>
		<cfset FavPasstrys3  = FavPasstrys3 + 1>
		<cfif Yards is 0>
		
			<cfif Playtype is 'Sack' or Playtype is 'Interception'>
			Sack or INT <br>
				<cfset fPassPts3 = fPassPts3 - 3>
			<cfelse>
				<cfset fPassPts3 = fPassPts3 - 1>
				incomplete <br>
			</cfif>
				
			<cfset fPassLoss3 = fPassLoss3 + 1>
			
		</cfif>

		<cfif  togo ge 5 and togo le 10 >
			<cfif togo le yards>
			made it between 5 and 10! <br>
			<cfset fPassWin3 = fPassWin3 + 1>
			<cfset fPassPts3 = fPassPts3 + 1>
			<cfelse>
			failed between 5 and 10! <br>
			</cfif>
		</cfif>
		
		<cfif togo ge 11>
			<cfif togo le yards>
			made it for 11 or more! <br>
			<cfset fPassWin3 = fPassWin3 + 1>			
			<cfset fPassPts3 = fPassPts3 + 3>
			<cfelse>
			failed for 11 or more! <br>
			</cfif>
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
	
	<cfif PlayType is 'Pass' or Playtype is 'Sack' or Playtype is 'Interception'>
		<cfoutput>
		3rd down and long Pass yards made #yards#, togo was #togo#...<br>
		</cfoutput>
		<cfset UndPasstrys3  = UndPasstrys3 + 1>
		<cfif Yards is 0>
		
			<cfif Playtype is 'Sack' or Playtype is 'Interception'>
			Sack or INT <br>
				<cfset uPassPts3 = uPassPts3 - 3>
			<cfelse>
				<cfset uPassPts3 = uPassPts3 - 1>
				incomplete <br>
			</cfif>
				
			<cfset uPassLoss3 = uPassLoss3 + 1>
			
		</cfif>

		<cfif  togo ge 5 and togo le 10 >
			<cfif togo le yards>
			made it between 5 and 10! <br>
			<cfset uPassWin3 = uPassWin3 + 1>
			<cfset uPassPts3 = uPassPts3 + 1>
			<cfelse>
			failed between 5 and 10! <br>
			</cfif>
		</cfif>
		
		<cfif togo ge 11>
			<cfif togo le yards>
			made it for 11 or more! <br>
			<cfset uPassWin3 = uPassWin3 + 1>			
			<cfset uPassPts3 = uPassPts3 + 3>
			<cfelse>
			failed for 11 or more! <br>
			</cfif>
		</cfif>
	
	</cfif>
	<br>
</cfloop>	


<p>
<p>
<p>
<p>
<p>	
<cfif  FAVpasstrys3 neq 0>
<cfoutput>
**********************************************<br>
3rd and long situations: #Getfav1stdown.recordcount#<br>
Offensive PassPts on 3rd and long for #FAV# was: #FPassPts3#<br>	
Pass Wins for #FAV# #(FPasswin3/FAVpasstrys3)*100#<br>	
**********************************************<br>

<cfquery name="bye" datasource="psp_psp" >
Update LineDominationStats
Set PassptsFor = #FPassPts3#,
  WinRate3LPFor = #(Fpasswin3/FavPasstrys3)*100#,
  PassptsAgst = #UPassPts3#,
  WinRate3LPAgst = #(Upasswin3/UndPasstrys3)*100#,
  ThrdLngFor = #FAVpasstrys3#,
  ThrdLngAgst = #Undpasstrys3#
 where week = #myweek#
 and Team = '#fav#' 
</cfquery>


</cfoutput>	
</cfif>

<cfif  undpasstrys3 neq 0>
<cfoutput>
**********************************************<br>
3rd and long situations: #GetUnd1stdown.recordcount#<br>
Offensive PassPts on 3rd and long for #und# was: #uPassPts3#<br>	
Pass Wins for #und# #(uPasswin3/Undpasstrys3)*100#<br>	
**********************************************<br>

<cfquery name="bye" datasource="psp_psp" >
Update LineDominationStats
Set PassptsAgst = #FPassPts3#,
  WinRate3LPAgst = #(Fpasswin3/FavPasstrys3)*100#,
  PassptsFor = #UPassPts3#,
  WinRate3LPFor = #(Upasswin3/UndPasstrys3)*100#,
  ThrdLngFor = #Undpasstrys3#,
  ThrdLngAgst = #Favpasstrys3#
 where week = #myweek#
 and team = '#und#' 
</cfquery>



</cfoutput>	
</cfif>

</cfloop>
</cfloop>	
</body>
</html>
