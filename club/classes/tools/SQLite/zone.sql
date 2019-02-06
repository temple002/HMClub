-- 创建数据表 --

CREATE TABLE IF NOT EXISTS "T_Zone" (
    "zoneID" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "zone" TEXT,
    "createTime" TEXT DEFAULT (datetime('now','localtime'))
);
