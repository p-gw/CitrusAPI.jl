export set_quota_properties!

function set_quota_properties!(client::LimeSurveyClient, quota_id::Int, data)
    payload = construct_payload("set_quota_properties", [client.session_key, quota_id, data])
    response = call_limesurvey_api(client, payload)
    return response
end
