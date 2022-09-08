export delete_group!

function delete_group!(client::CitrusClient, survey_id::Int, group_id::Int)
    payload = construct_payload("delete_group", [client.session_key, survey_id, group_id])
    response = call_limesurvey_api(client, payload)
    return response
end
