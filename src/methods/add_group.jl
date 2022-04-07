export add_group!

function add_group!(client::Client, survey_id::Int, title::AbstractString; description::AbstractString="")
    payload = construct_payload("add_group", [client.session_key, survey_id, title, description])
    response = call_limesurvey_api(client, payload)
    return response
end

function add_group!(client, survey_id, title, sink; description)
    response = add_group!(client, survey_id, title; description)
    return response.result |> sink
end
