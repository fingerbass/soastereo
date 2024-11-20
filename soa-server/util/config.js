// var environment = 'production';
var environment = process.env.NODE_ENV || 'production';
// process.env.NODE_ENV || 'production';
var config = {
	production: {
		port       : 3001,
		env        : environment,
		dev        : false,
		secret     : 'soa@1.0',
		app        : 'soa',
		soa: {
			empresa: 'soa',
			ruc    : 20115635388,
			color  : '#b80813',
			logo   : '',
			db     : {
				object_connection: {
					user    : '',
					password: '',
					server  : '',
					database: '',
					options: {
						encrypt: false,
						useUTC : false
					}
				}
			},
			mail : {
				config : {
					user    : '',
					password: '',
					host    : '',
					tls     : true
				}
			}
		}
	},
	development: {
		port       : 3001,
		env        : environment,
		dev        : true,
		secret     : 'soa@1.0',
		app        : 'soa',
		soa: {
			empresa: 'soa',
			ruc    : 20115635388,
			color  : '#b80813',
			logo   : '',
			// db     : {
			// 	object_connection: {
			// 		user    : 'sa',
			// 		password: 'sql',
			// 		server  : '192.168.1.5',
			// 		database: 'soa',
			// 		options: {
			// 			encrypt: false,
			// 			useUTC : false
			// 		}
			// 	}
			// },
			db     : {
				object_connection: {
					user    : 'sa',
					password: 'RivieraInsana++',
					server  : '135.148.78.170',
					database: 'soa',
					options: {
						encrypt: false,
						useUTC : false
					}
				}
			},
			mail : {
				config : {
					user    : '',
					password: '',
					host    : '',
					tls     : true
				}
			}
		}
	}
};
module.exports = config[environment];