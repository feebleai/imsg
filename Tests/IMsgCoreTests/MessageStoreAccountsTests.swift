import SQLite
import Testing

@testable import IMsgCore

@Test
func localAccountsPreservesOpaqueAccountIDAndReportsChatService() throws {
  let db = try Connection(.inMemory)
  try MessageDatabaseFixture.createSchema(db)
  try db.run(
    """
    INSERT INTO chat(
      ROWID, chat_identifier, guid, service_name, account_id, account_login
    )
    VALUES
      (1, '+111', 'iMessage;-;+111', 'iMessage',
       '9E876D56-1542-4DB5-A437-A4052D038DB9', 'E:me@example.com'),
      (2, '+222', 'SMS;-;+222', 'SMS',
       '34CD7B53-36C2-48ED-8FC3-7226D8BC538A', 'P:+15555550123'),
      (3, '+333', 'iMessage;-;+333', 'iMessage',
       '9E876D56-1542-4DB5-A437-A4052D038DB9', 'E:me@example.com')
    """
  )
  let store = try MessageStore(connection: db, path: ":memory:")

  let accounts = try store.localAccounts()

  #expect(accounts.map(\.service) == ["iMessage", "SMS"])
  #expect(
    accounts.map(\.accountID) == [
      "9E876D56-1542-4DB5-A437-A4052D038DB9",
      "34CD7B53-36C2-48ED-8FC3-7226D8BC538A",
    ])
}
