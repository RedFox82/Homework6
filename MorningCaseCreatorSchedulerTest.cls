@IsTest
private class MorningCaseCreatorSchedulerTest {

    @IsTest
    static void testExecuteMorningCaseCreator() {
        Test.startTest();
        Database.executeBatch(new AccountProcessor());
        String jobId = System.schedule('Morning Case', MorningCaseCreatorScheduler.cronExp,
                                        new MorningCaseCreatorScheduler());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger
                          WHERE id = :jobId];

        System.assertEquals(MorningCaseCreatorScheduler.cronExp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(MorningCaseCreatorScheduler.dt_fire + ' 19:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();

        String sbj = 'Morning Case - ' + System.Date.today().format();
        System.assertEquals(1, [SELECT Id FROM Case WHERE Subject = :sbj].size());
    }

}