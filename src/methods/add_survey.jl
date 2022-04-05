export add_survey!

function add_survey!(client::Client, survey_id::Int, title::AbstractString, language::AbstractString; format::AbstractString="G")
    payload = construct_payload("add_survey", [client.session_key, survey_id, title, language, format])
    response = call_limesurvey_api(client, payload)
    return response
end
