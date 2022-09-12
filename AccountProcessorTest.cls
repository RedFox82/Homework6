@IsTest
private class AccountProcessorTest {

        @TestSetup
        static void setup() {
            List<Account> accounts = new List<Account>();
            for (Integer i = 0; i < 200; i++) {
                accounts.add(new Account(Name='Test Account ' + i));
            }
            insert accounts;
        }

        @IsTest static void executeAccountProcessor() {
            Test.startTest();
            Database.executeBatch(new AccountProcessor());
            Test.stopTest();

            System.assertEquals(200, [SELECT COUNT() FROM Account WHERE Name LIKE '%Batch Processed']);
        }
}