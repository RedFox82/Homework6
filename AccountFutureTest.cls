@IsTest
private class AccountFutureTest {

    @IsTest
    static void testCreateAccountFuture_Positive() {
        //given
        String name = 'Test Account';

        //when
        Test.startTest();
        AccountFuture.createAccountFuture(name);
        Test.stopTest();

        //then
        System.assertEquals(1, [SELECT COUNT() FROM Account]);
    }

    @IsTest
    static void testCreateAccountFuture_Negative() {
        //given
        String name = null;

        //when
        Test.startTest();
        AccountFuture.createAccountFuture(name);
        Test.stopTest();

        //then
        System.assertEquals(0, [SELECT COUNT() FROM Account]);
    }


}