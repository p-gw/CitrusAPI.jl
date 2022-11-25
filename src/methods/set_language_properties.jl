export set_language_properties!

"""
    set_language_properties!(client, survey_id, data; language=nothing)

Set the language properties of remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_set_language_properties>
"""
function set_language_properties!(client::CitrusClient, survey_id::Int, data; language=nothing)
    payload = construct_payload("set_language_properties", [client.session_key, survey_id, data, language])
    response = call_limesurvey_api(client, payload)
    return response
end
