# activate endpoints
include("methods/activate_survey.jl")
include("methods/activate_tokens.jl")

# add endpoints
include("methods/add_group.jl")
include("methods/add_language.jl")
include("methods/add_participants.jl")
include("methods/add_response.jl")
include("methods/add_survey.jl")

# copy endpoints
include("methods/copy_survey.jl")

# delete endpoints
include("methods/delete_group.jl")
include("methods/delete_language.jl")
include("methods/delete_participants.jl")
include("methods/delete_question.jl")
include("methods/delete_response.jl")
include("methods/delete_survey.jl")

# import endpoints
include("methods/cpd_import_participants.jl")
include("methods/import_group.jl")
include("methods/import_question.jl")
include("methods/import_survey.jl")

# export endpoints
include("methods/export_responses.jl")
include("methods/export_responses_by_token.jl")
include("methods/export_statistics.jl")
include("methods/export_timeline.jl")

# list endpoints
include("methods/list_groups.jl")
include("methods/list_participants.jl")
include("methods/list_questions.jl")
include("methods/list_survey_groups.jl")
include("methods/list_surveys.jl")
include("methods/list_users.jl")

# session key endpoints
include("methods/get_session_key.jl")
include("methods/release_session_key.jl")
