import argparse
import json
import time
from dataset import DataSet
from dataset import InputTargetDataSets
from models.feedforward import feed_forward
from models.conv1d import conv1d
from models.conv2d import conv2d
from models.conv_lstm import conv_lstm
from keras.callbacks import EarlyStopping
from keras import optimizers


# Change here according to your environment
_GPU_COUNT = 2
_DATASET_SIZE = 79991


def main(args):

    # here can be replaced with argparse
    steps_per_epoch = _DATASET_SIZE / args.batch_size

    mfcc_data = DataSet(args.mfcc_dir)
    label_data = DataSet(args.label_dir)

    _, coefficient_vector_size, num_of_window = mfcc_data.shape()
    _, degree_of_latent_factor = label_data.shape()

    use_channel = False
    if args.model == 'conv1d':
        model = conv1d(num_of_window, coefficient_vector_size, degree_of_latent_factor)
    elif args.model == 'conv2d':
        use_channel = True
        model = conv2d(num_of_window, coefficient_vector_size, degree_of_latent_factor)
    elif args.model == 'conv1d_lstm':
        model = conv_lstm(num_of_window, coefficient_vector_size, degree_of_latent_factor)
    else:
        model = feed_forward(num_of_window, coefficient_vector_size, degree_of_latent_factor)

    trained_model, history = train(model, mfcc_data, label_data, use_channel, args.test_ratio,  args.batch_size, steps_per_epoch, args.epochs)
    export(args.result, trained_model, history)


def train(model, mfcc_data, label_data, use_channel, test_ratio, batch_size, steps_per_epoch, epochs):

    model.compile(optimizer=optimizers.Adagrad(), loss='mean_squared_error', metrics=['mae'])

    train_mfcc_paths, test_mfcc_paths = mfcc_data.train_test_files(test_ratio)
    train_label_paths, test_label_paths = label_data.train_test_files(test_ratio)

    trainset = InputTargetDataSets.create_generator(train_mfcc_paths, train_label_paths, batch_size, use_channel)
    testset = InputTargetDataSets.create_generator(test_mfcc_paths, test_label_paths, batch_size, use_channel)

    start_time = time.time()

    history = model.fit_generator(
        generator=trainset,
        steps_per_epoch=steps_per_epoch * (1 - test_ratio),
        epochs=epochs,
        verbose=1,
        callbacks=[
            EarlyStopping('val_loss', min_delta=0.0005, patience=70, verbose=1)
        ],
        validation_data=testset,
        validation_steps=steps_per_epoch * test_ratio
    )

    end_time = time.time()
    elapsed_time = end_time - start_time

    with open("./time.txt", 'w') as time_file:
        time_file.write("{0} sec".format(elapsed_time))

    return model, history.history


def export(export_to, model, history):
    model_out = "{0}.h5".format(export_to)
    model_weight_out = "{0}_weight.h5".format(export_to)
    history_out = "{0}_history.json".format(export_to)
    model.save(model_out)
    model.save_weights(model_weight_out,)
    with open(history_out, 'w') as f:
        json.dump(history, f)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--model', type=str, choices=['conv1d', 'conv2d', 'conv1d_lstm', 'feed_forward'], dest='model', default='feed_forward')
    parser.add_argument('--mfcc-dir', type=str, default='/mnt/gcs/song_vector_dataset/mfcc', dest='mfcc_dir')
    parser.add_argument('--label-dir', type=str, default='/mnt/gcs/song_vector_dataset/label', dest='label_dir')
    parser.add_argument('--batch-size', type=int, default=64, dest='batch_size')
    parser.add_argument('--epochs', type=int, default=50, dest='epochs')
    parser.add_argument('--test-ratio', type=float, default=0.15, dest='test_ratio')
    parser.add_argument('--result', type=str, default='./model', dest='result')
    main(parser.parse_args())
