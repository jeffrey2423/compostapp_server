CREATE OR REPLACE FUNCTION f_update_user_password(in_row_id_user INTEGER, in_password TEXT)
    RETURNS void AS
    $BODY$
	DECLARE
		err_context TEXT;
    BEGIN

        UPDATE USERS
        SET
            password = in_password
        WHERE row_id = in_row_id_user;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'