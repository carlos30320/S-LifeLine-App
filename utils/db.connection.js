const mongoose = require('mongoose')
const { env } = require('process')

module.exports.connectToDB = () => {
    mongoose.connect(env.DATABASE_URL, {
    }).then(() => {
        console.log('🖇️  Connected to database!')
    }).catch((err) => {
        console.log('[Error] connecting to database: ', err)
    })
}