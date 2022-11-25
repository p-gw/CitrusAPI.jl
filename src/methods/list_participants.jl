export list_participants

"""
    list_participants(client, survey_id, start; kwargs...)

Return a list of participants for the remote survey with `survey_id`.
A start ID (`start`) must be specified.

## Keyword arguments
- `limit`: Number of participants to return (default: `10`)
- `unused`: Return unused tokens (default: `false`)
- `attributes`: A list of attributes to return (default: `false`)
- `conditions`: A list of conditions to filter the returned list (default: `[]`)

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_list_participants>
"""
function list_participants(client::CitrusClient, survey_id::Int, start::Int; limit::Int=10, unused::Bool=false, attributes=false, conditions=[])
    payload = construct_payload("list_participants", [client.session_key, survey_id, start, limit, unused, attributes, conditions])
    response = call_limesurvey_api(client, payload)
    return response
end
