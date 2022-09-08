export upload_file!

function upload_file!(client::CitrusClient, survey_id::Int, field::String, file_name::String, file_content::String)
    payload = construct_payload("upload_file", [client.session_key, survey_id, field, file_name, file_content])
    response = call_limesurvey_api(client, payload)
    return response
end
