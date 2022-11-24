export add_response!

"""
    add_response!(client, survey_id, data)

Add a resopnse to the remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_add_response>
"""
function add_response!(client::CitrusClient, survey_id::Int, data)
    payload = construct_payload("add_response", [client.session_key, survey_id, data])
    response = call_limesurvey_api(client, payload)
    return response
end
