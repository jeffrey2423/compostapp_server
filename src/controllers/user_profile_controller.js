const userProfileController = {};
const resources_controller = require('../resources/resources_controller');
const connection = require('../database/connection');

userProfileController.UpdateProfile = async (req, res) => {
    try {
            await connection.connect(async (err, client, done) => {
                try {
                    let queryValidarUsuario = {
                        text: "select * from f_validate_update_user($1,$2)",
                        values: [req.body.email, req.params.id]
                    };
                    if (err) {
                        res.json(resources_controller.leerRecurso(1018, err.message));
                    } else {
                        await client.query(queryValidarUsuario, async (err, results) => {
                            if (!err) {
                                const estadoUsuario = results.rows[0].f_validate_update_user;
                                if (estadoUsuario === resources_controller.ESTADO_USUARIO.EMAIL_EXISTE) {
                                    res.json(resources_controller.leerRecurso(1012));
                                } else {
                                    let queryUpdateUser = {
                                        text: "select * from f_update_user($1,$2)",
                                        values: [req.body, req.params.id]
                                    };
                                    client.query(queryUpdateUser, async (err, results) => {
                                        if (!err) {
                                            res.json(resources_controller.leerRecurso(1019));

                                        } else {
                                            await client.query("ROLLBACK");
                                            res.json(resources_controller.leerRecurso(1018, err.message));
                                            console.log(err)
                                        }
                                    });
                                }
                            } else {
                                await client.query("ROLLBACK");
                                res.json(resources_controller.leerRecurso(1018, err.message));
                                console.log(err)
                            }
                        });
                    }
                } finally {
                    done();
                    queryValidarUsuario = {}
                    queryUpdateUser = {}
                }
            });
    } catch (error) {
        await client.query("ROLLBACK");
        res.json(resources_controller.leerRecurso(1018, error.message));
        console.log(error)
    }
}

userProfileController.UpdatePassword = async (req, res) => {
    try {
        await connection.connect(async (err, client, done) => {
            try {
                let query = {
                    text: "select * from f_update_user_password($1, $2)",
                    values: [req.params.id, req.body.password]
                };
                if (err) {
                    res.json(resources_controller.leerRecurso(1024, err.message));
                } else {
                    await client.query(query, async (err, results) => {
                        if (!err) {
                            res.json(resources_controller.leerRecurso(1025));
                        } else {
                            await client.query("ROLLBACK");
                            res.json(resources_controller.leerRecurso(1024, err.message));
                        }
                    });
                }
            } finally {
                done();
                query = {}
            }
        });
    } catch (error) {
        await client.query("ROLLBACK");
        res.json(resources_controller.leerRecurso(1024, error.message));
    }
}


module.exports = userProfileController;