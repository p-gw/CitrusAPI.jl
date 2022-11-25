module CitrusAPI

using Base64
using CSV
using DataFrames
using Dates
using HTTP
using JSON3
using UUIDs

export CitrusClient, connect!, disconnect!
export is_active

include("utils.jl")
include("CitrusClient.jl")
include("methods.jl")
include("query.jl")

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

"""
    disconnect!(client)

Disconnect `client` from a LimeSurvey server by releasing the session key.

See also: [`release_session_key`](@ref)
"""
function disconnect!(client::CitrusClient)
    release_session_key(client)
    client.session_key = nothing
    @info "Disconnected from server '$(client.url)'"
    return nothing
end

# helpers
"""
    is_active(client, survey_id)

Determine if a remote survey with `survey_id` is active.

See also: [`get_survey_properties`](@ref)
"""
function is_active(client::CitrusClient, survey_id::Int)
    res = get_survey_properties(client, survey_id)
    haskey(res.result, "status") && error("Failed with error: $(res.result.status)")
    return res.result.active == "Y"
end

"""
    expire_survey!(client, survey_id, date=now())

Set the expiry date of the remote survey with `survey_id`.

See also: [`set_survey_properties!`](@ref)
"""
function expire_survey!(client, survey_id, date::Union{Date,DateTime}=now())
    response = set_survey_properties!(client, survey_id, Dict("expires" => date))
    return response
end

end
