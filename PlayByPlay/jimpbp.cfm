




<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>


<cfquery datasource="psp_psp">
	Delete from PbpData
</cfquery>

<cfset Session.week = GetWeek.week>
<!--- 
<cfset Session.week = 99>
 --->


<!--- <cfquery datasource="psp_psp" name="loadit">
	Select StatsFor,OffDef,PlayDesc,opp
	from pbpdata1
	Where week = #Session.week#
</cfquery>

<cfoutput query="loadit">
	<cfquery datasource="psp_psp" name="addit">
	Insert into pbpdata
	(
	Team,
	OffDef,
	Play,
	Opponent,
	Week
	)
	Values
	(
	'#loadit.StatsFor#',
	'#loadit.OffDef#',
	'#loadit.PlayDesc#',
	'#loadit.Opp#',
	#Session.week#
	)
	</cfquery>
</cfoutput>
<cfabort>
 --->
	

<cfset mmdd = '0919'>
<cfset myyear = 2004>
<cfset homelastname = "">


<cfquery name="GetFirstGame" datasource="psp_psp">
	SELECT MIN(HomeTeam) as useHomeTeam
	FROM DriveChartLoadData
	WHERE week = #Session.week#
	and PBPLoaded = 'N' 
</cfquery>

<cfdump var='#GetFirstGame.useHomeTeam#'>


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

<cfquery name="GetSpds" datasource="nflspds" >
SELECT *
FROM nflspds
WHERE week = #Session.week#
AND (FAV = '#usethis#' or UND = '#usethis#')
</cfquery>







<cfloop query="Getspds">


	<cfset myfav = "#Getspds.fav#">
	<cfset myund = "#GetSpds.und#">
	<cfset ha = "#GetSpds.ha#">
	<cfset spd = "#GetSpds.spread#">
	<cfset gameplayed = "#GetSpds.TimeOfGame#">
	
	
	<cfquery datasource="psp_psp">
	Delete from PbpStatlocation where Team in ('#myfav#','#myund#')
	</cfquery>

	<cfquery datasource="psp_psp">
	Delete from PbpData1 where StatsFor in ('#myfav#','#myund#')
	</cfquery>

	
	<cfif ha is 'H'>
		<cfset useteam = myfav>
	<cfelse>
		<cfset useteam = myund>
	</cfif>

	<!-- <cfoutput>
	The team to find is *#useteam#*<br>
	</cfoutput>	 -->
	
	
	
	
	<cfquery name="GetGameURL" datasource="psp_psp">
	SELECT url,id
	FROM DriveChartLoadData
	WHERE week = #Session.week#
	and HomeTeam = '#GetFirstGame.useHomeTeam#'
	</cfquery>



<!--- 	<cfif Getit.recordcount neq 0>
	<cfinclude template="jimloadpbp.cfm">
	<cfabort>
	</cfif>
 --->	
		
	<cfif GetGameURL.recordcount neq 0>
		
		<cfset mygameurl   = GetGameURL.url>
		<cfset myurl       = Replace('#mygameurl#','drivecharts','playbyplay')>

	<cfoutput>
	#myurl#<br>
	#myfav#<br>
	#myund#<br>
	</cfoutput>
		
