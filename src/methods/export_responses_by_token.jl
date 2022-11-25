export export_responses_by_token

"""
    export_responses_by_token(client, survey_id, document_type, token; language=nothing, completion_status="all", heading_type="code", response_type="short", fields=nothing)

Export responses from remote survey with `survey_id` as `document_type` as a base64 encoded string.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_export_responses_by_token>
"""
function export_responses_by_token(client::CitrusClient, survey_id::Int, document_type::String, token::String; language::Union{Nothing,String}=nothing, completion_status::Union{Nothing,String}="all", heading_type::Union{Nothing,String}="code", response_type::Union{Nothing,String}="short", fields::Union{Nothing,AbstractArray}=nothing)
    payload = construct_payload("export_responses_by_token", [client.session_key, survey_id, document_type, token, language, completion_status, heading_type, response_type, fields])
    response = call_limesurvey_api(client, payload)
    return response
end
