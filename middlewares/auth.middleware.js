const jwt = require('jsonwebtoken')
const { response } = require("../utils/response.format");

exports.authMiddleWare = async (req, res, next) => {
    try {
        const token = req.headers['authorization'];
        if (!token) {
            return res.json(response(401, 'Unauthorized', false))
        }
        const tkn = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET)
        req.user = tkn
        next();

    } catch (error) {
        return res.json(response(500, error.message , false))
    }
}