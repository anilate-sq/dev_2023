# МДК 01.11 — Технология доступа к базам данных ADO.NET

[← Все дисциплины](../README.md) · [Страница курса в Notion](https://app.notion.com/p/3eae6b7dda8f80a6aeccc9bf92d1f0b6)

В этом разделе находятся **ссылки на лекции и примеры C#-кода**. Лекционный материал и практические задания публикуются в Notion; файлы `examples/` дополняют отдельные занятия.

## Лекции и примеры

| № лекции | Тема | Конспект | Примеры в GitHub |
| --- | --- | --- | --- |
| 1 | Введение в ADO.NET и архитектура доступа к данным | [Notion](https://app.notion.com/p/3eae6b7dda8f80dfb7d2e1336e6f339b) | [Папка занятия](Лекции/%D0%9F%D0%B0%D1%80%D0%B0%201.%20%D0%92%D0%B2%D0%B5%D0%B4%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%B2%20ADO.NET%20%D0%B8%20%D0%B0%D1%80%D1%85%D0%B8%D1%82%D0%B5%D0%BA%D1%82%D1%83%D1%80%D0%B0%20%D0%B4%D0%BE%D1%81%D1%82%D1%83%D0%BF%D0%B0%20%D0%BA%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D0%BC/README.md) |
| 2 | Выполнение SQL-запросов через SqlCommand | [Notion](https://app.notion.com/p/3f1e6b7dda8f80089166f257cecb684d) | [Папка занятия](Лекции/%D0%9F%D0%B0%D1%80%D0%B0%203.%20%D0%92%D1%8B%D0%BF%D0%BE%D0%BB%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5%20SQL-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D0%BE%D0%B2%20%D1%81%20%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E%20SqlCommand/README.md) |
| 3 | Параметризованные запросы и SqlParameter | [Notion](https://app.notion.com/p/3f1e6b7dda8f808988c9c866f8cb1bf3) | [Папка занятия](Лекции/%D0%9F%D0%B0%D1%80%D0%B0%205.%20%D0%9F%D0%B0%D1%80%D0%B0%D0%BC%D0%B5%D1%82%D1%80%D0%B8%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%BD%D1%8B%D0%B5%20SQL-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D1%8B%20%D0%B8%20SqlParameter/README.md) |
| 4 | Чтение результатов через SqlDataReader | [Notion](https://app.notion.com/p/0ebe6b7dda8f829a8875017b93619bc2) | [Папка занятия](Лекции/%D0%9F%D0%B0%D1%80%D0%B0%207.%20%D0%A7%D1%82%D0%B5%D0%BD%D0%B8%D0%B5%20%D1%80%D0%B5%D0%B7%D1%83%D0%BB%D1%8C%D1%82%D0%B0%D1%82%D0%BE%D0%B2%20SQL-%D0%B7%D0%B0%D0%BF%D1%80%D0%BE%D1%81%D0%BE%D0%B2%20%D1%81%20%D0%BF%D0%BE%D0%BC%D0%BE%D1%89%D1%8C%D1%8E%20SqlDataReader/README.md) |
| 5 | Транзакции: SqlTransaction, Commit и Rollback | [Notion](https://app.notion.com/p/3f8e6b7dda8f8186b06cd373cd09c468) | [Папка занятия](Лекции/%D0%9F%D0%B0%D1%80%D0%B0%209.%20%D0%A2%D1%80%D0%B0%D0%BD%D0%B7%D0%B0%D0%BA%D1%86%D0%B8%D0%B8%20%D0%B2%20ADO.NET%20-%20SqlTransaction%2C%20Commit%20%D0%B8%20Rollback/README.md) |
| 6 | Асинхронная работа с базой данных | [Notion](https://app.notion.com/p/3f8e6b7dda8f8136bf09cb35fc510c11) | [Папка занятия](Лекции/%D0%9F%D0%B0%D1%80%D0%B0%2011.%20%D0%90%D1%81%D0%B8%D0%BD%D1%85%D1%80%D0%BE%D0%BD%D0%BD%D0%B0%D1%8F%20%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D0%B0%20%D1%81%20%D0%B1%D0%B0%D0%B7%D0%BE%D0%B9%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B2%20ADO.NET/README.md) |
| 7 | Провайдеры данных и конфигурация подключения | [Notion](https://app.notion.com/p/3fae6b7dda8f81328d88d52d8b681a93) | Пока нет отдельной папки |

Названия папок «Пара 1», «Пара 3» и так далее отражают **номера учебных пар в существующей структуре**, а не номера лекций в Notion; поэтому они не совпадают.

## Материалы для практики

- [База данных кофейни — `coffee_shop.sql`](Дополнительные%20материалы/coffee_shop.sql).
- [Скачать .NET SDK](https://dotnet.microsoft.com/download).
- [Документация ADO.NET](https://learn.microsoft.com/dotnet/framework/data/adonet/).

Перед выполнением работы откройте практическое задание в Notion. При наличии демонстрационного кода его можно найти в папке соответствующего занятия. Условия работ и исходники не изменены.

> **Для студентов:** это репозиторий преподавателя. Выполненные задания храните в личном GitHub-репозитории и сдавайте в установленном порядке.
