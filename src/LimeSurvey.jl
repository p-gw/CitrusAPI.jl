module LimeSurvey

using Base64
using HTTP
using JSON3
using UUIDs

export Client
export connect!, disconnect!

include("utils.jl")

mutable struct Client
    url::String
    session_key::Union{Nothing,String}
end

function Client(url::String, session_key=nothing)
    return Client(url, session_key)
end

function construct_payload(method::AbstractString, params)
    request_id = string(UUIDs.uuid4())
    payload = Dict(
        "method" => method,
        "params" => params,
        "id" => request_id
    )
    json_payload = JSON3.write(payload)
    return json_payload
end

function construct_headers()
    headers = Dict("Content-type" => "application/json")
    return headers
end

function call_limesurvey_api(client::Client, payload; authenticated=true)
    if (authenticated && isnothing(client.session_key))
        error("Authentication required")
    end

    headers = construct_headers()
    response = HTTP.post(client.url, headers, payload)
    parsed_body = JSON3.read(response.body)
    return parsed_body
end

include("methods.jl")

# convenience fns
function connect!(client::Client, username::String, password::String; plugin="Authdb")
    response = get_session_key(client, username, password, plugin=plugin)
    if !(response.result isa String)
        error("Failed to connect. Error: $(response.result.status)")
    end
    client.session_key = response.result
    @info "Connected to server '$(client.url)'\n\tSession key: $(client.session_key)"
    return nothing
end

function disconnect!(client::Client)
    release_session_key(client)
    client.session_key = nothing
    @info "Disconnected from server '$(client.url)'"
    return nothing
end

end
