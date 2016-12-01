const fs = require("fs")
const redis = require("redis")
const async = require("async")
const csv = require("csv")


const client = redis.createClient()
const monsPath = process.argv[2]
const monsStr = fs.readFileSync(monsPath).toString()

client.select(1)

csv.parse(monsStr, (err, mons) => {
    let done = 0
    let erred = 0
    async.each(mons, (mon, cb) => {
        let name = mon[1]
        let types = mon[3].replace("{", "").replace("}", "").split(",")
        let write = {name: name, types: types}
        client.set(`p:${name}`, JSON.stringify(write), err => {
            if (err) erred++ && cb(err)
            else done++ & cb()
        })
    }, err => {
        console.log(`Done with ${erred} errored and ${done} completed`)
        client.quit()
    })
})

