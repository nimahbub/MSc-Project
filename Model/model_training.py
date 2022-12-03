from keras.layers import Input, Lambda, Dense, Flatten
from keras.models import Model
from keras.preprocessing import image
from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Conv2D, MaxPooling2D, Dense, Flatten
import tensorflow as tf
import numpy as np
from glob import glob
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import seaborn as sns
from sklearn.metrics import classification_report, accuracy_score



# Set the path for training dataset and validation dataset
train_path = "training dataset path"
valid_path = "validation dataset path"

# useful for getting number of classes
folders = glob("train dataset path/*")




# making training and validation image generator
train_datagen = ImageDataGenerator(rescale = 1./255,
                                   rotation_range=0,
                                   vertical_flip=False,
                                   horizontal_flip = True)

validation_datagen = ImageDataGenerator(rescale = 1./255)

training_set = train_datagen.flow_from_directory('training dataset path',
                                                 target_size = (224, 224),
                                                 batch_size = 32,
                                                 class_mode = 'categorical')

val_set = validation_datagen.flow_from_directory('validation dataset path',
                                            target_size = (224, 224),
                                            batch_size = 32,
                                            class_mode = 'categorical')







# Model structure
model = Sequential()
model.add(Conv2D(32, kernel_size = (3,3), activation='relu', input_shape=IMAGE_SIZE + [3]))
model.add(MaxPooling2D(2,2))
model.add(Conv2D(64, kernel_size = (3,3), activation='relu'))
model.add(MaxPooling2D(2,2))
model.add(Conv2D(64, kernel_size = (3,3), activation='relu'))
model.add(MaxPooling2D(2,2))
model.add(Conv2D(64, kernel_size = (3,3), activation='relu'))
model.add(MaxPooling2D(2,2))
model.add(Conv2D(64, kernel_size = (3,3), activation='relu'))
model.add(MaxPooling2D(2,2))
model.add(Conv2D(64, kernel_size = (3,3), activation='relu'))
model.add(MaxPooling2D(2,2))
model.add(Flatten())
model.add(Dense(64, activation = 'relu'))
model.add(Dense(len(folders), activation = 'softmax'))
print(model.summary()) 


#initializing model loss, optimizer and metrics
model.compile(
  loss='categorical_crossentropy',
  optimizer='adam',
  metrics=['accuracy']
)




# Model training for 50 epochs
r = model.fit_generator(
  training_set,
  validation_data=val_set,
  epochs=50,
  steps_per_epoch=len(training_set),
  validation_steps=len(val_set)
)



# save the model
model.save("model.h5")

