// Ассинхронный подход - подход базирующийся на параллельном выполнении различных операций

// Стандартная последовательность выполнения
console.log('Пример 1\n')
console.log('Message 1')
console.log('Message 2')
console.log('Message 3')

// Смена последовательности выполнения
console.log('\nПример 2\n')
console.log('Message 1')
setTimeout(()=>{
    console.log('Message 2')
}, 2000)
console.log('Message 3')
