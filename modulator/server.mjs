import net from "node:net";
import { Buffer } from "node:buffer";

let server;
let connections = [];

// Server methods
function startServer() {
    server = net.createServer();

    server.on("connection", handleConnection);

    let port = typeof process.env.MOD_RTLTCP_PORT !== "undefined" ? process.env.MOD_RTLTCP_PORT : 1234

    server.listen(port, () => {
        console.log(`RTL_TCP server listening on port ${server.address().port}`);
    });
}

function handleConnection(conn) {  
    let remoteAddress = conn.remoteAddress

    if (remoteAddress.startsWith("::ffff:")) {
        remoteAddress = remoteAddress.substr(7);
    }

    console.log(`RTL_TCP client connected: ${remoteAddress}`);

    conn.once("close", () => {
        console.log(`RTL_TCP client disconnected: ${remoteAddress}`);

        connections.splice(connections.indexOf(conn), 1);
    });

    conn.on("error", (err) => {
        if (err.message != "write EPIPE") {
            console.log(`Connection error: ${err.message}`);
        }
    });

    sendDongleInfo(conn);

    connections.push(conn);
}

function sendDongleInfo(conn) {
    let dongleInfo = Buffer.alloc(12);

    dongleInfo.fill("RTL0", 0, 4);
    dongleInfo[7] = 5;
    dongleInfo[11] = 1;

    conn.write(dongleInfo);
}

function sendData(data) {
    connections.forEach((conn) => {
        conn.write(data);
    });
}

// Data processing methods
function processStandardIn() {
    process.stdin.on("data", sendData);
}

// Main function
function main() {
    startServer();
    processStandardIn();
}

main();
