var util    = require('./util.js')
  , general = require('../util/general.js')
  , sql     = require('mssql')
    ;
    
const TABLE_NAME = 'seg_usuarios'

var getOne = function(empresa, idusuario, callback){
  
  util.getConnection(empresa, function(err, con){
    if (err) {
      callback(err)
      return
    }

    var query = `select * from ${TABLE_NAME} where idusuario = @idusuario`;
    var request = new sql.Request(con);
    request.input('idusuario', idusuario);
    var queryTime = `sql getOne ${TABLE_NAME} ${idusuario} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    request.query(query, function(err, recordset){
      con.close();
      general.timeLog('end', queryTime)
      // console.log('recordset[0]', recordset)
      // if (recordset !== undefined && recordset[0].idusuario == idusuario) {
      //   callback(null, true, recordset[0])
      // } else {
      //   callback(err, false)
      // }
      if (recordset.length > 0 ) {
        callback(null, true, recordset[0])
      } else {
        callback(err, false)
      }
    });
  });
};

var getOneUsuario = function(empresa, usuario, callback){
  
  util.getConnection(empresa, function(err, con){
    if (err) {
      callback(err)
      return
    }

    var query = `select * from ${TABLE_NAME} where login = @usuario`;
    var request = new sql.Request(con);
    request.input('usuario', usuario);
    var queryTime = `sql getOne ${TABLE_NAME} ${usuario} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    request.query(query, function(err, recordset){
      con.close();
      general.timeLog('end', queryTime)
      // console.log('recordset[0]', recordset)
      // if (recordset !== undefined && recordset[0].usuario == usuario) {
      //   callback(null, true, recordset[0])
      // } else {
      //   callback(err, false)
      // }
      if (recordset.length > 0 ) {
        callback(null, true, recordset[0])
      } else {
        callback(err, false)
      }
    });
  });
};

var get = function(empresa, obj, callback){
  var keys = Object.keys(obj)

  var arrayKeys = []
  
  for (var i = 0; i < keys.length; i++) {
    var element = keys[i];
    arrayKeys.push(`${element} = @${element}`)
  }

  var queryFields = arrayKeys.join(' and ')
  
  util.getConnection(empresa, function(err, con){
    if (err) {
      callback(err)
      return
    }

    var query = `select * from ${TABLE_NAME}`;

    if (keys.length > 0) {
      query += ` where ${queryFields}`
    }

    var request = new sql.Request(con);
    //Agregamos los inputs
    for (var i = 0; i < keys.length; i++) {
      var element = keys[i];
      request.input(element, obj[element]);
    }

    var queryTime = `sql get ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    
    request.query(query, function(err, recordset){
      con.close();
      general.timeLog('end', queryTime)
      if (recordset && recordset.length) callback(err, recordset.length, recordset)
      else callback(err, 0, [])
    });
  });
};

var builtGet = function(empresa, query, obj, callback){
  var keys = Object.keys(obj)

  var arrayKeys = []
  
  util.getConnection(empresa, function(err, con){
    if (err) {
      callback(err)
      return
    }

    var request = new sql.Request(con);
    //Agregamos los inputs
    for (var i = 0; i < keys.length; i++) {
      var element = keys[i];
      request.input(element, obj[element]);
    }
    var queryTime = `sql builtGet ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    request.query(query, function(err, recordset){
      con.close();
      general.timeLog('end', queryTime)
      if (recordset) callback(err, recordset.length, recordset)
      else callback(err, 0, [])
    });
  });
};

var insert = function(empresa, obj, callback) {
  
  var keys = Object.keys(obj)
  
  if (keys.length === 0) {
    callback(null, 0)
    return;
  }

  var arrayFieldsQuery = []
  var arrayParametersQuery = []
  for (var i = 0; i < keys.length; i++) {
    var element = keys[i];
    arrayFieldsQuery.push(element)
    arrayParametersQuery.push(`@${element}`)
  }

  var queryFields = arrayFieldsQuery.join(',')
  var queryValues = arrayParametersQuery.join(',')

  let query = `
    insert into ${TABLE_NAME} 
    (
    ${queryFields}
    )
    values
    (
    ${queryValues}
    );
  `

  try {
    util.getConnection(empresa, function(err, con){
      if (err) {
        callback(err)
        return
      }
  
      // var query = query;
      var request = new sql.Request(con);

      //Agregamos los inputs
      for (var i = 0; i < keys.length; i++) {
        var element = keys[i];
        request.input(element, obj[element]);
      }

      var queryTime = `sql insert ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
      general.timeLog('start', queryTime)
      
      request.query(query, function(err, recordset){
        con.close();
        general.timeLog('end', queryTime)
        if (err) {
          callback(err)
          return
        }
        callback(err, true)
      });
    })
  } catch (error) {
    // if (con) con.close()
    callback(error)
  }

}

//Lo que mandes en el objeto se va a actualizar
var update = function(empresa, key, obj, callback) {
  var keys = Object.keys(obj)
  
  if (keys.length === 0) {
    callback(null, 0)
    return;
  }

  var arrayKeys = []
  for (var i = 0; i < keys.length; i++) {
    var element = keys[i];
    arrayKeys.push(`${element} = @${element}`)
  }
  var queryMiddle = arrayKeys.join(',')

  let query = `
    update ${TABLE_NAME}
    set 
    ${queryMiddle}
    where
    idusuario = @key
  `

  try {
    util.getConnection(empresa, function(err, con){
      if (err) {
        callback(err)
        return
      }
      // var query = query;
      var request = new sql.Request(con);

      //Agregamos los inputs
      for (var i = 0; i < keys.length; i++) {
        var element = keys[i];
        request.input(element, obj[element]);
      }

      var queryTime = `sql update ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
      general.timeLog('start', queryTime)
      
      request.input('key', key);
      request.query(query, function(err, a, affected){
        con.close();
        general.timeLog('end', queryTime)
        callback(err, affected)
      });
    })
  } catch (error) {
    if (con) con.close()
    callback(error)
  }

}

var deleteById = function(empresa, idusuario, callback){
  
  util.getConnection(empresa, function(err, con){
    if (err) {
      callback(err)
      return
    }
    var query = `delete from ${TABLE_NAME} where idusuario = @idusuario`;
    var request = new sql.Request(con);
    
    var queryTime = `sql deleteById ${TABLE_NAME} ${idusuario} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    
    request.input('idusuario', idusuario);
    request.query(query, function(err, recordset){
      con.close();
      general.timeLog('end', queryTime)
      callback(err)
    });
  });
};

exports.getOne        = getOne
exports.getOneUsuario = getOneUsuario
exports.insert        = insert
exports.get           = get
exports.builtGet      = builtGet
exports.update        = update
exports.deleteById    = deleteById