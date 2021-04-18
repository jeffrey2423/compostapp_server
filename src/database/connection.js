const { Pool } = require('pg');
const config = require('../config/config')

const connection = new Pool(
    config.DB_CREDENTIALS.HEROKU
);

connection.connect(async (err, client, done) => {
    try {
        if (err) {
            console.log(err.message);
        } else {
            console.log("Conexion a base de datos exitosa");
        }
    }catch(err){
        console.log(err.message);
    }finally{
        done();
    }
});

module.exports = connection;