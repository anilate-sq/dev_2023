const socket = new WebSocket('ws://127.0.0.1:3060/ws');

socket.addEventListener('open', () => {
  console.log('Соединение установлено');
  socket.send('Привет, сервер!');
});

socket.addEventListener('message', (event) => {
  console.log('Сообщение:', event.data);
});

socket.addEventListener('error', () => {
  console.error('Ошибка WebSocket');
});

socket.addEventListener('close', (event) => {
  console.log('Закрытие:', event.code, event.reason);
});