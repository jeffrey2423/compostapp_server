CREATE OR REPLACE FUNCTION f_answer_question(in_json_answer JSON)
    RETURNS void AS
    $BODY$
	DECLARE
		err_context TEXT;
    BEGIN

        INSERT INTO ANSWERS(
            user_id,
            question_id,
            content
        )
        SELECT
            user_id,
            question_id,
            content
        FROM json_to_record(in_json_answer) AS x( 
            user_id         INTEGER,
            question_id     INTEGER,
            content         TEXT
        );

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;

    END
$BODY$ LANGUAGE 'plpgsql'