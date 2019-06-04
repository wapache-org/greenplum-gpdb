    set PGPORT=%1
    set PGUSER=gpadmin
    set PGHOST=127.0.0.1
    call "C:\Program Files\Greenplum\greenplum-clients-%2\greenplum_clients_path.bat"
    cd gpload2
    python TEST_REMOTE.py