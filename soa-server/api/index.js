var api = {
  sql : {
		seg_usuarios         : require('./sql_seg_usuarios'),
		seg_log_actividades  : require('./sql_seg_log_actividades'),
		seg_log_db_error     : require('./sql_seg_log_db_error'),
		seg_usuarios_empresa : require('./sql_seg_usuarios_empresa'),
		seg_usuarios_password: require('./sql_seg_usuarios_password'),
		seg_roles            : require('./sql_seg_roles'),
		adm_clientes         : require('./sql_adm_clientes'),
		adm_categorias       : require('./sql_adm_categorias'),
		adm_proveedores      : require('./sql_adm_proveedores'),
		adm_empresas         : require('./sql_adm_empresas'),
		adm_evaluacion		 	 : require('./sql_adm_evaluacion'),
		adm_eventos					 : require('./sql_adm_eventos'),
  },
  ws : {
  }
}

module.exports = api
