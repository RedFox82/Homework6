public with sharing class MorningCaseCreatorScheduler implements Schedulable {

    public static String cronExp = '0 0 7 1/1 * ? *';
    public static String dt_fire;

    public MorningCaseCreatorScheduler() {
        Datetime now = Datetime.now();
        if (now.hour() < 7 ) {
            dt_fire = now.format('yyyy-MM-dd');
        } else {
            dt_fire = (now + 1).format('yyyy-MM-dd');
        }
    }

    public void execute(SchedulableContext schedulableContext) {
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger
                          WHERE Id = :schedulableContext.getTriggerId()];

        System.assertEquals(cronExp, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals(dt_fire + ' 07:00:00', String.valueOf(ct.NextFireTime));

        insert (new Case(Subject = 'Morning Case - ' + System.Date.today().format(), Origin = 'Web'));
    }
}
