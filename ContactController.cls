public with sharing class ContactController {

    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContactsByAccountId(Id accountId) {
        return ContactSelector.selectContactsByAccountID(accountId);
    }

    @AuraEnabled
    public static void addContact(Id accountId, String lastName) {
        insert (new Contact(AccountId = accountId, LastName = lastName));
    }

}