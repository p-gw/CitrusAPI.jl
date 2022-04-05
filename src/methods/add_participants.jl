export add_participants!

function add_participants!(client::Client, survey_id::Int, data; create_token=true)
    payload = construct_payload("add_participants", [client.session_key, survey_id, data, create_token])
    response = call_limesurvey_api(client, payload)
    return response
end
