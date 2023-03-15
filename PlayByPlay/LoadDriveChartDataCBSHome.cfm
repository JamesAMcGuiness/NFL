<cftry>

<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>


<cfset week = GetWeek.week >
<cfset week = 3>	

<cfset Session.week = week>

<cfquery name="GetSpds" datasource="psp_psp" >
Delete from DriveCharts where week = #Week#
</cfquery>


<cfquery name="GetSpds" datasource="nflspds" >
SELECT *
FROM nflspds
WHERE week = #week#
</cfquery>



<cfloop query="Getspds">

<cfloop  index="iii" from="1" to="2">
<cfoutput>
============> #fav#/#und#<br>
</cfoutput>
<cfif iii is 1>
	<cfset myha = '#getspds.ha#'>
<cfelse>

	<cfif myha is 'H'>
		<cfset myha = 'A'>
	<cfelse>
		<cfset myha = 'H'>
	</cfif>
</cfif>

	<cfset myfav = "#Getspds.fav#">
	<cfset myund = "#GetSpds.und#">
	<cfset ha = "#GetSpds.ha#">
	<cfset spd = "#GetSpds.spread#">
	<cfset gameplayedon = "#GetSpds.TimeOfGame#">
	<!--- <cfset gameplayedon = "20061009"> --->
	<cfset awaytmlong = "">
	
	
	
	<cfif myfav is 'ARZ'>
		<cfset myfav = 'ARI'>
	</cfif>
	
	<cfif myund is 'ARZ'>
		<cfset myund = 'ARI'>
	</cfif>

	<cfif myfav is 'JAX'>
		<cfset myfav = 'JAC'>
	</cfif>
	
	<cfif myund is 'JAX'>
		<cfset myund = 'JAC'>
	</cfif>

	
	<cfif ha is 'H'>
		<cfset HomeTeam = myfav>
		<cfset AwayTeam = myUnd>
	<cfelse>
		<cfset HomeTeam = myund>
		<cfset AwayTeam = myfav>
	</cfif>

	<cfquery datasource="psp_psp" name="GetGameURL">
	select * from Drivechartloaddata
	where HomeTeam in ('#myfav#','#myund#')
	and week = #session.week#
	</cfquery>	

	<cfset myurl = '#GetGameURL.URL#'>
		
	<cfoutput>	#myurl# </cfoutput>
		
<cfoutput>
<cfhttp url="#myurl#" method="GET">
</cfhttp> 
</cfoutput>

<cfset mypage = #cfhttp.FileContent#>

<!--- <cfoutput>#mypage#</cfoutput> --->


<cfif awayteam is 'MIA'>
	<cfset awaytmlong = 'Miami'>
</cfif>


<cfif awayteam is 'CHI'>
	<cfset awaytmlong = 'Chicago'>
</cfif>


<cfif awayteam is 'DEN'>
	<cfset awaytmlong = 'Denver'>
</cfif>

	
<cfif awayteam is 'ATL'>
	<cfset awaytmlong = 'Atlanta'>
</cfif>

<cfif awayteam is 'ARI'>
	<cfset awaytmlong = 'Arizona'>
</cfif>

<cfif awayteam is 'NYG'>
	<cfset awaytmlong = 'New York Giants'>
</cfif>

<cfif awayteam is 'DAL'>
	<cfset awaytmlong = 'Dallas'>
</cfif>

<cfif awayteam is 'BUF'>
	<cfset awaytmlong = 'Buffalo'>
</cfif>


<cfif awayteam is 'PIT'>
	<cfset awaytmlong = 'Pittsburgh'>
</cfif>

<cfif awayteam is 'SEA'>
	<cfset awaytmlong = 'Seattle'>
</cfif>

<cfif awayteam is 'MIN'>
	<cfset awaytmlong = 'Minnesota'>
</cfif>

<cfif awayteam is 'WAS'>
	<cfset awaytmlong = 'Washington'>
</cfif>

<cfif awayteam is 'DET'>
	<cfset awaytmlong = 'Detroit'>
</cfif>

<cfif awayteam is 'TEN'>
	<cfset awaytmlong = 'Tennessee'>
</cfif>

<cfif awayteam is 'NYJ'>
	<cfset awaytmlong = 'New York Jets'>
</cfif>

<cfif awayteam is 'LAR'>
	<cfset awaytmlong = 'Los Angeles'>
</cfif>


