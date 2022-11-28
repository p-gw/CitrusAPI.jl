export list_groups

"""
    list_groups(client, survey_id; language=nothing)
    list_groups(client, survey_id, sink; language=nothing)

List all question groups of the remote survey with `survey_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_list_groups>
"""
function list_groups(client::CitrusClient, survey_id::Int; language::Union{String,Nothing}=nothing)
    payload = construct_payload("list_groups", [client.session_key, survey_id, language])
    response = call_limesurvey_api(client, payload)
    return response
end

function list_groups(client, survey_id, sink; language::Union{String,Nothing}=nothing)
    response = list_groups(client, survey_id; language)
    return response |> sink
end
