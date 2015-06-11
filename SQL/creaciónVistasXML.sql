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
FROM Facturas_OBJ F;
