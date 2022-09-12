public class AccountFuture {

    @Future
    public static void createAccountFuture(String accountName) {
        try {
            insert (new Account(Name=accountName));
        } catch (DmlException e){
            System.debug(e.getMessage());
        }
    }

}