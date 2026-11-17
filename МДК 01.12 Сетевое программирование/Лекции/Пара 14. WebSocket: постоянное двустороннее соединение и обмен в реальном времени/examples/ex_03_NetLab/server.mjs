import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({
  host: '127.0.0.1',
  port: 3061,
  maxPayload: 2048
});

wss.on('connection', (socket) => {
  console.log('Новый WebSocket-клиент');

  socket.on('message', (data, isBinary) => {
    if (isBinary) {
      socket.send('ERROR: только текст');
      return;
    }

    const message = data.toString('utf8');
    console.log('Получено:', message);
    socket.send('ECHO: ' + message);
  });

  socket.on('close', () => {
    console.log('Клиент отключился');
  });

  socket.on('error', (error) => {
    console.error('Ошибка соединения:', error.message);
  });
});

wss.on('error', (error) => {
  console.error('Ошибка сервера:', error.message);
});

console.log('WebSocket: ws://127.0.0.1:3061');