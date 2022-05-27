module LimeSurveyAPI

using Base64
using CSV
using DataFrames
using Dates
using HTTP
using JSON3
using UUIDs

export LimeSurveyClient

include("utils.jl")

mutable struct LimeSurveyClient
    url::String
    session_key::Union{Nothing,String}
end

function LimeSurveyClient(url::String, session_key=nothing)
    return LimeSurveyClient(url, session_key)
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

function call_limesurvey_api(client::LimeSurveyClient, payload; authenticated=true)
    if (authenticated && isnothing(client.session_key))
        error("Authentication required")
    end

    headers = construct_headers()
    response = HTTP.post(client.url, headers, payload)
    parsed_body = JSON3.read(response.body)
    return parsed_body
end

include("methods.jl")

end
