component displayname="SmartyStreets" hint="LiveAddress API v2.3.1 wrapper" {


    /*
     * Version 0.1 — Dec 1, 2011
     * API docs: http://wiki.smartystreets.com/liveaddress_api_users_guide
     */


    /*
     * TODO:
     * - Check compatibility with CF9 (CF8 wont be supported).
     * - Prepare usage examples and README.
     */


    variables.apikey = "";
    variables.apiurl = "https://api.qualifiedaddress.com/street-address/";
    variables.useragent = "";
    variables.verbose = false;


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



    /*
     * @street The input street address of the request
     *
     */
    private struct function invoke(
        required string street
    )
    hint="Perform request to the API and handle response" {

        var local = {};


        local.output = {};


        try {


            // communicate with API

            http url=getApiUrl() method="post" useragent=getUserAgent() result="local.result" {

                httpparam type="formfield" name="auth-key" value=getApiKey();

                for (local.key in arguments) {
                    httpparam type="formfield" name=local.key value=arguments[local.key];
                }

            }

            if (getVerbose()) {
                local.output.result = local.result;
            }



        }
        catch (any local.exception) {

            rethrow;

            local.output.fault = true;
            local.output.data = local.exception.Message;

            if (getVerbose()) {
                local.output.exception = local.exception;
            }

        }


        return local.output;


    }



}