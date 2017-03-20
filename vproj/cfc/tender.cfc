<cfcomponent>
	<cffunction name="Save" access="remote" returntype="string" returnformat='json' output="no" hint="Saves a record of payment.">		 
		<cfargument name="amountTendered" type="numeric" default="">
		<cfargument name="orderID" type="numeric" default="">
		<cfargument name="changeGiven" type="numeric" default="">
		<cfargument name="timeStamp" default="">
	
		<cfset var TenderQry= "">
		<cfset var tenderRecordID = {}>
		
		<cftry>
			<cfquery name="TenderQry" datasource="jcp-db">					 
					INSERT INTO [dbo].[TenderRecord](
							[orderID]
						 ,[amountTendered]
						 ,[changeGiven]
						 ,[timeStamp])
					VALUES(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.orderID#">
						 ,<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.amountTendered#">
						 ,<cfqueryparam cfsqltype="cf_sql_float" value="#ARGUMENTS.changeGiven#">
						 ,GetDate())	
				SELECT SCOPE_IDENTITY() as tenderRecordID		 		 					 
			</cfquery>		
			
			<cfset tenderRecord.tenderRecordID = TenderQry.tenderRecordID>
			<cfset tenderRecord.status = 'success'>
			
			<cfcatch type="any">
				<cfset tenderRecord.tenderRecordID = 0>
				<cfset tenderRecord.status = 'failed'>
			</cfcatch>
		</cftry>
		<cfreturn SerializeJSON(tenderRecord,'struct')>
	</cffunction>
</cfcomponent>