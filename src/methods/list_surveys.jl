export list_surveys

function list_surveys(client::LimeSurveyClient; username::Union{AbstractString,Nothing}=nothing)
    payload = construct_payload("list_surveys", [client.session_key, username])
    response = call_limesurvey_api(client, payload)
    return response
end

function list_surveys(client::LimeSurveyClient, sink; username=nothing)
    response = list_surveys(client, username=username)
    return response.result |> sink
end
