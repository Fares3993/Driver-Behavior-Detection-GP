import numpy as np
from werkzeug.utils import secure_filename
import werkzeug
from flask import Flask, request, jsonify
import tensorflow as tf
import cv2

app = Flask(__name__)
Results = ""
MODEL_PATH1 = 'D:/Study/Semester 8/GP/Models/Driver Behaviour_VGG16(98%).h5'
MODEL_PATH2 = 'D:/Study/Semester 8/GP/Models/Seatbelt_VGG16(99999.5).h5'
MODEL_PATH3 = 'D:/Study/Semester 8/GP/Models/Mobile_Net_Model.h5'
model1 = tf.keras.models.load_model(MODEL_PATH1, compile=False)
model1.compile(loss="categorical_crossentropy",
               optimizer="adam", metrics=["accuracy"])
model2 = tf.keras.models.load_model(MODEL_PATH2, compile=False)
model2.compile(loss="categorical_crossentropy",
               optimizer="adam", metrics=["accuracy"])
model3 = tf.keras.models.load_model(MODEL_PATH3, compile=False)
model3.compile(loss="categorical_crossentropy",
               optimizer="adam", metrics=["accuracy"])

@app.route('/upload', methods=["POST"])
def upload():
    if (request.method == "POST"):
        imagefile = request.files['image']
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        imagefile.save("D:/Study/Semester 8/GP/uploadedimages/" + filename)
        img2 = cv2.imread("D:/Study/Semester 8/GP/uploadedimages/" + filename)
        #################################################################################################
        final_image1 = cv2.resize(img2, (256, 256))
        final_image1 = np.expand_dims(final_image1, axis=0)  ##need fourth dimension
        final_image1 = final_image1 / 255.0
        ######################## until model 2 #############################
        ######################## model 1 ###################################
        max_prop1 = np.argmax(model1.predict(final_image1), axis=1)
        print("max_prop1 = " + str(max_prop1))
        my_list1 = ["Not Distracted", "texting", "talking on the phone", "texting",
                    "talking on the phone",
                    "operating the radio", "drinking", "reaching behind", "hair & makeup", "talking to passenger"]
        x = int(max_prop1)
        print(my_list1[x])
        Results = my_list1[x] + "/"
        ######################## model 2 ###################################
        max_prop2 = np.argmax(model2.predict(final_image1), axis=1)
        print("max_prop2 = " + str(max_prop2))
        my_list2 = ["Seat belt", "without seat belt"]
        x = int(max_prop2)
        print(my_list2[x])
        Results += my_list2[x] + "/"
        ######################## model 3 ###################################
        final_image2 = cv2.resize(img2, (224, 224))
        final_image2 = np.expand_dims(final_image2, axis=0)  ##need fourth dimension
        final_image2 = final_image2 / 255.0
        max_prop3 = np.argmax(model3.predict(final_image2), axis=1)
        print("max_prop3 = " + str(max_prop3))

        my_list3 = ["Closed eye","Drowsy","Not Drowsy","Open eye"]
        x = int(max_prop3)
        print(my_list3[x])
        Results += my_list3[x]
        # ##################### cropped Image ###############################
        # plt.imshow(cv2.cvtColor(img2, cv2.COLOR_BGR2RGB))
        # faceCascade =cv2.CascadeClassifier(cv2.data.haarcascades +'haarcascade_frontalface_default.xml')
        # eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_righteye_2splits.xml')
        # gray = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)
        # eyes = eye_cascade.detectMultiScale(gray, 1.1, 4)
        # for (x, y, w, h) in eyes:
        #     cv2.rectangle(img2, (x, y), (x + w, y + h), (0, 255, 0), 2)
        #
        # plt.imshow(cv2.cvtColor(img2, cv2.COLOR_BGR2RGB))
        # eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_righteye_2splits.xml')
        # gray = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)
        # # print(facecascade.empty())
        # eyes = eye_cascade.detectMultiScale(gray, 1.1, 4)
        # for x, y, w, h in eyes:
        #     roi_gray = gray[y:y + h, x:x + w]
        #     roi_color = img2[y:y + h, x:x + w]
        #     eyess = eye_cascade.detectMultiScale(roi_gray)
        #     if len(eyess) == 0:
        #         print("eyes are not detected")
        #         #eyes_roi = img2
        #     else:
        #         for (ex, ey, ew, eh) in eyess:
        #             eyes_roi = roi_color[ey: ey + eh, ex:ex + ew]
        #         plt.imshow(cv2.cvtColor(eyes_roi,cv2.COLOR_BGR2RGB))
        # eyeDetection = cv2.resize(eyes_roi, (224, 224))
        # eyeDetection = np.expand_dims(eyeDetection, axis=0)  ##need fourth dimension
        # eyeDetection = eyeDetection / 255.0
        # max_prop4 = np.argmax(model3.predict(eyeDetection), axis=1)
        # print("max_prop4 = " + str(max_prop4))
        return jsonify({
            "message": Results
        })
if __name__ == "__main__":
    app.run(debug=True, port=4000)
