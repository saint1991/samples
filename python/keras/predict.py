import argparse
import numpy as np
from dataset import DataSet
from dataset import InputDataSets
from keras.models import load_model

_DS_SIZE = 79991


def main(args):

    model = load_model(args.model_file)

    mfcc_data = DataSet(args.mfcc_dir)
    input_paths = mfcc_data.list_files()

    generator = InputDataSets.create_generator(input_paths, 1)
    predict(model, generator, args.result)


def predict(model, generator, predict_out):

    results = model.predict_generator(generator=generator, steps=_DS_SIZE, verbose=1)

    with open(predict_out, 'w') as file:
        for result in results:
            file.write(to_csv(result))
            file.flush()


def to_csv(np_arr):
    return ','.join(np_arr.astype(np.str)) + "\n"

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--mfcc-dir', type=str, default='/mnt/gcs/song_vector_dataset/mfcc', dest='mfcc_dir')
    parser.add_argument('--model-file', type=str, dest='model_file')
    parser.add_argument('--result', type=str, dest='result')
    main(parser.parse_args())
