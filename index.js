const express = require("express")
const redis = require("redis")
const async = require("async")


const Pokedex = require("pokedex-promise-v2")
const cacheClient = redis.createClient()
const dex = new Pokedex()
const app = express()

cacheClient.select(1)

function safeparse(json) {
    try {
        return JSON.parse(json)
    } catch(e) {
        return false
    }
}

function formatMon(mon) {
    return {
        name: mon.name, 
        types: mon.types.map(t => t.type.name)
    }
}

function readMon(name) {
    return new Promise((resolve, reject) => {
        cacheClient.get(`p:${name}`, (err, val) => {
            if (!val) {
                dex.getPokemonByName(name)
                .then(mon => {
                    let fmon = formatMon(mon)
                    cacheMon(fmon)
                    return resolve(fmon)
                })
                .catch(reject)
            } else if (err) return reject(err)
            else return resolve(safeparse(val))
        })
    })
}

function readTeam() {
    return new Promise((resolve, reject) => {
        let ret = []
        cacheClient.smembers(`s:team`, (err, members) => {
            if (err) return reject(err)
            async.each(members, (m, cb) => {
                readMon(m)
                .then(mon => ret.push(mon) && cb())
                .catch(cb)
            }, err => {
                if (err) return reject(err)
                return resolve(ret)
            })
        })
    })
}

function addToTeam(name) {
    cacheClient.sadd(`s:team`, name, err => console.log(err))
}


function cacheMon(mon) {
    cacheClient.set(`p:${mon.name}`, JSON.stringify(mon), err => console.log(err))
}

app.use("*", (req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept")
    next()
})

app.use("/mons/:name", (req, res, next) => {
    readMon(req.params.name).then(mon => res.send(mon)).catch(next)
})

app.get("/team", (req, res, next) => {
    readTeam().then(team => res.send(team)).catch(next)
})

app.post("/team/:name", (req, res, next) => {
    addToTeam(req.params.name)
    res.send()
})

app.use((err, req, res, next) => {
    if (err.statusCode) return res.status(err.statusCode).send()
    else {
        console.error(err)
        res.status(500).send()
    }
})


app.listen(4220)
