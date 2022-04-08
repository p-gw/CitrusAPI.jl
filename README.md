# LimeSurvey

[![Build Status](https://github.com/p-gw/LimeSurvey.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/p-gw/LimeSurvey.jl/actions/workflows/CI.yml?query=branch%3Amain)

This Julia package provides a thin wrapper for the [LimeSurvey API](https://manual.limesurvey.org/RemoteControl_2_API). For a list of methods see https://api.limesurvey.org/classes/remotecontrol_handle.html.

Note that this package uses a more "julian" syntax for API methods. Methods that mutate data by either adding, deleting or modifying data are implemented as [bang functions](https://docs.julialang.org/en/v1/manual/style-guide/#bang-convention). For example the API method `add_survey` is implemented as the `add_survey!` function in `LimeSurvey.jl`.  

## Getting started
If your LimeSurvey server is set up correctly you can start by setting up a `LimeSurveyClient` and connecting to the server. 

```julia
client = LimeSurveyClient("https://your-limesurvey-server.com/index.php/admin/remotecontrol")
connect!(client, "username", "password")
```

Once the connection is established you can execute your desired API methods, e.g. getting a list of all surveys, 

```julia
surveys = list_surveys(client)
```

Close the session by disconnecting from the server.

```julia
disconnect!(client)
```
