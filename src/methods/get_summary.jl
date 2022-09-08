export get_summary

function get_summary(client::CitrusClient, survey_id::Int; stat="all")
    payload = construct_payload("get_summary", [client.session_key, stat])
    response = call_limesurvey_api(client, payload)
    return response
end
