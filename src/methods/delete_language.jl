export delete_language!

function delete_language!(client::CitrusClient, survey_id::Int, language::String)
    payload = construct_payload("delete_language", [client.session_key, survey_id, language])
    response = call_limesurvey_api(client, payload)
    return response
end
