import net from 'node:net';

function frame(text) {
  const body = Buffer.from(text, 'utf8');

  const header = Buffer.alloc(4);
  header.writeUInt32BE(body.length);

  return Buffer.concat([header, body]);
}

const socket = net.createConnection({
  host: '127.0.0.1',
  port: 3102
});

let pending = Buffer.alloc(0);
let received = 0;

socket.on('connect', () => {
  const first = frame('Привет\nNetLab');
  const second = frame('PING');

  // Отправляем сначала только два байта заголовка
  socket.write(first.subarray(0, 2));

  // Затем остальные байты и второе сообщение
  setTimeout(() => {
    socket.write(
      Buffer.concat([
        first.subarray(2),
        second
      ])
    );
  }, 80);
});

socket.on('data', (chunk) => {
  pending = Buffer.concat([pending, chunk]);

  while (pending.length >= 4) {
    const size = pending.readUInt32BE(0);

    if (size > 1024) {
      return socket.destroy(
        new Error('Ответ слишком большой')
      );
    }

    if (pending.length < 4 + size) {
      break;
    }

    const message = pending
      .subarray(4, 4 + size)
      .toString('utf8');

    console.log('Ответ:', JSON.stringify(message));

    pending = pending.subarray(4 + size);
    received++;
  }

  if (received === 2) {
    socket.end();
  }
});

socket.on('error', (error) => {
  console.error('Клиент:', error.message);
});
