trigger PurchaseOrderTrigger on PurchaseOrder__c (before update, after update) {
    PurchaseOrderTriggerHandler.handle(Trigger.new, Trigger.old, Trigger.operationType);
}