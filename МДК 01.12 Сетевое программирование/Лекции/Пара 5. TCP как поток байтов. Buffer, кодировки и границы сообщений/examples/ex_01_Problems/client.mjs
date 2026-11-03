import net from 'node:net'

const socket = net.createConnection({
    host: '127.0.0.1',
    port: 3000
})

socket.setEncoding('utf-8')
let pending = ''
let received = 0


socket.write("Hello")
socket.write("World")

socket.on('data', (chunk)=>{
    console.log('Фрагмент data:',
        console.log(chunk.toString())
    )

})

socket.on('error', (error)=>{
    console.error('Клиент: ', error.message)
})