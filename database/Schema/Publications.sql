CREATE TABLE Publications
(
    key       VARCHAR,
    sender    VARCHAR,
    pub_time  DECIMAL,
    pub_value DECIMAL,
    new_value BOOLEAN DEFAULT FALSE
)