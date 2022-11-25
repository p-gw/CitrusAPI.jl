module CitrusAPI

using Base64
using CSV
using DataFrames
using Dates
using HTTP
using JSON3
using UUIDs

export CitrusClient, connect!
export is_active

include("utils.jl")

"""
    CitrusClient(url, session_key=nothing)

# Fields
- `url`: LimeSurvey API Endpoint URL.
- `session_key`: Key of the currently active session.
"""
mutable struct CitrusClient
    url::String
    session_key::Union{Nothing,String}
end

function CitrusClient(url::String, session_key=nothing)
    return CitrusClient(url, session_key)
end

"""
    connect!(client, username, password; plugin="Authdb")

Connect a LimeSurvey `client` by generating a session key given `username` and `password`.

See also: [`get_session_key`](@ref)
"""
function connect!(client::CitrusClient, username::String, password::String; plugin="Authdb")
    response = get_session_key(client, username, password, plugin=plugin)
    if !(response.result isa String)
        error("Failed to connect. Error: $(response.result.status)")
    end
    client.session_key = response.result
    @info "Connected to server '$(client.url)'\n\tSession key: $(client.session_key)"
    return nothing
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

function call_limesurvey_api(client::CitrusClient, payload; authenticated=true)
    if (authenticated && isnothing(client.session_key))
        error("Authentication required")
    end

    headers = construct_headers()
    response = HTTP.post(client.url, headers, payload)
    parsed_body = JSON3.read(response.body)
    return parsed_body
end

include("methods.jl")

# helpers
function is_active(client::CitrusClient, survey_id::Int)
    res = get_survey_properties(client, survey_id)
    haskey(res.result, "status") && error("Failed with error: $(res.result.status)")
    return res.result.active == "Y"
end

end
