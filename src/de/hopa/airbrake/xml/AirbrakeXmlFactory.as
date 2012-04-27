package de.hopa.airbrake.xml
{
	import de.hopa.airbrake.stacktrace.StackTrace;
	import de.hopa.airbrake.stacktrace.StackTraceLine;

	import flash.utils.Dictionary;
	
	public class AirbrakeXmlFactory
	{
		public static function createXmlRootWithApiKey( version : String, apiKey : String ) : XML
		{
			var notifyXml : XML = createNotifyXml( version );
			
			addApiKeyNode( apiKey, notifyXml );
			
			return notifyXml;
		}

		public static function createNotifierNode( notifierClientName : String, notifierClientVersion : String, notifierClientUrl : String ) : XML
		{
			var notifierNode : XML = new XML( "<notifier/>");

			addNotifierClientName( notifierClientName, notifierNode );
			addNotifierClientVersion( notifierClientVersion, notifierNode );
			addNotifierClientUrl( notifierClientUrl, notifierNode );
			
			return notifierNode;
		}

		public static function createErrorNode( errorId : int, errorName : String, errorMessage : String, stackTrace : StackTrace ) : XML
		{
			var errorNode : XML = new XML( "<error/>" );

			addErrorName( errorName, errorId, errorNode );
			addErrorMessage( errorName + ":" + errorMessage, errorNode );
			addErrorBacktraceNode( stackTrace, errorNode );
		
			return errorNode;
		}

		public static function createServerEnvironmentNode( projectRoot : String, environmentName : String, appVersion : String, hostname : String ) : XML
		{
			var serverEnvironmentNode : XML = new XML( "<server-environment/>" );

			addEnvironmentProjectRoot( projectRoot, serverEnvironmentNode );
			addEnvironmentName( environmentName, serverEnvironmentNode );
			addEnvironmentAppVersion( projectRoot, appVersion, serverEnvironmentNode );
			addEnvironmentHostname( hostname, serverEnvironmentNode );

			return serverEnvironmentNode;
		}
		
		public static function createRequestNode( requestUrl : String, component : String, action : String, requestParams : Dictionary, sessionParams : Dictionary, environmentVars : Dictionary ) : XML
		{
			var requestNode : XML = new XML( "<request/>" );

			addRequestUrl( requestUrl, requestNode );
			addRequestComponent( component, requestNode );
			addRequestAction( action, requestNode );
			addRequestParams( requestParams, requestNode );
			addRequestSessionParams( sessionParams, requestNode );
			addRequestEnvironmentVars( environmentVars, requestNode );

			return requestNode;
		}

		private static function createNotifyXml( version : String ) : XML
		{
			var notifyXml : XML = new XML( "<notice/>" );
			notifyXml.@version = version;
			return notifyXml;
		}

		private static function addApiKeyNode( apiKey : String, notifyXml : XML ) : void
		{
			var apiKeyNode : XML = new XML( "<api-key/>" );
			apiKeyNode.appendChild( apiKey );
			notifyXml.appendChild( apiKeyNode );
		}

		private static function addNotifierClientName( notifierClientName : String, notifierNode : XML ) : void
		{
			var nameNode : XML = new XML( "<name/>" );
			nameNode.appendChild( notifierClientName );
			notifierNode.appendChild( nameNode );
		}

		private static function addNotifierClientVersion( notifierClientVersion : String, notifierNode : XML ) : void
		{
			var versionNode : XML = new XML( "<version/>" );
			versionNode.appendChild( notifierClientVersion );
			notifierNode.appendChild( versionNode );
		}

		private static function addNotifierClientUrl( notifierClientUrl : String, notifierNode : XML ) : void
		{
			var urlNode : XML = new XML( "<url/>" );
			urlNode.appendChild( notifierClientUrl );
			notifierNode.appendChild( urlNode );
		}

		private static function addErrorName( errorName : String, errorId : int, errorNode : XML ) : void
		{
			errorName = ( errorId < 0 ) ? errorName : errorName + "(id: " + errorId + ")";
			
			var classNode : XML = new XML( "<class/>" );
			classNode.appendChild( errorName );
			errorNode.appendChild( classNode );
		}

		private static function addErrorMessage( errorMessage : String, errorNode : XML ) : void
		{
			var messageNode : XML = new XML( "<message/>" );
			messageNode.appendChild( errorMessage );
			errorNode.appendChild( messageNode );
		}

		private static function addErrorBacktraceNode( stackTrace : StackTrace, errorNode : XML ) : void
		{
			var backtraceNode : XML = new XML( "<backtrace/>" );
			errorNode.appendChild( backtraceNode );
			
			var lineNode : XML;
			
			if( stackTrace == null || stackTrace.lines.length <= 0 )
			{
				lineNode = new XML( "<line method='no stack trace found' file='' number=''/> " );
				backtraceNode.appendChild( lineNode );
			}
			else
			{
				for each ( var line : StackTraceLine in stackTrace.lines )
				{
					lineNode = new XML( "<line method='" + line.method + "' file='" + line.file + "' number='" + line.number + "'/> " );
					backtraceNode.appendChild( lineNode );
				}
			}
			
		}

		private static function addEnvironmentProjectRoot( projectRoot : String, serverEnvironmentNode : XML ) : void
		{
			if ( projectRoot == null )
				return;
				
			var projectRootNode : XML = new XML( "<project-root/>" );
			projectRootNode.appendChild( projectRoot );
			serverEnvironmentNode.appendChild( projectRootNode );
		}

		private static function addEnvironmentName( environmentName : String, serverEnvironmentNode : XML ) : void
		{
			var environmentNameNode : XML = new XML( "<environment-name/>" );
			environmentNameNode.appendChild( environmentName );
			serverEnvironmentNode.appendChild( environmentNameNode );
		}

		private static function addEnvironmentAppVersion( projectRoot : String, appVersion : String, serverEnvironmentNode : XML ) : void
		{
			if ( projectRoot == null )
				return;
				
			var appVersionNode : XML = new XML( "<app-version/>" );
			appVersionNode.appendChild( appVersion );
			serverEnvironmentNode.appendChild( appVersionNode );
		}

		private static function addEnvironmentHostname( hostname : String, serverEnvironmentNode : XML ) : void
		{
			if ( hostname == null )
				return;
			
			var hostNameNode : XML = new XML( "<hostname/>" );
			hostNameNode.appendChild( hostname );
			serverEnvironmentNode.appendChild( hostNameNode );
		}

		private static function addRequestUrl( requestUrl : String, requestNode : XML ) : void
		{
			var urlNode : XML = new XML( "<url/>" );
			urlNode.appendChild( requestUrl );
			requestNode.appendChild( urlNode );
		}

		private static function addRequestComponent( component : String, requestNode : XML ) : void
		{
			var componentNode : XML = new XML( "<component/>" );
			componentNode.appendChild( component );
			requestNode.appendChild( componentNode );
		}

		private static function addRequestAction( action : String, requestNode : XML ) : void
		{
			if( action == "" )
				return;
			
			var actionNode : XML = new XML( "<action/>" );
			actionNode.appendChild( action );
			requestNode.appendChild( actionNode );
		}

		private static function addRequestParams( requestParams : Dictionary, requestNode : XML ) : void
		{
			if( requestParams == null )
				return;
			
			var paramsNode : XML = new XML( "<params/>" );
			requestNode.appendChild( paramsNode );

			var requestParamNode : XML;
			for ( var key : String in requestParams )
			{
				requestParamNode = new XML( "<var key='" + key + "'>" + requestParams[key] + "</var>" );
				paramsNode.appendChild( requestParamNode );
			}
		}

		private static function addRequestSessionParams( sessionParams : Dictionary, requestNode : XML ) : void
		{
			if( sessionParams == null )
				return;
			
			var sessionNode : XML = new XML( "<session/>" );
			requestNode.appendChild( sessionNode );

			var sessionParamNode : XML;
			for ( var key : String in sessionParams )
			{
				sessionParamNode = new XML( "<var key='" + key + "'>" + sessionParams[key] + "</var>" );
				sessionNode.appendChild( sessionParamNode );
			}
		}

		private static function addRequestEnvironmentVars( environmentVars : Dictionary, requestNode : XML ) : void
		{
			if( environmentVars == null )
				return;
			
			var cgiDataNode : XML = new XML( "<cgi-data/>" );
			requestNode.appendChild( cgiDataNode );
			
			var environmentVarsNode : XML;
			for ( var key : String in environmentVars )
			{
				environmentVarsNode = new XML( "<var key='" + key + "'>" + environmentVars[key] + "</var>" );
				cgiDataNode.appendChild( environmentVarsNode );
			}
		}
	}
}