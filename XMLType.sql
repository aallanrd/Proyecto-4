--Ejemplo XML JJ Caicedo 
-- Link https://www.youtube.com/watch?v=AfyV2Te2UoI

create table empleado ( 
              
              idEmpleado Number (3) PRIMARY KEY, 
              datos SYS.XMLTYPE);
              
insert into empleado  (idEmpleado, datos) values (100, sys.XMLTYPE.createXML (

 '<Persona id = "100">   
   <Nombre>
     <PrimerNombre> Carlos </PrimerNombre>
     <SegundoNombre> Roberto </SegundoNombre>
     <Apellido> Cabrera </Apellido>
   </Nombre>
   <Telefono> 1234 </Telefono>
  </Persona>
 
 '));
 
 select * from empleado ;
 
 select idempleado , e.datos.extract('//PrimerNombre/text()').getStringVal() as 
 Nombre FROM empleado e where e.datos.extract ('//Apellido/text()').getStringVal() LIKE ' Cabrera ';
 
 select idempleado , e.datos.extract('//Persona/Nombre/PrimerNombre/text()').getStringVal() as 
 Nombre FROM empleado e where e.datos.extract ('//Apellido/text()').getStringVal() LIKE ' Cabrera ';
 
 
 --dbms_xdb.createfolder('/xml');
 
 
 