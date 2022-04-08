export get_participant_properties

function get_participant_properties(client::LimeSurveyClient, survey_id::Int, query; properties=nothing)
    payload = construct_payload("get_participant_properties", [client.session_key, survey_id, query, properties])
    response = call_limesurvey_api(client, payload)
    return response
end
