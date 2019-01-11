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
from google.cloud import firestore
from server import getEmotion
import signal
import sys
import time

db = firestore.Client()
# doc_ref = db.collection(u'emotion').document(u'2ZlyBDxOgmOMwP9RmtaUnb1tQ7q2')


def signal_handler(sig, frame):
        print('Exiting!')
        sys.exit(0)

def listener(doc_snapshot, changes, emo_time):
    print("Updating docs!")
    for doc in doc_snapshot:
        data = json.loads(json.dumps(doc.to_dict()))
        #print(data["photoUrl"])
        #print(getEmotion(data["photoUrl"]))
        emotion = getEmotion(data["photoUrl"])
        db.collection(u'users').document(u'{0}'.format(data['uid'])).set({u'emotion': emotion}, merge=True)
        print("Updated {0} with {1}".format(data['uid'], emotion))

emo_ref = db.collection(u'emotion')
emo_watch = emo_ref.on_snapshot(listener)

while True:
    signal.signal(signal.SIGINT, signal_handler)
    time.sleep(100)
