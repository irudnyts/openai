voice_sample_en <- system.file("extdata", "sample-en.m4a", package = "openai")
create_transcription(file = voice_sample_en, model = "whisper-1")
