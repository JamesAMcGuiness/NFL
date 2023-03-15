
	
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
