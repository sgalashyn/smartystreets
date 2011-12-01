component displayname="SmartyStreets" hint="LiveAddress API v2.3.1 wrapper" {


    /*
     * Version 0.2 — Dec 1, 2011
     * API docs: http://wiki.smartystreets.com/liveaddress_api_users_guide
     */


    /*
     * TODO:
     * - Prepare usage examples and README.
     */


    variables.apikey = "";
    variables.apiurl = "http://www.postbin.org/t357qt";
    variables.apiurl = "https://api.qualifiedaddress.com/street-address/";
    variables.useragent = "";
    variables.verbose = false;

    // HTTP status codes by SS
    variables.statuses = {
        "200" = "Request completed successfully, inspect response body.",
        "400" = "Malformed request – required fields missing from request.",
        "401" = "Authentication failure – invalid credentials; check credentials and try again.",
        "402" = "Unauthorized access; no active subscription can be found.",
        "500" = "General service failure, retry request."
    };


    /*
     * @apikey Valid API Key for your user account
     * @useragent Custom useragent for HTTP requests
     * @verbose Append extended info to the output
     */
    public any function init(
        required string apikey,
        string useragent = server.ColdFusion.ProductName,
        boolean verbose = false
    )
    hint="Component initialization" {

        setApiKey(arguments.apikey);
        setUserAgent(arguments.useragent);
        setVerbose(arguments.verbose);

        return this;

    }


    public void function setApiKey(required string apikey) hint="Set current API auth key setting" {
        variables.apikey = arguments.apikey;
    }


    public string function getApiKey() hint="Get current API auth key setting" {
        return variables.apikey;
    }


    public void function setUserAgent(required string useragent) hint="Set current useragent setting" {
        variables.useragent = arguments.useragent;
    }


    public string function getUserAgent() hint="Get current useragent setting" {
        return variables.useragent;
    }


    public string function getApiUrl() hint="Get current API URL" {
        return variables.apiurl;
    }


    public void function setVerbose(required boolean verbose) hint="Set current verbose setting" {
        variables.verbose = arguments.verbose;
    }


    public boolean function getVerbose() hint="Get current verbose setting" {
        return variables.verbose;
    }


    private string function getStatusDefinition(required string code) hint="Get definition for status code" {

        if (StructKeyExists(variables.statuses, arguments.code)) {
            return variables.statuses[arguments.code];
        }
        else {
            return "Unknown status code (#local.code#)";
        }

    }



    /*
     * @street The input street address of the request
     *
     */
    public any function invoke(
        required string street
    )
    hint="Perform request to the API and handle response" {

        var local = {};


        local.output = {};


        try {


            // send a request to API (token must be in URL)

            local.service = new http(
                url = "#getApiUrl()#?auth-token=#URLEncodedFormat(getApiKey())#",
                method = "post",
                useragent = getUserAgent()
            );

            for (local.key in arguments) {
                local.service.addParam(type="formfield", name=LCase(local.key), value=arguments[local.key]);
            }

            local.result = local.service.send().getPrefix();

            if (getVerbose()) {
                local.output.result = local.result;
            }


            // check if request is handled

            if (local.result.responseheader.status_code NEQ 200) {
                throw(message=getStatusDefinition(local.result.responseheader.status_code));
            }


            // try to parse the response

            if (StructKeyExists(local.result, "filecontent") AND isJSON(local.result.filecontent)) {
                local.output.fault = false;
                local.output.data = DeserializeJSON(local.result.filecontent);
            }
            else if (StructKeyExists(local.result, "errordetail")) {
                throw(message="API communication failure. #local.result.errordetail#");
            }
            else {
                throw(message="API communication failure, or invalid response returned.");
            }


        }
        catch (any exception) {

            local.output.fault = true;
            local.output.data = exception.Message;

            if (getVerbose()) {
                local.output.exception = exception;
            }

        }


        return local.output;


    }



}