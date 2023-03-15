<cfquery name="GetChartData" datasource="sysstats" >
SELECT gi.*
FROM GameInsights gi
where gi.week = 1
and gi.yr = 2018
order by MOVPlusGameRat desc
</cfquery>

<cfchart 
chartWidth=800
chartHeight=800 
BackgroundColor="##FFFF00" 
show3D="no" 
> 
<cfchartseries 
type="line" 
query="GetChartData" 
valueColumn="Team" 
itemColumn="MOVPlusGameRat" 
/> 
</cfchart> 
<br>