export invite_participants

"""
    invite_participants(client, survey_id, token_ids; email=true)

Invite participants by `token_ids` in a remote survey with `survey_id`.
If `email == true` only pending invites are sent. Otherwise invites are resent.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_invite_participants>
"""
function invite_participants(
    client::CitrusClient,
    survey_id::Int,
    token_ids::Vector{Int};
    email::Bool = true,
)
    payload = construct_payload(
        "invite_participants",
        [client.session_key, survey_id, token_ids, email],
    )
    response = call_limesurvey_api(client, payload)
    return response
end
