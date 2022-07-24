trigger CaseTrigger on Case (before insert, after insert, before update, after update) {
    CaseTriggerHandler.handle(Trigger.new, Trigger.old, Trigger.operationType);
    }