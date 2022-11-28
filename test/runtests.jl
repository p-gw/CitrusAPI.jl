using CitrusAPI
using Test

using Base64
using CSV
using DataFrames
using JSON3

function dataframe_to_base64csv(df::DataFrame)
    io = IOBuffer()
    CSV.write(io, df)
    df_encoded = io.data[io.data.!=0x00] |> String |> base64encode
    return df_encoded
end

@testset "CitrusAPI.jl" begin
    @testset "utils.jl" begin
        @test CitrusAPI.filename("test.csv") == "test.csv"
        @test CitrusAPI.filename("./test.csv") == "test.csv"
        @test CitrusAPI.filename("C:/Program Files/test.csv") == "test.csv"

        @test CitrusAPI.fileextension("test.csv") == "csv"
        @test CitrusAPI.fileextension("test.1.csv") == "csv"
        @test CitrusAPI.fileextension("test_1.csv") == "csv"
        @test CitrusAPI.fileextension("./test.csv") == "csv"
        @test CitrusAPI.fileextension("./test.1.csv") == "csv"
        @test CitrusAPI.fileextension("C:/Program Files/test.csv") == "csv"

        encoded = base64encode("Teststring")
        @test CitrusAPI.base64_to_string(encoded) == "Teststring"

        df = DataFrame(a=1:3, b=["a", "b", "c"])
        df_encoded = dataframe_to_base64csv(df)
        @test CitrusAPI.base64csv_to_sink(df_encoded, DataFrame) == df
    end

    @testset "CitrusClient" begin
        url = "https://www.test.co"
        c = CitrusClient(url)
        @test c.url == url
        @test isnothing(c.session_key)
    end

    @testset "API Payloads" begin
        headers = CitrusAPI.construct_headers()
        @test headers isa Dict
        @test headers["Content-type"] == "application/json"

        payload = CitrusAPI.construct_payload("test_method", [1, "a", []])
        @test payload isa String

        payload_obj = JSON3.read(payload)
        @test payload_obj.method == "test_method"
        @test payload_obj.id isa String
        @test payload_obj.params == [1, "a", []]
    end

    @testset "API Methods" begin
        c = CitrusClient("http://127.0.0.1:8082/index.php/admin/remotecontrol")

        @testset "Connection" begin
            @test_throws LimeSurveyError("Invalid user name or password") get_session_key(c, "", "")
            @test_throws LimeSurveyError("Invalid user name or password") connect!(c, "", "")

            @test_throws AuthenticationError release_session_key(c)
            @test_throws AuthenticationError disconnect!(c)

            session_key = connect!(c, "admin", "password")
            @test session_key == c.session_key
            @test disconnect!(c) == "OK"
        end

        connect!(c, "admin", "password")

        @testset "Surveys" begin
            @test_throws LimeSurveyError("No surveys found") list_surveys(c)

            # add some basic surveys
            s1 = add_survey!(c, 123456, "testsurvey-1", "en")
            s2 = add_survey!(c, 111111, "testsurvey-2", "en")
            s3 = add_survey!(c, 222222, "testsurvey-3", "en")

            @test s1 == 123456
            @test s2 == 111111
            @test s3 == 222222

            # surveys require valid languages
            @test_throws LimeSurveyError("Faulty parameters") add_survey!(c, 999999, "testsurvey-4", "invalid language")

            # duplicate survey ids lead to randomized survey ids
            s5 = add_survey!(c, 123456, "testsurvey-5", "en")
            @test s5 != 123456

            # list surveys
            surveys = list_surveys(c)
            @test length(surveys) == 4

            # list surveys (DataFrame sink)
            surveys = list_surveys(c, DataFrame)
            @test surveys isa DataFrame
            @test nrow(surveys) == 4
            @test names(surveys) == ["sid", "surveyls_title", "startdate", "expires", "active"]

            # import surveys
            s6 = import_survey!(c, "limesurvey/813998.lss")
            @test s6 == 813998

            # activate surveys
            @test_throws LimeSurveyError("Invalid survey ID") activate_survey!(c, 100000)
            @test_throws LimeSurveyError("Invalid survey ID") is_active(c, 100000)

            @test_throws LimeSurveyError("Survey does not pass consistency check") activate_survey!(c, s1)
            @test is_active(c, s1) == false

            res = activate_survey!(c, s6)  # s6 contains questions and should be ready to activate
            @test res.status == "OK"
            @test is_active(c, s6) == true

            # copying surves
            res = copy_survey!(c, s6, "survey copy")
            s7 = res.newsid
            @test res.status == "OK"
            @test s7 != s6

            # deleting surveys
            surveys = list_surveys(c, DataFrame)
            @test nrow(surveys) == 6
            @test surveys.sid == string.([s1, s2, s3, s5, s6, s7])
            res = delete_survey!(c, s7)
            @test res.status == "OK"

            surveys = list_surveys(c, DataFrame)
            @test nrow(surveys) == 5
            @test surveys.sid == string.([s1, s2, s3, s5, s6])

            # get survey properties
            s6_props = get_survey_properties(c, s6)
            @test s6_props.sid == string(s6)
            @test s6_props.anonymized == "N"

            # set survey properties
            new_props = set_survey_properties!(c, s6, Dict("anonymized" => "Y"))
            @test new_props.anonymized == true

            s6_new_props = get_survey_properties(c, s6)
            @test s6_new_props.anonymized == "Y"
        end

        @testset "Groups" begin
            s1 = 123456
            s2 = 111111
            s6 = 813998

            # add question groups
            g1 = add_group!(c, s1, "first group")
            g2 = add_group!(c, s1, "second group", description="description")

            # s6 already imports 4 question groups
            @test g1 == 5
            @test g2 == 6

            # list groups (basic)
            groups = list_groups(c, s1)
            @test length(groups) == 2

            group1 = groups[1]
            @test group1.group_name == "first group"
            @test group2.description == ""

            group2 = groups[2]
            @test group2.group_name == "second group"
            @test group2.description == "description"

            @test_throws LimeSurveyError("No groups found") list_groups(c, s2)

            # list groups (DataFrame sink)
            groups = list_groups(c, s1, DataFrame)
            @test nrow(groups) == 2

            @test groups[1, :group_name] == "first group"
            @test groups[2, :group_name] == "second group"
            @test groups[1, :description] == ""
            @test groups[2, :description] == "description"

            s6_groups = list_groups(c, s6)
            @test length(s6_groups) == 2
            @test s6_groups[1].group_name == "test group"
            @test s6_groups[1].description == "some description"
            @test s6_groups[2].group_name == "test group 2"
            @test s6_groups[2].description == "."
        end

        @testset "Questions" begin
            s6 = 813998

            # list questions
            qs = list_questions(c, s6)
            @test length(qs) == 2
            @test qs[1].question == "Make a long statement!"
            @test qs[1].help == "need help?"
            @test qs[2].question == "Rate on a scale from 1 to 5!"
            @test qs[2].help == "need help?"

            gid = parse(Int, last(s6_groups).gid)
            qg2 = list_questions(c, s6, gid)
            @test length(qg2) == 1
            @test qg2[1].question == qs[2].question
        end

        # activate_tokens
        # add_language
        # add_participants
        # add_response
        # delete_group
        # delete_language
        # delete_participants
        # delete_question
        # delete_response
        # cpd_import_participants
        # import_group
        # import_question
        # invite_participants
        # mail_registered_participants
        # remind_participants
        # export_responses
        # export_responses_by_token
        # export_statistics
        # export_timeline
        # list_participants
        # list_survey_groups
        # list_users
        # get_group_properties
        # get_language_properties
        # get_participant_properties
        # get_question_properties
        # get_response_ids
        # get_site_settings
        # get_summary
        # get_uploaded_files
        # set_group_properties
        # set_language_properties
        # set_participant_properties
        # set_question_properties
        # set_quota_properties
        # update_response
        # upload_file
    end
end
