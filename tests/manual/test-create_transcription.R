voice_sample_en <- system.file("extdata", "sample-en.m4a", package = "openai")
create_transcription(file = voice_sample_en, model = "whisper-1")
create_transcription(file = voice_sample_ua, model = "whisper-1", response_format = "srt")
create_transcription(file = voice_sample_ua, model = "whisper-1", response_format = "vtt")
create_transcription(file = voice_sample_ua, model = "whisper-1", response_format = "text")
create_transcription(file = voice_sample_ua, model = "whisper-1", response_format = "verbose_json")
create_transcription(file = voice_sample_ua, model = "whisper-1", response_format = "text", language = iso_languages["Swedish"])

