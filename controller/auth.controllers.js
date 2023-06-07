const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const { userValidator, User } = require("../models/user.model")
const { response } = require("../utils/response.format");
const { getJwt } = require('../utils/jwt.generator');

exports.signUp = async (req, res) => {
    console.log(req.body)
    try {
        const { value, error } = userValidator.validate(req.body);
        if (error) throw new Error(error.message);
        const sameUsername = await User.find({  username: value.username });
        if (!sameUsername) throw new Error('Username already taken')
        if (value.password != value.confirmPassword) throw new Error('Passwords do not match');
        const hashed = await bcrypt.hash(value.password, 10);
        const user = new User({
            username: value.username,
            password: hashed,
            email: value.email
        })
        await user.save();
        const token = getJwt(user.username, user._id)
        return res.json(response(200, 'Sign up successful', true, { token, username: user.username }))
    } catch (error) {
        console.log(error)
        return res.json(response(500, error.message, false))
    }
}


exports.signIn = async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email })
        if (!user) throw new Error('Invalid credentials')
        const passMatch = await bcrypt.compare(password, user.password);
        if (passMatch != true) throw new Error('Invalid credentials');
        const token = getJwt(user.username, user._id)
        return res.json(response(200, 'Sign in successful', true, { token, username: user.username }))
    } catch (error) {
        return res.json(response(500, error.message, false))
    }
}