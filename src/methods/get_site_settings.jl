export get_site_settings

function get_site_settings(client::CitrusClient, name::String)
    payload = construct_payload("get_site_settings", [client.session_key, name])
    response = call_limesurvey_api(client, payload)
    return response
end
