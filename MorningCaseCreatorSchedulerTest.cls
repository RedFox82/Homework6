@IsTest
private class MorningCaseCreatorSchedulerTest {

    @IsTest
    static void testExecuteMorningCaseCreator() {
        Integer crHours = MorningCaseCreatorScheduler.crHours;
        Integer crMins = MorningCaseCreatorScheduler.crMins;
        Integer crSecs = MorningCaseCreatorScheduler.crSecs;

        Test.startTest();
        Database.executeBatch(new AccountProcessor());
        String jobId = System.schedule('Morning Case', MorningCaseCreatorScheduler.cronExp,
                                        new MorningCaseCreatorScheduler());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger
                          WHERE id = :jobId];

        System.assertEquals(MorningCaseCreatorScheduler.cronExp, ct.CronExpression);

        Datetime now = Datetime.now();
        String dt_fire = '';
        if ((now.hour() < crHours) ||
                (now.hour() == crHours && (now.minute() < crMins ||
                        (now.minute() == crMins && now.second() < crSecs)))) {
            dt_fire = now.format('yyyy-MM-dd');
        } else {
            dt_fire = (now + 1).format('yyyy-MM-dd');
        }

        String tm_fire = '';
        if (crHours < 10) {
            tm_fire = tm_fire + '0' + String.valueOf(crHours) + ':';
        } else {
            tm_fire = tm_fire + String.valueOf(crHours) + ':';
        }
        if (crMins < 10) {
            tm_fire = tm_fire + '0' + String.valueOf(crMins) + ':';
        } else {
            tm_fire = tm_fire + String.valueOf(crMins) + ':';
        }
        if (crSecs < 10) {
            tm_fire = tm_fire + '0' + String.valueOf(crSecs);
        } else {
            tm_fire = tm_fire + String.valueOf(crSecs);
        }

        System.assertEquals(dt_fire + ' ' + tm_fire, String.valueOf(ct.NextFireTime));
        Test.stopTest();

        String sbj = 'Morning Case - ' + System.Date.today().format();
        System.assertEquals(1, [SELECT Id FROM Case WHERE Subject = :sbj].size());
    }

}