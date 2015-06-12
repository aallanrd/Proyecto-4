
--Selecciona las facturas XML de la vista FACTURAS_XML_VIEW dándoles el formato XML Ccon XMLROOT
SELECT XMLROOT(x.OBJECT_VALUE, VERSION '1.0', STANDALONE YES) FROM FACTURAS_XML_VIEW x;


--Imprime las facturas de la vista: FACTURAS_XML_VIEW obtenidas dentro de un cursor
DECLARE
  xml XMLTYPE;
  
  CURSOR XMLCursor IS
    SELECT x.OBJECT_VALUE FROM FACTURAS_XML_VIEW x;
BEGIN
  OPEN XMLCursor;
  
  LOOP
    FETCH XMLCursor INTO xml;
    EXIT WHEN XMLCursor%NOTFOUND;
    dbms_output.put_line('INICIO DE LA FACURA');
    dbms_output.put_line(xml.getCLOBVal());
      
  END LOOP;
  
  CLOSE XMLCursor;
END;












