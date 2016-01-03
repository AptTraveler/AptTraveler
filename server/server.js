var packageVersion = require('./../package.json').version;
console.log("packageVersion :: " + packageVersion);

var loopback = require('loopback');
var boot = require('loopback-boot');

var app = module.exports = loopback();

// ------------ Protecting mobile backend with Mobile Client Access start -----------------

// Load passport (http://passportjs.org)
// var passport = require('passport');

// Get the MCA passport strategy to use
// var MCABackendStrategy = require('bms-mca-token-validation-strategy').MCABackendStrategy;

// Tell passport to use the MCA strategy
// passport.use(new MCABackendStrategy())

// Tell application to use passport
// app.use(passport.initialize());

// Protect DELETE endpoint so it can only be accessed by HelloTodo mobile samples
// app.delete('/api/Items/:id', passport.authenticate('mca-backend-strategy', {session: false}));

// Protect /protected endpoint which is used in Getting Started with Bluemix Mobile Services tutorials
// app.get('/protected', passport.authenticate('mca-backend-strategy', {session: false}), function(req, res){
	// res.send("Hello, this is a protected resouce of the mobile backend application!");
// });
// ------------ Protecting backend APIs with Mobile Client Access end -----------------
var db;
var cloudant;
var dbCredentials = {
	dbName : 'apttraveler'
};

function initDBConnection() {

	if(process.env.VCAP_SERVICES) {
		var vcapServices = JSON.parse(process.env.VCAP_SERVICES);
		if(vcapServices.cloudantNoSQLDB) {
			dbCredentials.host = vcapServices.cloudantNoSQLDB[0].credentials.host;
			dbCredentials.port = vcapServices.cloudantNoSQLDB[0].credentials.port;
			dbCredentials.user = vcapServices.cloudantNoSQLDB[0].credentials.username;
			dbCredentials.password = vcapServices.cloudantNoSQLDB[0].credentials.password;
			dbCredentials.url = vcapServices.cloudantNoSQLDB[0].credentials.url;

			cloudant = require('cloudant')(dbCredentials.url);

			// check if DB exists if not create
			cloudant.db.create(dbCredentials.dbName, function (err, res) {
				if (err) { console.log('could not create db ', err); }
		    });

			db = cloudant.use(dbCredentials.dbName);

		} else {
			console.warn('Could not find Cloudant credentials in VCAP_SERVICES environment variable - data will be unavailable to the UI');
		}
	} else{
		// console.warn('VCAP_SERVICES environment variable not set - data will be unavailable to the UI');
		// For running this app locally you can get your Cloudant credentials
		// from Bluemix (VCAP_SERVICES in "cf env" output or the Environment
		// Variables section for an app in the Bluemix console dashboard).
		// Alternately you could point to a local database here instead of a
		// Bluemix service.
		dbCredentials.host = "37dd672c-b024-49a7-8a24-d53f1545d05a-bluemix.cloudant.com";
		dbCredentials.port = 443;
		dbCredentials.user = "37dd672c-b024-49a7-8a24-d53f1545d05a-bluemix";
		dbCredentials.password = "07d9b5e14d59b8a73828fd26acdf8e3ba634c889d9003faf6f553c6ab074aff7";
		dbCredentials.url = "https://37dd672c-b024-49a7-8a24-d53f1545d05a-bluemix:07d9b5e14d59b8a73828fd26acdf8e3ba634c889d9003faf6f553c6ab074aff7@37dd672c-b024-49a7-8a24-d53f1545d05a-bluemix.cloudant.com";
	}
}

initDBConnection();

app.start = function () {
	// start the web server
	return app.listen(function () {
		app.emit('started');
		var baseUrl = app.get('url').replace(/\/$/, '');
		console.log('Web server listening at: %s', baseUrl);
		var componentExplorer = app.get('loopback-component-explorer');
		if (componentExplorer) {
			console.log('Browse your REST API at %s%s', baseUrl, componentExplorer.mountPath);
		}
	});
};

// Bootstrap the application, configure models, datasources and middleware.
// Sub-apps like REST API are mounted via boot scripts.
boot(app, __dirname, function (err) {
	if (err) throw err;
	if (require.main === module)
		app.start();
	  // var io = require('socket.io')(app.start());
	  // io.on('connection', function(socket){
	  //   console.log('a user connected');
	  //   socket.on('chat message', function(msg){
	  //       console.log('message: ' + msg);
	  //       app.io.emit('chat message', msg);
	  //   });
	  //   socket.on('disconnect', function(){
	  //       console.log('user disconnected');
	  //   });
	  // });
});

