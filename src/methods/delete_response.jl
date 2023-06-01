export delete_response!

"""
    delete_response!(client, survey_id, response_id)

Delete a response by `response_id` from remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_delete_response>
"""
function delete_response!(client::CitrusClient, survey_id::Int, response_id::Int)
    payload =
        construct_payload("delete_response", [client.session_key, survey_id, response_id])
    response = call_limesurvey_api(client, payload)
    return response
end
