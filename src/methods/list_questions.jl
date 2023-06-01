export list_questions

"""
    list_questions(client, survey_id, group_id=nothing; language=nothing)

List questions for the remote survey with `survey_id`.
Optionally only list only questions for question group with `group_id` and/or survey `language`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_list_questions>
"""
function list_questions(
    client::CitrusClient,
    survey_id::Int,
    group_id::Union{Nothing,Int} = nothing;
    language::Union{Nothing,String} = nothing,
)
    payload = construct_payload(
        "list_questions",
        [client.session_key, survey_id, group_id, language],
    )
    response = call_limesurvey_api(client, payload)
    return response
end
