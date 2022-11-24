export copy_survey!

"""
    copy_survey!(client, survey_id, new_name)

Copy remote survey with `survey_id` to a new survey with title `new_name`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_copy_survey>
"""
function copy_survey!(client::CitrusClient, survey_id::Int, new_name::AbstractString)
    payload = construct_payload("copy_survey", [client.session_key, survey_id, new_name])
    response = call_limesurvey_api(client, payload)
    return response
end
