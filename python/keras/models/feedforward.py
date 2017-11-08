from keras.models import Sequential
from keras.layers import BatchNormalization, Dense, Dropout, Flatten
from keras.regularizers import l2


def feed_forward(num_of_window, coefficient_vector_size, degree_of_latent_factor):
    return Sequential([
        Dense(
            units=64,
            input_shape=(num_of_window, coefficient_vector_size),
            activation='relu',
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0002),
            bias_regularizer=l2(0.0002)
        ),
        Dropout(rate=0.1),
        BatchNormalization(),
        Dense(
            units=32,
            input_shape=(num_of_window, coefficient_vector_size),
            activation='relu',
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0002),
            bias_regularizer=l2(0.0002)
        ),
        Dropout(rate=0.1),
        BatchNormalization(),
        Dense(
            units=24,
            activation='relu',
            kernel_initializer='lecun_normal',
            kernel_regularizer=l2(0.0002),
            bias_regularizer=l2(0.0002)
        ),
        Dropout(rate=0.1),
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
