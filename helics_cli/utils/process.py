# -*- coding: utf-8 -*-
from multiprocessing import Process

from .message_handler import MessageHandler


class ProcessHandler:
    process_list: list
    output_list: list
    has_web: bool = False
    message_handler: MessageHandler
    use_broker_process: bool = False
    broker_process: Process = None
    web_process: Process = None

    def __init__(self, process_list, output_list, has_web, message_handler, use_broker_process):
        self.process_list = process_list
        self.output_list = output_list
        self.has_web = has_web
        self.message_handler = message_handler
        self.use_broker_process = use_broker_process

    def shutdown(self):
        print("in shutdown...")
        if self.use_broker_process and self.broker_process.is_alive():
            self.broker_process.terminate()
            # self.broker_process.kill()
            self.broker_process.close()

        print("shutdown broker")

        if self.has_web and self.web_process.is_alive():
            self.web_process.terminate()
            # self.web_process.kill()
            self.web_process.close()

        print("shutdown web")

    def run_broker(self, target, args, daemon=False):
        self.use_broker_process = True
        self.broker_process = Process(target=target, args=args, daemon=daemon)
        self.broker_process.start()

    def run_web(self, target, args, daemon=False):
        self.has_web = True
        self.web_process = Process(target=target, args=args, daemon=daemon)
        self.web_process.start()
