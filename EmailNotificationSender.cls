public class EmailNotificationSender implements NotificationSender {

    public void sendNotification(String notificationMessage) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String>();
        toAddresses.add(UserInfo.getUserEmail());
        mail.toAddresses = toAddresses;
        mail.setSubject('Notification for ' + UserInfo.getName());
        mail.setPlainTextBody(notificationMessage);
        mail.setBccSender(true);
        try {
            if (mail.getPlainTextBody() != null) {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            } else {
                throw new EmailException('Messages must be not null!');
            }
        }
        catch (EmailException e) {
            System.debug(e.getMessage());
        }

    }
}