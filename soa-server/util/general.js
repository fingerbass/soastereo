var moment  = require('moment');
var request = require('request');


var infoLog = function(empresa, obj, tipo) {
	var tipoLocal = tipo ? tipo : 'request'

	var texto = tipoLocal + ' '
	texto += empresa + ' '

	var keys = Object.keys(obj)

	//Agregamos los inputs
  for (var i = 0; i < keys.length; i++) {
    var key = keys[i];

    texto += key + ' '
    texto += obj[key] + ' '
  }

  console.log(texto)
}

var timeLog = function (type, text) {
	if (type === 'start') {
		console.time(text)
	} else if (type === 'end') {
		console.timeEnd(text)
	}
}

exports.infoLog      = infoLog;
exports.timeLog      = timeLog;