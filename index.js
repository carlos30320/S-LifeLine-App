const express = require("express")
const cors = require('cors')
const morgan = require('morgan')
const { config } = require('dotenv');
const { connectToDB } = require("./utils/db.connection");
const authRoutes = require('./routes/auth.routes')
const contactsRoutes = require('./routes/contacts.routes')
config();
const PORT = process.env.PORT;

const app = express();

app.use(express.json())
app.use(cors())
app.use(morgan('dev'))

app.use('/auth', authRoutes);
app.use('/contacts', contactsRoutes)

app.all('*', (req,res) => {
    return res.send('☺️ ASB Server up and running')
})
connectToDB();

app.listen(PORT, () => {
    console.log(`🚀  Server running on port ${PORT}`)
})