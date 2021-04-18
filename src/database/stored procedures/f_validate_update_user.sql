CREATE OR REPLACE FUNCTION f_validate_update_user(in_email TEXT, in_row_id_user INTEGER)
    RETURNS INTEGER
    AS
    $BODY$
        DECLARE
            err_context TEXT;
            v_err_code  INTEGER := 0; /*0 no existe -1 email existe*/

    BEGIN

        IF EXISTS 
        (
            SELECT  1 
            FROM    USERS
            WHERE   email   =  in_email
            AND     row_id  <> in_row_id_user

        ) THEN
            v_err_code := -1;
        ELSE
            v_err_code := 0;
        END IF;

        RETURN v_err_code;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'