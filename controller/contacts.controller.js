const mongoose = require("mongoose")
const { contactValidator, Contact } = require("../models/contacts.model")
const { response } = require("../utils/response.format")

exports.createContact = async (req, res) => {
    try {
        const { value, error } = contactValidator.validate(req.body)
        if (error) throw new Error(error.message)
        const userId = req.user.id;
        const userContacts = await  Contact.find({ owner : userId}) ;
        if(userContacts.length >= 3) throw new Error('Exceeded max contacts number')
        const contact = new Contact({
            name: value.name,
            phoneNumber: value.phoneNumber,
            owner: userId,
        })
        await contact.save();
        return res.json(response(200, 'Contact added', true,  contact ))
    } catch (error) {
        return res.json(response(500, error.message, false))
    }

}

exports.deleteContact = async (req, res) => {
    try {
        const { id } = req.params;
        if (!id) throw new Error('Missing params');
        const contact = await Contact.findById(id);
        if (!contact) throw new Error('No such contact found')
        await contact.deleteOne();
        return res.json(response(200, 'Contact deleted', true, contact))

    } catch (error) {
        return res.json (response(500, error.message , false))
    }
}

exports.getUserContacts = async (req, res) => {
    try {
        const contacts = await Contact.find({ owner: req.user.id });
        return res.json(response(200, 'User contacts retrieved', true, { contacts }))
    } catch (error) {
        return res.json(response(500, error.message , false))
    }
}