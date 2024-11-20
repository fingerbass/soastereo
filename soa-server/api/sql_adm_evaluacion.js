var util    = require('./util.js')
  , general = require('../util/general.js')
  , sql     = require('mssql')
    ;
    
const TABLE_NAME = 'adm_evaluacion'

var getOne = function(empresa, id, callback){
  util.getConnection(empresa, function(err, con){
    if (err) {
      callback(err)
      return
    }

    var query = `
      SELECT e.*, p.nombre as proveedor_nombre, c.nombre as categoria_nombre, ev.nombre as evento_nombre
      FROM ${TABLE_NAME} e
      INNER JOIN adm_proveedor p ON e.proveedor_id = p.id
      INNER JOIN adm_categorias c ON p.idcategoria = c.idcategoria
      INNER JOIN adm_evento ev ON e.evento_id = ev.id
      WHERE e.id = @id
    `;

    var request = new sql.Request(con);
    request.input('id', id);
    var queryTime = `sql getOne ${TABLE_NAME} ${id} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    request.query(query, function(err, recordset){
      con.close();
      general.timeLog('end', queryTime)
      if (recordset.length > 0) {
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
    arrayKeys.push(`e.${element} = @${element}`)
  }

  var queryFields = arrayKeys.join(' and ')
  
  util.getConnection(empresa, function(err, con){
    if (err) {
      callback(err)
      return
    }

    var query = `
      SELECT e.*, p.nombre as proveedor_nombre, c.nombre as categoria_nombre, ev.nombre as evento_nombre
      FROM ${TABLE_NAME} e
      INNER JOIN adm_proveedor p ON e.proveedor_id = p.id
      INNER JOIN adm_categorias c ON p.idcategoria = c.idcategoria
      INNER JOIN adm_evento ev ON e.evento_id = ev.id
    `;

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
    INSERT INTO ${TABLE_NAME} 
    (
      ${queryFields}
    )
    VALUES
    (
      ${queryValues}
    );
    
    -- Actualizar la reputación promedio del proveedor
    UPDATE adm_proveedor 
    SET reputacion = (
      SELECT AVG(CAST(puntuacion AS FLOAT))
      FROM ${TABLE_NAME}
      WHERE proveedor_id = @proveedor_id
    )
    WHERE id = @proveedor_id;
  `

  try {
    util.getConnection(empresa, function(err, con){
      if (err) {
        callback(err)
        return
      }
  
      var request = new sql.Request(con);

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
    callback(error)
  }
}

var update = function(empresa, id, obj, callback) {
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
    UPDATE ${TABLE_NAME}
    SET 
    ${queryMiddle}
    WHERE
    id = @key;
    
    -- Actualizar la reputación promedio del proveedor
    UPDATE adm_proveedor 
    SET reputacion = (
      SELECT AVG(CAST(puntuacion AS FLOAT))
      FROM ${TABLE_NAME}
      WHERE proveedor_id = @proveedor_id
    )
    WHERE id = @proveedor_id;
  `

  try {
    util.getConnection(empresa, function(err, con){
      if (err) {
        callback(err)
        return
      }

      var request = new sql.Request(con);

      for (var i = 0; i < keys.length; i++) {
        var element = keys[i];
        request.input(element, obj[element]);
      }

      request.input('key', id);
      request.input('proveedor_id', obj.proveedor_id);
      
      var queryTime = `sql update ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
      general.timeLog('start', queryTime)
      
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

var deleteById = function(empresa, id, callback){
  util.getConnection(empresa, function(err, con){
    if (err) {
      callback(err)
      return
    }
    var query = `
      DECLARE @proveedor_id INT;
      SELECT @proveedor_id = proveedor_id FROM ${TABLE_NAME} WHERE id = @id;
      
      DELETE FROM ${TABLE_NAME} WHERE id = @id;
      
      -- Actualizar la reputación promedio del proveedor
      UPDATE adm_proveedor 
      SET reputacion = (
        SELECT AVG(CAST(puntuacion AS FLOAT))
        FROM ${TABLE_NAME}
        WHERE proveedor_id = @proveedor_id
      )
      WHERE id = @proveedor_id;
    `;
    
    var request = new sql.Request(con);
    var queryTime = `sql deleteById ${TABLE_NAME} ${id} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    
    request.input('id', id);
    request.query(query, function(err, recordset){
      con.close();
      general.timeLog('end', queryTime)
      callback(err)
    });
  });
};

exports.getOne     = getOne
exports.get        = get
exports.builtGet   = builtGet
exports.insert     = insert
exports.update     = update
exports.deleteById = deleteById