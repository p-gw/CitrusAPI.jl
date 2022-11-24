export add_group!

"""
    add_group!(client, survey_id, title; description="")

Add a question group to remote survey with `survey_id`.
Requires the specification of a question group `title`.
Optionally a question group `description` can be added.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_add_group>
"""
function add_group!(client::CitrusClient, survey_id::Int, title::AbstractString; description::AbstractString="")
    payload = construct_payload("add_group", [client.session_key, survey_id, title, description])
    response = call_limesurvey_api(client, payload)
    return response
end
