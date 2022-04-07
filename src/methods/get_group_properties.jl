export get_group_properties

function get_group_properties(client::Client, group_id::Int; settings::Union{Nothing,AbstractArray}=nothing, language::Union{Nothing,String}=nothing)
    payload = construct_payload("get_group_properties", [client.session_key, group_id, settings, language])
    response = call_limesurvey_api(client, payload)
    return response
end
