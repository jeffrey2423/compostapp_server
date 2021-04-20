const forumController = {};
const resources_controller = require('../resources/resources_controller');
const connection = require('../database/connection');

forumController.CreateQuestion = async (req, res) => {
    try {
        await connection.connect(async (err, client, done) => {
            try {
                let createQuestionQuery = {
                    text: "select * from f_insert_question($1)",
                    values: [req.body]
                };
                if (err) {
                    res.json(resources_controller.leerRecurso(1027, err.message));
                } else {
                    await client.query(createQuestionQuery, async (err, results) => {
                        if (!err) {
                            res.json(resources_controller.leerRecurso(1026));
                        } else {
                            await client.query("ROLLBACK");
                            res.json(resources_controller.leerRecurso(1027, err.message));
                        }
                    });
                }
            } finally {
                done();
                createQuestionQuery = {}
            }
        });
    } catch (error) {
        await client.query("ROLLBACK");
        res.json(resources_controller.leerRecurso(1027, error.message));
    }
}

forumController.GetQuestions = async (req, res) => {
    try {
        let query = {
            text: `SELECT * FROM f_get_questions()`
        };
        await connection.connect(async (err, client, done) => {
            try {
                if (err) {
                    res.json(resources_controller.leerRecurso(1028, err.message));
                } else {
                    await client.query(query, async (err, results) => {
                        if (err) {
                            await client.query("ROLLBACK");
                            res.json(resources_controller.leerRecurso(1028, err.message));
                        } else {

                            res.status(200).json(results.rows);

                        }
                    });
                }
            } finally {
                done();
                query = {};
            }
        });

    } catch (error) {
        res.json(resources_controller.leerRecurso(1028, error.message));
    }
}

forumController.CreateAnswer = async (req, res) => {
    try {
        await connection.connect(async (err, client, done) => {
            try {
                let createQuestionQuery = {
                    text: "select * from f_answer_question($1)",
                    values: [req.body]
                };
                if (err) {
                    res.json(resources_controller.leerRecurso(1030, err.message));
                } else {
                    await client.query(createQuestionQuery, async (err, results) => {
                        if (!err) {
                            res.json(resources_controller.leerRecurso(1029));
                        } else {
                            await client.query("ROLLBACK");
                            res.json(resources_controller.leerRecurso(1030, err.message));
                        }
                    });
                }
            } finally {
                done();
                createQuestionQuery = {}
            }
        });
    } catch (error) {
        await client.query("ROLLBACK");
        res.json(resources_controller.leerRecurso(1030, error.message));
    }
}

forumController.LikeOrDislike = async (req, res) => {
    try {
        await connection.connect(async (err, client, done) => {
            try {
                let LikeOrDislikeQuery = {
                    text: "select * from f_like_or_dislike2($1)",
                    values: [req.body]
                };
                if (err) {
                    res.json(resources_controller.leerRecurso(1031, err.message));
                } else {
                    await client.query(LikeOrDislikeQuery, async (err, results) => {
                        if (!err) {
                            res.json(resources_controller.leerRecurso(1032));
                        } else {
                            await client.query("ROLLBACK");
                            res.json(resources_controller.leerRecurso(1031, err.message));
                        }
                    });
                }
            } finally {
                done();
                LikeOrDislikeQuery = {}
            }
        });
    } catch (error) {
        await client.query("ROLLBACK");
        res.json(resources_controller.leerRecurso(1031, error.message));
    }
}

module.exports = forumController;