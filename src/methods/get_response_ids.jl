export get_response_ids

"""
    get_response_ids(client, survey_id, token)

Get response ids for remote survey with `survey_id` by `token`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_response_ids>
"""
function get_response_ids(client::CitrusClient, survey_id::Int, token::AbstractString)
    payload = construct_payload("get_response_ids", [client.session_key, survey_id, token])
    response = call_limesurvey_api(client, payload)
    return response
end
