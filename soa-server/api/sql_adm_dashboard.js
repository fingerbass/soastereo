var util    = require('./util.js')
  , general = require('../util/general.js')
  , sql     = require('mssql')
  ;
    
const TABLE_NAME = 'adm_evento'

var get = function(empresa, obj, callback) {
  var keys = Object.keys(obj)
  var arrayKeys = []
  
  for (var i = 0; i < keys.length; i++) {
    var element = keys[i];
    arrayKeys.push(`${element} = @${element}`)
  }

  var queryFields = arrayKeys.join(' and ')
  
  util.getConnection(empresa, function(err, con) {
    if (err) {
      callback(err)
      return
    }

    var query = `SELECT * FROM ${TABLE_NAME}`
    if (keys.length > 0) {
      query += ` WHERE ${queryFields}`
    }

    var request = new sql.Request(con);
    for (var i = 0; i < keys.length; i++) {
      var element = keys[i];
      request.input(element, obj[element]);
    }

    var queryTime = `sql get ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    
    request.query(query, function(err, recordset) {
      con.close();
      general.timeLog('end', queryTime)
      if (recordset && recordset.length) callback(err, recordset.length, recordset)
      else callback(err, 0, [])
    });
  });
};

var builtGet = function(empresa, query, obj, callback) {
  var keys = Object.keys(obj)
  
  util.getConnection(empresa, function(err, con) {
    if (err) {
      callback(err)
      return
    }

    var request = new sql.Request(con);
    for (var i = 0; i < keys.length; i++) {
      var element = keys[i];
      request.input(element, obj[element]);
    }

    var queryTime = `sql builtGet ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)

    request.query(query, function(err, recordset) {
      con.close();
      general.timeLog('end', queryTime)
      if (recordset) {
        // Si el recordset es un array de resultados (múltiples consultas)
        if (Array.isArray(recordset)) {
          callback(err, recordset.reduce((total, set) => total + set.length, 0), recordset)
        } else {
          // Si es un solo resultado
          callback(err, recordset.length, recordset)
        }
      } else {
        callback(err, 0, [])
      }
    });
  });
};

var getKpis = function(empresa, callback) {
  util.getConnection(empresa, function(err, con) {
    if (err) {
      callback(err)
      return
    }

    var query = `EXEC USP_dashboard_kpis`;
    var request = new sql.Request(con);
    
    var queryTime = `sql getKpis ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    
    request.query(query, function(err, recordset) {
      con.close();
      general.timeLog('end', queryTime)
      if (recordset && recordset.length) callback(err, recordset.length, recordset[0])
      else callback(err, 0, {})
    });
  });
};

var getTendencias = function(empresa, año, callback) {
  util.getConnection(empresa, function(err, con) {
    if (err) {
      callback(err)
      return
    }

    var query = `EXEC USP_dashboard_eventos_trend @año`;
    var request = new sql.Request(con);
    request.input('año', año);
    
    var queryTime = `sql getTendencias ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    
    request.query(query, function(err, recordset) {
      con.close();
      general.timeLog('end', queryTime)
      if (recordset && recordset.length) callback(err, recordset.length, recordset)
      else callback(err, 0, [])
    });
  });
};

var getRadarStats = function(empresa, callback) {
  util.getConnection(empresa, function(err, con) {
    if (err) {
      callback(err)
      return
    }

    var query = `EXEC USP_dashboard_radar_stats`;
    var request = new sql.Request(con);
    
    var queryTime = `sql getRadarStats ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    
    request.query(query, function(err, recordset) {
      con.close();
      general.timeLog('end', queryTime)
      if (recordset) callback(err, recordset.length, recordset)
      else callback(err, 0, [])
    });
  });
};

var getCostosMensuales = function(empresa, año, callback) {
  util.getConnection(empresa, function(err, con) {
    if (err) {
      callback(err)
      return
    }

    var query = `EXEC USP_dashboard_costos_mensuales @año`;
    var request = new sql.Request(con);
    request.input('año', año);
    
    var queryTime = `sql getCostosMensuales ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    
    request.query(query, function(err, recordset) {
      con.close();
      general.timeLog('end', queryTime)
      if (recordset && recordset.length) callback(err, recordset.length, recordset)
      else callback(err, 0, [])
    });
  });
};

// Exportamos todas las funciones
exports.get = get
exports.builtGet = builtGet
exports.getKpis = getKpis
exports.getTendencias = getTendencias
exports.getRadarStats = getRadarStats
exports.getCostosMensuales = getCostosMensuales