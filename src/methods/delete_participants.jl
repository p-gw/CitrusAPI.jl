export delete_participants!

function delete_participants!(client::CitrusClient, survey_id::Int, token_ids::Vector{Int})
    payload = construct_payload("delete_participants", [client.session_key, survey_id, token_ids])
    response = call_limesurvey_api(client, payload)
    return response
end
