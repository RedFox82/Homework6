public with sharing class MorningCaseCreatorScheduler implements Schedulable {

    public static Integer crHours = 7;
    public static Integer crMins = 0;
    public static Integer crSecs = 0;
    public static String cronExp = crSecs + ' ' + crMins + ' ' + crHours + ' 1/1 * ? *';

    public void execute(SchedulableContext schedulableContext) {

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger
                          WHERE Id = :schedulableContext.getTriggerId()];

        System.assertEquals(cronExp, ct.CronExpression);

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
        insert (new Case(Subject = 'Morning Case - ' + System.Date.today().format(), Origin = 'Web'));
    }
}