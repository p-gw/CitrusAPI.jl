export update_response!

"""
    update_response!(client, survey_id, data)

Update a response of the remote survey with `survey_id` with new `data`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_update_response>
"""
function update_response!(client::CitrusClient, survey_id::Int, data)
    payload = construct_payload("update_response", [client.session_key, survey_id, data])
    response = call_limesurvey_api(client, payload)
    return response
end
