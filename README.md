# CitrusAPI

[![Build Status](https://github.com/p-gw/CitrusAPI.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/p-gw/CitrusAPI.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/p-gw/CitrusAPI.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/p-gw/CitrusAPI.jl)

This Julia package provides a thin wrapper for the [LimeSurvey API](https://manual.limesurvey.org/RemoteControl_2_API). For a list of methods see https://api.limesurvey.org/classes/remotecontrol_handle.html.

Note that this package uses a more "julian" syntax for API methods. Methods that mutate data by either adding, deleting or modifying data are implemented as [bang functions](https://docs.julialang.org/en/v1/manual/style-guide/#bang-convention). For example the API method `add_survey` is implemented as the `add_survey!` function in `CitrusAPI.jl`.  

## Getting started
If your LimeSurvey server is set up correctly you can start by setting up a `CitrusClient` and connecting to the server. 

```julia
client = CitrusClient("https://your-limesurvey-server.com/index.php/admin/remotecontrol")
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

## Available methods
- `activate_survey!`
- `activate_tokens!`
- `add_group!`
- `add_language!`
- `add_participants!`
- `add_response!`
- `add_survey!`
- `copy_survey!`
- `cpd_import_participants!`
- `delete_group!`
- `delete_language!`
- `delete_participants!`
- `delete_question!`
- `delete_response!`
- `delete_survey!`
- `export_responses_by_token`
- `export_responses`
- `export_statistics`
- `export_timeline`
- `get_group_properties`
- `get_language_properties`
- `get_participant_properties`
- `get_question_properties`
- `get_response_ids`
- `get_session_key`
- `get_site_settings`
- `get_summary`
- `get_survey_properties`
- `get_uploaded_files`
- `import_group!`
- `import_question!`
- `import_survey!`
- `invite_participants`
- `list_groups`
- `list_participants`
- `list_questions`
- `list_survey_groups`
- `list_surveys`
- `list_users`
- `mail_registered_participants`
- `release_session_key`
- `set_group_properties!`
- `set_language_properties!`
- `set_participant_properties!`
- `set_question_properties!`
- `set_quota_properties!`
- `set_survey_properties!`
- `updade_response!`
- `upload_file!`

## Convenience functions
- `connect!`
- `disconnect!`
- `expire_survey!`
- `is_active`