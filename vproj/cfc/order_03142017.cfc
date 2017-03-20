<cfcomponent>
	<cffunction name="Create"  access="remote" returntype="string" output="no" hint="Creates an order">		
		<cfargument name="myArgument" type="string" required="yes">
		<cfset myResult="foo">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="AddItem"  access="remote" returntype="string" output="no" hint="Adds an item to an order">		
		<cfargument name="myArgument" type="string" required="yes">
		<cfset myResult="foo">
		<cfreturn myResult>
	</cffunction>	
	
	<cffunction name="RemoveItem"  access="remote" returntype="string" output="no" hint="Removes an Item from the order">		
		<cfargument name="myArgument" type="string" required="yes">
		<cfset myResult="foo">
		<cfreturn myResult>
	</cffunction>	
	
	<cffunction name="UpdateQty"  access="remote" returntype="string" output="no" hint="Updates Quantity">		
		<cfargument name="myArgument" type="string" required="yes">
		<cfset myResult="foo">
		<cfreturn myResult>
	</cffunction>	
	
	<cffunction name="Submit"  access="remote" returntype="string" output="no" hint="Submits the order.">		
		<cfargument name="myArgument" type="string" required="yes">
		<cfset myResult="foo">
		<cfreturn myResult>
	</cffunction>	
	
	<cffunction name="Form" access="public" returntype="string" output="no" hint="The Order Form">
		<cfset var html = ''>
		<cfset var items = CreateObject('component','item').Get()>
		
		<cfsavecontent variable="html">
			<div class="row" style="margin-bottom:1em">
				<div class="col-md-2 col-md-offset-10">
					<button type="button" id="" class="form-control btn btn-default">Order</button>
				</div>
			</div>
			<div class="row">
				<div class="col-md-10">
					<div class="row" style="margin-bottom:1em;">									
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Supreme Pizza</button>
							<span id="" class="lineItemPrice"></span>
						</div>
								
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">BBQ Chicken Pizza</button>
						</div>
		
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Veggie Pizza</button>
						</div>
		
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Meat Lover's Pizza</button>
						</div>
		
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Hawaiian Pizza</button>
						</div>		
					</div>
		
					<div class="row"  style="margin-bottom:1em;">									
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Supreme Pizza</button>
						</div>
								
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">BBQ Chicken Pizza</button>
						</div>
		
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Veggie Pizza</button>
						</div>
		
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Meat Lover's Pizza</button>
						</div>
		
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Hawaiian Pizza</button>
						</div>		
					</div>
					
					<div class="row"  style="margin-bottom:1em;">							
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Supreme Pizza</button>
						</div>
								
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">BBQ Chicken Pizza</button>
						</div>
		
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Veggie Pizza</button>
						</div>
		
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Meat Lover's Pizza</button>
						</div>
		
						<div class="col-md-2">
							<button type="button" id="" class="form-control btn btn-default">Hawaiian Pizza</button>
						</div>		
					</div>						
				</div>
				
				<div class="col-md-2">
					<label>New Order / Order #099</label>
					<div class="row">
						<div class="well" style="border: 1px solid black; min-height:30em">					
								<p id="lineItem"></p>					
								<p style="margin-top: 30em;" id="subTotal">Subtotal:</p>
								<p id="salesTax">Sales Tax:</p>
								<p id="grandTotal">Grand Total:</p>
						</div>	
					</div>
					<div class="row">			
						<div class="col-md-6">
							<button type="button" name="" class="btn btn-default" id="">Void</button>
						</div>
						<div class="col-md-6">
							<button type="button" name="" class="btn btn-default" id="">Pay Now</button>
						</div>						
					</div>					
				</div>				
			</div>
														
		</cfsavecontent>
		<cfreturn html>
	</cffunction>
</cfcomponent>