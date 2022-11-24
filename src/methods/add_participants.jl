export add_participants!

"""
    add_participants!(client, survey_id, data; create_token=true)

Add participants to the remote survey with `survey_id`.
`data` contains participant data to be added.
If `create_token=true` (the default), access tokens will be automatically created.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_add_participants>
"""
function add_participants!(client::CitrusClient, survey_id::Int, data; create_token=true)
    payload = construct_payload("add_participants", [client.session_key, survey_id, data, create_token])
    response = call_limesurvey_api(client, payload)
    return response
end
