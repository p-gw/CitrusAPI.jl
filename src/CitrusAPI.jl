module CitrusAPI

using Base64
using CSV
using DataFrames
using Dates
using HTTP
using JSON3
using UUIDs

export CitrusClient, connect!, disconnect!
export LimeSurveyError, AuthenticationError
export is_active, expire_survey!

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
    client.session_key = response
    @info "Connected to server '$(client.url)'\n\tSession key: $(client.session_key)"
    return response
end

"""
    disconnect!(client)

Disconnect `client` from a LimeSurvey server by releasing the session key.

See also: [`release_session_key`](@ref)
"""
function disconnect!(client::CitrusClient)
    response = release_session_key(client)
    client.session_key = nothing
    @info "Disconnected from server '$(client.url)'"
    return response
end

# helpers
"""
    is_active(client, survey_id)

Determine if a remote survey with `survey_id` is active.

See also: [`get_survey_properties`](@ref)
"""
function is_active(client::CitrusClient, survey_id::Int)
    res = get_survey_properties(client, survey_id)
    return res.active == "Y"
end

"""
    expire_survey!(client, survey_id, date=now())

Set the expiry date of the remote survey with `survey_id`.

See also: [`set_survey_properties!`](@ref)
"""
function expire_survey!(client, survey_id, datetime::DateTime=now())
    response = set_survey_properties!(client, survey_id, Dict("expires" => datetime))
    return response
end

end
