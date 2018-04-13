import threading
import time
import logging

from .exceptions import HELICSRuntimeError

logger = logging.getLogger(__name__)


class CheckStatusThread(threading.Thread):

    def __init__(self, process_list):
        threading.Thread.__init__(self)
        self._process_list = process_list
        self._status = {}

    def run(self):
        logger.info("Starting checks logger")
        for p in self._process_list:
            self._status[p.name] = 0
        has_failed = False
        while True:
            time.sleep(1)
            for p in self._process_list:
                logger.info("Checking on {}".format(p.name))
                if has_failed is True:
                    p.kill()
                if p.poll() is not None and p.returncode != 0:
                    self._status[p.name] = p.returncode
                    has_failed = True

            all_p = [p.poll() for p in self._process_list if p.poll() is not None]
            if len(all_p) == len(self._process_list):
                if all(p == 0 for p in all_p):
                    return 0
                else:
                    raise HELICSRuntimeError("Error has occurred")
            else:
                continue


