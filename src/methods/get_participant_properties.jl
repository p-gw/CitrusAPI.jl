export get_participant_properties

"""
    get_participant_properties(client, survey_id, query; properties=nothing)

Get the settings of a survey participant for remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_participant_properties>
"""
function get_participant_properties(client::CitrusClient, survey_id::Int, query; properties=nothing)
    payload = construct_payload("get_participant_properties", [client.session_key, survey_id, query, properties])
    response = call_limesurvey_api(client, payload)
    return response
end
