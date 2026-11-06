import net from 'node:net'

const socket = net.createConnection({
    host: '127.0.0.1',
    port: 3000
})

const canContinue = socket.write('Hello')


if (!canContinue) {
  socket.once('drain', () => {
    console.log('Буфер записи частично освобождён');
  });
}

socket.on('error', (error)=>{
    console.error('Клиент: ', error.message)
})