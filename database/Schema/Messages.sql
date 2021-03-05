CREATE TABLE Messages
(
    sender       VARCHAR,
    destination  VARCHAR,
    send_time    DECIMAL,
    receive_time DECIMAL,
    value        TEXT,
    new_value    BOOLEAN DEFAULT FALSE
)