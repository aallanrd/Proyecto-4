
--Obtiene e imprime las facturas XML del procedimiento sp_mostrarFacturasXML a través de un cursor REFCURSOR (SYS_REFCURSOR)
VARIABLE facturas REFCURSOR
EXECUTE SP_MOSTRARFACTURASXML(:facturas);
PRINT facturas;