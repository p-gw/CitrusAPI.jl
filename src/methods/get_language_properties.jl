export get_language_properties

function get_language_properties(client::LimeSurveyClient, survey_id::Int; locale_settings=nothing, language=nothing)
    payload = construct_payload("get_language_properties", [client.session_key, survey_id, locale_settings, language])
    response = call_limesurvey_api(client, payload)
    return response
end
