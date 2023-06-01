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

function CitrusClient(url::String, session_key = nothing)
    return CitrusClient(url, session_key)
end
