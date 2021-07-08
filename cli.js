#!/usr/bin/env node
'use strict'

// See https://sao.vercel.app/api.html on basis for this file

// Deps
const path = require('path')
const sao = require('sao')

// Where the saofile lives
const generator = __dirname

// Where to install
const outDir = path.resolve(process.argv[2] || '.')

// Run Sao standalone
sao({ generator, outDir })
	.run()
	.catch(err => {
		console.trace(err)
		process.exit(1)
	})
