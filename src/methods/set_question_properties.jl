export set_question_properties!

"""
    set_question_properties!(client, question_id, data; language=nothing)

Set the properties of the question with `question_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_set_question_properties>
"""
function set_question_properties!(client::CitrusClient, question_id::Int, data; language=nothing)
    payload = construct_payload("set_question_properties", [client.session_key, question_id, data, language])
    response = call_limesurvey_api(client, payload)
    return response
end
