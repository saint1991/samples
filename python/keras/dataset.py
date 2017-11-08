import os
import numpy as np
from sklearn.model_selection import train_test_split


class DataSet:

    def __init__(self, data_dir):
        self.dir = data_dir

    def list_files(self):
        return sorted(["{0}/{1}".format(self.dir, filename)
                       for filename in os.listdir(self.dir) if filename.endswith(".npz")])

    def shape(self):
        files = self.list_files()
        assert len(files) > 0, "file not found"
        with np.load(files[0]) as sample:
            ret = sample["arr_0"].shape
        return ret

    def train_test_files(self, test_ratio=0.25):
        return train_test_split(self.list_files(), test_size=test_ratio, random_state=0)


class InputTargetDataSets:

    @staticmethod
    def create_generator(input_paths, target_paths, batch_size, use_channel=False):
        """
        Create generator of (input, target) pairs.

        Note: this method assumes the result of `list_files` contains
              all corresponding file to another in the same order.
        """
        ret_inputs = []
        ret_targets = []

        while True:
            for input_path, target_path in zip(input_paths, target_paths):
                with np.load(input_path) as input_elements, np.load(target_path) as target_elements:
                    for input, target in zip(input_elements['arr_0'], target_elements['arr_0']):
                        x = input.T
                        y = target
                        if use_channel:
                            x = x.reshape(x.shape + (1,))
                        ret_inputs.append(x)
                        ret_targets.append(y)
                        if len(ret_inputs) >= batch_size:
                            yield (np.array(ret_inputs), np.array(ret_targets))
                            ret_inputs = []
                            ret_targets = []


class InputDataSets:

    @staticmethod
    def size(input_paths):
        size = 0
        for input_path in input_paths:
            with np.load(input_path) as file:
                size += file['arr_0'].shape[0]
        return size

    @staticmethod
    def create_generator(input_paths, batch_size, use_channel=False):
        """
        Create generator of input dataset
        """
        ret = []
        for input_path in input_paths:
            with np.load(input_path) as input_elements:
                for input in input_elements['arr_0']:
                    x = input.T
                    if use_channel:
                        x = x.reshape(x.shape + (1,))
                    ret.append(x)
                    if len(ret) >= batch_size:
                        yield np.array(ret)
                        ret = []
