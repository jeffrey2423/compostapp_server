const endPoints = require("../resources/constants/endPoints");
const resources_controller = require('../resources/resources_controller');

module.exports = (req, res, next) => {
    try {
        if (req.path != endPoints.LOGIN) {
            if (req.headers.authorization) {
                next();
            }else{
                res.json(resources_controller.leerRecurso(1010));
            }
        }else{
            next();
        }
        
    } catch (error) {
        res.json(resources_controller.leerRecurso(1010, error.message));
    }
}