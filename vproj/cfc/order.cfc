<cfcomponent>
	<cffunction name="Create"  access="remote" returntype="string" returnformat='json' output="no" hint="Creates an order">					
		<cfargument name="args" type="array" required="yes">
		
		<cfset order = {}>
		<cfset var orderID = 0>
		<cfset var orderQry = ''>
		<cfset var orderNumber = 0>
		<cfset var subTotal = 0 >
		<cfset var totalTax = GetTax()>
		<cfset var grandTotal = 0>
		
		<cfloop from="1" to="#ArrayLen(ARGUMENTS.args)#" index="num">		
			<cfset subTotal = subTotal + (ARGUMENTS.args[num].qty * ARGUMENTS.args[num].price)>						
		</cfloop>
		
		<cfset grandTotal = subTotal  + (subTotal * (totalTax / 100))>	
		<cfset orderNumber = GetOrderNumber()>		
		
		<cfquery name="orderQry" datasource="jcp-db">
			INSERT INTO [dbo].[Order]
					 ([orderNumber]
					 ,[subTotal]
					 ,[totalTax]
					 ,[grandTotal]
					 ,[timestamp])
			VALUES
					 (<cfqueryparam value="#orderNumber#" cfsqltype="cf_sql_numeric">
					 ,<cfqueryparam value="#subTotal#" cfsqltype="cf_sql_float">
					 ,<cfqueryparam value="#totalTax#" cfsqltype="cf_sql_float"> 
					 ,<cfqueryparam value="#grandTotal#" cfsqltype="cf_sql_float"> 
					 ,GetDate())
			SELECT SCOPE_IDENTITY() as orderID		 
		</cfquery>			
		
		<cfset AddItem(args = ARGUMENTS.args,oid = orderQry.orderID)>	
		<cfset order.orderID = orderQry.orderID>
		<cfset order.orderNumber = orderNumber>
		
		<cfreturn SerializeJSON(order,'struct')>
	</cffunction>
	
	<cffunction name="AddItem" access="public" returntype="void" output="no" hint="Adds an item to an order">		
		<cfargument name="args"  required="yes">		
		<cfargument name="oid" type="numeric" required="yes">
				
		<cfset var OrderItemQry = ''>				
		<cfloop from="1" to="#ArrayLen(ARGUMENTS.args)#" index="num">
			<cfif ARGUMENTS.args[num].qty NEQ 0>			
				<cfquery name="OrderItemQry" datasource="jcp-db">
					INSERT INTO [dbo].[OrderLineItem](
										[itemID]
									 ,[orderID]
									 ,[qty]		
							 )
					VALUES(
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.args[num].itemID#">
								 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.oid#">
								 ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.args[num].qty#">
						)		
					</cfquery>
				</cfif>
		</cfloop>			
	</cffunction>	
	
	<cffunction name="RemoveItem" access="remote" returntype="string" output="no" hint="Removes an Item from the order">				
		<cfargument name="orderList" type="numeric" required="yes" hint="list of ids that should remain in the order">
		<!-----get a list of id values and anything that isn't in the list should be deleted from orderlineitem----->
		<cfset var DeleteOrderQry = ''>				
		<cfquery name="DeleteOrderQry" datasource="jcp-db">
			DELETE FROM  [dbo].[OrderLineItem]
			WHERE itemID NOT IN (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.itemID#">)
		</cfquery>	
		<cfreturn DeleteOrderQry>				
	</cffunction>	
	
	<cffunction name="GetOrderNumber" access="public" returntype="any" output="no" hint="Gets the last recorded order number">	
		<cfset var OrderNumQry = ''>
		<cfset var orderNumber = ''>
		<cfset var UpdateOrderQry = ''>
		
		<cfquery name="OrderNumQry" datasource="jcp-db">
			SELECT TOP 1 ISNULL(NULLIF(orderNumber,''),0) orderNumber 
			FROM [Order]		
			ORDER BY orderNumber DESC
		</cfquery>
		
		<!--------If tempNum is equal to 100 then reset to 1 otherwise we can just increment the order number by 1------>	
		<cfif OrderNumQry.recordcount EQ 0>
			<cfset orderNumber = 1>
		<cfelseif OrderNumQry.orderNumber EQ 100>
			<cfset orderNumber = 1>
		<cfelse>	
			<cfset orderNumber = OrderNumQry.orderNumber + 1>	
		</cfif>

		<cfreturn orderNumber>
	</cffunction>
	
	<cffunction name="UpdateQty"  access="remote" returntype="string" returnformat='json' output="no" hint="Updates Quantity">		
		<cfargument name="args" type="array" required="yes">
		<cfargument name="orderID" type="numeric" required="yes">
 		
		<cfset var order = {}>
		<cfset var UpdateQtyQry = ''>
		<cfset var OrderItemQry = ''>
		<cfset var subTotal = 0 >
		<cfset var totalTax = GetTax()>
		<cfset var grandTotal = 0>		
		<cfset var itemList = ''>	
				
		<cfquery name="OrderItemQry" datasource="jcp-db">
			SELECT itemID FROM OrderLineItem WHERE orderID = #ARGUMENTS.orderID# 
		</cfquery>		
		
		<cfset itemList = ValueList(OrderItemQry.itemID)>
						
		<cfloop from="1" to="#ArrayLen(ARGUMENTS.args)#" index="num">		
			<cfif ARGUMENTS.args[num].qty NEQ 0 AND itemList CONTAINS ARGUMENTS.args[num].itemID>
				<cfquery name="OrderItemQry" datasource="jcp-db">
					UPDATE [dbo].[OrderLineItem]															 
					SET [qty] = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.args[num].qty#">
					WHERE itemID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ARGUMENTS.args[num].itemID#">
				</cfquery>							
				<cfset subTotal = subTotal + (ARGUMENTS.args[num].qty * ARGUMENTS.args[num].price)>				
			<cfelseif ARGUMENTS.args[num].qty NEQ 0 AND itemList DOES NOT CONTAIN ARGUMENTS.args[num].itemID>	
				<cfset AddItem(args= ARGUMENTS.args,oid = orderID)>
			</cfif>
			<cfif ARGUMENTS.args[num].qty EQ 0 >
					<cfquery name="OrderItemQry" datasource="jcp-db">
						DELETE FROM OrderLineItem WHERE orderID = #ARGUMENTS.orderID# AND itemID = #ARGUMENTS.args[num].itemID#
					</cfquery>				
			</cfif>	
		</cfloop>		
		
		<cfset grandTotal = subTotal  + (subTotal * (totalTax / 100))>	
		
		<cfquery name="UpdateOrderQry" datasource="jcp-db">
			UPDATE [dbo].[Order]
			SET   [subTotal] = #subTotal#
					 ,[totalTax] = #totalTax#
					 ,[grandTotal] = #grandTotal#
					 ,[timestamp] = GetDate()
			WHERE orderID = #ARGUMENTS.orderID#		 
		</cfquery>			
		
		<cfset order.orderID = ARGUMENTS.orderID>		
		
		<cfreturn SerializeJSON(order,'struct')>
	</cffunction>	
	
	<cffunction name="GetTax" access="public" output="no" returntype="numeric">
		<cfset SalesTaxQry = ''>
		
		<cfquery name="SalesTaxQry" datasource="jcp-db">
			SELECT rate
			FROM SalesTaxRate
			WHERE description = 'CA'
		</cfquery>
		<cfreturn SalesTaxQry.rate>
	</cffunction>
	
	<cffunction name="Form" access="public" returntype="string" output="no" hint="The Order Form">
		<cfset var html = ''>
		<cfset var count  = 1>
		<cfset var items = CreateObject('component','item').Get()>		
		
		<cfsavecontent variable="html">
			<div class="row orderBoxBorder" >
				<div class="col-md-12" style="margin-bottom:1em;">					
					<div class="row" style="margin-bottom:1em; margin-top:1em;">
						<div class="col-md-2 col-md-offset-10">
							<button type="button" id="orderBtn" class="form-control btn btn-default">Place Order</button>
						</div>
					</div>
					<div class="row">
						<div class="col-md-10">
							<div class="row" style="margin-bottom:1em;">	
								<div class="col-md-10">
								<cfoutput query="items">																							
									<button type="button" class="lineItems btn btn-default">#items.name#</button>															
									<span class="lineItemPrice lineItemDetails">#items.price#</span>
									<span class="lineItemID lineItemDetails">#items.itemID#</span>									
									<cfif count EQ 5 AND  items.currentrow NEQ items.recordcount>	
										</div></div><div class="row" style="margin-bottom:1em;"><div class="col-md-10">								
										<cfset count = 0>
									<cfelseif items.currentrow EQ items.recordcount> 	
										</div>
									</cfif>
								<cfset count = count + 1>
							</cfoutput>
							</div>		
						</div>						
						<div class="col-md-2">
							<div class="row">
								<div class="col-md-12 text-center">
									<label id="orderNumberLbl"></label>
								</div>
							</div>		
							<div class="row">
								<div class="well" id="orderBox">					
										<span id="lineItemSection"></span>	
										<hr/>								
										<p>Subtotal:&nbsp;&nbsp;<span id="subTotal"></span></p>
										<p>Sales Tax:&nbsp;&nbsp;<span id="salesTax">$7.25</span></p>
										<p>Grand Total:&nbsp;&nbsp;<span id="grandTotal"></span></p>							
								</div>			
							</div>
							<div class="row">			
								<div class="col-md-4">
									<button type="button" name="voidBtn" id="voidBtn" class="btn btn-default" id="">Void</button>
								</div>
								<div class="col-md-5">
									<button type="button" id="payNow" class="btn btn-default" data-toggle="modal" data-target="#tenderBox">Pay Now</button>
								</div>						
							</div>					
						</div>				
					</div>
				</div>
			</div>
					
						
			<div class="modal fade" id="tenderBox" tabindex="-1" role="dialog">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-header" style="background-color:#FF4500; color:#FFF;">
							<button type="button" class="close cancelBtn" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
							<h4 class="modal-title text-center">Tender Payment</h4>
						</div>
						<div class="modal-body">
							<div class="row">
								<div class="col-md-4 ">
									<label>Amount Due:</label>
								</div>
								<div class="col-md-2 text-left">
									<label id="amountDue"></label>
								</div>								
							</div>	
							<div class="row">
								<div class="col-md-4 ">
									<label>Amount Tendered:</label>
								</div>
								<div class="col-md-2 text-left">
									<input type="text" class="form-control input-sm" maxlength="6" name="tAmount" id="tAmount" value="">
								</div>								
							</div>							
							<div class="row">
								<div class="col-md-4 ">
									<label>Change Due:</label>
								</div>
								<div class="col-md-2 text-left">
									<label id="changeDue"></label>
								</div>															
							</div>					
						</div>								
						<div class="modal-footer">
							<button type="button" class=" cancelBtn btn btn-default" data-dismiss="modal">Cancel</button>
							<button type="button" id="tSale" class="btn btn-default">Tender</button>
						</div>
					</div><!-- /.modal-content -->
				</div><!-- /.modal-dialog -->
			</div><!-- /.modal -->										

			
		</cfsavecontent>
		<cfreturn html>
	</cffunction>
</cfcomponent>