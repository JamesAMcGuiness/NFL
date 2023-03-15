<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>

<cfset Session.week = GetWeek.week>

<cfquery name="GetSpds" datasource="nflspds" >
SELECT *
FROM nflspds
WHERE week = #Session.week#
</cfquery>
     


<cfloop query="Getspds">

      
      <cfset myfav = '#fav#'>
      <cfset myund = '#und#'>


 	<cfquery name="GetDriveCtFav" datasource="psp_psp" >
      Update Drivecharts
      Set HowBallObtained = ''
      Where Team = '#myfav#' or Team = '#myund#'
      and Week = #Session.Week#
 	</cfquery>



      
      <!--- Count the number of drives per team --->
      <cfquery name="GetDriveCtFav" datasource="psp_psp" >
      Select Max(DriveNumber) as DriveCt
      from DriveCharts
      Where Team = '#myfav#'
      and DriveType='O'
      and Week = #Session.Week#
      </cfquery>
      
      <!--- Count the number of drives per team --->
      <cfquery name="GetDriveCtUnd" datasource="psp_psp" >
      Select Max(DriveNumber) as DriveCt
      from DriveCharts
      Where Team = '#myund#'
      and DriveType='O'
      and Week = #Session.Week#
      </cfquery>
      

      <cfset loopmax = GetDriveCtUnd.DriveCt>
      <cfif GetDriveCtFav.DriveCt ge GetDriveCtUnd.Drivect>
            <cfset loopmax = GetDriveCtFav.DriveCt>
      </cfif>
    		          
	      <!--- Get the result of the first Drive of the game --->
	      <cfquery name="GetResult" datasource="psp_psp" >
	      Select *
	      from DriveCharts
	      Where TimeRcd='15:00'
	      and DriveType='O'
	      and Week = #Session.Week#
	      and team in ('#myfav#','#myund#')
	      and DriveNumber = 1
	      </cfquery>
            
	  		
	      <!--- Get the result of the first Drive of the third quarter --->
	      <cfquery name="GetResult3rdqtr" datasource="psp_psp" >
	      Select *
	      from DriveCharts
	      Where TimeRcd='15:00'
	      and DriveType='O'
	      and Week = #Session.Week#
	      and team in ('#myfav#','#myund#')
	      and DriveNumber <> 1
	      </cfquery>
		
	<cfloop index="loopct" from="1" to="2">
		
			
	  <cfif loopct is 1>
	  
	  	<cfset start = 1>
	  	<cfset end   = GetResult3rdqtr.Drivenumber -1>	
			
	<cfelse>		
	  	<cfset start = GetResult3rdqtr.Drivenumber>
	  	<cfset end   = loopmax>	
			
	</cfif>
			
      <!--- Determine what to set based on the Result... --->
      <cfif '#GetResult.Result#' is 'Field Goal' or '#GetResult.Result#' is 'Safety' or '#GetResult.Result#' is 'Touchdown' >
            <cfset HowObtained = 'Kickoff'>
      <cfelse>
            <cfset HowObtained = '#GetResult.Result#'>
      </cfif>
      
	  <cfif loopct is 1>
	      <!--- See which Team got the first drive --->
	      <cfset FavGotBallFirst  = false>
	      <cfset TeamToUpdate     = '#myfav#'>      
	      <cfset TeamToUpdateFrom = '#myund#'>
	    	
		  
		
	      <cfif GetResult.Team is '#myfav#'>
	            <cfset TeamToUpdate = '#myund#'>    
	            <cfset FavGotBallFirst = true>
	            <cfset TeamToUpdateFrom = '#myfav#'>

	      </cfif>
		<cfelse>      
	
		      <!--- See which Team got the first drive --->
	      <cfset FavGotBallFirst  = false>
	      <cfset TeamToUpdate     = '#myfav#'>      
	      <cfset TeamToUpdateFrom = '#myund#'>
	    			
	      <cfif GetResult3rdqtr.Team is '#myfav#'>
	            <cfset TeamToUpdate = '#myund#'>    
	            <cfset FavGotBallFirst = true>
	            <cfset TeamToUpdateFrom = '#myfav#'>

	      </cfif>
	
	
	
		</cfif>

		<cfif loopct is 1>
	
            <cfquery name="aGetResult" datasource="psp_psp" >
            Update DriveCharts
			Set HowBallObtained = '#HowObtained#'
            Where Team    ='#TeamToUpdate#'
            and DriveType ='O'
            and Week      = #Session.Week#
            and DriveNumber  = 1
            </cfquery>
      
            <cfquery name="bGetResult" datasource="psp_psp" >
            Update DriveCharts
			Set HowBallObtained = '#HowObtained#'
            Where Team    ='#TeamToUpdateFrom#'
            and DriveType ='D'
            and Week      = #Session.Week#
            and DriveNumber  = 1
            </cfquery>

		<cfelse>	
	
	
	        <cfquery name="aGetResult" datasource="psp_psp" >
            Update DriveCharts
			Set HowBallObtained = '#HowObtained#'
            Where Team    ='#TeamToUpdate#'
            and DriveType ='O'
            and Week      = #Session.Week#
            and DriveNumber  = #GetResult3rdqtr.Drivenumber#
            </cfquery>
      
            <cfquery name="bGetResult" datasource="psp_psp" >
            Update DriveCharts
			Set HowBallObtained = '#HowObtained#'
            Where Team    ='#TeamToUpdateFrom#'
            and DriveType ='D'
            and Week      = #Session.Week#
            and DriveNumber  = #GetResult3rdqtr.Drivenumber#
            </cfquery>
   
		</cfif>
		      
      <!--- Create a loop for the max number of drives  --->
      <cfloop index="ii" from="#start#" to="#end#">
	
            <!--- Get the result of the Drive from the team you just updated --->
            <cfquery name="GetResult" datasource="psp_psp" >
            Select Result
            from DriveCharts
            Where DriveType ='O'
            and Week        = #Session.Week#
            and team        = '#TeamToUpdate#'
            and DriveNumber    = #ii#
            </cfquery>

			<!--- <cfif GetResult.recordcount is 0>
	            <cfquery name="GetResult" datasource="psp_psp" >
	            Select Result
	            from DriveCharts
	            Where DriveType ='O'
	            and Week        = #Session.Week#
	            and team        = '#TeamToUpdate#'
	            and DriveNumber    = #ii#
	            </cfquery>
			</cfif> --->
            
			<cfset nextweek = ii + 1>
			
			<cfoutput>
			The result of drive #ii# was #GetResult.Result#<br>
			</cfoutput>
			
			 <!--- Determine what to set based on the Result... --->
		    <cfif '#GetResult.Result#' is 'Field Goal' or '#GetResult.Result#' is 'Safety' or '#GetResult.Result#' is 'Touchdown' >
            	<cfset HowObtained = 'Kickoff'>
      		<cfelse>
            	<cfset HowObtained = '#GetResult.Result#'>
      		</cfif>
			
			
			<cfoutput>
			Setting How Ball Obtained is: #HowObtained#<br>
			</cfoutput>
			
			
			<cfoutput>
			****The team to update is '#teamtoupdate#'<br>
			
						
			
			
			<!--- Switch to update the next team --->
            <cfif TeamToUpdate is '#myfav#'>    
				  Team to update is the favorite...<br>	
                  <cfset TeamToUpdate    = '#myund#'>
                  <cfset TeamToUpdateFrom = '#myfav#'>
				  Setting Team to Update Now to: #teamtoupdate# <br>
				   Setting Team to Update From Now to: #teamtoupdatefrom# <br>	
				
            <cfelse>    
                  <cfset TeamToUpdate    = '#myfav#'>
                  <cfset TeamToUpdateFrom = '#myund#'>
				Team to update is the underdog...<br>		
				   Setting Team to Update Now to: #teamtoupdate# <br>
				   Setting Team to Update From Now to: #teamtoupdatefrom# <br>	

				
            </cfif> 
			</cfoutput>
			
            <cfquery name="aGetResult" datasource="psp_psp" >
            Update DriveCharts
			Set HowBallObtained = '#HowObtained#'
            Where Team    ='#TeamToUpdate#'
            and DriveType ='O'
            and Week      = #Session.Week#
            and DriveNumber  = #nextweek#
            </cfquery>
	
            <cfquery name="bGetResult" datasource="psp_psp" >
            Update DriveCharts
			Set HowBallObtained = '#HowObtained#'
            Where Team    ='#TeamToUpdateFrom#'
            and DriveType ='D'
            and Week      = #Session.Week#
            and DriveNumber  = #nextweek#
            </cfquery>
            

			
			
			<!--- Get the result of the Drive from the team you just updated --->
            <cfquery name="GetResult" datasource="psp_psp" >
            Select Result
            from DriveCharts
            Where DriveType ='O'
            and Week        = #Session.Week#
            and team        = '#TeamToUpdate#'
            and DriveNumber    = #ii#
            </cfquery>

			 <!--- Determine what to set based on the Result... --->
		    <cfif '#GetResult.Result#' is 'Field Goal' or '#GetResult.Result#' is 'Safety' or '#GetResult.Result#' is 'Touchdown' >
            	<cfset HowObtained = 'Kickoff'>
      		<cfelse>
            	<cfset HowObtained = '#GetResult.Result#'>
      		</cfif>
			
			
			<cfoutput>
			How Ball Obtained is: #HowObtained#<br>
			</cfoutput>
			
			
			<cfoutput>
			****The team to update is '#teamtoupdate#'<br>
			
			<!--- Switch to update the next team --->
            <cfif TeamToUpdate is '#myfav#'>    
				  Team to update is the favorite...<br>	
                  <cfset TeamToUpdate    = '#myund#'>
                  <cfset TeamToUpdateFrom = '#myfav#'>
				  Setting Team to Update Now to: #teamtoupdate# <br>
				   Setting Team to Update From Now to: #teamtoupdatefrom# <br>	
				
            <cfelse>    
                  <cfset TeamToUpdate    = '#myfav#'>
                  <cfset TeamToUpdateFrom = '#myund#'>
				Team to update is the underdog...<br>		
				   Setting Team to Update Now to: #teamtoupdate# <br>
				   Setting Team to Update From Now to: #teamtoupdatefrom# <br>	

				
            </cfif> 
			
			    
			
			</cfoutput>
			
			
            <cfquery name="aGetResult" datasource="psp_psp" >
            Update DriveCharts
			Set HowBallObtained = '#HowObtained#'
            Where Team    ='#TeamToUpdate#'
            and DriveType ='O'
            and Week      = #Session.Week#
            and DriveNumber  = #nextweek#
            </cfquery>
	
            <cfquery name="bGetResult" datasource="psp_psp" >
            Update DriveCharts
			Set HowBallObtained = '#HowObtained#'
            Where Team    ='#TeamToUpdateFrom#'
            and DriveType ='D'
            and Week      = #Session.Week#
            and DriveNumber  = #nextweek#
            </cfquery>
      </cfloop>   
	
	
	</cfloop>
	            
 </cfloop>                       
                        
                        
<cfquery name="GetSpds" datasource="psp_psp" >
Update Drivecharts
set HowBallObtained='Kickoff'
Where TimeRcd = '15:00'
</cfquery>  
