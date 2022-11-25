export add_language!

"""
    add_language!(client, survey_id, language)

Add `language` to the remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_add_language>
"""
function add_language!(client::CitrusClient, survey_id::Int, language::AbstractString)
    payload = construct_payload("add_language", [client.session_key, survey_id, language])
    response = call_limesurvey_api(client, payload)
    return response
end

