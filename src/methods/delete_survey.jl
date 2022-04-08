export delete_survey!

function delete_survey!(client::LimeSurveyClient, survey_id::Int)
    payload = construct_payload("delete_survey", [client.session_key, survey_id])
    response = call_limesurvey_api(client, payload)
    return response
end
