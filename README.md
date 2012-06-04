## as3-airbrake-notifier 

The as3-airbrake-notifier sends errors or better said crash reports to [Airbrake](http://airbrake.io). Airbrake receives the error data, collects them and displays them in an nice overview. Simply said it is a crash reporting tool like many others which are used for iOs. But Airbrake has no integration for ActionScript. This gap is filled with the as3-airbrake-notifier and  the usage is very simple. 
A meaningful use case is the combination with the [global error handling](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/UncaughtErrorEvent.html), so that every client error can be detected.
    
* * *
    
    
### Notice

The SWC file of as3-airbrake-notifier requires the as3-yaul SWC to parse the stacktrace. [as3-yaul](https://github.com/StephanPartzsch/as3-yaul) can be found on github too.

* * *
    
    
### Example

####1) Instantiate the notifier.The first two parameters are the most important. 
The first is the application key, which can be found on the left side of the Airbrake project overview (register first). 
The second one describes you environment. One of the three presets (testing, production, live) can be chosen from `AirbrakeNotifier`. Custom names are also supported. If it is not set, it will be 'unset'.
The other parameters are optional and provide more detailed information about the application in which the error occurs.

    airbrakeNotifier = new AirbrakeNotifier( "defbdb1a64105a3c8f64454dbb36b9a3", AirbrakeNotifier.ENVIRONMENT_TESTING, "Application_Version", "Host_Name", "Project_Root" );

####2) Register event listener to check if something went wrong while sending the crash report or if it was finished sucessfully.

    airbrakeNotifier.addEventListener( Event.COMPLETE, handleSendAirbrakeNotificationComplete );			
    airbrakeNotifier.addEventListener( HTTPStatusEvent.HTTP_STATUS, handleAirbrakeNotificationHttpStatus );			
    airbrakeNotifier.addEventListener( IOErrorEvent.IO_ERROR, handleAirbrakeNotificationIoError );
    airbrakeNotifier.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handleAirbrakeSecurityError );
  
####3) Create a standard crash report. If the errorId is negative, the id will be ignored. The stackTrace of an `Error` object can be parsed with the `StackTraceParser` to an object of type `StackTrace` or the object is filled with custom data. 

    airbrakeNotifier.createCrashReport( error.errorID, error.name, error.message, StackTraceParser.parseStackTrace( error.getStackTrace() ) );
  
####4) Create an optional request node with information about a (failed) remote request. The most of the parameters are optional. 

    airbrakeNotifier.addRequestInformationsToCrashReport( "URL", "COMPONENT", "ACTION", requestParams, sessionParams, environmentParams );
  
####5) Finally send the crash report. 

    airbrakeNotifier.sendCrashReport();

* * *
     
     
### More information

See the [notifier API](http://help.airbrake.io/kb/api-2/notifier-api-version-22) for a detailed description of values and how they are used. 


### Developer

The 'as3-airbrake-notifier' was developed by [Stephan Partzsch](https://github.com/StephanPartzsch/) and [Peter Höche](https://github.com/PeterHoeche/).