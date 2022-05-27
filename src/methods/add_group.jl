export add_group!

function add_group!(client::LimeSurveyClient, survey_id::Int, title::AbstractString; description::AbstractString="")
    payload = construct_payload("add_group", [client.session_key, survey_id, title, description])
    response = call_limesurvey_api(client, payload)
    return response
end
