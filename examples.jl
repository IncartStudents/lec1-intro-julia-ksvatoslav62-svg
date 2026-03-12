
println("Press Shift+Enter to run this line")

#%% code cell
println("This is a code cell")
println("Press Alt+Enter t run this code cell")
#%%

## встроенные типы данных

# пары

p = (1.0 => "qwerty")
p[1]
p[2]
typeof(p)

## кортежи

tuple = (1, 2.1, "hello", 0xFF)
typeof(tuple)
tuple[3]

# именованные кортежи

ntuple = (num1 = 1, num2 = 2.1, str = "hello", hex = 0xFF)
ntuple.hex
ntuple.str
ntuple.num1 == ntuple[1]

ntuple.str = "bye" # кортежи иммутабельны - их нельзя менять

ntuple2 = (ntuple..., str = "bye") # можно только создать новый

# массивы (списки)

v = [-1, 0, 1]
m = [1 2 3; 4 5 6; 7 8 9]

m * v
2 * v

v * v # такое умножение отсутствует
v .* v # но можно указать поэлементное умножение
v' * v

# способы инициализации массивов:
v = fill(0.0, 100)
v = zeros(100)
v = ones(100)
v = ones(Int, 100)
v = falses(100)
v = trues(100)

v = randn(100)
v = rand(Int, 100)
v = rand(1:5, 100)

# вложенные массивы
vv = [[1,2,3],[4,5,6],[7,8,9,10]]

# гетерогенные массивы
v = [1, 2.0, "hello", 0xFF] # чем отличаются от кортежей - динамический тип

# строки и интерполяция в строку:
a = 123
b = 321
println("a = $a")
println("b = $b")
println("a + b = $a + $b = $(a+b)")

println("a = ", a, "!")

## функции

function foo(a)
    b = a + 1
    return b
end

foo(10)

function bar(a::Number)
    a + 1
end

function bar(a::String)
    "$a + 1"
end

bar(10)
bar("hello")

bar.(v)

bar.(m)

# map
broadcast(m) do element
    bar(element)
end

# конкретные и абстрактные типы, их производительность
function test1(v)
    s = 0
    for vi in v
        s += vi
    end
    return s
end

x1 = randn(10_000)
@time test1(x1);

x2 = Vector{Any}(undef, 10_000)
for i in 1:length(x2)
    x2[i] = x1[i]
end

@time test1(x2);

# структуры

struct Foo
    a::Int
    b::String
end

mutable struct Bar
    a::Int
    b::String
end

# структуры могут быть вложенными:
struct Bazz
    foo::Foo
    bar::Bar
end

# методы структуры

f = Foo(1, "qwerty")
f.a = 2 # структуры по умолчанию иммутабельны

b = Bar(1, "qwerty")
b.a = 2

function Base.show(io::IO, f::Foo)
    print(io, "Foo -> $(f.a), $(f.b)")
end

# массив структур

vec_of_foo = [
    Foo(1, "qwerty"),
    Foo(2, "asdfgh"),
    Foo(3, "zxcvb")
]

# словари (ключ - значение)

d = Dict{String, String}("first" => "qwerty", "second" => "asdfg")

d["first"]
d["second"]
d["third"] = "zxcvb"

# именованный кортеж массивов

ntuple_of_vecs = (
    ind = [100, 200, 300, 400, 500],
    ampl = [1.1, 2.1, 3.1, 4.1, 5.1],
    form = ["N", "N", "V", "X", "N"], # подумать - какие ещё типы можно использовать для одной буквы?
    flag = [true, false, true, false, true],
    mask = [0x1, 0x2, 0x1, 0x3, 0x3],
)

ntuple_of_vecs[1]

# массив именованных кортежей

vec_of_ntuples = [
    (100, 1.1, "N", true, 0x1),
    (200, 2.1, "N", false, 0x2),
    (300, 3.1, "V", true, 0x1),
    (400, 4.1, "X", false, 0x3),
    (500, 5.1, "N", true, 0x3),
]

vec_of_ntuples[1]

# использование пакетов
using Plots
y = [1,2,1,4]
plot(y)
