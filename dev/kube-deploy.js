#!/usr/bin/env node
/*

    Deploy the container via kubectl
    Updates the date field just to trigger an image pull

*/

const cmd = require('./cmd')
const yaml = require('js-yaml')
const path = require('path')
const fs = require('fs')
const deploymentFilePath = path.resolve(process.cwd(), process.argv[2])
const env = require('./env.js')

const deployment = yaml.safeLoad(fs.readFileSync(deploymentFilePath, 'utf8'))
deployment.spec.template.spec.containers[0].env.filter(e => e.name === 'DATE')[0].value = new Date()
deployment.spec.template.spec.containers[0].image = env.DOCKER_TAG
fs.writeFileSync(deploymentFilePath, yaml.safeDump(deployment))

cmd.runSync(`kubectl apply -f ${deploymentFilePath}`)
