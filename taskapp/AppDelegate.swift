import UIKit
import UserNotifications
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // ユーザに通知の許可を求める
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        center.delegate = self
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            //(訳)新しいスキーマのバージョンを設定。以前使っていたバージョンよりも高くなければいけない。これまでバージョンの設定をしていなければ、初期のバージョンの値は0。
            schemaVersion: 1,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            //(訳)上記のものより低いスキーマバージョンでrealmを開くときに、自動的に呼び出されるようにブロックの設定をする。
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
        //(訳)まだマイグレーションを行っていないので、oldSchemaVersion == 0。
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
        //(訳)Realmは新しいプロパティと削除されたプロパティを自動で検知します。そして、自動でディスク上のスキーマを更新する。
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        //(訳)default Realmに対して、新しい設定オブジェクトを使うように、Realmに指示する。
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
}
