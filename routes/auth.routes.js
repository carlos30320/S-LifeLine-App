const { signUp, signIn } = require('../controller/auth.controllers');

const router = require('express').Router()


router.post('/signup', signUp)
router.post('/signin', signIn)

module.exports = router;