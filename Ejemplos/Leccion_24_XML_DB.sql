-- Procedimiento que activa el listener para http en el puerto 9090
-- Procedimiento que activa el listener para ftp en el puerto 2100
begin
    dbms_xdb.setHTTPport(9090);
    dbms_xdb.setFTPport(2100);
end;
/

commit;

-- El directorio xsd (XML Schema Definition) contiene el esquema de los documentos
-- orden de compra.
-- El directorio xsl (Extensible StyleSheet Language) contiene el archivo de
-- estilo para las ordenes de compra.
declare 
      resultado boolean;
begin  
      resultado :=  dbms_xdb.createfolder('/xml');
      resultado :=  dbms_xdb.createfolder('/xml/poSource');
      resultado :=  dbms_xdb.createfolder('/xml/poSource/xsd');
      resultado :=  dbms_xdb.createfolder('/xml/poSource/xsl');
      resultado :=  dbms_xdb.createfolder('/xml/poSource/purchaseOrders');
end;
/

-- Se confirma la definicion de los directorios.
commit;
/

-- Elimina el esquema.
begin
  dbms_xmlschema.deleteschema(
    schemaurl => 'http://172.19.127.101:9090/xml/poSource/xsd/purchaseOrder.xsd',
    DELETE_OPTION => dbms_xmlschema.delete_cascade_force
  );
end;
/

-- Registra el esquema.
begin
  dbms_xmlschema.registerschema(
    schemaurl => 'http://172.19.127.101:9090/xml/poSource/xsd/purchaseOrder.xsd',
    schemadoc =>  xdbURIType('/xml/poSource/xsd/purchaseOrder.xsd').getClob(),
    local => TRUE,
    genTypes => TRUE,
    genBean => FALSE,
    genTables => TRUE
  );
end;
/

-- Obtiene el numero de ordenes de compra registradas.
SELECT COUNT(*) FROM PURCHASEORDER
/

-- Anadiendo restricciones de intregridad.
alter table PURCHASEORDER
      add constraint REFERENCE_IS_UNIQUE UNIQUE (XMLDATA."REFERENCE");
/

-- cada nueva instancia de documento es valida contra el esquema antes de
-- insertarla en la base de datos.
create or replace trigger VALIDATE_PURCHASEORDER
before insert on PURCHASEORDER
for each row
begin
   if (:new.object_value is not null) then
       :new.object_value.schemavalidate();
   end if;
end;
/

-- Obtener el numero de documentos registrados.
select COUNT(*) from PURCHASEORDER
/

-- Obtiene cuantas ordenes de compra son del usuario "AMCEWEN".
select count(*) from PURCHASEORDER
where existsNode(object_value,'/PurchaseOrder[User="AMCEWEN"]') = 1;
/

-- Obtener el usuario de la orden de compra cuya referencia es "EABEL-20030409123336251PDT".
select  extract(object_value,'/PurchaseOrder/User') from PURCHASEORDER
where existsNode(object_value, '/PurchaseOrder[Reference = "AMCEWEN-20021009123336180PDT"]') = 1
/

-- Obtener el numero total de lineas de todas los documentos orden de compra registrado.
select count(*)
from PURCHASEORDER,
     table(
       xmlsequence(extract(object_value, '/PurchaseOrder/LineItems/LineItem'))) l
/

-- Obtener la referencia de las ordenes de compra con el id = "715515009058".
select extractValue(object_value, '/PurchaseOrder/User') "User"
from PURCHASEORDER
where existsNode(
            object_value,
            '/PurchaseOrder/LineItems/LineItem/Part[@Id = "715515009058"]'
       ) = 1
/

-- Obtener la descripcion de los items de la orden de compra con referencia
-- "AMCEWEN-20021009123336180PDT".
--
select extractValue(value(d), '/Description')
from PURCHASEORDER,
     table(
            xmlsequence(extract(object_value,'/PurchaseOrder/LineItems/LineItem/Description'))) d
where  existsNode
       (
           object_value,
           '/PurchaseOrder[ Reference = "AMCEWEN-20021009123336180PDT"]'
       ) = 1
/

-- Definicion de indices.
create index PURCHASEORDER_USER_IDX on PURCHASEORDER x (extractValue(value(x), '/PurchaseOrder/User'))
/

