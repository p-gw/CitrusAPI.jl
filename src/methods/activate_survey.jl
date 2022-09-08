export activate_survey!

function activate_survey!(client::CitrusClient, survey_id::Int)
    payload = construct_payload("activate_survey", [client.session_key, survey_id])
    response = call_limesurvey_api(client, payload)
    return response
end
