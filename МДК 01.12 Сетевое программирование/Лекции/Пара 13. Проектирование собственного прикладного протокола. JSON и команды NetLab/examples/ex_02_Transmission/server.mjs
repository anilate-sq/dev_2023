import net from 'node:net';

const HOST = '127.0.0.1';
const PORT = 3050;
const MAX_BYTES = 2048;

// Отправка сообщения
function send(socket, message) {
  if (!socket.destroyed && !socket.writableEnded) {
    socket.write(JSON.stringify(message) + '\n');
  }
}

// Возврат результата при успешной отправке
function success(id, result) {
  return { version: 1, id, ok: true, result };
}

// Возврат результата при неудачной отправке
function failure(id, code, message) {
  return {
    version: 1,
    id,
    ok: false,
    error: { code, message }
  };
}

// Проверка валидности
function handle(socket, raw) {
  let request;

  try {
    request = JSON.parse(raw);
  } catch {
    send(socket, failure(null,
      'INVALID_JSON', 'Неверный JSON'));
    return;
  }

  if (!request || typeof request !== 'object' ||
      Array.isArray(request)) {
    send(socket, failure(null,
      'INVALID_REQUEST', 'Ожидается объект'));
    return;
  }

  const id = request.id;

  if (typeof id !== 'string' ||
      !/^[A-Za-z0-9_-]{1,32}$/.test(id)) {
    send(socket, failure(null,
      'INVALID_REQUEST', 'Некорректный id'));
    return;
  }

  if (request.version !== 1) {
    send(socket, failure(id,
      'UNSUPPORTED_VERSION', 'Ожидалась версия 1'));
    return;
  }

  if (typeof request.command !== 'string') {
    send(socket, failure(id,
      'INVALID_REQUEST', 'Отсутствует command'));
    return;
  }

  switch (request.command) {
    case 'PING':
      send(socket, success(id, { message: 'PONG' }));
      break;

    case 'TIME':
      send(socket, success(id, {
        time: new Date().toISOString()
      }));
      break;

    case 'STATUS':
      send(socket, success(id, {
        service: 'NetLab',
        status: 'online'
      }));
      break;

    case 'ECHO': {
      const text = request.payload?.text;

      if (typeof text !== 'string' ||
          text.trim().length === 0 ||
          text.length > 120) {
        send(socket, failure(id,
          'INVALID_PAYLOAD',
          'text должен содержать 1–120 символов'));
        return;
      }

      send(socket, success(id, { text }));
      break;
    }

    default:
      send(socket, failure(id,
        'UNKNOWN_COMMAND', 'Команда не поддерживается'));
  }
}

const server = net.createServer((socket) => {
  socket.setEncoding('utf8');
  let pending = '';

  console.log('Клиент подключился');

  socket.on('data', (chunk) => {
    pending += chunk;

    let pos;

    while ((pos = pending.indexOf('\n')) !== -1) {
      const line = pending.slice(0, pos);
      pending = pending.slice(pos + 1);

      if (Buffer.byteLength(line, 'utf8') > MAX_BYTES) {
        send(socket, failure(null,
          'MESSAGE_TOO_LARGE', 'Превышен лимит'));
        socket.end();
        return;
      }

      if (line.trim()) handle(socket, line);
    }

    if (Buffer.byteLength(pending, 'utf8') > MAX_BYTES) {
      send(socket, failure(null,
        'MESSAGE_TOO_LARGE', 'Превышен лимит'));
      socket.end();
    }
  });

  socket.on('error', (error) => {
    console.error('Ошибка клиента:', error.message);
  });

  socket.on('close', () => {
    console.log('Клиент отключился');
  });
});

server.on('error', (error) => {
  console.error('Ошибка сервера:', error.message);
});

server.listen(PORT, HOST, () => {
  console.log('NetLab Protocol: ' + HOST + ':' + PORT);
});