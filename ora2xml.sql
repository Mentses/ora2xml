DECLARE
  TYPE TYPECURSOR IS REF CURSOR;
  CURSRC    TYPECURSOR;
  CURID     NUMBER;
  DESCTAB   DBMS_SQL.DESC_TAB;
  COLCNT    NUMBER;
  VNAME     VARCHAR2(50);
  VNUM      NUMBER;
  VDATE     DATE;
  SQLSTMT VARCHAR2(2000);
  V_TABLE_ID  VARCHAR2(20);
  V_CITYCODE  VARCHAR2(20);
  V_DATATIME  VARCHAR2(20);
BEGIN
  V_TABLE_ID := '&1';
  V_CITYCODE := '&2';
  V_DATATIME := '&3';
  SQLSTMT := 'SELECT * FROM T'||V_TABLE_ID||'0000000 WHERE CITYCODE = '''||V_CITYCODE||''' AND F'||V_TABLE_ID||'0100000 = '''||V_DATATIME||'''';
  -- �򿪹��
  --DBMS_OUTPUT.PUT_LINE(SQLSTMT);
  OPEN CURSRC FOR SQLSTMT;
    
  -- �ӱ��ض�̬SQLת��ΪDBMS_SQL
  CURID := DBMS_SQL.TO_CURSOR_NUMBER(CURSRC);
  -- ��ȡ�α������������������ÿ�������е����ԣ��������������ͣ����ȵ�
  DBMS_SQL.DESCRIBE_COLUMNS(CURID, COLCNT, DESCTAB);
  -- ������
  FOR I IN 1 .. COLCNT LOOP
    -- �˴��Ƕ����α����еĶ�ȡ���ͣ����Զ���Ϊ�ַ������ֺ��������ͣ�
    IF DESCTAB(I).COL_TYPE = 2 THEN
      DBMS_SQL.DEFINE_COLUMN(CURID, I, VNUM);
    ELSIF DESCTAB(I).COL_TYPE = 12 THEN
      DBMS_SQL.DEFINE_COLUMN(CURID, I, VDATE);
    ELSE
      DBMS_SQL.DEFINE_COLUMN(CURID, I, VNAME, 50);
    END IF;
  END LOOP;
  -- DBMS_SQL����ȡ��
  -- ���α��а����ݼ�������������BUFFER���У������� ��ֵֻ�ܱ�����COULUMN_VALUE()����ȡ
  DBMS_OUTPUT.PUT_LINE('<?xml version="1.0" encoding="GB2312"?>');
  DBMS_OUTPUT.PUT_LINE('<!-- Edited with ora2xml by yuxiao '||TO_CHAR(SYSDATE,'yyyy-mm-dd hh24:mi:ss'||' -->'));
  DBMS_OUTPUT.PUT_LINE('<H1>');
  WHILE DBMS_SQL.FETCH_ROWS(CURID) > 0 LOOP
    -- ����COLUMN_VALUE()�ѻ��������е�ֵ������Ӧ�����С�
    DBMS_OUTPUT.PUT_LINE('  <F'||V_TABLE_ID||'0000000>');
    FOR I IN 1 .. COLCNT LOOP
      IF DESCTAB(I).COL_TYPE = 1 THEN
        DBMS_SQL.COLUMN_VALUE(CURID, I, VNAME);
        DBMS_OUTPUT.PUT_LINE('    <'||DESCTAB(I).COL_NAME || '>' || VNAME || '</'||DESCTAB(I).COL_NAME || '>');
      ELSIF (DESCTAB(I).COL_TYPE = 2) THEN
        DBMS_SQL.COLUMN_VALUE(CURID, I, VNUM);
        DBMS_OUTPUT.PUT_LINE('    <'||DESCTAB(I).COL_NAME || '>'  || CASE WHEN VNUM < 1 AND VNUM > 0 THEN '0'||TO_CHAR(VNUM) ELSE TO_CHAR(VNUM) END || '</'||DESCTAB(I).COL_NAME || '>' );
      ELSIF (DESCTAB(I).COL_TYPE = 12) THEN
        DBMS_SQL.COLUMN_VALUE(CURID, I, VDATE);
        DBMS_OUTPUT.PUT_LINE('    <'||DESCTAB(I).COL_NAME || '>' || ' ' || TO_CHAR(VDATE, 'YYYY-MM-DD HH24:MI:SS') || '</'||DESCTAB(I).COL_NAME || '>' );
      END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('  </F'||V_TABLE_ID||'0000000>');
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('</H1>');
  DBMS_SQL.CLOSE_CURSOR(CURID);
END;
/
