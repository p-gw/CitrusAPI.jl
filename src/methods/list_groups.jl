export list_groups

"""
    list_groups(client, survey_id; language)
    list_groups(client, survey_id sink; language)

List all question groups of a survey.
"""
function list_groups(client::LimeSurveyClient, survey_id::Int; language::Union{String,Nothing}=nothing)
    payload = construct_payload("list_groups", [client.session_key, survey_id, language])
    response = call_limesurvey_api(client, payload)
    return response
end

function list_groups(client, survey_id, sink; language::Union{String,Nothing}=nothing)
    response = list_groups(client, survey_id; language)
    return response.result |> sink
end
