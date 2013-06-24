package de.hopa.airbrake.stacktrace
{
	public class StackTrace
	{
		public var title : String = "";
		public var message : String = "";
		public var lines : Vector.<StackTraceLine>;
	
		public function StackTrace() 
		{
			lines = new  Vector.<StackTraceLine>();
		}
		
		public function toString() : String
		{
			var result : String = title + ": " + message;
			
			for ( var i : int = 0; i < lines.length; i++ )
				result += "\n\t at " + lines[i];				
			
			return result;
		}
	}
}