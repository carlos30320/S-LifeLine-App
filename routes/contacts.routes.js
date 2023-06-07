const { createContact, deleteContact, getUserContacts } = require('../controller/contacts.controller')
const { authMiddleWare } = require('../middlewares/auth.middleware')

const router = require('express').Router()
router.all('*', authMiddleWare)
router.post('/new', createContact)
router.delete('/:id', deleteContact)
router.get('', getUserContacts)

module.exports = router;