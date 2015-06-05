CREATE OR REPLACE DIRECTORY
    EXAMPLE_LOB_DIR2
    AS
    'D:\Archivos de Programa\Oracle';

CREATE TABLE test_clob (
      id           NUMBER(15)
    , file_name    VARCHAR2(1000)
    , xml_file     CLOB
    , timestamp    DATE
);

CREATE OR REPLACE PROCEDURE Load_CLOB_From_XML_File
IS

    dest_clob   CLOB;
    src_clob    BFILE  := BFILENAME('EXAMPLE_LOB_DIR', 'DatabaseInventory.xml');
    dst_offset  number := 1 ;
    src_offset  number := 1 ;
    lang_ctx    number := DBMS_LOB.DEFAULT_LANG_CTX;
    warning     number;

BEGIN

    DBMS_OUTPUT.ENABLE(100000);

    -- -----------------------------------------------------------------------
    -- THE FOLLOWING BLOCK OF CODE WILL ATTEMPT TO INSERT / WRITE THE CONTENTS
    -- OF AN XML FILE TO A CLOB COLUMN. IN THIS CASE, WE WILL USE THE 
    -- DBMS_LOB.LoadFromFile() API WHICH *DOES NOT* SUPPORT MULTI-BYTE
    -- CHARACTER SET DATA.
    -- -----------------------------------------------------------------------

    INSERT INTO test_clob(id, file_name, xml_file, timestamp) 
        VALUES(1001, 'DatabaseInventory.xml', empty_clob(), sysdate)
        RETURNING xml_file INTO dest_clob;

    -- -------------------------------------
    -- OPENING THE SOURCE BFILE IS MANDATORY
    -- -------------------------------------
    DBMS_LOB.OPEN(src_clob, DBMS_LOB.LOB_READONLY);

    DBMS_LOB.LoadFromFile(
          DEST_LOB => dest_clob
        , SRC_LOB  => src_clob
        , AMOUNT   => DBMS_LOB.GETLENGTH(src_clob)
    );

    DBMS_LOB.CLOSE(src_clob);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Loaded XML File using DBMS_LOB.LoadFromFile: (ID=1001).');


    -- -----------------------------------------------------------------------
    -- THE FOLLOWING BLOCK OF CODE WILL ATTEMPT TO INSERT / WRITE THE CONTENTS
    -- OF AN XML FILE TO A CLOB COLUMN. IN THIS CASE, WE WILL USE THE NEW 
    -- DBMS_LOB.LoadCLOBFromFile() API WHICH *DOES* SUPPORT MULTI-BYTE
    -- CHARACTER SET DATA.
    -- -----------------------------------------------------------------------

    INSERT INTO test_clob(id, file_name, xml_file, timestamp) 
        VALUES(1002, 'DatabaseInventory.xml', empty_clob(), sysdate)
        RETURNING xml_file INTO dest_clob;

    -- -------------------------------------
    -- OPENING THE SOURCE BFILE IS MANDATORY
    -- -------------------------------------
    DBMS_LOB.OPEN(src_clob, DBMS_LOB.LOB_READONLY);

    DBMS_LOB.LoadCLOBFromFile(
          DEST_LOB     => dest_clob
        , SRC_BFILE    => src_clob
        , AMOUNT       => DBMS_LOB.GETLENGTH(src_clob)
        , DEST_OFFSET  => dst_offset
        , SRC_OFFSET   => src_offset
        , BFILE_CSID   => DBMS_LOB.DEFAULT_CSID
        , LANG_CONTEXT => lang_ctx
        , WARNING      => warning
    );

    DBMS_LOB.CLOSE(src_clob);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Loaded XML File using DBMS_LOB.LoadCLOBFromFile: (ID=1002).');

END;
