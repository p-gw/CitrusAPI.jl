export copy_survey!

function copy_survey!(client::CitrusClient, survey_id::Int, new_name::AbstractString)
    payload = construct_payload("copy_survey", [client.session_key, survey_id, new_name])
    response = call_limesurvey_api(client, payload)
    return response
end
