export export_timeline

"""
    export_timeline(client, survey_id, type, from, to)

Export the timeline of submissions for remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_export_timeline>
"""
function export_timeline(
    client::CitrusClient,
    survey_id::Int,
    type::String,
    from::String,
    to::String,
)
    payload = construct_payload(
        "export_timeline",
        [client.session_key, survey_id, type, from, to],
    )
    response = call_limesurvey_api(client, payload)
    return response
end
