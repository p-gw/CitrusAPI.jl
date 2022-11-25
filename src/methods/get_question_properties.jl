export get_question_properties

"""
    get_question_properties(client, question_id; settings=nothing, language=nothing)

Get the properties of a remote question by `question_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_get_question_properties>
"""
function get_question_properties(client::CitrusClient, question_id::Int; settings=nothing, language=nothing)
    payload = construct_payload("get_question_properties", [client.session_key, question_id, settings, language])
    response = call_limesurvey_api(client, payload)
    return response
end
