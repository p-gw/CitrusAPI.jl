module LimeSurvey

using HTTP
using JSON3
using UUIDs

export Client
export connect!, disconnect!

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

# methods
include("methods/activate_survey.jl")
include("methods/activate_tokens.jl")
include("methods/add_group.jl")
include("methods/add_language.jl")
include("methods/add_participants.jl")
include("methods/add_response.jl")
include("methods/add_survey.jl")
include("methods/copy_survey.jl")
include("methods/get_session_key.jl")
include("methods/list_groups.jl")
include("methods/list_participants.jl")
include("methods/list_questions.jl")
include("methods/list_survey_groups.jl")
include("methods/list_surveys.jl")
include("methods/list_users.jl")
include("methods/release_session_key.jl")

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
