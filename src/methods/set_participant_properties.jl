export set_participant_properties!

"""
    set_participant_properties!(client, survey_id, query, data)

Set properties of a participant of a remote survey with `survey_id`.
`query` can either be a participant token id, or an array of participant properties.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_set_participant_properties>
"""
function set_participant_properties!(client::CitrusClient, survey_id::Int, query, data)
    payload = construct_payload(
        "set_participant_properties",
        [client.session_key, survey_id, query, data],
    )
    response = call_limesurvey_api(client, payload)
    return response
end
