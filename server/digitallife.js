// Authenticate and use AT&T Digital Life API/Devices

var Client = require('node-rest-client').Client;
var client = new Client();

var args = {
  data: {
    userId: "553474453",
    password: "NO-PASSWD",
    appKey: "TE_CE2568549A16C9F0_1"
    },
  headers:{"Content-Type": "application/json"}
};

// /api/{gatewayGUID}/alarm
// GET /api/{gatewayGUID}/devices/{deviceGUID}/{attributeName}

// Authentication
function authenticateDL(callback, deviceId) {
    var req = client.post("https://systest.digitallife.att.com:443/penguin/api/authtokens", args, function(data,response) {
        // parsed response body as js object
        // console.log(data);
        // raw response
        // console.log(response);
        var headers = {
            Authtoken: data.content.authToken,
            Requesttoken: data.content.requestToken
        }
        var gateWay = data.content.gateways[0].id;
        callback(headers, gateway, deviceId);
    });

    req.on('requestTimeout',function(req){
        console.log('request has expired');
        req.abort();
    });

    req.on('responseTimeout',function(res){
        console.log('response has expired');
    });

    //it's usefull to handle request errors to avoid, for example, socket hang up errors on request timeouts
    req.on('error', function(err){
        console.log('request error',err);
    });
}

