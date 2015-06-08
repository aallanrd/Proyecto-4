-- Procedimiento que activa el listener para http en el puerto 9090
-- Procedimiento que activa el listener para ftp en el puerto 2100
begin
    dbms_xdb.setHTTPport(9090);
    dbms_xdb.setFTPport(2100);
end;

commit;



-- Registra el esquema.
begin
  dbms_xmlschema.registerschema(
    schemaurl => 'http://172.19.127.101:9090/grupoAllanMario/facturas/xsd/purchaseOrder.xsd',
    schemadoc =>  xdbURIType('/grupoAllanMario/facturas/xsd/purchaseOrder.xsd').getClob(),
    local => TRUE,
    genTypes => TRUE,
    genBean => FALSE,
    genTables => TRUE
  );
end;
