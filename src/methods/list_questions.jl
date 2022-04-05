export list_questions

function list_questions(client::Client, survey_id::Int, group_id::Union{Nothing,Int}=nothing; language::Union{Nothing,String}=nothing)
    payload = construct_payload("list_questions", [client.session_key, survey_id, group_id, language])
    response = call_limesurvey_api(client, payload)
    return response
end
