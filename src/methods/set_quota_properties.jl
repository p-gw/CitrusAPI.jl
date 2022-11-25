export set_quota_properties!

"""
    set_quota_properties!(client, quota_id, data)

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_set_quota_properties>
"""
function set_quota_properties!(client::CitrusClient, quota_id::Int, data)
    payload = construct_payload("set_quota_properties", [client.session_key, quota_id, data])
    response = call_limesurvey_api(client, payload)
    return response
end
