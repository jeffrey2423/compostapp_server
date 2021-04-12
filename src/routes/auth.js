const { Router } = require('express');
const router = Router();

const authController = require('../controllers/auth_controller');


router.route('/signin')
    .post(authController.SignIn)

router.route('/signup')
    .post(authController.SignUp)

module.exports = router;