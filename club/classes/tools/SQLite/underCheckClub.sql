
CREATE TABLE IF NOT EXISTS "T_UnderCheckClub" (
    "underCheckClubID" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "underCheckClubName" TEXT,
    "applyStuNum" TEXT,
    "applyReason" TEXT,
    "applyState" TEXT
);
