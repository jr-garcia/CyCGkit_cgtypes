import unittest
import importlib


def skip_if_package_missing(package_name):
    """
    Decorator to skip all tests in a class if a specific package is not installed

    :param package_name: Name of the package to check
    :return: Test class decorator
    """
    try:
        importlib.import_module(package_name)
        return lambda cls: cls
    except ImportError:
        return unittest.skip(f"{package_name} not installed")