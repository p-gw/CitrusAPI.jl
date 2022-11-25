export remind_participants

"""
    remind_participants(client, survey_id; kwargs...)

Send reminders to participants of the remote survey with `survey_id`.

## Keyword arguments
- `min_days_between`: Number of days from last reminder (default: `nothing`)
- `max_reminders`: Maximum number of reminders
- `token_ids`: Ids of the participants to remind (default: false)

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_remind_participants>
"""
function remind_participants(client::CitrusClient, survey_id::Int; min_days_between::Union{Nothing,Int}=nothing, max_reminders::Union{Nothing,Int}=nothing, token_ids=false)
    payload = construct_payload("remind_participants", [client.session_key, survey_id, min_days_between, max_reminders, token_ids])
    response = call_limesurvey_api(client, payload)
    return response
end
