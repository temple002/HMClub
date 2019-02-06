CREATE TABLE IF NOT EXISTS "T_Note" (
    "noteID" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "noteTitle" TEXT,
    "noteText" TEXT,
    "byClubName" TEXT,
    "isApplyNote" TEXT
);
