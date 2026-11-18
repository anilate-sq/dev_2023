import net from 'node:net';

const socket = net.createConnection({
  host: '127.0.0.1',
  port: 3050
});

const requests = [
  { version: 1, id: 'req-1', command: 'PING' },
  { version: 1, id: 'req-2', command: 'TIME' },
  {
    version: 1,
    id: 'req-3',
    command: 'ECHO',
    payload: { text: 'Привет,\nNetLab!' }
  },
  { version: 1, id: 'req-4', command: 'STATUS' },
  { version: 1, id: 'req-5', command: 'UNKNOWN' }
];

socket.setEncoding('utf8');

let pending = '';
const answered = new Set();

socket.on('connect', () => {
  console.log('Соединение установлено');

  for (const request of requests) {
    socket.write(JSON.stringify(request) + '\n');
  }
});

socket.on('data', (chunk) => {
  pending += chunk;

  let pos;
  while ((pos = pending.indexOf('\n')) !== -1) {
    const line = pending.slice(0, pos);
    pending = pending.slice(pos + 1);

    if (!line.trim()) continue;

    try {
      const response = JSON.parse(line);

      console.log('Ответ на', response.id);
      console.log(JSON.stringify(response, null, 2));

      if (typeof response.id === 'string') {
        answered.add(response.id);
      }
    } catch {
      console.error('Сервер прислал некорректный JSON');
      socket.destroy();
      return;
    }
  }

  if (answered.size === requests.length) {
    socket.end();
  }
});

socket.setTimeout(5000, () => {
  console.error('Не все ответы получены за 5 секунд');
  socket.destroy();
});

socket.on('error', (error) => {
  console.error('Ошибка:', error.message);
});

socket.on('close', () => {
  console.log('Соединение закрыто');
});