package de.hopa.airbrake.example
{
	import de.hopa.airbrake.AirbrakeNotifier;
	import de.hopa.airbrake.stacktrace.StackTraceParser;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;

	public class AirbrakeNotifierExample extends Sprite
	{
		private var airbrakeNotifier : AirbrakeNotifier;

		public function AirbrakeNotifierExample()
		{
			createAirbrakeNotifier();
			createUi();
		}

		private function createAirbrakeNotifier() : void
		{
			airbrakeNotifier = new AirbrakeNotifier( "APP_KEY", AirbrakeNotifier.ENVIRONMENT_TESTING, "APP_VERSION", "HOST_NAME", "PROJECT_ROOT" );

			airbrakeNotifier.addEventListener( Event.COMPLETE, handleSendAirbrakeNotificationComplete );			
			airbrakeNotifier.addEventListener( HTTPStatusEvent.HTTP_STATUS, handleAirbrakeNotificationHttpStatus );			
			airbrakeNotifier.addEventListener( IOErrorEvent.IO_ERROR, handleAirbrakeNotificationIoError );
		}

		private function handleAirbrakeNotificationIoError( event : IOErrorEvent ) : void
		{
			trace( "airbrake io error: " + event.text );
			trace( "reason for io error: " + AirbrakeNotifier( event.target ).currentLoaderResult );
		}

		private function handleAirbrakeNotificationHttpStatus( event : HTTPStatusEvent ) : void
		{
			trace( "airbrake http status: " + event.status );
		}

		private function handleSendAirbrakeNotificationComplete( event : Event ) : void
		{
			trace( "crash report successfully send to airbrake" );
		}

		private function createUi() : void
		{
			var sendButton : Sprite = new Sprite();
			sendButton.graphics.beginFill( 0xff0000, 1 );
			sendButton.graphics.drawRect( 0, 0, 100, 100 );
			sendButton.graphics.endFill();
			sendButton.buttonMode = true;
			sendButton.mouseChildren = false;
			sendButton.addEventListener( MouseEvent.CLICK, handleSendButtonClicked );
			addChild( sendButton );
			
			var textField : TextField = new TextField();
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.text = "Throw Error!";
			textField.x = ( 100 - textField.width ) / 2;
			textField.y = ( 100 - textField.height ) / 2;
			sendButton.addChild( textField );
		}

		private function handleSendButtonClicked( event : MouseEvent ) : void
		{
			try
			{
				throwError();
			}
			catch( error : Error )
			{
				var requestParams : Dictionary = new Dictionary();
				requestParams["ONE"] = "one";
				requestParams["TWO"] = "two";

				airbrakeNotifier.environmentName = AirbrakeNotifier.ENVIRONMENT_PRODUCTION;
				
				airbrakeNotifier.createCrashReport( error.errorID, error.name, error.message, StackTraceParser.parseStackTrace( error.getStackTrace() ) );
				airbrakeNotifier.addRequestInformationsToCrashReport( "RE_URL", "RE_COMPONENT", "RE_ACTION", requestParams );
				airbrakeNotifier.sendCrashReport();
			}
		}

		private function throwError() : void
		{
			throw new ArgumentError( "Test the Airbrake notifier" );
		}
	}
}