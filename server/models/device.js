// var http = require('http');

module.exports = function(Device) {

  // Device.smartUpdate = function(id, update, cb) {
  //   var deviceId = id;
  //   var command = update;
  //   Device.findById(id, function(err, device) {
  //     if (!!device.gateway) {
  //       // AT&T Digital Life
  //       console.log("AT&T");
  //     } else {
  //       // SmartThings
  //       var smartthings_url = "https://graph.api.smartthings.com/";
  //       var options = {
  //         host: smartthings_url,
  //         port: 80,
  //         path: 'api/smartapps/installations/0fdb46dc-c87a-4414-bb26-5811d0a94d71/devices/' + id + '/switch',
  //         headers: {"auth" : {"bearer" : "57d7bec7-af4b-4382-8733-a30c923b0d77"}}
  //       };

  //       var req = http.get(options, function(response) {
  //         // var jsonString = '';
  //         // var success = false;
  //         // response.setEncoding('utf8');
  //         // if (('' + req.statusCode).match(/^2\d\d$/)) {
  //         //   response.on('data', function (chunk) {
  //         //     jsonString += chunk;
  //         //   });
  //         //   response.on('end', function () {
  //         //     var jsonObj = JSON.parse(jsonString);
  //         //     if (jsonObj.value == "off") {
  //         //       callback(true);
  //         //     } else {
  //         //       // device not available. Send error.
  //         //       callback(false);
  //         //     }
  //         //   });
  //         // }
  //       }).end();
  //     }
  //   })
  // }

  // Device.remoteMethod(
  //   'smartUpdate',
  //   {
  //     accepts: [
  //       {arg: 'id', type: 'string', required: true},
  //       {arg: 'update', type: 'string'},
  //       ],
  //       http: {path: '/:id/smartupdate', verb: 'put'}
  //   });
};
