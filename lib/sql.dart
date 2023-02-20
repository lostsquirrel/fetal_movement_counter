const appInit = """CREATE TABLE IF NOT EXISTS app
    (id INTEGER PRIMARY KEY AUTOINCREMENT, 
    key TEXT,
    value TEXT,
    created_at INTEGER)""";

const counterTable = "CREATE TABLE IF NOT EXISTS counter"
    "("
    "id INTEGER PRIMARY KEY AUTOINCREMENT, "
    "type INTEGER, "
    "created_at INTEGER "
    ")";
