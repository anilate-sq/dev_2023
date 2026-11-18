const ws = new WebSocket('ws://127.0.0.1:3061');

ws.addEventListener('open', () => {
  console.log('OPEN');
  ws.send('PING');
  ws.send('Сокет работает')
});

ws.addEventListener('message', (event) => {
  console.log('FROM SERVER:', event.data);
});

ws.addEventListener('close', (event) => {
  console.log('CLOSED:', event.code);
});

ws.addEventListener('error', () => {
  console.log('ERROR');
});