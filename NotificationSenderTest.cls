@IsTest
private class NotificationSenderTest {

    @IsTest
    static void testNotificationSenderService_Object_Positive() {
        //given
        NotificationSender sender = new ObjectNotificationSender();
        NotificationSenderService service = new NotificationSenderService();
        String message = 'Hello my friend';

        //when
        Test.startTest();
        service.initNotificationSender(sender, message);
        service.executeSend();
        Test.stopTest();

        //then
        List<Notification__c> notifications = [SELECT Id, Notification_Message__c FROM Notification__c];
        System.assertEquals(1, notifications.size());
        System.assertEquals(message, notifications[0].Notification_Message__c);
    }

    @IsTest
    static void testNotificationSenderService_Object_Negative() {
        //given
        NotificationSender sender = new ObjectNotificationSender();
        NotificationSenderService service = new NotificationSenderService();
        String message = null;

        //when
        Test.startTest();
        service.initNotificationSender(sender, message);
        service.executeSend();
        Test.stopTest();

        //then
        List<Notification__c> notifications = [SELECT Id, Notification_Message__c FROM Notification__c];
        System.assertEquals(0, notifications.size());
    }

    @IsTest
    static void testNotificationSenderService_Email_Positive() {
        //given
        NotificationSender sender = new EmailNotificationSender();
        NotificationSenderService service = new NotificationSenderService();
        String message = 'Hello my friend';
        Integer actual = 0;

        //when
        Test.startTest();
        service.initNotificationSender(sender, message);
        service.executeSend();
        actual = Limits.getEmailInvocations();
        Test.stopTest();

        //then
        System.assertEquals(1, actual);
    }

    @IsTest
    static void testNotificationSenderService_Email_Negative() {
        //given
        NotificationSender sender = new EmailNotificationSender();
        NotificationSenderService service = new NotificationSenderService();
        String message = null;
        Integer actual = 0;

        //when
        Test.startTest();
        service.initNotificationSender(sender, message);
        service.executeSend();
        actual = Limits.getEmailInvocations();
        Test.stopTest();

        //then
        System.assertEquals(0, actual);
    }

    @IsTest
    static void testNotificationSenderService_Bulk() {
        //given
        List<NotificationSender> senders = new List<NotificationSender>{
            new EmailNotificationSender(),
            new ObjectNotificationSender()
        };
        List<String> messages = new List<String>();
        for (Integer i = 0; i < 10; i++) {
            messages.add('Hello my friend ' + i);
        }
        messages.add(null);

        NotificationSenderService service = new NotificationSenderService();
        Integer actual = 0;

        //when
        Test.startTest();
        for(String message : messages) {
            for (NotificationSender sender : senders) {
                service.initNotificationSender(sender, message);
                service.executeSend();
            }
        }
        actual = Limits.getEmailInvocations();
        Test.stopTest();

        //then
        List<Notification__c> notifications = [SELECT Id, Notification_Message__c FROM Notification__c];
        System.assertEquals(10, notifications.size());
        System.assertEquals(10, actual);
    }


}