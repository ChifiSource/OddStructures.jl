"""
Created in April, 2022 by
[chifi - an open source software dynasty.](https://github.com/orgs/ChifiSource)
by team
[odd-data](https://github.com/orgs/ChifiSource/teams/odd-data)
This software is MIT-licensed.
### WebDNA
Some basic expressions for working with web types from base types.
##### Module Composition
- [**WebRNA**]() - Random useful web creations.
"""
module WebRNA

"""
### hex_str(::String) -> ::String
Simply adds hex styling to a string.
##### example
```
hex"FFFFFF"
"#FFFFFF"
```
"""
macro hex_str(s::String)
    if length(s) != 6
        throw("A HEXidecimal should be 6 characters.")
    end
    return("#$s"::String)
end
# px"500"
"""
### pxx_str(::String) -> ::String
Simply adds px styling to a string.
##### example
```
px"500"
"500px"
```
"""
macro px_str(s::String)
    return("$s px"::String)
end

"""
### px_str(::Int64) -> ::String
Simply adds percent styling to an integer as a string.
##### example
```
px"500"
"500px"
```
"""
macro %(s::Int64)
    return("$s %")
end
export %, px_str, hex_str
end # module
