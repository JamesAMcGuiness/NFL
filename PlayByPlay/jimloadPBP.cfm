
<form >

<cfquery datasource="psp_psp" name="GetPBPData">
  Delete From DebugPBP
</cfquery>


<cfset StatsFor = ''>
<cfset form.themsg   = ''>
<cfoutput>
<input name="TheMsg" type="hidden" value="There was an error loading PBP for #Statsfor#">	
</cfoutput>
<cftry>

<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>

<cfset week = GetWeek.week>
 
<cfset session.week = week>
  
 <cfquery datasource="psp_psp" name="Update">
  Update PbPData
  Set Team = 'BAL'
  Where Team = 'BLT'
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPData
  Set opponent = 'BAL'
  Where opponent = 'BLT'
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPData
  Set Team = 'CLE'
  Where Team = 'CLV'
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPData
  Set opponent = 'CLE'
  Where opponent = 'CLV'
 </cfquery>
 
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPData
  Set opponent = 'ARZ'
  Where opponent = 'ARI'
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPData
  Set Team = 'ARZ'
  Where Team = 'ARI'
 </cfquery>
 
 <!--- <cfquery datasource="psp_psp" name="Update">
  Update PbPData
  Set opponent = 'JAX'
  Where opponent = 'JAC'
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPData
  Set Team = 'JAX'
  Where Team = 'JAC'
 </cfquery>
  --->

 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPTendencies
  Set Week = 1
  Where Week = 0
    
 </cfquery>
 
 
<cfquery name="GetFirstGame" datasource="psp_psp">
	Select HomeTeam
	From DriveChartLoadData
	Where PbPLoaded = 'C' 
	and week = #Session.week#
</cfquery>


<cfif GetFirstGame.recordcount is 0>

 <cfabort>

<cfelse>
	<cfset usethis = GetFirstGame.HomeTeam>
	<cfif GetFirstGame.HomeTeam is 'JAC'>
		<cfset usethis = 'JAX'>
	</cfif>

	<cfif GetFirstGame.HomeTeam is 'ARI'>
		<cfset usethis = 'ARZ'>
	</cfif>

</cfif>

<cfquery name="GetSpds" datasource="nflspds" >
SELECT *
FROM nflspds
WHERE week = #Session.week#
AND (FAV = '#usethis#' or UND = '#usethis#')
</cfquery>
 
<cfif GetSpds.recordcount is 0>

<cfabort>
</cfif>

<cfloop query="Getspds">
 
 <cfset myfav = "#trim(Getspds.fav)#">
 <cfset myund = "#trim(GetSpds.und)#">
 <cfset ha = "#GetSpds.ha#">
 <cfset spd = "#GetSpds.spread#">

 <cfquery name="Addit" datasource="psp_psp" >
  DELETE FROM PBPTendencies
  WHERE week = #Session.Week#
  AND Team in ('#myfav#','#myund#')
