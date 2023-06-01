export set_group_properties!

"""
    set_group_properties!(client, group_id, data)

Set properties of the question group with `group_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_set_group_properties>
"""
function set_group_properties!(client::CitrusClient, group_id::Int, data)
    payload =
        construct_payload("set_group_properties", [client.session_key, group_id, data])
    response = call_limesurvey_api(client, payload)
    return response
end
