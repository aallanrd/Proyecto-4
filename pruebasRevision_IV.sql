
delete facturas_obj;
commit;
select * from facturas_obj;

SELECT f.codigoFactura, f.fechaCompra, lineas.* 
FROM Facturas_OBJ f, TABLE(f.lineasDeCompra) lineas;


--PRUEBAS DE LAS VISTA
SELECT * FROM FACTURA_VIEW;
SELECT * FROM LINEAS_FACTURA_VIEW;