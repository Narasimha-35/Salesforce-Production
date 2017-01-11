@isTest
private class checkRecursiveTracker
{
    static testMethod void validate()
    {
        checkRecursive obj = new checkRecursive();
        checkRecursive.runOnce();
    }
}