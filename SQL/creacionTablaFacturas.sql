--Tipo para los datos de un artículo comprado
CREATE OR REPLACE TYPE T_ArticuloComprado AS OBJECT
(
  codigo VARCHAR2(20 CHAR),
  cantidad NUMBER(5),
  precioUnitario NUMBER(18,2)
  
);
/
--Tipo para manejar el conjunto de artículos de la factura 
CREATE OR REPLACE TYPE T_LineasCompra
AS 
  TABLE OF T_ArticuloComprado;

--Creación del tipo para los datos de la factura
CREATE OR REPLACE TYPE T_Factura AS OBJECT
(
  codigoFactura VARCHAR2(25),
  proveedor VARCHAR2(20),
  usuario VARCHAR2(20),
  fechaCompra DATE,
  lineasDeCompra T_LineasCompra
);
/
--CREACIÓN DE LA TABLA DE FACTURAS
CREATE TABLE Facturas_OBJ OF T_Factura
(
  codigoFactura NOT NULL,
  proveedor NOT NULL,
  usuario NOT NULL,
  fechaCompra NOT NULL,
  CONSTRAINT Factura_PK PRIMARY KEY(codigoFactura)
) NESTED TABLE lineasDeCompra STORE AS lineasDeCompraNT ;
/



--//////////////////////////////////////////////////////////////////////////////
--INSERCIÓN DE DATOS PARA LAS FACTURAS
INSERT INTO Facturas_OBJ VALUES ('Fact01', 'Prov01', 'jrojas', SYSDATE,
                                T_LineasCompra(
                                  T_ArticuloComprado('TMHYPER', 2, 45.5),
                                  T_ArticuloComprado('DD500GB', 10, 15.34)
                                ));

SELECT lineas.* 
FROM Facturas_OBJ f, TABLE(f.lineasDeCompra) lineas
WHERE f.codigoFactura = 'Fact01';

select * from facturas_obj;


