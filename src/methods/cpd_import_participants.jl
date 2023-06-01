export cpd_import_participants!

"""
    cpd_import_participants!(client, participants; update=false)

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_cpd_importParticipants>
"""
function cpd_import_participants!(
    client::CitrusClient,
    participants::AbstractArray;
    update::Bool = false,
)
    payload = construct_payload(
        "cpd_importParticipants",
        [client.session_key, participants, update],
    )
    response = call_limesurvey_api(client, payload)
    return response
end
