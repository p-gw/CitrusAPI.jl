export get_response_ids

function get_response_ids(client::CitrusClient, survey_id::Int, token::AbstractString)
    payload = construct_payload("get_response_ids", [client.session_key, survey_id, token])
    response = call_limesurvey_api(client, payload)
    return response
end
