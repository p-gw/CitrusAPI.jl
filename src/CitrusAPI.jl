module CitrusAPI

using Base64
using CSV
using DataFrames
using Dates
using HTTP
using JSON3
using UUIDs

export CitrusClient
export is_active

include("utils.jl")

mutable struct CitrusClient
    url::String
    session_key::Union{Nothing,String}
end

function CitrusClient(url::String, session_key=nothing)
    return CitrusClient(url, session_key)
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
