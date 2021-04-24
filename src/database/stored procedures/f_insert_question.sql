CREATE OR REPLACE FUNCTION f_insert_question(in_json_question JSON)
    RETURNS void AS
    $BODY$
	DECLARE
		err_context TEXT;
    BEGIN

        INSERT INTO QUESTIONS(
            user_id,
            title,
            content
        )
        SELECT
            user_id,
            title,
            content
        FROM json_to_record(in_json_question) AS x( 
            user_id INTEGER,
            title   TEXT,
            content TEXT
        );

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'