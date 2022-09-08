export list_surveys

"""
    list_surveys(client; username)
    list_surveys(client, sink; username)

List all surveys on the server.
Optional argument `username` can be set to list all surveys belonging to a single user.

Specify a `sink` to parse response into another data structure.

# Examples
```julia-repl
julia> # connect to Limesurvey client c
julia> list_surveys(c)

julia> using DataFrames
julia> list_surveys(c, DataFrame)
```
"""
function list_surveys(client::CitrusClient; username::Union{AbstractString,Nothing}=nothing)
    payload = construct_payload("list_surveys", [client.session_key, username])
    response = call_limesurvey_api(client, payload)
    return response
end

function list_surveys(client::CitrusClient, sink; username=nothing)
    response = list_surveys(client, username=username)
    return response.result |> sink
end
