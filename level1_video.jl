# переписать ниже примеры из первого часа из видеолекции: 
# https://youtu.be/4igzy3bGVkQ
# по желанию можно поменять значения и попробовать другие функции
println("Hellow World")
my_pi = 3.14
typeof(my_pi)
#что-то
csl = 3^6
sl = "World"
sl_1 = """rex", "error"""
name = "slav"
key = 12
key_1 = 134
println("my $name, $key, $(key+key_1)")
string("$name", "$sl" )
string("$name", 12,"$sl" )
sl*sl_1
"$sl$sl_1"
book = Dict("a" => "43-87")
book["a"]
book["my"] = "555-FILK"
book
pop!(book, "a")
book
animals = ("dog", "cat")
animals[1]
animals_1 = ["dog", "cat"]
animals_1
arr = [1 , 4, 45, 34]
arr
mix = ["gik", 34, 3.14]
animals_1[1] = "otter" 
animals_1
push!(arr, 4)
pop!(animals_1)
num = [[1,3,4], [5,6,7], [8,9,10]]
rand(4,3)
n=0
while n < 4
    n+=1
    println(n)
end
n = 0
while n<length(animals_1)
    n+=1
    animal = animals_1[n]
    println(animal)
    
end
for n in 1:10
    println(n)
end
for animal in animals_1
    println("$animal")
end
for n = 1:10
    println(n)
end
m, n  = 5, 5
A = zeros(m,n)
for i in 1:n
    for j in 1:n
        A[j, i] = 1+j
    end

end
B = zeros(m,n)
for i in 1:n, j in 1:n
    B[i,j] = i+j
end
B
C = [i+j for i in 1:n, j in 1:m]
C
for n in 1:10
    A = [i+j for i in 1:n, j in 1:n]
    display(A)
end
x = 8
y = 9
if x>y
    println("%x is larger than $y")
elseif y>x
    println("$y is larger than $x")
else
    println("$x = $y")
end
(x>y) ? x : y
(x>y) && println("$x")
(x<y) && println("$y")
function sayhi(name)
    println("$name")
end
sayhi("bro")
function f(x)
    x^2
end
f(3)
sayhi(name) = println("hi $name")
f2(x)=x^2
sayhi3 = name -> println("hi $name")
f3 = x->x^2
sayhi(394)
A = rand(3,3)
A
f2(A)
v = [2,32,23]
sort(v)
v
sort!(v)
v
A = [i + 4*j for j in 0:2,i in 1:3]
f2(A)
B = f.(A)
using Pkg
Pkg.add("Example")
using Example
hello("h")
Pkg.add("Colors")
using Colors
palette = distinguishable_colors(100)
rand(palette, 3, 3)
Pkg.add("Plots")
Pkg.add("PlotlyJS")
using Plots
using PlotlyJS  
x = -3:0.1:3
f4(x) = x^2
y = f4.(x)
gr()
#plotlyjs()      
plot(x, y, label="line")
scatter!(x, y, label="points")
globaltemp = [14.4, 14.5, 14.8, 15.2, 15.5, 15.8]
num = [45000, 20000, 15000, 5000, 400, 17]
plot(num, globaltemp, legend=false)
scatter!(num, globaltemp, legend=false)
xflip!()
xlabel!("num")
ylabel!("globaltemp")
title!("pop")
p1 = plot(x,x)
p2 = plot(x, x.^2)
plot(p1, p2, layout=(1,2), legend=false)
methods(+)
@which 3+3
import Base:+
+(x::String, y:: String) = string(x,y)
"hello" + "world"
@which "f" + "d"
foo(x,y) = println("duck foo!")
foo(x::Int, y::Float64) = println("foo with int and float")
foo(x::Float64, y::Float64) = println("float!")
foo(1,1)
foo(1., 1.)
foo(1, 0.1)
A = rand(1:4, 3, 3)
C = copy(A)
C[1]
x = ones(3)
b= A*x
Asym = A+A'
Apd = A'A
A\b