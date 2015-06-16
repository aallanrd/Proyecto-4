
CREATE OR REPLACE PROCEDURE sp_mostrarFacturas (facturas OUT SYS_REFCURSOR)
IS
  BEGIN
    OPEN facturas 
    FOR
      select f.codFactura, f.codProveedor, f.codUsuario, f.fechaCompra, 
             l.descriArticulo, l.codArticulo, l.cantidad, l.precioUnitario
      from FACTURA_VIEW f
      inner join LINEAS_FACTURA_VIEW l
      on l.codFactura = f.codFactura
      order by f.fechaCompra ASC;
  END;