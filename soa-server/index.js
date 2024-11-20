var express    = require('express');
var app        = express();
var config     = require('./util/config')
var bodyParser = require('body-parser');
var cors       = require('cors');
var moment     = require('moment');
var multer     = require('multer');
var fs         = require('fs');
var api        = require('./api/index')
var history    = require('connect-history-api-fallback')
var mw         = require('./model/middleware')
var usuarios   = require('./model/usuarios')
var path       = require('path')

app.use(express.static(path.join(__dirname, 'public')))
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.json());

// Add headers
app.use(cors());

app.use(history());

// Statics
app.use('/', express.static('dist'))
app.use('/static', express.static('static'))

// Statics
app.use('/statics', 			express.static('statics'))
app.use('/upload', 				express.static(__dirname + '/upload'))
app.use('/app_archivos',	express.static(__dirname + '/app_archivos'))
app.use('/temporal', 			express.static('temporal'))
app.use('/docs', 					express.static('docs'))
	
app.post('/login', 														usuarios.login);
app.get('/info', 															usuarios.getInfo);
app.post('/logout', 													usuarios.postLogout);
app.get('/login/menu',					mw.isLogged, 	usuarios.getMenu);


// Inicio Routes
app.use('/dashboard',								require('./router/dashboard'))
app.use('/log-actividades',					require('./router/log_actividades'))
app.use('/log-db-error', 						require('./router/log_db_error'))
app.use('/usuarios', 								require('./router/usuarios'))
app.use('/usuarios-empresa', 				require('./router/usuarios_empresa'))
app.use('/usuarios-password', 		  require('./router/usuarios_password'))
app.use('/roles', 									require('./router/roles'))
app.use('/clientes', 							  require('./router/clientes'))
app.use('/categorias', 							require('./router/categorias'))
app.use('/proveedores', 					  require('./router/proveedores'))


app.use('/empresas', 								require('./router/empresas'))
// app.use('/empresas-areas', 					require('./router/empresas_areas'))
// app.use('/empresas-cargos', 				require('./router/empresas_cargos'))
// app.use('/empresas-sedes', 					require('./router/empresas_sedes'))
// app.use('/empresas-terceros', 			require('./router/empresas_terceros'))
// app.use('/servicios', 							require('./router/servicios'))
// app.use('/servicios-empresa',				require('./router/servicios_empresa'))
// app.use('/agentes-sede',						require('./router/agentes_sede'))
// app.use('/puestos',									require('./router/puestos'))
// app.use('/personas',								require('./router/personas'))
// app.use('/personal',								require('./router/personal'))
// app.use('/personal-activos',				require('./router/personal_activos'))
// app.use('/tipos-documentos',				require('./router/tipos_documentos'))
// app.use('/tipos-personal',					require('./router/tipos_personal'))
// app.use('/tipos-activos',						require('./router/tipos_activos'))
// app.use('/empresas-tipos-personal',	require('./router/empresas_tipos_personal'))
// app.use('/vehiculos',								require('./router/vehiculos'))
// app.use('/tipos-vehiculos',					require('./router/tipos_vehiculos'))
// app.use('/ingresosalida',					  require('./router/ingresosalida'))
// app.use('/ingresosalida-upload',		require('./router/ingresosalida_upload'))
// app.use('/correspondencia',					require('./router/correspondencia'))
// app.use('/documentos-upload',			  require('./router/documentos_upload'))
// app.use('/tipos-correspondencia',	  require('./router/tipos_correspondencia'))
// app.use('/ingresosalida-activos',		require('./router/ingresosalida_activos'))
// app.use('/tipos-incidencias',			  require('./router/tipos_incidencias'))
// app.use('/incidencias',			  			require('./router/incidencias'))
// app.use('/camaras',			  					require('./router/camaras'))
// app.use('/tipos-ingresosalida',			require('./router/tipos_ingresosalida'))
// app.use('/log-actividades',					require('./router/log_actividades'))
// app.use('/upload',									require('./router/upload'))
// app.use('/uploads',									require('./router/uploads'))
// Fin Routes

var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'src/static/temporal/')
  },
  filename: function (req, file, cb) {
    console.log('data', req.body)
    cb(null, file.originalname)
  }
})

var upload = multer({ storage })
app.post('/api/upload', upload.single('file'), function (req, res) {
	// console.log('req.file:', req.file)
	var errors = [];
	var response = {
		status: 1
	}
	response.file = req.file
	res.send(response)
})

process.on('uncaughtException', function (err) {
	if (config.dev) console.error(err.stack);
	else {
		general.notifySlack('no se sabe', err, 'no handled error', 'no handled error', function (err) {
			process.exit(1);
		});
	}
});

app.listen(process.env === 'production' ? process.env.PORT : config.port, ()=> {
  console.log(`Escuchando en puerto ${process.env === 'production' ? process.env.PORT : config.port}`);
});