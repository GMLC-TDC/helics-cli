# -*- coding: utf-8 -*-
import os
import shutil

from ...utils import echo
from ... import utils


class BaseConfig(object):
    def __init__(self, config):

        self.config = config
        self.runner = []

        self.setup()
        self.run()

    @classmethod
    def _copy_and_overwrite(self, from_path, to_path, ignore=utils._ignore):
        utils.copy_and_overwrite(from_path, to_path, ignore)

    @classmethod
    def _mkdir(self, directory):
        utils.mkdir(directory)

    def setup(self):

        raise NotImplementedError("Subclass to implement")

    def run(self):

        raise NotImplementedError("Subclass to implement")
