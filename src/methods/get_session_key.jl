export get_session_key

function get_session_key(client::Client, username::AbstractString, password::AbstractString; plugin="Authdb")
    payload = construct_payload("get_session_key", [username, password, plugin])
    response = call_limesurvey_api(client, payload, authenticated=false)
    return response
end
