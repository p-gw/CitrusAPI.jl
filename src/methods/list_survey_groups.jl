export list_survey_groups

"""
    list_survey_groups(client, username=nothing)

Return a list of survey groups belonging to a user with `username`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_list_survey_groups>
"""
function list_survey_groups(client::CitrusClient, username::Union{Nothing,String} = nothing)
    payload = construct_payload("list_survey_groups", [client.session_key, username])
    response = call_limesurvey_api(client, payload)
    return response
end
