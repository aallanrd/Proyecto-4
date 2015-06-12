CREATE OR REPLACE VIEW Facturas_XML_View OF XMLTYPE
WITH OBJECT ID(
                substr(EXTRACTVALUE(OBJECT_VALUE, 'Factura/CodigoFactura'), 1, 128)
              )
AS
SELECT 
      XMLELEMENT("Factura", 
         XMLELEMENT("CodigoFactura", f.codigoFactura),
         XMLELEMENT("Proveedor", f.proveedor),
         XMLELEMENT("Usuario", f.usuario),
         XMLELEMENT("FechaCompra", f.fechaCompra),
         XMLELEMENT("LineasDeCompra", 
                       (SELECT XMLAgg
                              (
                                  XMLELEMENT("LineaDeArticulo",
                                        XMLForest(
                                          l.codigo as "codigo",
                                          l.cantidad as "cantidad",
                                          l.precioUnitario as "precipUnitario"
                                        )
                                  )
                                )--Fin de la agregación
                                FROM TABLE(f.lineasDeCompra) l
                       )
                    )
      ) AS XML
FROM Facturas_OBJ F
ORDER BY f.fechaCompra ASC;

--PRUEBAS ***************************************************************************

--Extraer la fecha de compra de la factura
SELECT  EXTRACTVALUE(OBJECT_VALUE, '/Factura/FechaCompra') "Fecha de Compra"
FROM Facturas_XML_VIEW
WHERE EXISTSNODE(OBJECT_VALUE, '/Factura[CodigoFactura="Fact02"]') = 1;



--Extraer el código de las líneas de la factura
SELECT EXTRACTVALUE(VALUE(ar), 'LineaDeArticulo/codigo') "Codigo del articulo"
FROM Facturas_XML_VIEW,
     TABLE(XMLSEQUENCE(EXTRACT(OBJECT_VALUE, '/Factura/LineasDeCompra/LineaDeArticulo'))) ar
WHERE EXISTSNODE(OBJECT_VALUE, '/Factura[CodigoFactura="Fact02"]') = 1;


