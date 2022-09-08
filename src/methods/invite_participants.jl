export invite_participants

function invite_participants(client::CitrusClient, survey_id::Int, token_ids::Vector{Int}; email::Bool=true)
    payload = construct_payload("invite_participants", [client.session_key, survey_id, token_ids, email])
    response = call_limesurvey_api(client, payload)
    return response
end
