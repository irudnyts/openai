voice_sample_ua <- system.file("extdata", "sample-ua.m4a", package = "openai")
create_translation(file = voice_sample_ua, model = "whisper-1")
