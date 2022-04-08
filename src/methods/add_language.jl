export add_language!

function add_language!(client::LimeSurveyClient, survey_id::Int, language::AbstractString)
    payload = construct_payload("add_language", [client.session_key, survey_id, language])
    response = call_limesurvey_api(client, payload)
    return response
end

