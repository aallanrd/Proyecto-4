
Create or Replace Procedure insertXMLType  (idDoc int )
IS

  myClob CLOB;
  l_xmlType XMLTYPE;
BEGIN 
 
 
   
   SELECT
   '<Persona id = "200">   
   <Nombre>
     <PrimerNombre> Carlos </PrimerNombre>
     <SegundoNombre> Roberto </SegundoNombre>
     <Apellido> Cabrera </Apellido>
   </Nombre>
   <Telefono> 1234 </Telefono>
  </Persona>'
  
  INTO myClob FROM DUAL;   
  
   
   insert into empleado  (idEmpleado, datos) values (idDoc, XMLTYPE.createXML(myClob));
 
 END ;

--

select * from empleado;


execute insertxmltype ( 200);