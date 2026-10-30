import net from 'node:net'

const HOST = '127.0.0.1' // Хост
const PORT = 3001 // Порт для прослушивания

const server = net.createServer((socket)=>{
    console.log("Клиент: " + socket.remoteAddress + ":" + socket.remotePort) // Выводим данные подключения
    socket.setEncoding('utf-8')
    // Подключение(событие connect)
    socket.on('connect', ()=>{
        console.log("Соединение установлено")
    })

    // Получение данных подключения
    socket.on('data', (chunk)=>{
        console.log("Полученные данные: " + chunk.toString())
    })

    // Выход
    socket.on('end', ()=>{
        console.log('Завершение отправки данных')
    })

    socket.on('close', ()=>{
        console.log("Ресурс закрыт")
    })

    // destroy - принудительное
    // socket.on('destroy',()=>{
    //     console.log("Сервер завершил работу принудительно")
    // })

    socket.setTimeout(5000); // Асинхронно расчитываем 5 секунд
    socket.on('timeout', ()=>{
        console.log('Пять секунд бездействия')
        socket.end('Бездействие')
    })

    // Вывод информации о том, что сломалось
    socket.on('error', (error)=>{
        console.log("Ошибка: " + error.message)
    })
})

server.listen(PORT, HOST, ()=>{
    console.log("Сервер запущен")
})