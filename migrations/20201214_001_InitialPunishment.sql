CREATE TABLE IF NOT EXISTS punishments (
    id UUID PRIMARY KEY,
    userId BIGINT NOT NULL,
    guildId BIGINT NOT NULL,
    expires TIMESTAMP DEFAULT NULL,
    processed BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE IF NOT EXISTS guild_punishments (
    guildId BIGINT REFERENCES guilds,
    punishmentId UUID REFERENCES punishments
);