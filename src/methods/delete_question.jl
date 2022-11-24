export delete_question!

"""
    delete_question!(client, question_id)

Delete a remote question by `question_id`.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_delete_question>
"""
function delete_question!(client::CitrusClient, question_id::Int)
    payload = construct_payload("delete_question", [client.session_key, question_id])
    response = call_limesurvey_api(client, payload)
    return response
end
