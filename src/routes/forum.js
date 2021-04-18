const { Router } = require('express');
const router = Router();

const forumController = require('../controllers/forum_controller');


router.route('/createquestion')
    .post(forumController.CreateQuestion)

router.route('/questions')
    .get(forumController.GetQuestions)

router.route('/answerquestion')
    .post(forumController.CreateAnswer)

router.route('/likeordislike')
    .post(forumController.LikeOrDislike)

module.exports = router;