<cfif awayteam is 'IND'>
	<cfset awaytmlong = 'Indianapolis'>
</cfif>

<cfif awayteam is 'DEN'>
	<cfset awaytmlong = 'Denver'>
</cfif>

<cfif awayteam is 'SEA'>
	<cfset awaytmlong = 'Seattle'>
</cfif>

<cfif trim(awayteam) is 'GB'>
	<cfset awaytmlong = 'Green Bay'>
</cfif>

<cfif trim(awayteam) is 'KC'>
	<cfset awaytmlong = 'Kansas City'>
</cfif>

<cfif awayteam is 'OAK'>
	<cfset awaytmlong = 'Oakland'>
</cfif>


<cfif awayteam is 'BAL'>
	<cfset awaytmlong = 'Baltimore'>
</cfif>

<cfif awayteam is 'DET'>
	<cfset awaytmlong = 'Detroit'>
</cfif>

<cfif awayteam is 'CIN'>
	<cfset awaytmlong = 'Cincinnati'>
</cfif>

<cfif trim(awayteam) is 'LAC'>
	<cfset awaytmlong = 'Los Angeles'>
</cfif>

<cfif awayteam is 'HOU'>
	<cfset awaytmlong = 'Houston'>
</cfif>

<cfif awayteam is 'JAC'>
	<cfset awaytmlong = 'Jacksonville'>
</cfif>

<cfif awayteam is 'CLE'>
	<cfset awaytmlong = 'Cleveland'>
</cfif>

<cfif trim(awayteam) is 'TB'>
	<cfset awaytmlong = 'Tampa Bay'>
</cfif>

<cfif awayteam is 'JAC'>
	<cfset awaytmlong = 'Jacksonville'>
</cfif>

<cfif awayteam is 'NYJ'>
	<cfset awaytmlong = 'New York Jets'>
</cfif>


<cfif Trim(awayteam) is 'NO'>
	<cfset awaytmlong = 'New Orleans'>
</cfif>

<cfif trim(awayteam) is 'SF'>
	<cfset awaytmlong = 'San Francisco'>
</cfif>

<cfif awayteam is 'CAR'>
	<cfset awaytmlong = 'Carolina'>
</cfif>


<cfif awayteam is 'PHI'>
	<cfset awaytmlong = 'Philadelphia'>
</cfif>

<cfif trim(awayteam) is 'NE'>
	<cfset awaytmlong = 'New England'>
</cfif>


 <cfquery datasource="psp_psp" name="Update">
  Update DriveChartLoadData
  Set PBPLoaded='TRY'
  Where HomeTeam in ('#hometeam#')
  and week = #Session.week#
 </cfquery>
 


<cfif awaytmlong is ''>
<cfoutput>
Couldn't find away team = #awayteam#</cfoutput><cfabort>
</cfif>


<cfset mypage = replace('#mypage#','<td  class="row1" align="left">','<tdjim>',"All")> 
<cfset mypage = replace('#mypage#','<td  class="row1" align="center">','<tdjim>',"All")> 
<cfset mypage = replace('#mypage#','<td  class="row2" align="center">','<tdjim>',"All")> 
<cfset mypage = replace('#mypage#','<td  class="row2" align="left">','<tdjim>',"All")> 

<!-- Find the Away Teams Stats -->
<cfoutput>
<cfset FindAwayTeamPos = FindNocase('<table class="data" width="100%" ><tr class="title away"><td colspan="6">',mypage)>

</cfoutput>

<!-- Remove all the data prior to the Away Teams data -->
<cfset mysmallpage = RemoveChars(mypage,1,FindAwayTeamPos - 1)>


<!-- Mypage should now have just the Drive Chart stats  -->
<cfset mypage = mysmallpage>

<!-- When the program has reached this, we are done entering stats for away team -->
<cfset FindHomeTeamPos = FindNocase('<table class="data" width="100%" ><tr class="title home"><td colspan="6">','#mypage#',1)>
<cfset myhomestart = FindHomeTeamPos>

<!---  
**************************************************************************************************************************************


**************************************************************************************************************************************
--->
<cfset hct = 0>
<cfset act = 0>	
<cfset done        = false>
<cfset aVisitorOff = arraynew(2)>
<cfset aHomeDef    = arraynew(2)>
<cfset aVisitorDef = arraynew(2)>
<cfset aHomeOff    = arraynew(2)>

