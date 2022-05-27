using LimeSurveyAPI
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

@testset "LimeSurveyAPI.jl" begin
    @testset "utils.jl" begin
        @test LimeSurveyAPI.filename("test.csv") == "test.csv"
        @test LimeSurveyAPI.filename("./test.csv") == "test.csv"
        @test LimeSurveyAPI.filename("C:/Program Files/test.csv") == "test.csv"

        @test LimeSurveyAPI.fileextension("test.csv") == "csv"
        @test LimeSurveyAPI.fileextension("test.1.csv") == "csv"
        @test LimeSurveyAPI.fileextension("test_1.csv") == "csv"
        @test LimeSurveyAPI.fileextension("./test.csv") == "csv"
        @test LimeSurveyAPI.fileextension("./test.1.csv") == "csv"
        @test LimeSurveyAPI.fileextension("C:/Program Files/test.csv") == "csv"

        encoded = base64encode("Teststring")
        @test LimeSurveyAPI.base64_to_string(encoded) == "Teststring"

        df = DataFrame(a=1:3, b=["a", "b", "c"])
        df_encoded = dataframe_to_base64csv(df)
        @test LimeSurveyAPI.base64csv_to_sink(df_encoded, DataFrame) == df
    end

    @testset "Client" begin
        url = "https://www.test.co"
        c = LimeSurveyClient(url)
        @test c.url == url
        @test isnothing(c.session_key)
    end

    @testset "payloads" begin
        headers = LimeSurveyAPI.construct_headers()
        @test headers isa Dict
        @test headers["Content-type"] == "application/json"

        payload = LimeSurveyAPI.construct_payload("test_method", [1, "a", []])
        @test payload isa String

        payload_obj = JSON3.read(payload)
        @test payload_obj.method == "test_method"
        @test payload_obj.id isa String
        @test payload_obj.params == [1, "a", []]
    end

    @testset "Integration tests" begin
        c = LimeSurveyClient("http://127.0.0.1:8082/index.php/admin/remotecontrol")
        connect!(c, "admin", "password")

        initial_surveys = list_surveys(c)
        @test initial_surveys.result[:status] == "No surveys found"
    end
end
