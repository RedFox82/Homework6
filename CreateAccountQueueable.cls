public class CreateAccountQueueable implements Queueable{
    private Account account;
    private String name;

    public CreateAccountQueueable (String name) {
        this.account = new Account();
        this.name = name;
    }

    public void execute(QueueableContext context) {
        account.Name = name;
        try {
            insert account;
        }
        catch (DmlException e) {
            System.debug(e.getMessage());
        }
    }
}