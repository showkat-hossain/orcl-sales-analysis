/* 	Tables are dropped and purged. The second drop gets rid of all
    other objects including identity column sequences.  */

BEGIN
   FOR table_rec IN (SELECT object_name, object_type
                        FROM user_objects
                        WHERE object_type = 'TABLE')
    LOOP
      EXECUTE IMMEDIATE    'DROP '
                              || table_rec.object_type
                              || ' "'
                              || table_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         
    END LOOP;
   
    EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';  
   
   FOR obj_rec IN (SELECT object_name, object_type
                      FROM user_objects
                      WHERE object_type IN
                             ('VIEW',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'PACKAGE',
                              'SYNONYM',
                              'INDEX'
                              ))
   LOOP
       EXECUTE IMMEDIATE    'DROP '
                              || obj_rec.object_type
                              || ' "'
                              || obj_rec.object_name
                              || '"';
        
   END LOOP;
END;
/ 