const { Schema, model } = require("mongoose");
const Joi = require('joi');
const { Contact } = require("./contacts.model");

const userSchema = new Schema({
    username: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    }
})

const User = model('user', userSchema)


const userValidator = Joi.object({
    username: Joi.string().required().min(2),
    password: Joi.string().required(),
    confirmPassword: Joi.string().required(),
    email: Joi.string().required(),
})


module.exports = {
    User,
    userValidator
}