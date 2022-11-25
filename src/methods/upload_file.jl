export upload_file!

"""
    upload_file!(client, survey_id, field, name, content)

Upload a file to the remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_upload_file>
"""
function upload_file!(client::CitrusClient, survey_id::Int, field::String, name::String, content::String)
    payload = construct_payload("upload_file", [client.session_key, survey_id, field, file_name, file_content])
    response = call_limesurvey_api(client, payload)
    return response
end
