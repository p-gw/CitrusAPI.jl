export mail_registered_participants

function mail_registered_participants(client::CitrusClient, survey_id::Int; override_all_conditions=nothing)
    payload = construct_payload("mail_registered_participants", [client.session_key, survey_id, override_all_conditions])
    response = call_limesurvey_api(client, payload)
    return response
end

# TODO: check if this works
function mail_registered_participant(client, survey_id, token_id::Int)
    opts = Dict("tid" => token_id)
    response = mail_registered_participants(client, survey_id, override_all_conditions=opts)
    return response
end

