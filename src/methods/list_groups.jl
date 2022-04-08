export list_groups

function list_groups(client::LimeSurveyClient, survey_id::Int; language::Union{String,Nothing}=nothing)
    payload = construct_payload("list_groups", [client.session_key, survey_id, language])
    response = call_limesurvey_api(client, payload)
    return response
end
