@IsTest
private class CreateAccountQueueableTest {

    @IsTest
    static void testQueueable_Positive() {
        //given
        String name = 'Test Queueable Account';
        CreateAccountQueueable creating = new CreateAccountQueueable(name);

        //when
        Test.startTest();
        System.enqueueJob(creating);
        Test.stopTest();

        //then
        List<Account> accounts = [SELECT Id, Name FROM Account];
        System.assertEquals(1, accounts.size());
        System.assertEquals(name,accounts[0].Name);
    }

    @IsTest
    static void testQueueable_Negative() {
        //given
        String name = null;
        CreateAccountQueueable creating = new CreateAccountQueueable(name);

        //when
        Test.startTest();
        System.enqueueJob(creating);
        Test.stopTest();

        //then
        List<Account> accounts = [SELECT Id, Name FROM Account];
        System.assertEquals(0, accounts.size());
    }
}