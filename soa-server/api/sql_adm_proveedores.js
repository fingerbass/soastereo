var util    = require('./util.js')
  , general = require('../util/general.js')
  , sql     = require('mssql')
    ;
    
const TABLE_NAME = 'adm_proveedor'

var getOne = function(empresa, id, callback) {
  util.getConnection(empresa, function(err, con) {
    if (err) {
      callback(err)
      return
    }

    var query = `select p.*, c.nombre as categoria_nombre 
                 from ${TABLE_NAME} p
                 left join adm_categorias c on p.idcategoria = c.idcategoria
                 where p.id = @id`;
    var request = new sql.Request(con);
    request.input('id', id);
    var queryTime = `sql getOne ${TABLE_NAME} ${id} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
    general.timeLog('start', queryTime)
    request.query(query, function(err, recordset) {
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

    var query = `select p.*, c.nombre as categoria_nombre 
                 from ${TABLE_NAME} p
                 left join adm_categorias c on p.idcategoria = c.idcategoria`;
    if (keys.length > 0) {
      query += ` where ${queryFields}`
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
      if (recordset) callback(err, recordset.length, recordset)
      else callback(err, 0, [])
    });
  });
};

var insert = function(empresa, obj, callback) {
  try {
    util.getConnection(empresa, function(err, con) {
      if (err) {
        callback(err)
        return
      }

      var query = ` EXEC USP_adm_proveedores_mantenimiento 
        @tipo = 1,
        @id = @id,
        @nombre = @nombre,
        @email = @email,
        @telefono = @telefono,
        @direccion = @direccion,
        @idcategoria = @idcategoria,
        @reputacion = @reputacion,
        @verificado = @verificado,
        @activo = @activo,
        @usuarioregistro = @usuarioregistro
      `

      var request = new sql.Request(con);
      
      request.input('id', obj.id);
      request.input('nombre', obj.nombre);
      request.input('email', obj.email);
      request.input('telefono', obj.telefono);
      request.input('direccion', obj.direccion);
      request.input('idcategoria', obj.idcategoria);
      request.input('reputacion', obj.reputacion || 0);
      request.input('verificado', obj.verificado || false);
      request.input('activo', obj.activo || true);
      request.input('usuarioregistro', obj.usuarioregistro);

      var queryTime = `sql insert ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
      general.timeLog('start', queryTime)
      
      request.query(query, function(err, recordset) {
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
  try {
    util.getConnection(empresa, function(err, con) {
      if (err) {
        callback(err)
        return
      }

      var query = ` EXEC USP_adm_proveedores_mantenimiento 
        @tipo = 2,
        @id = @id,
        @nombre = @nombre,
        @email = @email,
        @telefono = @telefono,
        @direccion = @direccion,
        @idcategoria = @idcategoria,
        @verificado = @verificado,
        @activo = @activo,
        @usuarioregistro = @usuarioregistro
      `

      var request = new sql.Request(con);
      
      request.input('id', id);
      request.input('nombre', obj.nombre);
      request.input('email', obj.email);
      request.input('telefono', obj.telefono);
      request.input('direccion', obj.direccion);
      request.input('idcategoria', obj.idcategoria);
      request.input('verificado', obj.verificado);
      request.input('activo', obj.activo);
      request.input('usuarioregistro', obj.usuarioregistro);

      var queryTime = `sql update ${TABLE_NAME} ${empresa} ` + Math.floor(Math.random() * 100000) + 1;
      general.timeLog('start', queryTime)
      
      request.query(query, function(err, result) {
        con.close();
        general.timeLog('end', queryTime)
        callback(err, result)
      });
    })
  } catch (error) {
    callback(error)
  }
}

var deleteById = function(empresa, id, callback) {
  try {
    util.getConnection(empresa, function(err, con) {
      if (err) {
        callback(err)
        return
      }

      var query = ` EXEC USP_adm_proveedores_mantenimiento @tipo = 3, @id = @id `
      var request = new sql.Request(con);
      request.input('id', id);
      
      var queryTime = `sql deleteById ${TABLE_NAME} ${id} ` + Math.floor(Math.random() * 100000) + 1;
      general.timeLog('start', queryTime)
      
      request.query(query, function(err, recordset) {
        con.close();
        general.timeLog('end', queryTime)
        callback(err)
      });
    });
  } catch (error) {
    callback(error)
  }
};

exports.getOne = getOne
exports.get = get
exports.builtGet = builtGet
exports.insert = insert
exports.update = update
exports.deleteById = deleteById