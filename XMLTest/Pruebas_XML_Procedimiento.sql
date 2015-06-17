--Procedimiento para generación de la vista*********************************************************************************
EXECUTE SP_CREARVISTAFACTURA_XML;

--Selecciona las facturas XML de la vista FACTURAS_XML_VIEW dándoles el formato XML con XMLROOT
SELECT XMLROOT(x.OBJECT_VALUE, VERSION '1.0', STANDALONE YES) "Facturas" FROM FACTURAS_XML_VIEW x;



--Obtiene y muestra el contenido de las tablas de facturas relacionales****************************************************
VARIABLE facturas REFCURSOR
EXECUTE SP_MOSTRARFACTURAS(:facturas);
PRINT facturas;



--Obtiene e imprime las facturas XML del procedimiento sp_mostrarFacturasXML a través de un cursor REFCURSOR (SYS_REFCURSOR)
VARIABLE facturas REFCURSOR
EXECUTE SP_MOSTRARFACTURASXML(:facturas);
PRINT facturas;

