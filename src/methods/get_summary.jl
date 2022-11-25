export get_summary

"""
    get_summary(client, survey_id; stat="all")

Get a summary of a survey by `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_summary>
"""
function get_summary(client::CitrusClient, survey_id::Int; stat="all")
    payload = construct_payload("get_summary", [client.session_key, survey_id, stat])
    response = call_limesurvey_api(client, payload)
    return response
end
