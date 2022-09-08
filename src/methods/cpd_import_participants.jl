export cpd_import_participants!

function cpd_import_participants!(client::CitrusClient, participants::AbstractArray; update::Bool=false)
    payload = construct_payload("cpd_importParticipants", [client.session_key, participants, update])
    response = call_limesurvey_api(client, payload)
    return response
end
