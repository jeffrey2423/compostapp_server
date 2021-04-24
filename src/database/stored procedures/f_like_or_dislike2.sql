CREATE OR REPLACE FUNCTION f_like_or_dislike2(in_json_txt JSON)
RETURNS void AS
$BODY$
    DECLARE
        reg             RECORD;
        err_context     TEXT;
        v_action        INTEGER;
        v_row_id_user   INTEGER;
        v_row_id_answer INTEGER;

        /*ACTIONS*/
        ACTION_LIKE                 INTEGER := 1;
        ACTION_DISLIKE              INTEGER := 2;
        ACTION_REMOVE_REACTION      INTEGER := 0;
    BEGIN
        SELECT action         INTO v_action         FROM json_to_record(in_json_txt) AS x(action INTEGER);
        SELECT row_id_user    INTO v_row_id_user    FROM json_to_record(in_json_txt) AS x(row_id_user INTEGER);
        SELECT row_id_answer  INTO v_row_id_answer  FROM json_to_record(in_json_txt) AS x(row_id_answer INTEGER);

        CASE v_action
            WHEN ACTION_LIKE THEN

                IF EXISTS (SELECT 1 FROM LIKES2 WHERE user_id = v_row_id_user AND answer_id = v_row_id_answer) THEN                   
                    UPDATE LIKES2
                    SET 
                        reaction  = ACTION_LIKE
                    WHERE 
                    user_id         = v_row_id_user 
                    AND answer_id   = v_row_id_answer;
                ELSE
                    INSERT INTO LIKES2
                    (user_id, answer_id, reaction) 
                    VALUES 
                    (v_row_id_user, v_row_id_answer, ACTION_LIKE);
                END IF;     

            WHEN ACTION_DISLIKE THEN

                IF EXISTS (SELECT 1 FROM LIKES2 WHERE user_id = v_row_id_user AND answer_id = v_row_id_answer) THEN
                    UPDATE LIKES2
                    SET 
                        reaction  = ACTION_DISLIKE
                    WHERE 
                    user_id         = v_row_id_user 
                    AND answer_id   = v_row_id_answer;            
                ELSE
                    INSERT INTO LIKES2
                    (user_id, answer_id, reaction) 
                    VALUES 
                    (v_row_id_user, v_row_id_answer, ACTION_DISLIKE);
                END IF;

            WHEN ACTION_REMOVE_REACTION THEN
                UPDATE LIKES2
                SET 
                    reaction  = ACTION_REMOVE_REACTION
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