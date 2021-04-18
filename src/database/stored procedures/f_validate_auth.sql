CREATE OR REPLACE FUNCTION f_validate_auth(in_json_txt JSON)
    RETURNS INTEGER
    AS
    $BODY$
        DECLARE
            err_context     TEXT;
            v_err_code      INTEGER := 0; /* 1 no existe, 2 datos incorrectos, 3 existe y correcto*/
            v_email         TEXT;
			v_password      TEXT; 

    BEGIN
	
        SELECT email 
            INTO v_email 
        FROM json_to_record(in_json_txt) 
            AS x(email TEXT);

        IF EXISTS (
            SELECT  1 
            FROM    USERS
            WHERE   email = v_email
        ) THEN
            SELECT password
                INTO v_password 
                FROM json_to_record(in_json_txt) 
                    AS x(password TEXT);

            IF EXISTS (
                SELECT  1 
                FROM    USERS
                WHERE   email       = v_email
                AND     password    = v_password
            ) THEN
                
                v_err_code := 3;
                
            ELSE
                v_err_code := 2;
            END IF;
           
        ELSE
            v_err_code := 1;
        END IF;

        RETURN v_err_code;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'