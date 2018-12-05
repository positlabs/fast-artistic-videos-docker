
const {exec, execSync} = require('child_process')
function run(cmd){
    return new Promise((resolve, reject) => {
        exec(cmd, (err, stdout, stderr) => {
            if(err) return reject(err)
            resolve(stdout.replace(/\n/g, ''))
        })
    })
}
function runSync(cmd){
    return execSync(cmd, {encoding: 'utf8'}).replace(/\n/g, '')
}
module.exports = {
    run, runSync
}