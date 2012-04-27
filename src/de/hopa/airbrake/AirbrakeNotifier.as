package de.hopa.airbrake
{
	import de.hopa.airbrake.stacktrace.StackTrace;
	import de.hopa.airbrake.xml.AirbrakeNotifyXmlCreator;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	public class AirbrakeNotifier extends EventDispatcher
	{
		public static const ENVIRONMENT_TESTING: String = "testing";
		public static const ENVIRONMENT_STAGING : String = "staging";
		public static const ENVIRONMENT_PRODUCTION : String = "production";
		
		private static const CRASH_REPORT_URL : String = "http://airbrake.io/notifier_api/v2/notices";
		
		private var airbrakeNotifyXmlCreator : AirbrakeNotifyXmlCreator;
		private var crashReportXml : XML;
		private var request : URLRequest;
		private var loader : URLLoader;

		public function AirbrakeNotifier( appKey : String, environmentName : String = "unset", appVersion : String = "", hostname : String = "", projectRoot : String = "" )
		{
			initializeAirbrakeNotifyXmlCreator( appKey, environmentName, appVersion, hostname, projectRoot );
			initializeUrlLoader();
		}
		
		public function set environmentName( environmentName : String ) : void
		{
			airbrakeNotifyXmlCreator.environmentName = environmentName;
		}
		
		public function get currentLoaderResult() : String
		{
			return loader.data;
		}
		
		public function createCrashReport( errorID : int, errorName : String, errorMessage : String, stackTrace : StackTrace = null ) : void
		{
			crashReportXml = airbrakeNotifyXmlCreator.createNotifyXml( errorID, errorName, errorMessage, stackTrace );
		}
		
		public function addRequestInformationsToCrashReport( requestUrl : String, component : String, action : String = "", requestParams : Dictionary = null, sessionParams : Dictionary = null, environmentVars : Dictionary = null ) : void
		{
			if( crashReportXml == null )
				throw new IllegalOperationError( "Before execute 'addRequestInformationsToCrashReport' call function 'createCrashReport' first to create a valid crash report xml." );
			
			airbrakeNotifyXmlCreator.addRequestInformation( requestUrl, component, action, requestParams, sessionParams, environmentVars );
		}
		
		public function sendCrashReport() : void
		{
			if( crashReportXml == null )
				throw new IllegalOperationError( "Before execute 'sendCrashReport' call function 'createCrashReport' first to create a valid crash report xml." );

			createUrlRequest();
			sendRequest();
			clean();
		}
		
		public function dispose() : void
		{
			disposeUrlLoader();
			
			crashReportXml = null;
			request = null;
			airbrakeNotifyXmlCreator = null;
		}
		
		private function initializeAirbrakeNotifyXmlCreator( appKey : String, environmentName : String, appVersion : String, hostname : String, projectRoot : String ) : void
		{
			airbrakeNotifyXmlCreator = new AirbrakeNotifyXmlCreator( appKey, environmentName );
			
			if( appVersion != "" )
				airbrakeNotifyXmlCreator.appVersion = appVersion;

			if( appVersion != "" )
				airbrakeNotifyXmlCreator.hostname = hostname;

			if( appVersion != "" )
				airbrakeNotifyXmlCreator.projectRoot = projectRoot;
		}

		private function initializeUrlLoader() : void
		{
			loader = new URLLoader();
            loader.dataFormat = URLLoaderDataFormat.TEXT;
 
            loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handleUrlLoaderEvent );
            loader.addEventListener( IOErrorEvent.IO_ERROR, handleUrlLoaderEvent );
            loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, handleUrlLoaderEvent );
            loader.addEventListener( Event.COMPLETE, handleUrlLoaderEvent );
		}

		private function handleUrlLoaderEvent( event : Event ) : void
		{
			dispatchEvent( event ); 
		}
		
		private function createUrlRequest() : void
		{
			request = new URLRequest();
			request.method = URLRequestMethod.POST;
			request.data = [ crashReportXml.toString() ];
			request.url = CRASH_REPORT_URL;			
		}

		private function sendRequest() : void
		{
			loader.load( request );
		}

		private function clean() : void
		{
			request = null;
			crashReportXml = null;
		}
		
		private function disposeUrlLoader() : void
		{
            loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, handleUrlLoaderEvent );
            loader.removeEventListener( IOErrorEvent.IO_ERROR, handleUrlLoaderEvent );
            loader.removeEventListener( HTTPStatusEvent.HTTP_STATUS, handleUrlLoaderEvent );
            loader.removeEventListener( Event.COMPLETE, handleUrlLoaderEvent );
			
			loader = null;
		}
	}
}