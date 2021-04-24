CREATE OR REPLACE FUNCTION f_get_question_answers(in_row_id_question INTEGER)
   RETURNS TABLE(
       answer_ts_creation TIMESTAMP,
       answer_row_id INTEGER,
       answer_content TEXT,
       answer_creator_row_id INTEGER,
       answer_creator_name TEXT,
       id_users_who_liked TEXT,
       id_users_who_disliked TEXT,
       likes_count INTEGER,
       dislikes_count INTEGER
   ) AS
   $BODY$
DECLARE
	err_context TEXT;

    REACTION_LIKE     INTEGER := 1;
    REACTION_DISLIKE  INTEGER := 2;
BEGIN
        RETURN QUERY
        SELECT  
            ANSWERS.ts_creation::TIMESTAMP AS answer_ts_creation,
            ANSWERS.row_id::INTEGER AS answer_row_id,
            ANSWERS.content::TEXT AS answer_content,
            USERS.row_id::INTEGER AS answer_creator_row_id,
            USERS.name::TEXT AS answer_creator_name,
            array_to_string(array(SELECT LIKES2.user_id FROM LIKES2 WHERE LIKES2.reaction = REACTION_LIKE AND LIKES2.answer_id = ANSWERS.row_id), ',' )::TEXT AS id_users_who_liked,
            array_to_string(array(SELECT LIKES2.user_id FROM LIKES2 WHERE LIKES2.reaction = REACTION_DISLIKE AND LIKES2.answer_id = ANSWERS.row_id), ',' )::TEXT AS id_users_who_disliked,
            COUNT(*) FILTER (WHERE LIKES2.reaction = REACTION_LIKE AND LIKES2.answer_id in (SELECT row_id FROM ANSWERS WHERE question_id = in_row_id_question))::INTEGER AS likes_count,
            COUNT(*) FILTER (WHERE LIKES2.reaction = REACTION_DISLIKE AND LIKES2.answer_id in (SELECT row_id FROM ANSWERS WHERE question_id = in_row_id_question))::INTEGER AS dislikes_count
        FROM ANSWERS
        LEFT JOIN USERS
        ON ANSWERS.user_id = USERS.row_id
        LEFT JOIN LIKES2
        ON ANSWERS.row_id = LIKES2.answer_id
        WHERE LIKES2.answer_id in (SELECT row_id FROM ANSWERS WHERE question_id = in_row_id_question)
        GROUP BY ANSWERS.row_id, USERS.name, USERS.row_id 
        ORDER BY ANSWERS.ts_creation;
    EXCEPTION WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RAISE INFO 'Error Context:%', err_context;
END
$BODY$ LANGUAGE 'plpgsql';