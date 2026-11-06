// Проблема передачи
import net from 'node:net'

const HOST = '127.0.0.1' // Хост
const PORT = 3000 // Порт для прослушивания

const server = net.createServer((socket)=>{
    // Получение данных
    socket.on('data', (chunk) =>{
        console.log('Фрагмент data:',
            chunk
        )
    })
    
})

server.listen(PORT, HOST, ()=>{
    console.log("Сервер запущен")
})