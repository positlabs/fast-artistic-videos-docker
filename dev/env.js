#!/usr/bin/env node

/*
    Uses dotenv and applies some defaults at runtime
*/ 

const path = require('path')
const {runSync} = require('./cmd')

// define defaults
const REPO = runSync('basename $(git remote get-url origin) .git')
const BRANCH = runSync('git rev-parse --abbrev-ref HEAD')
const GOOGLE_CLOUD_PROJECT = runSync('gcloud config get-value project')
const DOCKER_TAG = `gcr.io/${GOOGLE_CLOUD_PROJECT}/${REPO}`

// grab project specific env file
const file_path = path.resolve(__dirname, '../.env')
const dotenv = require('dotenv').config({path: file_path})

const defaults = {
    NODE_ENV: 'production',
    REPO,
    BRANCH,
    DOCKER_TAG,
    GOOGLE_CLOUD_PROJECT,
    BUILT_AT: new Date()
}

// apply defaults to parsed object
const env = Object.assign(defaults, dotenv.parsed)
// apply result to process.env
for (var k in env) { process.env[k] = env[k] }

module.exports = env