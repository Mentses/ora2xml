set serveroutput on
set trimspool on
set linesize 4000
set pagesize 0
set newpage 1
set heading off
set term off
set verify off
set feedback off
alter session set nls_date_format='yyyymmddhh24miss'
exec dbms_output.put_line('---Begin---');
spool xml\T20391.xml
@@ ora2xml.sql '&1' '&2' '&3'
spool off
exec dbms_output.put_line('---End..---')
/
exit;
