from multiprocessing import Queue

class SimpleMessage:
    def __init__(self, message_type: str, message: str):
        self.Type = message_type
        self.Message = message

    def __str__(self):
        return f'{{"type": "{self.Type}", "message": "{self.Message}"}}'


# TODO: this message handler is very simple, and fully blocking. it is possible to implement this better
class MessageHandler:
    ToHelics: Queue
    FromHelics: Queue
    Enabled: bool

    def __init__(self, to_helics, from_helics, enabled):
        self.ToHelics = to_helics
        self.FromHelics = from_helics
        self.Enabled = enabled

    def set_enable(self, enable: bool):
        self.Enabled = enable

    def send_helics(self, message: SimpleMessage):
        self.ToHelics.put(message, True)

    def get_helics(self) -> SimpleMessage:
        return self.FromHelics.get(True, timeout=10)

    def send_server(self, message: SimpleMessage):
        self.FromHelics.put(message, True)

    def get_server(self) -> SimpleMessage:
        return self.ToHelics.get(True)
