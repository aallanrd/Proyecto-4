-- Define acl para dar acceso completo a un usuario llamado grupoXX
declare
  r boolean;
begin
  r := DBMS_XDB.createResource('/sys/acls/all_usr_acl.xml',
  '<acl description="grupo_acl"
  xmlns="http://xmlns.oracle.com/xdb/acl.xsd"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd
  http://xmlns.oracle.com/xdb/acl.xsd">
  <ace>
    <principal>grupoXX</principal>
    <grant>true</grant>
        <privilege>
                  <all/>
         </privilege>
    </ace>
  </acl>');
  commit;
end;
/

-- Asigna derechos de xdbadmin a grupoXX
-- Asigna acceso completo a partir del directorio raíz /
-- Define un directorio grupoXX en el directorio raíz
declare 
      resultado boolean;
begin  
      grant xdbadmin to grupoXX;
      grant alter session to grupoXX;
      dbms_xdb.setAcl('/', '/sys/acls/all_all_acl.xml');
      -- select dbms_xdb.getprivileges('/') from dual;
      resultado :=  dbms_xdb.createfolder('/grupoXX');
      commit;
end;
/
