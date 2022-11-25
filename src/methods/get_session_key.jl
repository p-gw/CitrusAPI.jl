export get_session_key

"""
    get_session_key(client, username, password; plugin="Authdb")

Generate a session key given `username` and `password`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_session_key>
"""
function get_session_key(client::CitrusClient, username::AbstractString, password::AbstractString; plugin="Authdb")
    payload = construct_payload("get_session_key", [username, password, plugin])
    response = call_limesurvey_api(client, payload, authenticated=false)
    return response
end
