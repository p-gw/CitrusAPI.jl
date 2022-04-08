export set_survey_properties!
export expire_survey!

function set_survey_properties!(client::LimeSurveyClient, survey_id::Int, data)
    payload = construct_payload("set_survey_properties", [client.session_key, survey_id, data])
    response = call_limesurvey_api(client, payload)
    return response
end

function set_survey_properties!(client, survey_id, data, sink)
    response = set_survey_properties!(client, survey_id, data)
    return response.result |> sink
end

function expire_survey!(client, survey_id, date::Union{Date,DateTime}=now())
    response = set_survey_properties!(client, survey_id, Dict("expires" => date))
    return response
end
