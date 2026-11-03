import net from 'node:net';

const MAX_BYTES = 1024;

function frame(text) {
  const body = Buffer.from(text, 'utf8');

  const header = Buffer.alloc(4);
  header.writeUInt32BE(body.length);

  return Buffer.concat([header, body]);
}

const server = net.createServer((socket) => {
  let pending = Buffer.alloc(0);

  socket.on('data', (chunk) => {
    pending = Buffer.concat([pending, chunk]);

    while (pending.length >= 4) {
      const size = pending.readUInt32BE(0);

      if (size > MAX_BYTES) {
        socket.destroy(
          new Error('Слишком большое сообщение')
        );
        return;
      }

      if (pending.length < 4 + size) {
        break;
      }

      const message = pending
        .subarray(4, 4 + size)
        .toString('utf8');

      pending = pending.subarray(4 + size);

      console.log(
        'Получено:',
        JSON.stringify(message)
      );

      socket.write(frame('ACK: ' + message));
    }
  });

  socket.on('error', (error) => {
    console.error('Сокет:', error.message);
  });
});

server.on('error', (error) => {
  console.error('Сервер:', error.message);
});

server.listen(3102, '127.0.0.1', () => {
  console.log('Бинарный TCP-сервер слушает порт 3102');
});
