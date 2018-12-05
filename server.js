const express = require('express')
const app = express()
const port = 8338

app.use(express.json({}))
app.use(express.static('content'))

app.get('/', (req, res) => res.send('Style transfer service ' + process.env.BUILT_AT))

app.listen(port, () => console.log(`http://localhost:${port}`))
