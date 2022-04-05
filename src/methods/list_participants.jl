export list_participants

function list_participants(client::Client, survey_id::Int, start::Int; limit::Int=10, unused::Bool=false, attributes=false, conditions=[])
    payload = construct_payload("list_participants", [client.session_key, survey_id, start, limit, unused, attributes, conditions])
    response = call_limesurvey_api(client, payload)
    return response
end
