CREATE OR REPLACE FUNCTION f_get_questions()
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
                QUESTIONS.ts_creation::TIMESTAMP AS ts_creation,
                QUESTIONS.row_id::INTEGER AS row_id,
				QUESTIONS.title::TEXT AS title,
                QUESTIONS.content::TEXT AS content,
				T_USERS.row_id::INTEGER AS creator_id,
                T_USERS.name::TEXT AS creator_name                
            FROM QUESTIONS
            LEFT JOIN USERS AS T_USERS
            ON QUESTIONS.user_id = T_USERS.row_id;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RAISE INFO 'Error Context:%', err_context;
END
$BODY$ LANGUAGE 'plpgsql';