<cfdump var='#Variables#'>
		
	<cfif ha is 'H'>
		<cfset HomeTeam = myfav>
		<cfset AwayTeam = myUnd>
	<cfelse>
		<cfset HomeTeam = myund>
		<cfset AwayTeam = myfav>
	</cfif>
	
	
	<!-- Add all the team names here -->
	<cfif trim(HomeTeam) is 'NE'>
		<cfset HomeLastName = 'Patriots'>
	</cfif>

	<cfif HomeTeam is 'IND'>
		<cfset HomeLastName = 'Colts'>
	</cfif>

	<cfif trim(HomeTeam) is 'TB'>
		<cfset HomeLastName = 'Buccaneers'>
	</cfif>

	<cfif trim(AwayTeam) is 'TB'>
		<cfset AwayLastName = 'Buccaneers'>
	</cfif>

	<cfif trim(AwayTeam) is 'TEN'>
		<cfset AwayLastName = 'Titans'>
	</cfif>
	
	<cfif trim(HomeTeam) is 'TEN'>
		<cfset HomeLastName = 'Titans'>
	</cfif>


	
	<cfif HomeTeam is 'JAX' or HomeTeam is 'JAC' >
		<cfset HomeLastName = 'Jaguars'>
	</cfif>

	<cfif AwayTeam is 'JAX' or AwayTeam is 'JAC'>
		<cfset AwayLastName = 'Jaguars'>
	</cfif>
	
	
	<cfif trim(awayTeam) is 'NE'>
		<cfset AwayLastName = 'Patriots'>
	</cfif>

	<cfif AwayTeam is 'IND'>
		<cfset AwayLastName = 'Colts'>
	</cfif>


	<cfif HomeTeam is 'PHI'>
		<cfset HomeLastName = 'Eagles'>
	</cfif>

	<cfif AwayTeam is 'PHI'>
		<cfset AwayLastName = 'Eagles'>
	</cfif>

	
	
	<cfif HomeTeam is 'NYG'>
		<cfset HomeLastName = 'Giants'>
	</cfif>
	
	
	<cfif awayTeam is 'MIN'>
		<cfset AwayLastName = 'Vikings'>
	</cfif>

	<cfif HomeTeam is 'MIN'>
		<cfset HomeLastName = 'Vikings'>
	</cfif>


	<cfif awayTeam is 'DET'>
		<cfset AwayLastName = 'Lions'>
	</cfif>

	<cfif HomeTeam is 'DET'>
		<cfset HomeLastName = 'Lions'>
	</cfif>


	<cfif awayTeam is 'CHI'>
		<cfset AwayLastName = 'Bears'>
	</cfif>

	<cfif HomeTeam is 'CHI'>
		<cfset HomeLastName = 'Bears'>
	</cfif>
	
	
	<cfif awayTeam is 'CAR'>
		<cfset AwayLastName = 'Panthers'>
	</cfif>

	<cfif HomeTeam is 'CAR'>
		<cfset HomeLastName = 'Panthers'>
	</cfif>

	<cfif awayTeam is 'CLE'>
		<cfset AwayLastName = 'Browns'>
	</cfif>

	<cfif HomeTeam is 'CLE'>
		<cfset HomeLastName = 'Browns'>
	</cfif>


	<cfif awayTeam is 'BAL'>
		<cfset AwayLastName = 'Ravens'>
	</cfif>

	<cfif HomeTeam is 'BAL'>
		<cfset HomeLastName = 'Ravens'>
	</cfif>

	
	<cfif awayTeam is 'PIT'>
		<cfset AwayLastName = 'Steelers'>
	</cfif>

	<cfif HomeTeam is 'PIT'>
		<cfset HomeLastName = 'Steelers'>
	</cfif>

	<cfif awayTeam is 'DAL'>
		<cfset AwayLastName = 'Cowboys'>
	</cfif>

	<cfif HomeTeam is 'DAL'>
		<cfset HomeLastName = 'Cowboys'>
	</cfif>
	
	<cfif awayTeam is 'WAS'>
		<cfset AwayLastName = 'Redskins'>
	</cfif>

	<cfif HomeTeam is 'WAS'>
		<cfset HomeLastName = 'Redskins'>
	</cfif>
	
	<cfif awayTeam is 'NYG'>
		<cfset AwayLastName = 'Giants'>
	</cfif>

	<cfif HomeTeam is 'NYG'>
		<cfset HomeLastName = 'Giants'>
	</cfif>
	

	<cfif trim(awayTeam) is 'GB'>
		<cfset AwayLastName = 'Packers'>
	</cfif>

	<cfif trim(HomeTeam) is 'GB'>
		<cfset HomeLastName = 'Packers'>
	</cfif>


	<cfif awayTeam is 'ARI'>
		<cfset AwayLastName = 'Cardinals'>
	</cfif>

	<cfif HomeTeam is 'ARI'>
		<cfset HomeLastName = 'Cardinals'>
	</cfif>

	<cfif awayTeam is 'ARZ'>
		<cfset AwayLastName = 'Cardinals'>
	</cfif>

	<cfif HomeTeam is 'ARZ'>
		<cfset HomeLastName = 'Cardinals'>
	</cfif>


	<cfif awayTeam is 'BUF'>
		<cfset AwayLastName = 'Bills'>
	</cfif>

	<cfif HomeTeam is 'BUF'>
		<cfset HomeLastName = 'Bills'>
	</cfif>

	<cfif awayTeam is 'MIA'>
		<cfset AwayLastName = 'Dolphins'>
	</cfif>

	<cfif HomeTeam is 'MIA'>
		<cfset HomeLastName = 'Dolphins'>
	</cfif>

	<cfif awayTeam is 'SEA'>
		<cfset AwayLastName = 'Seahawks'>
	</cfif>

	<cfif HomeTeam is 'SEA'>
		<cfset HomeLastName = 'Seahawks'>
	</cfif>

	<cfif awayTeam is 'NYJ'>
		<cfset AwayLastName = 'Jets'>
	</cfif>

	<cfif HomeTeam is 'NYJ'>
		<cfset HomeLastName = 'Jets'>
	</cfif>

	<cfif awayTeam is 'LAR'>
		<cfset AwayLastName = 'Rams'>
	</cfif>

	<cfif HomeTeam is 'LAR'>
		<cfset HomeLastName = 'Rams'>
	</cfif>

	<cfif trim(awayTeam) is 'KC'>
		<cfset AwayLastName = 'Chiefs'>
	</cfif>

	<cfif trim(HomeTeam) is 'KC'>
		<cfset HomeLastName = 'Chiefs'>
	</cfif>
	
	
	<cfif awayTeam is 'CIN'>
		<cfset AwayLastName = 'Bengals'>
	</cfif>

	<cfif HomeTeam is 'CIN'>
		<cfset HomeLastName = 'Bengals'>
	</cfif>
	
	<cfif awayTeam is 'DEN'>
		<cfset AwayLastName = 'Broncos'>
	</cfif>

	<cfif HomeTeam is 'DEN'>
		<cfset HomeLastName = 'Broncos'>
	</cfif>

	<cfif HomeTeam is 'OAK'>
		<cfset HomeLastName = 'Raiders'>
	</cfif>

	<cfif AwayTeam is 'OAK'>
		<cfset AwayLastName = 'Raiders'>
	</cfif>

	<cfif HomeTeam is 'CAR'>
		<cfset HomeLastName = 'Panthers'>
	</cfif>

	<cfif AwayTeam is 'CAR'>
		<cfset AwayLastName = 'Panthers'>
	</cfif>

	<cfif trim(HomeTeam) is 'SD' or trim(HomeTeam) is 'LAC' >
		<cfset HomeLastName = 'Chargers'>
	</cfif>

	<cfif trim(AwayTeam) is 'SD' or trim(AwayTeam) is 'LAC'>
		<cfset AwayLastName = 'Chargers'>
	</cfif>

	<cfif trim(AwayTeam) is 'HOU'>
		<cfset AwayLastName = 'Texans'>
	</cfif>

	<cfif trim(HomeTeam) is 'HOU'>
		<cfset HomeLastName = 'Texans'>
	</cfif>

	<cfif trim(AwayTeam) is 'NO'>
		<cfset AwayLastName = 'Saints'>
	</cfif>

	<cfif trim(HomeTeam) is 'NO'>
		<cfset HomeLastName = 'Saints'>
	</cfif>

	<cfif trim(AwayTeam) is 'ATL'>
		<cfset AwayLastName = 'Falcons'>
	</cfif>

	<cfif trim(HomeTeam) is 'ATL'>
		<cfset HomeLastName = 'Falcons'>
	</cfif>


	<cfif trim(AwayTeam) is 'SF'>
		<cfset AwayLastName = '49ers'>
	</cfif>

	<cfif trim(HomeTeam) is 'SF'>
		<cfset HomeLastName = '49ers'>
	</cfif>

		
	<cfset Matchup = '#awayteam#' & '@' & '#hometeam#'>

	<cfoutput>
	#myurl#
	</cfoutput>		

	<cfoutput>
		<cfhttp url="#myurl#" method="GET">
		</cfhttp> 
	</cfoutput>

	<cfset mypage = #cfhttp.FileContent#>
	
