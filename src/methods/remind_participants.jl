export remind_participants

function remind_participants(client::LimeSurveyClient, survey_id::Int; min_days_between::Union{Nothing,Int}=nothing, max_reminders::Union{Nothing,Int}=nothing, token_ids=false)
    payload = construct_payload("remind_participants", [client.session_key, survey_id, min_days_between, max_reminders, token_ids])
    response = call_limesurvey_api(client, payload)
    return response
end
