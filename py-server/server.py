from keras.models import load_model
import numpy as np
from statistics import mode
import os
import cv2
import pandas as pd
from sklearn.externals import joblib
from flask_restful import reqparse, abort, Api, Resource
from flask import Flask, jsonify, request
from utils import preprocess_input
from firebase import firebase
import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
import datetime
import urllib
import urllib.request
import json

def getEmotion(img_url):

    urllib.request.urlretrieve(img_url, "face.jpg")

    detection_model_path = 'models/haarcascade_frontalface_default.xml'
    classification_model_path = 'models/simple_CNN.hdf5'
    emotion_labels = {0:'Angry',1:'Disgust',2:'Neutral',3:'Very Happy!',
                        4:'Sad',5:'Surprise',6:'Happy!'}

    face_detection = cv2.CascadeClassifier(detection_model_path)
    emotion_classifier = load_model(classification_model_path)

    img = cv2.imread('face.jpg')

    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    faces = face_detection.detectMultiScale(gray, 1.3, 5)

    emotion = "Happy!"

    for (x, y, w, h) in faces:
        face = gray[y:y + h, x:x + w]
        try:
            face = cv2.resize(face, (48, 48))
        except:
          continue
        face = np.expand_dims(face, 0)
        face = np.expand_dims(face, -1)
        face = preprocess_input(face)

        emotion_arg = np.argmax(emotion_classifier.predict(face))
        emotion = emotion_labels[emotion_arg]

    return emotion
