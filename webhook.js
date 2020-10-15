let http = require("http")
let crypto = require("crypto")
const SECRET = "chenSir123"

// 计算数字签名
function sig(body){
    return `sha1=` + crypto.createHmac("sha1", SECRET).update(body).digest('hex');
}

let server = http.createServer(function(req, res){
    if(req.method == "POST" && req.url == "/webhook"){
        let buffers = [];
        req.on("data", function(buffer){
            buffers.push(buffer)
        })
        req.on('end', function(buffer){
            let body = Buffer.concat(buffers)
            // 解析webhook的请求
            let event = req.headers['X-github-event'];
            // github请求到来的时候，要传递一个body，还会带一个signature过来，需要验证签名是否正确
            let signature = req.headers['x-hub-signature'];
            if(signature !== sig(body)){
                return res.end('Not Allowed');
            }
        })
        res.setHeader('Content-Type', 'application/json');
        res.end(JSON.stringify({ok: true}))
    }else{
        res.end("Not Found")
    }
})

server.listen(4000, () => {
    console.log("webhook 启动在4000端口")
})