const jwt   = require('jsonwebtoken')

exports.getJwt = (username , id ) => {
    const token  = jwt.sign({
        username ,
        id
    }, process.env.ACCESS_TOKEN_SECRET)

    return token ;
}