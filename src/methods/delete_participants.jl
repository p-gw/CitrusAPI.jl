export delete_participants!

"""
    delete_participants!(client, survey_id, token_ids)

Delete participants from a remote survey with `survey_id` by their access `token_ids`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_delete_participants>
"""
function delete_participants!(client::CitrusClient, survey_id::Int, token_ids::Vector{Int})
    payload = construct_payload("delete_participants", [client.session_key, survey_id, token_ids])
    response = call_limesurvey_api(client, payload)
    return response
end
