## Description

CFML wrapper library for [SmartyStreets LiveAddress API](http://www.smartystreets.com/Products/LiveAddress-API/), formerly Qualified Address.

There is a [RIAForge project](http://quaddress.riaforge.org/) for previous version wrapper, it uses v1 (deprecated) XML web-service.

## Requirements

Library uses modern CFScript syntax, so it requires at least Adobe ColdFusion 9 or Railo 3.2 engine to work. 

Check out old wrapper for ACF8 compatible integration, please be aware that API could have change since release.

## Using Component 

First you need to register an account and [obtain your authentication token](https://www.smartystreets.com/Account/Api/Install/rest/).
SmartyStreets provides free 30-day trial with 500 requests, this should be enough for integration and testing.

There are two **core methods** to be used:

 - **init** initializes the component. Except *apikey* this method accepts two arguments, *useragent* (string) allows to override http agent
(say, put your application name there), *verbose* (boolean) enables adding debugging info to response (cfhttp result, exception struct). 
API key needs to be set with *init*, or with *setApiKey(apikey)* in order to authenticate.

 - **invoke** performs request to the API and handles response. All possible input parameters are passed as optional arguments of this method.
Method returns a structure with at least two fields: *fault* (boolean) and *data* (mixed). Field *data* contains parsed JSON response
for successful requests and error string for failures.
   
See all API parameters and response fields [in User Guide](http://wiki.smartystreets.com/liveaddress_api_users_guide#section_4rest_json_endpoint).

There are few other helper (getter/setter) methods, please see component code for details.

## Usage Examples

Step by step use with verbose output:

    ws = CreateObject("SmartyStreets").init(apikey = "YourAuthenticationToken", verbose = true);
    
    params = {
        street = "1600 Amphitheatre Parkway",
        zipcode = "94043",
        city = "Mountain View",
        state = "CA"
    };
    
    result = ws.invoke(argumentCollection = params);
    
    if (result.fault) {
        WriteOutput("Something went wrong: " & result.data);
        WriteDump(var=result.exception, label="Exception");
    }
    else {
        WriteDump(var=result.data, label="Success");
    }
    
Compact format:

    result = CreateObject("SmartyStreets").init("YourAuthenticationToken").invoke(
        street = "1600 Amphitheatre Parkway",
        zipcode = "94043"
    );
    
    if (result.fault) {
        WriteOutput("Something went wrong: " & result.data);
    }
    else {
        WriteDump(var=result.data, label="Success");
    }

## License

Library is released under the [Apache License Version 2.0](http://www.apache.org/licenses/LICENSE-2.0).
