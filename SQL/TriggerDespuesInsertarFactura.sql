CREATE OR REPLACE TRIGGER Facturas_XML_After_Insert
AFTER INSERT ON "Facturas_XML"
FOR EACH ROW

DECLARE fechaCompra VARCHAR2(10);

BEGIN
   
    SELECT EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/FechaCompra') INTO fechaCompra
    FROM DUAL;


     INSERT INTO FACTURAS_OBJ VALUES(
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/CodigoFactura'),
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/Proveedor'),
                                      fechaCompra,--EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/Usuario'),
                                      SYSDATE, 
                                      T_LineasCompra()
                                    ); 

END;