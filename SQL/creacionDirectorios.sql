
-- El directorio grupoAllanMario (XML Schema Definition) contiene el esquema de los documentos
-- orden de compra.
-- El directorio 2015 contiene el archivo de los datos para el directorio de las facturas
declare
      resultado boolean;
begin
      resultado :=  dbms_xdb.createfolder('/grupoAllanMario');
      resultado :=  dbms_xdb.createfolder('/grupoAllanMario/facturas');
      resultado :=  dbms_xdb.createfolder('/grupoAllanMario/facturas/xsd');
      resultado :=  dbms_xdb.createfolder('/grupoAllanMario/facturas/2015');
end;
/

-- Se confirma la definicion de los directorios.
commit;
/