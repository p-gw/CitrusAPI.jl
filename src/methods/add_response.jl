export add_response!

function add_response!(client::CitrusClient, survey_id::Int, data)
    payload = construct_payload("add_response", [client.session_key, survey_id, data])
    response = call_limesurvey_api(client, payload)
    return response
end
