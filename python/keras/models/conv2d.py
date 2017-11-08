from keras.models import Sequential
from keras.layers import BatchNormalization, Conv2D, Dense, Dropout, Flatten, MaxPooling2D
from keras.regularizers import l2


def conv2d(num_of_window, coefficient_vector_size, degree_of_latent_factor):
    return Sequential([
        Conv2D(
            input_shape=(num_of_window, coefficient_vector_size, 1),
            activation='relu',
            filters=512,
            kernel_size=(4, 3),
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0001),
            bias_regularizer=l2(0.0001)
         ),
        MaxPooling2D(pool_size=(2, 2)),
        Dropout(0.1),
        BatchNormalization(),
        Conv2D(
            activation='relu',
            filters=256,
            kernel_size=(2, 2),
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0001),
            bias_regularizer=l2(0.0001)
        ),
        MaxPooling2D(pool_size=(2, 1)),
        Dense(16, activation='relu'),
        Flatten(),
        Dense(degree_of_latent_factor, activation='linear')
    ])
