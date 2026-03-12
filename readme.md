# Вводные задачи по Julia

Пытаемся выполнить максимальное количество задач. Оцениваются полнота и качество выполнения.

## Уровень 0: Установка инструментов: vscode, Julia, git и github
Пушим тестовый коммит в этот репозиторий. 
- Сборник инструкций и материалов по Julia: https://docs.google.com/document/d/115vBKdhpop9s6SnmMY19l4edZeFX9g6vFNxvhswAiSI/edit

## Уровень 1: Знакомимся с Julia
Заполнить файл `level1_video.jl` - переписать примеры первого часа из видеолекции https://youtu.be/4igzy3bGVkQ. По желанию можно поменять значения и попробовать другие функции.
- Примеры для справки - см. в файле `examples.jl` .

## Уровень 2. Экзамен по мануалу Julia
Выполнить больше половины заданий в комментариях `level2_manual.jl`
- Пробегаемся по разделам официальной документации: https://docs.julialang.org/en/v1/manual/getting-started/ 

## Уровень 3: Игра "Жизнь"
Файл `level3_life.jl` - выполнить код и сгенерировать gif-файл анимации.
 - Описание алгоритма: https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

## Уровень 4: Алгоритм "Boids"
Файл `level4_boids.jl` - выполнить код и сгенерировать gif-файл анимации.
 - Условия задачи: http://www.red3d.com/cwr/boids/ 
 - Описание предметной области:
   - игровое поле
   - объекты ("птички")
   - вектор координат (каждого объекта)
   - вектор скорости (каждого объекта)
   - вектор ускорения (каждого объекта)
   - область видимости (каждого объекта)
   - время = количество итераций / частота смены кадров
 - Пример выполнения: https://eater.net/boids

## Бонусный уровень "Godlike"
Разные варианты точек в Boids, вместо `Tuple{Float64, Float64}`:
- Своя структура: `struct Point2D`
- Своя параметрическая структура: `struct Point{D,T}`
- FieldVector из [StaticArrays](https://juliaarrays.github.io/StaticArrays.jl/stable/api/#FieldVector)
- Vec2 из [GeometryBasics](https://juliageometry.github.io/GeometryBasics.jl/dev/static_array_types/)

