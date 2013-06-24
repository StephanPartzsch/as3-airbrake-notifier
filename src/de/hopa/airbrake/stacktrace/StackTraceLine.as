package de.hopa.airbrake.stacktrace
{
	public class StackTraceLine
	{
		public var file : String = "";
		public var number : String = "";
		public var method : String = "";

		public function toString() : String
		{
			var result : String = file + "." + method;
			
			if ( number != "" ) 
				result += ": " + number;
		
			return result;
		}
	}
}