-- RENOMBRAR LA TABLA ANIDADA PREVIO A DEFINIR EL INDICE
-- COMPLETAR A TRAVES DE LA INTERFAZ GRAFICA DE SQLDEVELOPER.
-- En este caso la tabla anidada correspondiente a la agregación
-- LineItems se debe renombrar como LINEITEMS_NT.
create index LineItemPartNumber_idx on LINEITEMS_NT x( x.ITEMNUMBER, x.PART.PART_NUMBER, x.NESTED_TABLE_ID)
/

create index PARTNUMBER_IDX on LINEITEMS_NT x (x.PART.PART_NUMBER, x.NESTED_TABLE_ID)
/

analyze table PURCHASEORDER compute statistics for table
/

analyze table LINEITEMS_NT compute statistics for table
/

-- Acceso basado en rutas y actualizacion de contenido XML.

-- Obtener el texto del documento AMCEWEN-20021009123336180PDT.xml
select xdbURIType('/xml/poSource/purchaseOrders/AMCEWEN-20021009123336180PDT.xml').getXML()
from dual
/

-- Obtener la version caracter del documento XML a traves de la vista resource_view
select r.res.getCLOBVal()
from resource_view r
where equals_path(res, '/xml/poSource/purchaseOrders/AMCEWEN-20021009123336271PDT.xml') = 1
/

-- Obtener la ruta al documento por medio de la  vista resource_view
select r.any_path, extractValue(r.res,'/Resource/RefCount')
from resource_view r
where equals_path(
                    res, '/xml/poSource/purchaseOrders/AMCEWEN-20021009123336180PDT.xml') = 1
                  
-- Actualizar el usuario del documento 'AMCEWEN-20021009123336180PDT'
update PURCHASEORDER p
       set object_value = updateXML(object_value, '/PurchaseOrder/User/text()', 'STRADI')
where  existsNode(object_value,
           '/PurchaseOrder[ Reference = "AMCEWEN-20021009123336180PDT"]' ) = 1
/

commit;
/

-- Atributos de la vista  Resource_view para los documentos
-- del directorio /xml/poSource/purchaseOrders.
--
select any_path,
       extractValue(res,'/Resource/ContentType'),
       extractValue(res,'/Resource/CharacterSet'),
       extractValue(res,'/Resource/Language'),
       extractValue(res,'/Resource/DisplayName')
from  resource_view
where under_path(res, '/xml/poSource/purchaseOrders') = 1
/ 

desc path_view
/

select extractValue(object_value,'/PurchaseOrder/Reference') from PURCHASEORDER
where existsNode(object_value,'/PurchaseOrder[User="STRADI"]') = 1;
/

--  Vistas asociadas con el repositorio XML.
--  RESOURCE_VIEW    texto de cada documento XML.
--  PATH_VIEW        inf. acerca de cada documento registrado.

-- Cuantas ordenes de compra existen en el directorio de ordenes de compra.
select count(*) from RESOURCE_VIEW where under_path(RES, '/xml/poSource/purchaseOrders') = 1
/

-- Mostrar los documentos almacenados en el directorio solicitado.
select path from PATH_VIEW  where under_path(res,1, '/xml/poSource/purchaseOrders') = 1
/

select extractValue(res,'/Resource/ContentType') 
                  from resource_view
                  where  equals_path(res, '/xml/poSource/purchaseOrders/AMCEWEN-20021009123336271PDT.xml') = 1;
/ 

-- Seleccionar los nombres de documentos que incluyen dentro de sus items al 7155. --- Revisar
select path, extractValue(object_value,'/PurchaseOrder/Reference')
from   path_view, purchaseOrder p
where  extractValue(res, '/Resource/XMLRef')  = ref(p)  and
       existsNode(object_value,'/PurchaseOrder/LineItems/LineItem/Part[@Id = "715515009058"]') = 1

-- Acceso relacional a contenido XML.
create or replace view  purchase_order_master_view
                        (reference, requestor,  userid,  costcenter, ship_to_name, ship_to_address,
                         ship_to_phone, instructions)
