CREATE OR REPLACE TRIGGER Facturas_XML_After_Insert
AFTER INSERT ON "Facturas_XML"
FOR EACH ROW

DECLARE fechaCompra VARCHAR2(10);
        codigoFactura VARCHAR2(25);

BEGIN
    --Se extrae la fecha de compra de la factura
    SELECT EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/FechaCompra') INTO fechaCompra
    FROM DUAL;
    
    --Se extrae el código de la factura
    SELECT EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/CodigoFactura') INTO codigoFactura
    FROM DUAL;
    
    --Se inserta el encabezado de la factura
     INSERT INTO FACTURAS_OBJ VALUES(
                                      codigoFactura,
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/Proveedor'),
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/Usuario'),
                                      TO_DATE(fechaCompra, 'yyyy/mm/dd'), 
                                      T_LineasCompra()
                                    );
    
    --Se inserta las líneas de la factura
    INSERT INTO TABLE(SELECT lineasDeCompra FROM FACTURAS_OBJ WHERE codigoFactura = codigoFactura)
    SELECT x.codigo, x.cantidad, x.precioUnitario
          FROM XMLTABLE('Factura/LineasDeCompra/LineaDeArticulo' PASSING :NEW.OBJECT_VALUE
                columns
                codigo VARCHAR2(20 CHAR) PATH 'ArticuloComprado/@codigo',
                cantidad NUMBER(5) PATH 'ArticuloComprado/@cantidad',
                precioUnitario NUMBER(18,2) PATH 'ArticuloComprado/@precioUnitario'
              ) x;
    

END;