</cfquery> 
  
 <cfif ha is 'H'>
  <cfset hometeam = myfav>
  <cfset awayteam = myund>
 </cfif>
 
 <cfif ha is 'A'>
  <cfset hometeam = myund>
  <cfset awayteam = myfav>
 </cfif>
  
 <cfoutput>
 <cfquery datasource="psp_psp" name="GetPBPData">
  Select *
  from PBPData
  Where Team in ('#trim(hometeam)#','#trim(awayteam)#')
  and week = #Session.week#
  and OffDef='O'
  
  order by id
 </cfquery>
 </cfoutput>
 
 <cfoutput>
 <br>
 <br>
 <br>
 <br>
 ******************************* Starting data for: #hometeam# vs #awayteam# <br>
 </cfoutput>
 
 
 
 <!-- Run Play? -->
  <cfset Run1 = 'left tackle'>
  <cfset Run2 = 'right tackle'>
  <cfset Run3 = 'left guard'>
  <cfset Run4 = 'right guard'>
  <cfset Run5 = 'up the middle'>
  <cfset Run6 = 'kneels'>
  <cfset Run7 = 'left end'>
  <cfset Run8 = 'right end'>
 
 <!-- Pass Play? -->
  <cfset Pass1 = 'pass intended'>
  <cfset Pass2 = 'pass to'>
  <cfset Pass3 = 'pass incomplete'>
  
  <cfset Pass4 = 'pass deep right'>
  <cfset Pass5 = 'pass deep left'>
  <cfset Pass6 = 'pass deep middle'>
 
  <cfset Pass7 = 'pass short right'>
  <cfset Pass8 = 'pass short left'>
  <cfset Pass9 = 'pass short middle'>
  <cfset Pass10 = 'sacked'>
  <cfset Pass11 = 'complete'>
  <cfset Pass12 = 'incomplete'>
  
  
  
  
  <cfset PlayType = ''>
  <cfset FirstDashPos = 0>
  <cfset NextDashPos = 0>
  <cfset DownLen = 0> 
   
  <cfset Down = 0>
  <cfset ToGo = 0>
  <cfset Where = ''>
  <cfset Session.SessToGo = ''>  
	
 <cfoutput query="GetPBPData">
 
	<cfquery datasource="psp_psp" name="debugit2">
	INSERT into DebugPBP(DebugInfo) values('Trying to load id:#id#...#Play#') 
	</cfquery>

 <p>
  id is: #id#...play is=========================>#play#...#id#<br>
  <cfset theid = #id#>
  <cfset thedebug = '#play#'>
 <p>
  <cfset Pts = 0>	
  <cfset yds = 0>
  <cfset Statsfor = '#trim(Team)#'>
  <cfset Done = false>
  <cfset PlayDesc = '#Play#'>
  
  <cfset valtoreplace = Replace('#PlayDesc#','Barnyard','','All')>
  <cfset PlayDesc = '#valtoreplace#'>

  <cfquery datasource="psp_psp" name="debugit">
	INSERT into DebugPBP(DebugInfo) values('Start try to load') 
	</cfquery>
 
  <cfquery datasource="psp_psp" name="debugit">
	INSERT into DebugPBP(DebugInfo) values('With any massaging..#PlayDesc#') 
	</cfquery>
  
  <cfset Direction = ''>
 
  <cfif not Done>
 
   <!-- PENALTY -->
   <cfif find('PENALTY','#ucase(play)#')>
	<cfif find('NO PLAY','#ucase(play)#')>
		<cfset PlayType = 'Penalty'>
		<cfset Done = true>
		*********************Found NO PLAY for #play#<br>
	<cfelse>
		
	</cfif>	
   </cfif>
 
  </cfif>
 
  <cfif not Done>
 
   <!-- Extra Point -->
   <cfif findnocase('EXTRA POINT IS GOOD','#ucase(play)#')>
    <cfset PlayType = 'Point After'>
    <cfset Done = true>
   </cfif>
 
   <cfif findnocase('EXTRA POINT IS NO GOOD','#ucase(play)#')>
    <cfset PlayType = 'Point After'>
    <cfset Done = true>
   </cfif>
 
  </cfif>

  <cfif not Done>
 
   <!-- FGA -->
   <cfif findnocase(ucase('field goal is GOOD'),ucase('#play#'))>
    <cfset PlayType = 'FGA'>
    <cfset Direction = 'Made'>
    <cfset Done = true>
    <cfset yds = 0>  
	
<!---     <cfset ForPos=find("for",'#play#')> 
    <cfif ForPos neq 0>
     <cfset YardPos=find("yard",'#play#')> 
     <cfif YardPos neq 0>
      <cfset yds = val(mid('#play#',ForPos + 3,yardpos - (Forpos + 3)))>
     </cfif>
    </cfif>  --->
   </cfif>
  
   <cfif findnocase(ucase('field goal is no good'),ucase('#play#'))>
    <cfset PlayType = 'FGA'>
    <cfset Done = true>
    <cfset Direction = 'Missed'>
    <cfset Yds = 0>   
