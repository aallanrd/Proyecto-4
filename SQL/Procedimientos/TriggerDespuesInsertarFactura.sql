CREATE OR REPLACE TRIGGER Facturas_XML_After_Insert
AFTER INSERT ON "Facturas_XML"
FOR EACH ROW

DECLARE fechaCompra VARCHAR2(10);
        codFactura VARCHAR2(25);

BEGIN
    --Se extrae la fecha de compra de la factura
    SELECT EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/FechaCompra') INTO fechaCompra
    FROM DUAL;
    
    --Se extrae el c�digo de la factura
    SELECT EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/CodigoFactura') INTO codFactura
    FROM DUAL;
    
    --Se inserta el encabezado de la factura
     INSERT INTO FACTURAS_OBJ VALUES(
                                      codFactura,                                             --C�digo de la factura
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/Proveedor'),  --C�digo del proveedor
                                      EXTRACTVALUE(:NEW.OBJECT_VALUE, '/Factura/Usuario'),    --C�digo del usuario quien inserta
                                      TO_DATE(fechaCompra, 'yyyy/mm/dd'),                     --Fecha de la compra (Se convierte al formato correcto)
                                      T_LineasCompra()                                        --Inicializador de la tabla anidada de articulos comprados
                                    );
    
    --Se inserta las l�neas de la factura
    INSERT INTO TABLE(SELECT lineasDeCompra  FROM FACTURAS_OBJ f WHERE f.codigoFactura = codFactura)
    SELECT x.codigo, x.cantidad, x.precioUnitario
          FROM XMLTABLE('Factura/LineasDeCompra/LineaDeArticulo' PASSING :NEW.OBJECT_VALUE
                columns
                codigo VARCHAR2(20 CHAR) PATH 'ArticuloComprado/@codigo',
                cantidad NUMBER(5) PATH 'ArticuloComprado/@cantidad',
                precioUnitario NUMBER(18,2) PATH 'ArticuloComprado/@precioUnitario'
              ) x;
    

END;