export get_uploaded_files

"""
    get_uploaded_files(client, survey_id, token)

Get all uploaded files for remote survey with `survey_id` by `token`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_uploaded_files>
"""
function get_uploaded_files(client::CitrusClient, survey_id::Int, token::AbstractString)
    payload = construct_payload("get_uploaded_files", [client.session_key, survey_id, token])
    response = call_limesurvey_api(client, payload)
    return response
end
