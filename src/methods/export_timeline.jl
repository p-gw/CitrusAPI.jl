export export_timeline

function export_timeline(client::CitrusClient, survey_id::Int, type::String, from::String, to::String)
    payload = construct_payload("export_timeline", [client.session_key, survey_id, type, from, to])
    response = call_limesurvey_api(client, payload)
    return response
end
