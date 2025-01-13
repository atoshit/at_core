CREATE TABLE players (
    license VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    discord VARCHAR(50),
    steam VARCHAR(50),
    ip VARCHAR(50),
    rank VARCHAR(20) DEFAULT 'user',
    vip BOOLEAN DEFAULT FALSE,
    whitelist BOOLEAN DEFAULT FALSE,
    banned BOOLEAN DEFAULT FALSE,
    ban_reason TEXT,
    created_at INT NOT NULL,
    last_connection INT NOT NULL
);

CREATE TABLE characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license VARCHAR(50) NOT NULL,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    dateofbirth VARCHAR(10) NOT NULL,
    gender VARCHAR(1) NOT NULL,
    job VARCHAR(50) DEFAULT 'unemployed',
    crew VARCHAR(50),
    position JSON,
    skin JSON,
    inventory JSON,
    health INT DEFAULT 200,
    armor INT DEFAULT 0,
    is_dead BOOLEAN DEFAULT FALSE,
    jail_time INT DEFAULT 0,
    bank_money INT DEFAULT 0,
    dirty_money INT DEFAULT 0,
    created_at INT NOT NULL,
    last_played INT NOT NULL,
    FOREIGN KEY (license) REFERENCES players(license)
);