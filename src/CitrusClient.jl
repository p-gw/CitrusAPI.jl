"""
    CitrusClient(url, session_key=nothing)

# Fields
- `url`: LimeSurvey API Endpoint URL.
- `session_key`: Key of the currently active session.
"""
mutable struct CitrusClient
    url::String
    session_key::Union{Nothing,String}
    http_args::Base.Pairs
end

function CitrusClient(url::String, session_key = nothing; kwargs...)
    return CitrusClient(url, session_key, kwargs)
end
