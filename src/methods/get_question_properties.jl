export get_question_properties

function get_question_properties(client::LimeSurveyClient, question_id::Int; settings=nothing, language=nothing)
    payload = construct_payload("get_question_properties", [client.session_key, question_id, settings, language])
    response = call_limesurvey_api(client, payload)
    return response
end
