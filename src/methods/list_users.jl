export list_users

"""
    list_users(client; user_id=nothing, username=nothing)
    list_users(client, sink; kwargs...)

Return a list of administration users for a LimeSurvey instance.

See also: <https://api.limesurvey.org/classes/remotecontrol_handle.html#method_list_users>
"""
function list_users(
    client::CitrusClient;
    user_id::Union{Nothing,Int} = nothing,
    username::Union{Nothing,String} = nothing,
)
    payload = construct_payload("list_users", [client.session_key, user_id, username])
    response = call_limesurvey_api(client, payload)
    return response
end

function list_users(client, sink; kwargs...)
    response = list_users(client; kwargs...)
    return response |> sink
end
