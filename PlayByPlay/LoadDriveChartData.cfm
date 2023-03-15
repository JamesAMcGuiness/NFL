
<cfset adrive = arraynew(2)>
<cfset hdrive = arraynew(2)>

<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>


<cfset week = GetWeek.week>




<!--- <cfset week = Session.week>  --->


<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set hometeam = 'ARI'
where hometeam='ARZ'
</cfquery>


<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set hometeam = 'JAC'
where hometeam='JAX'
</cfquery>

<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set awayteam = 'ARI'
where awayteam='ARZ'
</cfquery>


<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set awayteam = 'JAC'
where awayteam='JAX'
</cfquery>


<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set hometeam = 'BAL'
where hometeam='BLT'
</cfquery>

<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set awayteam = 'BAL'
where awayteam='BLT'
</cfquery>



<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set hometeam = 'HOU'
where hometeam='HST'
</cfquery>



<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set awayteam = 'HOU'
where awayteam='HST'
</cfquery>



<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set hometeam = 'CLE'
where hometeam='CLV'
</cfquery>



<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set awayteam = 'CLE'
where awayteam='CLV'
</cfquery>


<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set hometeam = 'LOS'
where hometeam='LOS'
</cfquery>



<cfquery datasource="psp_psp" name="Getit">
Update DriveChartLoadData 
set awayteam = 'LOS'
where awayteam='LOS'
</cfquery>


<cfloop index="xx" from="#week#" to="#week#">
<cfset week = #xx#>


<cfquery datasource="psp_psp" name="Getit">
Select * 
from DriveChartLoadData 
where week = #week#
</cfquery>


<cfloop query="GetIt">

<cfset myHometeam = '#trim(GetIt.HomeTeam)#'>
<cfset myAwayteam = '#trim(GetIt.AwayTeam)#'>

<cfoutput>
At first:<br>
*#myhometeam#*<br
#myawayteam#
</cfoutput>

<cfif trim(myhometeam) is 'ARI' >
	<cfset myhometeam = 'ARZ'>
</cfif> 

<cfif myhometeam is 'JAC' >
	<cfset myhometeam = 'JAX'>
</cfif> 

<cfif myawayteam is 'ARI' >
	<cfset myawayteam = 'ARZ'>
</cfif> 

<cfif myawayteam is 'JAC' >
	<cfset myawayteam = 'JAX'>
</cfif> 



<cfset myurl    = '#GetIt.Url#'>

<cfset efp = 0>
<cfset Drivenum = 0>
<cfoutput>
#myHomeTeam#,#myAwayTeam#<br>
</cfoutput>
---------------------------------------------------------<br>

<!-- Load array of Home and Away Stats -->

<cfquery name="GetAwayStats" datasource="psp_psp">
Select * from drivecharts where Team = '#myAwayteam#'
and week = #week#
and DriveType='O'
</cfquery>



<cfquery name="GetHomeStats" datasource="psp_psp">
Select * from drivecharts where Team = '#myHometeam#'
and week = #week#
and DriveType='O'
</cfquery>



<cfloop index="xx" from="1" to="2">
<cfset loopct = 0>
<cfif xx is 1>
	<cfset DriveFor = 'A'>
	<cfset opp = '#trim(myhometeam)#'>
<cfoutput query="GetAwayStats">
<cfset loopct = loopct + 1>
<cfset aDrive[loopct][1] = '#TimeRcd#'>
<cfset aDrive[loopct][2] = '#TimePoss#'>

<cfif #drivebegan# is '&nbsp;'>
	<cfset aDrive[loopct][3] = '50'>
<cfelse>
	<cfset aDrive[loopct][3] = '#DriveBegan#'>
</cfif>

<cfset aDrive[loopct][4] = '#NumPlays#'>
<cfset aDrive[loopct][5] = '#YdsGained#'>
<cfset aDrive[loopct][6] = '#result#'>
<cfset aDrive[loopct][7] = '#Drivenum#'>
<cfset aDrive[loopct][8] = #id#>
<cfset myid = #id#>
</cfoutput>


<cfelse>
    <cfset DriveFor = 'H'>
	<cfset opp = '#trim(myawayteam)#'>

<cfoutput query="GetHomeStats">
<cfset loopct = loopct + 1>
<cfset hDrive[loopct][1] = '#TimeRcd#'>
<cfset hDrive[loopct][2] = '#TimePoss#'>


<cfif #drivebegan# is '&nbsp;'>
	<cfset hDrive[loopct][3] = '50'>
<cfelse>
	<cfset hDrive[loopct][3] = '#DriveBegan#'>
</cfif>

<cfset hDrive[loopct][4] = '#NumPlays#'>
<cfset hDrive[loopct][5] = '#YdsGained#'>
<cfset hDrive[loopct][6] = '#result#'>
<cfset hDrive[loopct][7] = '#Drivenum#'>
<cfset hDrive[loopct][8] = #id#>
<cfset myid = #id#>
</cfoutput>


