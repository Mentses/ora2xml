@echo off
rem 加载数据库配置
for /f "delims=;" %%a in (conf\db.ini) do (
set %%a
)

rem 加载导出表配置
for /f "delims=;" %%a in (conf\data.ini) do (
set %%a
)
rem sqlplus -s yuxiao/yuxiao@ora_ip: @run.sql 20391 BJ 20190101100000
sqlplus -s %ora_uid%/%ora_pwd%@%ora_ip%:%ora_port%/%ora_sid% @run.sql %TABLE_ID% %CITYCODE% %DATATIME%
exit
