export activate_tokens!

"""
    activate_tokens!(client, survey_id, attribute_fields=[])

Initialise the participants table for remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_activate_tokens>
"""
function activate_tokens!(client::CitrusClient, survey_id::Int, attribute_fields::Vector{Int}=[])
    payload = construct_payload("activate_tokens", [client.session_key, survey_id, attribute_fields])
    response = call_limesurvey_api(client, payload)
    return response
end
