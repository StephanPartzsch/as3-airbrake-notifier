package de.hopa.airbrake.stacktrace
{
	import de.hopa.yaul.text.trim;

	public class StackTraceParser
	{
		public static function parseStackTrace( stackTraceString : String ) : StackTrace
		{
			var data : Array = stackTraceString.split( "	at " );

			var stackTrace : StackTrace = new StackTrace();

			parseErrorTitleAndMessage( data.shift(), stackTrace );

			for ( var i : int = 0; i < data.length; i++ )
			{
				stackTrace.lines.push( parseStackTraceLine( data[i] ) );
			}

			return stackTrace;
		}

		private static function parseErrorTitleAndMessage( input : String, stackTrace : StackTrace ) : void
		{
			var index : int = input.indexOf( ": " );
			stackTrace.title = input.substr( 0, index );
			stackTrace.message = input.substr( index + 2 );
		}

		private static function parseStackTraceLine( lineString : String ) : StackTraceLine
		{
			var stackTraceLine : StackTraceLine = new StackTraceLine();

			var methodNameIndex : int = lineString.indexOf( "/" );
			var methodName : String = lineString.substr( methodNameIndex + 1 );
			var debugIndex : int = methodName.indexOf( "[" );

			stackTraceLine.file = lineString.substr( 0, methodNameIndex );

			if ( debugIndex == -1)
			{
				stackTraceLine.method = trim( methodName );
				stackTraceLine.number = "";
			}
			else
			{
				stackTraceLine.method = methodName.substr( 0, debugIndex );
				stackTraceLine.number = methodName.substring( methodName.lastIndexOf( ":" ) + 1, methodName.lastIndexOf( "]" ) );
			}

			return stackTraceLine;
		}
	}
}