export get_survey_properties

"""
    get_survey_properties(client, survey_id; settings=nothing)

Get the properties of a remote survey by `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_survey_properties>
"""
function get_survey_properties(client::CitrusClient, survey_id::Int; settings=nothing)
    payload = construct_payload("get_survey_properties", [client.session_key, survey_id, settings])
    response = call_limesurvey_api(client, payload)
    return response
end

function get_survey_properties(client, survey_id, sink; settings=nothing)
    response = get_survey_properties(client, survey_id; settings)
    return response |> sink
end