as
   select
          extractValue(object_value, '/PurchaseOrder/Reference'),
          extractValue(object_value, '/PurchaseOrder/Requestor'),
          extractValue(object_value, '/PurchaseOrder/User'),
          extractValue(object_value, '/PurchaseOrder/CostCenter'),
          extractValue(object_value, '/PurchaseOrder/ShippingInstructions/name'),
          extractValue(object_value, '/PurchaseOrder/ShippingInstructions/address'),
          extractValue(object_value, '/PurchaseOrder/Shippinginstructions/telephone'),
          extractValue(object_value, '/PurchaseOrder/SpecialInstructions')
    from  purchaseOrder   
/

select * from purchase_order_master_view

describe purchase_order_master_view

create or replace view PURCHASE_DETAIL_VIEW 
                      (REFERENCE, ITEMNO, DESCRIPTION, PARTNO, QUANTITY, UNITPRICE)
as
     select
           extractValue(object_value, '/PurchaseOrder/Reference'),
           extractValue(value(l), '/LineItem/@ItemNumber'),
           extractValue(value(l), '/LineItem/Description'),
           extractValue(value(l), '/LineItem/Part/@Id'),
           extractValue(value(l), '/LineItem/Part/@Quantity'),
           extractValue(value(l), '/LineItem/Part/@UnitPrice')          
     from  PURCHASEORDER,
     table(xmlsequence(extract(object_value,'PurchaseOrder/LineItems/LineItem'))) l
/

desc purchase_order_master_view

select reference, costcenter, ship_to_name
from purchase_order_master_view
/

select d.reference, d.itemNo, d.partNo, d.description
from   PURCHASE_ORDER_MASTER_VIEW m inner join PURCHASE_DETAIL_VIEW d on m.reference = d.reference
/

select partNo, count(*) "Numero de ordenes", quantity "Numero de copias"
from purchase_detail_view
where partNo in (715515009126, 715515009058)
group by rollup(partNo, quantity)
/

-- Esquema: HR.
-- Definicion de vista XML de la tabla departamento 
CREATE OR REPLACE VIEW DEPARTMENT_XML OF xmltype
WITH OBJECT ID (
   substr(extractValue(OBJECT_VALUE, 'Department/Name'), 1, 128)) 
AS
  SELECT XMLElement(
	"Department",
	XMLAttributes(d.DEPARTMENT_ID AS "DepartmentId"),
	XMLElement("Name", d.DEPARTMENT_NAME),
	XMLElement(
		     "Location",
		     XMLForest(
                    street_address  AS "Address",
                    city            AS "City",
                    state_province  AS "State",
                    postal_code     AS "Zip",
                    country_name    AS "Country"
			     )
		   ),
	XMLElement(
		     "EmployeeList",
		     (SELECT XMLAgg(
          				    XMLElement("Employee",
					      XMLAttributes(e.employee_id AS "employeeNumber"),
					      XMLForest(  e.first_name   AS "FirstName",
						           e.last_name    AS "LastName",
						           e.email        AS "EmailAddress",
						           e.phone_number AS "PHONE_NUMBER",
						           e.hire_date    AS "StartDate",
						           j.job_title    AS "JobTitle",
						           e.salary       AS "Salary",
						           m.first_name || '  ' || m.last_name AS "Manager"
						          ),
					      XMLElement("Commission", e.commission_pct)
					    )
				   )
		       FROM  hr.employees e, hr.employees m, hr.jobs j
		       WHERE e.department_id = d.department_id
                 AND j.job_id = e.job_id
                 AND m.employee_id = e.manager_id)
		      )
	) AS XML
FROM hr.departments d, hr.countries c, hr.locations l
WHERE department_name = 'Executive'
AND d.location_id = l.location_id
AND l.country_id = c.country_id;
/

Select * from department_xml

-- Recupera los elementos del primer nivel del documento asociado al Depto
-- cuyo nombre es Executive.
select XMLTYPE.extract(object_value, '/*')
from DEPARTMENT_XML
where existsNode(object_value,'/Department[Name="Executive"]') = 1
/

-- Recupera el texto del documento asociado al Depto. cuyo nombre es Executive.
select d.getCLOBVal()
FROM department_xml d
where existsNode(object_value,'/Department[Name="Executive"]') = 1
/