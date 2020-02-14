#!/usr/bin/env python3

import sys

extension = sys.argv[1]

db = "brownfield-land.db"
table = "site"
col = "point"

import sqlite3

conn = sqlite3.connect(db)

conn.enable_load_extension(True)
conn.load_extension(extension)

conn.execute("SELECT InitSpatialMetadata(1)")

conn.execute('SELECT AddGeometryColumn("%s", "%s", 4326, "POINT", 2);' % (table, col))

conn.execute(
    """
    UPDATE site SET
    point = GeomFromText('POINT('||"longitude"||' '||"latitude"||')',4326);
"""
)

conn.execute('SELECT CreateSpatialIndex("%s", "%s");' % (table, col))

conn.commit()
conn.close()