</cfif>

<cfset hct = 0>
<cfset act = 0>

<cfset HowObtained="Kickoff">
<cfset done = false>
<cfset hdone = false>
<cfset adone = false>

<cfloop condition="not done">
            <!-- Figure out starting Field Position -->

			
            <cfif DriveFor is 'H' and hdone is false >
                  <cfset hct = hct + 1>
				  <cfif hct ge GetHomeStats.recordcount>
				  	<cfset hdone = true>
				  </cfif>

				<cfset temph = Replace(hdrive[hct][3],'BLT','BAL')>
				<cfset temph = Replace(hdrive[hct][3],'HST','HOU')>
				<cfset temph = Replace(hdrive[hct][3],'SL','STL')>
				<cfset temph = Replace(hdrive[hct][3],'CLV','CLE')>		
				<cfset temph = Replace(hdrive[hct][3],'ARI','ARZ')>	
				<cfset temph = Replace(hdrive[hct][3],'JAC','JAX')>			
			
			<cfoutput>
			temph = #temph#<br>
			</cfoutput>
						
				<cfset hdrive[hct][3] = temph>
							  
                  <cfset team     = Left(trim(hDrive[hct][3]),3)>
                  <cfset yardline = Right(hdrive[hct][3],2)>
                  <cfset result   = trim(hdrive[hct][6])>
       
	        <cfelse>
			
				<cfif adone is false>
                  <cfset act = act + 1>
				  
				  <cfif act ge GetAwayStats.recordcount>
				  	<cfset adone = true>
				  </cfif>
        
				<!--- <cfdump var="#adrive#"> --->
		

					<cfset tempa = Replace(adrive[act][3],'BLT','BAL')>
					<cfset tempa = Replace(adrive[act][3],'HST','HOU')>
					<cfset tempa = Replace(adrive[act][3],'SL','STL')>
					<cfset tempa = Replace(adrive[act][3],'CLV','CLE')>		
					<cfset tempa = Replace(adrive[act][3],'ARI','ARZ')>		
					<cfset tempa = Replace(adrive[act][3],'JAC','JAX')>			
					
					<cfoutput>		
					tempa = #tempa#.....*#adrive[act][3]#*<br>
					</cfoutput>
					<cfset adrive[act][3] = tempa>

		
		          
				  <cfset team     = Left(trim(aDrive[act][3]),3)>
                  <cfset yardline = Right(adrive[act][3],2)>
                  <cfset result   = trim(adrive[act][6])>

				 </cfif> 
            </cfif>

			<cfif yardline is ''>
				<cfset yardline = 20>
			</cfif> 

						
            <cfoutput>
           #myid#==== Team=#team# vs Awayteam=#myawayteam#,HomeTeam=#myHometeam#,DriveFieldSide is #Team#...Yardline is #yardline#...Poss is for #DriveFor#...Obtained by #HowObtained#...Result = #result#
            </cfoutput>

			
            <cfif trim(team) is trim(myAwayTeam) and DriveFor is 'A' or trim(team) is trim(myHomeTeam) and DriveFor is 'H' or trim(team) is '50' >
			1<br>
                        <cfif yardline le 20>

                                    <cfset fp = 1>

                        <cfelseif yardline le 40>

                                    <cfset fp = 2>

                        <cfelse>                        

                                    <cfif yardline le 50>

                                                <cfset fp = 3>

                                    </cfif>   

                        </cfif>

            

            <cfelse>
			2<br>
            <!-- Starting field position is on the opponents side of field -->

                        <cfif yardline le 20>

                                    <cfset fp = 5>

                        <cfelseif yardline le 40>

                                    <cfset fp = 4>

                        <cfelse>

                        

                                    <cfif yardline le 50>

                                                <cfset fp = 3>

                                    </cfif>

                        </cfif>   

            </cfif>               
			<cfoutput>
			The starting FP was #fp#<br>
			<p>
			</cfoutput>


 

            <!--- <cfoutput>

            fp = #fp#<br>

            </cfoutput> --->
           <cfset Drivenum = drivenum + 1>

            <cfif '#trim(result)#' is 'Touchdown' or '#Trim(result)#' is 'Field Goal' or '#Trim(result)#' is 'End of Half' >

                        <cfset HowObtained = 'Kickoff'>

            <cfelse>

                        <cfset HowObtained = '#result#'> 

            </cfif>   

			<cfif DriveFor is 'H'>
					<cfset addit = 0>
					<cfif '#trim(team)#' is '#Trim(myHomeTeam)#' or (fp is 1 or fp is 2)>
						<cfset addit = 0>
					<cfelse>
					
					
						<!--- We are on the opponents side of the field --->
						<cfif fp is 3>
							<cfset addit = (20 - yardline) + 40>
						<cfelseif fp is 4>	
							<cfset addit = (20 - yardline) + 60>
						<cfelseif fp is 5>	
							<cfset addit = (20 - yardline) + 80>
						<cfelse>	
							<cfabort showerror="We have an error setting the FP#fp#">
						</cfif>
					
					</cfif>
					
					
					
					<cfoutput>
					================#hDrive[hct][5]#
					</cfoutput>
					
					<cfif '#team#' is '&nb'>
						<cfset ydsend = 80>
					<cfelse>
						<cfset ydsend = (val(hDrive[hct][5]) + yardline + addit)>
					</cfif>									
					<cfif ydsend ge 0>
						<cfset efp = 1>
					</cfif>
				
					<cfif ydsend ge 20>
						<cfset efp = 2>
					</cfif>
					
					<cfif ydsend ge 40>
						<cfset efp = 3>
					</cfif>
					
					<cfif ydsend ge 60>
						<cfset efp = 4>
					</cfif>	
					
					<cfif ydsend ge 80>
						<cfset efp = 5>
					</cfif>
				
				
			<cfelse>
					<cfset addit = 0>
					<cfif '#trim(team)#' is '#Trim(AwayTeam)#' or (fp is 1 or fp is 2)>
						<cfset addit = 0>
					<cfelse>
						<!--- We are on the opponents side of the field --->
						<cfif fp is 3>
							<cfset addit = (20 - yardline) + 40>
						<cfelseif fp is 4>	
							<cfset addit = (20 - yardline) + 60>
						<cfelseif fp is 5>	
							<cfset addit = (20 - yardline) + 80>
						<cfelse>	
							<cfabort showerror="We have an error setting the FP">
						</cfif>
					</cfif>

					<cfif '#team#' is '&nb'>
						<cfset ydsend = 80>
					<cfelse>	
						<cfset ydsend = (val(aDrive[act][5]) + yardline + addit)>
					</cfif>									
					<cfif ydsend ge 0>
						<cfset efp = 1>
					</cfif>
				
					<cfif ydsend ge 20>
						<cfset efp = 2>
					</cfif>
					
					<cfif ydsend ge 40>
						<cfset efp = 3>
					</cfif>
					
					<cfif ydsend ge 60>
						<cfset efp = 4>
					</cfif>	
					
					<cfif ydsend ge 80>
						<cfset efp = 5>
					</cfif>
			
			</cfif>
					
			<cfoutput>
			********EFP = #efp#.....DriveFieldSide = #team#......ydsend=#ydsend#<br>
			</cfoutput>
			

			<cfif myhometeam is 'ARI' >
				<cfset myhometeam = 'ARZ'>
			</cfif> 
			

			<cfif myawayteam is 'ARI' >
				<cfset myawayteam = 'ARZ'>
			</cfif> 


			<cfif team is 'ARI' >
				<cfset team = 'ARZ'>
			</cfif> 
			
			<!--- <cfoutput>
			 '#AwayTeam#',
            #week#,
            #act#,
            '#aDrive[act][1]#',
            '0',
            '#aDrive[act][2]#',
            '#HowObtained#',
            '#aDrive[act][3]#',
            '#aDrive[act][4]#',
            '#aDrive[act][5]#',
            '0',
            '#aDrive[act][5]#',
            '0',
            '0'',
			'#result#'
            'O'
			</cfoutput>
			<cfabort> --->
			
			
			
			<cfif DriveFor is 'H'>

			
            <cfquery datasource="psp_psp" name="Addit">

            Update DriveCharts
            Set Fp = #fp#,
			efp = #efp#,
			HowBallObtained = ''
			Where id = #hDrive[hct][8]#

            </cfquery>


            <cfquery datasource="psp_psp" name="Addit">
            Update DriveCharts
            Set Fp = #fp#,
			efp = #efp#
			Where id = #hDrive[hct][8]+1#
            </cfquery>

		
		<cfelse>
		
            <cfquery datasource="psp_psp" name="Addit">
            Update DriveCharts
            Set Fp = #fp#,
			efp = #efp#,
			HowBallObtained = ''
			Where id = #aDrive[act][8]#

            </cfquery>

          

            <cfquery datasource="psp_psp" name="Addit">
            Update DriveCharts
            Set Fp = #fp#,
			efp = #efp#
			
			Where id = #aDrive[act][8]+1#
            </cfquery>
		
		
	
		</cfif>
		
        <!--- <cfif DriveFor is 'H' and adone is false>
            <cfset DriveFor = 'A'>
        <cfelse>
			<cfif DriveFor is 'A' and hdone is false>
            	<cfset DriveFor = 'H'>
			</cfif>
        </cfif> --->

		<cfif hdone is true or adone is true>
			<cfset done = true>
		</cfif>

</cfloop>

</cfloop>

</cfloop>

</cfloop>

<cfquery datasource="psp_psp" name="Getit">
Update DataLoadStatus
Set step = 'GAMESIMFIRSTRUN'
</cfquery>

<cfinclude template="UpdateHowBallObtained.cfm"> 
<cfinclude template="Checkpcts.cfm"> 



