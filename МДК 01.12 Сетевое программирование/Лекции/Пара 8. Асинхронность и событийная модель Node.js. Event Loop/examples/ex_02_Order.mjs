// Пример 1. Promise
console.log('1. Синхронный код');

setTimeout(() => {
  console.log('4. Таймер');
}, 0);

// Ждем действия в программе, чтобы выполнился Promise
Promise.resolve().then(() => {
  console.log('3. Promise');
});

console.log('2. Синхронный код');

// Пример 2. async function(асихнронная функция)
function wait(ms){
    return new Promise((resolve)=>{
        setTimeout(resolve, ms)
    })
}

async function demo(){
    console.log('До ожидания')
    await wait(500)
    console.log('После ожидания')
}

demo()
console.log('Работа продолжается')