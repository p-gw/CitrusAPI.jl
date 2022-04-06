export export_responses_by_token

function export_responses_by_token(client::Client, survey_id::Int, document_type::String, token::String; language::Union{Nothing,String}=nothing, completion_status::Union{Nothing,String}="all", heading_type::Union{Nothing,String}="code", response_type::Union{Nothing,String}="short", fields::Union{Nothing,AbstractArray}=nothing)
    payload = construct_payload("export_responses_by_token", [client.session_key, survey_id, document_type, token, language, completion_status, heading_type, response_type, fields])
    response = call_limesurvey_api(client, payload)
    return response
end
