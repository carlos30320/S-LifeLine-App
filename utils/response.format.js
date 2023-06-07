exports.response = (status, message, success, data) => {
    return {
        status,
        message,
        success,
        data
    }
}