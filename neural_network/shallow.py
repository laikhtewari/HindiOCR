#import libraries
from keras.models import Sequential
from keras.layers import Conv2D
from keras.layers import MaxPooling2D
from keras.layers import Flatten
from keras.layers import Dense
from keras.preprocessing import image

#import dataset

#create model
model = Sequential()
model.add(Conv2D(filters=16, kernel_size=3, input_shape=(32,32,3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2,2)))
model.add(Flatten())
model.add(Dense(units=128, activation='relu'))
model.add(Dense(units=46, activation='sigmoid'))
model.compile(optimizer='SGD', loss='mean_squared_error', metrics=['accuracy'])

train_datagen = ImageDataGenerator(rescale=1./255, shear_range=0.2, zoom_range=0.2, horizontal_flip=True)
test_datagen = ImageDataGenerator(rescale = 1./255)
train_set = train_datagen.flow_from_directory('NepalDataset/Train', target_size=(32, 32),class_mode='categorical')
test_set = test_datagen.flow_from_directory('NepalDataset/Test', target_size=(32, 32), class_mode = 'categorical')

model.fit_generator(train_set, steps_per_epoch=8000, epochs=25, validation_data=test_set, validation_steps=2000)