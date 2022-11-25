export release_session_key
export disconnect!

"""
    release_session_key(client)

Close the current session for `client`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_release_session_key>
"""
function release_session_key(client::CitrusClient)
    payload = construct_payload("release_session_key", [client.session_key])
    response = call_limesurvey_api(client, payload)
    return response
end
