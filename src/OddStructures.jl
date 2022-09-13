"""
Created in April, 2022 by
[chifi - an open source software dynasty.](https://github.com/orgs/ChifiSource)
by team
[odd-data](https://github.com/orgs/ChifiSource/teams/odd-data)
This software is MIT-licensed.
### OddStructures
OddStructures provides basic densionality and types for odddata modules.
##### example
```julia
densions = 3d * 5

# reshapes vertically
vector3 = fill!(densions) do c::Combination{Int64}
    [c]
end
```
"""
module OddStructures
using ParseNotEval
using CarouselArrays
using Dates
import Base: vect, getindex, setindex!, (:), length, size

"""
### abstract type AbstractDimensions
Dimensions explain the shape that data goes together. Dimensions in this case
can be any number.
##### Consistencies
- n::Combination{Int64}
"""
abstract type AbstractDimensions end

"""
### abstract type AbstractAlgebra <: AbstractDimensions
An abstract definition for Algebraic data.
##### Consistencies
- fill!(f::Function, aa::AbstractAlgebra)
"""
abstract type AbstractAlgebra <: AbstractDimensions end

"""
### abstract type AbstractCombination <: AbstractDimensions
A combination is a horizontal collection of observations. These can be
vectorized with `[]` and `:`.
```julia

```
##### Consistencies
- k::Vector{T}
"""
abstract type AbstractCombination <: AbstractDimensions end

"""
### Combination{T <: Any} <: AbstractCombination
- k::Vector{S}
A horizontal concatenation of `k`'s values.
##### example
```
combo = "hi":"hello"
Combination{String}(["hi", "hello"])
```
------------------
##### constructors
- Combination{T}(s::Any ...)
"""
mutable struct Combination{S <: Any} <: AbstractCombination
    k::Vector{S}
    Combination{T}(s::Any ...) where {T <: Any} = new{T}([k for k in s])
    Combination(s::Any ...) = Combination{typeof(s[1])}([k for k in s])
end

"""
### Combination{T <: Any} <: AbstractAlgebra
- f::Combination{Function}
- n::Combination{Int64}
------------------
##### constructors
- AlgebraicCombination{T}(f::Function, n::Any)
"""
mutable struct AlgebraicCombination{T <: Any} <: AbstractAlgebra
    f::Combination{Function}
    n::Combination{Int64}
    AlgebraicCombination{T}(f::Function, n::Any) {where T <: Any} = new{T}(f, n)
end

"""
### Combination{T <: Any} <: AbstractAlgebra
- f::Combination{Function}
- n::Combination{Int64}

### example
```julia

```
------------------
##### constructors
- AlgebraicCombination{T}(f::Function, n::Any)
"""
mutable struct Dimensions <: AbstractAlgebra
    n::Combination{Int64}
    Dimensions(i::NumberCombination{<:Any}, t::Type = Float64) = new{t}(n)::Dimensions
    Dimensions(i::NumberCombination{<:Any}) = new{Any}(n)::Dimensions
end

const dim = Dimensions(1)

(:)(t::DataType{<:Any}, i::Int64, d::Dimensions) = begin

end

(:)(t::DataType{<:Any}, i::Int64, d::Dimensions) = begin

end

depth(d::AbstractDimensions) = d.n[3]
width(d::AbstractDimensions) =  d.n[2]
length(d::AbstactDimensions) = d.n[1]
size(d::AbstractDimensions) = d.n

function size!(d::AbstractDimensions)

end

length(c::Combination) = length(c.k)
width(c::Combination) = 1
depth(c::Combination) = 1

*(i::Number ..., t::Type{<:Number}) begin

end

*(d::AbstractDimensions, i::Number = 1) = begin

end

*(d::AbstractDimensions, i::Number = 1) = begin

end

*(i::Int64, d::Dimension) =

*(x::Number, d::Dimension, y::Number = 1, z::Number = 1) = begin
    *(i, d) * i
end

vect(a::AbstractAlgebra ...) = [hcat(fill!(a) for a in 1:a.n)]
vect(n::Combination{<:Any} ...) = [Vector{(typeof(n.k)}(k)]

size!(d::AbstractDimensions, i::Int64 ...) = begin
    n = d.n
end
fill!(f::Function, d::NumberCombination) = begin
    create
end
fill!(f::Function, c::AbstractCombination) = begin
    f(length(c.n))
end
fill!(f::Function, c::AlgebraicCombination) = begin
    f(length(c.n))
end
fill!(d::AbstractAlgebra) = begin
    T = get_parameter(d)
    Dimensions()
end
all(ad::AbstractDimensions) = begin
    [1:length(n) for i in length(n)]
end
getindex(f::Function = all, aa::AbstractDimensions, c::NumberCombination) = begin
    if length(c) < length(c)
        IndexError("The $(aa.n)")
    end
    c[]
end
getindex(f::Function = all, aa::AbstractAlgebra, c::NumberCombination) = begin
    fill!(aa)
end



"""
- OddStructures
### ikeys(pairs::Vector{Pair}) -> Array{Any}
Parses keys of pairs into a 1-densional array.
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
Parses values of pairs into a 1-densional array.
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
apply(array::AbstractDimensions, f::Function) = [f(x) for x in array]

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
apply!(array::AbsstractDimensions, f::Function) = [insert!(array, i, f(val)) for (i, val) in enumerate(array)]

export parse, AlgebraicArray, CarouselArray, StreamArray, write!
export Date, DateTime, parse
export apply!, apply, ivalues, ikeys
end # module
