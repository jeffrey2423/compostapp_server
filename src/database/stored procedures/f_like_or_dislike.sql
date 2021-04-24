CREATE OR REPLACE FUNCTION f_like_or_dislike(in_json_txt JSON)
RETURNS void AS
$BODY$
    DECLARE
        reg             RECORD;
        err_context     TEXT;
        v_action        INTEGER;
        v_row_id_user   INTEGER;
        v_row_id_answer INTEGER;

        /*ACTIONS*/
        ACTION_LIKE             INTEGER := 1;
        ACTION_DISLIKE          INTEGER := 2;
        ACTION_REMOVE_LIKE      INTEGER := 3;
        ACTION_REMOVE_DISLIKE   INTEGER := 4;
    BEGIN
        SELECT action         INTO v_action         FROM json_to_record(in_json_txt) AS x(action INTEGER);
        SELECT row_id_user    INTO v_row_id_user    FROM json_to_record(in_json_txt) AS x(row_id_user INTEGER);
        SELECT row_id_answer  INTO v_row_id_answer  FROM json_to_record(in_json_txt) AS x(row_id_answer INTEGER);

        CASE v_action
            WHEN ACTION_LIKE THEN

                IF EXISTS (SELECT 1 FROM LIKES WHERE user_id = v_row_id_user AND answer_id = v_row_id_answer) THEN
                    
                    UPDATE LIKES
                    SET 
                        answer_like     = true,
                        answer_dislike  = false
                    WHERE 
                    user_id         = v_row_id_user 
                    AND answer_id   = v_row_id_answer;

                ELSE

                    INSERT INTO LIKES 
                    (user_id, answer_id, answer_like, answer_dislike) 
                    VALUES 
                    (v_row_id_user, v_row_id_answer, true, false);

                END IF;     

            WHEN ACTION_DISLIKE THEN

                IF EXISTS (SELECT 1 FROM LIKES WHERE user_id = v_row_id_user AND answer_id = v_row_id_answer) THEN
                    UPDATE LIKES
                    SET 
                        answer_like     = false,
                        answer_dislike  = true
                    WHERE 
                    user_id         = v_row_id_user 
                    AND answer_id   = v_row_id_answer;             
                ELSE

                    INSERT INTO LIKES 
                    (user_id, answer_id, answer_like, answer_dislike) 
                    VALUES 
                    (v_row_id_user, v_row_id_answer, false, true);

                END IF;

            WHEN ACTION_REMOVE_LIKE THEN

                UPDATE LIKES
                SET 
                    answer_like  = false
                WHERE 
                user_id         = v_row_id_user 
                AND answer_id   = v_row_id_answer;
                
            WHEN ACTION_REMOVE_DISLIKE THEN

                UPDATE LIKES
                SET 
                    answer_dislike  = false
                WHERE 
                user_id         = v_row_id_user 
                AND answer_id   = v_row_id_answer;

            ELSE
                   
        END CASE;

        EXCEPTION WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS err_context = PG_EXCEPTION_CONTEXT;
            RAISE INFO 'Error Name:%',SQLERRM;
            RAISE INFO 'Error State:%', SQLSTATE;
            RAISE INFO 'Error Context:%', err_context;
    END
$BODY$ LANGUAGE 'plpgsql'

