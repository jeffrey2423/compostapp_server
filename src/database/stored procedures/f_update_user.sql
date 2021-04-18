CREATE OR REPLACE FUNCTION f_update_user(in_json_txt JSON, in_row_id_user INTEGER)
    RETURNS void AS
    $BODY$
	DECLARE
		err_context  TEXT;
        v_name       TEXT;
        v_email      TEXT;

    BEGIN
        SELECT name     INTO v_name             FROM json_to_record(in_json_txt) AS x(name TEXT);
        SELECT email    INTO v_email            FROM json_to_record(in_json_txt) AS x(email TEXT);

        UPDATE USERS
            SET
                name            = v_name,
                email           = v_email
        WHERE   row_id          = in_row_id_user;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'