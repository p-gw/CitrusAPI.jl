export get_language_properties

"""
    get_language_properties(client, survey_id; locale_settings=nothing, language=nothing)

Get the language properties of a remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_language_properties>
"""
function get_language_properties(
    client::CitrusClient,
    survey_id::Int;
    locale_settings = nothing,
    language = nothing,
)
    payload = construct_payload(
        "get_language_properties",
        [client.session_key, survey_id, locale_settings, language],
    )
    response = call_limesurvey_api(client, payload)
    return response
end
