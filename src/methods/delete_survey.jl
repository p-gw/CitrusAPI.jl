export delete_survey!

"""
    delete_survey!(client, survey_id)

Delete a remote survey by `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_delete_survey>
"""
function delete_survey!(client::CitrusClient, survey_id::Int)
    payload = construct_payload("delete_survey", [client.session_key, survey_id])
    response = call_limesurvey_api(client, payload)
    return response
end
