export get_site_settings

"""
    get_site_settings(client, name)

Get global LimeSurvey settings by `name`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_site_settings>
"""
function get_site_settings(client::CitrusClient, name::AbstractString)
    payload = construct_payload("get_site_settings", [client.session_key, name])
    response = call_limesurvey_api(client, payload)
    return response
end
