<cfquery datasource="psp_psp" name="GetTeams">
Delete from DcFieldPosStartEnd
</cfquery>

<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>

<cfset Session.week = Getweek.week + 1>


<!-- Update the team names with the correct names -->
<cfquery datasource="psp_psp" name="GetTeams">
Select Distinct(Team)
from DriveCharts
</cfquery>

<cfoutput query="GetTeams">

<cfset Fav = '#GetTeams.Team#'>


<cfloop index="fpindex" from="1" to="5">
	<cfset TotalDrives = 0>
	<cfloop index="efpindex" from="1" to="5">
	
		<cfset myqueryname = "oFromFP" & #fpindex# & "To" & #efpindex#>

		<cfquery datasource="psp_psp" name="#myqueryname#">
			Select *
			from DriveCharts
			where team    = '#fav#' 
			and DriveType = 'O'
			and FP  = #fpindex#
			and EFP = #efpindex#
			and week < #Session.week#
			and Result not in ('End of Game','End of Half')
		</cfquery>	
	
		<cfset temp = "#myqueryname#" & ".recordcount">
		<cfset TotalDrives = TotalDrives + #evaluate(temp)#>
		
	</cfloop>
	
	<cfloop index="efpindex" from="1" to="5">
		<cfset myqueryname = "oFromFP" & #fpindex# & "To" & #efpindex#>
		<cfset temp = "#myqueryname#" & ".recordcount">
		
		
		<cfif TotalDrives eq 0>
			<cfset storeit = 0>
		<cfelse>
		
			<cfset storeit = #numberformat(val(evaluate(temp)/TotalDrives)*100,"99.99")#>
		</cfif>
		
			<cfquery datasource="psp_psp" name="Addit">
			Insert into DCFieldPosStartEnd
			(
				Team, 
				OffDeff,
				StartFP,
				EndFPPct,
				EndFp
			)
			Values
			(	
			'#Fav#',
			'O',
			 #fpindex#,
			 #storeit#,
			 #efpindex#
			 )
			</cfquery>
		
	</cfloop>
	<hr>	
	
</cfloop>


<cfloop index="fpindex" from="1" to="5">
	<cfset TotalDrives = 0>
	<cfloop index="efpindex" from="1" to="5">
		<cfset myqueryname = "dFromFP#fpindex#To#efpindex#">

		<cfquery datasource="psp_psp" name="#myqueryname#">
			Select *
			from DriveCharts
			where team    = '#fav#' 
			and DriveType = 'D'
			and FP  = #fpindex#
			and EFP = #efpindex#
			and week < #Session.week#
			and Result not in ('End of Game','End of Half')
		</cfquery>	

		<cfset temp = "#myqueryname#" & ".recordcount">
		<cfset TotalDrives = TotalDrives + #evaluate(temp)#>

		
	</cfloop>
	
	<cfloop index="efpindex" from="1" to="5">
		<cfset myqueryname = "dFromFP" & #fpindex# & "To" & #efpindex#>
		<cfset temp = "#myqueryname#" & ".recordcount">
		
		
		<cfif TotalDrives eq 0>
			<cfset storeit = 0>
		<cfelse>
			<cfset storeit = #numberformat(val(evaluate(temp)/TotalDrives)*100,"99.99")#>
		</cfif>
		#storeit#<br>
		
		
		<cfquery datasource="psp_psp" name="Addit">
			Insert into DCFieldPosStartEnd
			(
				Team, 
				OffDeff,
				StartFP,
				EndFPPct,
				EndFP
			)
			Values
			(	
			'#Fav#',
			'D',
			 #fpindex#,
			 #storeit#,
			 #efpindex#
			 )
		</cfquery>

		
	</cfloop>
	<hr>
	
</cfloop>
</cfoutput>


