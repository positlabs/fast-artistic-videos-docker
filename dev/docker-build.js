#!/usr/bin/env node

const {spawn} = require('child_process')
const env = require('./env.js')

// default to production
env.NODE_ENV = env.NODE_ENV || 'production'

console.log('=============================')
console.log('building with env')
console.log(env)
console.log('=============================')

// assemble build args to be consumed by the dockerfile
const buildArgs = [
    '--build-arg', `BUILT_AT=${new Date()}`,
]
Object.keys(env).map(key => {
    buildArgs.push('--build-arg')
    buildArgs.push(`${key}=${env[key]}`)
})

const proc = spawn('docker', [
    'build',
    '-t', env.DOCKER_TAG,
    ...buildArgs,
    './'
])
proc.stderr.pipe(process.stderr)
proc.stdout.pipe(process.stdout)
