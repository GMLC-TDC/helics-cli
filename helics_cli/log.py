# -*- coding: utf-8 -*-
"""
Set up logging
"""
import logging


def setup_logger(level=logging.DEBUG):
    """Set up logging"""
    logging.basicConfig(
        format="%(asctime)s [%(filename)s:%(lineno)d] %(levelname)s: %(message)s",
        datefmt="%Y-%m-%d:%H:%M:%S",
        level=level,
    )
