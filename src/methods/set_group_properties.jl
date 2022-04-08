export set_group_properties!

function set_group_properties!(client::LimeSurveyClient, group_id::Int, data)
    payload = construct_payload("set_group_properties", [client.session_key, group_id, data])
    response = call_limesurvey_api(client, payload)
    return response
end
