insert into Messages
--     sender       VARCHAR,
--     destination  VARCHAR,
--     send_time    DECIMAL,
--     receive_time DECIMAL,
--     value        TEXT,
--     new_value    BOOLEAN DEFAULT FALSE
values
       ('sender_1', 'dest_1', 1.1, 2.1, '{"message": "fake json message 1"}', 1),
       ('sender_2', 'dest_2', 1.2, 2.2, '{"message": "fake json message 2"}', 1),
       ('sender_3', 'dest_3', 1.3, 2.3, '{"message": "fake json message 3"}', 0),
       ('sender_4', 'dest_4', 1.4, 2.4, '{"message": "fake json message 4"}', 0),
       ('sender_5', 'dest_5', 1.5, 2.5, '{"message": "fake json message 5"}', 0),
       ('sender_6', 'dest_6', 1.6, 2.6, '{"message": "fake json message 6"}', 0),
       ('sender_7', 'dest_7', 1.7, 2.7, '{"message": "fake json message 7"}', 0),
       ('sender_8', 'dest_8', 1.8, 2.8, '{"message": "fake json message 8"}', 0)

