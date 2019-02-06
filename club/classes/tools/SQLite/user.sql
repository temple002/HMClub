CREATE TABLE IF NOT EXISTS "T_User" (
    "userID" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "userName" TEXT,
    "userIcon" TEXT,
    "stuNum" TEXT,
    "psw" TEXT,
    "club" TEXT,
    "loveClubCount" INTEGER,
    "joinEventCount" INTEGER,
    "createClubCount" INTEGER,
    "createdClubs" TEXT,
    "joinedEvents" TEXT
);
