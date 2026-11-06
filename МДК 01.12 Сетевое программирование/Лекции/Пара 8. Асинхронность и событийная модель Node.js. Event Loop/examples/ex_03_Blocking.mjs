const start = Date.now() // храним текущее время
setTimeout(()=>{
    console.log('Таймер запустился через: ',
    Date.now() - start, 'мс')
}, 100)

while(Date.now() - start < 2000){
    // имитация вычислений
}

console.log('Работа завершена')