<!--- 
	<cfoutput>
	
	#mypage#
	</cfoutput>
 --->
	
	
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
	
	<cfif awayteam is 'ARI' or awayteam is 'ARZ'>
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
		<cfset awaytmlong = 'Rams'>
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
	
	<cfif trim(awayteam) is 'SD' or trim(awayTeam) is 'LAC'>
		<cfset awaytmlong = 'San Diego'>
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
	
	
	<cfif trim(awayteam) is 'NO'>
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
	
	
	<cfif trim(awayteam) is 'GB'>
		<cfset awaytmlong = 'Packers'>
	</cfif>
	
	<cfset Session.HomeTeam = '#hometeam#'>
	<cfset Session.AwayTeam = '#awayteam#'>
		
	<!-- Find the first occurnece of the Home teams name (i.e Patriots at Gillete Stadium -->
	<cfset findit = "#Homelastname#" & " at">
	
	<cfset findhomestats = "#Homelastname#" & " at">
	<cfset findawaystats = "#Awaylastname#" & " at">
	
	<cfset hstats = arraynew(1)>
	<cfset astats = arraynew(1)>
	<cfset mystart = 1>

	<cfset done = false>
	<cfloop condition="done is false">
	
			<cfset lookforbegin = '<td  colspan="2" class="home" align="left">'>
			<cfset FindTeamPos = Find('#lookforbegin#',mypage,mystart)>
			
			<cfoutput>#FindTeamPos#</cfoutput>
			
			<cfif FindTeamPos gt 0>
				<cfquery datasource="psp_psp" name="addit">
				Insert into PbPStatLocation(OffDef,Team,Opp,StatPos) values ('O','#hometeam#','#awayteam#',#FindTeamPos#)
				</cfquery> 
				
			<cfelse>
				<cfset done = true>
			</cfif>
			<cfset mystart = findteampos + 37>
			
			<!-- <cfoutput>#mystart#</cfoutput> -->

	</cfloop>


	

	<cfset mystart = 1>
	<cfset done = false>
	<cfloop condition="done is false">
	
			<cfset lookforbegin = '<td  colspan="2" class="away" align="left">'>
			<cfset FindTeamPos = Find('#lookforbegin#',mypage,mystart)>
			
			<cfif FindTeamPos gt 0>
				<cfquery datasource="psp_psp" name="addit">
				Insert into PbPStatLocation(OffDef,Team,Opp,StatPos) values ('O','#awayteam#','#hometeam#',#FindTeamPos#)
				</cfquery> 
				
			<cfelse>
				<cfset done = true>
			</cfif>
			<cfset mystart = findteampos + 37>
			
	</cfloop>
		
		
	<cfoutput>
	
	<!-- Looking for #findit#<br> -->
	<cfset FindTeamPos = Find('#findit#',mypage)>
- 	Found the team AT position: #FindTEAMPOS#<br> 
	</cfoutput>
	
	
	<!-- See if the home team won the toss and is receiving the ball, if so the home team will be found at 15:00 -->
	<cfoutput>
	<cfset findit = "#homelastname#" & " at 15:00">
	</cfoutput>
	
	<cfoutput>
	<cfset FindTeamPos = Find('#findit#',mypage)>
	</cfoutput>
	
	
 	<cfoutput>FindTeamPos is #FindTeamPos#<br></cfoutput> 
	
	<cfset find3rd = Find("3rd Quarter",mypage)>
		
	<cfset StatsFor = "#awayteam#">
	<cfif FindTeamPos gt 0 and FindTeamPos lt find3rd>
		<cfset StatsFor = "#hometeam#">
	</cfif>
	
	
<!-- 	<cfoutput>Stats are for #statsfor#<br></cfoutput> -->
		
	<cfset findit = "1-10-">
	
<!--- 	<cfset mypage = replace('#mypage#','<td width="80">','<td>',"All")> 
	<cfset mypage = replace('#mypage#','<td colspan="3">','<td>',"All")> 
	<cfset mypage = replace('#mypage#','<td class="downText">','<td>',"All")> 
	<cfset mypage = replace('#mypage#','<td colspan="2" class="downTextfull">','<td>',"All")> 
	<cfset mypage = replace('#mypage#','<td class="downInfo">','<td>',"All")> 
	<cfset mypage = replace('#mypage#',"'"," ","All")>  --->
	
	<!-- Find the Away Teams Stats -->
	<cfoutput>
	<cfset FindTeamPos = Find('#findit#',mypage)>
	</cfoutput>

		<cfset arrayteamfor = arraynew(2)>
		<cfset jimct = 0>
		<cfset done = false>
		<cfset mystart = 1>
		<cfset PrevFoundPosend = 0>
		<cfloop condition="done is false">
			<cfoutput>		
			<!-- Jimct = #jimct#		 -->
			</cfoutput>		
			<cfif jimct gt 500>
				<cfset done = true>
			</cfif>
		
			<cfset lookforbegin = '<td  class="row2" align="left">'>
			<cfset lookforbeginlen = len(lookforbegin)>
			<cfset lookforend = '</td>'>
			<cfset lookforendlen = len(lookforend)>
			
			<cfset foundposbegin = findnocase('#lookforbegin#','#mypage#',mystart)>
			<cfset foundposend = findnocase('#lookforend#','#mypage#',foundposbegin)>	
	
			<!--- <cfoutput>#mypage#</cfoutput> --->
	

<!-- 			<cfoutput>
			foundposbegin = #foundposbegin#<br>
			foundposend = #foundposend#<br>
			</cfoutput> 
 -->		
			<cfset startFrom = (lookforbeginlen + foundposbegin)>
			<cfset ForALengthOf = foundposend - startFrom>

			<cfset teamstatfor = '#mid(mypage,startfrom,ForALengthOf)#'>

			<cfoutput>statsfor = #statsfor#: Play Desc:#teamstatfor#<br>
						
			<cfif PrevFoundPosEnd lt FoundPosEnd>

				<cfquery datasource="psp_psp" name="checkit">
				Select * from PbPStatlocation 
				where team in ('#hometeam#','#awayteam#') 
				order by statpos desc
				</cfquery>

				<cfset thestatsarefor = ''>
				<cfloop query="checkit">
					<!-- ********************************************************<br>
					We are checking #Checkit.Statpos# versus #FoundPosEnd#<br>
					********************************************************<br> -->
					<cfif #Checkit.Statpos# lt #FoundPosEnd#>
						<cfset thestatsarefor = '#checkit.team#'>	
						<!-- =============================>Found it!...The stats are for #checkit.team#<br> -->
						<cfbreak>		
					</cfif>	
				</cfloop>


			<cfif thestatsarefor is hometeam>
				<cfset theopp1 = awayteam>
				<cfset theopp2 = hometeam>
			<cfelse>
				<cfset theopp1 = hometeam>
				<cfset theopp2 = awayteam>
			</cfif>	
			
<!--- 			<cfswitch expression="#hometeam"
			<cfcase>
			
			</cfcase>
 --->			
			<cfset myplaydesc = replace(teamstatfor,'-JAC','-JAX','ALL')>
			<cfset myplaydesc = replace('#myplaydesc#','Barnyard','','ALL')>	
				
				
			<cfoutput>
			<cfquery datasource="psp_psp" name="addit">
			Insert into PbPData1(HomeTeam,AwayTeam,PlayDesc,FoundPosEnd,week,StatsFor,OffDef,opp) values ('#hometeam#','#awayteam#','#myplaydesc#',#foundposend#,#Session.week#,'#thestatsarefor#','O','#theopp1#')
			</cfquery>
			
			<cfif ThestatsAreFor is '#hometeam#'>
				<cfset ThestatsAreFor = '#awayteam#'>
			<cfelse>
				<cfset ThestatsAreFor = '#hometeam#'>
			</cfif>
			
			<cfquery datasource="psp_psp" name="addit">
			Insert into PbPData1(HomeTeam,AwayTeam,PlayDesc,FoundPosEnd,week,StatsFor,OffDef,opp) values ('#hometeam#','#awayteam#','#myplaydesc#',#foundposend#,#Session.week#,'#thestatsarefor#','D','#theopp2#')
			</cfquery>

			
			
			
			</cfoutput>
			</cfif>
			#homelastname#<br>
			#awaylastname#<br>
			
			</cfoutput>
		
			<cfset statsforha = ''>
			<cfif findnocase('#hometeam#',teamstatfor) gt 0>
				<cfset statsforha = 'H'>
			</cfif>
		
			<cfif findnocase('#awayteam#',teamstatfor) gt 0>
				<cfset statsforha = 'A'>
			</cfif>
			
			<cfif statsforha neq ''>
				<cfset jimct = jimct + 1>	
				<cfoutput>
				<!--- <font color="red"> #teamstatfor#</font><br> --->
				<cfset arrayteamfor[jimct][1] = "#statsforha#">
				<cfset arrayteamfor[jimct][2] = #foundposbegin#>
				</cfoutput>
			</cfif>
			
			<cfset mystart = startfrom>
			
			
			<cfif FoundPosend lt PrevFoundPosend>
				<cfset done = true>
			<cfelse>
				<cfset PrevFoundPosend = FoundPosend>
			</cfif>
		</cfloop>
		
		<cfquery datasource="psp_psp" name="bigchange">
				Select id,PlayDesc from pbpdata1
		</cfquery>

		<cfoutput query="bigchange">
			<cfset myplaydesc = '#bigchange.playdesc#'>
			<cfif findnocase('-JAC',#bigchange.PlayDesc#) gt 0>
				<cfset myplaydesc = replace(#bigchange.PlayDesc#,'-JAC','-JAC ','ALL')>
			</cfif>

			<cfquery datasource="psp_psp">
			Update pbpdata1 set Playdesc = '#myplaydesc#'
			where id = #bigchange.id#
			</cfquery>
		
		
			<!--- For all accepted penalties remove the down and distance from the load... --->
			<cfif FindNoCase('Penalty','#myplaydesc#') GT 0>
				<cfif FindNoCase('declined','#myplaydesc#') is 0>
						<cfquery datasource="psp_psp">
						Update pbpdata1 set LoadIt = 'N'
						where id in(#bigchange.id# - 1, #bigchange.id# - 2) 
						</cfquery>
				</cfif>
			</cfif>
		
		
		</cfoutput>
	
	<cfif 1 neq 1>
	
		<!-- Remove all the data prior to the Away Teams data -->
<!--- 		<cfset mysmallpage = RemoveChars(mypage,1,FindTeamPos - 1)> --->
		
		<!-- Mypage should now have just the Drive Chart stats  -->
		<!--- <cfset mypage = mysmallpage> --->
	
		<cfset Team = Mid(mypage,6,3)>
		
		
		<!---  
		**************************************************************************************************************************************
	
	
		**************************************************************************************************************************************
		--->
		<cfset hct = 0>
		<cfset act = 0>	
		<cfset done        = false>
		<cfset aAwayOff    = arraynew(2)>
		<cfset aHomeDef    = arraynew(2)>
		<cfset aAwayDef    = arraynew(2)>
		<cfset aHomeOff    = arraynew(2)>
	
		<cfloop index="i" from="1" to="50">
			<cfloop index="j" from="1" to="13">
				<cfset aAwayOff[#i#][#j#] = " ">
				<cfset aHomeDef[#i#][#j#]    = " ">
				<cfset aAwayDef[#i#][#j#] = " ">
				<cfset aHomeOff[#i#][#j#]    = " ">
			</cfloop>
		</cfloop>
		
		<cfset Statct  = 0>
		<cfset mystart = 1>
		<cfset myorigstart = mystart>
		
		<cfset j       = 1>
		<cfset StatsForOtherTeam = false>


		<cfloop condition="done is false">
	
			<!-- Find the <td> just before the value you want to grab -->
			<cfset lookforbegin    = '<td>'>
			<cfset lookforbeginlen = len(lookforbegin)>
		
		
			<cfoutput>
		
			<cfset foundposbegin = findnocase('#lookforbegin#','#mypage#',mystart)>
		
			<!-- If the <TD> found is passed the Visitors Drive Chart then -->
			
			<!-- Start Processing HOME stats -->
			
<!-- 			=======>foundposbegin = #foundposbegin#    -->
			<CFSET mystart = foundposbegin>
	
			<!-- Find the </td> just after the value you want to grab -->
			<cfset lookforend = '</td>'>
			<cfset lookforendlen = len(lookforend)>
			<cfset foundposend = findnocase('#lookforend#','#mypage#',mystart)>
<!-- 		 	=======>foundposend = #foundposend#  -->
		
			</cfoutput>
			
			<!-- Load the stat into an array -->
			<cfif foundposbegin neq 0 and foundposend neq 0>
		
				<cfoutput>
		
				<cfset statct = statct + 1>
			
				<!-- Create new row when done processing all the columns -->
			
			
				<cfset startFrom = (lookforbeginlen + foundposbegin)>
				<cfset ForALengthOf = foundposend - startFrom>
				<cfoutput>
<!-- 				start from = #startFrom#<br>
				ForALengthOf = #ForALengthOf#<br>
 -->				</cfoutput>

				<cfset mystatsfor = "">
				
				<cfloop index="ii" from="2" to="#arraylen(arrayteamfor)/2#">
				
<!-- 					======================> checking #FoundPosBegin# vs  #arrayteamfor[ii][2]#<br> -->
					<cfif FoundPosBegin le arrayteamfor[ii][2]>
						<cfif arrayteamfor[ii - 1][1] is 'H'>
							<cfset mystatsFor = hometeam>
						<cfelse>
							<cfset mystatsFor = awayteam>
						</cfif>
						<cfbreak>
					</cfif>	
				</cfloop>

		<!--- 		<cfif hometeam is 'ARZ'>
					<cfset hometeam = 'ARI'>
				</cfif>
			 		 
				<cfif hometeam is 'JAX'>
					<cfset hometeam = 'JAC'>
				</cfif>
					
				<cfif awayteam is 'ARZ'>
					<cfset awayteam = 'ARI'>
				</cfif>
			 		 
				<cfif awayteam is 'JAX'>
					<cfset awayteam = 'JAC'>
				</cfif>	 
		 --->			 
					 
					 
				<cfif trim(myStatsFor) is '#trim(hometeam)#' and '#trim(mid(mypage,startfrom,ForALengthOf))#' neq '<div class="hSpacer10px"></div>'>
					
					<cfset aHomeOff[j][statct] = '#mid(mypage,startfrom,ForALengthOf)#'>
					<cfset aAwayDef[j][statct] = '#mid(mypage,startfrom,ForALengthOf)#'>
				
					<cfset valtoreplace = '#trim(mid(mypage,startfrom,ForALengthOf))#'>
	<!--- 				<cfset chgit = replace('#valtoreplace#','JAC','JAX')>	
					<cfset chgit = replace('#valtoreplace#','ARI','ARZ')>	
	 --->				
					<cfset valtoreplace = Replace('#valtoreplace#','yard difference','','All')>
					<cfset valtoreplace = Replace('#valtoreplace#','yard differences','','All')>
					<cfset valtoreplace = Replace('#valtoreplace#','yards difference','','All')>
					<cfset valtoreplace = Replace('#valtoreplace#','Barnyard','','All')>	
	
					<cfquery name="Addit" datasource="psp_psp" >
					Insert Into PBPData
					(Team,
					Play,
					Week,
					OffDef,
					Opponent
					)
					Values
					(
					'#hometeam#',
					'#valtoreplace#',
					#Session.week#,
					'O',
					'#awayteam#'
					)
					</cfquery>
					
					
					<cfquery name="Addit" datasource="psp_psp" >
					Insert Into PBPData
					(Team,
					Play,
					Week,
					OffDef,
					Opponent
					)
					Values
					(
					'#awayteam#',
					'#valtoreplace#',
					#Session.week#,
					'D',
					'#hometeam#'
					)
					</cfquery>
				
					<!-- #hometeam#=========>#aHomeOff[j][statct]#<BR> -->
			
				<cfelseif '#trim(mid(mypage,startfrom,ForALengthOf))#' neq '<div class="hSpacer10px"></div>'>>
			    
				
					<cfset aHomeDef[j][statct] = '#mid(mypage,startfrom,ForALengthOf)#'>
					<cfset aAwayOff[j][statct]    = '#mid(mypage,startfrom,ForALengthOf)#'>
<!-- 					#awayteam#=========>#aAwayOff[j][statct]#<br> -->


					<cfset valtoreplace = '#trim(mid(mypage,startfrom,ForALengthOf))#'>
					<cfset valtoreplace = Replace('#valtoreplace#','yard difference','','All')>
					<cfset valtoreplace = Replace('#valtoreplace#','yard differences','','All')>
					<cfset valtoreplace = Replace('#valtoreplace#','yards difference','','All')>
					<cfset valtoreplace = Replace('#valtoreplace#','Barnyard','','All')>
					
					
					
<!--- 					<cfset chgit = replace('#valtoreplace#','JAC','JAX')>	
					<cfset chgit = replace('#valtoreplace#','ARI','ARZ')>	
 --->
			
					<cfquery name="Addit" datasource="psp_psp" >
						Insert Into PBPData
						(Team,
						Play,
						Week,
						OffDef,
						Opponent
						)
						Values
						(
						'#awayteam#',
						'#valtoreplace#',
						#Session.week#,
						'O',
						'#hometeam#'
						)
					</cfquery>
						
						
					<cfquery name="Addit" datasource="psp_psp" >
						Insert Into PBPData
						(Team,
						Play,
						Week,
						OffDef,
						Opponent
						)
						Values
						(
						'#hometeam#',
						'#valtoreplace#',
						#Session.week#,
						'D',
						'#awayteam#'
						)
					</cfquery>
				
				</cfif>
			
			
				<cfset mystart = (foundposend + lookforendlen) - 1>
		
<!-- 		 		Next Start is: #mystart#<br>  -->
			
						
				</cfoutput>
			
				<cfif statct ge 3>
					<cfset j = j + 1>
					<cfset statct = 0>
				
				<!--- <cfif StatsForHome is false>
					<cfset act = act + 1>
				<cfelse>
					<cfset hct = hct + 1>
				</cfif> --->
				
				</cfif>
			
			
			<cfelse>
				<cfset done = true>
	
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
	
	
		<cfquery datasource="psp_psp" name="GetPBPData">
			Select *
			from PBPData
			Where Team in ('#hometeam#','#awayteam#')
			and week = #Session.week#
		</cfquery>
	
	
		<!-- Run Play? -->
		<cfset Run1 = 'left tackle'>
		<cfset Run2 = 'right tackle'>
		<cfset Run3 = 'left guard'>
		<cfset Run4 = 'right guard'>
		<cfset Run5 = 'up the middle'>
		<cfset Run6 = 'kneels'>
		<cfset Run7 = 'left end'>
		<cfset Run7 = 'right end'>
	
		<!-- Pass Play? -->
		<cfset Pass1 = 'pass intended'>
		<cfset Pass2 = 'pass to'>
		<cfset Run3 = 'pass incomplete'>
		<cfset Run4 = 'right guard'>
		<cfset Run5 = 'sacked'>
			
		<cfoutput query="GetPBPData">
			<cfset Done = false>
			<cfset PlayDesc = '#Play#'>
		
			<cfset PlayDesc = Replace('#PlayDesc#','yard difference','','All')>
			<cfset PlayDesc = Replace('#PlayDesc#','yard differences','','All')>
			<cfset PlayDesc = Replace('#PlayDesc#','yards difference','','All')>
	
		
			<!-- Situation? -->
			<cfset homesit = '-' & '#hometeam#'>
			<cfset awaysit = '-' & '#awayteam#'>
		
			<cfif find('#homesit#','#play#')>
				<cfset PlayType = 'SITH'>
				<cfset Done = true>
			</cfif>
		
			<cfif not Done>
		
				<cfif find('#awaysit#','#play#')>
					<cfset PlayType = 'SITA'>
					<cfset Done = true>
				</cfif>
		
			</cfif>
	
	
			<cfif not Done>
	
				<!-- Run Play -->
				<cfloop index="ii" from="1" to="6">
					<cfset run = 'Run' & '#ii#'>
					<cfset check = evaluate('#run#')>
				
					<cfif Find(#check#,#play#) gt 0>
						<cfset PlayType = 'Run'>
				
					</cfif>
				
				
				</cfloop>
	
	
			</cfif>
			
	
		</cfoutput>

			<cfoutput>
			<cfquery name="Getit" datasource="psp_psp">
			Insert into LoadStats
			(Load_Type, 
			week,
			Load_Id)
			values
			(
			'PBP',
			#week#,
			#GetGameURL.id#
			)
			</cfquery>
			</cfoutput>
		
	
	<cfelse>
		<cfoutput>
		*************************************
		No stats loaded for: myurl is #myurl#
		*************************************
		<br>
		</cfoutput>
	</cfif>

</cfif>

</cfloop>



<cfquery datasource="psp_psp" name="bigchange">
	Select id,PlayDesc from pbpdata1 
	where OffDef = 'O'
	AND week     = #Session.week#
	and Statsfor in ('#hometeam#','#awayteam#')
	order by id
</cfquery>

<cfoutput query="bigchange">
			<cfset myplaydesc = '#bigchange.playdesc#'>
		
			<!--- For all accepted penalties remove the down and distance from the load... --->
			<cfif FindNoCase('Penalty','#myplaydesc#') GT 0>
				<cfif FindNoCase('declined','#myplaydesc#') is 0>
						<cfquery datasource="psp_psp">
						Update pbpdata1 set LoadIt = 'N'
						where id in(#bigchange.id# - 1, #bigchange.id# - 2, #bigchange.id# + 1, #bigchange.id#) 
						</cfquery>
				</cfif>
			</cfif>
</cfoutput>	


<cfquery datasource="psp_psp" name="loadit">
	Select StatsFor,OffDef,PlayDesc,opp,id
	from pbpdata1
	Where week = #Session.week#
	and Statsfor in ('#hometeam#','#awayteam#')
	and LoadIt = 'Y'
	order by id
</cfquery>

<cfoutput query="loadit">
	<cfset myPlayDesc = '#loadit.PlayDesc#'>
	<cfset myPlayDesc = Replace('#myPlayDesc#','yard difference','','All')>
	<cfset myPlayDesc = Replace('#myPlayDesc#','yard differences','','All')>
	<cfset myPlayDesc = Replace('#myPlayDesc#','yards difference','','All')>
	<cfset myPlayDesc = Replace('#myPlayDesc#','Barnyard','','All')>
		
	<cfset pts = 0>
	============================================> checking #loadit.playdesc#========================================================<br>
	
	<cfif find('TOUCHDOWN','#ucase(loadit.PlayDesc)#') gt 0>
		<cfset pts = 7>
	</cfif>
	
	<cfif find('FIELD GOAL IS GOOD','#ucase(loadit.PlayDesc)#') gt 0>
		<cfset pts = 3>
	</cfif>
	
	
	<cfquery datasource="psp_psp" name="addit">
	Insert into pbpdata
	(
	Team,
	OffDef,
	Play,
	Opponent,
	Week,
	pbpdata1id,
	Pts
	)
	Values
	(
	'#loadit.StatsFor#',
	'#loadit.OffDef#',
	'#myPlayDesc#',
	'#loadit.Opp#',
	#Session.week#,
	#loadit.id#,
	#pts#
	)
	</cfquery>
	
	
	
</cfoutput>

<cfquery datasource="psp_psp" name="addit">
DELETE FROM pbpdata
WHERE Play Like '%kneels%'
</cfquery>

		

<cfquery name="updGetGameURL" datasource="psp_psp">
	Update DriveChartLoadData
	Set PbPLoaded = 'C' 
	WHERE week = #Session.week#
	and HomeTeam = '#GetFirstGame.useHomeTeam#'
</cfquery>

<cfinclude template="jimLoadPBP.cfm">
