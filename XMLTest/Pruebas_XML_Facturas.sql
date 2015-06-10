--Obtener la descripción de las líneas de una factura
SELECT EXTRACTVALUE(VALUE(descripcion), '/NombreDeArticulo') "Nombre del Articulo"
FROM "Facturas_XML", TABLE(XMLSEQUENCE(EXTRACT(OBJECT_VALUE, '/Factura/LineasDeCompra/LineaDeArticulo/NombreDeArticulo'))) descripcion
WHERE EXISTSNODE
  (
    OBJECT_VALUE,
    '/Factura[ CodigoFactura = "Fact02"]'
  )=1;
  

--Extraer los datos de todas las facturas
SELECT EXTRACTVALUE(OBJECT_VALUE, '/Factura/CodigoFactura'),
       EXTRACTVALUE(VALUE(linea), '/LineaDeArticulo/@numeroLinea'),
       EXTRACTVALUE(VALUE(linea), 'LineaDeArticulo/ArticuloComprado/@codigo'),
       EXTRACTVALUE(VALUE(linea), 'LineaDeArticulo/ArticuloComprado/@cantidad'),
       EXTRACTVALUE(VALUE(linea), 'LineaDeArticulo/ArticuloComprado/@precioUnitario')
FROM "Facturas_XML", TABLE(XMLSEQUENCE(EXTRACT(OBJECT_VALUE, 'Factura/LineasDeCompra/LineaDeArticulo'))) linea;


    
select EXTRACTVALUE(OBJECT_VALUE, '/Factura/CodigoFactura'),
        EXTRACTVALUE(OBJECT_VALUE, '/Factura/Proveedor'),
        EXTRACTVALUE(OBJECT_VALUE, '/Factura/Usuario'),
        EXTRACTVALUE(OBJECT_VALUE, '/Factura/FechaCompra') 
from "Facturas_XML";



select EXTRACTVALUE(SYS_NC_ROWINFO$, '/Factura/CodigoFactura') from "Facturas_XML";