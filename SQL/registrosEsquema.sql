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
