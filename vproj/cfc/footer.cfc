<cfcomponent>
	<cffunction name="Create" access="public" output="no" returntype="string">
		<cfset var html = ''>
		<cfsavecontent variable="html">
<!---						<div class="page-header">
							<h1>Sticky footer with fixed navbar</h1>
						</div>
						<p class="lead">Pin a fixed-height footer to the bottom of the viewport in desktop browsers with this custom HTML and CSS. A fixed navbar has been added with <code>padding-top: 60px;</code> on the <code>body &gt; .container</code>.</p>
						<p>Back to <a href="../sticky-footer">the default sticky footer</a> minus the navbar.</p>--->
					</div>
			
					<footer class="footer">
						<div class="container">
							<p class="text-muted">&copy 2017 CHESTER'S PIZZERIA, LLC. ALL RIGHTS RESERVED. - PRIVACY</p>
						</div>
					</footer>
			
			
					<!-- Bootstrap core JavaScript
					================================================== -->
					<script src="/vproj/library/jquery/jquery-3.1.1.min.js"></script>
					<!-- Custom CSS brought to you by Eric -->
					<script src="/vproj/js/order.js"></script>
					<!-- Placed at the end of the document so the pages load faster -->
					<script src="/vproj/library/bootstrap/js/bootstrap.min.js"></script>
					<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
					<script src="../../assets/js/ie10-viewport-bug-workaround.js"></script>
					
				</body>
			</html>				
		</cfsavecontent>
		<cfreturn html>
	</cffunction>
</cfcomponent>