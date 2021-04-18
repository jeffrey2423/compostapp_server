CREATE OR REPLACE FUNCTION f_get_question_answers(in_row_id_question INTEGER, in_row_id_user INTEGER)
   RETURNS TABLE(
       ts_creation TIMESTAMP,
       row_id INTEGER,
       title TEXT,
       content TEXT,
       creator_id INTEGER,
       creator_name TEXT
   ) AS
   $BODY$
DECLARE
	err_context TEXT;
BEGIN
        RETURN QUERY
        SELECT  
                ANSWERS.ts_creation::TIMESTAMP AS ts_creation,
                ANSWERS.row_id::INTEGER AS row_id,
				ANSWERS.content::TEXT AS content,
                USERS.name::TEXT AS creator_name/*,
				LIKES.answer_like::BOOLEAN AS answer_like,
                LIKES.answer_unlike::BOOLEAN AS answer_unlike,
				LIKES.user_id::INTEGER AS id_user_who_likes'*/
            FROM ANSWERS
            LEFT JOIN USERS
            ON ANSWERS.user_id = USERS.row_id
			LEFT JOIN LIKES
			ON ANSWERS.row_id = LIKES.answer_id
			WHERE ANSWERS.question_id = 1
			ORDER BY ANSWERS.ts_creation;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RAISE INFO 'Error Context:%', err_context;
END
$BODY$ LANGUAGE 'plpgsql';