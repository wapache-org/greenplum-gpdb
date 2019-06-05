set PGPORT=%1
set PGUSER=gpadmin
set PGHOST=127.0.0.1

call "C:\Program Files\Greenplum\greenplum-clients\greenplum_clients_path.bat"
psql -U gpadmin -p 15432 -h 127.0.0.1 -c "select version();" "dbname=postgres"
psql -U gpadmin -p 15432 -h 127.0.0.1 -c "select version();" "dbname=postgres sslmode=require"
cd gpload2
python TEST_REMOTE.py