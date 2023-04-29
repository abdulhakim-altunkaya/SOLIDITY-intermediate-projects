const express = require("express");
const path = require("path");

const app = express();

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "./", "dapp.html"));
});
app.get("/home", (req, res) => {
    res.sendFile(path.join(__dirname, "/dapp2.html"));
});
app.get("/test", (req, res) => {
    res.sendFile(path.join(__dirname, "/dapp3.html"));
});


const server = app.listen(5000);
const portNumber = server.address().port;
console.log(`port is open on ${portNumber}`);
