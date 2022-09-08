export delete_response!

function delete_response!(client::CitrusClient, survey_id::Int, response_id::Int)
    payload = construct_payload("delete_response", [client.session_key, survey_id, response_id])
    response = call_limesurvey_api(client, payload)
    return response
end
