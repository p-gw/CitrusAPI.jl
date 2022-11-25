export activate_survey!

"""
    activate_survey!(client, survey_id)

Activate a remote survey by `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_activate_survey>
"""
function activate_survey!(client::CitrusClient, survey_id::Int)
    payload = construct_payload("activate_survey", [client.session_key, survey_id])
    response = call_limesurvey_api(client, payload)
    return response
end