<!---     <cfset ForPos=find("for",'#play#')> 
      <cfif ForPos neq 0>
       <cfset YardPos=find("yard",'#play#')> 
      
       <cfif YardPos neq 0>
      
        <cfset yds = val(mid('#play#',ForPos + 3,yardpos - (Forpos + 3)))>
      
       </cfif>
          
      </cfif> 
 --->    
    
   </cfif>
   
  </cfif>
  
  <cfif not Done> 
  <!-- Punt -->
   <cfif find('punts','#play#')>
    <cfset PlayType = 'Punt'>
    <cfset Done = true>
   </cfif>
  </cfif>
   
 
 
 
 
  <!-- Sack -->
  <cfif find('sacked','#play#') neq 0>
   
   <cfset PlayType = 'Sack'>
   <cfset Done = true>
 
   <cfset ForPos=find("for ",'#play#')> 
   <cfif ForPos neq 0>
    <cfset YardPos=find("yard",'#play#')> 
    <cfif YardPos neq 0>
     <cfset yds = val(mid('#play#',ForPos + 3,yardpos - (Forpos + 3)))>
    </cfif>
   </cfif> 
   
  </cfif>
 
 
  <cfif not Done>
 
   <!-- Pass Play -->
   <cfloop index="ii" from="1" to="12">
       
    <cfif findnocase('INTERCEPTED','#play#') eq 0>
     <cfset Pass = 'Pass' & '#ii#'>
     <cfset check = evaluate('#pass#')>
 
     <cfif findnocase('#check#','#play#')>
      <cfset PlayType = 'Pass'>
      <cfset Done = true>
      <cfset Yds = 0> 
	  
      <cfset ForPos=find("for ",'#play#')> 
      
	   <!--- See if play was a TD... --->	
	  <cfif findnocase('Touchdown','#play#') gt 0>	
		<cfset yds = Session.SessToGo>
		<cfset ForPos = 0>
		<cfset YardsPos = 0>	
	  </cfif>	
	  
	  <!--- If FOR X Yards is found...--->
	  <cfif ForPos neq 0>
       <cfset YardPos=find("yard",'#play#')> 
      
       <cfif YardPos neq 0>
        <cfset yds = val(mid('#play#',ForPos + 3,yardpos - (Forpos + 3)))>
       </cfif>
      </cfif> 


	 
	  
     </cfif>
  
  
  
    <cfelse>
    
    
     <cfset PlayType = 'Interception'>
     <cfset Done = true>
     <cfset Yds = 0> 
    
    </cfif>
    
   </cfloop>
  </cfif>
  
  
 
  
  
  <cfif not done>
   <cfset PlayType = 'Other'>
   <cfset Direction = ''>
  </cfif>
  
  <cfset findhometeam = hometeam>
  <cfset findawayteam = awayteam>
  
  <cfif findhometeam is 'ARZ'>
	<cfset findhometeam = 'ARI'>
  </cfif>

  <cfif findawayteam is 'ARZ'>
	<cfset findawayteam = 'ARI'>
  </cfif>

  


  
  
   <!-- Situation? -->
   <cfset homesit = '-' & '#findhometeam#'>
   <cfset awaysit = '-' & '#findawayteam#'>
 

  Looking for the Hometeam team now....Looking for '#homesit#' in  '#play#'<br>    
   <cfif findnocase('#trim(homesit)#','#play#') gt 0>
   		FOUND #homesit# in the #play#...<br>
   
    <cfset PlayType = 'SIT'>
    <cfset Done = true>
    <cfset Dash = '-'>
   
    <cfset FirstDashPos = Find('#dash#','#play#',1)>
    <cfset NextDashPos = Find('#dash#','#play#',FirstDashPos + 1)>
    <cfset DownLen = (NextDashPos - FirstDashPos) - 1> 
   
    <cfset Down = Left('#play#',1)>
    <cfset ToGo = mid('#play#',FirstDashPos + 1,DownLen)>
    <cfset Where = mid('#play#',NextDashPos + 1,10)>
    <cfset Session.SessToGo =  ToGo> 
	  
	  Down is: #down#<br>
	  ToGo is: #togo#<br>
	  Where is: #where#<br>
		<p>	
			  
   </cfif>
  
  
  
  
  
   Looking for the away team now....Looking for '#awaysit#' in  '#play#'<br>    
   <cfif find('#trim(awaysit)#','#play#')>
   
   	   		FOUND #awaysit# in the #play#...<br>
    <cfset PlayType = 'SIT'>
    <cfset Done = true>
       
    <cfset Dash = '-'>
   
    <cfset FirstDashPos = Find('#dash#','#play#',1)>
       
    <cfset NextDashPos = Find('#dash#','#play#',FirstDashPos + 1)>
      
    <cfset DownLen = (NextDashPos - FirstDashPos) - 1> 
   
    <cfset Down = Left('#play#',1)>
    <cfset ToGo = mid(#play#,FirstDashPos + 1,DownLen)>
    <cfset Where = mid(#play#,NextDashPos + 1,10)>
   
	  Down is: #down#<br>
	  ToGo is: #togo#<br>
	  Where is: #where#<br>
	<p>
       
   </cfif>
  
    
<cfif not Done>
 
   <!-- Run Play -->
   <cfloop index="ii" from="1" to="8">
	<cfset PlayType = 'Run'>
	<cfset Direction = 'Unknown'>
	<cfset Done = true>
	
    <cfset run = 'Run' & '#ii#'>
    <cfset check = evaluate('#run#')>
    <!-- Checkin running play #check# in #play#<br> -->
    
    <cfif Find('#check#','#play#') gt 0>
     <cfset done = true>
     
     <cfif ii is 1>
      <cfset Direction = 'Left'>
     </cfif>
     <cfif ii is 2>
      <cfset Direction = 'Right'>
     </cfif>
     <cfif ii is 3>
      <cfset Direction = 'Left'>
     </cfif>
     <cfif ii is 4>
      <cfset Direction = 'Right'>
     </cfif>
     <cfif ii is 5>
      <cfset Direction = 'Middle'>
     </cfif>
     <cfif ii is 6>
      <cfset Direction = 'Middle'>
     </cfif>
     <cfif ii is 7>
      <cfset Direction = 'Left'>
     </cfif>
     <cfif ii is 8>
      <cfset Direction = 'Right'>
     </cfif>
    <cfelse>  
			<cfif Find('for a touchdown','#play#') gt 0>
	
	
	</cfif>
	
	
	
	<p>
	<cfoutput>
	***********************************CHECKING THIS PLAY: #play#
	</cfoutput>
	 
	<p>
	
     <cfset Yds = 0> 
     <cfset ForPos=find("for",'#play#')> 
	 
	 <cfquery datasource="psp_psp" name="debugit2">
		INSERT into DebugPBP(DebugInfo) values('for string found at spot #ForPos#') 
	 </cfquery>
	 
     <cfif ForPos neq 0>
      <cfset YardPos=find("yard",'#play#')> 
      
		
		<cfif findnocase("touchdown",'#play#') gt 0> 
			<cfset yds = #togo#>
			
		<cfelse>
			  <cfif YardPos neq 0>
				<cfquery datasource="psp_psp" name="debugit2">
				INSERT into DebugPBP(DebugInfo) values('YardsPos found at #YardPos#') 
				</cfquery>
				<cfset yds = val(mid('#play#',ForPos + 3,yardpos - (Forpos + 3)))>
			   
				<cfquery datasource="psp_psp" name="debugit2">
				INSERT into DebugPBP(DebugInfo) values('Found YardPos, setting Yds to #yds#') 
				</cfquery>
			  </cfif>
		</cfif>
	 </cfif> 
     </cfif>   
   </cfloop>
  
  </cfif>

  
  <cfset Opp = trim(hometeam)>  
  <cfif trim(Statsfor) is trim(hometeam)>
   <cfset Opp = trim(awayteam)>
  </cfif>
  
  <cfset myfp = 0>
  
  <cfset teamat = val(trim(Right(#Where#,2)))>
  
  The Teamat value is #teamat#<br>
  Checking trim(Left(#Where#,3)) eq '#Statsfor#'<br>

  <cfif trim(Left('#Where#',#Len(statsfor)#)) is '#trim(Statsfor)#'>
   <cfif teamat ge 0 and teamat le 20>
    <cfset myfp = 1>
   </cfif>
  
   <cfif teamat ge 21 and teamat le 39>
    <cfset myfp = 2>
   </cfif>
     
  </cfif>
  
  
  <cfif Trim(Left('#Where#',#len(opp)#)) is '#trim(opp)#'>
   <cfif teamat ge 0 and teamat le 20>
    <cfset myfp = 5>
   </cfif>
  
   <cfif teamat ge 21 and teamat le 39>
    <cfset myfp = 4>
   </cfif>
     
  </cfif>
  
  
  <cfif myfp is 0>
	************************************************ Didn't find it!!!!!!<br>
   <cfset myfp = 3>
  </cfif>
  
   
  <cfset WhichWay = '#Direction#'> 
  <cfquery datasource="psp_psp" name="debugit2">
		INSERT into DebugPBP(DebugInfo) values('Playtype is #PlayType#') 
	</cfquery>
  
  
 <cfif PlayType is 'Interception'>
	<cfset hold = '#opp#'>
	<cfset opp = statsfor>
	<cfset statsfor = hold>
</cfif>	
  
  
  
  
  <cfif PlayType neq 'SIT' and PlayType neq 'Other' and PlayType neq 'Penalty' and (Findnocase('kneels','#play#') is 0)>
    
  <cfquery name="Addit" datasource="psp_psp" >
  Insert into PBPTendencies(Team,
  Down,
  ToGo,
  FieldPosition,
  PlayType,
  Opponent,
  FieldPos,
  Yards,
  Score,
  Direction,
  OffDef,
  week,
  Pts
  
  )
  Values('#Statsfor#',
  #val(down)#,
  #val(ToGo)#,
  '#Where#',
  '#PlayType#',
  '#opp#',
   #val(myfp)#,
  #val(yds)#,
  0,
  '#WhichWay#',
  'O',
  #session.week#,
  #GetPBPData.Pts#
  
  )
  </cfquery>  
  
    <cfquery datasource="psp_psp" name="debugit">
	INSERT into DebugPBP(DebugInfo) values('Successfully stored the offensive row.') 
	</cfquery>
  
  
  <cfquery name="Addit" datasource="psp_psp" >
  Insert into PBPTendencies(Team,
  Down,
  ToGo,
  FieldPosition,
  PlayType,
  Opponent,
  FieldPos,
  Yards,
  Score,
  Direction,
  OffDef,
  week,
  Pts
  )
  Values('#opp#',
  #val(down)#,
  #val(ToGo)#,
  '#Where#',
  '#PlayType#',
  '#statsfor#',
   #myfp#,
  #val(yds)#,
  0,
  '#WhichWay#',
  'D',
  #session.week#,
  #GetPBPData.Pts#
  )
  </cfquery>  
  
    <cfquery datasource="psp_psp" name="debugit">
	INSERT into DebugPBP(DebugInfo) values('Successfully stored the defensive row.') 
	</cfquery>
  
  <cfelse>
	<cfquery datasource="psp_psp" name="debugit">
	INSERT into DebugPBP(DebugInfo) values('Skipped INSERT for id #id#.') 
	</cfquery>

</cfif>
  
  Play by===>#Statsfor#......The PlayType was #PlayType#,down=#down#,togo=#togo#,from=#where#.. The direction was #Direction#, playdesc was: #play#..Yds was: #yds#<br>  
   
 
 </cfoutput>
 <p>
 <p>
 <cfoutput>
  ******************************* Finished data for: #hometeam# vs #awayteam# <br>
 </cfoutput> 
 
 

  
 
</cfloop>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPTendencies
  Set Team = 'BAL'
  Where Team = 'BLT'
    
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPTendencies
  Set opponent = 'BAL'
  Where opponent = 'BLT'
    
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPTendencies
  Set Team = 'JAX'
  Where Team = 'JAC'
    
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPTendencies
  Set opponent = 'JAX'
  Where opponent = 'JAC'
    
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPTendencies
  Set Team = 'ARZ'
  Where Team = 'ARI'
    
 </cfquery>
 
 <cfquery datasource="psp_psp" name="Update">
  Update PbPTendencies
  Set opponent = 'ARZ'
  Where opponent = 'ARI'
    
 </cfquery>


<cfquery datasource="psp_psp" name="Update">
  Select * 
  from PbPTendencies
  Where Team = 'ARZ'
  AND OFFDEF = 'O'
  AND FieldPos in (1,2,3)
  AND LEFT(FieldPosition,3) = 'ARI'
 </cfquery>

<cfoutput query="Update">
<!--- 
#update.team#...#update.opponent#...#update.FieldPos#....#update.FieldPosition#<br>
 --->
<cfset yds = #val(mid(update.fieldposition,4,2))#>

<cfset updateval = 3>
<cfif yds lte 20>
	<cfset updateval = 1>
<cfelseif yds gt 20 and yds lte 40>
	<cfset updateval = 2>
</cfif>

<cfquery datasource="psp_psp" name="Update2">
Update PBPTendencies
SET FieldPos = #updateval#
where id = #Update.id#
</cfquery>

Change value to #updateval#<br>
<p>

</cfoutput>



<cfquery datasource="psp_psp" name="Update">
  Select * 
  from PbPTendencies
  Where Team = 'ARZ'
  AND OFFDEF = 'D'
  AND FieldPos in (1,2,3)
  AND LEFT(FieldPosition,3) = 'ARI'
 </cfquery>

 
<cfoutput query="Update">
<!--- #update.team#...#update.opponent#...#update.FieldPos#....#update.FieldPosition#<br> --->
<cfset yds = #val(mid(update.fieldposition,4,2))#>


<cfset updateval = 3>
<cfif yds lte 20>
	<cfset updateval = 1>
<cfelseif yds gt 20 and yds lte 40>
	<cfset updateval = 2>
</cfif>

<cfquery datasource="psp_psp" name="Update3">
Update PBPTendencies
SET FieldPos = #updateval#
where id = #Update.id#
</cfquery>

<!--- 
Change value to #updateval#<br>
<p>
 --->

</cfoutput>












<cfquery datasource="psp_psp" name="Update">
  Select * 
  from PbPTendencies
  Where Opponent = 'ARZ'
  AND OFFDEF = 'O'
  AND LEFT(FieldPosition,3) = 'ARI'
 </cfquery>

 
<cfoutput query="Update">
<!--- #update.team#...#update.opponent#...#update.FieldPos#....#update.FieldPosition#<br> --->
<cfset yds = #mid(update.fieldposition,4,2)#>

<cfset updateval = 3>
<cfif yds lte 20>
	<cfset updateval = 5>
<cfelseif yds gt 20 and yds lte 40>
	<cfset updateval = 4>
</cfif>

 
<cfquery datasource="psp_psp" name="Update2">
Update PBPTendencies
SET FieldPos = #updateval#
where id = #Update.id#
</cfquery>


<!--- 
Change value to #updateval#<br>
<p>
 --->

</cfoutput>



<cfquery datasource="psp_psp" name="Update">
  Select * 
  from PbPTendencies
  Where Opponent = 'ARZ'
  AND OFFDEF = 'D'
  AND FieldPos in (1,2,3)
  AND LEFT(FieldPosition,3) = 'ARI'
 </cfquery>

 
<cfoutput query="Update">
#update.team#...#update.opponent#...#update.FieldPos#....#update.FieldPosition#<br> 
<cfset yds = #val(mid(update.fieldposition,4,2))#>


<cfset updateval = 3>
<cfif yds lte 20>
	<cfset updateval = 1>
<cfelseif yds gt 20 and yds lte 40>
	<cfset updateval = 2>
</cfif>

</CFOUTPUT>

<cfif 1 is 1>

<cfquery datasource="psp_psp" name="Update4">
Select Id, Id + 1 as rowafter
from PBPTendencies
where Pts = 7
and PlayType = 'Interception'
and OffDef = 'O'
</cfquery> 


<cfloop query = "Update4">

<cfquery datasource="psp_psp" name="Update5">
Update PBPTendencies
Set Pts = 7
where Id = #Update4.Rowafter#
and PlayType = 'Interception'
and OffDef = 'D'
</cfquery> 


<cfquery datasource="psp_psp" name="Update6">
Update PBPTendencies
Set Pts = 0
where Id = #Update4.Id#
and PlayType = 'Interception'
and OffDef = 'O'
</cfquery> 

</cfloop>

</cfif>

<cfquery name="Addit" datasource="psp_psp" >
  Update PBPTendencies
  Set Yards = togo
  where Pts = 7
</cfquery>
<!--- Change value to #updateval#<br>
<p> --->


<cfif 1 is 1> 
<cfinclude template="LinePlayRating.cfm">
</cfif>

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

</form>