export add_survey!

function add_survey!(client::LimeSurveyClient, survey_id::Int, title::AbstractString, language::AbstractString; format::AbstractString="G")
    payload = construct_payload("add_survey", [client.session_key, survey_id, title, language, format])
    response = call_limesurvey_api(client, payload)
    return response
end

function add_survey!(client, survey_id, title, language, sink; kwargs...)
    response = add_survey!(client, survey_id, title, language; kwargs...)
    return response.result |> sink
end
