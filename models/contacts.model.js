const { Schema, model, default: mongoose } = require("mongoose");
const Joi = require('joi')

const contactSchema = new Schema({
    name: {
        type: String,
        required: true
    },
    phoneNumber: {
        type: String,
        required: true
    },
    owner: {
        type: mongoose.Types.ObjectId,
        requeired: true,
        ref : 'user'
    }
})

const Contact = model('contact', contactSchema)

const contactValidator = Joi.object({
    name: Joi.string().required().min(2),
    phoneNumber: Joi.string().required(),
})


module.exports = {
    Contact,
    contactValidator
}