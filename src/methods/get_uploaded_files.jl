export get_uploaded_files

function get_uploaded_files(client::CitrusClient, survey_id::Int, token::AbstractString)
    payload = construct_payload("get_uploaded_files", [client.session_key, survey_id, token])
    response = call_limesurvey_api(client, payload)
    return response
end
