export delete_group!

"""
    delete_group!(client, survey_id, group_id)

Delete the question group with `group_id` from remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_delete_group>
"""
function delete_group!(client::CitrusClient, survey_id::Int, group_id::Int)
    payload = construct_payload("delete_group", [client.session_key, survey_id, group_id])
    response = call_limesurvey_api(client, payload)
    return response
end