<cfloop index="i" from="1" to="50">
	<cfloop index="j" from="1" to="7">
		<cfset aVisitorOff[#i#][#j#] = " ">
		<cfset aHomeDef[#i#][#j#]    = " ">
		<cfset aVisitorDef[#i#][#j#] = " ">
		<cfset aHomeOff[#i#][#j#]    = " ">
	</cfloop>
</cfloop>

<cfset Statct       = 0>
<cfif iii is 1>
	<cfset mystart      = 1>
<cfelse>
	<cfset mystart      = FindHomeTeamPos>
</cfif>	

<cfset myorigstart  = mystart>
<cfset jimct        = 0>
<cfset j            = 1>
<cfset StatsForHome = false>
<cfset prevfoundposend = 0>
<cfloop condition="done is false">

	<!-- Find the <td> just before the value you want to grab -->
	<cfset lookforbegin    = '<tdjim>'>
	<cfset lookforbeginlen = len(lookforbegin)>
		
	<cfoutput>
	
	<cfset foundposbegin = findnocase('#lookforbegin#','#mypage#',mystart)>
	

<!-- 		<p>
		foundposbegin = #foundposbegin#<br>
		HomeDataPos = #Myhomestart#
 -->	
		<cfif 	foundposbegin is 0>
			<cfset done = true>
		</cfif>
	
	<!-- If we are now done with away team, and ready to do home team stats then -->
	<!-- Start Processing HOME stats -->
		
		<cfset StatsForHome  = true>
		
		<cfset foundposbegin = findnocase('#lookforbegin#','#myPAGE#',mystart)>	

		<!-- =====>foundposbegin = #foundposbegin#<br>
		=====>HomeDataPos = #Myhomestart# -->

		
<!--- 		<CFIF foundposend lt prevfoundposend>
			<cfset done = true>
			<cfset foundposbegin = 100000000>
		</cfif>
		<cfset prevfoundposend = foundposend> --->
		
		<cfset mystart       = foundposbegin>
	
<!-- 	=======>foundposbegin = #foundposbegin#   -->

	<!-- Find the </td> just after the value you want to grab -->
	<cfset lookforend = '</td>'>
	<cfset lookforendlen = len(lookforend)>
	<cfset foundposend = findnocase('#lookforend#','#mypage#',mystart)>

	
 	<!-- =======>foundposend = #foundposend# <br> -->
	
	</cfoutput>
		
	<!-- Load the stat into an array -->
	<cfif foundposbegin neq 0 and foundposend neq 0 and done is false>
	
		<cfoutput>
	
		<cfset statct = statct + 1>
		<!--- 1 = start time
		2 = time of pos on drive
		3 = starting position (i.e Cin 30)
		4 = num of plays
		5 = yards on drive
		6 = result --->
		<!-- Create new row when done processing all the columns -->
		
		
		<cfset startFrom = (lookforbeginlen + foundposbegin)>
		<cfset ForALengthOf = foundposend - startFrom>
		
		<!-- startfrom = #startfrom#
		ForALengthOf = #ForALengthOf# -->
		 
		 	<cfif iii is 1>
		 
				<cfset aHomeDef[j][statct] = '#trim(mid(mypage,startfrom,ForALengthOf))#'>
				<cfset aVisitorOff[j][statct]    = '#trim(mid(mypage,startfrom,ForALengthOf))#'>
			
			<cfelse>
			
				<cfset aHomeoff[j][statct] = '#trim(mid(mypage,startfrom,ForALengthOf))#'>
				<cfset aVisitorDef[j][statct]    = '#trim(mid(mypage,startfrom,ForALengthOf))#'>
			
			</cfif>
			[#j#][#statct#]<br>
			aVisitorDef[j][statct] = #aVisitorDef[j][statct]#<br>
			aHomeOff[j][statct]    = #aHomeOff[j][statct]#<br>
			aVisitorOff[j][statct] = #aVisitorOff[j][statct]#<br>
			aHomeDef[j][statct]    = #aHomeDef[j][statct]#<br>
			<hr>
		<cfset mystart = (foundposend + lookforendlen) - 1>
	
		<!-- ==== The start is now: #mystart#... foundposend = #foundposend#....Statct = #statct#<br> -->
	
<!-- 		Next Start is: #mystart#<br> -->
		
					
		</cfoutput>
		
		
		
		<cfif statct ge 6>
			<cfset j = j + 1>
			<cfset statct = 0>
			
			<cfif iii is 2>
				<cfset hct = hct + 1>
			<cfelse>
				<cfset act = act + 1>
			</cfif>
			
			<cfif iii is 1>
				<cfset #aHomeDef[act][7]# = j>
				<cfset #aVisitorOff[act][7]# = j>
			<cfelse>
				<cfset #aHomeOff[hct][7]# = j>
				<cfset #aVisitorDef[hct][7]# = j>
			
			</cfif>
			
		</cfif>
				
	<cfelse>
		Get here, done is true!<br>
		<cfset done = true>

	</cfif>
	

	<cfif done is false>
		<cfset mystart = (foundposend + lookforendlen) - 1>
	</cfif>	
	
	<cfif iii is 1>
		<cfif mystart ge FindHomeTeamPos>
			<cfset done = true>
		</cfif>
	<cfelse>
		<cfif mystart ge (FindHomeTeamPos + 100000) >
			<cfset done = true>
		</cfif>
	</cfif>
	
</cfloop>



<cfif myfav is 'ARI'>
		<cfset myfav = 'ARZ'>
	</cfif>
	
	<cfif myund is 'ARI'>
		<cfset myund = 'ARZ'>
	</cfif>

	<cfif myfav is 'JAC'>
		<cfset myfav = 'JAX'>
	</cfif>
	
	<cfif myund is 'JAC'>
		<cfset myund = 'JAX'>
	</cfif>


	<cfif ha is 'H'>
		<cfset HomeTeam = myfav>
		<cfset AwayTeam = myUnd>
	<cfelse>
		<cfset HomeTeam = myund>
		<cfset AwayTeam = myfav>
	</cfif>




<cfset mytotct = 0>
<cfif iii is 1>
	<cfset mytotct = act>
<cfelse>
	<cfset mytotct = hct>
</cfif>

<cfoutput>
The total count is #mytotct#<br>
</cfoutput>
<cfloop index="hh" from="1" to="#mytotct#">

================== jim ==============<br>
<cfoutput>
#hh#<br>	
Home Off: #aHomeoff[hh][3]#<br>
Away Def: #aVisitorDef[hh][3]#<br>
Home Def: #aHomeDef[hh][3]#<br>
Away Off: #aVisitorOff[hh][3]#<br>
================== jim ==============<br>
</cfoutput>



<cfoutput>

<cfif 'BLT' is '#Left(aHomeOff[hh][3],3)#'>
	<cfset #aHomeOff[hh][3]# = 'BAL ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>

<cfif 'SL' is '#Left(aHomeOff[hh][3],2)#'>
	<cfset #aHomeOff[hh][3]# = 'SL ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>

<cfif 'CLV' is '#Left(aHomeOff[hh][3],3)#'>
	<cfset #aHomeOff[hh][3]# = 'CLE ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>

<cfif 'HST' is '#Left(aHomeOff[hh][3],3)#'>
	<cfset #aHomeOff[hh][3]# = 'HOU ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>

<cfif 'ARI' is '#trim(Left(aHomeOff[hh][3],3))#'>
	
	<cfset #aHomeOff[hh][3]# = 'ARZ ' & Trim(right(aHomeOff[hh][3],2))>
	we match!.... setting to #aHomeOff[hh][3]# <br>
	
</cfif>

<cfif 'JAC' is '#Left(aHomeOff[hh][3],3)#'>
	<cfset #aHomeOff[hh][3]# = 'JAX ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>


<cfif '*BLT' is '#Left(aHomeOff[hh][3],4)#'>
	<cfset #aHomeOff[hh][3]# = '*BAL ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>

<cfif '*SL' is '#Left(aHomeOff[hh][3],3)#'>
	<cfset #aHomeOff[hh][3]# = '*SL ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>

<cfif '*CLV' is '#Left(aHomeOff[hh][3],4)#'>
	<cfset #aHomeOff[hh][3]# = '*CLE ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>

<cfif '*HST' is '#Left(aHomeOff[hh][3],4)#'>
	<cfset #aHomeOff[hh][3]# = '*HOU ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>

<cfif '*ARI' is '#Left(aHomeOff[hh][3],4)#'>
	<cfset #aHomeOff[hh][3]# = '*ARZ ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>


<cfif '*JAC' is '#Left(aHomeOff[hh][3],4)#'>
	<cfset #aHomeOff[hh][3]# = '*JAX ' & Trim(right(aHomeOff[hh][3],2))>
</cfif>



<cfif 'BLT' is '#Left(aHomeDef[hh][3],3)#'>
	<cfset #aHomeDef[hh][3]# = 'BAL ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>

<cfif 'SL' is '#Left(aHomeDef[hh][3],2)#'>
	<cfset #aHomeDef[hh][3]# = 'STL ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>

<cfif 'CLV' is '#Left(aHomeDef[hh][3],3)#'>
	<cfset #aHomeDef[hh][3]# = 'CLE ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>

<cfif 'HST' is '#Left(aHomeDef[hh][3],3)#'>
	<cfset #aHomeDef[hh][3]# = 'HOU ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>

<cfif 'ARI' is '#Left(aHomeDef[hh][3],3)#'>
	<cfset #aHomeDef[hh][3]# = 'ARZ ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>

<cfif 'JAC' is '#Left(aHomeDef[hh][3],3)#'>
	<cfset #aHomeDef[hh][3]# = 'JAX ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>


<cfif '*BLT' is '#Left(aHomeDef[hh][3],4)#'>
	<cfset #aHomeDef[hh][3]# = '*BAL '  & trim(right(aHomeDef[hh][3],2))>
</cfif>

<cfif '*SL' is '#Left(aHomeDef[hh][3],3)#'>
	<cfset #aHomeDef[hh][3]# = '*STL ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>

<cfif '*CLV' is '#Left(aHomeDef[hh][3],4)#'>
	<cfset #aHomeDef[hh][3]# = '*CLE ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>

<cfif '*HST' is '#Left(aHomeDef[hh][3],4)#'>
	<cfset #aHomeDef[hh][3]# = '*HOU ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>

<cfif '*ARI' is '#Left(aHomeDef[hh][3],4)#'>
	<cfset #aHomeDef[hh][3]# = '*ARZ ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>

<cfif '*JAC' is '#Left(aHomeDef[hh][3],4)#'>
	<cfset #aHomeDef[hh][3]# = '*JAX ' & trim(right(aHomeDef[hh][3],2))> 
</cfif>



<cfif 'BLT' is '#Left(aVisitorOff[hh][3],3)#'>
	<cfset #aVisitorOff[hh][3]# = 'BAL ' & trim(right(aVisitorOff[hh][3],2))>
</cfif>

<cfif 'SL' is '#Left(aVisitorOff[hh][3],2)#'>
	<cfset #aVisitorOff[hh][3]# = 'STL ' & trim(right(aVisitorOff[hh][3],2))>
</cfif>

<cfif 'CLV' is '#Left(aVisitorOff[hh][3],3)#'>
	<cfset #aVisitorOff[hh][3]# = 'CLE ' & trim(right(aVisitorOff[hh][3],2))>
</cfif>

<cfif 'HST' is '#Left(aVisitorOff[hh][3],3)#'>
	<cfset #aVisitorOff[hh][3]# = 'HOU ' & trim(right(aVisitorOff[hh][3],2))>
</cfif>


Checking 'ARI' vs '#trim(Left(aVisitorOff[hh][3],4))#'<br>
<cfif 'ARI' is '#trim(Left(aVisitorOff[hh][3],3))#'>
	Yes for ARI, just set to 
	<cfset #aVisitorOff[hh][3]# = 'ARZ ' & trim(right(aVisitorOff[hh][3],2))>
	Yes for ARI, just set to #aVisitorOff[hh][3]#<br>
</cfif>

<cfif 'JAC' is '#Left(aVisitorOff[hh][3],3)#'>
	<cfset #aVisitorOff[hh][3]# = 'JAX ' & trim(right(aVisitorOff[hh][3],2))>
</cfif>


<cfif '*BLT' is '#Left(aVisitorOff[hh][3],4)#'>
	<cfset #aVisitorOff[hh][3]# = '*BAL ' & trim(right(aVisitorOff[hh][3],2))>
</cfif>

<cfif '*SL' is '#Left(aVisitorOff[hh][3],3)#'>
	<cfset #aVisitorOff[hh][3]# = '*STL ' & trim(right(aVisitorOff[hh][3],2))>>
</cfif>

<cfif '*CLV' is '#Left(aVisitorOff[hh][3],4)#'>
	<cfset #aVisitorOff[hh][3]# = '*CLE ' & trim(right(aVisitorOff[hh][3],2))>>
</cfif>

<cfif '*HST' is '#Left(aVisitorOff[hh][3],4)#'>
	<cfset #aVisitorOff[hh][3]# = '*HOU ' & trim(right(aVisitorOff[hh][3],2))>>
</cfif>

<cfif '*ARI' is '#Left(aVisitorOff[hh][3],4)#'>
	<cfset #aVisitorOff[hh][3]# = '*ARZ ' & trim(right(aVisitorOff[hh][3],2))>>
</cfif>

<cfif '*JAC' is '#Left(aVisitorOff[hh][3],4)#'>
	<cfset #aVisitorOff[hh][3]# = '*JAZ ' & trim(right(aVisitorOff[hh][3],2))>>
</cfif>



<cfif 'BLT' is '#Left(aVisitorDef[hh][3],3)#'>
	<cfset #aVisitorDef[hh][3]# = 'BAL ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif 'SL' is '#Left(aVisitorDef[hh][3],2)#'>
	<cfset #aVisitorDef[hh][3]# = 'STL ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif 'CLV' is '#Left(aVisitorDef[hh][3],3)#'>
	<cfset #aVisitorDef[hh][3]# = 'CLE ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif 'HST' is '#Left(aVisitorDef[hh][3],3)#'>
	<cfset #aVisitorDef[hh][3]# = 'HOU ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif 'ARI' is '#Left(aVisitorDef[hh][3],3)#'>
	<cfset #aVisitorDef[hh][3]# = 'ARZ ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif 'JAC' is '#Left(aVisitorDef[hh][3],3)#'>
	<cfset #aVisitorDef[hh][3]# = 'JAX ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>



<cfif '*BLT' is '#Left(aVisitorDef[hh][3],4)#'>
	<cfset #aVisitorDef[hh][3]# = '*BAL ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif '*SL' is '#Left(aVisitorDef[hh][3],3)#'>
	<cfset #aVisitorDef[hh][3]# = '*STL ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif '*CLV' is '#Left(aVisitorDef[hh][3],4)#'>
	<cfset #aVisitorDef[hh][3]# = '*CLE ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif '*HST' is '#Left(aVisitorDef[hh][3],4)#'>
	<cfset #aVisitorDef[hh][3]# = '*HOU ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif '*ARI' is '#Left(aVisitorDef[hh][3],4)#'>
	<cfset #aVisitorDef[hh][3]# = '*ARZ ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>

<cfif '*JAC' is '#Left(aVisitorDef[hh][3],4)#'>
	<cfset #aVisitorDef[hh][3]# = '*JAX ' & trim(right(aVisitorDef[hh][3],2))>
</cfif>


</cfoutput>
</cfloop>


<!--- 
        1 = start time
		2 = time of pos on drive
		3 = starting position (i.e Cin 30)
		4 = # of plays
		5 = yards on drive
		6 = result
		7 = drive number
		
 --->		
<cfloop index="hh" from="1" to="#mytotct#">

<cfoutput>
		
	<cfif myha is 'H'>	
		<cfset myha = 'A'>	
	<cfelse>
		<cfset myha = 'H'>	
	</cfif>
		
	<!--- Stats are for the Away team --->	
	<cfif iii is 1>	
		
	<cfquery datasource="psp_psp" name="Addit">
	Insert into DriveCharts
	(Team,
	ha,
	opp,
	Week,
	DriveNumber,
	TimeRcd,
	TimeLost,
	TimePoss,
	HowBallObtained,
	DriveBegan,
	NumPlays,
	YdsGained,
	YdsPen,
	NetYds,
	FstDown,
	DriveEnd,
	Result,
	DriveType)
	Values(
	
	'#awayteam#',
	'A',
	'#hometeam#',
	#week#,
	'#aVisitorOff[hh][7]-1#',
	'#aVisitorOff[hh][1]#',
	'0',
	'#aVisitorOff[hh][2]#',
	'',
	'#aVisitorOff[hh][3]#',
	'#aVisitorOff[hh][4]#',
	'#aVisitorOff[hh][5]#',
	'0',
	'#aVisitorOff[hh][5]#',
	'0',
	'',
	'#aVisitorOff[hh][6]#',
	'O')
	</cfquery>

	<cfset mynextha = 'H'>
	<cfif myha is 'H'>
		<cfset mynextha = 'A'>
	</cfif> 
	
	<cfquery datasource="psp_psp" name="Addit">
	Insert into DriveCharts
	(Team,
	ha,
	opp,
	Week,
	DriveNumber,
	TimeRcd,
	TimeLost,
	TimePoss,
	HowBallObtained,
	DriveBegan,
	NumPlays,
	YdsGained,
	YdsPen,
	NetYds,
	FstDown,
	DriveEnd,
	Result,
	DriveType)
	Values(
	
	'#hometeam#',
	'H',
	'#awayteam#',
	#week#,
	'#aHomeDef[hh][7]-1#',
	'#aHomeDef[hh][1]#',
	'0',
	'#aHomeDef[hh][2]#',
	'',
	'#aHomeDef[hh][3]#',
	'#aHomeDef[hh][4]#',
	'#aHomeDef[hh][5]#',
	'0',
	'#aHomeDef[hh][5]#',
	'0',
	'',
	'#aHomeDef[hh][6]#',
	'D')
	</cfquery>

	<cfelse>
	
	<cfquery datasource="psp_psp" name="Addit">
	Insert into DriveCharts
	(Team,
	ha,
	opp,
	Week,
	DriveNumber,
	TimeRcd,
	TimeLost,
	TimePoss,
	HowBallObtained,
	DriveBegan,
	NumPlays,
	YdsGained,
	YdsPen,
	NetYds,
	FstDown,
	DriveEnd,
	Result,
	DriveType)
	Values(
	
	'#hometeam#',
	'H',
	'#awayteam#',
	#week#,
	'#aHomeOff[hh][7]-1#',
	'#aHomeOff[hh][1]#',
	'0',
	'#aHomeOff[hh][2]#',
	'',
	'#aHomeOff[hh][3]#',
	'#aHomeOff[hh][4]#',
	'#aHomeOff[hh][5]#',
	'0',
	'#aHomeOff[hh][5]#',
	'0',
	'',
	'#aHomeOff[hh][6]#',
	'O')
	</cfquery>

	<cfset mynextha = 'H'>
	<cfif myha is 'H'>
		<cfset mynextha = 'A'>
	</cfif> 
	
	<cfquery datasource="psp_psp" name="Addit">
	Insert into DriveCharts
	(Team,
	ha,
	opp,
	Week,
	DriveNumber,
	TimeRcd,
	TimeLost,
	TimePoss,
	HowBallObtained,
	DriveBegan,
	NumPlays,
	YdsGained,
	YdsPen,
	NetYds,
	FstDown,
	DriveEnd,
	Result,
	DriveType)
	Values(
	
	'#awayteam#',
	'A',
	'#hometeam#',
	#week#,
	'#aVisitorDef[hh][7]-1#',
	'#aVisitorDef[hh][1]#',
	'0',
	'#aVisitorDef[hh][2]#',
	'',
	'#aVisitorDef[hh][3]#',
	'#aVisitorDef[hh][4]#',
	'#aVisitorDef[hh][5]#',
	'0',
	'#aVisitorDef[hh][5]#',
	'0',
	'',
	'#aVisitorDef[hh][6]#',
	'D')
	</cfquery>
	</cfif>
	
</cfoutput>
</cfloop>

</cfloop>

<cfquery datasource="psp_psp" name="Update">
  Update DriveChartLoadData
  Set PBPLoaded='SUCCESS'
  Where HomeTeam in ('#hometeam#')
  and week = #week#
 </cfquery>


</cfloop>

<cfcatch>
	<cfoutput>
	
	<cfquery datasource="psp_psp" name="debugit2">
		INSERT into DebugPBP(DebugInfo) values('Failed on: #cfcatch.Detail#...#cfcatch.Message#....#cfcatch.tagcontext[1].line#') 
	</cfquery>
	
	<input name="TheMsg" type="hidden" value="There was an error loading PBP line number: #cfcatch.tagcontext[1].line#..for #Statsfor#">
	
	<cfhttp method="Post"
			url="http://www.pointspreadpros.com/psp2012/nfl/admin/EmailNFLDataLoadError.cfm">
	
	<cfhttpparam name="TheMsg" type="FormField" value="There was an error loading PBP line number: #cfcatch.tagcontext[1].line#..#Statsfor#...rowid=#theid#..play=#thedebug#">
	</cfhttp>
	</cfoutput>
</cfcatch>
</cftry>

<cfinclude template="LoadDriveChartData.cfm"> 
