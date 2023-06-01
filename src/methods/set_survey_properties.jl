export set_survey_properties!

"""
    set_survey_properties!(client, survey_id, data)
    set_survey_properties!(client, survey_id, data, sink)

Set properties of the remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_set_survey_properties>
"""
function set_survey_properties!(client::CitrusClient, survey_id::Int, data)
    payload =
        construct_payload("set_survey_properties", [client.session_key, survey_id, data])
    response = call_limesurvey_api(client, payload)
    return response
end

function set_survey_properties!(client, survey_id, data, sink)
    response = set_survey_properties!(client, survey_id, data)
    return response |> sink
end
