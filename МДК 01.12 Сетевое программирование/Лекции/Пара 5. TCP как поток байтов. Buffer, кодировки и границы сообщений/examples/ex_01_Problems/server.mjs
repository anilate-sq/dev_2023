// Проблема передачи
import net from 'node:net'

const HOST = '127.0.0.1' // Хост
const PORT = 3000 // Порт для прослушивания

const server = net.createServer((socket)=>{
    socket.setEncoding('utf-8')

    let pending = ''

    socket.write('Text')
    socket.write('Info')

    // Получение данных
    socket.on('data', (chunk) =>{
        console.log('Фрагмент data:',
            JSON.stringify(chunk)
        )
    })
    
})

server.listen(PORT, HOST, ()=>{
    console.log("Сервер запущен")
})