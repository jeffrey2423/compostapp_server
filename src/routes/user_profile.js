const { Router } = require('express');
const router = Router();

const userProfileController = require('../controllers/user_profile_controller');


router.route('/updatepassword/:id')
    .post(userProfileController.UpdatePassword)

router.route('/updateprofile/:id')
    .post(userProfileController.UpdateProfile)

module.exports = router;