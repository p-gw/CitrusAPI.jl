export set_participant_properties!

function set_participant_properties!(client::CitrusClient, survey_id::Int, query, data)
    payload = construct_payload("set_participant_properties", [client.session_key, survey_id, query, data])
    response = call_limesurvey_api(client, payload)
    return response
end
