<cfscript>
	header  = CreateObject('component','cfc.header').Create();
	content = CreateObject('component','cfc.order').Form();
	footer  = CreateObject('component','cfc.footer').Create();

	WriteOutput(header & content & footer);

</cfscript>

