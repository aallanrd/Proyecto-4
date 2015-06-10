CREATE OR REPLACE TRIGGER Facturas_XML_After_Insert
AFTER INSERT ON "Facturas_XML"
FOR EACH ROW

BEGIN
     INSERT INTO FACTURAS_OBJ VALUES(
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/CodigoFactura'),
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/Proveedor'),
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/Usuario'),
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/FechaCompra'),
                                      T_LineasCompra()
                                    ); 

END;