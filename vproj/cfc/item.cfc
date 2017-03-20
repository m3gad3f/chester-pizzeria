<cfcomponent>
	<cffunction name="Get" access="public" returntype="query" output="no">		
		<cfset var Items ="">
		<cfquery name="Items" datasource="jcp-db">
			SELECT itemID,name,price
			FROM Item
		</cfquery>
		<cfreturn Items>
	</cffunction>	
</cfcomponent>