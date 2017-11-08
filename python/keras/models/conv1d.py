
from keras.models import Sequential
from keras.layers import BatchNormalization, Dense, Dropout, Flatten
from keras.layers.convolutional import Conv1D
from keras.layers.pooling import MaxPool1D
from keras.regularizers import l2


def conv1d(num_of_window, coefficient_vector_size, degree_of_latent_factor):
    return Sequential([
        Conv1D(
            input_shape=(num_of_window, coefficient_vector_size),
            filters=64,
            kernel_size=4,
            strides=1,
            activation='relu',
            padding='causal',
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0002),
            bias_regularizer=l2(0.0002)
        ),
        MaxPool1D(),
        Dropout(rate=0.1),
        BatchNormalization(),
        Conv1D(
            filters=32,
            kernel_size=2,
            activation='relu',
            padding='causal',
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0002),
            bias_regularizer=l2(0.0002)
        ),
        MaxPool1D(),
        Dense(
            units=16,
            activation='relu',
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0002),
            bias_regularizer=l2(0.0002)
        ),
        Flatten(),
        Dense(units=degree_of_latent_factor, activation='linear')
    ])
