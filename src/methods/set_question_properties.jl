export set_question_properties!

function set_question_properties!(client::LimeSurveyClient, question_id::Int, data; language=nothing)
    payload = construct_payload("set_question_properties", [client.session_key, question_id, data, language])
    response = call_limesurvey_api(client, payload)
    return response
end
