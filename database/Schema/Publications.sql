CREATE TABLE Publications
(
    key       VARCHAR(64),
    sender    VARCHAR(128),
    pub_time  DECIMAL(32),
    pub_value DECIMAL(32),
    new       BOOLEAN DEFAULT FALSE
)