export set_language_properties!

function set_language_properties!(client::CitrusClient, survey_id::Int, data; language=nothing)
    payload = construct_payload("set_language_properties", [client.session_key, survey_id, data, language])
    response = call_limesurvey_api(client, payload)
    return response
end
