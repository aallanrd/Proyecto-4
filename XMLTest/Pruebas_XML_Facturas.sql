
SELECT EXTRACTVALUE(VALUE(d), '/NombreDeArticulo') "Nombre del Articulo"
FROM "Facturas_XML",
      TABLE(XMLSEQUENCE(EXTRACT(OBJECT_VALUE, '/Factura/LineasDeCompra/LineaDeArticulo/NombreDeArticulo'))) d
WHERE EXISTSNODE
  (
    OBJECT_VALUE,
    '/Factura[ CodigoFactura = "Fact01"]'
  )=1;


    
SELECT * FROM "Facturas_XML";
