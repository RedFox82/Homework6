public class NotificationSenderService {

    public NotificationSender sender { get; private set; }
    public String message { get; private set; }

    public void initNotificationSender(NotificationSender sender, String message) {
        this.sender = sender;
        this.message = message;
    }

    public void executeSend() {
        this.sender.sendNotification(this.message);
    }
}