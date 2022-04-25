"""
### abstract type AbstractAlgebraicArray
Basic algebra arrays
Common fields
- f::Function - The function, which takes n to calculate the index.
- n::Int64 - The length of the Algebraic Array.
- calls::Vector{Pair{Function, Tuple}}
"""
abstract type AbstractAlgebraicArray end

"""
### AlgebraicArray
**fields**
- f::Function - The function, which takes n to calculate the index.
- n::Int64 - The length of the Algebraic Array.
- calls::Vector{Pair{Function, Tuple}}
**constructors*
- AlgebraicArray(f::Function, n::Int64)
------------------
#### description
An algebraic array is an array that saves memory by only calculating values
automatically when indexed. For the AlgebraicArray, we can either use indexing
to compute portions of the array, or we can use the compute() method. Another
important macro is the @algebraic! macro, which allows you to add code to the
    array.
#### Example
```
aa = AlgebraicArray(f(n::Int64) -> n * 20, 3)
aa[2]
40

@algebraic aa + 2
aa[2]
42

compute(aa) do a
    println(a)
end
# It stops here because n = 3.
[22, 42, 62]
```
"""
mutable struct AlgebraicArray  <: AbstractAlgebraicArray
    f::Function
    n::Int64
    calls::Vector{Pair{Function, Tuple}}
    function AlgebraicArray(f::Function, n::Int64)
        new(f, n, [])
    end
end

"""
### add_algebra(aa::Symbol, args::Any) -> mutates **aa**
Not meant to be used at high-level, adds algebra to an algebraic array via the
macro @algebraic!
##### example
```
@algebraic aa + 5
```
"""
function add_algebra(aa::Symbol, args::Any)
    aa = eval(aa)
    if length(args) > 1
        farguments = Tuple(eval(args[length(args)]))
        push!(aa.calls, eval(args[1]) => farguments)
    else
        push!(aa.calls, eval(args[1]) => [])
    end
end

function generate(aa::AbstractAlgebraicArray)
    [aa.f(n) for n in 1:aa.n]
end

function generate(aa::AbstractAlgebraicArray, mask::BitArray)
    if length(mask) != aa.n
        throw(DimensionMismatch("Mask must be the same size as AlgebraicArray!"))
    end
    vals = Array(1:aa.n)
    filter!(vals, mask)
    [aa.f(n) for n in vals]
end

function generate(aa::AbstractAlgebraicArray, range::UnitRange)
    if range[2] > aa.n
        throw(BoundsError("Invalid algebraic index!"))
    end
    [aa.f(n) for n in range]
end

function generate(aa::AbstractAlgebraicArray, index::Integer)
    if index > aa.n
        throw(string("Invalid algebraic index!"))
    end
    aa.f(index)[1]
end

function compute(aa::AbstractAlgebraicArray, r::Any) # <- range, bitarray
    gen = generate(aa, r)
    for call in aa.calls
        gen = [call[1](val, call[2]...) for val in gen]
    end
    return(gen)
end

function compute(aa::AbstractAlgebraicArray, r::Integer) # <- Index
    gen = generate(aa, r)
    for call in aa.calls
        gen = [call[1](gen, call[2]...)]
    end
    return(gen)
end

function compute(aa::AbstractAlgebraicArray)
    gen = generate(aa)
    for call in aa.calls
        gen = [call[1](val, call[2]...) for val in gen]
    end
    return(gen)
end

function compute(f::Function, aa::AbstractAlgebraicArray) # compute(aa) do _
    gen = generate(aa)
    for call in aa.calls
        gen = [call[1](gen, call[2]...)]
    end
    return(f(gen))
end
"""
### @algebraic(aa::Symbol, args::Any) -> mutates **aa**
Not meant to be used at high-level, adds algebra to an algebraic array via the
macro @algebraic!
##### example
```
@algebraic aa + 5
```
"""
macro algebraic!(aa::AlgebraicArray, exp::Expr)
    add_algebra(aa, exp.head, exp.args)
end

getindex(aa::AlgebraicArray, i::Any) = compute(aa, i)

function iterate(aa::AbstractAlgebraicArray)
    ret = Iterators.partition(compute(aa), 1)
end

function linear_UUID(start::Int64, max::Int64)
    f(n::Int64)::Function = Array(range)[n]
    return(AlgebraicArray(f, max))
end
