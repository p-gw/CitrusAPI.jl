export delete_question!

function delete_question!(client::LimeSurveyClient, question_id::Int)
    payload = construct_payload("delete_question", [client.session_key, question_id])
    response = call_limesurvey_api(client, payload)
    return response
end
