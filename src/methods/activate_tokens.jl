export activate_tokens!

function activate_tokens!(client::CitrusClient, survey_id::Int, attribute_fields::Vector{Int}=[])
    payload = construct_payload("activate_tokens", [client.session_key, survey_id, attribute_fields])
    response = call_limesurvey_api(client, payload)
    return response
end
