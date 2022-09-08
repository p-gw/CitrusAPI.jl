export get_survey_properties

function get_survey_properties(client::CitrusClient, survey_id::Int; settings=nothing)
    payload = construct_payload("get_survey_properties", [client.session_key, survey_id, settings])
    response = call_limesurvey_api(client, payload)
    return response
end

function get_survey_properties(client, survey_id, sink; settings=nothing)
    response = get_survey_properties(client, survey_id; settings)
    return response.result |> sink
end
