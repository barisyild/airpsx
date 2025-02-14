package command;

import lib.LibKernel;
import type.TaskStatus;
import airpsx.Config;

class SetupDatabaseCommand extends Command {
    public function new() {
        super();
    }

    public function execute():Void {
        var db = sys.db.Sqlite.open(Config.DB_PATH);

        // Create stats table if not exists
        db.request("CREATE TABLE IF NOT EXISTS stats (id INTEGER PRIMARY KEY AUTOINCREMENT, socSensorTemperature INTEGER, temperature INTEGER, frequency REAL, titleID TEXT, timestamp DATE DEFAULT (datetime('now','localtime')));");

        // Create index for stats table
        db.request("CREATE INDEX IF NOT EXISTS idx_titleID ON stats(titleID);");
        db.request("CREATE INDEX IF NOT EXISTS idx_timestamp ON stats(timestamp);");

        // Keep last 1000 stats
        db.request("DELETE FROM stats WHERE id NOT IN (SELECT id FROM stats ORDER BY id DESC LIMIT 1000);");
        db.close();


        db = sys.db.Sqlite.open(Config.TASK_DB_PATH);

        // Create schedules table if not exists
        db.request('CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, script TEXT DEFAULT "", logs BOOL DEFAULT TRUE, frequency INT DEFAULT 3600, status INTEGER DEFAULT 0, lastRun DATE, enabled BOOL DEFAULT TRUE, success INTEGER DEFAULT 0, failed INTEGER DEFAULT 0, createdAt DATE DEFAULT (datetime(\'now\',\'localtime\')));');

        var runningSchedules = db.request('SELECT name FROM tasks WHERE status = ${TaskStatus.RUNNING} and enabled = 1');
        for(result in runningSchedules.results())
        {
            LibKernel.sendNotificationRequest('${result.name} task has been disabled due to unexpected status');
        }
        db.request('UPDATE tasks SET enabled = 0, status = ${TaskStatus.IDLE} WHERE status = ${TaskStatus.RUNNING}');
        db.close();
    }
}
