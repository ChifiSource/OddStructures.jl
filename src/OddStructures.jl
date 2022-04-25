"""
Created in April, 2022 by
[chifi - an open source software dynasty.](https://github.com/orgs/ChifiSource)
by team
[odd-data](https://github.com/orgs/ChifiSource/teams/odd-data)
This software is MIT-licensed.
### OddStructures
##### Module Composition
- [**OddStructures**]() - High-level API!
- [Algebraic]() - Algebraic array implementation.
- [WebRNA]() - Some basic expressions for working with web types from base types.
"""
module OddStructures
using EvalNotParse
export Date, DateTime, parse
include("AlgebraicArrays.jl")
include("WebRNA.jl")
using Main.AlgebraicArray
using Main.WebRNA
"""
- OddStructures
### ikeys(pairs::Vector{Pair}) -> Array{Any}
Parses keys of pairs into a 1-dimensional array.
##### example
```
pairs = [:A => [5, 10], :B => [5, 10]]
ikeys(pairs)
[:A, :B]
```
"""
ikeys(pairs::Any) = [p[1] for p in pairs]
"""
- OddStructures
- Base Tools
### ivalues(pairs::Vector{Pair}) -> Array{Array}
Parses values of pairs into a 1-dimensional array.
##### example
```
pairs = [:A => [5, 10], :B => [5, 10]]
ivalues(pairs)
[[5, 10], [5, 10]]
```
"""
ivalues(pairs::Any) = [p[2] for p in pairs]
"""
- OddStructures
### getindex(x::AbstractArray, mask::BitArray) -> Array{Any}
Removes any indexes equal to zero on the mask on **x**
##### example
```
array = [5, 10, 15]
array = array[array .== 5]
array

[5]
```
"""
function getindex(x::AbstractArray, mask::BitArray)
        pos = findall(x->x==0, mask)
        [deleteat!(x, p) for p in pos]
end

"""
- OddStructures
### getindex(x::AbstractArray, mask::Function) -> Array{Any}
Removes any indexes equal to zero on the mask function's return onto **x**.
##### example
```
array = [5, 10, 15]
array = array[x -> x == 5]
array

[5]
```
"""
function getindex(x::AbstractArray, mask::Function)
    mask2 = [mask(x) for x in x]
    getindex(x, mask2)
end

"""
- OddStructures
### apply(array::AbstractArray, f::Function) -> ::Array
Applies a function to an iterable array.
##### example
```
array = [5, 10, 15]
map!(array, x -> x += 5)
array
[10, 15, 20]
```
"""
apply(array::AbstractArray, f::Function) = [f(x) for x in array]

"""
- OddStructures
### apply!(array::AbstractArray, f::Function) -> _
Applies a function to an iterable array.
##### example
```
array = [5, 10, 15]
map!(array, x -> x += 5)
array
[10, 15, 20]
```
"""
apply!(array::AbstractArray, f::Function) = [insert!(array, i, f(val)) for (i, val) in enumerate(array)]
export apply!, apply, ivalues, ikeys
export compute, algebraic!, AlgebraicArray, linear_UUID
export %, px_str, hex_str
end # module
