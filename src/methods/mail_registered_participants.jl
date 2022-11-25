export mail_registered_participants, mail_registered_participant

"""
    mail_registered_participants(client, survey_id)

Send register emails for a remote survey with `survey_id` to all not invited, not reminded, not completed participants.
Overwrite this behaviour by specifying `override_all_conditions`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_mail_registered_participants>
"""
function mail_registered_participants(client::CitrusClient, survey_id::Int; override_all_conditions=nothing)
    payload = construct_payload("mail_registered_participants", [client.session_key, survey_id, override_all_conditions])
    response = call_limesurvey_api(client, payload)
    return response
end

"""
    mail_registered_participant(client, survey_id, token_id)

Send a register email for a remote survey with `survey_id` to a single participant with `token_id`.
"""
# TODO: check if this works
function mail_registered_participant(client, survey_id, token_id::Int)
    opts = Dict("tid" => token_id)
    response = mail_registered_participants(client, survey_id, override_all_conditions=opts)
    return response
end
