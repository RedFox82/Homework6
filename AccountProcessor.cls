public class AccountProcessor implements Database.Batchable<SObject>, Database.Stateful {

    public Integer recordsProcessed = 0;

    public Database.QueryLocator start(Database.BatchableContext batchableContext) {
        final String query = 'SELECT Id, Name FROM Account';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext batchableContext, List<Account> scope) {
        List<Account> accsToUpd = new List<Account>();
        for (Account account : scope) {
            account.Name = account.Name + ' Batch Processed';
            accsToUpd.add(account);
            recordsProcessed++;
        }
        Database.update(accsToUpd);
    }

    public void finish(Database.BatchableContext batchableContext) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedById
                            FROM AsyncApexJob
                            WHERE Id = :batchableContext.getJobId()];
        System.debug(job);
        System.debug('Records are processed: ' + recordsProcessed);
    }

}