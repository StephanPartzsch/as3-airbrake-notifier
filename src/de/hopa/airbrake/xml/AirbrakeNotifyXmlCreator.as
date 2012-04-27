package de.hopa.airbrake.xml
{
	import de.hopa.airbrake.stacktrace.StackTrace;

	import flash.utils.Dictionary;
	
	public class AirbrakeNotifyXmlCreator
	{
		private const API_VERSION : String = "2.0";

		private var notifyXml : XML;
		private var apiKey : String ;
		
		private var _environmentName : String;
		private var _appVersion : String;
		private var _projectRoot : String;
		private var _hostname : String;

		public function AirbrakeNotifyXmlCreator( apiKey : String, environmentName : String )
		{
			this.apiKey = apiKey;
			this._environmentName = environmentName;
		}
		
		public function set environmentName( environmentName : String ) : void
		{
			_environmentName = environmentName;
		}
		
		public function set appVersion( appVersion : String ) : void
		{
			_appVersion = appVersion;
		}
		
		public function get appVersion() : String
		{
			return _appVersion;
		}

		public function set projectRoot( projectRoot : String ) : void
		{
			_projectRoot = projectRoot;
		}

		public function get projectRoot() : String
		{
			return _projectRoot;
		}

		public function set hostname( hostname : String ) : void
		{
			_hostname = hostname;
		}

		public function get hostname() : String
		{
			return _hostname;
		}

		public function createNotifyXml( errorId : int, errorName : String, errorMessage : String, stackTrace : StackTrace ) : XML
		{
			createXMLRoot();
			
			addNotifierNode();
			addErrorNode( errorId, errorName, errorMessage, stackTrace );
			addServerEnvironmentNode();
			
			return notifyXml;
		}

		public function addRequestInformation( requestUrl : String, component : String, action : String = "", requestParams : Dictionary = null, sessionParams : Dictionary = null, environmentVars : Dictionary = null ) : void
		{
			var requestNode : XML = AirbrakeXmlFactory.createRequestNode( requestUrl, component, action, requestParams, sessionParams, environmentVars );
			notifyXml.appendChild( requestNode );
		}

		private function createXMLRoot() : void
		{
			notifyXml = AirbrakeXmlFactory.createXmlRootWithApiKey( API_VERSION, apiKey );
		}
		
		private function addNotifierNode() : void
		{
			var notifierClientName : String = "SPAAS3-Notifier";
			var notifierClientVersion : String = "0.9.0";
			var notifierClientUrl : String = "http://help.airbrake.io/kb/api-2/notifier-api-version-22";
			
			var notifierNode : XML = AirbrakeXmlFactory.createNotifierNode( notifierClientName, notifierClientVersion, notifierClientUrl );
			notifyXml.appendChild( notifierNode );
		}

		private function addErrorNode( errorId : int, errorName : String, errorMessage : String, stackTrace : StackTrace ) : void
		{
			var errorNode : XML = AirbrakeXmlFactory.createErrorNode( errorId, errorName, errorMessage, stackTrace );
			notifyXml.appendChild( errorNode );
		}

		private function addServerEnvironmentNode() : void
		{
			var serverEnvironmentNode : XML = AirbrakeXmlFactory.createServerEnvironmentNode( projectRoot, _environmentName, appVersion, hostname );
			notifyXml.appendChild( serverEnvironmentNode );
		}
	}
}
