export get_session_key
export connect!

function get_session_key(client::Client, username::AbstractString, password::AbstractString; plugin="Authdb")
    payload = construct_payload("get_session_key", [username, password, plugin])
    response = call_limesurvey_api(client, payload, authenticated=false)
    return response
end

function connect!(client::Client, username::String, password::String; plugin="Authdb")
    response = get_session_key(client, username, password, plugin=plugin)
    if !(response.result isa String)
        error("Failed to connect. Error: $(response.result.status)")
    end
    client.session_key = response.result
    @info "Connected to server '$(client.url)'\n\tSession key: $(client.session_key)"
    return nothing
end
