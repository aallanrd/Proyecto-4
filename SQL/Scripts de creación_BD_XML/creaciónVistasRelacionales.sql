--Vista para el encabezado de las facturas

CREATE OR REPLACE VIEW Factura_View
      (
        codFactura, codProveedor, codUsuario, fechaCompra
      )
AS
  SELECT EXTRACTVALUE(OBJECT_VALUE, '/Factura/CodigoFactura'),
       EXTRACTVALUE(OBJECT_VALUE, '/Factura/Proveedor'),
       EXTRACTVALUE(OBJECT_VALUE, '/Factura/Usuario'),
       EXTRACTVALUE(OBJECT_VALUE, '/Factura/FechaCompra')
  FROM "Facturas_XML";
  
--Vista para las líneas de la factura
CREATE OR REPLACE VIEW LineasFactura_View
    (
      descriArticulo, codArticulo, cantidad, precioUnitario, codFactura
    )
AS
  --Extraer las líneas de las facturas
    SELECT EXTRACTVALUE(VALUE(linea), '/LineaDeArticulo/NombreDeArticulo'),
           EXTRACTVALUE(VALUE(linea), 'LineaDeArticulo/ArticuloComprado/@codigo'),
           EXTRACTVALUE(VALUE(linea), 'LineaDeArticulo/ArticuloComprado/@cantidad'),
           EXTRACTVALUE(VALUE(linea), 'LineaDeArticulo/ArticuloComprado/@precioUnitario'),
           EXTRACTVALUE(OBJECT_VALUE, '/Factura/CodigoFactura')
    FROM "Facturas_XML", 
         TABLE(XMLSEQUENCE(EXTRACT(OBJECT_VALUE, 'Factura/LineasDeCompra/LineaDeArticulo'))) linea;