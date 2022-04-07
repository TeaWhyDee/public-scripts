#!/usr/bin/python3

import sys
import speech_recognition as sr
import os
r = sr.Recognizer()

lan=os.getenv('STT_LAN')
if (lan == None):
    lan = "en-US"

filename = sys.argv[1]

with sr.AudioFile(filename) as source:
    r.adjust_for_ambient_noise(source)
    audio = r.record(source)
    text="Couldn't run Speech to text."
    try:
        text = r.recognize_google(audio, language=lan)
        # text = r.recognize_sphinx(audio)
    except sr.UnknownValueError:
        print("Couldn't recognize speech.")
    print(text)
