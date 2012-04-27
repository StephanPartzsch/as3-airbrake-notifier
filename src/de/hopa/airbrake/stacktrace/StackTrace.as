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
	}
}