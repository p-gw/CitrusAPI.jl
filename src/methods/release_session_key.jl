export release_session_key

function release_session_key(client::Client)
    payload = construct_payload("release_session_key", [client.session_key])
    response = call_limesurvey_api(client, payload)
    return response
end
