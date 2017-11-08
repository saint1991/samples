from keras.models import Sequential
from keras.layers import BatchNormalization, Dense, Dropout, Flatten
from keras.layers.convolutional import Conv1D
from keras.layers.recurrent import LSTM
from keras.layers.pooling import MaxPool1D
from keras.regularizers import l2


def conv_lstm(num_of_window, coefficient_vector_size, degree_of_latent_factor):
    return Sequential([
        Conv1D(
            input_shape=(num_of_window, coefficient_vector_size),
            filters=128,
            kernel_size=8,
            activation='relu',
            padding='causal',
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0002),
            bias_regularizer=l2(0.0002)
        ),
        MaxPool1D(),
        Dropout(rate=0.1),
        Conv1D(
            filters=64,
            kernel_size=2,
            strides=1,
            activation='relu',
            padding='causal',
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0002),
            bias_regularizer=l2(0.0002)
        ),
        MaxPool1D(),
        LSTM(
            units=16,
            activation='sigmoid',
            kernel_initializer='lecun_uniform',
            kernel_regularizer=l2(0.0002),
            activity_regularizer=l2(0.0002),
            return_sequences=True,
            implementation=2
        ),
        Dropout(rate=0.1),
        BatchNormalization(),
        Flatten(),
        Dense(units=degree_of_latent_factor, activation='linear')
    ])
