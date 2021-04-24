const authController = {};
const resources_controller = require('../resources/resources_controller');
const connection = require('../database/connection');
const CONFIG = require("../config/config");
const jwt = require("jsonwebtoken");

authController.SignIn = async (req, res) => {
    try {
        let query = {
            text: "select * from f_validate_auth($1)",
            values: [req.body]
        };
        await connection.connect(async (err, client, done) => {
            try {
                if (err) {
                    res.json(resources_controller.leerRecurso(1005, err.message));
                } else {
                    await client.query(query, async (err, results) => {
                        if (err) {
                            await client.query("ROLLBACK");
                            res.json(resources_controller.leerRecurso(1005, err.message));
                        } else {
                            switch (results.rows[0].f_validate_auth) {
                                case resources_controller.ESTADO_USUARIO.NO_EXISTE:
                                    res.json(resources_controller.leerRecurso(1008));
                                    break;
                                case resources_controller.ESTADO_USUARIO.DATOS_INCORRECTOS:
                                    res.json(resources_controller.leerRecurso(1006));
                                    break;
                                default:
                                    query = {
                                        text: "select * from f_user_auth($1)",
                                        values: [req.body]
                                    };
                                    await client.query(query, async (err, results) => {
                                        if (!err) {
                                            jwt.sign(results.rows[0], CONFIG.ENCRYPTION_SECRET_KEY, (jwtErr, token) => {
                                                if (!jwtErr) {
                                                    res.status(200).json({
                                                        token: token
                                                    });
                                                } else {
                                                    res.json(resources_controller.leerRecurso(1005, jwtErr.message));
                                                }
                                            });

                                        } else {
                                            await client.query('ROLLBACK');
                                            res.json(resources_controller.leerRecurso(1005, err.message));
                                        }
                                    });
                            }
                        }
                    });
                }
            } finally {
                done();
                query = {};
                io = "";
            }
        });
    } catch (error) {
        res.json(resources_controller.leerRecurso(1005, error.message));
    }

}

authController.SignUp = async (req, res) => {
    try {
        await connection.connect(async (err, client, done) => {
            try {
                let queryValidarUsuario = {
                    text: "select * from f_validate_insert_user($1)",
                    values: [req.body.email]
                };
                if (err) {
                    res.json(resources_controller.leerRecurso(1003, err.message));
                } else {
                    await client.query(queryValidarUsuario, async (err, results) => {
                        if (!err) {
                            const estadoUsuario = results.rows[0].f_validate_insert_user;
                            if (estadoUsuario === resources_controller.ESTADO_USUARIO.EMAIL_EXISTE) {
                                res.json(resources_controller.leerRecurso(1012));
                            } else {
                                let queryInsertUser = {
                                    text: "select * from f_insert_user($1)",
                                    values: [req.body]
                                };
                                client.query(queryInsertUser, async (err, results) => {
                                    if (!err) {
                                        res.json(resources_controller.leerRecurso(1002));

                                    } else {
                                        await client.query("ROLLBACK");
                                        res.json(resources_controller.leerRecurso(1003, err.message));
                                        console.log(err)
                                    }
                                });
                            }
                        } else {
                            await client.query("ROLLBACK");
                            res.json(resources_controller.leerRecurso(1003, err.message));
                            console.log(err)
                        }
                    });
                }
            } finally {
                done();
                queryValidarUsuario = {}
                queryInsertUser = {}
            }
        });
    } catch (error) {
        await client.query("ROLLBACK");
        res.json(resources_controller.leerRecurso(1003, error.message));
        console.log(error)
    }
}



module.exports = authController;