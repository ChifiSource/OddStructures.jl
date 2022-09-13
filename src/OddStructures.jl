"""
Created in April, 2022 by
[chifi - an open source software dynasty.](https://github.com/orgs/ChifiSource)
by team
[odd-data](https://github.com/orgs/ChifiSource/teams/odd-data)
This software is MIT-licensed.
### OddStructures
Defines and exports different basic odd-data structures for different files to
use.
##### Module Composition
- [**OddStructures**]() - High-level API!
- [Components.jl]() - Toolips binding to OddStructures
"""
module OddStructures
import Toolips: Servable, write!, Component
using ParseNotEval
using CarouselArrays
using Dates

#==
Combinations
==#
abstract type AbstractCombination <: AbstractDimensions end

mutable struct Combination{S <: AbstractString}
    k::Vector{S}
end

#==TODO find greatest sub-type
==#
mutable struct MixedCombination{S <: Any}
    T::Vector{Type}
    k::Vector{<:Any}
    function MixedCombination()

    end

end

(:)(c::Combination{<:Any} ...) = begin
    Combination(vcat(k))::Combination{typeof(k)}
end

mutable struct NumberCombination{N <: Number}
    k::Vector{N}
end

(:)(f::Function, ac::AlgebraicCombination)

(:)(elements::AbstractString ...) = begin
    Combination{typeof(elements[1])}([s for s in elements]::Vector{typeof(elements[1])})
end

(:)(elements::Number ...) = begin
    NumericalCombination{typeof(elements[1])}()
end





string(c::Combination{<:AbstractString}) = string(join(["$k:" for k in c.k]))



getindex(c::Combination, i::Int64) = c.k[i]::String
setindex!(c::Combination, s::String, i::Int64) = c.k[i] = s
length(c::Combination) = length(c.k)

mutable struct IndexSymbol{S <: Function}
    f::Function
    IndexSymbol(symb::String = "all") = IndexSymbol{Symbol(symb)}()
end

function vector()

end

function length(ad::AbstractDimensions)

end

function depth()

end




mutable struct Dimensions <: AbstractDimensions end
    dimensions::Int64
    types::Vector{DataType{<: Any}}
    Dimensions(i::Int64, t::Vector{Type} = (typeof(i) for i in 1:4)) = Dimensions(length(1:i), t)::Dimensions
    Dimensions(i::Int64)
end

length(ad::AbstractDimensions) = length(1:ad.dimensions)

const d = Dimensions

*(i::Number ..., t::Type{<:Numver}) begin

end

*(i::Number, d::Dimension) = begin

end



vect(ad::AbstractDimensions, i::Vector{AbstractNumber} ...) begin

end

Matrix(t::Tensor{<:Any}) = Matrix()

.*(ad::AbstractDimensions, i::Number) = begin

end
*(ad::AbstractDimensions, i::Number) = begin

end

contains(ad::AbstractDimensions, needle::AbstractDimensions) = begin

end

.*(ad::AbstractDimensions, ad::AbstractDimenions) = begin

end

const all = IndexSymbol(all)

function getindex(od::AbstractDimensions, all::IndexSymbol{<:Any}, i::Int64)

end

function getindex(od::AbstractOddFrame, all::IndexSymbol{<:Any}, i::IndexSymbol{<:Any})
    return()
end

function getindex(od::AbstractOddFrame, i::Int64, all::IndexSymbol{<:Any}})

end

function getindex(od::AbstractOddFrame, s::String, all::IndexSymbol{<:Any})

end



table(name::String, p::Pair{String, <:Any} ...; args ...) = Component(name, "table")
td(name::String, p::Pair{String, <:Any} ...; args ...) = Component(name, "td")
th(name::String, p::Pair{String, <:Any} ...; args ...) = Component(name, "th")
tr(name::String, p::Pair{String, <:Any} ...; args ...) = Component(name, "tr")

write!(c::Connection, od::AbstractOddFrame) = begin
        rows = od[all, 1]
end
function write!(c::AbstractConnection, )

# x y z r g b a r


StreamArray(length::Int64, uri::String) = AlgebraicArray(n::Int64) do row::AbstractVector
    [parse(T, read(uri, i)) for i in 1:n]::Vector{}
end

mutable struct AlgebraicArray{T <: Number}
    n::Int64
    f::Function
    generator::Int64
    function AlgebraicArray()

    end
end
ImageArray()

StreamArray()

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

export parse, AlgebraicArray, CarouselArray, StreamArray, write!
export Date, DateTime, parse
export apply!, apply, ivalues, ikeys
end # module
