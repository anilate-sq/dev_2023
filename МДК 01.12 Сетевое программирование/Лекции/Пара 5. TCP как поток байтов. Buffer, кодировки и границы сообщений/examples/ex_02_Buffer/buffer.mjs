
import { StringDecoder } from 'node:string_decoder';

const text = 'Я';
const bytes = Buffer.from(text, 'utf8');

console.log('Текст:', text);
console.log('Длина JS-строки:', text.length);
console.log('Число байтов:', bytes.length);
console.log('Байты (hex):', bytes.toString('hex'));

// Разделим байты одного символа на две части
const first = bytes.subarray(0, 1);
const second = bytes.subarray(1);

console.log(
  'Неверное декодирование части:',
  first.toString('utf8')
);

// Правильно декодируем поток байтов
const decoder = new StringDecoder('utf8');

console.log(
  'Первый кусок:',
  JSON.stringify(decoder.write(first))
);

console.log(
  'Второй кусок:',
  JSON.stringify(decoder.write(second))
);
